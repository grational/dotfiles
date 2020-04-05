local filters = require "filters"

local polito_phd = {}

local email = 's223297@studenti.polito.it'
local external_password = filters.get_external_password('mail-pass', email)
local account = IMAP {
	server = 'imap.studenti.polito.it',
	username = email,
	password = external_password,
	port = 993,
	ssl = 'auto'
}

local folders = Set {
	'INBOX'
}

function polito_phd.filters()
	filters.labeled_status(account, folders)

	-- delete all emails since they are automatically 
	-- forwarded to giuseppe.ricupero@polito.it by the server
	filters.all_inbox_emails(account):delete_messages()

	filters.labeled_status(account, folders)
end

return polito_phd
-- vim: fdm=indent
