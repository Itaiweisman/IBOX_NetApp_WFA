param (
  [parameter(Mandatory=$true, HelpMessage="Array name or IP address")]
  [string]$ibox,

  [parameter(Mandatory=$true, HelpMessage="Volume name")]
  [string]$volname,

  [parameter(Mandatory=$true, HelpMessage="Host Name")]
  [string]$hostname,

  [parameter(Mandatory=$false, HelpMessage="lun")]
  [int]$lun


)

$password='123456'
$user='admin'
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

function GetObjectIDByName 
{
	param(
		[parameter(Mandatory=$true)]
		[string]$ObjType,
		
		[parameter(Mandatory=$true)]
		[string]$ObjName
	)
	$url="http://"+$ibox+"/api/rest/"+$ObjType+"?"+"name="+$ObjName
	$response=Invoke-RestMethod -uri $url -Method GET -cred $credi -ContentType "application/json"
	return $response.result.id
	
	
}
function MapVolToHost {
	    param(
                [parameter(Mandatory=$true)]
                [int]$volid,

                [parameter(Mandatory=$true)]
                [int]$hostid,
                [parameter(Mandatory=$false)]
                [int]$lunid
        )
	if ($lunid) {
		$JSON=@{
			"volume_id"=[int]$volid
			"lun"=[int]$lunid
		} | ConvertTo-JSON }
	else { 
		$JSON=@{
			"volume_id"=[int]$volid
	     } | ConvertTo-JSON } 
	$url="http://"+$ibox+"/api/rest/hosts/"+$hostid+"/luns/"
	$url
	$response=Invoke-RestMethod -uri $url -body $JSON -Method POST -cred $credi -ContentType "application/json"

}


    
$credi=CreateUserCredntials $user $password
$host_id=GetObjectIDByName hosts $hostname
$vol_id=GetObjectIDByName volumes $volname
if (-Not $host_id -or -Not $vol_id) 
{
	Write-Host "Not!!!"
	Exit 1
}

Write-Host "Host ID"+$host_id
Write-Host "Volume ID"+$vol_id
MapVolToHost $vol_id $host_id $lun

