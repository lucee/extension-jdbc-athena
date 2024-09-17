component extends="types.Driver" implements="types.IDatasource" {

	this.className="{class-name}";
	this.bundleName="{bundle-name}";
	this.dsn="{connstr}";
	
	fields=[
	field(
		"Output Location",
		"S3OutputLocation",
		"",
		true,
		"Specifies the S3 location where Athena will store the results of the query. Example: s3://your-bucket/path/"
	),
    field(
        "Region",
        "AwsRegion",
        "us-east-1",
        true,
        "Specifies the AWS region where your Athena instance resides."
    ),
    field(
        "Workgroup",
        "Workgroup",
        "primary",
        false,
        "Specifies the Athena workgroup to run the query in."
    ),
    field(
        "Result Reuse Enabled",
        "ResultReuseEnabled",
        "Yes,No",
        false,
        "Enables or disables the use of cached results to reduce query execution time and cost.",
		"select"
    ),
    field(
        "Max Retries",
        "MaxRetries",
        "3",
        false,
        "Defines the maximum number of retry attempts if the connection fails."
    ),
    field(
        "Connection Timeout",
        "ConnectionTimeout",
        "30",
        false,
        "Defines the connection timeout in seconds."
    ),
    field(
        "Socket Timeout",
        "SocketTimeout",
        "60",
        false,
        "Defines the timeout (in seconds) for the socket connection to Athena."
    ),
    field(
        "Schema",
        "Schema",
        "",
        false,
        "Specifies the default schema (database) to use for the connection."
    ),
    field(
        "Authentication Type",
        "AuthenticationType",
        "IAM",
        false,
        "Specifies the authentication type for connecting to Athena (IAM, Default, Profile, AccessKey)."
    ),
    field(
        "AWS Profile",
        "AwsProfile",
        "default",
        false,
        "Specifies the AWS profile to use from the AWS credentials file."
    ),
    field(
        "Role ARN",
        "RoleARN",
        "",
        false,
        "Specifies the ARN of an IAM role to assume for Athena queries."
    ),
    field(
        "Role Session Name",
        "RoleSessionName",
        "",
        false,
        "Specifies the session name for the IAM role session when using RoleARN."
    ),
    field(
        "Role External ID",
        "RoleExternalId",
        "",
        false,
        "Specifies an external ID when assuming an IAM role, if required by the role's trust policy."
    ),
    field(
        "Enable Result Streaming",
        "EnableResultStreaming",
        "Yes,No",
        false,
        "Enables streaming of large query results to reduce memory usage.",
		"select"
    ),
    field(
        "Metadata Cache TTL",
        "MetadataCacheTTL",
        "300",
        false,
        "Specifies the time-to-live (in seconds) for the metadata cache."
    ),
    field(
        "Use Result Set Streaming",
        "UseResultSetStreaming",
        "Yes,No",
        false,
        "Enables streaming of the result set to process large datasets row by row.",
		"select",
		2
    ),
    field(
        "Endpoint Override",
        "EndpointOverride",
        "",
        false,
        "Specifies a custom Athena endpoint for regional or private endpoints."
    ),
    field(
        "Log Level",
        "LogLevel",
        "DEBUG,INFO,WARN,ERROR",
        false,
        "Specifies the log level for the Athena JDBC driver (DEBUG, INFO, WARN, ERROR).",
		"select",
		2
    ),
    field(
        "Disable Certificate Validation",
        "DisableCertificateValidation",
        "Yes,No",
        false,
        "Disables SSL certificate validation (not recommended for production).",
		"select",
		2
    ),
    field(
        "SSL Enabled",
        "SslEnabled",
        "Yes,No",
        false,
        "Enables or disables SSL for the connection.",
		"select",
		1
    )
];

	
	data={};

	public function customParameterSyntax() {
		return {leadingdelimiter:';',delimiter:';',separator:'='};
	}
/*
	public boolean function literalTimestampWithTSOffset() {
		return true;
	}
*/	
	public void function onBeforeUpdate() {
		var keysToDelete=[];
		// get fields
		var fields={};
		loop array=getFields() item="f" {
			fields[f.getName()]={req:f.getRequired(),def:f.getDefaultValue(),dis:f.getDisplayName()};
		}

		// remove the values that are using the defaukt values
		loop struct=form index="local.kwp" item="v" {
			if(find("custom_",kwp)==1) {
				var k= mid(kwp,8);
				if(structKeyExists(fields, k) && fields[k].def==v ||  isEmpty(trim(v)) ) {
					arrayAppend(keysToDelete, kwp);
				}
				else form[kwp]=improve(v);
			}
		}
		loop array=keysToDelete item="k" {
			structDelete(form, k);
		}
	}
	
	/**
	* returns array of fields
	*/
	public array function getFields() {
		return fields;
	}

	/**
	* Returns the display name of the driver.
	*/
	public string function getName() {
		return "Amazon Athena";
	}

	/**
	* Returns the description for the driver.
	*/
	public string function getDescription() {
		return "{description}";
	}

	/**
	* return if String class match this
	*/
	public boolean function equals(required className, required dsn) {
		return this.className EQ arguments.className;
	}


	public function improve(val) {
		if("Yes"==val) return true;
		if("No"==val) return false;
		return val;
	}
}