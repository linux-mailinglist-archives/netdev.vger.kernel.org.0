Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0163195BE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBKWWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:22:14 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:32947 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229936AbhBKWWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:22:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E942F580360;
        Thu, 11 Feb 2021 17:20:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 Feb 2021 17:20:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WQ5jES
        djDsSedEzelgiCJkKsS0wvUGc1S3PSUMYfph8=; b=DkN0P0CRQGfKQEu+BegReF
        KdyJW9cvlF/Eyacc+8RlcVDGYT+KN2hSJ3KHRCiznolgqztW3XWHg28RSnKk8Hrs
        /kDAmVzG/EPeWhEPwgtfaGwnqQlkJL9JeeczDcaKtOY+Nd9a/82+j65LW2OUDRQw
        zfQOFTejX/BdjyRLXH66/eHCelGlN1Xn+0T+uefscuxS1XPudGNuqMkPodMIOgby
        Wj+5NuNsQ/zadyC7F3V89wREkT+APjsguLkFpK/P1BXN3FKSfhOAT2k0txuYoMKh
        dXCkEu83mAVjtHPPBJzvfiBIepZLaL+tNyYYGO4At9wxdpkvaw60zsHZjMO5HlHA
        ==
X-ME-Sender: <xms:xq0lYFpXKHYp6ianhjHh8ck7Ubhyagjq3HHGvc2E4yeBc6UeRdOicA>
    <xme:xq0lYHoplmg4cRHnQQj6rnOFlqMl_S4M3NRyq-PfawEwlpo6lYJtja4gt3hWyW34a
    5nJOfqCvtzwsL8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheelgdduheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xq0lYCOdC3HXFqxstUTOfHI1trc-Ww_W3M9TQfDrXNVsucSDLMQrrQ>
    <xmx:xq0lYA7GRgwiUBdiwXyNQ64CDCHCLAnuqIAEwfR8QWgO_d0RsguisA>
    <xmx:xq0lYE6sPsWpPx3FwBLS9hSPFn87ajPfvk-vtGpjV60SlQwYW3UnsA>
    <xmx:x60lYBP7VXzW8mARoMweeqyoGqtRFXfRnqjp8F1Q8RDWr76DCWFV2Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C883240057;
        Thu, 11 Feb 2021 17:20:53 -0500 (EST)
Date:   Fri, 12 Feb 2021 00:20:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210211222050.GA374961@shredder.lan>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
 <20210209185100.GA266253@shredder.lan>
 <20210209202045.obayorcud4fg2qqb@skbuf>
 <20210209220124.GA271860@shredder.lan>
 <20210209225153.j7u6zwnpdgskvr2v@skbuf>
 <20210210105949.GB287766@shredder.lan>
 <20210210232352.m7nqzvs2g4i74rx4@skbuf>
 <20210211074443.GB324421@shredder.lan>
 <20210211093527.qyaa3czumgggvm7z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211093527.qyaa3czumgggvm7z@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:35:27AM +0200, Vladimir Oltean wrote:
