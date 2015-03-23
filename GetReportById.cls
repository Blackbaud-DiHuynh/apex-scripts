String selectedReportId = '00Oo00000045NNO';
Http http = new Http();
HttpRequest req = new HttpRequest();
String url = 'https://c.na17.visual.force.com';
req.setEndpoint(url + '/services/data/v31.0/analytics/reports/'+ selectedReportId +'?includeDetails=true');
req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
req.setMethod('GET');
HTTPResponse res = http.send(req);
String fullReport = res.getBody();
fullReport = fullReport.substring(fullReport.indexOf('"allData"'));
fullReport = '{'+fullReport;		
Reports.ReportResults results = (Reports.ReportResults) JSON.deserializeStrict(fullReport, Reports.*.class);

//System.debug('response: ' + res.getBody());

