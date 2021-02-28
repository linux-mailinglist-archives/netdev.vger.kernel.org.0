Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635FF32734E
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 17:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhB1QNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 11:13:10 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41097 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhB1QNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 11:13:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BD8DA5800B3;
        Sun, 28 Feb 2021 11:12:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 28 Feb 2021 11:12:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aIa+bf
        wGh/yiHt8uWY5VZV8tNetvLQpe7UTeHhjqxkc=; b=gqPp5EAkT9gW4ZbNk2mfiP
        eB57oIAg27Amfgw+1Ljy2844YE9d2llDTkvwsafnMTtuD4BP3FAwtYbjGxtBAsjf
        AlrzTQPOnZ/nLuMub2RIQYKB/KdY1DsWwa14jkMOSbXxHvJl/+z98ML/l2drtKIv
        xDQknctK2TWlTxHHCED4yqzI+vIz6pA2xff/FPYLQVk46SEzzCSxxN3uosn+/V3B
        ecvAI8pOt1701lpCzhyDC8rFhl5Lf/Y4+0xbjM+QeCw5luEuwXe77G3kjHVSYQq2
        UvKh+B0K5LesvXlaxWero9yOlveplgF1tNObggpdJp0+lHjMiUGL+TlX9OFYFPEw
        ==
X-ME-Sender: <xms:z8A7YNk4OXi5-211l59ILMHgQI5xz3HZn4Xui8FwVrZ5kQQS1RjlOA>
    <xme:z8A7YI1Gcne6QPvXhyuMbCQq5PHyqXUKd1cjIyHMojOReMKQUjBWHmhHUcEkdPVhY
    zh6TH_pkAtIVuI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleeigdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:z8A7YDoQZ85Sqrby4g8VvsYXasyMge-8yy_zhagtlsrhWlRCmn32Sg>
    <xmx:z8A7YNlw0QBQUy7Dhbvb1AO4A6s1sskwmvQHnkoC3M8LPH894t8Dfw>
    <xmx:z8A7YL3G3_aQVSPGSY0XMPJeERMlmnVimwnj4pZ_ivYQKpZof1S_qg>
    <xmx:0MA7YAmO3gLUc_oZPcPIv7BJKyn6pPJgYJw8mz-SkTc4Xr50PG7oXw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66B6A1080054;
        Sun, 28 Feb 2021 11:11:59 -0500 (EST)
Date:   Sun, 28 Feb 2021 18:11:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 11/12] Documentation: networking: switchdev:
 clarify device driver behavior
Message-ID: <YDvAzCBGDeGxZ1bh@shredder.lan>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-12-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 11:33:54PM +0200, Vladimir Oltean wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> This patch provides details on the expected behavior of switchdev
> enabled network devices when operating in a "stand alone" mode, as well
> as when being bridge members. This clarifies a number of things that
> recently came up during a bug fixing session on the b53 DSA switch
> driver.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/switchdev.rst | 120 +++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
> 
> diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
> index ddc3f35775dc..9fb3e0fd39dc 100644
> --- a/Documentation/networking/switchdev.rst
> +++ b/Documentation/networking/switchdev.rst
> @@ -385,3 +385,123 @@ The driver can monitor for updates to arp_tbl using the netevent notifier
>  NETEVENT_NEIGH_UPDATE.  The device can be programmed with resolved nexthops
>  for the routes as arp_tbl updates.  The driver implements ndo_neigh_destroy
>  to know when arp_tbl neighbor entries are purged from the port.
> +
> +Device driver expected behavior
> +-------------------------------
> +
> +Below is a set of defined behavior that switchdev enabled network devices must
> +adhere to.
> +
> +Configuration-less state
> +^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Upon driver bring up, the network devices must be fully operational, and the
> +backing driver must configure the network device such that it is possible to
> +send and receive traffic to this network device and it is properly separated
> +from other network devices/ports (e.g.: as is frequent with a switch ASIC). How
> +this is achieved is heavily hardware dependent, but a simple solution can be to
> +use per-port VLAN identifiers unless a better mechanism is available
> +(proprietary metadata for each network port for instance).
> +
> +The network device must be capable of running a full IP protocol stack
> +including multicast, DHCP, IPv4/6, etc. If necessary, it should program the
> +appropriate filters for VLAN, multicast, unicast etc. The underlying device
> +driver must effectively be configured in a similar fashion to what it would do
> +when IGMP snooping is enabled for IP multicast over these switchdev network
> +devices and unsolicited multicast must be filtered as early as possible into
> +the hardware.
> +
> +When configuring VLANs on top of the network device, all VLANs must be working,
> +irrespective of the state of other network devices (e.g.: other ports being part
> +of a VLAN-aware bridge doing ingress VID checking). See below for details.
> +
> +If the device implements e.g.: VLAN filtering, putting the interface in
> +promiscuous mode should allow the reception of all VLAN tags (including those
> +not present in the filter(s)).
> +
> +Bridged switch ports
> +^^^^^^^^^^^^^^^^^^^^
> +
> +When a switchdev enabled network device is added as a bridge member, it should
> +not disrupt any functionality of non-bridged network devices and they
> +should continue to behave as normal network devices. Depending on the bridge
> +configuration knobs below, the expected behavior is documented.
> +
> +Bridge VLAN filtering
> +^^^^^^^^^^^^^^^^^^^^^
> +
> +The Linux bridge allows the configuration of a VLAN filtering mode (statically,
> +at device creation time, and dynamically, during run time) which must be
> +observed by the underlying switchdev network device/hardware:
> +
> +- with VLAN filtering turned off: the bridge is strictly VLAN unaware and its
> +  data path will only process untagged Ethernet frames. Frames ingressing the
> +  device with a VID that is not programmed into the bridge/switch's VLAN table
> +  must be forwarded and may be processed using a VLAN device (see below).

