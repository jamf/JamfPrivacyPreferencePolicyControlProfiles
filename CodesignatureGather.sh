#!/bin/bash

####################################################################################################
#
# Copyright (c) 2018, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
#
# Description
#  This script was designed to allow Admins the ability to scan every application installed under /Applications and return their 
#  app name, BundleID and CodeSignature to be used with Apples new Privacy Preference Policy Control  (PPPC) profile payload 
#  in the Transparency Consent and Control (TCC) framework.  
#
# Admins can either specify a specific app or binary by path or let the script look for any .app files under the /Applications/ directory.  
#
# If ran via a Jamf policy the output is echoed into the policy log and sent back to the Jamf Pro server.  If ran locally the results are displayed in terminal
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Adam Sippl on September 25th, 2018
#
####################################################################################################
#

## Admins can either use Parameter 4 in a policy to define a specific app  
## or choose not to define a specific path to one application and search for all applications installed under /Applications/

pathToApp="$4"

## If a path was defined in parameter 4 it will return just that apps values

if [[ -n "$pathToApp" ]]; then
	bundleID=$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$path"/Contents/Info.plist)
	codesignature=$(codesign -dr - "$app" 2>&1 | awk -F '>' '{print $2}') 
	if [[ -n "$codesignature" ]]; then
		echo App: "$app"
		echo BundleID: "$bundleID"
		echo CodeSignature: "$codesignature"
	else
		echo App: "$app"
		echo BundleID: "$bundleID"
		echo "CodeSignature: No Code Signature"
	fi
else

## If pathToApp was not defined it will search through all Apps recursively in the Applications directory

IFS=$'\n'

apps=$(find /Applications -iname "*.app" -maxdepth 2)

for app in $apps; do
	bundleID=$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$app"/Contents/Info.plist)
			codesignature=$(codesign -dr - "$app" 2>&1 | awk -F '>' '{print $2}') 
		
			if [[ -n "$codesignature" ]]; then
				echo App: "$app"
				echo BundleID: "$bundleID"
				echo CodeSignature: "$codesignature"
			else
				echo App: "$app"
				echo BundleID: "$bundleID"
				echo "CodeSignature: No Code Signature"		
			fi
			echo ""
done
fi