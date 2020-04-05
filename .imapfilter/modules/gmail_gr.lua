local filters = require "filters"

local gmail_gr = {}

local email = 'giuseppe.ricupero@gmail.com'
local external_password = filters.get_external_password('mail-app-pass', email)
local account = IMAP {
	server = 'imap.gmail.com',
	username = email,
	password = external_password,
	port = 993,
	ssl = 'auto'
}

local folders = Set {
	'INBOX',
	'INBOX/agenda',
	'INBOX/bolletta_cb',
	'INBOX/previmedical',
	'INBOX/e-commerce',
	'INBOX/code-ml',
	'INBOX/sella',
	'INBOX/groovy-calamari',
}

function gmail_gr.filters()

	filters.labeled_status(account, folders)

	local mails = filters.all_inbox_emails(account)

	filters.if_from_contains_move_to (
		'INBOX/agenda',
		account,
		mails,
		'Google Calendar'
	)

	filters.if_from_contains_move_to (
		'INBOX/bolletta_cb',
		account,
		mails,
		'@servizioelettriconazionale.it'
	)

	filters.if_from_contains_move_to (
		'INBOX/previmedical',
		account,
		mails,
		'@previmedical.it'
	)

	filters.if_from_contains_move_to (
		'INBOX/e-commerce',
		account,
		mails,
		'@amazon',
		'aliexpress.com'
	)
	
	filters.if_from_contains_move_to (
		'INBOX/code-ml',
		account,
		mails,
		'mailer@dzone.com',
		'@interviewcake.com',
		'@enki.com'
	)
	
	filters.if_from_contains_move_to (
		'INBOX/sella',
		account,
		mails,
		'@sella.it',
		'@bancasella.it'
	)
	
	filters.if_from_contains_move_to (
		'INBOX/groovy-calamari',
		account,
		mails,
		'me@sergiodelamo.com'
	)

	filters.labeled_status(account, folders)
end

return gmail_gr
-- vim: fdm=indent
