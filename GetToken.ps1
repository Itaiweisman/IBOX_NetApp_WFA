$password="adpass"
$domain="default"
$cinderhost="cinder2"
$auth_port=5000
$user="admin"
function GetToken
{
        $url="http://"+$cinderhost+":"+$auth_port+"/v3/auth/tokens"
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", 'application/json')
        $JSON= @{
        "auth"= @{
        "identity"= @{
        "methods" = {
        "password"
        }
        "password" = @{
        "user" = @{
          "name" = "$user"
          "domain" = @{
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
GetToken
