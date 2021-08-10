global class verifyAccountOwners implements Schedulable {
    global void execute (SchedulableContext ctx){
        List<Account> accts = [SELECT BillingPostalCode, OwnerId FROM Account];
        List<Territory__c> trrts = [SELECT Zip_Code__c, Owner__c FROM Territory__c];
        Boolean assignedToProperOwner = false;

        List<Territory__c> filteredTerritories = new List<Territory__c>();
        List<Account> accToUpdate = new List<Account>();
                
        for(Account a : accts){
            for(Territory__c t : trrts){
                if(a.BillingPostalCode == t.Zip_Code__c && a.OwnerId == t.owner__c){
                    assignedToProperOwner = true;                
                }
            }
            if(!assignedToProperOwner){
                accToUpdate.add(a);
            }
        }
        system.debug('accToUpdate ' + accToUpdate);
        if(accToUpdate !=null){
            AccountController.assignRandomOwner(accToUpdate);
        }
    }
}

            