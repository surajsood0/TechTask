/* This class handles the events for TransactionItems Trigger
 *
 */

public with sharing class TransactionItemsHandler {
    
    //constructor
    public TransactionItemsHandler() {

    }

        
    // handle logic for before insert
    public void OnBeforeInsert(List<TransactionItem__c> newTxnItems)
    {
    
    }

    // handle logic for after insert
    public void OnAfterInsert(List<TransactionItem__c> newTxnItems)
    {
        //check transaction Items match the criteria to makemake API call
		TransactionItemsBusinesslogic.syncTransactions(newTxnItems);
    }

    // handle logic for after update
    public void OnAfterUpdate( List<TransactionItem__c> newTxnItems, List<TransactionItem__c> oldTxnItems, 
                              Map<ID, TransactionItem__c> newTxnItemsMap , Map<ID, TransactionItem__c> oldTxnItemsMap )
    {
        //logic
    }

    //handle logic for before insert
    public void OnBeforeUpdate( List<TransactionItem__c> newTxnItems, List<TransactionItem__c> oldTxnItems, 
                               Map<ID, TransactionItem__c> newTxnItemsMap , Map<ID, TransactionItem__c> oldTxnItemsMap )
    {
        //logic
    }

    //this method can be used to perform async operations on a trigger 
    // handle async logic for after update   
    @future 
    public static void OnAfterUpdateAsync(Set<ID> newTxnItems)
    {
        //logic
    } 

}