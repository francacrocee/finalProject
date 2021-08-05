trigger ChangeAccountBillingZipCode on Account (after insert, after update) {
    List<Account> accs = new List<Account>();
    List<Account> oldAccs = new List<Account>();

    accs = trigger.New;
    oldAccs = trigger.Old;

    if(trigger.isAfter){
        if(trigger.isUpdate || trigger.isInsert){
            //call methods in salesRepController class
            AccountController.updateAccountOwner(accs, oldAccs);
            AccountController.updateContactOwnerHelper(accs, oldAccs);
            AccountController.updateOpenOpportunitiesHelper(accs, oldAccs);
            AccountController.createAssigmentHistoryRecord(accs, oldAccs);
        }
    }
}



