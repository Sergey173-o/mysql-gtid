# -*- mode: ruby -*-
# Поднимает одну ВМ для трёх веб-приложений за Nginx.

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.box_version = "4.3.12"
  config.vm.box_check_update = false
  config.vm.boot_timeout = 900
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "web" do |vm|
    vm.vm.hostname = "dynamic-web"
    vm.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = 3072
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    { 8081 => "django", 8082 => "node", 8083 => "wordpress" }.each do |port, app|
      vm.vm.network "forwarded_port", guest: port, host: port,
                    host_ip: "127.0.0.1", auto_correct: false, id: app
    end

    vm.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/provision.yml"
    end
  end
end

# Версия 1 · 2026-11-11 · ВМ Ubuntu, три локальных порта и Ansible.