> On Thu, Feb 11, 2021 at 09:44:43AM +0200, Ido Schimmel wrote:
> > On Thu, Feb 11, 2021 at 01:23:52AM +0200, Vladimir Oltean wrote:
> > > On Wed, Feb 10, 2021 at 12:59:49PM +0200, Ido Schimmel wrote:
> > > > > > The reverse, during unlinking, would be to refuse unlinking if the upper
> > > > > > has uppers of its own. netdev_upper_dev_unlink() needs to learn to
> > > > > > return an error and callers such as team/bond need to learn to handle
> > > > > > it, but it seems patchable.
> > > > >
> > > > > Again, this was treated prior to my deletion in this series and not by
> > > > > erroring out, I just really didn't think it through.
> > > > >
> > > > > So you're saying that if we impose that all switchdev drivers restrict
> > > > > the house of cards to be constructed from the bottom up, and destructed
> > > > > from the top down, then the notification of bridge port flags can stay
> > > > > in the bridge layer?
> > > >
> > > > I actually don't think it's a good idea to have this in the bridge in
> > > > any case. I understand that it makes sense for some devices where
> > > > learning, flooding, etc are port attributes, but in other devices these
> > > > can be {port,vlan} attributes and then you need to take care of them
> > > > when a vlan is added / deleted and not only when a port is removed from
> > > > the bridge. So for such devices this really won't save anything. I would
> > > > thus leave it to the lower levels to decide.
> > >
> > > Just for my understanding, how are per-{port,vlan} attributes such as
> > > learning and flooding managed by the Linux bridge? How can I disable
> > > flooding only in a certain VLAN?
> >
> > You can't (currently). But it does not change the fact that in some
> > devices these are {port,vlan} attributes and we are talking here about
> > the interface towards these devices. Having these as {port,vlan}
> > attributes allows you to support use cases such as a port being enslaved
> > to a VLAN-aware bridge and its VLAN upper(s) enslaved to VLAN unaware
> > bridge(s).
> 
> I don't think I understand the use case really. You mean something like this?
> 
>     br1 (vlan_filtering=0)
>     /           \
>    /             \
>  swp0.100         \
>    |               \
>    |(vlan_filtering \
>    |  br0  =1)       \
>    | /   \            \
>    |/     \            \
>  swp0    swp1         swp2
> 
> A packet received on swp0 with VLAN tag 100 will go to swp0.100 which
> will be forwarded according to the FDB of br1, and will be delivered to
> swp2 as untagged? Respectively in the other direction, a packet received
> on swp2 will have a VLAN 100 tag pushed on egress towards swp0, even if
> it is already VLAN-tagged?
> 
> What do you even use this for?

The more common use case is to have multiple VLAN-unaware bridges
instead of one VLAN-aware bridge. I'm not aware of users that use the
hybrid model (VLAN-aware + VLAN-unaware). But regardless, this entails
treating above mentioned attributes as {port,vlan} attributes. A device
that only supports them as port attributes will have problems supporting
such a model.

> And also: if the {port,vlan} attributes can be simulated by making the
> bridge port be an 8021q upper of a physical interface, then as far as
> the bridge is concerned, they still are per-port attributes, and they
> are per-{port,vlan} only as far as the switch driver is concerned -
> therefore I don't see why it isn't okay for the bridge to notify the
> brport flags in exactly the same way for them too.

Look at this hunk from the patch:

@@ -343,6 +360,8 @@ static void del_nbp(struct net_bridge_port *p)
 		update_headroom(br, get_max_headroom(br));
 	netdev_reset_rx_headroom(dev);
 
+	nbp_flags_notify(p, BR_PORT_DEFAULT_FLAGS & ~BR_LEARNING,
+			 BR_PORT_DEFAULT_FLAGS);
 	nbp_vlan_flush(p);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	switchdev_deferred_process();

Devices that treat these attributes as {port,vlan} attributes will undo
this change upon the call to nbp_vlan_flush() when all the VLANs are
flushed.

> 
> > Obviously you need to ensure there is no conflict between the
> > VLANs used by the VLAN-aware bridge and the VLAN device(s).
> 
> On the other hand I think I have a more real-life use case that I think
> is in conflict with this last phrase.
> I have a VLAN-aware bridge and I want to run PTP in VLAN 7, but I also
> need to add VLAN 7 in the VLAN table of the bridge ports so that it
> doesn't drop traffic. PTP is link-local, so I need to run it on VLAN
> uppers of the switch ports. Like this:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp0 master br0
> ip link set swp1 master br0
> bridge vlan add dev swp0 vid 7 master
> bridge vlan add dev swp1 vid 7 master
> bridge vlan add dev br0 vid 7 self
> ip link add link swp0 name swp0.7 type vlan id 7
> ip link add link swp1 name swp0.7 type vlan id 7
> ptp4l -i swp0.7 -i swp1.7 -m
> 
> How can I do that considering that you recommend avoiding conflicts
> between the VLAN-aware bridge and 8021q uppers? Or is that true only
> when the 8021q uppers are bridged?

The problem is with the statement "I also need to add VLAN 7 in the VLAN
table of the bridge ports so that it doesn't drop traffic". Packets with
VLAN 7 received by swp0 will be processed by swp0.7. br0 is irrelevant
and configuring swp0.7 should be enough in order to enable the VLAN
filter for VLAN 7 on swp0. I don't know the internals of the HW you are
working with, but I imagine that you would need to create a HW bridge
between {swp0, VLAN 7} and the CPU port so that all the traffic with
VLAN 7 will be sent / flooded to the CPU.
