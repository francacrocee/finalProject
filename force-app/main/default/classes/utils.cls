public class utils {
        //Method to retrieve all accounts in which its Billing Postal Code has changed - returns new values - 
        public static List <Account> filterByChangeZipCodeNewValues (List <Account> newAccs, List <Account> oldAccs){

            List<Account> nAccs = new List<Account>();
            //List<Account> oAccs = new List<Account>();
    
            for (Account aNew : newAccs){
                if(oldAccs !=null){
                    for(Account aOld : oldAccs){
                        if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                            nAccs.add(aNew);
                            //oAccs.add(aOld);
                        }
                    }
                }else if(aNew.BillingPostalCode != null){
                    nAccs.add(aNew);
                }
            }
            return nAccs;
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
    
    
}
