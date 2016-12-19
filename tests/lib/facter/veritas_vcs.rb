# veritas_vcs.rb
require 'facter'

def get_veritas_vcs_status

  vcs_status={}

  output = Facter::Util::Resolution.exec('/opt/VRTS/bin/hastatus -summary 2>/dev/null')
  unless output.nil?
    section=''
    output.split(/\n/).each do |line|

      next if line.empty?

      if line =~ /^-- SYSTEM STATE/
         section='system'
         vcs_status[:systems]={}
         next;
      elsif line =~ /^-- GROUP STATE/
         section='group'
         vcs_status[:servicegroups]={}
         next;
      end

      next if section.empty?

      if section == 'system'
         prefix = nil
         system = nil
         state = nil
         frozen = nil
         if line =~ /^-- System/
           next
         else
           prefix,system,state,frozen = line.split(/\s+/)
           unless system.nil? 
             #state.downcase!
             #Puppet.debug "Veritas vcs system status #{system} #{state}"
             vcs_status[:systems]||={}
             vcs_status[:systems][system]||={}
             vcs_status[:systems][system].merge!({ :state => state, :frozen => frozen })
           end
         end    
      elsif section == 'group'
         prefix = nil
         group = nil
         system = nil
         probed = nil
         autodisabled= nil
         state = nil
         if line =~ /^-- Group/
             next
         else

           # get service group status
           prefix,group,system,probed,autodisabled,state = line.split(/\s+/)
           unless group.nil? 
             #state.downcase!
             #Puppet.debug "Veritas vcs group status #{group} #{system}"
             vcs_status[:servicegroups][group]||={}
             vcs_status[:servicegroups][group][:systems]||={}
             vcs_status[:servicegroups][group][:systems][system]||={}
             vcs_status[:servicegroups][group][:systems][system].merge!({ :probed => probed, :autodisabled => autodisabled, :state => state})

             # get the resources of the service group
             unless vcs_status[:servicegroups][group].has_key?(:resources)
               res_status = Facter::Util::Resolution.exec("/opt/VRTS/bin/hares -display -group #{group} 2>/dev/null")
               unless res_status.nil?
                 vcs_status[:servicegroups]||={}
                 vcs_status[:servicegroups][group]||={}
                 vcs_status[:servicegroups][group][:resources]||={}

                 res_status.split(/\n/).each do |line1|

                   #Resource     Attribute             System     Value
                   next if line1 =~ /^#/

                   resource,attr,system1,value=line1.split(/\s+/,4)
                   #Puppet.debug "Veritas vcs resource status #{line1}, #{system1}, #{value}"

                   unless resource.nil?
                     vcs_status[:servicegroups][group][:resources][resource]||={}
                     if attr =~ /^(Type|AutoStart|Critical|Enabled)$/
                       vcs_status[:servicegroups][group][:resources][resource].merge!({ attr => value })
                     elsif attr =~ /^(Probed|State|Start)$/
                       vcs_status[:servicegroups][group][:resources][resource][attr]||={}
                       vcs_status[:servicegroups][group][:resources][resource][attr].merge!({ system1 => value })
                     end
                   end
                 end
               end
             end
           end
         end    
      end
    end
  end

  Puppet.debug "Veritas vcs status #{vcs_status}"
  vcs_status
end

# get status for veritas vcs service groups and resources
vcs_status = get_veritas_vcs_status
Facter.add('veritas_vcs_cluster') do
  setcode do
    vcs_status
  end
end

