# check_tr64_fritz

![check_tr64_fritz](https://raw.githubusercontent.com/mcktr/check_tr64_fritz/master/doc/github_doc_fritzbox_services.png)

This is a Check Plugin for Icinga 2 to monitor a Fritz!Box

### Requirements

You need the following packages installed to use this check Plugin

- `curl`
- `bc`

Please use your favorite package manager to install them.

### Installation

1. Clone this Repository to an empty folder
2. Execute the `getSecurityPort` script, to find out your TR-064 SSL Port
3. Copy the check_tr64_fritz script to your Icinga 2 Check Plugin Directory
4. Add the CheckCommand definition to your Icinga 2 configuration. See the [Icinga 2 documentation](https://www.icinga.com/docs/icinga2/latest/doc/09-object-types/#checkcommand) for more details
5. Create a new service in Icinga 2 for your Fritz!Box

#### CheckCommand

```
object CheckCommand "check_tr64_fritz" {
  command = [ PluginDir + "/check_tr64_fritz" ]

  arguments = {
    "-h" = "$fritz_host$"
    "-p" = "$fritz_port$"
    "-u" = "$fritz_username$"
    "-P" = "$fritz_password$"
    "-f" = "$fritz_function$"
    "-w" = "$fritz_warning$"
    "-c" = "$fritz_critical$"
  }

  vars.fritz_host = "$address$"
  vars.fritz_port = "49443"
  vars.fritz_username = "dslf-config"
  vars.fritz_function = "status"
}
```

### Usage

#### getSecurityPort

```
getSecurityPort <HOST>

  <HOST> = IP-Adress of your Fritz!Box
```

The returned value is your SSL port for the TR-064 protocol of your Fritz!Box

#### check_tr64_fritz

```
usage: check_tr64_fritz -h <HOSTNAME> -p <PORT> -u <USERNAME> -P <PASSWORD> -f <FUNCTION> -w <WARNING> -c <CRITICAL>

  -h: IP-Adress or hostname from the Fritz!Box
      default = fritz.box

  -p: SSL-Port from the Fritz!Box
      default = 49443

  -u: Login Username for the Fritz!Box
      default = dslf-config

  -P: Login Password for the Fritz!Box

  -f: Function to check
      default = status

  -w: value where the warning state come into effect
      default = -1 / returns every time an OK state

  -c: value where the critical state come into effect
      default = -1 / return every time an OK state

Functions:

  status = Connection Status

  linkuptime = WAN link uptime

  uptime = device uptime

  downstream = useable downstream rate
               output in Mbit/s

  upstream = useable upstream rate
             output in Mbit/s

  downstreamrate = current downstream rate
                   output in Mbit/s

  upstreamrate = current upstream rate
                 output in Mbit/s

  update = get the update state

DEBUG:

  -d: prints debug information
```

The username and password are the same as for the Web-Interface of your Fritz!Box. If you don't use the login method with username and password you can leave the username empty.

### Security

Since there are credentials transmitted over the network, this script use SSL to communicate with the Fritz!Box. Therefore you need to find out your SSL port for the TR-064 protocol of your Fritz!Box. For finding out the port you can use the `getSecurityPort` script.

Make sure you are hiding password variables in Icinga Web 2.

1. Log In to your Icinga Web 2
2. Go to `Configuration` -> `Modules` -> `monitoring` -> `Security`
3. Make sure your custom password variable is protected (defaults are `*pw*,*pass*,community`). If you named your custom variable `frtiz_password` it will be protected by the default entry `*pass*`.
4. Double check it, go  to one of your Fritz!Box service an check if the password is display with ``***``.

### Authors

- [mcktr](https://github.com/mcktr)

Thanks to all contributors!

- [cxcv](https://github.com/cxcv) for fixing a bug with [performance data output](https://github.com/mcktr/check_tr64_fritz/pull/23)

### Thanks

- [FRITZ!Box mit Nagios überwachen](http://blog.gmeiners.net/2013/09/fritzbox-mit-nagios-uberwachen.html)
- [Fritz!Box and TR-064](http://heise.de/-2550500)
