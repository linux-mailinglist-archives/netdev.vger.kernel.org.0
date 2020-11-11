Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B012AF7A8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgKKSCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 13:02:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50275 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgKKSCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 13:02:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BBE4F5C0105;
        Wed, 11 Nov 2020 13:02:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 11 Nov 2020 13:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=T/Gx521phxO6qKh09ol1WoqiINT3EqhyQJX96W6sp
        SA=; b=pFanZHqtJptHiQwOHub/kF55j+ifJd9m8PioOuikaiWMbRbXrYXVe80uD
        lSa2JKTBuWPqC/OV3vwBKLZlWMgaL4t1sFquzduAMpoATbW/Mazny66CDA3sYrqo
        p6gDeP4v6mk09RP1zKIC5orjUopcpcOojP1WbGkLJeFFm9eTsgGPCxVX49Ur0Hpg
        WIFp0JTOLZA0z67WrdHG41sdQbzsaB1M3yBA+BpW8mwMxXzWSLK0Uc5nf+6d6ukb
        EU8H+6uTYabYnvDI/UH1ZNFBP0d1Z1fdYms/2Xb24GSX1SPUP06acXotvjjycRqs
        QWRyTbDhMxj4DqcP5jC6R2T7e3rwg==
X-ME-Sender: <xms:PCesX25qh7RRAqB3SLCrgAR5ydaZctR6MN4oAEEIczPutMC6ii5o0A>
    <xme:PCesX_5ApVBcOZuSbybEi_hL73YGbVtu_F8uIj_q1ea0xy85RGObiV0r2Gt-NJyj7
    vc0NbEA17PGWXc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvtddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdffveekfeeiieeuieetudefkeevkeeuhfeuieduudetkeegleefvdegheej
    hefhnecukfhppeekgedrvddvledrudehgedrudegjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PCesX1c4SfQ9vHeGf8CawlLAT7SGqkbxLKA7U4PWQMI3o1RXsNqnRg>
    <xmx:PCesXzKT4nK1Yr_7-u7zZuqvvVk6fnGJJ8OGkNl7Q4MBcuTiFQyzHg>
    <xmx:PCesX6JcE8W5Sqd291WUcxAzVhTi135dlXLFSta2oZrLX5CbfpG3HA>
    <xmx:PSesX8g9fjFYp6CL8yP33RvYRlyKZmTeT8m3-g7bVaILooQjnm7WrA>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9325306301C;
        Wed, 11 Nov 2020 13:02:35 -0500 (EST)
Date:   Wed, 11 Nov 2020 20:02:33 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Markus =?iso-8859-1?Q?Bl=F6chl?= <markus.bloechl@ipetronik.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201111180233.GA2089577@shredder>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 07:43:41AM -0800, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 16:39:58 +0100 Markus Blöchl wrote:
> > The rx-vlan-filter feature flag prevents unexpected tagged frames on
> > the wire from reaching the kernel in promiscuous mode.
> > Disable this offloading feature in the lan7800 controller whenever
> > IFF_PROMISC is set and make sure that the hardware features
> > are updated when IFF_PROMISC changes.
> > 
> > Signed-off-by: Markus Blöchl <markus.bloechl@ipetronik.com>
> > ---
> > 
> > Notes:
> >     When sniffing ethernet using a LAN7800 ethernet controller, vlan-tagged
> >     frames are silently dropped by the controller due to the
> >     RFE_CTL_VLAN_FILTER flag being set by default since commit
> >     4a27327b156e("net: lan78xx: Add support for VLAN filtering.").
> > 
> >     In order to receive those tagged frames it is necessary to manually disable
> >     rx vlan filtering using ethtool ( `ethtool -K ethX rx-vlan-filter off` or
> >     corresponding ioctls ). Setting all bits in the vlan filter table to 1 is
> >     an even worse approach, imho.
> > 
> >     As a user I would probably expect that setting IFF_PROMISC should be enough
> >     in all cases to receive all valid traffic.
> >     Therefore I think this behaviour is a bug in the driver, since other
> >     drivers (notably ixgbe) automatically disable rx-vlan-filter when
> >     IFF_PROMISC is set. Please correct me if I am wrong here.
> 
> I've been mulling over this, I'm not 100% sure that disabling VLAN
> filters on promisc is indeed the right thing to do. The ixgbe doing
> this is somewhat convincing. OTOH users would not expect flow filters
> to get disabled when promisc is on, so why disable vlan filters?
> 
> Either way we should either document this as an expected behavior or
> make the core clear the features automatically rather than force
> drivers to worry about it.
> 
> Does anyone else have an opinion, please?

I agree it is weird, but it seems to be justified by the bridge code.
Note that the code was added around 2013, so it is possible it was
influenced by the behavior of existing drivers.

1. vi net/bridge/br_vlan.c +245

/* Add VLAN to the device filter if it is supported.
 * This ensures tagged traffic enters the bridge when
 * promiscuous mode is disabled by br_manage_promisc().
 */

2. The bridge device itself will not filter packets based on their VID
when it is in promiscuous mode:

vi net/bridge/br_input.c +45

vg = br_vlan_group_rcu(br);
/* Bridge is just like any other port.  Make sure the
 * packet is allowed except in promisc modue when someone
 * may be running packet capture.
 */
if (!(brdev->flags & IFF_PROMISC) &&
    !br_allowed_egress(vg, skb)) {
	kfree_skb(skb);
	return NET_RX_DROP;
}
