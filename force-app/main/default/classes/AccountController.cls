public class AccountController {
    
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
    public static void updateContactOwner(List<Account> accs){
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
    public static void updateOpenOpportunities(List<Account> accs){

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
    public static void updateAccountOwner(List<Account> accs){
    
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
/*    public static void createAssigmentHistoryRecord(List<Account> newAccs){

        List<Assignment_History__c> assHistoryToInsert = new List<Assignment_History__c>();

        //Get all territories
        List<Territory__c> territories =[SELECT Zip_Code__c, Owner__c FROM Territory__C];
        //List<Territory__c> filteredNewTerritories = new List<Territory__c>();
        //Iterate over recieved NEW accounts and over territories to obtain the list of territories in my accounts
        /*for(Account a : newAccs){
            for(Territory__c t : territories){
                if(a.BillingPostalCode == t.Zip_Code__c && a.OwnerId == t.owner__c){
                    system.debug(1);
                    filteredNewTerritories.add(t);
                }
            }
        }*/

    /*    List<Territory__c> filteredOldTerritories = new List<Territory__c>();
        for(Account a : newAccs){
            for(Territory__c t : territories){
                if(a.BillingPostalCode == t.Zip_Code__c && a.OwnerId == t.owner__c){
                    system.debug(2);
                    filteredOldTerritories.add(t);
                }
            }
        }*/

        //Get all territories history for my territories List
        //List<Territory__History> filteredTh = [SELECT Field,Id,NewValue,OldValue,ParentId FROM Territory__History WHERE ParentId IN :filteredNewTerritories];
        //Get all accounts history for my accounts List
        /*List<AccountHistory> filteredAh = [SELECT AccountId,CreatedDate,DataType,Field,Id,NewValue,OldValue FROM AccountHistory WHERE AccountId in :newAccs ORDER BY createdDate desc];
        List<User> users = [select name, Id from User];

        for(Account a : newAccs){
            for(AccountHistory ah : filteredAh){
                if(a.Id == ah.AccountId){
                    system.debug(3);
                    Assignment_History__c assHis = new Assignment_History__c();
                    assHis.Account__c= a.Id;
                    assHis.Changed_By__c = a.CreatedById;

                    if(ah.Field == 'Owner' && ah.DataType == 'EntityId'){
                        system.debug(4);
                        for(User u : users){
                            if(u.Id == ah.OldValue){
                                system.debug(5);
                                assHis.Previous_Owner__c = u.Id;
                                assHis.New_owner__c = a.OwnerId;

                            }
                        }                        
                    }
                    if(ah.Field == 'BillingPostalCode'){
                        system.debug(6);
                        for(Territory__c t : territories){
                            system.debug('t.zipcode: '+t.Zip_Code__c);
                            system.debug('ah.OldValue: '+ ah.OldValue);
                            system.debug('t.Owner__c: '+ t.Owner__c);
                            
                            if(t.Zip_Code__c == ah.OldValue && t.Owner__c == assHis.Previous_Owner__c){
                                system.debug(7);
                                assHis.Previous_Territory__c = t.Id;
                            }
                            if(t.Zip_Code__c == ah.NewValue && t.Owner__c == assHis.New_owner__c){
                                system.debug(8);
                                assHis.New_Territory__c = t.Id;
                            }
                        }
                    }
                    assHistoryToInsert.add(assHis);
                    system.debug('Nuevo Objeto: ' + assHis);
                }
            }
        }

        system.debug('List to insert: ' + assHistoryToInsert);    
        insert assHistoryToInsert;
            

    }*/
    //#Requirement 6
    public static void createAssigmentHistoryRecord(List<Account> newAccs, List<Account> oldAccs){

        List<Assignment_History__c> assHistoryToInsert = new List<Assignment_History__c>();
        List<Territory__c> territories = [SELECT Zip_Code__c, Owner__c FROM Territory__C];

        for(Account aNew : newAccs){
            for(account aOld : oldAccs){
                if(aNew.Id == aOld.Id){
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
                            ah.Previous_territory__c = t.Id;
                        }
                    }
                    assHistoryToInsert.add(ah);
                }
            }
        }
        Insert assHistoryToInsert;
    }

}
 