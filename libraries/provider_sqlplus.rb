require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class SqlPlus < Chef::Provider::LWRPBase
      provides :sqlplus if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :run do
        # Create stripts directory in the cache
        scripts_location = Chef::Config[:file_cache_path] + '/' + new_resource.location
        directory scripts_location

        # Copy all scripts from the templates scritps dir to the cache scripts dir
        run_context.cookbook_collection['base-oracle-db'].manifest['templates'].each do |tmplt|
          if tmplt['path'].include? "#{new_resource.location}"
            template tmplt['name'] do
              path scripts_location + '/' + tmplt['name']
              source new_resource.location + '/' + tmplt['name']
              owner "#{new_resource.owner}"
              group "#{new_resource.group}"
              mode "0644"
            end

            execute "sqlplus_#{tmplt['name']}" do
              command "#{new_resource.install_dir}/12R1/bin/sqlplus #{new_resource.user}/#{new_resource.password} #{new_resource.sysdba} < " + scripts_location + "/#{tmplt['name']}"
              user 'oracle'
              group 'oinstall'
              cwd '/tmp'
              environment(
                'ORACLE_BASE' => "#{new_resource.install_dir}",
                'ORACLE_HOME' => "#{new_resource.install_dir}/#{new_resource.oracle_env}",
                'ORACLE_SID' => "#{new_resource.oracle_sid}",
                'ORACLE_UNQNAME' => "#{new_resource.oracle_sid}",
                'ORA_ENV'=> "#{new_resource.oracle_env}"
              )
            end

          end
        end

      end

    end
  end
end