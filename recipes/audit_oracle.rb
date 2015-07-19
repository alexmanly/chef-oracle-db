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
  end
end