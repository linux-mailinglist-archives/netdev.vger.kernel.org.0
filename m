Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0711DFF4A
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgEXOHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 10:07:04 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58967 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727985AbgEXOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 10:07:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5506C580B9B;
        Sun, 24 May 2020 10:07:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 10:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xxOsgh
        sY5NF9a80BeCz/H7XEbKW1nx0x6SvQhA+NGEc=; b=xAn1y8Fz4fOGO86+qNoCzG
        xoEk4NgqGWO8RvVuWNz43GB94WuKbE/J7tnSpHfBILyOrQeCALBdrJLG5MGdMBmP
        UVElQFG4rnBTXwiEIYE1NjaYq86qPdMkCL3nO7DhqKjw4lLP3jC6/E1fL86htrpj
        qRdJlaj3Oh0NmYI1rs2DhyrSIn65RuS1xwwx0LIzkG3xwjU+qbaKKD3gS8PQisPT
        gwm8JT+FJ9W6u3NCvuKPdIiRdSSoTVTllSAuMY+2k7Xp0O+Wl3fSN6EXqY5K79VP
        XWMant+tztNjGPgJTaGHllAJT5uQE4r0kdGbqxGr//A7WCNzBPcl7aFsfPlc1mgg
        ==
X-ME-Sender: <xms:g3_KXlW4oXCHOKJfmihzJHu5hisAE3_pgIPbBYwo7prZprpohC5Z1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddukedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtieevuedvgeffhfelfffhieevudefkedtheekuedvkefgveektdefudekvdfh
    teenucffohhmrghinhepshhpihhnihgtshdrnhgvthdplhhkmhhlrdhorhhgpdihohhuth
    husggvrdgtohhmnecukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthh
    drohhrgh
X-ME-Proxy: <xmx:g3_KXln2ySyO8WMlB0syoKF8b6lUBWoAY9s1y0LHaZGBVv7LayU1gw>
    <xmx:g3_KXhYyvsRxe4c5RRvPizsIa9MCEtqWDJf45F4KtnWrIL3iPD1lPA>
    <xmx:g3_KXoWDJivZWi9e1UI_HIG8QSuwkzQahBAe2L4soj3x7REYkLr0EQ>
    <xmx:hn_KXh7MVZoWN67Rgy4VN4_BB84nydRGqMDlsiVqPp3yMOvO6HddNw>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93441306648A;
        Sun, 24 May 2020 10:06:59 -0400 (EDT)
Date:   Sun, 24 May 2020 17:06:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20200524140657.GA1281067@splinter>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 12:10:23AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a WIP series whose stated goal is to allow DSA and switchdev
> drivers to flood less traffic to the CPU while keeping the same level of
> functionality.
> 
> The strategy is to whitelist towards the CPU only the {DMAC, VLAN} pairs
> that the operating system has expressed its interest in, either due to
> those being the MAC addresses of one of the switch ports, or addresses
> added to our device's RX filter via calls to dev_uc_add/dev_mc_add.
> Then, the traffic which is not explicitly whitelisted is not sent by the
> hardware to the CPU, under the assumption that the CPU didn't ask for it
> and would have dropped it anyway.
> 
> The ground for these patches were the discussions surrounding RX
> filtering with switchdev in general, as well as with DSA in particular:
> 
> "[PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code":
> https://www.spinics.net/lists/netdev/msg651922.html
> "[PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module":
> https://www.spinics.net/lists/netdev/msg634859.html
> "[PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity":
> https://lkml.org/lkml/2019/8/29/255
> LPC2019 - SwitchDev offload optimizations:
> https://www.youtube.com/watch?v=B1HhxEcU7Jg
> 
> Unicast filtering comes to me as most important, and this includes
> termination of MAC addresses corresponding to the network interfaces in
> the system (DSA switch ports, VLAN sub-interfaces, bridge interface).
> The first 4 patches use Ivan Khoronzhuk's IVDF framework for extending
> network interface addresses with a Virtual ID (typically VLAN ID). This
> matches DSA switches perfectly because their FDB already contains keys
> of the {DMAC, VID} form.

Hi,

I read through the series and I'm not sure how unicast filtering works.
Instead of writing a very long mail I just created a script with
comments. I think it's clearer that way. Note that this is not a made up
configuration. It is used in setups involving VRRP / VXLAN, for example.

