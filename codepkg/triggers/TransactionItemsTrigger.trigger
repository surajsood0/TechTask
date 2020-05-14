trigger TransactionItemsTrigger on TransactionItem__c (before insert, before update, 
        before delete, after insert, after update, after delete, after undelete) 
{
    
    TransactionItemsHandler handler = new TransactionItemsHandler();

    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeInsert(Trigger.NewMap);
        }
        else
        {
            handler.OnAfterInsert(Trigger.NewMap, Trigger.OldMap);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeUpdate(Trigger.NewMap ,Trigger.OldMap);
        }
        else
        {
            handler.OnAfterUpdate(Trigger.NewMap ,Trigger.OldMap);
        }
    }
}