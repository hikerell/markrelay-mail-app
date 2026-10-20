CREATE TABLE `account` (
	`id` text PRIMARY KEY NOT NULL,
	`account_id` text NOT NULL,
	`provider_id` text NOT NULL,
	`user_id` text NOT NULL,
	`access_token` text,
	`refresh_token` text,
	`id_token` text,
	`access_token_expires_at` integer,
	`refresh_token_expires_at` integer,
	`scope` text,
	`password` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `account_userId_idx` ON `account` (`user_id`,`provider_id`);--> statement-breakpoint
CREATE TABLE `session` (
	`id` text PRIMARY KEY NOT NULL,
	`expires_at` integer NOT NULL,
	`token` text NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer NOT NULL,
	`ip_address` text,
	`user_agent` text,
	`user_id` text NOT NULL,
	`impersonated_by` text,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `session_token_unique` ON `session` (`token`);--> statement-breakpoint
CREATE INDEX `session_userId_idx` ON `session` (`user_id`);--> statement-breakpoint
CREATE TABLE `user` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`email_verified` integer DEFAULT false NOT NULL,
	`image` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`role` text DEFAULT 'user' NOT NULL,
	`banned` integer DEFAULT false,
	`ban_reason` text,
	`ban_expires` integer,
	`stripe_customer_id` text
);
--> statement-breakpoint
CREATE UNIQUE INDEX `user_email_unique` ON `user` (`email`);--> statement-breakpoint
CREATE INDEX `user_createdAt_idx` ON `user` (`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `user_name_idx` ON `user` (`name`,`id`);--> statement-breakpoint
CREATE INDEX `user_banned_createdAt_idx` ON `user` (`banned`,`created_at`,`id`);--> statement-breakpoint
CREATE TABLE `verification` (
	`id` text PRIMARY KEY NOT NULL,
	`identifier` text NOT NULL,
	`value` text NOT NULL,
	`expires_at` integer NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `verification_identifier_idx` ON `verification` (`identifier`);--> statement-breakpoint
CREATE TABLE `apikey` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`owner_id` text NOT NULL,
	`domain_id` text,
	`token` text NOT NULL,
	`scope_addresses` text,
	`status` text DEFAULT 'active' NOT NULL,
	`last_used_at` integer,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`owner_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`domain_id`) REFERENCES `domain`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `apikey_token_idx` ON `apikey` (`token`);--> statement-breakpoint
CREATE INDEX `apikey_domain_idx` ON `apikey` (`domain_id`);--> statement-breakpoint
CREATE INDEX `apikey_owner_idx` ON `apikey` (`owner_id`);--> statement-breakpoint
CREATE INDEX `apikey_created_idx` ON `apikey` (`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `apikey_name_idx` ON `apikey` (`name`,`id`);--> statement-breakpoint
CREATE INDEX `apikey_owner_created_idx` ON `apikey` (`owner_id`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `apikey_status_created_idx` ON `apikey` (`status`,`created_at`,`id`);--> statement-breakpoint
CREATE TABLE `broadcast` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`sender_mailbox_id` text,
	`sender_name` text,
	`sender_address` text,
	`reply_to_name` text,
	`reply_to_address` text,
	`subject` text DEFAULT '' NOT NULL,
	`recipients_count` integer DEFAULT 0 NOT NULL,
	`recipients_storage_object_id` integer,
	`message_storage_object_id` integer,
	`content_version` integer DEFAULT 0 NOT NULL,
	`recipients_etag` text,
	`message_etag` text,
	`recipients_size` integer DEFAULT 0 NOT NULL,
	`recipient_columns` text DEFAULT '["email"]' NOT NULL,
	`recipient_chunk_offsets` text DEFAULT '[]' NOT NULL,
	`prepare_chunk_index` integer DEFAULT 0 NOT NULL,
	`send_byte_offset` integer DEFAULT 0 NOT NULL,
	`status` text DEFAULT 'draft' NOT NULL,
	`operation_token` text,
	`operation_started_at` integer,
	`schedule_mode` text DEFAULT 'immediate' NOT NULL,
	`schedule_time` integer,
	`open_tracking_enabled` integer DEFAULT true NOT NULL,
	`click_tracking_enabled` integer DEFAULT true NOT NULL,
	`total_count` integer DEFAULT 0 NOT NULL,
	`success_count` integer DEFAULT 0 NOT NULL,
	`failure_count` integer DEFAULT 0 NOT NULL,
	`skipped_count` integer DEFAULT 0 NOT NULL,
	`unknown_count` integer DEFAULT 0 NOT NULL,
	`error` text,
	`created_by` text,
	`started_at` integer,
	`completed_at` integer,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`sender_mailbox_id`) REFERENCES `mailbox`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`recipients_storage_object_id`) REFERENCES `storage_object`(`id`) ON UPDATE no action ON DELETE restrict,
	FOREIGN KEY (`message_storage_object_id`) REFERENCES `storage_object`(`id`) ON UPDATE no action ON DELETE restrict,
	FOREIGN KEY (`created_by`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `broadcast_recipients_storage_object_idx` ON `broadcast` (`recipients_storage_object_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `broadcast_message_storage_object_idx` ON `broadcast` (`message_storage_object_id`);--> statement-breakpoint
CREATE INDEX `broadcast_sender_idx` ON `broadcast` (`sender_mailbox_id`);--> statement-breakpoint
CREATE INDEX `broadcast_status_idx` ON `broadcast` (`status`);--> statement-breakpoint
CREATE INDEX `broadcast_schedule_time_idx` ON `broadcast` (`schedule_time`);--> statement-breakpoint
CREATE INDEX `broadcast_created_by_idx` ON `broadcast` (`created_by`);--> statement-breakpoint
CREATE INDEX `broadcast_created_idx` ON `broadcast` (`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `broadcast_name_idx` ON `broadcast` (`name`,`id`);--> statement-breakpoint
CREATE INDEX `broadcast_creator_created_idx` ON `broadcast` (`created_by`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `broadcast_status_created_idx` ON `broadcast` (`status`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `broadcast_operation_idx` ON `broadcast` (`status`,`updated_at`);--> statement-breakpoint
CREATE TABLE `broadcast_delivery` (
	`id` text PRIMARY KEY NOT NULL,
	`broadcast_id` text,
	`message_id` text,
	`recipient_email` text NOT NULL,
	`recipient_data` text DEFAULT '{}' NOT NULL,
	`execution_status` text DEFAULT 'pending' NOT NULL,
	`attempt_count` integer DEFAULT 0 NOT NULL,
	`operation_token` text,
	`lease_token` text,
	`lease_expires_at` integer,
	`next_attempt_at` integer,
	`provider_error_code` text,
	`delivery_status` text,
	`delivery_status_at` integer,
	`recipient_status` text DEFAULT 'none' NOT NULL,
	`sent_at` integer,
	`delivered_at` integer,
	`bounced_at` integer,
	`complained_at` integer,
	`opened_at` integer,
	`clicked_at` integer,
	`replied_at` integer,
	`open_count` integer DEFAULT 0 NOT NULL,
	`click_count` integer DEFAULT 0 NOT NULL,
	`error` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`broadcast_id`) REFERENCES `broadcast`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `broadcast_delivery_broadcast_idx` ON `broadcast_delivery` (`broadcast_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `broadcast_delivery_broadcast_recipient_idx` ON `broadcast_delivery` (`broadcast_id`,`recipient_email`);--> statement-breakpoint
CREATE INDEX `broadcast_delivery_claim_idx` ON `broadcast_delivery` (`broadcast_id`,`operation_token`,`execution_status`,`next_attempt_at`);--> statement-breakpoint
CREATE INDEX `broadcast_delivery_message_recipient_idx` ON `broadcast_delivery` (`message_id`,`recipient_email`);--> statement-breakpoint
CREATE INDEX `broadcast_delivery_execution_status_idx` ON `broadcast_delivery` (`execution_status`);--> statement-breakpoint
CREATE INDEX `broadcast_delivery_broadcast_delivery_status_idx` ON `broadcast_delivery` (`broadcast_id`,`delivery_status`);--> statement-breakpoint
CREATE INDEX `broadcast_delivery_recipient_status_idx` ON `broadcast_delivery` (`recipient_status`);--> statement-breakpoint
CREATE INDEX `broadcast_delivery_recipient_email_idx` ON `broadcast_delivery` (`recipient_email`);--> statement-breakpoint
CREATE TABLE `domain` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`created_by` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`created_by`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `domain_name_idx` ON `domain` (`name`);--> statement-breakpoint
CREATE INDEX `domain_created_idx` ON `domain` (`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `domain_status_created_idx` ON `domain` (`status`,`created_at`,`id`);--> statement-breakpoint
CREATE TABLE `mail_log` (
	`id` text PRIMARY KEY NOT NULL,
	`mail_address` text DEFAULT '' NOT NULL,
	`operation_type` text NOT NULL,
	`log_type` text NOT NULL,
	`message` text NOT NULL,
	`detail` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `mail_log_mail_address_idx` ON `mail_log` (`mail_address`);--> statement-breakpoint
CREATE INDEX `mail_log_operation_type_idx` ON `mail_log` (`operation_type`);--> statement-breakpoint
CREATE INDEX `mail_log_log_type_idx` ON `mail_log` (`log_type`);--> statement-breakpoint
CREATE INDEX `mail_log_created_at_idx` ON `mail_log` (`created_at`);--> statement-breakpoint
CREATE TABLE `mail_suppression` (
	`id` text PRIMARY KEY NOT NULL,
	`email` text NOT NULL,
	`sender_address` text DEFAULT '' NOT NULL,
	`reason` text NOT NULL,
	`broadcast_id` text,
	`detail` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `mail_suppression_email_sender_idx` ON `mail_suppression` (`email`,`sender_address`);--> statement-breakpoint
CREATE TABLE `mailbox` (
	`id` text PRIMARY KEY NOT NULL,
	`address` text NOT NULL,
	`local_part` text NOT NULL,
	`domain_id` text NOT NULL,
	`display_name` text NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`created_by` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`domain_id`) REFERENCES `domain`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`created_by`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `mailbox_address_idx` ON `mailbox` (`address`);--> statement-breakpoint
CREATE INDEX `mailbox_domain_idx` ON `mailbox` (`domain_id`);--> statement-breakpoint
CREATE INDEX `mailbox_created_idx` ON `mailbox` (`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `mailbox_domain_created_idx` ON `mailbox` (`domain_id`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `mailbox_status_created_idx` ON `mailbox` (`status`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `mailbox_domain_status_address_idx` ON `mailbox` (`domain_id`,`status`,`address`,`id`);--> statement-breakpoint
CREATE TABLE `mailbox_access` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`mailbox_id` text NOT NULL,
	`granted_by` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`mailbox_id`) REFERENCES `mailbox`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`granted_by`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `mailbox_access_user_mailbox_idx` ON `mailbox_access` (`user_id`,`mailbox_id`);--> statement-breakpoint
CREATE INDEX `mailbox_access_mailbox_idx` ON `mailbox_access` (`mailbox_id`);--> statement-breakpoint
CREATE TABLE `mailbox_activity_identity` (
	`mailbox_id` text PRIMARY KEY NOT NULL,
	`mailbox_address` text NOT NULL,
	`domain_id` text NOT NULL,
	`domain_name` text NOT NULL,
	`deleted_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `mailbox_activity_identity_domain_idx` ON `mailbox_activity_identity` (`domain_id`,`mailbox_id`);--> statement-breakpoint
CREATE TABLE `mailbox_attachment` (
	`id` text PRIMARY KEY NOT NULL,
	`mailbox_email_id` text,
	`storage_object_id` integer NOT NULL,
	`file_name` text NOT NULL,
	`content_type` text DEFAULT 'application/octet-stream' NOT NULL,
	`content_id` text,
	`disposition` text DEFAULT 'attachment' NOT NULL,
	`sort_order` integer DEFAULT 0 NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`mailbox_email_id`) REFERENCES `mailbox_email`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`storage_object_id`) REFERENCES `storage_object`(`id`) ON UPDATE no action ON DELETE restrict
);
--> statement-breakpoint
CREATE INDEX `mailbox_attachment_email_order_idx` ON `mailbox_attachment` (`mailbox_email_id`,`sort_order`,`id`);--> statement-breakpoint
CREATE INDEX `mailbox_attachment_storage_object_idx` ON `mailbox_attachment` (`storage_object_id`);--> statement-breakpoint
CREATE TABLE `mailbox_daily_activity` (
	`mailbox_id` text NOT NULL,
	`stat_date` text NOT NULL,
	`received_count` integer DEFAULT 0 NOT NULL,
	`sent_count` integer DEFAULT 0 NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	PRIMARY KEY(`mailbox_id`, `stat_date`),
	FOREIGN KEY (`mailbox_id`) REFERENCES `mailbox_activity_identity`(`mailbox_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `mailbox_daily_activity_date_idx` ON `mailbox_daily_activity` (`stat_date`,`mailbox_id`);--> statement-breakpoint
CREATE TABLE `mailbox_email` (
	`id` text PRIMARY KEY NOT NULL,
	`mailbox_id` text NOT NULL,
	`folder` text DEFAULT 'inbox' NOT NULL,
	`direction` text DEFAULT 'incoming' NOT NULL,
	`source` text DEFAULT 'web' NOT NULL,
	`subject` text DEFAULT '' NOT NULL,
	`snippet` text DEFAULT '' NOT NULL,
	`from_address` text DEFAULT '' NOT NULL,
	`from_name` text,
	`to_addresses` text DEFAULT '[]' NOT NULL,
	`storage_object_id` integer NOT NULL,
	`message_id` text,
	`thread_id` text NOT NULL,
	`is_read` integer DEFAULT false NOT NULL,
	`is_starred` integer DEFAULT false NOT NULL,
	`received_at` integer,
	`sent_at` integer,
	`attachment_count` integer DEFAULT 0 NOT NULL,
	`size` integer DEFAULT 0 NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`mailbox_id`) REFERENCES `mailbox`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`storage_object_id`) REFERENCES `storage_object`(`id`) ON UPDATE no action ON DELETE restrict
);
--> statement-breakpoint
CREATE INDEX `mailbox_email_mailbox_idx` ON `mailbox_email` (`mailbox_id`);--> statement-breakpoint
CREATE INDEX `mailbox_email_mailbox_folder_idx` ON `mailbox_email` (`mailbox_id`,`folder`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `mailbox_email_folder_created_idx` ON `mailbox_email` (`folder`,`created_at`,`id`,`mailbox_id`);--> statement-breakpoint
CREATE INDEX `mailbox_email_starred_created_idx` ON `mailbox_email` (`is_starred`,`created_at`,`id`,`mailbox_id`);--> statement-breakpoint
CREATE INDEX `mailbox_email_unread_folder_idx` ON `mailbox_email` (`mailbox_id`,`is_read`,`folder`);--> statement-breakpoint
CREATE INDEX `mailbox_email_thread_idx` ON `mailbox_email` (`mailbox_id`,`thread_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `mailbox_email_message_idx` ON `mailbox_email` (`mailbox_id`,`message_id`) WHERE direction = 'incoming';--> statement-breakpoint
CREATE UNIQUE INDEX `mailbox_email_storage_object_idx` ON `mailbox_email` (`storage_object_id`);--> statement-breakpoint
CREATE TABLE `mailbox_monthly_activity` (
	`mailbox_id` text NOT NULL,
	`stat_month` text NOT NULL,
	`received_count` integer DEFAULT 0 NOT NULL,
	`sent_count` integer DEFAULT 0 NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	PRIMARY KEY(`mailbox_id`, `stat_month`),
	FOREIGN KEY (`mailbox_id`) REFERENCES `mailbox_activity_identity`(`mailbox_id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `mailbox_monthly_activity_month_idx` ON `mailbox_monthly_activity` (`stat_month`,`mailbox_id`);--> statement-breakpoint
CREATE TABLE `mailbox_stats` (
	`mailbox_id` text PRIMARY KEY NOT NULL,
	`message_total` integer DEFAULT 0 NOT NULL,
	`incoming_total` integer DEFAULT 0 NOT NULL,
	`outgoing_total` integer DEFAULT 0 NOT NULL,
	`unread_total` integer DEFAULT 0 NOT NULL,
	`attachment_total` integer DEFAULT 0 NOT NULL,
	`logical_storage_size` integer DEFAULT 0 NOT NULL,
	`revision` integer DEFAULT 0 NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`mailbox_id`) REFERENCES `mailbox`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `storage_object` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`key` text NOT NULL,
	`kind` text NOT NULL,
	`size` integer DEFAULT 0 NOT NULL,
	`metadata` text,
	`state` text DEFAULT 'active' NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `storage_object_key_idx` ON `storage_object` (`key`);--> statement-breakpoint
CREATE INDEX `storage_object_kind_idx` ON `storage_object` (`kind`,`size`);--> statement-breakpoint
CREATE INDEX `storage_object_size_idx` ON `storage_object` (`size`);--> statement-breakpoint
CREATE INDEX `storage_object_updated_idx` ON `storage_object` (`updated_at`);--> statement-breakpoint
CREATE TABLE `template` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`subject` text DEFAULT '' NOT NULL,
	`preheader` text DEFAULT '' NOT NULL,
	`storage_object_id` integer NOT NULL,
	`shared` integer DEFAULT false NOT NULL,
	`tags` text DEFAULT '[]' NOT NULL,
	`group` text,
	`created_by` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`storage_object_id`) REFERENCES `storage_object`(`id`) ON UPDATE no action ON DELETE restrict,
	FOREIGN KEY (`created_by`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE INDEX `template_name_idx` ON `template` (`name`);--> statement-breakpoint
CREATE UNIQUE INDEX `template_storage_object_idx` ON `template` (`storage_object_id`);--> statement-breakpoint
CREATE INDEX `template_shared_idx` ON `template` (`shared`,`updated_at`);--> statement-breakpoint
CREATE INDEX `template_created_by_idx` ON `template` (`created_by`);--> statement-breakpoint
CREATE INDEX `template_creator_updated_idx` ON `template` (`created_by`,`updated_at`,`id`);--> statement-breakpoint
CREATE INDEX `template_group_updated_idx` ON `template` (`group`,`updated_at`,`id`);--> statement-breakpoint
CREATE INDEX `template_creator_group_updated_idx` ON `template` (`created_by`,`group`,`updated_at`,`id`);--> statement-breakpoint
CREATE INDEX `template_updated_at_idx` ON `template` (`updated_at`);--> statement-breakpoint
CREATE INDEX `template_group_idx` ON `template` (`group`);--> statement-breakpoint
CREATE TABLE `webhook` (
	`id` text PRIMARY KEY NOT NULL,
	`owner_id` text NOT NULL,
	`domain_id` text,
	`url` text NOT NULL,
	`description` text DEFAULT '' NOT NULL,
	`secret` text NOT NULL,
	`events` text DEFAULT '["email.received"]' NOT NULL,
	`scope_addresses` text,
	`status` text DEFAULT 'active' NOT NULL,
	`failure_count` integer DEFAULT 0 NOT NULL,
	`last_success_at` integer,
	`last_failure_at` integer,
	`last_error` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`owner_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`domain_id`) REFERENCES `domain`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `webhook_domain_idx` ON `webhook` (`domain_id`);--> statement-breakpoint
CREATE INDEX `webhook_owner_idx` ON `webhook` (`owner_id`);--> statement-breakpoint
CREATE INDEX `webhook_status_idx` ON `webhook` (`status`);--> statement-breakpoint
CREATE INDEX `webhook_created_idx` ON `webhook` (`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `webhook_url_idx` ON `webhook` (`url`,`id`);--> statement-breakpoint
CREATE INDEX `webhook_owner_created_idx` ON `webhook` (`owner_id`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `webhook_status_domain_idx` ON `webhook` (`status`,`domain_id`);--> statement-breakpoint
CREATE INDEX `webhook_status_created_idx` ON `webhook` (`status`,`created_at`,`id`);