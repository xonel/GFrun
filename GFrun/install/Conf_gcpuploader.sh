echo "
        #:'######:::'########:'########::'##::::'##:'##::: ##:
#      '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:
#       ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:
#       ##::'####: ######::: ########:: ##:::: ##: ## ## ##:
#       ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:
#       ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:
#     .  ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:
#     :......::::..::::::::..:::::..:::.......:::..::::..::"
echo "
# Username and password credentials may be placed in a configuration file
# located either in the current working directory, or in the user's home
# directory.  WARNING, THIS IS NOT SECURE. USE THIS OPTION AT YOUR OWN
# RISK.  Username and password are stored as clear text in a file
# format that is consistent with Microsoft (r) INI files."
echo ""
echo "====================================================="
echo "Configuration Auto-Upload http:\\connect.garmin.com"
echo "====================================================="

if [ ! -f $HOME/.guploadrc ]; then
		read -p 'USERNAME on connect.garmin.com (@mail) : ' Read_user
		read -p 'PASSWORD on connect.garmin.com : ' Read_password

		echo "[Credentials]" >> $HOME/.guploadrc
		echo "username="$Read_user"" >> $HOME/.guploadrc
		echo "password="$Read_password"" >> $HOME/.guploadrc	
	else
		echo "Configuration file already exist"
		echo ""
		cat  $HOME/.guploadrc
fi
echo ""
echo "PROCEDURE TERMINEE"
