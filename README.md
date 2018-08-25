# check_tr64_fritz

#### Table of Contents

1. [Introduction](#introduction)
2. [Support](#support)
3. [Requirements](#requirements)
4. [Usage](#usage)
5. [CheckCommand](#checkcommand)
6. [Security](#security)
7. [Contributors](#contributors)
8. [Thanks](#thanks)
9. [Development](#development)

## Introduction

This is a check plugin for Icinga 2 to monitor a Fritz!Box.

## Support

If you have any questions, please hop onto the community channels.

## Requirements

__Required packages__

The following packages are required to use this check plugin.

- `curl`
- `bc`

Please use your favorite package manager to install them.

__Fritz!Box configuration__

The TR-064 feature must be enabled on the Fritz!Box. You can enable the feature in the following menu:

_Heimnetz_ -> _Netzwerk_, switch over to the tab _Netzwerkeinstellungen_

The setting _Zugriff für Anwendungen zulassen_ must be activated. After a restart of your Fritz!Box the
TR-064 feature is activated.

> **Note**:
>
> You may need to activate the advanced view (_Erweiterte Ansicht_) to see the setting.

## Installation

1. Get the [latest stable release](https://github.com/mcktr/check_tr64_fritz/releases)
2. Extract the archive
3. Execute the `getSecurityPort` script, to find your TR-064 SSL port
4. Copy the `check_tr64_fritz` script to your Icinga 2 check plugin directory
5. Add the CheckCommand definition to your Icinga 2 configuration.
6. Create a new service in Icinga 2 for your Fritz!Box

You can find additional information on how to setup check plugins for Icinga 2 in the offical [Icinga 2 documentation](https://www.icinga.com/docs/icinga2/latest/doc/05-service-monitoring/#service-monitoring-plugins)

## Usage

__getSecurityPort__

```
getSecurityPort <HOST>
```

| Name | Description                               |
| ---  | ---                                       |
| HOST | Hostname or IP address of your Fritz!Box. |

_Example:_

```
$ ./getSecurityPort 192.168.178.1
Your Fritz!Box Security Port (for TR-064 over SSL) is: 49443
```

__check_tr64_fritz__

```
check_tr64_fritz -h <HOSTNAME> -p <PORT> -u <USERNAME> -P <PASSWORD> -f <FUNCTION> -w <WARNING> -c <CRITICAL>
```

__Arguments__

| Name | Description                                                                                |
| ---  | ---                                                                                        |
| -h   | **Optional.** Hostname or IP address of your Fritz!Box. _Defaults to "fritz.box"._         |
| -p   | **Optional.** The port number for TR-064 over SSL. _Defaults to "49443"._                  |
| -u   | **Optional.** Username to authenticate against the Fritz!Box. _Defaults to "dslf-config"._ |
| -P   | **Required.** Password to authenticate against the Fritz!Box.                              |
| -f   | **Optional.** Function that should be checked. _Defaults to "status"._                     |
| -w   | **Optional.** Warning threshold. _Defaults to "0"._                                        |
| -c   | **Optional.** Critical threshold. _Defaults to "0"._                                       |
| -v   | **Optional.** Print current plugin version and usage text.                                 |
| -d   | **Optional.** Print debug information (TR-064  XML output).                                |

> **Note**:
>
> The username and password are the same as for the web interface of your
> Fritz!Box. If you don't use the login method with username and password, you
> can leave the username empty.

__Functions__

| Name           | Description                                                                                                                                                     |
| ---            | ---                                                                                                                                                             |
| status         | **Optional Index.** Returns the connection state. _Default Index to "pppoe"._                                                                                   |
| linkuptime     | **Optional Index.** Returns the uptime of the WAN link. _Default Index to "pppoe"._                                                                             |
| uptime         | Returns the device uptime.                                                                                                                                      |
| downstream     | Returns the usable downstream rate in MBit/s.                                                                                                                   |
| upstream       | Returns the usable upstream rate in MBit/s.                                                                                                                     |
| downstreamrate | Returns the current downstream speed in MBit/s.                                                                                                                 |
| upstreamrate   | Returns the current upstream speed in MBits/s.                                                                                                                  |
| update         | Returns the update state.                                                                                                                                       |
| thermometer    | **Requires Index.** Returns the connection status and temperature of a smart home thermometer device.                                                           |
| socketpower    | **Requires Index.** Returns the connection status and current power usage in watts of a smart home socket device.                                               |
| socketenergy   | **Requires Index.** Returns the connection status and total consumption over the last year in kWh of a smart home socket device.                                |
| socketswitch   | **Requires Index.** Returns the connection status and the current switch state. Setting the thresholds to 1 or greater will threat the `OFF` state as critical. |

__Indexes__

| Function     | Index            | Description                           |
| ---          | ---              | ---                                   |
| status       | `cable`, `pppoe` | Check the specified connection type.  |
| linkuptime   | `cable`, `pppoe` | Check the specified connection type.  |
| thermometer  | `[NUMBER]`       | Check the specified DECT thermometer. |
| socketpower  | `[NUMBER]`       | Check the specified DECT socket.      |
| socketenergy | `[NUMBER]`       | Check the specified DECT socket.      |
| socketswitch | `[NUMBER]`       | Check the specified DECT socket.      |
> **Note**:
>
> You can specify the index with a double point and the index number after the function name e.g. `thermometer:3`.

_Example:_

```
$ ./check_tr64_fritz -P password -f uptime
OK - Uptime 29990 seconds (0d 8h 19m 50s) | uptime=2999

$ ./check_tr64_fritz -P password -f status:cable
WARNING - Connecting | status=1

$ ./check_tr64_fritz -P password -f thermometer:3
OK - Comet DECT 03.68 - Wohnzimmer CONNECTED 21.5 °C | thermometer_current_state=0 thermometer_current_temp=21.5 warn=0 crit=0
```

> **Note**:
>
> Please also read the seperate documentation about the [Smart Home index](doc/01-smarthome.md)

## CheckCommand

You can use the following CheckCommand definition for your Icinga 2
configuration.

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

You can find more information about a CheckCommand definition inside the [offical
Icinga 2 documentation](https://www.icinga.com/docs/icinga2/latest/doc/09-object-types/#checkcommand).

## Security

__Authentication__

You can use an independently account for the authentication against the Fritz!Box.

1. Login to your Fritz!Box
2. Navigate to _System_ -> _Fritz!Box-Benutzer_

Here you can add a new user to your Fritz!Box. The user needs at least the following permissions to work properly.

* _FRITZ!Box Einstellungen__
* _Sprachnachrichten, Faxnachrichten, FRITZ!App Fon und Anrufliste_
* _Smart Home_

__Script__

The `check_tr64_script` use SSL to communicate with the Fritz!Box. Therefore you
need to find out your SSL port for the TR-064 protocol. Please use the script
`getSecurityPort` to find out the port that is used by your Fritz!Box.

> **Note**:
>
> The script `getSecurityPort` don't use the SSL protocol to communitcate with
> the Fritz!Box. The information about the used port for TR-064 over SSL is
> available without authentication against the Fritz!Box.

__Icinga Web 2__

You must specify your Fritz!Box  password inside your Icinga 2 configuration to
monitor your Fritz!Box, therefore ensure that you are hiding the custom password
attribute in Icinga Web 2.

1. Log in to Icinga Web 2.
2. Go to `Configuration` -> `Modules` -> `monitoring` -> `Security`.
3. Ensure that your custom password attribute is protected (defaults are `*pw*,*pass*,community`). If you named your custom variable `frtiz_password` it will be protected by the default entry `*pass*`.
4. Check it by going to one of your Fritz!Box service and check if the password is display with ``***``.

## Contributors

- [mcktr](https://github.com/mcktr)

Thanks to all contributors!

- [cxcv](https://github.com/cxcv) for fixing a bug with [performance data output](https://github.com/mcktr/check_tr64_fritz/pull/23)
- [uclara](https://github.com/uclara) for proposing to add [adjustable warning/critical values for the functions down-/upstream](https://github.com/mcktr/check_tr64_fritz/issues/40)
- [matthenning](https://github.com/matthenning) for reporting and helping resolving a [bug on Fritz!Box cable models](https://github.com/mcktr/check_tr64_fritz/issues/30)


## Thanks

- [FRITZ!Box mit Nagios überwachen](http://blog.gmeiners.net/2013/09/fritzbox-mit-nagios-uberwachen.html)
- [Fritz!Box and TR-064](http://heise.de/-2550500)

## Development

Fork the project to your GitHub account, commit your changes and send a pull request. For developing on
this project it is advantageous to have a Fritz!Box at your place to test your changes.

Before we start to fetching and parsing the TR-064 data we need to know which data our
Fritz!Box provides. We can either fetch a list of this directly from the Fritz!Box or
we can also look into the documentation from the manufacturer AVM. It is good to do both,
make sure that the data we want to fetch is supported by AVM and our Fritz!Box actually 
provides it.

You can fetch the list directly from the Fritz!Box, go to 
`http://<Your Fritz!Box IP Address>:49000/tr64desc.xml` to fetch this list.
You will get a XML file that contains many entries and it looks like the following.

```
[...]
<service>
  serviceType>urn:dslforum-org:service:DeviceInfo:1</serviceType>
  serviceId>urn:DeviceInfo-com:serviceId:DeviceInfo1</serviceId>
  controlURL>/upnp/control/deviceinfo</controlURL>
  eventSubURL>/upnp/control/deviceinfo</eventSubURL>
  SCPDURL>/deviceinfoSCPD.xml</SCPDURL>
</service>
[...]
```

| Name        | Description                                                              |
| ---         | ---                                                                      |
| serviceType | Service category which we want to call                                   |
| controlURL  | URL we need to call, when fetching information from the choosen category |

You can find the manufacturer  documentation [here](https://avm.de/service/schnittstellen/). 
Have a look into the PDF files and search for a __action__ that provides your needed data.

To finally create our TR-064 request we need three information beforehand. 

1. The _serviceType_ e.g. `DeviceInfo`
2. The _controlURL_ e.g. `deviceinfo` (Only the last part after the slash.)
3. The _action_ e.g. 'GetInfo' (Look into the manufacturer documentation to find those.)

Inside the `devel` directory you can find a bash script, that allows you to fetch the raw TR-064 data (basically in  XML
format).

__fetch_tr64_data.sh__

This script fetches and output the raw TR-064 data.

__Arugments__

| Name | Description                           |
| ---  | ---                                   |
| -h   | Hostname/IP Adress of your Fritz!Box. |
| -p   | The port number for TR-064 over SSL.  |
| -u   | Username.                             |
| -P   | Password.                             |
| -U   | _controlURL_.                         |
| -s   | _serviceType_.                        |
| -a   | _action_.                             |
| -x   | Index.                                |

_Example:_

```
./fetch_tr64_data.sh -P [PASSWORD] -U deviceinfo -s DeviceInfo -a GetInfo


fritz.box
49443
dslf-config
[PASSWORD]
deviceinfo
DeviceInfo
GetInfo



<?xml version="1.0"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<s:Body>
<u:GetInfoResponse xmlns:u="urn:dslforum-org:service:DeviceInfo:1">
<NewManufacturerName>AVM</NewManufacturerName>
<NewManufacturerOUI>00040E</NewManufacturerOUI>
<NewModelName>FRITZ!Box 7490</NewModelName>
<NewDescription>FRITZ!Box 7490 113.06.92</NewDescription>
<NewProductClass>FRITZ!Box</NewProductClass>
<NewSerialNumber>[SERIALNO.]</NewSerialNumber>
<NewSoftwareVersion>113.06.92</NewSoftwareVersion>
<NewHardwareVersion>FRITZ!Box 7490</NewHardwareVersion>
<NewSpecVersion>1.0</NewSpecVersion>
<NewProvisioningCode>[CODE]</NewProvisioningCode>
<NewUpTime>97384</NewUpTime>
<NewDeviceLog>
[LOG]
</NewDeviceLog>
</u:GetInfoResponse>
</s:Body>
</s:Envelope>
```

Now you can see the raw TR-064 and see if your needed information is in there. If yes you can now extend the check plugin script and parsing the output to output the result in a proper format. 
