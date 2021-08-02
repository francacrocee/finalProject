trigger ChangeAccountBillingZipCode on Account (after insert, after update) {
    List<Account> accs = new List<Account>();
    List<Account> oldAccs = new List<Account>();

    accs = trigger.New;
    oldAccs = trigger.Old;

    if(trigger.isUpdate){
        //call methods in salesRepController class
        AccountController.updateAccountOwner(accs, oldAccs);
        AccountController.updateContactOwner(accs, oldAccs);
        AccountController.updateOpenOpportunities(accs, oldAccs);
        AccountController.createAssigmentHistoryRecord(accs, oldAccs);
    }
    if(trigger.isInsert){
        //call methods in salesRepController class
        //AccountController.updateAccountOwner(accs);
        
        }
    }



