#==========================================================
# This script parses the system logs of a Windows server
# and forwards details via email.
#
# REQUIREMENTS:
# - psloglist (part of pstools)
# 
# MOD HISTORY
# 18 Sept 2015 - nju - Created Script
#==========================================================

$PSLOGLIST='c:\psloglist.exe'	  # This is the path to the psloglist.exe
$LASTHOURS='24'					        # How far back (in hours) do we want to go
$LOGLEVELS='we'					        # i=info,w=warning,e=error
$SMTPSERVER='10.x.y.z'			    # What mail server will send the message (IP Address)
$RCPTTO='user@domain.tld'		    # who is the message to
$MAILFROM='user@domain.tld'		# who is the message from
$SUBJECT="Logs from $env:computername for the last $LASTHOURS hours" 	# What is the subject

#------------------------------------------------------------
# Add the event logs that you want to review below.  There is 
# likely a better way to do this (like with an array) but we're 
# basically creating an $output_ variable for each available 
# log and then combining each of those logs at the bottom of 
# the script.
#------------------------------------------------------------

$output_system=& $PSLOGLIST -f $LOGLEVELS -h $LASTHOURS |out-string 	
$output_ds=& $PSLOGLIST -f $LOGLEVELS -h $LASTHOURS "directory service" |out-string
$output_application=& $PSLOGLIST -f $LOGLEVELS -h $LASTHOURS application |out-string
$output_security=& $PSLOGLIST -f $LOGLEVELS -h $LASTHOURS security |out-string

$output = "++++ SYSTEM LOG ++++"
$output +=$output_system
$output +="++++ Directory Service LOG ++++"
$output +=$output_ds
$output +="++++ Application LOG ++++"
$output += $output_application
$output += "++++ Security LOG ++++"
$output += $output_security

send-mailmessage -smtpserver "$SMTPSERVER" -to "$RCPTTO" -from "$MAILFROM" -subject "$SUBJECT" -body "$output"
