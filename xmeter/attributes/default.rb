default[:xmeter][:templates] = 
  [{:keys => ["sourcemacaddress", "destinationmacaddress",
      	"sourceIPv4Address", "destinationipv4address",
      	"protocolIdentifier",
      	"sourceTransportPort", "destinationTransportPort"],
    :elements => ["packettotalcount", "octettotalcount", "flowId",
        "flowstartmicroseconds", "flowendmicroseconds"]}
  ]
default[:xmeter][:option_templates] =
  [
    {
      :scope => [ "meterversion", "meterossysname", "meterosnodename",
        "meterosrelease", "meterosversion", "meterosmachine"]
    }
  ]
default[:xmeter][:report_freq] = 60
ie_path =
  case node[:platform]
  when "debian","ubuntu","centos","redhat","suse"
    "/usr/lib"
  when "mac_os_x"
    "/usr/local/lib"
  end
default[:xmeter][:module_location] = "#{ie_path}/info_elements"
default[:xmeter][:config_dir] =
  case node[:platform]
  when "debian","ubuntu","centos","redhat","suse"
    "/etc/opt"
  when "mac_os_x"
    "/etc"
  end
default[:xmeter][:tls] =
  {
  	:ca_file => "#{node[:xmeter][:config_dir]}/xmeter/ca.pem"
  	:cert_file => "#{node[:xmeter][:config_dir]}/xmeter/cert.pem"
  	:key_file => "#{node[:xmeter][:config_dir]}/xmeter/key.pem"
  }
default[:xmeter][:outputs] =
  {
    "tcp:collector.fastip.com:4740" =>
      { 
  	    :use_tls => true
  	    :buffer_size => 128
      }
  }
int_type = 
  case node[:platform]
  when "debian","ubuntu","centos","redhat","suse"
    "eth"
  when "mac_os_x"
    "en"
  end
default[:xmeter][:inputs] =
  node[:network][:interfaces].each_pair do |k, v|
    if v[:type].eql?(int_type)
      {k => {:type => "pcapint"}}
    else
      nil
    end
  end.compact
    