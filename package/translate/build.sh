#!/bin/bash
# Version: 7

# This script will convert the *.po files to *.mo files, rebuilding the package/contents/locale folder.
# Feature discussion: https://phabricator.kde.org/D5209
# Eg: contents/locale/fr_CA/LC_MESSAGES/plasma_applet_org.kde.plasma.eventcalendar.mo

DIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
# plasmoidName=`kreadconfig5 --file="$DIR/../metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Name"`
plasmoidName='com.github.PortikSzabolcs.progress-indicator'
# website=`kreadconfig5 --file="$DIR/../metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Website"`
website="https://github.com/PortikSzabolcs/progress-indicator-plasmoid"
bugAddress="$website"
packageRoot="${DIR}/.." # Root of translatable sources
projectName="plasma_applet_${plasmoidName}" # project name

### Colors
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# https://stackoverflow.com/questions/911168/how-can-i-detect-if-my-shell-script-is-running-through-a-pipe
TC_Red='\033[31m'; TC_Orange='\033[33m';
TC_LightGray='\033[90m'; TC_LightRed='\033[91m'; TC_LightGreen='\033[92m'; TC_Yellow='\033[93m'; TC_LightBlue='\033[94m';
TC_Reset='\033[0m'; TC_Bold='\033[1m';
if [ ! -t 1 ]; then
	TC_Red=''; TC_Orange='';
	TC_LightGray=''; TC_LightRed=''; TC_LightGreen=''; TC_Yellow=''; TC_LightBlue='';
	TC_Bold=''; TC_Reset='';
fi
function echoTC() {
	text="$1"
	textColor="$2"
	echo -e "${textColor}${text}${TC_Reset}"
}
function echoGray { echoTC "$1" "$TC_LightGray"; }
function echoRed { echoTC "$1" "$TC_Red"; }
function echoGreen { echoTC "$1" "$TC_LightGreen"; }

#---
if [ -z "$plasmoidName" ]; then
	echoRed "[translate/build] Error: Couldn't read plasmoidName."
	exit
fi

if [ -z "$(which msgfmt)" ]; then
	echoRed "[translate/build] Error: msgfmt command not found. Need to install gettext"
	echoRed "[translate/build] Running ${TC_Bold}'sudo apt install gettext'"
	sudo apt install gettext
	echoRed "[translate/build] gettext installation should be finished. Going back to installing translations."
fi

#---
echoGray "[translate/build] Compiling messages"

function relativePath() {
	basePath=`realpath -- "$1"`
	longerPath=`realpath -- "$2"`
	echo "${longerPath#${basePath}*}"
}
catalogs=`find . -name '*.po' | sort`
for cat in $catalogs; do
	catLocale=`basename ${cat%.*}`
	moFilename="${catLocale}.mo"
	installPath="${packageRoot}/contents/locale/${catLocale}/LC_MESSAGES/${projectName}.mo"
	installPath=`realpath -m -- "$installPath"`
	relativeInstallPath=`relativePath "${packageRoot}" "${installPath}"`
	relativeInstallPath="${relativeInstallPath#/*}"
	echoGray "[translate/build] Converting '${cat}' => '${relativeInstallPath}'"
	msgfmt -o "${moFilename}" "${cat}"
	mkdir -p "$(dirname "$installPath")"
	mv "${moFilename}" "${installPath}"
done

echoGreen "[translate/build] Done building messages"

if [ "$1" = "--restartplasma" ]; then
	echo "[translate/build] ${TC_Bold}Restarting plasmashell${TC_Reset}"
	killall plasmashell
	kstart5 plasmashell
	echo "[translate/build] Done restarting plasmashell"
else
	echo "[translate/build] (re)install the plasmoid and restart plasmashell to test translations."
fi
