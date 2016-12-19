# veritas_license.rb
require 'facter'

def get_veritas_license

  licenses={}

  output = Facter::Util::Resolution.exec('/opt/VRTSvlic/bin/vxkeyless display -v 2>/dev/null')
  unless output.nil?
    output.split(/\n/).each do |line|
      unless line.match(/^Product|^No/) 
        name, description = line.split(/\s+/,2)
        #Puppet.debug "Veritas license: #{name}, description: #{description}"
        licenses[name] = { :type => :keyless, :description => description }
      end
    end
  end

  output = Facter::Util::Resolution.exec('/opt/VRTSvlic/bin/vxlicrep -s 2>/dev/null')
  unless output.nil?
    name = nil
    description = nil
    type = nil
    output.split(/\n/).each do |line|
      if line =~ /License Key\s*=\s*(.*)/ 
         name = $1  
      elsif line =~ /Product Name\s*=\s*(.*)/
         description = $1
      elsif line =~ /License Type\s*=\s*(.*)/
         type = ($1).downcase
         #Puppet.debug "Veritas license: #{name}, description: #{description}, type: #{type}"
         licenses[name] = { :type => type, :description => description } unless name.nil?
      end
    end
  end

  Puppet.debug "Veritas license #{licenses}"
  licenses
end

# get veritas license
inventory = get_veritas_license
Facter.add('veritas_licenses') do
  setcode do
    inventory
  end
end

