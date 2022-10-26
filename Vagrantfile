nguests = 1
box = "centos/7"
memory = 1024/nguests # memory per box in MB
cpuCap = 100/nguests


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  (1..nguests).each do |i|

      config.vm.box = box

      config.vm.define "manager", primary: true do |hostconfig|
      hostconfig.vm.network :private_network, ip: "192.168.2.101"
      hostconfig.vm.box = box
      hostconfig.vm.hostname = "centos.nextlabs.local"
      #hostconfig.vm.synced_folder "./manager","/vagrant",type: "virtualbox"
      
      hostconfig.vm.synced_folder "../", "/opt/nextlabs"

      hostconfig.vm.provision "shell", inline: <<-SHELL

        echo "Works" > /tmp/tt.sh

      SHELL
      
    end
    
      
  end
end