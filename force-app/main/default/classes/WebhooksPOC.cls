@RestResource(urlMapping='/api/webhooks/pushdetailspoc/*')
global with sharing class WebhooksPOC {
    @HttpPost
    global static void handleNotifications() {
        try{
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;

            String hadheadval = request.headers.get('X-Hub-Signature-256');
            Blob bb = request.requestBody;

            JSONParser parser = JSON.createParser(request.requestBody.toString());
            pusher ps;
            head_commit hc;
            String repo;
            while (parser.nextToken() != null){
                if(parser.getText() == 'pusher'){
                    parser.nextToken();
                    ps=(pusher)parser.readValueAs(pusher.class);
                }

                if(parser.getText() == 'head_commit'){
                    parser.nextToken();
                    hc=(head_commit)parser.readValueAs(head_commit.class);
                }

                if(parser.getText() == 'full_name'){
                    parser.nextToken();
                    repo=parser.getText();
                }
            }

            GitHub_Push_Details__c detail = new GitHub_Push_Details__c();
            detail.Committer_Name__c = ps!=null?ps.name:'';
            detail.Committer_Email__c = ps!=null?ps.email:'';
            detail.Commit_Message__c = hc!=null?hc.message:'';
            detail.Commit_Timestamp__c = ps!=null?hc.timestamp:'';
            detail.Committed_URL__c = ps!=null?hc.url:'';
            detail.Repository_Name__c = repo;
        //    detail.Added_Components__c = hc!=null && hc.added != null?String.join(hc.added,','):'';
         //   detail.Removed_Components__c = hc!=null && hc.removed != null?String.join(hc.removed,','):'';
         //   detail.Modified_Components__c = hc!=null && hc.modified != null?String.join(hc.modified,','):'';
            insert detail;
            system.debug('@@1--'+detail);
            
            response.statuscode = 200;
            response.responseBody = Blob.valueof(JSON.serialize(new SFDCResponse('Success','Proccessed Successfully')));
        }catch(Exception ex){
            system.debug('Exception --'+ex.getMessage());
        }
    }

    public class SFDCResponse{
        String response;
        String message;
        public SFDCResponse(String resp, String msg){
            response = resp;
            message = msg;
        }
    }

    public class pusher{
        public string name;
        public string email;
        public pusher(String name, string email){
            name = name;
            email = email;
        }
    }
    
    public class head_commit{
        public string message;
        public string timestamp;
        public string url;
        public string added;
        public string removed;
        public string modified;
        public head_commit(String message, string timestamp, string url, string added, string modified, string removed){
            message = message;
            timestamp = timestamp;
            url = url;
            added = added;
            modified = modified;
            removed = removed;
        }
    }
}
