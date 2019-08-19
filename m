Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2682694EBF
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfHSUPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:15:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40187 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727769AbfHSUPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:15:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C1E7622265;
        Mon, 19 Aug 2019 16:15:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 19 Aug 2019 16:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=672qgg
        ltbHcOheWmxO8yODpDT3BPEHwKT+UjXwUERC0=; b=vhDmv1ORdjJ7bM4o5jDDsw
        1vqXrO+ZXnEHfT7JvDG7Gnj8MGJxTj6fvYKYZ0znWuUnxy3uUQ70g6BoDNnhkmaX
        Q6UXi+U4e7mOkTd26CYloty9DI0m7O054JldEyJyJ3qCIHQPh3BozqC392desaRa
        +5AmRUafB65Kfw5QEstSKo31YUGei4NYD8iWFCzvaqNkbGl/cLqaud1BfETbtQGC
        Rxuh3IkYB97C3zOWthsX/3IyInbJNQqOEIaaZxAotwig5d1GGDLFXvfi4RcKZQhF
        ghrxBF66VH2WY2i8sHFjM7nsLbdxKlCKw4Wh3rFSkMknMDvkRwvYgyY2hfqC0RVg
        ==
X-ME-Sender: <xms:VgNbXeDGhRKNStmTBQ-qaGVgy45I_s2PAMQ5suY-YeGS2zhmuPwamg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefledgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrg
    hinhepkhgvrhhnvghlrdhorhhgnecukfhppeejjedrudefkedrvdegledrvddtleenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlh
    hushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:VgNbXfjuBkiYigzy2auJ-QyARNehCB0YPVw5Xw8ND60AiMnFfXIexA>
    <xmx:VgNbXdGwqTP-6_E4y2Cq75JayM_IdtW_QJgB1EzA0m-ojkozMtksjw>
    <xmx:VgNbXWksjCQy4YhKe80_6ukyRETIhce0xz6DmeAqW9-zmI2SXgeojA>
    <xmx:WQNbXdTM-sdUXaWXZCx7jULovzXCKRyVfsKWK2Q3pcoKvEXrLzxOUw>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6720380087;
        Mon, 19 Aug 2019 16:15:17 -0400 (EDT)
Date:   Mon, 19 Aug 2019 23:15:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
Subject: Re: What to do when a bridge port gets its pvid deleted?
Message-ID: <20190819201502.GA25207@splinter>
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
 <20190628123009.GA10385@splinter>
 <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
 <bb99eabb-1410-e7c2-4226-ee6c5fef6880@gmail.com>
 <4756358f-6717-0fbc-3fe8-9f6359583367@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756358f-6717-0fbc-3fe8-9f6359583367@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 08:15:03PM +0300, Vladimir Oltean wrote:
