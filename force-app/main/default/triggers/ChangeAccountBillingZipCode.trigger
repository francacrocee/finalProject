trigger ChangeAccountBillingZipCode on Account (after insert, after update) {
    List<Account> accs = new List<Account>();
    List<Account> oldAccs = new List<Account>();

    accs = trigger.New;
    oldAccs = trigger.Old;

    if(trigger.isAfter){
        if(trigger.isUpdate){
            //call methods in AccountController class
            AccountController.updateAccountOwner(accs, oldAccs);
            AccountController.updateContactOwnerHelper(accs, oldAccs);
            AccountController.updateOpenOpportunitiesHelper(accs, oldAccs);
            AccountController.createAssigmentHistoryRecord(accs, oldAccs);
            AccountController.sendEmailToAccountOwners(accs, oldAccs);
        }

        if(trigger.isInsert){
            //call methods in AccountController class
            AccountController.updateAccountOwner(accs, oldAccs);
            AccountController.updateContactOwnerHelper(accs, oldAccs);
            AccountController.updateOpenOpportunitiesHelper(accs, oldAccs);
            AccountController.createAssigmentHistoryRecord(accs, oldAccs);
            //AccountController.sendEmailToAccountOwners(accs, oldAccs);
        }
    }
}



