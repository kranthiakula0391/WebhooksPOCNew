@RestResource(urlMapping='/api/webhooks/pushdetailspoc/*')
global with sharing class WebhooksPOC {
    @HttpPost
    global static void handleNotifications() {
        try{
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
        }catch(Exception ex){
            system.debug('Exception --'+ex.getMessage());
        }
    }
}