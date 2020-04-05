local filters = {}

function filters.get_external_password(label, account)
	local cmd = "secret-tool lookup " .. label .. " " .. account
	status, output = pipe_from(cmd)
	return output
end 

local function non_empty(s)
	return not ( (s == nil) or (s == '') )
end

function banner_print(message)
	local banner = string.rep( "=", string.len(message) )
	print(banner)
	print(message)
	print(banner)
end

function filters.labeled_status(account, folders)
	banner_print(account._account.username)
	for _, folder in ipairs(folders) do
		account[folder]:check_status()
	end
end

function filters.all_inbox_emails(account)
	return account.INBOX:select_all()
end

function filters.if_cc_only_move_to(dest, account, mails, ...)
	local filtered = mails
	for _,condition in ipairs({...}) do
		filtered = filtered - mails:contain_to(condition)
	end
	filtered:move_messages(account[dest])
end

function filters.if_from_contains_move_to(dest, account, mails, ...)
	for _,condition in ipairs({...}) do
		local filtered = mails:contain_from(condition)
		filtered:move_messages(account[dest])
	end
end

function filters.delete_mail_from(account, mails, ...)
	for _,condition in ipairs({...}) do
		local filtered = mails:contain_from(condition)
		filtered:delete_messages()
	end
end

function filters.move_to(dest, account, mails)
	mails:move_messages(account[dest])
end

return filters
-- vim: fdm=indent
