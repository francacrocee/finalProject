public with sharing class territoryController {
    
    //Requirement #4
    public static Boolean verifyMaxSalesRepForZipCode(List<Territory__c> territories){
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
                    //Add same zipcodes to a temporary list to check quantity
                    sameTerritory.add(f);
                }

            }
            if(sameTerritory.Size()>=3){
                lessThan3 = false;
            }else{
                for(Territory__c j : sameTerritory){
                    if(t.owner__c == j.owner__c){
                        alreadyExists = true;
                    }
                }
            }
            sameTerritory.clear();
            //if any time lessThan3 variable is set to false, canUpdate variable will be set to false and the insert wont be done
            if(! lessThan3 || alreadyExists){
                canUpdate = false;
            }
        }
        return canUpdate;
    }

    //Requirement #7
    public static void updateSalesRepInRelatedRecords (List<Territory__c> newTerritories, List<Territory__c> oldTerritories ){
        SYSTEM.DEBUG('ESTOY EN RELATED RECORDS');
        //get filtered territories by those who change its sales Rep
        List<Territory__c> filteredList = utils.filterByChangeSalesRep(newTerritories, oldTerritories);
        
        //If the list is not null
        if(filteredList !=null){
            //Get territories in trigger.old which id is present in filtered territories
            List<Territory__c> oldTerrs = new List<Territory__c>();
            for(Territory__c t : oldTerritories){
                for (Territory__c nt : filteredList){
                    if(nt.Id == t.Id){
                        oldTerrs.add(t);
                    }
                }
            }
            //get all accounts whith those owners and zip codes
            List <Account> accounts = [SELECT ownerId, BillingPostalCode, name FROM Account];
            //create an empty list to retrieve
            List <Account> modifiedAccs = new List<Account>();
            //iterate over territories to find related accounts 
            for(Territory__c ter : filteredList){
                for(Territory__c ot : oldTerrs){
                    for(Account a : accounts){
                        // if zip code and owner are the same in te account and territory, assign the new territory owner to this account.
                        if(ot.Owner__c == a.OwnerId && ter.Zip_Code__c == a.BillingPostalCode){
                            a.OwnerId = ter.owner__C;
                            modifiedAccs.add(a);                    
                        }
                    }
                }
            }
            update modifiedAccs;
            //Call the methods I have to change related sales rep in accounts
            AccountController.updateContactOwner(modifiedAccs);
            AccountController.updateOpenOpportunities(modifiedAccs);
        }
    }
}
