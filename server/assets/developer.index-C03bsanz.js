import{a as e}from"./rolldown-runtime-B0Z9INg1.js";import{t}from"./react-DVplv7_D.js";import{n,t as r}from"./createLucideIcon-Dt4AP-mx.js";import{t as i}from"./jsx-runtime-B74pBk57.js";import{i as a,n as o,r as s,t as c}from"./tabs-Bv3HcRyw.js";import{t as l}from"./check-D7NVYkCm.js";import{t as u}from"./app-page-header-BsVyZd6T.js";import{t as d}from"./copy-CP8pRtbC.js";import{t as f}from"./key-round-CaQER539.js";import{t as p}from"./webhook-CGySvVCP.js";import{t as m}from"./header-button-CU-sFwta.js";var h=r(`arrow-up-right`,[[`path`,{d:`M7 7h10v10`,key:`1tivn9`}],[`path`,{d:`M7 17 17 7`,key:`1vkiza`}]]),g=e(t()),_=i(),v=[{label:`API reference`,description:`Explore endpoints and request schemas interactively.`,href:`/openapi/docs`},{label:`OpenAPI schema`,description:`Use the machine-readable JSON specification.`,href:`/openapi/openapi.json`},{label:`Agent skill`,description:`Teach AI agents how to use the MarkRelay API.`,href:`/skills/SKILL.md`},{label:`llms.txt`,description:`Give LLMs concise API and integration context.`,href:`/llms.txt`}];function y({code:e}){let[t,n]=(0,g.useState)(!1);return(0,_.jsxs)(`div`,{className:`relative`,children:[(0,_.jsx)(`pre`,{className:`max-h-[500px] overflow-auto rounded-xl bg-foreground px-4 py-3.5 pr-20 text-xs leading-relaxed text-background`,children:(0,_.jsx)(`code`,{children:e})}),(0,_.jsxs)(`button`,{type:`button`,onClick:async()=>{try{await navigator.clipboard.writeText(e),n(!0),setTimeout(()=>n(!1),1500)}catch{}},className:`absolute right-2.5 top-2.5 inline-flex cursor-pointer items-center gap-1 rounded-md bg-white/10 px-2 py-1 text-[11px] font-medium text-background transition-colors hover:bg-white/20`,children:[t?(0,_.jsx)(l,{className:`size-3`}):(0,_.jsx)(d,{className:`size-3`}),t?`Copied`:`Copy`]})]})}function b(){let[e,t]=(0,g.useState)(`https://your-markrelay.example.com`),[r,i]=(0,g.useState)(`curl`);(0,g.useEffect)(()=>t(window.location.origin),[]);let l=`${e}/openapi/v1`,d=`MARKRELAY_API_URL=${l}
MARKRELAY_API_KEY=sk-...`,b=`const MARKRELAY_API_URL = "${l}";
const MARKRELAY_API_KEY = process.env.MARKRELAY_API_KEY;

const response = await fetch(\`\${MARKRELAY_API_URL}/emails/send\`, {
  method: "POST",
  headers: {
    Authorization: \`Bearer \${MARKRELAY_API_KEY}\`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    from: "sender@example.com",
    to: "to@example.com",
    subject: "Hello",
    text: "Hello!",
  }),
});
const result = await response.json();
console.log(result);`,x=`import { readFile } from "node:fs/promises";

const MARKRELAY_API_URL = "${l}";
const MARKRELAY_API_KEY = process.env.MARKRELAY_API_KEY;
const headers = { Authorization: \`Bearer \${MARKRELAY_API_KEY}\` };

// Upload the attachment
const form = new FormData();
form.append("file", new Blob([await readFile("invoice.pdf")]), "invoice.pdf");
const response = await fetch(\`\${MARKRELAY_API_URL}/attachments\`, { method: "POST", headers, body: form });
const attachmentId = (await response.json()).id;

// Send the email
await fetch(\`\${MARKRELAY_API_URL}/emails/send\`, {
  method: "POST",
  headers: { ...headers, "Content-Type": "application/json" },
  body: JSON.stringify({
    from: "sender@example.com",
    to: "to@example.com",
    subject: "Invoice",
    text: "Attached.",
    attachmentIds: [attachmentId],
  }),
});`,S=`const MARKRELAY_API_URL = "${l}";
const MARKRELAY_API_KEY = process.env.MARKRELAY_API_KEY;

const response = await fetch(
  \`\${MARKRELAY_API_URL}/emails?mailbox=support@example.com&folder=inbox&limit=25\`,
  { headers: { Authorization: \`Bearer \${MARKRELAY_API_KEY}\` } },
);
const emails = await response.json();
console.log(emails);`,C=`import { writeFile } from "node:fs/promises";

const MARKRELAY_API_URL = "${l}";
const MARKRELAY_API_KEY = process.env.MARKRELAY_API_KEY;

const response = await fetch(
  \`\${MARKRELAY_API_URL}/attachments/<attachment-id>\`,
  { headers: { Authorization: \`Bearer \${MARKRELAY_API_KEY}\` } },
);
const file = Buffer.from(await response.arrayBuffer());
await writeFile("attachment.bin", file);`,w=`import os, requests

MARKRELAY_API_URL = "${l}"
MARKRELAY_API_KEY = os.environ["MARKRELAY_API_KEY"]

response = requests.post(
    f"{MARKRELAY_API_URL}/emails/send",
    headers={"Authorization": f"Bearer {MARKRELAY_API_KEY}"},
    json={
        "from": "sender@example.com",
        "to": "to@example.com",
        "subject": "Hello",
        "text": "Hello!",
    },
)
result = response.json()
print(result)`,T=`import os, requests

MARKRELAY_API_URL = "${l}"
MARKRELAY_API_KEY = os.environ["MARKRELAY_API_KEY"]
headers = {"Authorization": f"Bearer {MARKRELAY_API_KEY}"}

# Upload the attachment
with open("invoice.pdf", "rb") as file:
    response = requests.post(f"{MARKRELAY_API_URL}/attachments", headers=headers, files={"file": file})
    attachment_id = response.json()["id"]

# Send the email
requests.post(f"{MARKRELAY_API_URL}/emails/send", headers=headers, json={
    "from": "sender@example.com",
    "to": "to@example.com",
    "subject": "Invoice",
    "text": "Attached.",
    "attachmentIds": [attachment_id],
})`,E=`import os, requests

MARKRELAY_API_URL = "${l}"
MARKRELAY_API_KEY = os.environ["MARKRELAY_API_KEY"]

response = requests.get(
    f"{MARKRELAY_API_URL}/emails",
    headers={"Authorization": f"Bearer {MARKRELAY_API_KEY}"},
    params={"mailbox": "support@example.com", "folder": "inbox", "limit": 25},
)
emails = response.json()
print(emails)`,D=`import os, requests

MARKRELAY_API_URL = "${l}"
MARKRELAY_API_KEY = os.environ["MARKRELAY_API_KEY"]

response = requests.get(
    f"{MARKRELAY_API_URL}/attachments/<attachment-id>",
    headers={"Authorization": f"Bearer {MARKRELAY_API_KEY}"},
)
open("attachment.bin", "wb").write(response.content)`,O={send:{curl:`curl "$MARKRELAY_API_URL/emails/send" \\
  -H "Authorization: Bearer $MARKRELAY_API_KEY" \\
  -H "Content-Type: application/json" \\
  -d '{"from":"sender@example.com","to":"to@example.com","subject":"Hello","text":"Hello!"}'`,node:b,python:w},attachment:{curl:`curl "$MARKRELAY_API_URL/attachments" \\
  -H "Authorization: Bearer $MARKRELAY_API_KEY" \\
  -F "file=@./invoice.pdf"

curl "$MARKRELAY_API_URL/emails/send" \\
  -H "Authorization: Bearer $MARKRELAY_API_KEY" \\
  -H "Content-Type: application/json" \\
  -d '{"from":"sender@example.com","to":"to@example.com","subject":"Invoice","text":"Attached.","attachmentIds":["<attachment-id>"]}'`,node:x,python:T},inbox:{curl:`curl "$MARKRELAY_API_URL/emails?mailbox=support@example.com&folder=inbox&limit=25" \\
  -H "Authorization: Bearer $MARKRELAY_API_KEY"`,node:S,python:E},download:{curl:`curl -L "$MARKRELAY_API_URL/attachments/<attachment-id>" \\
  -H "Authorization: Bearer $MARKRELAY_API_KEY" \\
  --output attachment.bin`,node:C,python:D}};return(0,_.jsxs)(`div`,{className:`flex h-full flex-col overflow-hidden bg-background`,children:[(0,_.jsx)(u,{title:`Developer`,actions:(0,_.jsxs)(_.Fragment,{children:[(0,_.jsx)(m,{asChild:!0,children:(0,_.jsxs)(n,{to:`/admin/apikeys`,children:[(0,_.jsx)(f,{}),`API keys`]})}),(0,_.jsx)(m,{tone:`primary`,asChild:!0,children:(0,_.jsxs)(n,{to:`/admin/webhooks`,children:[(0,_.jsx)(p,{}),`Webhooks`]})})]})}),(0,_.jsx)(`main`,{className:`flex-1 overflow-y-auto`,children:(0,_.jsxs)(`div`,{className:`mx-auto w-full max-w-5xl space-y-6 px-6 py-6`,children:[(0,_.jsxs)(`section`,{children:[(0,_.jsx)(`h1`,{className:`text-lg font-semibold text-foreground`,children:`Connect to the API`}),(0,_.jsx)(`p`,{className:`mt-1 text-sm text-muted-foreground`,children:`Set these two environment variables in your application or agent.`}),(0,_.jsx)(`div`,{className:`mt-3`,children:(0,_.jsx)(y,{code:d})})]}),(0,_.jsxs)(`section`,{children:[(0,_.jsxs)(`div`,{children:[(0,_.jsx)(`h2`,{className:`text-sm font-semibold text-foreground`,children:`Examples`}),(0,_.jsx)(`p`,{className:`mt-0.5 text-xs text-muted-foreground`,children:`Replace example mailbox addresses and IDs with values available to your API key.`})]}),(0,_.jsxs)(c,{defaultValue:`send`,className:`mt-3 gap-3`,children:[(0,_.jsxs)(`div`,{className:`flex items-center justify-between gap-3`,children:[(0,_.jsx)(`div`,{className:`min-w-0 overflow-x-auto`,children:(0,_.jsxs)(s,{className:`h-9 shrink-0`,children:[(0,_.jsx)(a,{value:`send`,className:`flex-none px-3`,children:`Send`}),(0,_.jsx)(a,{value:`attachment`,className:`flex-none px-3`,children:`Send with attachment`}),(0,_.jsx)(a,{value:`inbox`,className:`flex-none px-3`,children:`Check inbox`}),(0,_.jsx)(a,{value:`download`,className:`flex-none px-3`,children:`Download attachment`})]})}),(0,_.jsx)(`div`,{className:`flex shrink-0 items-center rounded-lg bg-muted p-0.5`,children:[[`curl`,`cURL`],[`node`,`Node.js`],[`python`,`Python`]].map(([e,t])=>(0,_.jsx)(`button`,{type:`button`,onClick:()=>i(e),className:`cursor-pointer rounded-md px-2.5 py-1 text-xs font-medium transition-colors ${r===e?`bg-background text-foreground shadow-sm`:`text-muted-foreground hover:text-foreground`}`,children:t},e))})]}),(0,_.jsx)(o,{value:`send`,children:(0,_.jsx)(y,{code:O.send[r]})}),(0,_.jsx)(o,{value:`attachment`,children:(0,_.jsx)(y,{code:O.attachment[r]})}),(0,_.jsx)(o,{value:`inbox`,children:(0,_.jsx)(y,{code:O.inbox[r]})}),(0,_.jsx)(o,{value:`download`,children:(0,_.jsx)(y,{code:O.download[r]})})]})]}),(0,_.jsxs)(`section`,{className:`border-t border-border pt-5`,children:[(0,_.jsx)(`h2`,{className:`text-sm font-semibold text-foreground`,children:`Documentation`}),(0,_.jsx)(`div`,{className:`mt-3 grid gap-x-8 gap-y-1 sm:grid-cols-2`,children:v.map(e=>(0,_.jsxs)(`a`,{href:e.href,target:`_blank`,rel:`noreferrer`,className:`group flex items-start justify-between gap-3 rounded-lg px-3 py-2.5 transition-colors hover:bg-muted`,children:[(0,_.jsxs)(`span`,{className:`min-w-0`,children:[(0,_.jsx)(`span`,{className:`block text-xs font-medium text-foreground group-hover:text-brand-600`,children:e.label}),(0,_.jsx)(`span`,{className:`mt-0.5 block text-xs text-muted-foreground`,children:e.description})]}),(0,_.jsx)(h,{className:`mt-0.5 size-3.5 shrink-0 text-muted-foreground transition-colors group-hover:text-brand-600`})]},e.href))})]})]})})]})}export{b as component};