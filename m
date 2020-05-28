Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9E1E6415
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgE1Ohe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:37:34 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:40751 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgE1Oh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:37:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 1F7DC943;
        Thu, 28 May 2020 10:37:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 28 May 2020 10:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kXGooo
        oT7uF7Mgp55YhTEeVyKY+epZaeLCopReEXAWs=; b=NxZ4Dq+BM1qrWjSM1O01vY
        PYY4kws+HlVVwaEbktf97CQ1hID48Tz4/3xAibwvwD14E1DEpFAH+maThX25pCDh
        zjEQOiXwenRzp7GT9jX1yfNprMsqu6EYtk91z+e9kotBF7mZgg3x7CiuiO9KNDeL
        z7exfFfBTOfUgFQeAqJF81uTl0hloS/Ya7x8jfkfkpNoflnYWETdYt9Zwyr1wg8/
        QqFpRU/fY3OLYmyAtQflCgav8QySCmCXr/yxsmpXq9IkGzkek+87O7DUsJ1EiIOc
        Pl0BY62moUB8LCaPbMbbDAhVhOs3s+KihQJo+HWL3IxEBGLDp20JGUbXvNLm3J8w
        ==
X-ME-Sender: <xms:oczPXvh0XXoPUdlrOl8NMuKz9AQCHBBCkrE_DJ9EfyoLwDV9W8dptQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddviedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtieevuedvgeffhfelfffhieevudefkedtheekuedvkefgveektdefudekvdfh
    teenucffohhmrghinhepshhpihhnihgtshdrnhgvthdplhhkmhhlrdhorhhgpdihohhuth
    husggvrdgtohhmnecukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthh
    drohhrgh
X-ME-Proxy: <xmx:oczPXsC5dz1ZHeGeBpu7EZStVACf00FpnGtqjuhDSC2evDNARBzdKg>
    <xmx:oczPXvHuPHGWfjwTVT4Y7rVknu82U7r6JYHXvlEaudP9X5BHXpD2JQ>
    <xmx:oczPXsSurX4Le86uUv_iHYFc0TqWHpTAbnhDESl2UI4ufYxcA9Octw>
    <xmx:o8zPXrl1ORdGWQIt6B-ziEGyS5aQ-B1A3RuT4TJWqcG5m3pb0QqSQ712z8o>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B96623061DC5;
        Thu, 28 May 2020 10:37:20 -0400 (EDT)
Date:   Thu, 28 May 2020 17:37:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20200528143718.GA1569168@splinter>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200524140657.GA1281067@splinter>
 <CA+h21hoJwjBt=Uu_tYw3vv2Sze28iRdAAoR3S+LFrKbL6-iuJQ@mail.gmail.com>
 <20200525194808.GA1449199@splinter>
 <CA+h21hq+TULBNRHJRN-_UwR8weBxgzT5v762yNzzkRaM2iGx9A@mail.gmail.com>
 <20200526140159.GA1485802@splinter>
 <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 02:36:53PM +0300, Vladimir Oltean wrote:
