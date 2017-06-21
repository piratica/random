import-module activedirectory
$output = get-aduser -filter 'enabled -eq "true"' -properties * | select -property samaccountname,distinguishedname,lastlogondate,whencreated,whenchanged | out-string

send-mailmessage -smtpserver <YOUR_MAIL_SERVER> -to <TO_EMAIL_ADDRESS> -from <FROM_EMAIL_ADDRESS> -subject "Daily User Report" -body $output
