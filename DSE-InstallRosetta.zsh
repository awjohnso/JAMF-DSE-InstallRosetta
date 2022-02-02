#!/bin/zsh

# Author: Andrew W. Johnson
# Date: Sometime in 2021
# Version: 1.00
# Organization: Stony Brook University/DoIT
#
# This Jamf script will check the hardware and if it detects it is not an Intel based 
# Macintosh, it will then install Rosetta. Typically this script is run early in the setup
# process so other programs and processes can run without issue.

	# Check for Intel chip. Easier to check for Intel than M1 or ARM etc, since I've noticed
	# Apple had a slightly different designation one one of my MacMinis. Thus checking for
	# Intel seems safer.
isIntel=$( /usr/sbin/sysctl -n machdep.cpu.brand_string | /usr/bin/egrep -ic "Intel" )

	# If the CPU type is Intel do nothing, but if it's implied to be ARM, then install Rosetta.
if [[ ${isIntel} -eq 0 ]]; then
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: This is Apple Silicon, installing Rosetta..." >> /var/log/jamf.log
	/bin/echo "This is Apple Silicon, installing Rosetta..."
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
else
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: This is an Intel Macintosh. Nothing to do." >> /var/log/jamf.log
	/bin/echo "This is an Intel Macintosh. Nothing to do."
fi

exit 0