> On 6/28/19 7:45 PM, Florian Fainelli wrote:
> > On 6/28/19 5:37 AM, Vladimir Oltean wrote:
> > > On Fri, 28 Jun 2019 at 15:30, Ido Schimmel <idosch@idosch.org> wrote:
> > > > 
> > > > On Tue, Jun 25, 2019 at 11:49:29PM +0300, Vladimir Oltean wrote:
> > > > > A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
> > > > > at the very least), as well as Mellanox Spectrum (I didn't look at all
> > > > > the pure switchdev drivers) try to restore the pvid to a default value
> > > > > on .port_vlan_del.
> > > > 
> > > > I don't know about DSA drivers, but that's not what mlxsw is doing. If
> > > > the VLAN that is configured as PVID is deleted from the bridge port, the
> > > > driver instructs the port to discard untagged and prio-tagged packets.
> > > > This is consistent with the bridge driver's behavior.
> > > > 
> > > > We do have a flow the "restores" the PVID, but that's when a port is
> > > > unlinked from its bridge master. The PVID we set is 4095 which cannot be
> > > > configured by the 8021q / bridge driver. This is due to the way the
> > > > underlying hardware works. Even if a port is not bridged and used purely
> > > > for routing, packets still do L2 lookup first which sends them directly
> > > > to the router block. If PVID is not configured, untagged packets could
> > > > not be routed. Obviously, at egress we strip this VLAN.
> > > > 
> > > > > Sure, the port stops receiving traffic when its pvid is a VLAN ID that
> > > > > is not installed in its hw filter, but as far as the bridge core is
> > > > > concerned, this is to be expected:
> > > > > 
> > > > > # bridge vlan add dev swp2 vid 100 pvid untagged
> > > > > # bridge vlan
> > > > > port    vlan ids
> > > > > swp5     1 PVID Egress Untagged
> > > > > 
> > > > > swp2     1 Egress Untagged
> > > > >           100 PVID Egress Untagged
> > > > > 
> > > > > swp3     1 PVID Egress Untagged
> > > > > 
> > > > > swp4     1 PVID Egress Untagged
> > > > > 
> > > > > br0      1 PVID Egress Untagged
> > > > > # ping 10.0.0.1
> > > > > PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> > > > > 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
> > > > > 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
> > > > > 64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
> > > > > 64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
> > > > > 64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
> > > > > ^C
> > > > > --- 10.0.0.1 ping statistics ---
> > > > > 5 packets transmitted, 5 received, 0% packet loss, time 4188ms
> > > > > rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
> > > > > # bridge vlan del dev swp2 vid 100
> > > > > # bridge vlan
> > > > > port    vlan ids
> > > > > swp5     1 PVID Egress Untagged
> > > > > 
> > > > > swp2     1 Egress Untagged
> > > > > 
> > > > > swp3     1 PVID Egress Untagged
> > > > > 
> > > > > swp4     1 PVID Egress Untagged
> > > > > 
> > > > > br0      1 PVID Egress Untagged
> > > > > 
> > > > > # ping 10.0.0.1
> > > > > PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> > > > > ^C
> > > > > --- 10.0.0.1 ping statistics ---
> > > > > 8 packets transmitted, 0 received, 100% packet loss, time 7267ms
> > > > > 
> > > > > What is the consensus here? Is there a reason why the bridge driver
> > > > > doesn't take care of this?
> > > > 
> > > > Take care of what? :) Always maintaining a PVID on the bridge port? It's
> > > > completely OK not to have a PVID.
> > > > 
> > > 
> > > Yes, I didn't think it through during the first email. I came to the
> > > same conclusion in the second one.
> > > 
> > > > > Do switchdev drivers have to restore the pvid to always be
> > > > > operational, even if their state becomes inconsistent with the upper
> > > > > dev? Is it just 'nice to have'? What if VID 1 isn't in the hw filter
> > > > > either (perfectly legal)?
> > > > 
> > > > Are you saying that DSA drivers always maintain a PVID on the bridge
> > > > port and allow untagged traffic to ingress regardless of the bridge
> > > > driver's configuration? If so, I think this needs to be fixed.
> > > 
> > > Well, not at the DSA core level.
> > > But for Microchip:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/microchip/ksz9477.c#n576
> > > For Broadcom:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/b53/b53_common.c#n1376
> > > For Mediatek:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/mt7530.c#n1196
> > > 
> > > There might be others as well.
> > 
> > That sounds bogus indeed, and I bet that the two other drivers just
> > followed the b53 driver there. I will have to test this again and come
> > up with a patch eventually.
> > 
> > When the port leaves the bridge we do bring it back into a default PVID
> > (which is different than the bridge's default PVID) so that part should
> > be okay.
> > 
> 
> Adding a few more networking people.
> So my flow is something like this:
> - Boot a board with a DSA switch
> - Bring all interfaces up
> - Enslave all interfaces to br0
> - Enable vlan_filtering on br0
> 
> What VIDs should be installed into the ports' hw filters, and what should
> the pvid be at this point?
> Should the switch ports pass any traffic?
> At this point, 'bridge vlan' shows a confusing:
> port    vlan ids
> eth0     1 PVID Egress Untagged
> 
> swp5     1 PVID Egress Untagged
> 
> swp2     1 PVID Egress Untagged
> 
> swp3     1 PVID Egress Untagged
> 
> swp4     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
> for all ports, but the .port_vlan_add callback is nowhere to be found.

The bridge adds a PVID on the port when it is enslaved to the bridge.
The configuration only takes effect when VLAN filtering is enabled. I'm
looking at dsa_port_vlan_add() and it seems that it does not propagate
the VLAN call when VLAN filtering is disabled. This explains why you
never see the callback.

I assume that if you configure the bridge with VLAN filtering enabled
and then enslave a port, then everything works fine.

mlxsw avoids the situation by forbidding the toggling of VLAN filtering
on the bridge when its ports are enslaved.

> 
> Whose responsibility is it for the switch to pass traffic without any
> further 'bridge vlan' command? What is the mechanism through which this
> should work?
> 
> What if I do:
> sudo bridge vlan add vid 100 dev swp2 pvid untagged
> echo 0 | sudo tee /sys/class/net/br0/bridge/vlan_filtering
> echo 1 | sudo tee /sys/class/net/br0/bridge/vlan_filtering
> What pvid should there be on swp2 now?
> 'bridge vlan' shows:
> port    vlan ids
> eth0     1 PVID Egress Untagged
> 
> swp5     1 PVID Egress Untagged
> 
> swp2     1 Egress Untagged
>          100 PVID Egress Untagged
> 
> swp3     1 PVID Egress Untagged
> 
> swp4     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
> If the 'bridge vlan' output is correct, whose responsibility is it to
> restore this pvid?

I suggest to follow mlxsw and avoid this mess. You can support both VLAN
filtering enable / disable without supporting dynamically toggling the
option.

> 
> More context: the sja1105 driver is somewhat similar to the mlxsw in that
> VLAN awareness cannot be truly disabled. Arid details aside, in both cases,
> achieving "VLAN-unaware"-like behavior involves manipulating the pvid in
> both cases. But it appears that the bridge core does expect:
> (1) that the driver performs a default VLAN initialization which matches its
> own, without them ever communicating. But because switchdev/DSA drivers
> start off in standalone mode, vlan_filtering=0 comes first, hence the
> non-standard pvid. Through what mechanism is the bridge-expected pvid
> supposed to get restored upon flipping vlan_filtering?
> (2) that toggling VLAN filtering off and on has no other state upon the
> underlying driver than enabling and disabling VLAN awareness. The VLAN hw
> filter table is assumed to be unchanged. Is this a correct assumption?
> 
> Thanks,
> -Vladimir
