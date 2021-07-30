public with sharing class territoryController {
    
    //Requirement #4
    public static Boolean verifyMaxSalesRepForZipCode(List<Territory__c> territories){
        system.debug('territories: ' + territories);
        
        Boolean lessThan3 = true;
        Boolean canUpdate = true;
        Boolean alreadyExists = false;
        
        List<Territory__c> sameTerritory = new List<Territory__c>();
        List<Territory__c> filteredTerritories = [SELECT Zip_Code__c, owner__c FROM Territory__c];


        //Iteartes over recieved list and over all records list compareing zip code.
        String actualZipCode ='';
        for(Territory__c t : territories){
            for(Territory__c f : filteredTerritories){
                if(t.Zip_Code__c == f.Zip_Code__c){
                    system.debug('zc1: ' + t.Zip_Code__c + ' - zc2: ' + f.Zip_Code__c);
                    //Add same zipcodes to a temporary list to check quantity
                    sameTerritory.add(f);
                }

            }
            system.debug('Same territory' + sameTerritory);
            if(sameTerritory.Size()>=3){
                system.debug('size: ' + sameTerritory.Size());
                lessThan3 = false;
            }else{
                for(Territory__c j : sameTerritory){
                    system.debug('owner1: ' + t.owner__c + ' - owner2: ' + j.owner__c);
                    if(t.owner__c == j.owner__c){
                        alreadyExists = true;
                    }
                }
            }

            sameTerritory.clear();
            //if any time lessThan3 variable is set to false, canUpdate variable will be set to false and the insert wont be done
            if(! lessThan3 || alreadyExists){
                system.debug('Entra al if y devuelve false');
                canUpdate = false;
            }
        }

        return canUpdate;
        
    }
}