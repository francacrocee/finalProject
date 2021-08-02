public class AccountController {

    //Method to retrieve all accounts in which its Billing Postal Code has changed - returns new values - 
    public static List <Account> filterByChangeZipCodeNewValues (List <Account> newAccs, List <Account> oldAccs){

        List<Account> nAccs = new List<Account>();
        //List<Account> oAccs = new List<Account>();
    
        for (Account aNew : newAccs){
            for(Account aOld : oldAccs){
                if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                    nAccs.add(aNew);
                    //oAccs.add(aOld);
                }
            }
        }
        return nAccs;
    } 

    //Method to retrieve all accounts in which its Billing Postal Code has changed - returns OLD values - 
    public static List <Account> filterByChangeZipCodeOldValues (List <Account> newAccs, List <Account> oldAccs){

        //List<Account> nAccs = new List<Account>();
        List<Account> oAccs = new List<Account>();
    
        for (Account aNew : newAccs){
            for(Account aOld : oldAccs){
                if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                    //nAccs.add(aNew);
                    oAccs.add(aOld);
                }
            }
        }
        return oAccs;
    } 
        
    
    
    
    
    //Requirement #2a
    /*public static void updateAccountOwner(List<Account> accs){
    system.debug('Lista que recibo en account owner: ' + accs);
        
        List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
        system.debug('My accounts:' + myAccounts);

        List<Territory__c> territories = [SELECT Zip_Code__c, OwnerId, Owner__c FROM Territory__C];
        system.debug('Lista de territories:' + territories);

        List<Account> accToUpdate = new List<Account>();

        for(Account a : myAccounts){
            for(Territory__c t : territories){
                if(a.BillingPostalCode == t.Zip_Code__c){
                    a.OwnerId = t.Owner__c;
                    accToUpdate.add(a);
                    system.debug('account:' + a);
                }
            }
            
        }

        system.debug('Lista para actualizar acct: ' + accToUpdate);
        update accToUpdate;

    }*/

 //Requirement #2b
    public static void updateContactOwner(List<Account> nAccs, List<Account> oAccs){

        List <Account> accs = filterByChangeZipCodeNewValues(nAccs, oAccs);


        List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
        List<Contact> ctcs = [SELECT Id, OwnerId, AccountId FROM Contact];
        List<Contact> ctcToUpdate = new List<Contact>();

        for(Account a : myAccounts){
            for(Contact c : ctcs){
                if(c.AccountId == a.Id){
                    c.OwnerId = a.OwnerId;
                    ctcToUpdate.add(c);
                }
            }
        }
        update ctcToUpdate;
    }

    //Requirement #2c
    public static void updateOpenOpportunities(List<Account> nAccs, List<Account> oAccs){

        List <Account> accs = filterByChangeZipCodeNewValues(nAccs, oAccs);

        List<Opportunity> opps = [SELECT accountId, ownerId, stageName from opportunity WHERE stageName != 'Closed Lost' AND stageName != 'Closed Won'];
        List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
        List<Opportunity> oppToUpdate = new List<Opportunity>();

        for(Opportunity o : opps){
            for(Account a : myAccounts){
                if(o.accountId == a.Id){
                    o.ownerId = a.ownerId;
                    oppToUpdate.add(o);
                }
            }
        }
        update oppToUpdate;
    }

    //Requirement #3
    public static void updateAccountOwner(List<Account> nAccs, List<Account> oAccs){

        List <Account> accs = filterByChangeZipCodeNewValues(nAccs, oAccs);
    
        //Get all accounts with information I need
        List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
        
        //Create an empty list to update with new values
        List<Account> accToUpdate = new List<Account>();

        List<Territory__c> allTerritories =[SELECT Zip_Code__c, Owner__c FROM Territory__C];
        List<Territory__c> filteredNewTerritories = new List<Territory__c>();

        //Iterate over accounts
        for(Account a : myAccounts){
            for(Territory__c t : allTerritories){
                if(a.BillingPostalCode == t.Zip_code__c){
                    filteredNewTerritories.add(t);
                }
            } 
            //create random number to pick an owner
            Integer random = Integer.valueof(Math.random()*(filteredNewTerritories.Size()+1));
            system.debug('random number: ' + random);
            //assign ownerId
            a.ownerId = filteredNewTerritories[random].owner__c;
            system.debug('ownerId: ' + a.ownerId);
            //Add updated value to the list
            accToUpdate.add(a); 
        }
        //Update in database
        update accToUpdate;
    }

    //#Requirement 6
    public static void createAssigmentHistoryRecord(List<Account> nAccs, List<Account> oAccs){

        List <Account> newAccs = filterByChangeZipCodeNewValues(nAccs, oAccs);
        List <Account> oldAccs = filterByChangeZipCodeOldValues(nAccs, oAccs);

        
        List<Account> newAccsFULL = [SELECT Id, CreatedById, OwnerId, BillingPostalCode FROM Account WHERE Id in :newAccs];

        List<Assignment_History__c> assHistoryToInsert = new List<Assignment_History__c>();
        List<Territory__c> territories = [SELECT Zip_Code__c, Owner__c FROM Territory__C];

        for(Account aNew : newAccsFULL){
            for(account aOld : oldAccs){
                if(aNew.Id == aOld.Id){
                    system.debug('Nueva account: ' + aNew);
                    Assignment_History__c ah = new Assignment_History__c();
                    ah.Account__c= aNew.Id;
                    ah.Changed_By__c = aNew.CreatedById;
                    ah.Previous_Owner__c = aOld.OwnerId;
                    ah.New_owner__c = aNew.OwnerId;
                    for(Territory__c t : territories){
                        if(t.Zip_Code__c == aOld.BillingPostalCode && t.Owner__c == aOld.OwnerId){
                            ah.Previous_territory__c = t.Id;
                        }
                        if(t.Zip_Code__c == aNew.BillingPostalCode && t.Owner__c == aNew.OwnerId){
                            ah.New_Territory__c = t.Id;
                        }
                    }
                    assHistoryToInsert.add(ah);
                }
            }
        }
        Insert assHistoryToInsert;
    }

}
 /*
 Account:
 {Id=0015e00000FdmTdAAJ, 
    IsDeleted=false, 
    MasterRecordId=null, 
    Name=sForce, 
    Type=null, 
    ParentId=null, 
    BillingStreet=The Landmark @ One Market, 
    BillingCity=San Francisco,
    BillingState=CA, 
    BillingPostalCode=123, 
    BillingCountry=US, 
    BillingLatitude=null, 
    BillingLongitude=null, 
    BillingGeocodeAccuracy=null, 
    ShippingStreet=null, 
    ShippingCity=null, 
    ShippingState=null, 
    ShippingPostalCode=null, 
    ShippingCountry=null, 
    ShippingLatitude=null, 
    ShippingLongitude=null, 
    ShippingGeocodeAccura
 */