Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D1359AFA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF1MaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:30:21 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60835 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbfF1MaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:30:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD87521CDD;
        Fri, 28 Jun 2019 08:30:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 28 Jun 2019 08:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1H27gm
        moF2Qqx8xP+qPJxm9717l69m/FMIqAA+ZDiFk=; b=MZrg6lvXneZA55BRBhZYbk
        7ba1q2C4T+jNSWwk/pVczC7jmAoO0DiQSlV8xId+IU9AUmxIqbuHfDNcoxvZ3XLw
        HIDS2Mh8dWZ9GGJb7NXx1TqAfzzJbVB1lrsOMBKHMR5BOUyrE6UlgtcIPX/oa6iT
        QPU7L88v7cSaxUpe5pWDhw38gheUXxLIo3K8k5RkloSNQZiY8E7y56hdyplVI6as
        NuDxIsS2OIHrvP6PttJVlFviip04u9HOmdOTbkcnIq20pfZmB9SuTI/Xd8JM1gll
        bLr4Xo+a+uiIlN7yvlhz4xWc1JlvTr5Bo6FM8IJ4nZ6Az1ciFziqdpUdKR5RS7aw
        ==
X-ME-Sender: <xms:WggWXfm_myIXRKpnjeCz_QPr8VP3EH8GP5w2ggFBi6KT3r4Sg8Kuow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvddtgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepuddtle
    drieehrdeifedruddtudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WggWXUvLGr3m4p6ptMykD_IF2CXJIXj1u7bsmiZ4Mq_UldIJ3cAK2Q>
    <xmx:WggWXawikPv6oatB2xmd8Ums2gG2tGYAumQN-eMgpgWqAZlboRTFyw>
    <xmx:WggWXXy05gPQFw4hopBqEfGdxMySzfs_WuxfuyIulsxVgZyuj8Htww>
    <xmx:WwgWXU0M9C_Swe75Ekyg4N6i7C3hbYDNHMIuHsG6Tg6VM50cbi1Rqw>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0838380064;
        Fri, 28 Jun 2019 08:30:17 -0400 (EDT)
Date:   Fri, 28 Jun 2019 15:30:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
Subject: Re: What to do when a bridge port gets its pvid deleted?
Message-ID: <20190628123009.GA10385@splinter>
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:49:29PM +0300, Vladimir Oltean wrote:
> A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
> at the very least), as well as Mellanox Spectrum (I didn't look at all
> the pure switchdev drivers) try to restore the pvid to a default value
> on .port_vlan_del.

I don't know about DSA drivers, but that's not what mlxsw is doing. If
the VLAN that is configured as PVID is deleted from the bridge port, the
driver instructs the port to discard untagged and prio-tagged packets.
This is consistent with the bridge driver's behavior.

We do have a flow the "restores" the PVID, but that's when a port is
unlinked from its bridge master. The PVID we set is 4095 which cannot be
configured by the 8021q / bridge driver. This is due to the way the
underlying hardware works. Even if a port is not bridged and used purely
for routing, packets still do L2 lookup first which sends them directly
to the router block. If PVID is not configured, untagged packets could
not be routed. Obviously, at egress we strip this VLAN.

> Sure, the port stops receiving traffic when its pvid is a VLAN ID that
> is not installed in its hw filter, but as far as the bridge core is
> concerned, this is to be expected:
> 
> # bridge vlan add dev swp2 vid 100 pvid untagged
> # bridge vlan
> port    vlan ids
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
> # ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
> 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
> 64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
> 64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
> 64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
> ^C
> --- 10.0.0.1 ping statistics ---
> 5 packets transmitted, 5 received, 0% packet loss, time 4188ms
> rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
> # bridge vlan del dev swp2 vid 100
> # bridge vlan
> port    vlan ids
> swp5     1 PVID Egress Untagged
> 
> swp2     1 Egress Untagged
> 
> swp3     1 PVID Egress Untagged
> 
> swp4     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
> 
> # ping 10.0.0.1
> PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> ^C
> --- 10.0.0.1 ping statistics ---
> 8 packets transmitted, 0 received, 100% packet loss, time 7267ms
> 
> What is the consensus here? Is there a reason why the bridge driver
> doesn't take care of this? 

Take care of what? :) Always maintaining a PVID on the bridge port? It's
completely OK not to have a PVID.

> Do switchdev drivers have to restore the pvid to always be
> operational, even if their state becomes inconsistent with the upper
> dev? Is it just 'nice to have'? What if VID 1 isn't in the hw filter
> either (perfectly legal)?

Are you saying that DSA drivers always maintain a PVID on the bridge
port and allow untagged traffic to ingress regardless of the bridge
driver's configuration? If so, I think this needs to be fixed.
