$ErrorActionPreference = "Stop"
function Add-BuildTools {
    Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" -ArgumentList 'modify --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools" --quiet --add Microsoft.VisualStudio.Component.NuGet.BuildTools --add Microsoft.Net.Component.4.5.TargetingPack --norestart --force' -Wait -PassThru;
}
function Add-DotnetSDK {
Param(
	[Parameter(Mandatory=$false)]
	$version = $null
);
	Add-Tools -Tools 'dotnetcore-sdk' -Versions $version
	#add environment variable MsSDKBuildPath
    $dotnetSDK = (Get-Item Env:MSBuildSDKsPath -ErrorAction SilentlyContinue).Value;
    If ([string]::IsNullOrEmpty($dotnetSDK)) {
        If ([string]::IsNullOrEmpty($version)) {
            $version = (dir "C:\Program Files\dotnet\sdk" | Where-Object { $_.Name -like '2.*' -or $_.Name -like '1.*' })[-1].Name;
        }
        If ([string]::IsNullOrEmpty($version)) {
            $version = Read-Host -Prompt 'DotNet SDK Path (optional, path defaults to latest path C:\Program Files\dotnet\sdk\{latestversion}\sdk)';
        }
        $dotnetSDK = "C:\Program Files\dotnet\sdk\$version\Sdks";
        [System.Environment]::SetEnvironmentVariable("MSBuildSDKsPath", $dotnetSDK, [System.EnvironmentVariableTarget]::User);
    }
}
function Add-ServiceFabric {
	$installed_version = (Get-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Service Fabric SDK").FabricSDKVersion;
	
	If ($installed_version -ne $null) {
		Write-Warning "Service Fabric version $installed_version already installed. Please refer to this document for upgrading your service fabric cluster: https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-upgrade-windows-server";
		return;
	}
	
	Invoke-WebRequest "https://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi" -OutFile "C:\WebPlatformInstaller.msi" -UseBasicParsing;
	Start-Process "msiexec" -ArgumentList '/i', 'C:\WebPlatformInstaller.msi', '/passive', '/quiet', '/norestart', '/qn' -NoNewWindow -Wait; 
	rm "C:\WebPlatformInstaller.msi"
		
	WebPICMD.exe /Install /Products:MicrosoftAzure-ServiceFabric-CoreSDK /AcceptEULA
}
function Add-AngularTools {
	Add-Tools -Tools ('nodejs.install', 'npm');
	npm install --add-python-to-path='true' --global --production windows-build-tools;
	npm install @angular/cli -g;
}
function Add-Tools {
Param(
	[Parameter(Mandatory=$true)]
	[string[]]
	$tools,
	
	[Parameter(Mandatory=$false)]
	[string[]]
	$versions = $null
);    

    #install chocolatey
	$chocoExists = (Test-Path -Path "$env:ProgramData\Chocolatey");
	If (-not ($chocoExists)) {
		iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
	} Else {
		Write-Host "Chocolatey already exists";
	}

    $allUsersProfile = [Environment]::GetEnvironmentVariable("ALLUSERSPROFILE");
	$envPath = [Environment]::GetEnvironmentVariable("Path");
	$chocoPath = "$allUsersProfile\chocolatey\bin\choco";

    #upgrade powershell
	If ($PSVersionTable.PSVersion.Major -lt 5) {
		& $chocoPath upgrade powershell -Force;
        Write-Host "Powershell upgrade successful"
	}

    & $chocoPath feature enable -n allowGlobalConfirmation
	For ($i=0; $i -le $tools.count; $i++)
	{
		$tool = $tools[$i];
		If ($versions -ne $null)
		{
			$version = $versions [$i];
		}
		$toolExists = (& $chocoPath search $tool --by-id-only --limit-output --local-only -e);
	   If (-not ($toolExists)) {
			If ($version -ne $null)
			{
				& $chocoPath install $tool --version $version -Force;
			}
			Else {
				& $chocoPath install $tool -Force;
			}
	   } Else {
			If ($version -ne $null)
			{
				& $chocoPath upgrade $tool --version $version -Force;
			}
			Else {
				& $chocoPath upgrade $tool -Force;
			}
        }
	}
    & $chocoPath feature disable -n allowGlobalConfirmation
}

Export-ModuleMember -Function Add-BuildTools
Export-ModuleMember -Function Add-DotnetSDK
Export-ModuleMember -Function Add-ServiceFabric
Export-ModuleMember -Function Add-AngularTools
Export-ModuleMember -Function Add-Tools
