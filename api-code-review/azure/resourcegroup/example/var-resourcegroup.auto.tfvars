## NOTE: Read all given instructions before updating the values to get the resources created in first run.

resource_groups = {
  "rg1" = {                        
    rg_name = " mgb-xxxx-nonprod-xxx-e2-rg"                   # Resource group name
    location = "eastus"                       # (Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.
    tags = {                                     # (Optional) A mapping of tags which should be assigned to the Resource Group.
      BusinessUnit = ""
      CostCenter = ""
      Criticality = "Non-production"
      Environment = "Non-production"
      ManagedBy = ""
      BusinessOwner = ""
      Entity = "MGB"
      Application =""
      FundNumber = ""
      DataClassification = "confidential"
      EndDate = "conditional"
      Department = ""
      TechnicalOwner = ""

      }
    }
}  