@istest 
private class verifyAccountOwnersTest {
    public static String CRON_EXP = '0 0 0 11 8 ? 2021';

    static testmethod void testScheduledJob() {

        List<Territory__c> territories = TestDataFactory.createTerritories();
        insert territories;
        Account a = new Account (Name='Test', BillingPostalCode = '1001');
        insert a;

        //Asigno el usuario u[0]
        User u = [SELECT id FROM User WHERE Username='usrdp44754396@fake123.com' LIMIT 1];
        a.OwnerId = u.Id;
        update a;

        //usuario que deberia asignarse por billing postal code = 1001
        User u3 = [SELECT id FROM User WHERE Username='usrdp344754396@fake123.com' LIMIT 1];
        //usrdp344754396@fake123.com

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new verifyAccountOwners());
        //Antes que corra es test, el usuario debería er el asignado
        system.assertEquals(u.Id, a.ownerId);
        Test.stopTest();

        Account a2 = [SELECT Name, ownerId FROM Account WHERE Name = 'Test'];
        system.assertEquals(u3.Id, a2.ownerId);
    }
}
