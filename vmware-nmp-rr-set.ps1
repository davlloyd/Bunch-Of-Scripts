
## Enter the name of the cluster containing hosts you want to change the default PSP on
$strClusterName = "YourCluster"

## Array of SATPs to change
$arrSATPsToChange = @"
VMW_SATP_CX
VMW_SATP_SYMM
"@.Split("`n")

## Define the PSP you want to set on each SATP above (Examples: VMW_PSP_FIXED_AP, VMW_PSP_MRU, VMW_PSP_RR, VMW_PSP_FIXED)
$strPSPName = "VMW_PSP_RR"


## Get all VMHosts in chosen cluster and change the PSP to RR
Get-Cluster -Name $strClusterName | Get-VMHost | Sort-Object Name | ForEach-Object {
    ## Grab EsxCli info for a host
    $objEsxCli = Get-EsxCli -VMHost $_
    ## Change predefined SATPs to the new PSP first by traversing all available SATPs looking for matches
    $objEsxCli.storage.nmp.satp.list() | %{
        $objCurrentSATP = $_
        ## Only change the SATP if it isn't already set correctly and if it is included in our predefined list of SATPs to change
        if (($objCurrentSATP.DefaultPSP -ne $strPSPName) -and ($arrSATPsToChange -contains $objCurrentSATP.Name)) {
            ## List matching SATP before changing its default PSP
            $objCurrentSATP
            ## Change matching SATP to the pre-defined PSP
            $objEsxCli.storage.nmp.satp.set($null,$strPSPName,$objCurrentSATP.Name)
        }
    }
}