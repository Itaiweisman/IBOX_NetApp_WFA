param (
  [parameter(Mandatory=$true, HelpMessage="Array name or IP address")]
  [string]$ibox,

  [parameter(Mandatory=$true, HelpMessage="Volume name")]
  [string]$name,

  [parameter(Mandatory=$true, HelpMessage="pool")]
  [string]$pool_name,

  [parameter(Mandatory=$true, HelpMessage="Size")]
  [long]$size,

  [parameter(Mandatory=$true, HelpMessage="provision type")]
  [ValidateSet("THICK", "THIN")]
  [string]$provtype,


 [parameter(Mandatory=$true, HelpMessage="password")]
  [Alias("IBOX_Password")] [string]$password,

 [parameter(Mandatory=$true, HelpMessage="user")]
  [string]$user

)
#$a=ConvertTo-SecureString $password -AsPlainText -Force
$a=Get-WfaInputPassword -EncryptedPassword $password
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


$url="http://"+$ibox+"/api/rest/volumes"

#echo $password > c:\d2.out

$size*=1000000000
$iboxVolumeName=$name

function BuildVolumeJson 
{
    param(
        [parameter(Mandatory=$true, HelpMessage="Volume Name")]
        [string]$Name,

        [parameter(Mandatory=$true, HelpMessage="Volume Size")]
        [string]$Size,

        [parameter(Mandatory=$true, HelpMessage="Pool ID")]
        [string]$PoolID,

        [parameter(Mandatory=$true, HelpMessage="Provtype")]
        [string]$Provtype
    )
    $JSON= @{
        "pool_id" = [int]$PoolID
        "provtype" = $Provtype
        "name" = $Name
        "size" = [long]$Size
        } | ConvertTo-JSON
    return $JSON
}


$pool =  GetObjectIDByName "pools" $pool_name 

$body=BuildVolumeJson $name $size $pool $provtype
$body
$response=Invoke-RestMethod -uri $url -Method POST -cred $creds -body $body -ContentType "application/json"
$response



