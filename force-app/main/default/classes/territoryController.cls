public with sharing class territoryController {
    
    //Requirement #4
    public static Boolean verifyMaxSalesRepForZipCode(List<Territory__c> territories){
        system.debug('territories: ' + territories);
        
        Boolean canUpdate = true;
        List<Territory__c> trrtsToAdd = new List<Territory__c>();

        for(Territory__c t : territories){
            List<Territory__c> filteredTerritories = [SELECT Zip_Code__c, owner__c FROM Territory__c where Zip_Code__c = :t.Zip_Code__c];
            system.debug('filteredTerritories' + filteredTerritories);
            system.debug('territory size: ' + filteredTerritories.Size());
            

            if(filteredTerritories.Size()>=3){
                canUpdate = false;
                
            }
        }
        return canUpdate;
        
    }
}
