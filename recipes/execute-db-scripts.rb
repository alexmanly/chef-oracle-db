cache_script_path = node['base-oracle-db']['scripts']['cache_script_path']

directory cache_script_path

node['base-oracle-db']['scripts']['scripts'].each { |script| 
  script_name = "#{script}"
  template script_name do
    path cache_script_path + '/' + script_name
    source node['base-oracle-db']['scripts']['script_dir_name'] + '/' + script_name
  end
}

bash 'flyway migrate' do
  code './flyway migrate'
  cwd "#{node['oracle']['ora_base']}/flyway-#{node['flyway']['version']}"
  action :run
end