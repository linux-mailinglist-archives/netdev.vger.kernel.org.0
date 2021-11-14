Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AAC44F742
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 09:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNIl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 03:41:28 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:48527 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhKNIlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 03:41:11 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id D8BD72B0125E;
        Sun, 14 Nov 2021 03:38:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 14 Nov 2021 03:38:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QHl2fq
        wuJ1S+rzSnrrZjXOf3cCHreTgTDIPd5EW9/zU=; b=h743kJ1Yn14fiD01LC7qo5
        bcdAnmtg6oYVX3tNZmY7RSwIVNoqm1xZAnACdeCIPLNnAofpKdtWyCmuM4+xxwBu
        u2NyAGZR++6qsiaiG77vcnTJ3rHPJ253e5yfGKvGxDhpgMOrbIiDNpP4waqOY0ew
        E/qW8IDtXci1ZbonZ+DiL38nZU9Oou7RKs/P2sZfMk7yBRcrE5ZvixdomXhvghm/
        RFTlflSo+sxmRjFz7hv7WcHeSvEcndC85I05WUybjDtH/nSynkKlRDICfWhTLU7F
        HPsrkmK81ErNMMqThgVTVs41+gcmnAvfwXT3qYGwXxz/op8Qj77H5I50X5Sh1S+g
        ==
X-ME-Sender: <xms:68qQYWt-oKyM9JFNAjBYUV60F6MH37PfRag40CG0kKHcPsf4s3gDVQ>
    <xme:68qQYbcRhE6kJPExfCWsULRtYieKpOkixcVI8LVfuDNeMyzKRgEVrKrElHv9E0lxw
    4a4lI0WKQWa-58>
X-ME-Received: <xmr:68qQYRxNOhSdR0gCTk2pvLg6jgZsOkPFSjoXeMwOqPti__sKGYu-u-fTqn_t>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrvdeigdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:68qQYRNpzaCjDnvRL5TWCaZF8Ls22W8xPKnxQbIKQI7yG-O_qFu8LQ>
    <xmx:68qQYW-TpJdh3zZPB2xfx6_jibkhXK_oYa0nKBlm2Sl4tzAn7uD4qg>
    <xmx:68qQYZUcwxrG4FWmo5J34FwEgFcpBmKTuD4ly5rxYGmiGTc9M7VWbQ>
    <xmx:7MqQYZV-3WOSmnjqeo1Y6AK2ryRMDfEWmpjEflLp3jX-CgYzyjBqYG0xLc8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 14 Nov 2021 03:38:03 -0500 (EST)
Date:   Sun, 14 Nov 2021 10:38:00 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <YZDK6JxwcoPvk/Zx@shredder>
References: <YXmWb2PZJQhpMfrR@shredder>
 <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder>
 <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder>
 <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
 <YYeajTs6d4j39rJ2@shredder>
 <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YY0uB7OyTRCoNBJQ@shredder>
 <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 08:47:19AM -0800, Jakub Kicinski wrote:
> On Thu, 11 Nov 2021 16:51:51 +0200 Ido Schimmel wrote:
> > On Mon, Nov 08, 2021 at 07:54:50AM -0800, Jakub Kicinski wrote:
> > > On Sun, 7 Nov 2021 11:21:17 +0200 Ido Schimmel wrote:  
> > > > TBH, I'm not that happy with my ethtool suggestion. It is not very clear
> > > > which hardware entities the attribute controls.  
> > > 
> > > Last week I heard a request to also be able to model NC-SI disruption.
> > > Control if the NIC should be reset and newly flashed FW activated when
> > > host is rebooted (vs full server power cycle).
> > > 
> > > That adds another dimension to the problem, even though that particular
> > > use case may be better answered thru the devlink flashing/reset APIs.
> > > 
> > > Trying to organize the requirements we have 3 entities which may hold
> > > the link up:
> > >  - SFP power policy  
> > 
> > The SFP power policy does not keep the link up. In fact, we specifically
> > removed the "low" policy to make sure that whatever policy you configure
> > ("auto"/"high") does not affect your carrier.
> 
> Hm. How do we come up with the appropriate wording here...
> 
> I meant keeping the "PHY level link" up? I think we agree that all the
> cases should behave like SFP power behaves today?
> 
> The API is to control or query what is forcing the PHY link to stay up
> after the netdev was set down. IOW why does the switch still see link
> up if the link is down on Linux. 

