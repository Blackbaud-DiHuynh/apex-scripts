





public MetadataService.IReadResult readMetadata(String type_x,String[] fullNames) {
	String endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/31.0';
	readMetadata_element request_x = new readMetadata_element();
	request_x.type_x = type_x;
	request_x.fullNames = fullNames;
	IReadResponseElement response_x;
	Map<String, IReadResponseElement> response_map_x = new Map<String, IReadResponseElement>();
	response_map_x.put('response_x', response_x);
	WebServiceCallout.invoke(
		this,
		request_x,
		response_map_x,
		new String[]{endpoint_x,
			'',
			'http://soap.sforce.com/2006/04/metadata',
			'readMetadata',
			'http://soap.sforce.com/2006/04/metadata',
			'readMetadataResponse',
			'MetadataService.read' + type_x + 'Response_element'}
			);
	response_x = response_map_x.get('response_x');
	return response_x.getResult();
}

public class readMetadata_element {
	public String type_x;
	public String[] fullNames;
	private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
	private String[] fullNames_type_info = new String[]{'fullNames','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
	private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
	private String[] field_order_type_info = new String[]{'type_x','fullNames'};
}

public interface IReadResult {
	Metadata[] getRecords();
}

public interface IReadResponseElement {
	IReadResult getResult();
}

public virtual class Metadata {
	public String fullName;
	private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
	private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
	private String[] field_order_type_info = new String[]{'fullName'};
}