```
#!/bin/bash

ip netns add ns1

ip -n ns1 link add name br0 type bridge vlan_filtering 1
ip -n ns1 link add name dummy10 up type dummy

ip -n ns1 link set dev dummy10 master br0
ip -n ns1 link set dev br0 up

ip -n ns1 link add link br0 name vlan10 up type vlan id 10
bridge -n ns1 vlan add vid 10 dev br0 self

echo "Before adding macvlan:"
echo "======================"

echo -n "Promiscuous mode: "
ip -n ns1 -j -p -d link show dev br0 | jq .[][\"promiscuity\"]

echo -e "\nvlan10's MAC is in br0's FDB:"
bridge -n ns1 fdb show br0 vlan 10

echo
echo "After adding macvlan:"
echo "====================="

ip -n ns1 link add link vlan10 name vlan10-v up address 00:00:5e:00:01:01 \
        type macvlan mode private

echo -n "Promiscuous mode: "
ip -n ns1 -j -p -d link show dev br0 | jq .[][\"promiscuity\"]

echo -e "\nvlan10-v's MAC is not in br0's FDB:"
bridge -n ns1 fdb show br0 | grep master | grep 00:00:5e:00:01:01
```

This is the output on my laptop (kernel 5.6.8):

```
Before adding macvlan:
======================
Promiscuous mode: 0

vlan10's MAC is in br0's FDB:
42:bd:b1:cc:67:15 dev br0 vlan 10 master br0 permanent

After adding macvlan:
=====================
Promiscuous mode: 1

vlan10-v's MAC is not in br0's FDB:
```

Basically, if the MAC of the VLAN device is not inherited from the
bridge or you stack macvlans on top, then the bridge will go into
promiscuous mode and it will locally receive all frames passing through
it. It's not ideal, but it's a very old and simple behavior. It does not
require you to track the VLAN associated with the MAC addresses, for
example.

When you are offloading the Linux data path to hardware this behavior is
not ideal as your hardware can handle much higher packet rates than the
CPU.

In mlxsw we handle this by tracking the upper devices of the bridge. I
was hoping that with Ivan's patches we could add support for unicast
filtering in the bridge driver and program the MAC addresses to its FDB
with 'local' flag. Then the FDB entries would be notified via switchdev
to device drivers.

> 
> Multicast filtering was taken and reworked from Florian Fainelli's
> previous attempts, according to my own understanding of multicast
> forwarding requirements of an IGMP snooping switch. This is the part
> that needs the most extra work, not only in the DSA core but also in
> drivers. For this reason, I've left out of this patchset anything that
> has to do with driver-level configuration (since the audience is a bit
> larger than usual), as I'm trying to focus more on policy for now, and
> the series is already pretty huge.

From what I remember, this is the logic in the Linux bridge:

* Broadcast is always locally received
* Multicast is locally received if:
	* Snooping disabled
	* Snooping enabled:
		* Bridge netdev is mrouter port
		or
		* Matches MDB entry with 'host_joined' indication

> 
> Florian Fainelli (3):
>   net: bridge: multicast: propagate br_mc_disabled_update() return
>   net: dsa: add ability to program unicast and multicast filters for CPU
>     port
>   net: dsa: wire up multicast IGMP snooping attribute notification
> 
> Ivan Khoronzhuk (4):
>   net: core: dev_addr_lists: add VID to device address
>   net: 8021q: vlan_dev: add vid tag to addresses of uc and mc lists
>   net: 8021q: vlan_dev: add vid tag for vlan device own address
>   ethernet: eth: add default vid len for all ethernet kind devices
> 
> Vladimir Oltean (6):
>   net: core: dev_addr_lists: export some raw __hw_addr helpers
>   net: dsa: don't use switchdev_notifier_fdb_info in
>     dsa_switchdev_event_work
>   net: dsa: mroute: don't panic the kernel if called without the prepare
>     phase
>   net: bridge: add port flags for host flooding
>   net: dsa: deal with new flooding port attributes from bridge
>   net: dsa: treat switchdev notifications for multicast router connected
>     to port
> 
>  include/linux/if_bridge.h |   3 +
>  include/linux/if_vlan.h   |   2 +
>  include/linux/netdevice.h |  11 ++
>  include/net/dsa.h         |  17 +++
>  net/8021q/Kconfig         |  12 ++
>  net/8021q/vlan.c          |   3 +
>  net/8021q/vlan.h          |   2 +
>  net/8021q/vlan_core.c     |  25 ++++
>  net/8021q/vlan_dev.c      | 102 +++++++++++---
>  net/bridge/br_if.c        |  40 ++++++
>  net/bridge/br_multicast.c |  21 ++-
>  net/bridge/br_switchdev.c |   4 +-
>  net/core/dev_addr_lists.c | 144 +++++++++++++++----
>  net/dsa/Kconfig           |   1 +
>  net/dsa/dsa2.c            |   6 +
>  net/dsa/dsa_priv.h        |  27 +++-
>  net/dsa/port.c            | 155 ++++++++++++++++----
>  net/dsa/slave.c           | 288 +++++++++++++++++++++++++++++++-------
>  net/dsa/switch.c          |  36 +++++
>  net/ethernet/eth.c        |  12 +-
>  20 files changed, 780 insertions(+), 131 deletions(-)
> 
> -- 
> 2.25.1
> 
