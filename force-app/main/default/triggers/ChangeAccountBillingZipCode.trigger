trigger ChangeAccountBillingZipCode on Account (after insert, after update) {

    List<Account> accs = new List<Account>();

    for (Account aNew : trigger.new){
        for(Account aOld : trigger.old){
            if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                accs.add(aNew);
            }
        }
    }

    salesRepController.updateAccountOwner(accs);



}