param (
  [parameter(Mandatory=$true, HelpMessage="Cinder Host or IP address")]
  [string]$cinderhost,

  [parameter(Mandatory=$false, HelpMessage="Volume name")]
  [string]$name,

  [parameter(Mandatory=$true, HelpMessage="Size")]
  [int]$size


)
$user="admin"
$password="adpass"
$domain="default"
function GetToken 
{
	$url="http://"+$cinderhost+":"+$auth_port+"/v3/auth/tokens"
	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$headers.Add("Content-Type", 'application/json')
	$JSON= @{
	"auth"= @{
        "identity"= @{
        "methods"= {"password"}
        "password"= @{
        "user"= @{
          "name"= ""
          "domain"= @{ 
		"id"= "$domain"
		 }
          "password"= "$password"
        }
      }
    }
  }
	} | ConvertTo-JSON
	$JSON
	$response=Invoke-RestMethod -uri $URL -Method Get -Headers $headers
	
}

$OS_TOKEN="7af34b49d3d6489294b875bd71500f79"
$PROJECT_ID="a4ff4e5d4310422dae78df323c3ec95a"
$port=8776
$JSON = @{
"volume" =  
@{
"status" =  "creating"
"user_id" = $NULL 
"name" =  "$name"
"imageRef" =  $NULL
"availability_zone" = $NULL
"description" = $NULL 
"multiattach" = $false
"attach_status" =  "detached"
"volume_type" =  $NULL
"metadata" =  @{} 
"consistencygroup_id" = $NULL 
"source_volid" = $NULL 
"snapshot_id" = $NULL 
"project_id" = $NULL
"source_replica" =  $NULL
"size" = $size
}
} | ConvertTo-JSON
$JSON

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("User-Agent", 'python-cinderclient')
$headers.Add("Content-Type", 'application/json')
$headers.Add("Accept", 'application/json')
$headers.Add("X-Auth-Token", "$OS_TOKEN")
$URL="http://"+$cinderhost+":"+$port+"/v2/"+$PROJECT_ID+"/volumes"
$URL
Invoke-RestMethod -uri $URL -body $JSON -Method Post -Headers $headers


