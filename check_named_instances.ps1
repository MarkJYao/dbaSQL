# Update $servers_original before running
$servers_original = @()

Function Check_Instance_With_IN1_IN2
{
    # This array resets for each server to store instances temporarily
    $each_server_instances = @()
    # Dynamically checking multiple instances
    $servers = @()
    ForEach ($server in $servers_original) {
        $installedinstance = Invoke-Command -ComputerName $server -ErrorAction Stop -ScriptBlock {(Get-Itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances}
        $each_server_instances += $installedinstance
        ForEach ($each_instance in $each_server_instances) {
            If ($each_instance -eq 'MSSQLSERVER') { 
                $servers += $server 
            }
            Else {
                $servers += $server + '\' + $each_instance
            }
        }
        $each_server_instances = @()    
    }
    $servers
}

Check_Instance_With_IN1_IN2
