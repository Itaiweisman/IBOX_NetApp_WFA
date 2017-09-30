param (
  [parameter(Mandatory=$true, HelpMessage="Array name or IP address")]
  [string]$ibox,

  [parameter(Mandatory=$true, HelpMessage="Volume name")]
  [string]$name,

  [parameter(Mandatory=$true, HelpMessage="pool")]
  [string]$pool,

  [parameter(Mandatory=$true, HelpMessage="Size")]
  [long]$size,

  [parameter(Mandatory=$true, HelpMessage="provision type")]
  [ValidateSet("THICK", "THIN")]
  [string]$provtype

)
#$name="WFA-TESTVOL"
#$pool=126
#$size=1000000000
#$provtype="THICK"
#$ibox='ibox1093'
$url="http://"+$ibox+"/api/rest/volumes"
$password='123456'
$user='admin'
$size*=1000000000
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


    
$credi=CreateUserCredntials $user $password
$body=BuildVolumeJson $name $size $pool $provtype
$response=Invoke-RestMethod -uri $url -Method POST -cred $credi -body $body -ContentType "application/json"
$response

