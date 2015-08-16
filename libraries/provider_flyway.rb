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
        converge_by("Execute flyway migrate scripts") do
          # Create stripts directory in the cache
          scripts_location = Chef::Config[:file_cache_path] + '/' + new_resource.location
          
          updates = []

          dir1 = directory scripts_location do
            recursive true
            action :delete
          end
          updates << [dir1.updated?]

          dir2 = directory scripts_location do
            recursive true
            action :create
            mode '0755'
            owner "#{new_resource.owner}"
          end
          updates << [dir2.updated?]

          # Copy all scripts from the templates scritps dir to the cache scripts dir
          run_context.cookbook_collection['base-oracle-db'].manifest['templates'].each do |tmplt|
            if tmplt['path'].include? "#{new_resource.location}"
              tmpt1 = template tmplt['name'] do
                path scripts_location + '/' + tmplt['name']
                source new_resource.location + '/' + tmplt['name']
                owner "#{new_resource.owner}"
                sensitive new_resource.sensitive
              end
              updates << [tmpt1.updated?]
            end
          end

          # configure flyway
          conf = {
            url: "#{new_resource.url}",
            user: "#{new_resource.user}",
            password: "#{new_resource.password}",
            locations: "filesystem:#{scripts_location}"
          }

          tmpt2 = template "#{new_resource.install_dir}/flyway/conf/flyway.conf" do
            source 'flyway.conf.erb'
            owner "#{new_resource.owner}"
            sensitive new_resource.sensitive
            variables(
              :conf => conf,
            )
          end
          updates << [tmpt2.updated?]

          # run flyway command
          bsh = bash 'flyway migrate' do
            code './flyway migrate'
            cwd "#{new_resource.install_dir}/flyway"
            action :run
          end
          updates << [bsh.updated?]

          new_resource.updated_by_last_action(updates.any?)
        end # converge_by
      end

      action :install do
        converge_by("Install flyway") do
          updates = []
          # download
          rmt = remote_file "#{new_resource.install_dir}/flyway-commandline-#{new_resource.flyway_version}-linux-x64.tar.gz" do
            source "#{new_resource.flyway_url}/flyway-commandline-#{new_resource.flyway_version}-linux-x64.tar.gz"
            user "#{new_resource.owner}"
            action :create
            not_if do ::File.exists?("#{new_resource.install_dir}/flyway/conf/flyway.conf") end
          end
          updates << [rmt.updated?]

          # extract
          bsh = bash 'extract_flyway' do
            cwd "#{new_resource.install_dir}"
            code <<-EOH
              /bin/tar xzf #{new_resource.install_dir}/flyway-commandline-#{new_resource.flyway_version}-linux-x64.tar.gz
              /bin/mv #{new_resource.install_dir}/flyway-#{new_resource.flyway_version} #{new_resource.install_dir}/flyway
              /bin/rm -f #{new_resource.install_dir}/flyway-commandline-#{new_resource.flyway_version}-linux-x64.tar.gz
              /bin/chown -R #{new_resource.owner}:#{new_resource.group} #{new_resource.install_dir}/flyway
              /bin/ln -s #{new_resource.install_dir}/12R1/jdbc/lib/ojdbc6.jar #{new_resource.install_dir}/flyway/drivers/ojdbc6.jar
              EOH
            not_if do ::File.exists?("#{new_resource.install_dir}/flyway/conf/flyway.conf") end
          end
          updates << [bsh.updated?]

          # delete downloaded file
          f1 = file "#{new_resource.install_dir}/flyway-commandline-#{new_resource.flyway_version}-linux-x64.tar.gz" do
            action :delete
          end
          updates << [f1.updated?]

          new_resource.updated_by_last_action(updates.any?)
        end # converge_by
      end 
    end
  end
end