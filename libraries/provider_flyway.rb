require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class Flyway < Chef::Provider::LWRPBase
      provides :flyway if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :run do
        # Create stripts directory in the cache
        scripts_location = Chef::Config[:file_cache_path] + '/' + new_resource.location
        directory scripts_location do
          recursive true
          action :delete
        end
        directory scripts_location do
          recursive true
          action :create
        end

        # Copy all scripts from the templates scritps dir to the cache scripts dir
        run_context.cookbook_collection['base-oracle-db'].manifest['templates'].each do |tmplt|
          if tmplt['path'].include? "#{new_resource.location}"
            template tmplt['name'] do
              path scripts_location + '/' + tmplt['name']
              source new_resource.location + '/' + tmplt['name']
            end
          end
        end

        # configure flyway
        node.default['base-oracle-db']['flyway']['conf'] = {
          url: "#{new_resource.url}",
          user: "#{new_resource.user}",
          password: "#{new_resource.password}",
          locations: 'filesystem:' + scripts_location
        }

        template "#{new_resource.install_dir}/flyway/conf/flyway.conf" do
          source 'flyway.conf.erb'
          owner "#{new_resource.owner}"
        end

        # run flyway command
        bash 'flyway migrate' do
          code './flyway migrate'
          cwd "#{new_resource.install_dir}/flyway"
          action :run
        end
      end

      action :install do

        # download
        remote_file "#{new_resource.install_dir}/flyway-commandline-#{new_resource.version}-linux-x64.tar.gz" do
          source "https://bintray.com/artifact/download/business/maven/flyway-commandline-#{new_resource.version}-linux-x64.tar.gz"
          user "#{new_resource.owner}"
          action :create
          not_if do ::File.exists?("#{new_resource.install_dir}/flyway/conf/flyway.conf") end
        end

        # extract
        bash 'extract_flyway' do
          cwd "#{new_resource.install_dir}"
          code <<-EOH
            /bin/tar xzf #{new_resource.install_dir}/flyway-commandline-#{new_resource.version}-linux-x64.tar.gz
            /bin/mv #{new_resource.install_dir}/flyway-#{new_resource.version} #{new_resource.install_dir}/flyway
            /bin/rm -f #{new_resource.install_dir}/flyway-commandline-#{new_resource.version}-linux-x64.tar.gz
            /bin/chown #{new_resource.owner}:#{new_resource.group} #{new_resource.install_dir}/flyway
            /bin/ln -s #{new_resource.install_dir}/12R1/jdbc/lib/ojdbc6.jar #{new_resource.install_dir}/flyway/drivers/ojdbc6.jar
            EOH
          not_if do ::File.exists?("#{new_resource.install_dir}/flyway/conf/flyway.conf") end
        end

        # delete downloaded file
        file "#{new_resource.install_dir}/flyway-commandline-#{new_resource.version}-linux-x64.tar.gz" do
          action :delete
        end
      end 
    end
  end
end