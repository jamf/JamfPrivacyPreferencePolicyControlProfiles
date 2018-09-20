# JamfPrivacyPreferencePolicyControlProfiles

This profile will leverage Apple's new Privacy Preference Policy Control payload to allow the Jamf framework to communicate with three main apps and services used that leverage AppleEvents to provide interactive prompts with end users.  

This profile is using the Privacy Service Dictionary Key of AppleEvents to allow communication from the Jamf binary, Jamf agent and Jamf.app to Finder, SystemEvents and SystemUIServer.  

You can modify the entry for PayloadOrganization to match the organization name and modify the PayloadDescription and PayloadDisplayName entries to match current naming and description conventions.  

If you are using Jamf Pro 10.7.1+ you can upload this profile to the server unsigned and it will automatically generate the PayloadUUID values.  
If you wish to upload this to a server running a version prior to 10.7.1 you will need to specify the PayloadUUID keys and  values and then sign the profile prior to upload.  
