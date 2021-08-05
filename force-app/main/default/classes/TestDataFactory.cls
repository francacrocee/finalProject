@isTest
public class TestDataFactory {
    
    public static List<Account> createAccounts(){
        List<Account> acc = new List<Account>();
         for (integer i=1; i<10; i++){
             Account a = new Account(Name = 'Account ' + i, BillingPostalCode = '100' + i);
             acc.add(a);
         }
         //insert acc;
         return acc;
    }

    public static List<User> createUsers(){
        List<User> users = new List<User>();

    User u1 = new user(Username='usrdp44754396@fake123.com', 
                    FirstName='Usuario de prueba', 
                    LastName= 'test', 
                    Email='Udp@fake123.com', 
                    Alias = 'usudep', 
                    TimeZoneSidKey = 'America/Argentina/Buenos_Aires', 
                    LocaleSidKey = 'en_US', 
                    EmailEncodingKey='UTF-8', 
                    ProfileId='00e5e0000037LoeAAE', 
                    LanguageLocaleKey='en_US');
    User u2 = new user(Username='usrdp244754396@fake123.com', 
                    FirstName='Usuario de prueba2', 
                    LastName= 'test', 
                    Email='Udp2@fake124.com', 
                    Alias = 'usudep2', 
                    TimeZoneSidKey = 'America/Argentina/Buenos_Aires', 
                    LocaleSidKey = 'en_US', 
                    EmailEncodingKey='UTF-8', 
                    ProfileId='00e5e0000037LoeAAE', 
                    LanguageLocaleKey='en_US');
    User u3 = new user(Username='usrdp344754396@fake123.com', 
                    FirstName='Usuario de prueba3', 
                    LastName= 'test3', 
                    Email='usrdp3@fake123.com', 
                    Alias = 'usudep3', 
                    TimeZoneSidKey = 'America/Argentina/Buenos_Aires', 
                    LocaleSidKey = 'en_US', 
                    EmailEncodingKey='UTF-8', 
                    ProfileId='00e5e0000037LoeAAE', 
                    LanguageLocaleKey='en_US');
    users.add(u1);
    users.add(u2);
    users.add(u3);

    insert users;
    return users;
    }



    public static List<Territory__c> createTerritories(){
        List<Territory__c> terr = new List<Territory__c>();
        List<User> users = createUsers();
        Integer random = Integer.Valueof(Math.Random()*2);

        Territory__c t1 = new Territory__c(Name='Territory 1', Owner__c = Users[0].Id, Zip_Code__c = '1003');
        Territory__c t2 = new Territory__c(Name='Territory 1', Owner__c = Users[1].Id, Zip_Code__c = '1003');
        Territory__c t3 = new Territory__c(Name='Territory 1', Owner__c = Users[2].Id, Zip_Code__c = '1003');
        

        Territory__c t4 = new Territory__c(Name='Territory 2', Owner__c = Users[0].Id, Zip_Code__c = '1002');
        Territory__c t5 = new Territory__c(Name='Territory 2', Owner__c = Users[1].Id, Zip_Code__c = '1002');

        Territory__c t6 = new Territory__c(Name='Territory 3', Owner__c = Users[2].Id, Zip_Code__c = '1001');
        
        terr.add(t1);
        terr.add(t2);
        terr.add(t3);
        terr.add(t4);
        //terr.add(t5);
        terr.add(t6);
        //insert terr;
        return terr;   
    }

public static List<Opportunity> createOppsWithAccs(List<Account> accounts){
    List<Opportunity> opportunities = new List<Opportunity>();

    for(integer i=1; i<10; i++){
        Opportunity  o = new Opportunity(
            Name='Test opportunity ' + i,
            StageName= 'Prospecting',
            AccountId= accounts[i-1].Id,
            CloseDate=System.today().addMonths(2)
        );
        opportunities.add(o);
    }
    insert opportunities;
    return opportunities;
    }

    public static List<Contact> createContactsWithAccs(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();

        for(integer i=1; i<10; i++){
            Contact c = new Contact(
                LastName= 'Contact ' + i,
                AccountId=accounts[i-1].Id
            );
        }
        insert contacts;
        return contacts;
    }




}
