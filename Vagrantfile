# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

VAGRANTFILE_API_VERSION ||= "2"
confDir = File.expand_path("conf", File.dirname(__FILE__))

bootstrapYamlPath = File.expand_path(confDir + "/Bootstrap.yaml")

require File.expand_path(confDir + '/../scripts/bootstrap.rb')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    Bootstrap.configure(config, YAML::load(File.read(bootstrapYamlPath)))

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.add_recipe "learn_chef_httpd"
  end

end