> On Tue, 26 May 2020 at 17:02, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Mon, May 25, 2020 at 11:23:34PM +0300, Vladimir Oltean wrote:
> > > Hi Ido,
> > >
> > > On Mon, 25 May 2020 at 22:48, Ido Schimmel <idosch@idosch.org> wrote:
> > > >
> > > > On Sun, May 24, 2020 at 07:24:27PM +0300, Vladimir Oltean wrote:
> > > > > On Sun, 24 May 2020 at 17:07, Ido Schimmel <idosch@idosch.org> wrote:
> > > > > >
> > > > > > On Fri, May 22, 2020 at 12:10:23AM +0300, Vladimir Oltean wrote:
> > > > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > > > >
> > > > > > > This is a WIP series whose stated goal is to allow DSA and switchdev
> > > > > > > drivers to flood less traffic to the CPU while keeping the same level of
> > > > > > > functionality.
> > > > > > >
> > > > > > > The strategy is to whitelist towards the CPU only the {DMAC, VLAN} pairs
> > > > > > > that the operating system has expressed its interest in, either due to
> > > > > > > those being the MAC addresses of one of the switch ports, or addresses
> > > > > > > added to our device's RX filter via calls to dev_uc_add/dev_mc_add.
> > > > > > > Then, the traffic which is not explicitly whitelisted is not sent by the
> > > > > > > hardware to the CPU, under the assumption that the CPU didn't ask for it
> > > > > > > and would have dropped it anyway.
> > > > > > >
> > > > > > > The ground for these patches were the discussions surrounding RX
> > > > > > > filtering with switchdev in general, as well as with DSA in particular:
> > > > > > >
> > > > > > > "[PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code":
> > > > > > > https://www.spinics.net/lists/netdev/msg651922.html
> > > > > > > "[PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module":
> > > > > > > https://www.spinics.net/lists/netdev/msg634859.html
> > > > > > > "[PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity":
> > > > > > > https://lkml.org/lkml/2019/8/29/255
> > > > > > > LPC2019 - SwitchDev offload optimizations:
> > > > > > > https://www.youtube.com/watch?v=B1HhxEcU7Jg
> > > > > > >
> > > > > > > Unicast filtering comes to me as most important, and this includes
> > > > > > > termination of MAC addresses corresponding to the network interfaces in
> > > > > > > the system (DSA switch ports, VLAN sub-interfaces, bridge interface).
> > > > > > > The first 4 patches use Ivan Khoronzhuk's IVDF framework for extending
> > > > > > > network interface addresses with a Virtual ID (typically VLAN ID). This
> > > > > > > matches DSA switches perfectly because their FDB already contains keys
> > > > > > > of the {DMAC, VID} form.
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > I read through the series and I'm not sure how unicast filtering works.
> > > > > > Instead of writing a very long mail I just created a script with
> > > > > > comments. I think it's clearer that way. Note that this is not a made up
> > > > > > configuration. It is used in setups involving VRRP / VXLAN, for example.
> > > > > >
> > > > > > ```
> > > > > > #!/bin/bash
> > > > > >
> > > > > > ip netns add ns1
> > > > > >
> > > > > > ip -n ns1 link add name br0 type bridge vlan_filtering 1
> > > > > > ip -n ns1 link add name dummy10 up type dummy
> > > > > >
> > > > > > ip -n ns1 link set dev dummy10 master br0
> > > > > > ip -n ns1 link set dev br0 up
> > > > > >
> > > > > > ip -n ns1 link add link br0 name vlan10 up type vlan id 10
> > > > > > bridge -n ns1 vlan add vid 10 dev br0 self
> > > > > >
> > > > > > echo "Before adding macvlan:"
> > > > > > echo "======================"
> > > > > >
> > > > > > echo -n "Promiscuous mode: "
> > > > > > ip -n ns1 -j -p -d link show dev br0 | jq .[][\"promiscuity\"]
> > > > > >
> > > > > > echo -e "\nvlan10's MAC is in br0's FDB:"
> > > > > > bridge -n ns1 fdb show br0 vlan 10
> > > > > >
> > > > > > echo
> > > > > > echo "After adding macvlan:"
> > > > > > echo "====================="
> > > > > >
> > > > > > ip -n ns1 link add link vlan10 name vlan10-v up address 00:00:5e:00:01:01 \
> > > > > >         type macvlan mode private
> > > > > >
> > > > > > echo -n "Promiscuous mode: "
> > > > > > ip -n ns1 -j -p -d link show dev br0 | jq .[][\"promiscuity\"]
> > > > > >
> > > > > > echo -e "\nvlan10-v's MAC is not in br0's FDB:"
> > > > > > bridge -n ns1 fdb show br0 | grep master | grep 00:00:5e:00:01:01
> > > > > > ```
> > > > > >
> > > > > > This is the output on my laptop (kernel 5.6.8):
> > > > > >
> > > > > > ```
> > > > > > Before adding macvlan:
> > > > > > ======================
> > > > > > Promiscuous mode: 0
> > > > > >
> > > > > > vlan10's MAC is in br0's FDB:
> > > > > > 42:bd:b1:cc:67:15 dev br0 vlan 10 master br0 permanent
> > > > > >
> > > > > > After adding macvlan:
> > > > > > =====================
> > > > > > Promiscuous mode: 1
> > > > > >
> > > > > > vlan10-v's MAC is not in br0's FDB:
> > > > > > ```
> > > > > >
> > > > > > Basically, if the MAC of the VLAN device is not inherited from the
> > > > > > bridge or you stack macvlans on top, then the bridge will go into
> > > > > > promiscuous mode and it will locally receive all frames passing through
> > > > > > it. It's not ideal, but it's a very old and simple behavior. It does not
> > > > > > require you to track the VLAN associated with the MAC addresses, for
> > > > > > example.
> > > > > >
> > > > >
> > > > > This is a good point. I wasn't aware that the bridge 'gives up' with
> > > > > macvlan upper devices, but if I understand correctly, we do have the
> > > > > necessary tools to improve that.
> > > > > But actually, I'm wondering if this simple behavior from the bridge is
> > > > > correct.
> > > >
> > > > Why would it be incorrect?
> > > >
> > > > > As you, Jiri and Ivan pointed out in last summer's email
> > > > > thread about the Linux bridge and promiscuous mode, putting the
> > > > > interface in IFF_PROMISC is only going to guarantee acceptance through
> > > > > the net device's RX filter, but not that the packets will go to the
> > > > > CPU.
> > > >
> > > > IFF_PROMISC has no bearing on whether a packet should go to the CPU or
> > > > not. It only influences the device's RX filter, like you said. If you
> > > > only look at the software data path, the bridge being in promiscuous
> > > > mode means that all received packets will be injected to the kernel's Rx
> > > > path as if they were received through the bridge device. This includes,
> > > > for example, an IPv4 packet with an unknown unicast MAC (does not
> > > > correspond to your MAC). Such a packet will be later dropped by the IPv4
> > > > code since it's not addressed to you:
> > > >
> > > > vi net/ipv4/ip_input.c +443
> > > >
> > > > We maintain the same behavior in the hardware data path. We don't have
> > > > MAC filtering in the router like the software data path, so we only send
> > > > to the router unicast MACs that correspond to the bridge's MAC and its
> > > > uppers. If such packets later hit a local route (for example), then they
> > > > will be trapped to the CPU, but the more common case is to simply route
> > > > them through a different device due to a prefix / gateway route. These
> > > > never reach the CPU.
> > > >
> > > > > So from that perspective, the current series would break things, so we
> > > > > should definitely fix that and keep the {MAC, VLAN} pairs in the
> > > > > bridge's local FDB.
> > > >
> > > > Not sure I follow. Can you explain what will break and why?
> > > >
> > >
> > > I haven't done any further testing since yesterday, so my level of
> > > (mis)understanding is the same. Let's hope at least I can explain
> > > better this time.
> > >
> > > I guess what I didn't understand from your "macvlan upper whose MAC
> > > address isn't inherited from bridge" is why does the bridge go in
> > > promiscuous mode.
> >
> > Packets received from bridge slaves with DMAC equal to an active bridge
> > upper (e.g., macvlan) should be received by this upper. When a packet is
> > received from a bridge slave it performs FDB lookup. Since {VID, MAC}
> > entries are not programmed for bridge uppers, packets addressed to such
> > addresses will incur an FDB miss and be flooded. If the bridge is not in
> > promiscuous mode, these packets will not be received via the bridge
> > interface and will not reach the relevant upper device.
> >
> > > You said that it's so that the slave ports won't drop packets with
> > > that DMAC,
> >
> > I did not say that. I explained above that if promiscuous mode is not
> > enabled on the bridge interface itself (a soft device), the packet will
> > not be received via the bridge interface and will not reach the upper
> > device.
> >
> > > I said ok, yes the packets would get dropped without promisc, but also
> > > promisc still doesn't mean the packets will land on the CPU. This is
> > > one of the cases where the bridge puts an interface in promisc mode
> > > with the intention of making the CPU see some frames,
> >
> > The statement "the bridge puts an interface in promisc mode with the
> > intention of making the CPU see some frames" is incorrect. The bridge
> > puts an interface in promiscuous mode so that the bridge will see all
> > the frames received by this interface. If the bridge is offloaded,
> > bridging happens in hardware and there is no reason to send all the
> > frames to the CPU.
> >
> > > something which has been argued, in the context of switchdev, that was
> > > never the case. You said that's all true, and that in mlxsw you're
> > > giving the bridge a helping hand, by tracking the bridge's uppers in
> > > order to keep something that works by accident in software working
> > > with switchdev too.
> >
> > I never said that the software bridge works by accident. I explained
> > why, to my understanding, the bridge works the way it's working and what
> > can be done in order to prevent the bridge from going into promiscuous
> > mode. It involves very careful (and error-prone?) tracking of the upper
> > devices and their VLANs.
> >
> > Also, please differentiate between the bridge interface itself going
> > into promiscuous mode and bridge slaves going into promiscuous mode.
> >
> > > I said that this is a
> > > weird layering violation, because the bridge's job is to notify the
> > > driver of addresses it needs to see, not for the driver to fish for
> > > them.
> > > As for "what will break and why". My current patch proposal is to only
> > > send to the CPU the addresses added via dev_uc_add and dev_mc_add,
> > > basically. The macvlan upper of the bridge would not be part of that
> > > list. My rhetorical question then becomes: whose fault is it that
> > > macvlan breaks? Mine for not tracking the bridge upper, or the bridge
> > > for not notifying me and just pretending that 'promisc' means 'the CPU
> > > will see all packets, including the ones I need'? Of course I think
> > > it's the bridge.
> > >
> 
> Ok, bridge promisc vs slave promisc is not a difference I explicitly
> made, but my point is actually beyond that.
> The bridge going in promisc will only help if the packets are sent to
> the CPU in the first place. And it does nothing to ensure that that
> will happen. So the bridge code works by accident.

