public class salesRepController {
    
    public static void updateAccountOwner(List<Account> accs){
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

    }


    public static void updateContactOwner(List<Account> accs){

        system.debug('Lista que recibo en contact owner: ' + accs);

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
        system.debug('Lista para actualizar ctct: ' + ctcToUpdate);
        update ctcToUpdate;
    }

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
}
