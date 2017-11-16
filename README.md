# check_tr64_fritz

#### Table of Contents

1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Usage](#usage)
4. [Authors](#authors)
5. [Thanks](#thanks)

## Introduction

This is a check plugin for Icinga 2 to monitor a Fritz!Box.

## Requirements

__Required packages__

You need the following packages installed to use this check plugin:

- `curl`
- `bc`

Please use your favorite package manager to install them.

__Fritz!Box configuration__

The TR-064 feature must be enabled on the Fritz!Box. You can do that by going to
the following menu `Heimnetz` -> `Netzwerk`, switch to the tab
`Netzwerkeinstellungen`. Now you must enable the entry `Zugriff für Anwendungen
zulassen`. The Fritz!Box needs a restart, after that the TR-064 feature is
enabled.

> If you don't see the entry `Zugriff für Anwendungen zulassen` you must enable
> the advanced view(`Erweiterte Ansicht`).

## Installation

1. Get the [latest stable release](https://github.com/mcktr/check_tr64_fritz/releases)
2. Open and extract the archiv
3. Execute the `getSecurityPort` script, to find your TR-064 SSL port out
4. Copy the `check_tr64_fritz` script to your Icinga 2 check plugin directory
5. Add the CheckCommand definition to your Icinga 2 configuration. Have a look inside the Icinga 2 documentation for more details.
6. Create a new service in Icinga 2 for your Fritz!Box

## Usage

__getSecurityPort__

```
getSecurityPort <HOST>
```

| Name | Description                               |
| ---  | ---                                       |
| HOST | Hostname or IP address of your Fritz!Box. |

_Example_

```
$ ./getSecurityPort 192.168.178.1
Your Fritz!Box Security Port (for TR-064 over SSL) is: 49443
```

__check_tr64_fritz__

```
check_tr64_fritz -h <HOSTNAME> -p <PORT> -u <USERNAME> -P <PASSWORD> -f <FUNCTION> -w <WARNING> -c <CRITICAL>
```

__Arguments__

| Name | Description                                                                       |
| ---  | ---                                                                               |
| -h   | **Optional.** Hostname or IP address of your Fritz!Box. _Defaults to "fritz.box"._          |
| -p   | **Optional.** The port number for TR-064 over SSL. _Defaults to "49443"._                   |
| -u   | **Optional.** Username to authenticate against the Fritz!Box. _Defaults to "dslf-config"._  |
| -P   | **Required.** Password to authenticate against the Fritz!Box.                       |
| -f   | **Optional.** Function that should be checked. _Defaults to "status"._                      |
| -w   | **Optional.** Warning threshold _Defaults to "0"._                                |
| -c   | **Optional.** Critical threshold _Defaults to "0."_                                         |
| -v   | **Optional.** Print current plugin version and usage text.                                       |
| -d   | **Optional.** Print debug information (TR-064  XML output.)                                      |

> The username and password are the same as for the web interface of your
> Fritz!Box. If you don't use the login method with username and password, you
> can leave the username empty.

__Functions__

| Name           | Description                                                                                           |
| --             | ---                                                                                                   |
| status         | Returns the connection state.                                                                         |
| linkuptime     | Returns the uptime of the WAN link.                                                                   |
| uptime         | Returns the device uptime.                                                                            |
| downstream     | Returns the usable downstream rate in MBit/s.                                                         |
| upstream       | Returns the usable upstream rate in MBit/s.                                                           |
| downstreamrate | Returns the current downstream speed in MBit/s.                                                       |
| upstreamrate   | Returns the current upstream speed in MBits/s.                                                        |
| updte          | Returns the update state.                                                                             |
| thermometer    | Returns the connection status and temperature of a smart home thermometer device. __Requieres index__ |

> You specify the index with a double point and the index number after the function name e.g. `thermometer:3`.

_Example_

```
$ ./check_tr64_fritz -P password -f uptime
OK - Uptime 29990 seconds (0d 8h 19m 50s) | uptime=2999

$ ./check_tr64_fritz -P password -f thermometer:3
OK - Comet DECT 03.68 - Wohnzimmer CONNECTED 21.5 °C | thermometer_current_state=0 thermometer_current_temp=21.5 warn=0 crit=0
```

## Authors

- [mcktr](https://github.com/mcktr)

Thanks to all contributors!

- [cxcv](https://github.com/cxcv) for fixing a bug with [performance data output](https://github.com/mcktr/check_tr64_fritz/pull/23)


## Thanks

- [FRITZ!Box mit Nagios überwachen](http://blog.gmeiners.net/2013/09/fritzbox-mit-nagios-uberwachen.html)
- [Fritz!Box and TR-064](http://heise.de/-2550500)

