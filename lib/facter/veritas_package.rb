# veritas_package.rb
require 'facter'

def get_veritas_package

  packages={}
  os = Facter.value(:operatingsystem)

  if ( os =~ /RedHat|SLES/ )
	output = Facter::Util::Resolution.exec('rpm -qa | grep VRTS 2>/dev/null')
	unless output.nil?
		output.split(/\n/).each do |line|
			name, version = line.split(/-/,3)
			packages[name] = version
		end
	end
  elsif ( os == 'Solaris' )
	output = Facter::Util::Resolution.exec('pkg list | grep VRTS 2>/dev/null')
	unless output.nil?
		output.split(/\n/).each do |line|
			name, publisher, version = line.split(/\s+/,4)
			packages[name] = version
		end
	end
  end

  Puppet.debug "Veritas packages #{packages}"
  packages
end

# get veritas packages 
inventory = get_veritas_package
Facter.add('veritas_packages') do
  setcode do
    inventory
  end
end