It's not beyond your point and the bridge code does not work by
accident. When the bridge interface is in promiscuous mode every packet
is injected to the kernel's Rx path as if it was accepted by the bridge
interface. Packets then reach the protocol handlers. In the case of
IPv4/IPv6, the packets go to ipv_rcv() / ip6_rcv() and perform routing.
Packets with a unicast destination MAC that does not correspond to that
of the receiving interface are dropped.

When you look at it from hardware offload perspective, not every packet
received by the bridge interface should reach the CPU. Actually, most
should not reach it. Otherwise it would mean that every routed packet
would need to go to the CPU, which is not feasible. If you can't perform
routing in hardware, then yes, you need to send such packets to the CPU.

In mlxsw we can't perform MAC filtering in the router like in the
software data path, so in order not to route packets we should not, we
only send to the router packets with destination MACs that correspond to
that of the bridge or one of its uppers. We don't flood all unknown
unicast packets there.

In the case of hardware offload it's relatively easy to do this sort of
tracking because only a limited set of upper devices topologies are
actually supported. I'm not sure how feasible it is with every
combination of upper devices supported by the kernel. It seems easiest
to just put the bridge interface in promiscuous mode and let upper
layers perform the filtering. Like it is today.

> I also have an additional question, only partially related.
> Doesn't the SWITCHDEV_OBJ_ID_HOST_MDB mechanism conceptually overlap
> with what we're trying to do here?

