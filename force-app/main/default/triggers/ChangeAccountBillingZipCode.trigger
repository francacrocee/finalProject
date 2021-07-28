trigger ChangeAccountBillingZipCode on Account (after insert, after update) {

    List<Account> accs = new List<Account>();

    for (Account aNew : trigger.new){
        for(Account aOld : trigger.old){
            if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                accs.add(aNew);
            }
        }
    }
    if (accs.size()>0 || accs!=null){
    if(trigger.isUpdate){
        system.debug('Entra en el update');
    //call methods in salesRepController class
    salesRepController.updateAccountOwner(accs);
    salesRepController.updateContactOwner(accs);
    salesRepController.updateOpenOpportunities(accs);
    }
    if(trigger.isInsert){
        system.debug('Entra en el insert');
        //call methods in salesRepController class
        //salesRepController.updateAccountOwner(accs);
        
        }
    }



}