/* This class handles the business logic for TransactionItems Trigger
 *
 */

public with sharing class TransactionItemsBusinesslogic {

    //contructor
    public TransactionItemsBusinesslogic() {

    }

    //This method willl check if transaction items are equal to Transaction count,
    //If yes API call is made to sync transactions and transaction items
    public static void syncTransactions(Set<Id> newTxnItems){

        Set<Id> transactionIds = new Set<Id>();
        
        //get set of transactions to deal with, 
        //consider multiple transactions for bulkification
        for(TransactionItem__c thisTxnItem : [SELECT Id, Transaction__c FROM TransactionItem__c
                                            WHERE Id IN : newTxnItems])
        {

            transactionIds.add(thisTxnItem.Transaction__c);                                                

        }

        //check if transactions qualify for sync
        //transaction items should be equal to Related Transaction Count 
        List<transactionItem> txnItems = new List<transactionItem>();
        List<transactions> txns = new List<transactions>();
               
        try{
        	for(Transaction__c thisTrxn : [SELECT Id, Total_Cost__c, Total_Discount__c, Transaction_Count__c, CreatedDate,
                                        (SELECT Id, Item_Cost__c, Name FROM TransactionItem__r)
                                        FROM Transaction__c WHERE Id IN : transactionIds])
        	{
           
           		
                if(thisTrxn.Transaction_Count__c == thisTrxn.TransactionItem__r.size()){
                                    
                   // construct wrapper for txnItems
                   for(TransactionItem__c thisItem : thisTrxn.TransactionItem__r)
                   {
                        txnItems.add(new transactionItem(thisItem.Id, 
                                     new itemValue(thisItem.Item_Cost__c, thisItem.Name)));	
                   }
                   
                   
                   //construct wrapper for txns
                   txns.add(new transactions(thisTrxn.Id, 
                            new txnValue(thisTrxn.Total_Cost__c,
                                        thisTrxn.Total_Discount__c,
                                        //convert datetime to date 
                                        date.newinstance(thisTrxn.CreatedDate.year(), thisTrxn.CreatedDate.month(), thisTrxn.CreatedDate.day()), 
                                        thisTrxn.Transaction_Count__c)));
               }
    
            }
        
            //at this stage we have all the txnitems and txns that needs to be synced
        	//Make API calls now
        	
            if(txnItems.size() > 0){//sync txnitems first
                     
                system.debug('Txn Item payload ' + JSON.serialize(txnItems));
                system.debug('Txn payload ' + JSON.serialize(txns));
                
				HttpResponse txnItemRes = ExecuteCallout(JSON.serialize(txnItems));                
                if(txnItemRes.getStatusCode() == 200){
                    
                    //parse txnItems response and do logic
                    system.debug('txnItem txnItemRes body' + txnItemRes.getBody());
                    
                    
                    //sync txnitems success, sync Txn now
                    HttpResponse txnRes = ExecuteCallout(JSON.serialize(txns));
                    //parse txns response and do logic
                    system.debug('txn res body' + txnRes.getBody());

                }
            }
            
        } catch (Exception exp){
             
            //throw custom exception or show error to user
            system.debug('Issue in Sync:: ' + exp.getMessage() + ' ' +exp.getLineNumber());   
        } 
        

    }
        
    
	//this method is used to make API calls.
	//Sync Items first, if success then synmc txns
    public static HttpResponse ExecuteCallout(String payload){
        
        //we can configure endpoint, consumer key etc in custom settings
        List<API_Config_Settings__c> apiConfigSettingList = [SELECT Consumerkey__c, Consumer_Secret__c,
                    								Endpoint__c FROM API_Config_Settings__c]; 
        API_Config_Settings__c apiConfigSetting = apiConfigSettingList.get(0);
        
        //request id for tracebility
        String requestId =  String.ValueOf(Math.random());
        
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('X-Request-Id', requestId);
        httpRequest.setHeader('client_id', apiConfigSetting.Consumerkey__c);
        httpRequest.setHeader('client_secret', apiConfigSetting.Consumer_Secret__c);
        httpRequest.setEndpoint(apiConfigSetting.Endpoint__c);
        
        httpRequest.setBody(payload);
        httpRequest.setTimeOut(60000);
        
                
        HttpResponse httpRes;
		httpRes = new HTTPResponse();
				
		httpRes = h.send(httpRequest);
        
        
		return httpRes;
        
    }    
    
    
    //wrappers for transaction Items
    public class transactionItem{
        public String itemKey {get;set;}
        public itemValue values{get;set;}
        
        transactionItem(String itemKey, itemValue values)
        {
            this.itemKey = itemKey;
            this.values = values;
        }
    }
    
    
	public class itemValue{
		public Decimal itemCost{get;set;}
		public String itemName{get;set;}
        
        itemValue(Decimal itemCost, String itemName)
        {
            this.itemCost = itemCost;
            this.itemName = itemName;
            
        }
    }
    
    
    //wrappers for transaction
    public class transactions{
        public String txnKey{get;set;}
        public txnValue value{get;set;}
        
        transactions(String key, txnValue value)
        {
            this.txnKey = key;
            this.value = value;
            
        }
    }
    
    
	public class txnValue{
		public Decimal totalCost{get;set;}
		public Decimal totalDiscount{get;set;}
		public Date transactionDate{get;set;}
		public Decimal totalCount{get;set;}
        
        txnValue(Decimal totalCost, Decimal totalDiscount, Date transactionDate, Decimal totalCount)
        {
            this.totalCost = totalCost;
            this.totalDiscount = totalDiscount;
            this.transactionDate = transactionDate;
            this.totalCount = totalCount;                
        }
        

    }
    
}