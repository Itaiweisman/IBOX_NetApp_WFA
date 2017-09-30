$first=ssh root@cinder2 '. /root/keystonerc_admin ; openstack token issue' | select-string ' id '
$second=$first.ToString()
$second
$third=$second | %{ $_.Split('|')[2]; }
$forth=$third.trim(' ')
$forth
