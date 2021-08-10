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
        update accToUpdate;
    }*/

 //Requirement #2b
    public static void updateContactOwnerHelper(List<Account> nAccs, List<Account> oAccs){
        List <Account> accs = utils.filterByChangeZipCodeNewValues(nAccs, oAccs);

        if(accs !=null){
            List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id in :accs];
            updateContactOwner(myAccounts);
        }
    }

    public static void updateContactOwner (List<Account> accs){
        List<Contact> ctcs = [SELECT Id, OwnerId, AccountId, name FROM Contact];
        List<Contact> ctcToUpdate = new List<Contact>();
        
        for(Account a : accs){
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
    public static void updateOpenOpportunitiesHelper(List<Account> nAccs, List<Account> oAccs){

        List <Account> accs = utils.filterByChangeZipCodeNewValues(nAccs, oAccs);
        if(accs !=null){
            List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id in :accs];
            updateOpenOpportunities(myAccounts);
            }
    }

    public static void updateOpenOpportunities(List<Account> accs){
        List<Opportunity> opps = [SELECT accountId, ownerId, stageName from opportunity WHERE stageName != 'Closed Lost' AND stageName != 'Closed Won'];
        List<Opportunity> oppToUpdate = new List<Opportunity>();

        for(Opportunity o : opps){
            for(Account a : accs){
                if(o.accountId == a.Id){
                    o.ownerId = a.ownerId;
                    oppToUpdate.add(o);
                }
            }
        }
        update oppToUpdate;
    }


    //Requirement #3
    /*public static void updateAccountOwner(List<Account> nAccs, List<Account> oAccs){
        List <Account> accs = utils.filterByChangeZipCodeNewValues(nAccs, oAccs);
        if(accs !=null){
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
                if(filteredNewTerritories.Size() >0){
                    //create random number to pick an owner
                    Integer random = Integer.valueof(Math.random()*filteredNewTerritories.Size());
                    //assign ownerId
                    a.ownerId = filteredNewTerritories[random].owner__c;
                    //Add updated value to the list
                    accToUpdate.add(a); 
                }
            }
            //Update in database
            update accToUpdate;
        }
    }*/
    public static void updateAccountOwner(List<Account> nAccs, List<Account> oAccs){
        List <Account> accs = utils.filterByChangeZipCodeNewValues(nAccs, oAccs);
        if(accs !=null){
            //Get all accounts with information I need
            List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
            assignRandomOwner(myAccounts);           
        }
    }

    public static void assignRandomOwner(List<Account> myAccounts){

        List<Territory__c> allTerritories =[SELECT Zip_Code__c, Owner__c FROM Territory__C];
        List<Territory__c> filteredNewTerritories = new List<Territory__c>();

        //Create an empty list to update with new values
        List<Account> accToUpdate = new List<Account>();
        
        //Iterate over accounts
        for(Account a : myAccounts){
            for(Territory__c t : allTerritories){
                if(a.BillingPostalCode == t.Zip_code__c){
                    filteredNewTerritories.add(t);
                }
            } 
            if(filteredNewTerritories.Size() >0){
                //create random number to pick an owner
                Integer random = Integer.valueof(Math.random()*filteredNewTerritories.Size());
                //assign ownerId
                a.ownerId = filteredNewTerritories[random].owner__c;
                //Add updated value to the list
                accToUpdate.add(a); 
            }
        }
        upsert accToUpdate;
    }


    //#Requirement 6
    public static void createAssigmentHistoryRecord(List<Account> nAccs, List<Account> oAccs){
        //Get values from trigger new
        List <Account> newAccs = utils.filterByChangeZipCodeNewValues(nAccs, oAccs);

        if(newAccs !=null){
        //Get values from trigger old
        List <Account> oldAccs = utils.filterByChangeZipCodeOldValues(nAccs, oAccs);
        //Create an empty list to add the records
        List<Assignment_History__c> assHistoryToInsert = new List<Assignment_History__c>();
        List<Territory__c> territories = [SELECT Zip_Code__c, Owner__c FROM Territory__C];
        List <Account> myAccounts = [SELECT OwnerId, BillingPostalCode, CreatedById FROM Account WHERE Id in : newAccs];    
        //Iterate over old and new accounts to create the new record    
        for(Account aNew : myAccounts){
            if(oldAccs != null){
                for(account aOld : oldAccs){
                    if(aNew.Id == aOld.Id){
                        Assignment_History__c ah = new Assignment_History__c();
                        ah.Account__c= aNew.Id;
                        ah.Changed_By__c = aNew.CreatedById;
                        ah.Previous_Owner__c = aOld.OwnerId;
                        ah.New_owner__c = aNew.OwnerId;
                        //Iterate over territories to compare owner and zip code
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
            //if it was an insert
            }else{
                Assignment_History__c ah = new Assignment_History__c();
                ah.Account__c= aNew.Id;
                ah.Changed_By__c = aNew.CreatedById;
                ah.Previous_Owner__c = null;
                ah.New_owner__c = aNew.OwnerId;
                ah.Previous_territory__c = null;
                for(Territory__c t : territories){
                    if(t.Zip_Code__c == aNew.BillingPostalCode && t.Owner__c == aNew.OwnerId){
                        ah.New_Territory__c = t.Id;
                    }
                }
                assHistoryToInsert.add(ah);            
            }
        }
        //add to database
        Insert assHistoryToInsert;
        }
    }

    //Bonus challenge #1
    public static void sendEmailToAccountOwners(List<Account> nAccs, List<Account> oAccs){
        Map<Account, List<User>> accountUser = new Map<Account, List<User>>();
        List<User> usrs = [SELECT email FROM User];


        for(Account nAc : nAccs){
            for(Account oAc : oAccs){
                if(nAc.Id == oAc.Id && nAc.OwnerId != oAc.OwnerId){
                    accountUser.put(nAc, new List<User>());
                    for(User u : usrs){
                        if(u.Id == nAc.OwnerId){
                            accountUser.get(nAc).add(u);
                        }
                        if(u.Id == oAc.OwnerId){
                            accountUser.get(nAc).add(u);
                        }
                    }
                }
            }
        }
        if(!accountUser.isEmpty()){
            system.debug('mi mapa: ' + accountUser);
            sendMailToOwners(accountUser);
        }
    }
/*
    public static void sendMailToOwners(Map<Account, List<User>> usersPerAccount){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        EmailTemplate et=[SELECT id FROM EmailTemplate WHERE Name = 'Account change email template' limit 1];
        for(Account a : usersPerAccount.keySet()){
            List<User> users = usersPerAccount.get(a);
            String[] toAddress = new List<String>();
            for(User u : users){
                toAddress.add(u.Email);
            }
            mail.setToAddresses(toAddress);
            mail.setWhatId(a.Id);
            //mail.setTargetObjectId(a.OwnerId);
            mail.setTargetObjectId('0035e00000C5gH7AAJ'); //contact
            mail.setTemplateId(et.id);
            mail.setSaveAsActivity(false);
                    
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    */
    public static void sendMailToOwners(Map<Account, List<User>> usersPerAccount){
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        EmailTemplate et=[SELECT id FROM EmailTemplate WHERE Name = 'Account change email template' limit 1];
        for(Account a : usersPerAccount.keySet()){
            List<User> users = usersPerAccount.get(a);
            String[] toAddress = new List<String>();
            for(User u : users){
                toAddress.add(u.Email);
            }
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(et.id, a.ownerId, a.id);
            mail.setTargetObjectId(a.ownerId);
            mail.setToAddresses(toAddress);
            mail.setSaveAsActivity(false);
                    
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
/*

  //Requirement #bonus2
  public static void updateAccountOwner2(List<Account> nAccs, List<Account> oAccs){
    List <Account> accs = utils.filterByChangeZipCodeNewValues(nAccs, oAccs);
    if(accs !=null){
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
            //if there is any territory with selected zip code, assign a new account owner
            if(filteredNewTerritories.Size() >0){
                //If there is only one in the territorie's list, assign it
                if(filteredNewTerritories.Size() == 1){
                    a.ownerId = filteredNewTerritories[0].owner__c;
                    //if there is more than one
                }else{
                    //create a map with all accounts per territory
                    map<Territory__c, List<Account>> accsPerTerritory = new map<Territory__c, List<Account>>();
                    List<Account> allAccounts = [SELECT OwnerId FROM Account];
                    for(Territory__c t : filteredNewTerritories){
                        accsPerTerritory.put(t, new List<Account>());
                        for(Account a : allAccounts){
                            if(a.BillingPostalCode == t.Zip_Code__c && a.ownerId == t.owner__c){
                                accsPerTerritory.get(t).add(a);
                            }
                        }
                    }  


                }
                                  
                //assign ownerId
                a.ownerId = filteredNewTerritories[random].owner__c;
                //Add updated value to the list
                accToUpdate.add(a); 
            }
        }
        //Update in database
        update accToUpdate;
    }
}*/
}


/*
map<Territory__c, List<Account>> accsPerTerritory = new map<Territory__c, List<Account>>();
List<Accounts> allAccounts = [SELECT OwnerId FROM Account];
List<Territory> filteredNewTerritories = [SELECT Zip_Code__c, owner__c FROM Territory__c WHERE Zip_Code__c == '11']
for(Territory__c t : filteredNewTerritories){
accsPerTerritory.put(t, new List<Account>());
for(Account a : allAccounts){
    if(a.BillingPostalCode == t.Zip_Code__c && a.ownerId == t.owner__c){
accsPerTerritory.get(t).add(a);
    }
}
}  
 */