Yes, it is similar, but it's easier with multicast because you need to
send IGMP / MLD Membership reports if you are interested in a certain
address. So what the bridge does is to intercept such packets when they
are sent through it and then calls br_multicast_rcv() with a NULL port,
which indicates that the host itself is interested in the address.

> If there are no objections I would replace it with
> dev_mc_sync_multiple, to be symmetric with what I'm going to be
> changing for unicast. Only DSA and cpsw are using
> SWITCHDEV_OBJ_ID_HOST_MDB anyway, and looks like cpsw is using it
> wrong.

Not sure what you plan for unicast, but I'm quite happy with the work
Andrew did with SWITCHDEV_OBJ_ID_HOST_MDB.

> 
> > > > >
> > > > > > When you are offloading the Linux data path to hardware this behavior is
> > > > > > not ideal as your hardware can handle much higher packet rates than the
> > > > > > CPU.
> > > > > >
> > > > > > In mlxsw we handle this by tracking the upper devices of the bridge. I
> > > > > > was hoping that with Ivan's patches we could add support for unicast
> > > > > > filtering in the bridge driver and program the MAC addresses to its FDB
> > > > > > with 'local' flag. Then the FDB entries would be notified via switchdev
> > > > > > to device drivers.
> > > > > >
> > > > >
> > > > > Yes, it should be possible to do that. I'll try and see how far I get.
> > > > >
> > > > > > >
> > > > > > > Multicast filtering was taken and reworked from Florian Fainelli's
> > > > > > > previous attempts, according to my own understanding of multicast
> > > > > > > forwarding requirements of an IGMP snooping switch. This is the part
> > > > > > > that needs the most extra work, not only in the DSA core but also in
> > > > > > > drivers. For this reason, I've left out of this patchset anything that
> > > > > > > has to do with driver-level configuration (since the audience is a bit
> > > > > > > larger than usual), as I'm trying to focus more on policy for now, and
> > > > > > > the series is already pretty huge.
> > > > > >
> > > > > > From what I remember, this is the logic in the Linux bridge:
> > > > > >
> > > > > > * Broadcast is always locally received
> > > > > > * Multicast is locally received if:
> > > > > >         * Snooping disabled
> > > > > >         * Snooping enabled:
> > > > > >                 * Bridge netdev is mrouter port
> > > > > >                 or
> > > > > >                 * Matches MDB entry with 'host_joined' indication
> > > > > >
> > > > > > >
> > > > > > > Florian Fainelli (3):
> > > > > > >   net: bridge: multicast: propagate br_mc_disabled_update() return
> > > > > > >   net: dsa: add ability to program unicast and multicast filters for CPU
> > > > > > >     port
> > > > > > >   net: dsa: wire up multicast IGMP snooping attribute notification
> > > > > > >
> > > > > > > Ivan Khoronzhuk (4):
> > > > > > >   net: core: dev_addr_lists: add VID to device address
> > > > > > >   net: 8021q: vlan_dev: add vid tag to addresses of uc and mc lists
> > > > > > >   net: 8021q: vlan_dev: add vid tag for vlan device own address
> > > > > > >   ethernet: eth: add default vid len for all ethernet kind devices
> > > > > > >
> > > > > > > Vladimir Oltean (6):
> > > > > > >   net: core: dev_addr_lists: export some raw __hw_addr helpers
> > > > > > >   net: dsa: don't use switchdev_notifier_fdb_info in
> > > > > > >     dsa_switchdev_event_work
> > > > > > >   net: dsa: mroute: don't panic the kernel if called without the prepare
> > > > > > >     phase
> > > > > > >   net: bridge: add port flags for host flooding
> > > > > > >   net: dsa: deal with new flooding port attributes from bridge
> > > > > > >   net: dsa: treat switchdev notifications for multicast router connected
> > > > > > >     to port
> > > > > > >
> > > > > > >  include/linux/if_bridge.h |   3 +
> > > > > > >  include/linux/if_vlan.h   |   2 +
> > > > > > >  include/linux/netdevice.h |  11 ++
> > > > > > >  include/net/dsa.h         |  17 +++
> > > > > > >  net/8021q/Kconfig         |  12 ++
> > > > > > >  net/8021q/vlan.c          |   3 +
> > > > > > >  net/8021q/vlan.h          |   2 +
> > > > > > >  net/8021q/vlan_core.c     |  25 ++++
> > > > > > >  net/8021q/vlan_dev.c      | 102 +++++++++++---
> > > > > > >  net/bridge/br_if.c        |  40 ++++++
> > > > > > >  net/bridge/br_multicast.c |  21 ++-
> > > > > > >  net/bridge/br_switchdev.c |   4 +-
> > > > > > >  net/core/dev_addr_lists.c | 144 +++++++++++++++----
> > > > > > >  net/dsa/Kconfig           |   1 +
> > > > > > >  net/dsa/dsa2.c            |   6 +
> > > > > > >  net/dsa/dsa_priv.h        |  27 +++-
> > > > > > >  net/dsa/port.c            | 155 ++++++++++++++++----
> > > > > > >  net/dsa/slave.c           | 288 +++++++++++++++++++++++++++++++-------
> > > > > > >  net/dsa/switch.c          |  36 +++++
> > > > > > >  net/ethernet/eth.c        |  12 +-
> > > > > > >  20 files changed, 780 insertions(+), 131 deletions(-)
> > > > > > >
> > > > > > > --
> > > > > > > 2.25.1
> > > > > > >
> > > > >
> > > > > Thanks,
> > > > > -Vladimir
> > >
> > > -Vladimir
> 
> Thanks,
> -Vladimir
