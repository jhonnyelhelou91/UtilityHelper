# Utility Helpers

PowerShell Helper scripts to manage tools.

## Getting Started

* Copy the files
* Open Command Line or PowerShell (*Window + X, A*)
* If you opened Command Prompt, then type *powershell* in order to use PowerShell commands
* Navigate to the scripts directory <br />`cd your_directory`
* Type <br />`Import-Module .\UtilityHelper.psm1`
* Now you can use the methods from your PowerShell session

### Adding Script to Profile [Optional]

* Enable execution policy using PowerShell Admin <br /> `Set-ExecutionPolicy Unrestricted`
* Navigate to the profile path <br />`cd (Split-Path -parent $PROFILE)`
* Open the location in Explorer <br />`ii .`
* Create the user profile if it does not exist <br />`If (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }`
* Import the module in the PowerShell profile <br />`Import-Module -Path script_directory -ErrorAction SilentlyContinue`

# Examples

## Add-BuildTools Example
Install Build Tools using Visual Studio Installer
<details>
   <summary>Add Build Tools</summary>
   <p>Add-BuildTools</p>
</details>

## Add-DotnetSDK Example
Install DOTNET SDK and add version to environment variable
<details>
   <summary>Add latest Dotnet SDK</summary>
   <p>Add-DotnetSDK</p>
</details>
<details>
   <summary>Add specific Dotnet SDK</summary>
   <p>Add-DotnetSDK -Version 2.2</p>
</details>

## Add-ServiceFabric Example
Install Service Fabric SDK.
<details>
   <summary>Install Service Fabric</summary>
   <p>Add-ServiceFabric</p>
</details>

## Add-AngularTools Example
Install Angular tools: nodeJS, npm, angular -cli and windows-build-tools globally.
<details>
   <summary>Add Angular tools</summary>
   <p>Add-AngularTools</p>
</details>

## Add-Tools Example
Install or update your favorite tools.
<details>
   <summary>Add Or Update favorite tools</summary>
   <p>Add-Tools -Tools 'googlechrome', 'firefox', '7zip.install', 'putty.install', 'git', 'notepadplusplus.install'</p>
</details>
<details>
   <summary>Install specific tool version</summary>
   <p>Add-Tools -Tools 'git.install' -Version '2.10'</p>
</details>
