trigger updateTerritory on Territory__c (after insert, after update) {

    if(trigger.isAfter){
        if(trigger.isUpdate){
            territoryController.updateSalesRepInRelatedRecords(trigger.new, trigger.old);
        }
    }

}