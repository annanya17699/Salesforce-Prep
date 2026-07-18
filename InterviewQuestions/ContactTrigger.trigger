trigger ContactTrigger on Contact (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    /*INSERT EVENT*/
    if(Trigger.isInsert){
        /*BEFORE INSERT EVENT*/
        if(Trigger.isBefore){
            
        }
        /*AFTER INSERT EVENT*/
        else if(Trigger.isAfter){
            if(!ContactTriggerHandler.bypassTrigger){
                ContactTriggerHandler.bypassTrigger = true;
            	ContactTriggerHandler.insertAccount(Trigger.new);
            }
        }
    }
    /*UPDATE EVENT*/
    else if(Trigger.isUpdate){
        /*BEFORE UPDATE EVENT*/
        if(Trigger.isBefore){
            
        }
        /*AFTER UPDATE EVENT*/
        else if(Trigger.isAfter){
        }
    }
    /*DELETE EVENT*/
    else if(Trigger.isDelete){
        /*BEFORE DELETE EVENT*/
        if(Trigger.isBefore){
        }
        /*AFTER DELETE EVENT*/
        else if(Trigger.isAfter){
        }
    }
    /*AFTER UNDELETE EVENT*/
    else if(Trigger.isUndelete && Trigger.isAfter){
    }
}