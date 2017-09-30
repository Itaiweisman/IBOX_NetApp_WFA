param (
  [parameter(Mandatory=$true, HelpMessage="Array name or IP address")]
  [string]$ibox,

  [parameter(Mandatory=$true, HelpMessage="Volume name")]
  [string]$name,

  [parameter(Mandatory=$true, HelpMessage="Size")]
  [long]$size,


 [parameter(Mandatory=$true, HelpMessage="password")]
  [Alias("IBOX_Password")] [string]$password,

 [parameter(Mandatory=$true, HelpMessage="user")]
  [string]$user

)
$a=ConvertTo-SecureString $password -AsPlainText -Force
#$a=Get-WfaInputPassword -EncryptedPassword $password
$creds = New-Object System.Management.Automation.PSCredential $user, $a
write-host $creds
function GetObjectIDByName 
{
	param(
		[parameter(Mandatory=$true)]
		[string]$ObjType,
		
		[parameter(Mandatory=$true)]
		[string]$ObjName
	)
	$url="http://"+$ibox+"/api/rest/"+$ObjType+"?"+"name="+$ObjName
	$response=Invoke-RestMethod -uri $url -Method GET -cred $creds -ContentType "application/json"
	return $response.result.id
	
	
}

$id=GetObjectIDByName volumes $name
$url="http://"+$ibox+"/api/rest/volumes/"+$id


$size*=1000000000
$iboxVolumeName=$name
$JSON=@{"size"=[long]$size} | ConvertTo-JSON
$url
$JSON

$response=Invoke-RestMethod -uri $url -Method PUT -cred $creds -body $JSON -ContentType "application/json"
$response



