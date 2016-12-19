# veritas_vxfs.rb
require 'facter'

def get_vxfs_filesystems
  output = Facter::Util::Resolution.exec("mount -f | grep 'type vxfs' 2>/dev/null")

  vxfs_filesystems={}
  unless output.nil?
    output.split(/\n/).each do |line|
      temp, temp, mount, temp, fstype, options = line.split(/\s+/, 6)
      #Puppet.debug "Veritas vxfs filesystem: mount: #{mount}, type: #{fstype}, options: #{options}"
      vxfs_filesystems[mount] = { :fstype => fstype, :options => options }
    end
  end
  Puppet.debug "Veritas vxfs filesystems #{vxfs_filesystems}"
  vxfs_filesystems
end

# get vxfs filesystems
inventory = get_vxfs_filesystems
Facter.add('veritas_vxfs_filesystems') do
  setcode do
    inventory
  end
end

