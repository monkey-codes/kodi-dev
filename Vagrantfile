unless Vagrant.has_plugin?("vagrant-reload")
 raise 'vagrant-reload plugin not installed [vagrant plugin install vagrant-reload]'
end
Vagrant.configure(2) do |config|
  config.vm.box = "dreamscapes/archlinux"
   config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    if RUBY_PLATFORM =~ /darwin/
      vb.customize ["modifyvm", :id, '--audio', 'coreaudio', '--audiocontroller', 'hda'] # choices: hda sb16 ac97
    elsif RUBY_PLATFORM =~ /mingw|mswin|bccwin|cygwin|emx/
      vb.customize ["modifyvm", :id, '--audio', 'dsound', '--audiocontroller', 'ac97']
    end
    vb.customize ["modifyvm", :id, "--vram", "64"]
    vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]
    #run VBoxManage list usbhost to get the sd card reader details

    vb.customize ["usbfilter", "add", "0",
    "--target", :id,
    "--name", "SDCardReader",
    "--manufacturer", "SDMMC M121",
    "--product", "USB 2.0  SD/MMC READER"]
    #mount usb on guest - journalctl -f then plug in the usb should see /dev/sdx1 /dev/sdx2 if any partitions exist
   end

   #config.vm.provision "file", source: "mirrorlist", destination: "~/"

   config.vm.provision "shell",
     inline: "cp /vagrant/mirrorlist /etc/pacman.d/mirrorlist && pacman -Syu --noconfirm puppet"

   config.vm.provision "puppet" do |puppet|
     #puppet.manifest_file = "kodi.pp"
     puppet.environment_path = "environments"
     puppet.environment = "default"
   end

   config.vm.provision :reload

   #config.vm.network :private_network, ip: "10.11.12.13"
   #config.vm.synced_folder("./git/", "/opt/git/", type: "nfs", :mount_options => ['nolock,vers=3,udp,rsize=32768,wsize=32768,intr,noatime,fsc'])
end
