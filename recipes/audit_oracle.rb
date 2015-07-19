control_group "System Audit" do
  iptables_command='chkconfig --list iptables'
  describe command(iptables_command) do
    its(:stdout) { should match /^iptables.+:on/ }
  end

  describe port(5500) do
    it { should be_listening }
  end

  describe port(1521) do
    it { should be_listening }
  end
end