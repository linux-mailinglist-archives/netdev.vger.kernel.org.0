Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D02473DD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404032AbgHQTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:02:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731794AbgHQTCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 15:02:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7kOR-009m4B-Na; Mon, 17 Aug 2020 21:02:03 +0200
Date:   Mon, 17 Aug 2020 21:02:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: mv88e6xxx: Add devlink regions
Message-ID: <20200817190203.GD2291654@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-6-andrew@lunn.ch>
 <20200816221205.mspo63dohn7pvxg4@skbuf>
 <20200816223941.GC2294711@lunn.ch>
 <93a2b736-ff45-4529-c63a-b384db12b232@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a2b736-ff45-4529-c63a-b384db12b232@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Looking at the documentation above (assuming it is up to date), these
> are raw hex dumps of the region, which is mildly useful.
> 
> If we were to pretty print those regions such that they can fully
> replace the infamous debugfs interface patch from Vivien that has been
> floated around before, what other information is available (besides the
> driver name) for the user-space tools to do that pretty printing?

Hi Florian

https://github.com/lunn/mv88e6xx_dump

root@rap:~# /home/andrew/mv88e6xxx_dump/mv88e6xxx_dump --atu --global1 --global2 --ports --port 1
Using device <mdio_bus/gpio-0:00>
00 Port status                            0x1e4f
      Transmit Pause Enable bit            0
      Receive Pause Enable bit             0
      802.3 PHY Detected                   1
      Link Status                          Up
      Duplex                               Full
      Speed                                1000 Mbps
      Duplex Fixed                         0
      EEE Enabled                          1
      Transmitter Paused                   0
      Flow Control                         0
      Config Mode                          0xf
01 Physical control                       0x203e
      RGMII Receive Timing Control         Default
      RGMII Transmit Timing Control        Default
      Force Speed                          1
      Alternate Speed Mode                 Normal
      MII PHY Mode                         MAC
      EEE force value                      0
      Force EEE                            0
      Link's Forced value                  Up
      Force Link                           1
      Duplex's Forced value                Full
      Force Duplex                         1
      Force Speed                          1000 Mbps
02 Flow control                           0x0100
03 Switch ID                              0x3901
04 Port control                           0x053f
      Source Address Filtering controls    Disabled
      Egress Mode                          Unmodified
      Ingress & Egress Header Mode         0
      IGMP and MLD Snooping                1
      Frame Mode                           DSA
      VLAN Tunnel                          0
      TagIfBoth                            0
      Initial Priority assignment          Tag & IP Priority
      Egress Flooding mode                 Allow unknown DA
      Port State                           Forwarding
05 Port control 1                         0x0000
      Message Port                         0
      LAG Port                             0
      VTU Page                             0
      LAG ID                               0
      FID[11:4]                            0x000
06 Port base VLAN map                     0x07fd
      FID[3:0]                             0x000
      Force Mapping                        0
      VLANTable                            0 2 3 4 5 6 7 8 9 10 
07 Def VLAN ID & Prio                     0x0000
      Default Priority                     0x0
      Force to use Default VID             0
      Default VLAN Identifier              0
08 Port control 2                         0x0080
      Force good FCS in the frame          0
      Allow bad FCS                        0
      Jumbo Mode                           1522
      802.1QMode                           Disabled
      Discard Tagged Frames                0
      Discard Untagged Frames              0
      Map using DA hits                    1
      ARP Mirror enable                    0
      Egress Monitor Source Port           0
      Ingress Monitor Source Port          0
      Allow VID of Zero                    0
      Default Queue Priority               0x0
09 Egress rate control                    0x0001
0a Egress rate control 2                  0x0000
0b Port association vec                   0x0000
0c Port ATU control                       0x0000
0d Override                               0x0000
0e Policy control                         0x0000
0f Port ether type                        0x9100
10 Reserved                               0x0000
11 Reserved                               0x0000
12 Reserved                               0x0000
13 Reserved                               0x0000
14 Reserved                               0x0000
15 Reserved                               0x0000
16 LED control                            0x0022
17 IP prio map table                      0x0000
18 IEEE prio map table                    0x3e07
19 Port control 3                         0x0000
1a Reserved                               0x0000
1b Queue counters                         0x8000
1c Queue control                          0x0000
1d Reserved                               0x0000
1e Cut through control                    0x0000
1f Debug counters                         0x003d
			   0    1    2    3    4    5    6    7    8    9   10 
