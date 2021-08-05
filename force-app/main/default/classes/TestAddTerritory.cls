@IsTest
public class TestAddTerritory {
    
    private final static string ERROR_MESSAGE = 'Can not add this territory, check conditions or contact the administrator'; 

    @isTest
    static void TestAddNewTerritory(){
    List<Territory__c> trrt =  TestDataFactory.createTerritories();    
    
    Test.startTest();
    Database.SaveResult[] result = Database.insert(trrt);
    Test.StopTest();

    for(Database.SaveResult dr : result){
        System.assert(dr.isSuccess());
        System.assert(dr.getErrors().size() == 0);
    }
}

//Test not to add a zipcode with more than 3 sales rep
    @isTest
    static void TestAddMoreThan3SalesRepToSameZipCode(){

        List<Territory__c> trrt = TestDataFactory.createTerritories();   
        insert trrt;

        List<User> users = [SELECT username FROM User];
        
        List<Territory__c> newTrrt = new List<Territory__c>(); 
        Territory__c t = new Territory__c(Name='Territory 1', Owner__c = Users[2].Id, Zip_Code__c = '1003');
        newTrrt.add(t);
            
        Test.startTest();
        Database.SaveResult[] result = Database.insert(newTrrt, false);
        Test.StopTest();
    
        boolean hasError = false;

        for(Database.SaveResult dr : result){
            System.assert(!dr.isSuccess());
            System.assert(dr.getErrors().size() > 0);
            for(Database.Error err : dr.getErrors()) {
                if(err.getMessage() == ERROR_MESSAGE) {
                    hasError = true;
                }
            }
        }
        System.assertEquals(true, hasError);
    }

    @isTest
    public static void TestUpdateTerritory(){
        List<Territory__c> trrt = TestDataFactory.createTerritories();   
        insert trrt;
        //List<User> users = [SELECT username FROM User];
        Territory__C terr = [SELECT Name, Zip_Code__c FROM Territory__c WHERE Name = 'Territory 3' LIMIT 1];
        terr.Zip_Code__c = '1004';

        List<Territory__c> trtList = new List<Territory__c>();
        trtList.add(terr);

        Test.startTest();
        Database.SaveResult result = Database.update(terr);
        Test.StopTest();

        Territory__c t = [SELECT Name, Zip_Code__c FROM Territory__c WHERE Name = 'Territory 3' LIMIT 1];

        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals('1004', t.Zip_Code__c);
    }
 
    @isTest
    public static void updateSalesRepInTerritory(){
        List<Territory__c> trrt = TestDataFactory.createTerritories();   
        insert trrt;
        //List <Account> accounts = TestDataFactory.createAccounts();
        //insert accounts;
        List<Account> accs = new List<Account>();
        Account a = New Account (Name = 'Account 1', BillingPostalCode = '1001');
        insert a;

        User usr = [SELECT Id FROM User WHERE Username='usrdp244754396@fake123.com'];
        Territory__C terr = [SELECT Name, Zip_Code__c, Owner__c FROM Territory__c WHERE Name = 'Territory 3' LIMIT 1];
        terr.Owner__c= usr.Id;

        
        Test.startTest();
        Database.SaveResult result = Database.update(terr);
        Test.StopTest();

        Account updatedAcc = [SELECT OwnerId, BillingPostalCode FROM Account WHERE Id= :a.Id];
        system.assertEquals(usr.Id, updatedAcc.OwnerId);
        
    }


}