The SFP power policy doesn't affect that. In our systems (and I believe
many others), by default, the transceivers are transitioned to high
power mode upon plug-in, but the link is still down when the netdev is
down because the MAC/PHY are not operational.

With SRIOV/Multi-Host, the MAC/PHY are always operational which is why
your link partner has a carrier even when the netdev is down.

> I don't think we should report carrier up when netdev is down?

This is what happens today, but it's misleading because the carrier is
always up with these systems. When I take the netdev down, I expect my
link partner to lose carrier. If this doesn't happen, then I believe the
netdev should always report IFF_UP. Alternatively, to avoid user space
breakage, this can be reported via a new attribute such as "protoup".

> 
> > >  - NC-SI / BMC
> > >  - SR-IOV (legacy)
> 
>  - NPAR / Mutli-Host
> 
> so 4 known reasons.
> 
> > > I'd think auto/up as possible options still make sense, although in
> > > case of NC-SI many NICs may not allow overriding the "up". And the
> > > policy may change without notification if BMC selects / activates 
> > > a port - it may go from auto to up with no notification.
> > > 
> > > Presumably we want to track "who's holding the link up" per consumer.
> > > Just a bitset with 1s for every consumer holding "up"? 
> > > 
> > > Or do we expect there will be "more to it" and should create bespoke
> > > nests?
> > >   
> > > > Maybe it's better to
> > > > implement it as a rtnetlink attribute that controls the carrier (e.g.,
> > > > "carrier_policy")? Note that we already have ndo_change_carrier(), but
> > > > the kdoc comment explicitly mentions that it shouldn't be used by
> > > > physical devices:
> > > >
> > > >  * int (*ndo_change_carrier)(struct net_device *dev, bool new_carrier);
> > > >  *	Called to change device carrier. Soft-devices (like dummy, team, etc)
> > > >  *	which do not represent real hardware may define this to allow their
> > > >  *	userspace components to manage their virtual carrier state. Devices
> > > >  *	that determine carrier state from physical hardware properties (eg
> > > >  *	network cables) or protocol-dependent mechanisms (eg
> > > >  *	USB_CDC_NOTIFY_NETWORK_CONNECTION) should NOT implement this function.  
> > > 
> > > New NDO seems reasonable.   
> > 
> > Spent a bit more time on that and I'm not sure a new ndo is needed. See:
> > 
> >  * void (*ndo_change_proto_down)(struct net_device *dev,
> >  *				 bool proto_down);
> >  *	This function is used to pass protocol port error state information
> >  *	to the switch driver. The switch driver can react to the proto_down
> >  *      by doing a phys down on the associated switch port.
> > 
> > So what this patch is trying to achieve can be achieved by implementing
> > support for this ndo:
> > 
> > $ ip link show dev macvlan10
> > 20: macvlan10@dummy10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
> >     link/ether 3e:d6:1a:97:ba:5e brd ff:ff:ff:ff:ff:ff
> > 
> > # ip link set dev macvlan10 protodown on
> > 
> > $ ip link show dev macvlan10
> > 20: macvlan10@dummy10: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
> >     link/ether 3e:d6:1a:97:ba:5e brd ff:ff:ff:ff:ff:ff protodown on
> 
> Let's wait to hear a strong use case, tho.

Agree

> 
> > Currently, user space has no visibility into the fact that by default
> > the carrier is on, but I imagine this can be resolved by adding
> > "protoup" and defaulting the driver to report "on". The "who's holding
> > the link up" issue can be resolved via "protoup_reason" (same as
> > "protodown_reason").
> 
> "proto" in "protodown" refers to STP, right?

Not really. I believe the main use case was vrrp / mlag. The
"protdown_reason" is just a bitmap of user enumerated reasons to keep
the interface down. See commit 829eb208e80d ("rtnetlink: add support for
protodown reason") for details.

> Not sure what "proto" in "protoup" would be.

sriov/multi-host/etc ?
