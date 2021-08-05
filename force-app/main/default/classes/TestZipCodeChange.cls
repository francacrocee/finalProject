@isTest
public class TestZipCodeChange {

    @isTest
    static void TestAccountOwnerAssignationInsert(){
        //List<Account> accs = TestDataFactory.createAccounts();
        List<Territory__c> trrt = TestDataFactory.createTerritories();
        insert trrt;
        List<Account> accs = new List<Account>();
        Account a = New Account (Name = 'Account 1', BillingPostalCode = '1001');
        accs.add(a);
        
        Test.startTest();
        Database.SaveResult[] accsResults = Database.insert(accs);
        Test.StopTest();

        Account ac = [SELECT BillingPostalCode, OwnerId FROM Account WHERE Name = 'Account 1'];
        User u = [SELECT username FROM User WHERE Username = 'usrdp344754396@fake123.com'];

    }

    @isTest
    static void TestAccountOwnerAssignationUpdate(){
        List<Account> accs = TestDataFactory.createAccounts();
        insert accs;
        List<Territory__c> trrt = TestDataFactory.createTerritories();
        insert trrt;
        Account a = [SELECT OwnerId, BillingPostalCode, Name FROM Account WHERE Name = 'Account 1'];
        a.BillingPostalCode = '1002';
        
        Test.startTest();
        Database.update(a);
        Test.StopTest();

        Account ac = [SELECT BillingPostalCode, OwnerId FROM Account WHERE Name = 'Account 1'];
        User u = [SELECT username FROM User WHERE Username = 'usrdp44754396@fake123.com'];

        //Check if account owner has change
        system.assertEquals(u.Id, ac.OwnerId);
    }

    @isTest
    static void TestContactOwnerChange(){
        
        List<Account> accs = TestDataFactory.createAccounts();
        insert accs;
        List<Contact> contacts = TestDataFactory.createContactsWithAccs(accs);
        List<Territory__c> trrt = TestDataFactory.createTerritories();
        insert trrt;
        Account a = [SELECT OwnerId, BillingPostalCode, Name FROM Account WHERE Name = 'Account 1'];
        a.BillingPostalCode = '1002';
        
        Test.startTest();
        Database.update(a);
        Test.StopTest();

        Account ac = [SELECT BillingPostalCode, OwnerId FROM Account WHERE Name = 'Account 1'];
        User u = [SELECT username FROM User WHERE Username = 'usrdp44754396@fake123.com'];
        //Check if account owner has change
        List<Contact> ctcs = [SELECT OwnerId FROM Contact WHERE accountId = :ac.Id];
        for(Contact c : ctcs){
            system.assertEquals(c.OwnerId, ac.OwnerId);
        }
        
    }
 @isTest
    static void TestOpenOppsOwnerChange(){
        
        List<Account> accs = TestDataFactory.createAccounts();
        insert accs;
        List<Opportunity> opportunities = TestDataFactory.createOppsWithAccs(accs);
        List<Territory__c> trrt = TestDataFactory.createTerritories();
        insert trrt;
        Account a = [SELECT OwnerId, BillingPostalCode, Name FROM Account WHERE Name = 'Account 1' LIMIT 1];
        system.debug('account: '+ a);
        a.BillingPostalCode = '1002';
        
        Test.startTest();
        Database.update(a);
        Test.StopTest();

        Account ac = [SELECT BillingPostalCode, OwnerId FROM Account WHERE Name = 'Account 1'];
        User u = [SELECT username FROM User WHERE Username = 'usrdp44754396@fake123.com'];

        List<Opportunity> openOpps = [SELECT accountId, ownerId, stageName from opportunity WHERE stageName != 'Closed Lost' AND stageName != 'Closed Won'];
        system.debug('openopps: ' + openOpps);
        List<Opportunity> opps = new List<Opportunity>();
        for(Opportunity o : openOpps){
            if(o.AccountId == ac.Id){
                opps.add(o);
            }
        }
        system.debug('opps: ' + opps);
        for(Opportunity op : opps){
            system.assertEquals(op.ownerId, ac.OwnerId);
        }

    }

    
}
