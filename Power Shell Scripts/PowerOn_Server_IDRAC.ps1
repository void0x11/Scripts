# Define iDRAC credentials and IP address
$idracIP = "0.0.0.0"
$username = "root"
$password = "Passw@rd"

# Power on command using racadm
$command = "racadm -r $idracIP -u $username -p $password serveraction powerup"

# Execute the command
Invoke-Expression $command
