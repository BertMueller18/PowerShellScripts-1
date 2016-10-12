﻿# Get all running instances in all regions following Don Jones toomaking part guide

$Regions = Get-EC2Region
ForEach ( $Region in $Regions ) 
{
    try 
    {
        $RegionName = $Region.RegionName
        Set-DefaultAWSRegion -Region $RegionName -ErrorAction Stop
        $Instances = (Get-EC2Instance).Instances
        $InstancesCount = $Instances.count 
        if ($InstancesCount -gt 0)
        { 
            ForEach ($instance in $Instances) 
            {
                $InstanceProperties = @{RegionName = $RegionName
                                        RegionStatus = 'Available'
                                        InstanceID = $Instance.imageid
                                        InstanceType = $Instance.InstanceType
                                        KeyName = $Instance.KeyName
                                        LaunchTime = $Instance.LaunchTime}
                # $InstanceProperties = $Instances | select InstanceID,InstanceType,KeyName,LaunchTime | fl
            }
        }
    }
    catch
    {
        Write-Warning "AWS is having problems to connect to region $RegionName"
        $InstanceProperties = @{RegionName = $RegionName
                                RegionStatus = 'Unvailable'
                                InstanceID = $null
                                InstanceType = $null
                                KeyName = $null
                                LaunchTime = $null} 
    }
    finally
    {
        if ($instances.count -gt 0)
        {
            $obj = New-Object -TypeName PSObject -Property $InstanceProperties
            if ($InstancesCount -eq 1)
            {
                Write-Output "$InstancesCount instance found in $RegionName"
            }
            else
            {
                Write-Output "$InstancesCount instances found in $RegionName"
            }
            Write-Output $obj
        }
        Else
        {
            Write-Output "There are no instances in region $RegionName"
        }
    }
}

# for output play with simple select, maybe as | fl
# with select option script needs to be changed as $obj has to be removed