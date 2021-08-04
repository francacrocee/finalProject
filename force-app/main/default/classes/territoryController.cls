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


    //Requirement #7
    public static void updateSalesRepInRelatedRecords (List<Territory__c> newTerritories, List<Territory__c> oldTerritories ){
        //get filtered territories by those who change its sales Rep
        List<Territory__c> filteredList = utils.filterByChangeSalesRep(newTerritories, oldTerritories);
        system.debug('filteredList: ' + filteredList);
        
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
            
            system.debug('oldTerrs: ' + oldTerrs);
            //get all accounts whith those owners and zip codes
            List <Account> accounts = [SELECT ownerId, BillingPostalCode, name FROM Account];
            //create an empty list to retrieve
            List <Account> modifiedAccs = new List<Account>();
            system.debug('Accounts: ' + accounts); 
            //iterate over territories to find related accounts 
            for(Territory__c ter : filteredList){
                for(Territory__c ot : oldTerrs){
                    for(Account a : accounts){
                        // if zip code and owner are the same in te account and territory, assign the new territory owner to this account.
                        system.debug('ot.Owner__c: ' + ot.Owner__c);
                        system.debug('a.OwnerId: ' + a.OwnerId);
                        system.debug('ter.Zip_Code__c: ' + ter.Zip_Code__c);
                        system.debug('a.BillingPostalCode: ' + a.BillingPostalCode);
                        if(ot.Owner__c == a.OwnerId && ter.Zip_Code__c == a.BillingPostalCode){
                            system.debug('asigno a ' + a.name + ' el owner: ' + ter.owner__c);
                            a.OwnerId = ter.owner__C;
                            modifiedAccs.add(a);                    
                        }
                    }
                }

            }
            update modifiedAccs;
            system.debug('mod accounts: ' + modifiedAccs);
            //Call the methods I have to change related sales rep in accounts
            AccountController.updateContactOwner(modifiedAccs);
            AccountController.updateOpenOpportunities(modifiedAccs);
        }

    }
}
/**
 filteredList:
 (Territory__c:{
     Id=a005e000002joN1AAI, 
     OwnerId=0055e000002fTz8AAE, 
     IsDeleted=false, 
     Name=ter4, 
     CreatedDate=2021-07-30 14:58:42, 
     CreatedById=0055e000002fTz8AAE, 
     LastModifiedDate=2021-08-04 12:57:34, 
     LastModifiedById=0055e000002fTz8AAE, 
     SystemModstamp=2021-08-04 12:57:34, 
     LastViewedDate=null, 
     LastReferencedDate=null, 
     Zip_Code__c=11, 
     Owner__c=0055e000002fomKAAQ})


-----------------------------------
filteredList: (
    Territory__c:{
        Id=a005e000002joN1AAI, 
        OwnerId=0055e000002fTz8AAE, 
        IsDeleted=false, 
        Name=ter4, 
        CreatedDate=2021-07-30 14:58:42, 
        CreatedById=0055e000002fTz8AAE, 
        LastModifiedDate=2021-08-04 13:05:35, 
        LastModifiedById=0055e000002fTz8AAE, 
        SystemModstamp=2021-08-04 13:05:35, 
        LastViewedDate=null, 
        LastReferencedDate=null, 
        Zip_Code__c=11, 
        Owner__c=0055e000002fomKAAQ})

    oldTerrs: (
        Territory__c:{
            Owner__c=0055e000002fomKAAQ, 
            Zip_Code__c=11, 
            Id=a005e000002joN1AAI})

 */