00 Port status            0e07 1e4f 100f 100f de4f 100f 100f 100f 1d0f 0049 0049 
01 Physical control       0003 203e 0003 0003 0003 0003 0003 0003 0003 0003 0003 
02 Flow control           0000 0100 0100 0100 0100 0000 0000 0000 0100 0000 0000 
03 Switch ID              3901 3901 3901 3901 3901 3901 3901 3901 3901 3901 3901 
04 Port control           007c 053f 0433 0433 0433 007c 007c 007c 0433 007c 007c 
05 Port control 1         0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
06 Port base VLAN map     07fe 07fd 0002 0002 0002 07df 07bf 077f 0002 05ff 03ff 
07 Def VLAN ID & Prio     0001 0000 0000 0000 0000 0001 0001 0001 0000 0001 0001 
08 Port control 2         2080 0080 0080 0080 0080 2080 2080 2080 0080 2080 2080 
09 Egress rate control    0001 0001 0001 0001 0001 0001 0001 0001 0001 0001 0001 
0a Egress rate control 2  8000 0000 0000 0000 0000 8000 8000 8000 0000 8000 8000 
0b Port association vec   0001 0000 0004 0008 0010 0020 0040 0080 0100 0200 0400 
0c Port ATU control       0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
0d Override               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
0e Policy control         0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
0f Port ether type        9100 9100 9100 9100 9100 9100 9100 9100 9100 9100 9100 
10 Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
11 Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
12 Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
13 Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
14 Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
15 Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
16 LED control            0000 0022 0022 0022 0022 0022 0022 0022 0022 0022 0022 
17 IP prio map table      0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
18 IEEE prio map table    0000 3e07 3e07 3e07 3e07 0000 0000 0000 3e07 0000 0000 
19 Port control 3         0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
1a Reserved               0000 0000 0000 0000 3d40 01c0 0000 0000 0000 0000 0000 
1b Queue counters         8000 8000 8000 8000 8000 8000 8000 8000 8000 8000 8000 
1c Queue control          0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
1d Reserved               0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
1e Cut through control    0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 
1f Debug counters         0000 003d 0000 0000 0077 0000 0000 0000 0000 0000 0000 
ATU:
FID  MAC	       T 0123456789A Prio State
   0 ff:ff:ff:ff:ff:ff   11111100000    0 Static
Global1:
 0 c814
 1 0000
 2 0000
 3 0000
 4 40a8
 5 4000
 6 2fff
 7 0000
 8 0000
 9 0000
10 0509
11 4000
12 7ff7
13 ffff
14 ffff
15 ffff
16 0000
17 0000
18 0000
19 0000
20 0000
21 0000
22 0000
23 0000
24 0000
25 0000
26 03ff
27 03fd
28 07c0
29 1000
30 0000
31 0000
Global2:
 0 0000
 1 811c
 2 0000
 3 0000
 4 0258
 5 0400
 6 1f1f
 7 77ff
 8 7800
 9 2a00
10 0000
11 31ff
12 0000
13 0589
14 0001
15 0f00
16 0000
17 0000
18 0000
19 0300
20 0000
21 0000
22 5e0e
23 0000
24 1885
25 c5e1
26 0000
27 110f
28 0000
29 0000
30 0000
31 0000

Still WIP. I want to add at least names for the global1 and glabel2. 

> Right now, as with any single user facility it is a bit difficult to
> determine whether a DSA common representation would be warranted.

This is all specific to the mv88e6xxx. Vivien had two debugfs
patchsets. One for generic DSA properties and a second one for
mv88e6xxx specific stuff. The regions i've added only cover the
mv88e6xxx specific stuff.

The recent devlink metric's should help with some parts of the generic
debugfs code.

Andrew
