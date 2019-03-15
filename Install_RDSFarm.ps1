	$RDGatewayServer01 = "GW01TE.totalexotics.com"
	$RDSHost01 = "RDS01TE.totalexotics.com"
	$RDSHost02 = "RDS02TE.totalexotics.com"
	$GatewayAccessGroup = "RDS_Users@totalexotics.com"
	$RDBrokerDNSInternalName = "broker"
	$RDBrokerDNSInternalZone = "totalexotics.com"

    # Configure GW Policies on RDGatewayServer01
    #Invoke-Command -ComputerName $config.RDGatewayServer01 -ArgumentList $config.GatewayAccessGroup, $config.RDBrokerDNSInternalName, $config.RDBrokerDNSInternalZone, $config.RDSHost01, $config.RDSHost02 -ScriptBlock {
        #$GatewayAccessGroup = $args[0]
        #$RDBrokerDNSInternalName = $args[1]
        #$RDBrokerDNSInternalZone = $args[2]
        #$RDSHost01 = $args[3]
        #$RDSHost02 = $args[4]
        Import-Module RemoteDesktopServices
        Remove-Item -Path "RDS:\GatewayServer\CAP\RDG_CAP_AllUsers" -Force -recurse
        Remove-Item -Path "RDS:\GatewayServer\RAP\RDG_RDConnectionBrokers" -Force -recurse
        Remove-Item -Path "RDS:\GatewayServer\RAP\RDG_AllDomainComputers" -Force -recurse
        Remove-Item  -Path "RDS:\GatewayServer\GatewayManagedComputerGroups\RDG_RDCBComputers" -Force -recurse
		
		
		
        New-Item -Path "RDS:\GatewayServer\GatewayManagedComputerGroups" -Name "RDSFarm1" -Description "RDSFarm1" -Computers "$RDBrokerDNSInternalName.$RDBrokerDNSInternalZone" -ItemType "String"
        New-Item -Path "RDS:\GatewayServer\GatewayManagedComputerGroups\RDSFarm1\Computers" -Name $RDSHost01 -ItemType "String"
        New-Item -Path "RDS:\GatewayServer\GatewayManagedComputerGroups\RDSFarm1\Computers" -Name $RDSHost02 -ItemType "String"

        New-Item -Path "RDS:\GatewayServer\RAP" -Name "RDG_RAP_RDSFarm1" -UserGroups $GatewayAccessGroup -ComputerGroupType 0 -ComputerGroup "RDS_SERVERS"
        New-Item -Path "RDS:\GatewayServer\CAP" -Name "RDG_CAP_RDSFarm1" -UserGroups $GatewayAccessGroup -AuthMethod 1

    
    Write-Verbose "Configured CAP & RAP Policies on: $($config.RDGatewayServer01)"  -Verbose

read-host "Configuring CAP & RAP on $($config.RDGatewayServer01) error? Re-run this part of the script before continue"
