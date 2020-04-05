package.path = package.path .. ';/home/d7392/.imapfilter/modules/?.lua'

local iol = require "iol"
local gmail_gr = require "gmail_gr"
local polito_phd = require "polito_phd"

-- The time in seconds for imapfilter to wait
-- for a mail server's response (default 60)
options.timeout = 120

-- imapfilter tries to create a destination mailbox if it doesn't exist
options.create = true

-- new mailboxes that were automatically created, get also subscribed
-- that is, they are set active in order for clients to recognize them
options.subscribe = true

-- messages are expunged immediately after being marked deleted
-- instead of waiting for the mailbox to be closed
options.expunge = true

function forever()
	iol.filters()
	gmail_gr.filters()
	polito_phd.filters()
end

function main()
	two_minutes = 120
	become_daemon(two_minutes, forever)
end

main() -- Call the main function
-- forever() -- one time execution for debug purposes
-- vim: fdm=indent
