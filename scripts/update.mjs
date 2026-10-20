// Runs before every deploy (see package.json): brings this build up to the
// latest MarkRelay release, so redeploying the Worker is how a deployment
// updates (Mail: Admin → Settings → Updates POSTs the Worker's Cloudflare
// deploy hook, which starts such a build).
//
// Nothing is committed. This repository keeps the wrangler.jsonc Cloudflare
// wrote on first deploy (resource names and IDs), and each build starts from
// it again:
//
// - Downloads the release (RELEASE_REF, default main) from the public
//   release repository.
// - Every top-level file and folder of the release replaces the one here,
//   except .git, .github and wrangler.jsonc.
// - wrangler.jsonc becomes the release's config with this deployment's Worker
//   name, resource names and resource IDs put back, matched by binding name;
//   resources new in the release are kept as the release defines them.
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const RELEASE_REPO = "LoadShine/markrelay-mail-app-installer";
const ref = process.env.RELEASE_REF || "main";
const hereDir = process.cwd();

const releaseRoot = fs.mkdtempSync(path.join(os.tmpdir(), "markrelay-release-"));
const archive = path.join(releaseRoot, "release.tar.gz");
const response = await fetch(`https://codeload.github.com/${RELEASE_REPO}/tar.gz/${ref}`);
if (!response.ok) {
  console.error(`Could not download MarkRelay release ${ref} from ${RELEASE_REPO}: HTTP ${response.status}`);
  process.exit(1);
}
fs.writeFileSync(archive, Buffer.from(await response.arrayBuffer()));
execFileSync("tar", ["-xzf", archive, "-C", releaseRoot]);
const releaseDir = path.join(
  releaseRoot,
  fs.readdirSync(releaseRoot).find((entry) => entry !== "release.tar.gz"),
);

/** JSON with comments and trailing commas, as Wrangler accepts. */
function parseJsonc(text) {
  let out = "";
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (c === '"') {
      let j = i + 1;
      while (j < text.length && text[j] !== '"') j += text[j] === "\\" ? 2 : 1;
      out += text.slice(i, j + 1);
      i = j;
    } else if (c === "/" && text[i + 1] === "/") {
      while (i < text.length && text[i] !== "\n") i++;
      out += "\n";
    } else if (c === "/" && text[i + 1] === "*") {
      i = text.indexOf("*/", i + 2) + 1;
    } else {
      out += c;
    }
  }
  return JSON.parse(out.replace(/,(\s*[}\]])/g, "$1"));
}

const readJsonc = (file) => parseJsonc(fs.readFileSync(file, "utf-8"));
const current = readJsonc(path.join(hereDir, "wrangler.jsonc"));
const release = readJsonc(path.join(releaseDir, "wrangler.jsonc"));

/** Copies `keys` from this deployment's entry with the same binding. */
function keepByBinding(releaseList, currentList, keys) {
  return (releaseList ?? []).map((entry) => {
    const mine = (currentList ?? []).find((c) => c.binding === entry.binding);
    if (!mine) return entry;
    const kept = Object.fromEntries(keys.filter((k) => k in mine).map((k) => [k, mine[k]]));
    return { ...entry, ...kept };
  });
}

const merged = { ...release, name: current.name };
// Lets Mail name this Worker when it points to the Cloudflare dashboard.
merged.vars = { ...release.vars, WORKER_NAME: current.name };
merged.d1_databases = keepByBinding(release.d1_databases, current.d1_databases, [
  "database_name", "database_id", "preview_database_id",
]);
merged.r2_buckets = keepByBinding(release.r2_buckets, current.r2_buckets, [
  "bucket_name", "preview_bucket_name", "jurisdiction",
]);
merged.kv_namespaces = keepByBinding(release.kv_namespaces, current.kv_namespaces, ["id", "preview_id"]);
if (release.queues) {
  const producers = keepByBinding(release.queues.producers, current.queues?.producers, ["queue"]);
  // Queue names this deployment changed: a producer's queue by its binding;
  // a consumer's queue and dead-letter queue by position, since some queues
  // (Email Sending events) have no producer binding. Cloudflare edits the
  // config in place, so a release may add queues only after existing ones.
  const renamed = new Map(
    (release.queues.producers ?? []).map((p, i) => [p.queue, producers[i].queue]),
  );
  (release.queues.consumers ?? []).forEach((c, i) => {
    const mine = current.queues?.consumers?.[i];
    if (!mine) return;
    if (!renamed.has(c.queue)) renamed.set(c.queue, mine.queue);
    if (c.dead_letter_queue && mine.dead_letter_queue && !renamed.has(c.dead_letter_queue)) {
      renamed.set(c.dead_letter_queue, mine.dead_letter_queue);
    }
  });
  const consumers = (release.queues.consumers ?? []).map((c) => ({
    ...c,
    queue: renamed.get(c.queue) ?? c.queue,
    ...(c.dead_letter_queue
      ? { dead_letter_queue: renamed.get(c.dead_letter_queue) ?? c.dead_letter_queue }
      : {}),
  }));
  merged.queues = { ...release.queues, producers, consumers };
}
if (current.routes) merged.routes = current.routes;
for (const key of ["d1_databases", "r2_buckets", "kv_namespaces"]) {
  if (merged[key].length === 0) delete merged[key];
}

const wranglerVersion = (dir) => {
  try {
    return JSON.parse(fs.readFileSync(path.join(dir, "node_modules/wrangler/package.json"), "utf-8")).version;
  } catch {
    return null;
  }
};
const installedWrangler = wranglerVersion(hereDir);

for (const entry of fs.readdirSync(releaseDir)) {
  if ([".git", ".github", "wrangler.jsonc"].includes(entry)) continue;
  fs.rmSync(path.join(hereDir, entry), { recursive: true, force: true });
  fs.cpSync(path.join(releaseDir, entry), path.join(hereDir, entry), { recursive: true });
}
fs.writeFileSync(
  path.join(hereDir, "wrangler.jsonc"),
  "// MarkRelay release config, with this deployment's names and resource IDs kept.\n"
    + `${JSON.stringify(merged, null, "\t")}\n`,
);

// The release may pin another Wrangler than the one installed for this build.
const releaseWrangler = JSON.parse(
  fs.readFileSync(path.join(hereDir, "package.json"), "utf-8"),
).devDependencies?.wrangler;
if (releaseWrangler && releaseWrangler !== installedWrangler) {
  console.log(`Installing wrangler ${releaseWrangler} (was ${installedWrangler ?? "none"})`);
  execFileSync("npm", ["install", "--no-audit", "--no-fund"], { cwd: hereDir, stdio: "inherit" });
}

const version = JSON.parse(fs.readFileSync(path.join(hereDir, "package.json"), "utf-8")).version;
console.log(`Updated this build to MarkRelay ${version} (release ${ref}).`);
