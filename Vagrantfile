# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centOs65"

#  config.vm.define :el1 do | el1 |
#    el1.vm.network "private_network", ip: "192.168.25.20"
#  end

   config.vm.define :el2 do | el2 |
    el2.vm.network "private_network", ip: "192.168.25.30"
  end
  
#  config.vm.define :el3 do | el3 |
#    el3.vm.network "private_network", ip: "192.168.25.40"
#  end

  config.vm.define :el4 do | el4 |
    el4.vm.network "private_network", ip: "192.168.25.50"
  end
end
