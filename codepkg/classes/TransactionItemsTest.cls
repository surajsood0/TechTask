@isTest
public class TransactionItemsTest {

    @isTest
    static void actionCodeControllerTests() {
        
        //set http mock        
        Test.setMock(HttpCalloutMock.class, new HttpMockClass());

        //custom setting
        API_Config_Settings__c testConf = new API_Config_Settings__c();
        testConf.Consumerkey__c = 'test123';
		testConf.Consumer_Secret__c = 'test321';
        testConf.Endpoint__c = 'https://www.google.com';
        insert testConf;
        
        
        //create test data
        //create transaction
        Transaction__c testTxn = new Transaction__c();
        testTxn.Total_Cost__c = 100;
        testTxn.Total_Discount__c = 10;
        testTxn.Transaction_Count__c = 2;
        
        insert testTxn;
        
        //create transaction item
        TransactionItem__c testTxnItem1 = new TransactionItem__c();
        testTxnItem1.Item_Cost__c = 50;
        testTxnItem1.Name = 'testTxnItem1';
        testTxnItem1.Transaction__c = testTxn.Id;
                
        insert testTxnItem1;
        
        TransactionItem__c testTxnItem2 = new TransactionItem__c();
        testTxnItem2.Item_Cost__c = 50;
        testTxnItem2.Name = 'testTxnItem2';
        testTxnItem2.Transaction__c = testTxn.Id;
                
        insert testTxnItem2;
        
        //update an item
        testTxnItem2.Item_Cost__c = 60;
        update testTxnItem2;

        
        
        

        
        
    }

    
}