# veritas_cfs.rb
require 'facter'

def get_veritas_cfs_status

  cfs_status={}

  output = Facter::Util::Resolution.exec('/opt/VRTS/bin/cfscluster status 2>/dev/null')
  unless output.nil?
    system=nil

    output.split(/\n/).each do |line|

      next if line.empty?

      Puppet.debug "Veritas cfs status #{line}"
      if line =~ /^\s*Node\s+:\s+([\w\.]+)/
         system=$1
         next if system.nil?

         Puppet.debug "Veritas node #{system}"
         cfs_status[:systems]||={}
         cfs_status[:systems][system]||={}
      elsif line =~ /^\s*Cluster Manager\s+:\s+(.*)/
         state=$1
         Puppet.debug "Veritas Cluster Manager: #{state}"
         cfs_status[:systems][system].merge!({'Cluster Manager'.to_sym=>state}) unless system.nil?
      elsif line =~ /^\s*CVM state\s+:\s+(.*)/
         state=$1
         Puppet.debug "Veritas CVM state: #{state}"
         cfs_status[:systems][system].merge!({'CVM state'.to_sym=>state}) unless system.nil?
      end

    end
  end

  Puppet.debug "Veritas cfs status #{cfs_status}"
  cfs_status
end

# get status for veritas cfs service groups and resources
cfs_status = get_veritas_cfs_status
Facter.add('veritas_cfs_cluster') do
  setcode do
    cfs_status
  end
end

