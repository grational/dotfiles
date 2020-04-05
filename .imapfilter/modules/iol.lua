local filters = require "filters"

local iol = {}

local email = 'd7392@italiaonline.it'
local external_password = filters.get_external_password('mail-app-pass', email)
local account = IMAP {
	server = 'outlook.office365.com',
	username = email,
	password = external_password
}

local folders = Set {
	'INBOX',
	'cron',
	'jira',
	'ADP',
	'GOODBOX'
}

function iol.filters()

	filters.labeled_status(account, folders)

	local mails = filters.all_inbox_emails(account)

	filters.if_cc_only_move_to(
		'cc',
		account,
		mails,
		'giuseppe.ricupero@italiaonline.it',
		'd7392@italiaonline.it'
	)

	filters.if_from_contains_move_to (
		'cron',
		account,
		mails,
		'Cron Daemon',
		'DAB user',
		'FacebookCrawler@crawler-proxy-manager',
		'mysql@prd-inf-dbclient-b.aws.pgol.net',
		'monitor@italiaonline.it'
	)

	filters.if_from_contains_move_to (
		'jira',
		account,
		mails,
		'jira@paginegialle.it',
		'jira.releng@paginegialle.it' ,
		'jira@italiaonline.it',
		'jira.releng@italiaonline.it'
	)

	filters.if_from_contains_move_to (
		'ADP',
		account,
		mails,
		'@adp.com'
	)

	filters.delete_mail_from (
		account,
		mails,
		'google-my-business-noreply@google.com',
		'googlemybusiness-noreply@google.com',
		'google-maps-noreply@google.com'
	)

	local remaining_inbox_emails = filters.all_inbox_emails(account)
	filters.move_to (
		'GOODBOX',
		account,
		remaining_inbox_emails
	)

	filters.labeled_status(account, folders)
end

return iol
-- vim: fdm=indent
