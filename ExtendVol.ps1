function CreateUserCredntials
{
    param(
        [parameter(Mandatory=$true, HelpMessage="User Name")]
        [string]$UserName,

        [parameter(Mandatory=$true, HelpMessage="User Password")]
        [string]$Password
    )
    $pwd=ConvertTo-SecureString $Password -AsPlainText -Force
    $cred=New-Object Management.Automation.PSCredential ($UserName,$pwd)
    return $cred
}
function GetVolIdByName 
{
  param(
        [parameter(Mandatory=$true, HelpMessage="VolName")]
        [string]$name, 
        [parameter(Mandatory=$true, HelpMessage="Ibox")]
	[string]$ibox,
        [parameter(Mandatory=$true, HelpMessage="VolName")]
	[PSCredential]$cred
	

)
	$url="http://"+$ibox+"/api/rest/volumes/?name="+$name
	$response=Invoke-RestMethod -uri $url -Method GET -cred $cred
	#$response
	$response.result[0].id
	$id=$response.result[0].id
	return $id
}
$cred=CreateUserCredntials admin 123456
$ID=GetVolIdByName Ofer ibox1093 $cred
Write-Output $ID
