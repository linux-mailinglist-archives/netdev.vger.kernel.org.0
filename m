Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9547244D89E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbhKKOyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:54:47 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:50849 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233672AbhKKOyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 09:54:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 7585D2B0139E;
        Thu, 11 Nov 2021 09:51:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Nov 2021 09:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jubEFc
        H5zMilOnWA5PKv0DeZtyUJeDw9Z7dfGFdSKAE=; b=OgvWqrsB3cu5Yhnk2hGfHa
        CdbawqcrOf8DPy/PyNhh/LqBYTOvjJNGLBveBokqCLvfL242onHafATkqYaG9Znz
        AiuncjiaaJnu5d3FvWfYoRtAU/2QMpn398nox/DeCz2cNbl+bkv4aI0i3w5Ia0mO
        xuE7FmKjFRokJky/4P5fbYRHEabY/UuyCWBMCM1MaBP/USpqPMikRsDQe8Qo5hBO
        8o/ArB0bj1DX4hDXYRnkoKX7tZHAln9UKKm0MzUUn7mNukfypeLeDxZJHBW0ilyo
        +pusMYpXCQc9677HJysismCtzOUzl5L6kLbvDcsbd46jNgalG34c3Qu9JaDRpgCA
        ==
X-ME-Sender: <xms:Ci6NYYL_txl3eMlka092aBdbu8O0eIIB5REeIpWDAgYtYDX0JtxFAw>
    <xme:Ci6NYYKytNKnqSsxRHha247o1BvbMBHHNVx0wO3pKPwrEghJLNrHTrEHkWug6MBEg
    MNJaoUvWVGP9Y0>
X-ME-Received: <xmr:Ci6NYYsliVKIF7VcpD3mMv7I_05FGCXboip24Ku8WA2ZPHfsSuCo5xBxBIKGjM0ZsDrfYuLXJ7sCp_MSPIulYSDN5QOcrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrvddugdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ci6NYVZKJ8fiDxUZmkB62Dyg5jJmvJ17e3hu9U_mI-pLGe32m8ZwvA>
    <xmx:Ci6NYfauD3BABFxsccLtO0ef00b6y5KcIedmagR12OoZ2Q2k_ufdKg>
    <xmx:Ci6NYRAfje05gPajsg8sqwO-zaGS6qgFwa2prg79skwFatbm2vlMGA>
    <xmx:Cy6NYdAV6bzw-8LGU9WEe0j3XDVrJjACLRR1_kfnGPYsF5rq2CspcFk79Xc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Nov 2021 09:51:54 -0500 (EST)
Date:   Thu, 11 Nov 2021 16:51:51 +0200
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
Message-ID: <YY0uB7OyTRCoNBJQ@shredder>
References: <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXmWb2PZJQhpMfrR@shredder>
 <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder>
 <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder>
 <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
 <YYeajTs6d4j39rJ2@shredder>
 <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:54:50AM -0800, Jakub Kicinski wrote:
> On Sun, 7 Nov 2021 11:21:17 +0200 Ido Schimmel wrote:
> > > This looks good. Please note that we need the behavior such that after changing
> > > the flag a subsequent ifconfig command is not needed by the user.
> > > 
> > > auto : in ndo_open, ndo_close check the physical link flag is auto and
> > > send command
> > >           to firmware for bringing physical link up/down.
> > > up: send command to firmware instantaneously for physical link UP
> > > down: send command to firmware instantaneously for physical link DOWN  
> > 
> > TBH, I'm not that happy with my ethtool suggestion. It is not very clear
> > which hardware entities the attribute controls.
> 
> Last week I heard a request to also be able to model NC-SI disruption.
> Control if the NIC should be reset and newly flashed FW activated when
> host is rebooted (vs full server power cycle).
> 
> That adds another dimension to the problem, even though that particular
> use case may be better answered thru the devlink flashing/reset APIs.
> 
> Trying to organize the requirements we have 3 entities which may hold
> the link up:
>  - SFP power policy

The SFP power policy does not keep the link up. In fact, we specifically
removed the "low" policy to make sure that whatever policy you configure
("auto"/"high") does not affect your carrier.

>  - NC-SI / BMC
>  - SR-IOV (legacy)
> 
> I'd think auto/up as possible options still make sense, although in
> case of NC-SI many NICs may not allow overriding the "up". And the
> policy may change without notification if BMC selects / activates 
> a port - it may go from auto to up with no notification.
> 
> Presumably we want to track "who's holding the link up" per consumer.
> Just a bitset with 1s for every consumer holding "up"? 
> 
> Or do we expect there will be "more to it" and should create bespoke
> nests?
> 
> > Maybe it's better to
> > implement it as a rtnetlink attribute that controls the carrier (e.g.,
> > "carrier_policy")? Note that we already have ndo_change_carrier(), but
> > the kdoc comment explicitly mentions that it shouldn't be used by
> > physical devices:
> >
> >  * int (*ndo_change_carrier)(struct net_device *dev, bool new_carrier);
> >  *	Called to change device carrier. Soft-devices (like dummy, team, etc)
> >  *	which do not represent real hardware may define this to allow their
> >  *	userspace components to manage their virtual carrier state. Devices
> >  *	that determine carrier state from physical hardware properties (eg
> >  *	network cables) or protocol-dependent mechanisms (eg
> >  *	USB_CDC_NOTIFY_NETWORK_CONNECTION) should NOT implement this function.
> 
> New NDO seems reasonable. 

Spent a bit more time on that and I'm not sure a new ndo is needed. See:

 * void (*ndo_change_proto_down)(struct net_device *dev,
 *				 bool proto_down);
 *	This function is used to pass protocol port error state information
 *	to the switch driver. The switch driver can react to the proto_down
 *      by doing a phys down on the associated switch port.

So what this patch is trying to achieve can be achieved by implementing
support for this ndo:

$ ip link show dev macvlan10
20: macvlan10@dummy10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 3e:d6:1a:97:ba:5e brd ff:ff:ff:ff:ff:ff

# ip link set dev macvlan10 protodown on

$ ip link show dev macvlan10
20: macvlan10@dummy10: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 3e:d6:1a:97:ba:5e brd ff:ff:ff:ff:ff:ff protodown on

Currently, user space has no visibility into the fact that by default
the carrier is on, but I imagine this can be resolved by adding
"protoup" and defaulting the driver to report "on". The "who's holding
the link up" issue can be resolved via "protoup_reason" (same as
"protodown_reason").
