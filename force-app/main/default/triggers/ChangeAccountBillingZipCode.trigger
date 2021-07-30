trigger ChangeAccountBillingZipCode on Account (after insert, after update) {

    List<Account> accs = new List<Account>();
    List<Account> oldAccs = new List<Account>();

    for (Account aNew : trigger.new){
        for(Account aOld : trigger.old){
            if(aNew.BillingPostalCode != aOld.BillingPostalCode){
                accs.add(aNew);
                oldAccs.add(aOld);
            }
        }
    } 
    
    /*for (Id aNew : trigger.newMap.keySet()){
        if(trigger.newMap.get(aNew).BillingPostalCode != Trigger.oldMap.get(aNew).BillingPostalCode) {

                accs.add(aNew);

            }
        
    }*/

    if (accs.size()>0 || accs!=null){
    if(trigger.isUpdate){
        //call methods in salesRepController class
        AccountController.updateAccountOwner(accs);
        AccountController.updateContactOwner(accs);
        AccountController.updateOpenOpportunities(accs);
        AccountController.createAssigmentHistoryRecord(accs, oldAccs);
    }
    if(trigger.isInsert){
        //call methods in salesRepController class
        //AccountController.updateAccountOwner(accs);
        
        }
    }



}