# veritas_vxvm.rb
require 'facter'

def get_vxvm_disks
  output = Facter::Util::Resolution.exec('/usr/sbin/vxdisk -o alldgs list 2>/dev/null')

  disks={}
  unless output.nil?
    output.split(/\n/).each do |line|
      unless line.match(/^DEVICE/)
        name, type, disk, group, status = line.split(/\s+/, 5)
        #Puppet.debug "Veritas vxvm disk name: #{name}, type: #{type}, status: #{status}"
        disks[name] = { :type => type, :status => status }
      end
    end
  end
  #Puppet.debug "Veritas vxvm disks #{disks}"
  disks
end

def get_vxvm_diskgroups
  output = Facter::Util::Resolution.exec('/usr/sbin/vxdg list 2>/dev/null')

  diskgroups={}
  unless output.nil?
    output.split(/\n/).each do |line|
      unless line.match(/^NAME/)
        name, state, id  = line.split(/\s+/, 3)
        #Puppet.debug "Veritas vxvm disk group:  name: #{name}, state: #{state}, id: #{id}"
        diskgroups[name] = { :state => state, :id => id }

        # get vxvm volume information
        dginfo = Facter::Util::Resolution.exec("/usr/sbin/vxprint -tr -g #{name} 2>/dev/null")
        #Puppet.debug "Veritas vxvm disk group detail info:  #{dginfo}"
        unless dginfo.nil?
          dginfo.split(/\n/).each do |line1|
            #Puppet.debug "Veritas vxvm disk group detail info: line1: #{line1}"

            if line1.match(/^v\s+/)
              flag,volume,rvg,kstate,state,length,others=line1.split(/\s+/,7)

              diskgroups[name][:volumes]||={}
              diskgroups[name][:volumes][volume]||={}
              diskgroups[name][:volumes][volume].merge!({:kstate=>kstate, :state=>state, :length=>length })
            elsif line1.match(/^dm\s+/)
              flag,dgindex,disk,type,privlen,publen,state=line1.split(/\s+/,7)

              diskgroups[name][:disks]||={}
              diskgroups[name][:disks][dgindex]||={}
              diskgroups[name][:disks][dgindex].merge!({:disk=>disk, :type=>type, :privlen=>privlen, :publen => publen })
            
            end
          end
        end
      end
    end
  end
  Puppet.debug "Veritas vxvm diskgroups #{diskgroups}"
  diskgroups
end

# get vxvm disks
inventory1 = get_vxvm_disks
Facter.add('veritas_vxvm_disks') do
  setcode do
    inventory1
  end
end

# get vxvm diskgroups
inventory2 = get_vxvm_diskgroups
Facter.add('veritas_vxvm_diskgroups') do
  setcode do
    inventory2
  end
end
