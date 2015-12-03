class Bootstrap
  def Bootstrap.configure(config, settings)
    # Set The VM Provider
    ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"

    #yah
    # Random 4 digit
    r = rand.to_s[2..8]
    name = "client-"+r

    # Configure Local Variable To Access Scripts From Remote Location
    scriptDir = File.dirname(__FILE__)

    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Allow SSH Agent Forward from The Box
    config.ssh.forward_agent = true

    # Configure The Box
    config.vm.box = settings["box"] ||= "centos/7"
    config.vm.hostname = settings["hostname"] ||= name+".dev"

    # config.vm.provider = "virtualbox"
    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.50."+rand(12..250).to_s

    # Configure Additional Networks
    if settings.has_key?("networks")
      settings["networks"].each do |network|
        config.vm.network network["type"], ip: network["ip"], bridge: network["bridge"] ||= nil
      end
    end

    # Register default folder
    config.vm.synced_folder "./", "/vagrant"
    # Register All Of The Configured Shared Folders
    if settings.include? 'folders'
      settings["folders"].each do |folder|
        mount_opts = []

        if (folder["type"] == "nfs")
            mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1']
        end

        # For b/w compatibility keep separate 'mount_opts', but merge with options
        options = (folder["options"] || {}).merge({ mount_options: mount_opts })

        # Double-splat (**) operator only works with symbol keys, so convert
        options.keys.each{|k| options[k.to_sym] = options.delete(k) }

        config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options
      end
    end

  end
end
