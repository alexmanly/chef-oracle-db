control_group "Oracle Audit" do
  
  control 'Oracle' do
    it 'should be listening on port 5500' do
      expect(port(5500)).to be_listening
    end

    it 'should be listening on port 1521' do
      expect(port(1521)).to be_listening
    end

    it 'should be running' do
      expect(service('oracle')).to be_running
    end

    it "/opt/oracle should be mounted with an ext4 partition" do
      expect(file("/opt/oracle")).to be_mounted.with( :type => "ext4" )
    end
  end
end