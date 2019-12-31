Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F6B12DAD3
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 19:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfLaSGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 13:06:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46975 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbfLaSGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 13:06:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9363321E6A;
        Tue, 31 Dec 2019 13:06:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 31 Dec 2019 13:06:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=xonW21miiqN4UBuODJa4z8IWhm6/JvUuvw9OPxCL6
        z0=; b=vQZTPbverhwF5651F9ENsCRkr3Zra9kUQIdnvwX0EP2bbdSp6oA/Vf10c
        QvAJyVnJSs4fpSNI9WPVbes7FrZzpcN+TFsd7QnJ6urO0nYGsdvsFKK/QBQPjaZX
        4u9bcW8Ej75zvy8EIkQgS6sA8KKXBBK8yGGVdBDVL5J/O9Qs44VH65PazMg53dBR
        mifHGYoCWmxw06u88OhYJ+Ur0pmGBzN1FFuDjP3c//oTmtpomlfceld6kUz9B8XX
        E65fzd6cDDLHmViPfMX69VdrcHcPrmkX8JU8V4wXVt6raGTiHKMUcellfRTzybr0
        KwFDIbjDG3KSoBUIQKZM/QUK1xc0Q==
X-ME-Sender: <xms:Go4LXj4H9T4yz6LzQFan6umJbRR1hzQjoEgblBc8wp6WTvwletRkjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdefjedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    elrddukedurdeiuddruddujeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Go4LXsrakvslpJi_VFixmjLmCiXrK1nO_n_9qyONQjF6UdgawxrD8Q>
    <xmx:Go4LXgCwH5PSREFRTviFTYjHLB3m-8MuL-TdyzierYyOkYmskhnLBQ>
    <xmx:Go4LXm0djAba_PVjpw3RpRhkrmZn2E3r6Mv3W6eSsUM49A5x-ddhLA>
    <xmx:G44LXilN6lzzzj08QZMpZDLm8JwWeqXREsoMxe8uGJf7dmy2wIAYpg>
Received: from localhost (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67B758005A;
        Tue, 31 Dec 2019 13:06:17 -0500 (EST)
Date:   Tue, 31 Dec 2019 20:06:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20191231180614.GA120120@splinter>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191231161020.stzil224ziyduepd@pali>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 31, 2019 at 05:10:20PM +0100, Pali Rohár wrote:
> On Sunday 22 December 2019 19:22:35 Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > I've been trying to configure DSA for VLANs and not having much success.
> > The setup is quite simple:
> > 
> > - The main network is untagged
> > - The wifi network is a vlan tagged with id $VN running over the main
> >   network.
> > 
> > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> > setup to provide wifi access to the vlan $VN network, while the switch
> > is also part of the main network.
> 
> Hello, I do not know if it is related, but I have a problem with DSa,
> VLAN and mv88e6085 on Espressobin board (armada-3720).
> 
> My setup/topology is similar:
> 
> eth0 --> main interface for mv88e6085 switch

This is the DSA master interface?

> wan --> first RJ45 port from eth0
> lan0 --> second RJ45 port from eth0
> wan.10 --> unpacked VLAN with id 10 packets from wan
> 
> Just one note, wan and wan.10 uses different MAC addresses.

Is this something you configured? By default the MAC address of the VLAN
device should be inherited from the real device. What happens if they
have the same MAC address?

> Also lan0 has another MAC address.
> 
> Basically on upstream wan are two different/separated networks. First
> one is untagged, second one is tagged with vlan id 10 and tagged packets
> should come on wan interface (linux kernel then pass untagged packets to
> wan and vlan id 10 tagged as "untagged" to wan.10). lan0 is downstream
> network and in this configuration Espressobin works as router. So there
> is no switching between RJ45 ports, all packets should come to CPU and
> Linux's iptables do all stuff.
> 
> And now the problem. All (untagged) traffic for first network on wan
> works fine (incoming + outgoing). Also all outgoing packets from wan.10
> interface are correctly transmitted (other side see on first RJ45 port
> that packets are properly tagged by id 10). But for unknown reason all
> incoming packets with vlan id 10 on first RJ45 port are dropped. Even
> tcpdump on eth0 does not see them.
> 
> Could be this problem related to one which Russel described? I tried to
> debug this problem but I give up 2 days before Russel send this email
> with patches, so I have not had a chance to test it.

I'm not sure. I believe Russel was not able to receive tagged packets at
all and he was using a bridged setup, unlike you (IIUC). Also, below you
write that sometimes you're able to receive packets with VLAN 10.

> One very strange behavior is that sometimes mv88e6085 starts accepting
> those vlan id 10 packets and kernel them properly send to wan.10
> interface and userspacee applications see them. And once they start
> appearing it works for 5 minutes, exactly 300s. After 300s they are
> again silently somehow dropped (tcpdump again does not see them). I was
> not able to detect anything which could cause that kernel started seeing
> them. Looks for me it was really random. But exact time 300s is really
> strange.

300 seconds is the default ageing time the Linux bridge uses, so maybe
the problem is the hardware FDB table and not the VLAN filter.

Andrew / Vivien, how routed traffic is handled on this platform? Is it
possible that the FDB table is consulted first and the expectation is
that it would direct the packet towards the CPU port? If so, I guess
that the FDB entry with {VID 10, wan.10's MAC} is aged-out and flooding
towards the CPU is disabled?

> 
> I used default Debian Buster kernel (without any custom patches). Also
> one from Debian Buster backports, but behavior was still same.
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com


