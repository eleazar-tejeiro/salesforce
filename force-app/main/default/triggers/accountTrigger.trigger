trigger accountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  if(Trigger.isBefore ){
    system.debug('I am before trigger ');
  }
  else if(Trigger.isAfter){
      system.debug('I am after trigger ');
      if(Trigger.isUpdate){
          ContactTriggerHandler.afterAccountUpdated(Trigger.new);
      }
  }
}