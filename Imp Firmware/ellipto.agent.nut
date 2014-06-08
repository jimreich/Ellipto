// ELLIPTO: Elliptical Trainer Step Counter
// Electric Imp / Keen IO demo
//
// (c) Jim Reich, May 2014
// KeenIO class from Electric Imp
//
// This code counts steps on an elliptical trainer or exercise bike
// using a tilt sensor attached to an Electric Imp and posting to Keen IO
// This file is the agent, which is responsible for receiving the events
// and posting to Keen IO under the hardcoded API keys given here

class KeenIO {
    _baseUrl = "https://api.keen.io/3.0/projects/";
    
    _projectId = null;
    _apiKey = null;
    
    constructor(projectId, apiKey) {
        _projectId = projectId;
        _apiKey = apiKey;
    }
    
    /***************************************************************************
    * Parameters: 
    *   eventCollection - the name of the collection you are pushing data to
    *   data - the data you are pushing
    *   cb - an optional callback to execute upon completion
    *
    * Returns: 
    *   HTTPResponse - if a callback was NOT specified  
    *   None - if a callback was specified
    ***************************************************************************/
    function sendEvent(eventCollection, data, cb = null) {
        local url = _buildUrl(eventCollection);
        local headers = {
            "Content-Type": "application/json"
        };
        local encodedData = http.jsonencode(data);
        server.log(encodedData);
        
        local request = http.post(url, headers, encodedData);
        
        // if a callback was specificed
        if (cb == null) {
            return request.sendsync();
        } else {
            request.sendasync(cb);
        }
    }
    
    /*************** Private Functions - (DO NOT CALL EXTERNALLY) ***************/
    function _buildUrl(eventCollection, projectId = null, apiKey = null) {
        if (projectId == null) projectId = _projectId;
        if (apiKey == null) apiKey = _apiKey;
        
        
        local url = _baseUrl + projectId + "/events/" + eventCollection + "?api_key=" + apiKey;
        return url;
    }
}

const KEEN_PROJECT_ID = <INSERT_YOUR_PROJECT_ID>;
const KEEN_WRITE_API_KEY = <INSERT_YOUR_WRITE_KEY>;

keen <- KeenIO(KEEN_PROJECT_ID, KEEN_WRITE_API_KEY);

function gotState(data) {
     local result = keen.sendEvent("StepData", data);
    server.log(result.statuscode + ": " + result.body);
}

device.on("step",gotState);
