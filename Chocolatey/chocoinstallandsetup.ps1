Set-ExecutionPolicy Bypass -Scope Process;

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

choco install git -y
choco install azure-data-studio -y
choco install vscode -y
choco install sql-server-management-studio -y
#choco install powerbi -y
