param (
  [parameter(Mandatory=$true, HelpMessage="Cinder Host or IP address")]
  [string]$cinderhost,

  [parameter(Mandatory=$false, HelpMessage="Volume name")]
  [string]$name,

  [parameter(Mandatory=$true, HelpMessage="Size")]
  [long]$size,


)
$password='xsignnet1'
$user='root'
$host='cinder2'
function Invoke-SSH
{
    param(
        [parameter(Mandatory=$true, HelpMessage="User Name")]
        [string]$UserName,

        [parameter(Mandatory=$true, HelpMessage="User Password")]
        [string]$Password,
        [parameter(Mandatory=$true, HelpMessage="Host")]
        [string]$Host,
        [parameter(Mandatory=$true, HelpMessage="command")]
        [string]$Command
    )
	return .\plink.exe -pw $Password $user\@$Host $cmd
}


Invoke-SSH $user $passwrod $host ". /root/cindersh ; cinder list"
