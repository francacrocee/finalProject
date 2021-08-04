public class utils {

    //Method to retrieve all accounts in which its Billing Postal Code has changed - returns new values - 
    public static List <Account> filterByChangeZipCodeNewValues (List <Account> newAccs, List <Account> oldAccs){

        List<Account> nAccs = new List<Account>();

        for (Account aNew : newAccs){
            if(oldAccs !=null){
                for(Account aOld : oldAccs){
                    if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                        nAccs.add(aNew);
                        system.debug('agregó la cuenta: ' + aNew.Name);
                        
                    }
                }
            }else if(aNew.BillingPostalCode != null){
                    nAccs.add(aNew);
            }
        }
        if(nAccs.size()>0){
            system.debug('utils devuelve: ' + nAccs.size() + ' accounts');
            return nAccs;
        }else{
            system.debug('utils devuelve null');
            return null;
        }
            
    } 
    
    //Method to retrieve all accounts in which its Billing Postal Code has changed - returns OLD values - 
    public static List <Account> filterByChangeZipCodeOldValues (List <Account> newAccs, List <Account> oldAccs){
    
            //List<Account> nAccs = new List<Account>();
            List<Account> oAccs = new List<Account>();
    
            if(oldAccs !=null){
    
            }else{
                return null;
            }
    
            
            for (Account aNew : newAccs){
                if(oldAccs !=null){
                    for(Account aOld : oldAccs){
                        if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                            //nAccs.add(aNew);
                            oAccs.add(aOld);
                        }
                    }
                }else if(aNew.BillingPostalCode != null){
                    //nAccs.add(aNew);
                    oAccs.add(aNew);
                }
            }
            return oAccs;
        }


    //Method to get all territories that its sales rep is changed
    public static List<Territory__c> filterByChangeSalesRep (List<Territory__c> newTerr, List<Territory__c> oldTerr){
        List<Territory__c> nTerr = new List<Territory__c>();

        for (Territory__c tNew : newTerr){
            if(oldTerr !=null){
                for(Territory__c tOld : oldTerr){
                    if(tNew.Owner__c != told.Owner__c){
                        nTerr.add(tNew);
                    }
                }
            }
        }
        return nTerr;
    }
     
}
