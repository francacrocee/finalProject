trigger addRecord on Territory__c (before insert, before update) {

    List<Territory__c> trrts = new List<Territory__c>();

    if(trigger.isBefore){
        if(trigger.isUpdate){
            for(Territory__c tnew : trigger.new){
                for(Territory__c told : trigger.old){
                    if(tnew.zip_code__c != told.zip_code__c){
                        trrts.add(tnew);
                    }
                }
            }
            if(trrts.size()>0 || trrts !=null){
                if (territoryController.verifyMaxSalesRepForZipCode(trrts)==false){
                    trrts[0].name.addError('Can not add this territory, check conditions or contact the administrator');
                }
            }
            
        }

        if(trigger.isInsert){
            trrts = trigger.new;
            system.debug('trrts: ' + trrts);
            if (territoryController.verifyMaxSalesRepForZipCode(trrts) == false){
                trrts[0].name.addError('Can not add this territory, check conditions or contact the administrator');
            }
            
        }
        
    }

}