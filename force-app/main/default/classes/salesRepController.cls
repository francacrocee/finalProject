public class salesRepController {
    
    public static void updateAccountOwner(List<Account> accs){
    system.debug('Lista que recibo: ' + accs);
        
        //List<Account> accs = [SELECT Id, Name, OwnerId FROM Account WHERE id = :accsId];
        //system.debug('Lista de accounts: ' + accsId);

        List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
        system.debug('My accounts:' + myAccounts);

        List<Territory__c> territories = [SELECT Zip_Code__c, OwnerId FROM Territory__C];
        system.debug('Lista de territories:' + territories);

        List<Account> accToUpdate = new List<Account>();

        for(Account a : myAccounts){
            for(Territory__c t : territories){
                if(a.BillingPostalCode == t.Zip_Code__c){
                    a.OwnerId = t.OwnerId;
                    accToUpdate.add(a);
                    system.debug('account:' + a);
                }
            }
            
        }
        update accToUpdate;

    }


/*@InvocableMethod  
public static void updateAccountOwner(List<id> accsId){
        system.debug('Lista que recibo: ' + accsId);
        
        List<Account> accs = [SELECT Id, Name, OwnerId FROM Account WHERE id = :accsId];
        system.debug('Lista de accounts: ' + accsId);

        List<Account> myAccounts = [SELECT Id, Name, OwnerId, BillingPostalCode FROM Account WHERE id = :accs];
        system.debug('My accounts:' + myAccounts);

        List<Territory__c> territories = [SELECT Zip_Code__c, OwnerId FROM Territory__C];
        system.debug('Lista de territories:' + territories);

        List<Account> accToUpdate = new List<Account>();

        for(Account a : myAccounts){
            for(Territory__c t : territories){
                if(a.BillingPostalCode == t.Zip_Code__c){
                    a.OwnerId = t.OwnerId;
                    accToUpdate.add(a);
                    system.debug('account:' + a);
                }
            }
            
        }
        update accToUpdate;

    }*/

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


    

}
/*
(Account:{
    Id=0015e00000G4BN4AAN,
    IsDeleted=false, 
    MasterRecordId=null, 
    Name=Cuenta de ejemplo para asignaciones,
    Type=null, 
    ParentId=null, 
    BillingStreet=null, 
    BillingCity=null, 
    BillingState=mvd, 
    BillingPostalCode=11800, 
    BillingCountry=Uruguay, 
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
    ShippingGeoc
*/