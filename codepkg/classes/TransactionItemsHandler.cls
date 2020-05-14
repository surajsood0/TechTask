/* This class handles the events for TransactionItems Trigger
 *
 */

public with sharing class TransactionItemsHandler {
    
    //constructor
    public TransactionItemsHandler() {

    }

        
    // handle logic for before insert
    public void OnBeforeInsert(Map<ID, TransactionItem__c> newTxnItemsMap)
    {
        //logic
    }

    // handle logic for after insert
    public void OnAfterInsert(Map<ID, TransactionItem__c> newTxnItemsMap, Map<ID, TransactionItem__c> oldTxnItemsMap)
    {
        OnAfterInsertAsync(newTxnItemsMap.keySet());//call future method
    }

    // handle logic for after update
    public void OnAfterUpdate( Map<ID, TransactionItem__c> newTxnItemsMap, Map<ID, TransactionItem__c> oldTxnItemsMap )
    {
        OnAfterUpdateAsync(newTxnItemsMap.keySet());//call future method
		    
    }

    //handle logic for before insert
    public void OnBeforeUpdate( Map<ID, TransactionItem__c> newTxnItemsMap, Map<ID, TransactionItem__c> oldTxnItemsMap )
    {
        //logic
    }

    //this method can be used to perform async operations on a trigger 
    // handle async logic for after update   
    @future(callout=true)
    public static void OnAfterUpdateAsync(Set<Id> recIds)
    {
        //check transaction Items match the criteria to makemake API call
		TransactionItemsBusinesslogic.syncTransactions(recIds);
    } 
    
	//this method can be used to perform async operations on a trigger 
    // handle async logic for after update   
    @future(callout=true)
    public static void OnAfterInsertAsync(Set<Id> recIds)
    {
        //check transaction Items match the criteria to makemake API call
		TransactionItemsBusinesslogic.syncTransactions(recIds);
    } 

}