This needs some more clarification like Andrew noted. If you put a port
in a VLAN-unaware bridge, the bridge will process all the packets,
regardless if they are tagged or untagged.

If you then create a VLAN device on top of the port and put it in a
second VLAN-unaware bridge, then the second bridge will process the VLAN
packets after they were untagged by the VLAN device. Obviously, other
VLAN-tagged packets that do not belong to the VLAN device will continue
to be processed by the first bridge.

I'm not sure if you can support such a flexible model in hardware or
not. To avoid disambiguation you can prevent user space from creating
VLAN devices on top of a port that is member in a VLAN-unaware bridge,
but this is very very limiting.

Instead, the common deployment scenario is that VLAN-unaware bridges
only forward untagged packets. Regardless if they were received untagged
or were untagged by a VLAN device.

> +
> +- with VLAN filtering turned on: the bridge is VLAN-aware and frames ingressing
> +  the device with a VID that is not programmed into the bridges/switch's VLAN
> +  table must be dropped (strict VID checking).

Worth mentioning that the VLAN protocol of the bridge plays a role in
deciding whether a packet is tagged or not. For example, a 802.1ad
bridge will also treat 802.1q tagged packets as untagged.

I would also mention the expected behavior with regards to the presence
of PVID:

* When PVID exists: Untagged and prio-tagged packets belong to the PVID
* When PVID does not exists: Untagged and prio-tagged packets are
  dropped

Note that if you really need to support a scenario where both untagged
and 802.1q tagged packets are forwarded the same, you can create a
802.1ad bridge.

> +
> +Non-bridged network ports of the same switch fabric must not be disturbed in any
> +way by the enabling of VLAN filtering on the bridge device(s).
> +
> +VLAN devices configured on top of a switchdev network device (e.g: sw0p1.100)
> +which is a bridge port member must also observe the following behavior:
> +
> +- with VLAN filtering turned off, enslaving VLAN devices into the bridge might
> +  be allowed provided that there is sufficient separation using e.g.: a
> +  reserved VLAN ID (4095 for instance) for untagged traffic. The VLAN data path
> +  is used to pop/push the VLAN tag such that the bridge's data path only
> +  processes untagged traffic.
> +
> +- with VLAN filtering turned on, these VLAN devices can be created as long as
> +  there is not an existing VLAN entry into the bridge with an identical VID and
> +  port membership. These VLAN devices cannot be enslaved into the bridge since
> +  they duplicate functionality/use case with the bridge's VLAN data path
> +  processing.
> +
> +Because VLAN filtering can be turned on/off at runtime, the switchdev driver
> +must be able to reconfigure the underlying hardware on the fly to honor the
> +toggling of that option and behave appropriately.
> +
> +A switchdev driver can also refuse to support dynamic toggling of the VLAN
> +filtering knob at runtime and require a destruction of the bridge device(s) and
> +creation of new bridge device(s) with a different VLAN filtering value to
> +ensure VLAN awareness is pushed down to the hardware.
> +
> +Finally, even when VLAN filtering in the bridge is turned off, the underlying
> +switch hardware and driver may still configured itself in a VLAN-aware mode
> +provided that the behavior described above is observed.
> +
> +Bridge IGMP snooping
> +^^^^^^^^^^^^^^^^^^^^
> +
> +The Linux bridge allows the configuration of IGMP snooping (statically, at
> +interface creation time, or dynamically, during runtime) which must be observed
> +by the underlying switchdev network device/hardware in the following way:
> +
> +- when IGMP snooping is turned off, multicast traffic must be flooded to all
> +  ports within the same bridge that have mcast_flood=true. The CPU/management
> +  port should ideally not be flooded (unless the ingress interface has
> +  IFF_ALLMULTI or IFF_PROMISC) and continue to learn multicast traffic through
> +  the network stack notifications. If the hardware is not capable of doing that
> +  then the CPU/management port must also be flooded and multicast filtering
> +  happens in software.
> +
> +- when IGMP snooping is turned on, multicast traffic must selectively flow
> +  to the appropriate network ports (including CPU/management port). Flooding of
> +  unknown multicast should be only towards the ports connected to a multicast
> +  router (the local device may also act as a multicast router).
> +
> +The switch must adhere to RFC 4541 and flood multicast traffic accordingly
> +since that is what the Linux bridge implementation does.
> +
> +Because IGMP snooping can be turned on/off at runtime, the switchdev driver
> +must be able to reconfigure the underlying hardware on the fly to honor the
> +toggling of that option and behave appropriately.
> +
> +A switchdev driver can also refuse to support dynamic toggling of the multicast
> +snooping knob at runtime and require the destruction of the bridge device(s)
> +and creation of a new bridge device(s) with a different multicast snooping
> +value.
> -- 
> 2.25.1
> 
