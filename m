Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE1447255
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 10:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhKGJYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 04:24:06 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:50091 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234994AbhKGJYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 04:24:05 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id A0BF52B01407;
        Sun,  7 Nov 2021 04:21:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 07 Nov 2021 04:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/QGUeq
        caCo70u4JNx8665htRvpmwYT5F3jUqVzHXtOQ=; b=fkPpcQtGr9Mw6lV7YlCfrk
        bOyu12JUv8iEBr6IbPxgeV5OaHy8TfvCa+4ROHbyHKTid2xbuNzeKmlzddNpP1Vu
        6ZlHM2tnm+9M3uNpOVSD8KWCOBZe2G88kTtmEX109eII3nQ6G7BHRP2hM2DlPNn/
        d9C4j7y4NNUk64WM2zUKFmNNRj+K/EAD7w6VaAMe3wXuTuINX0bDd3ETIRDNTAJA
        klQhnzRDLxWqdQuu16HIrLJ/MPvKxe80xaNQQGGYULUX6RDT/3hEGUQnhOCi0lXB
        b1vg8nfGOH1tHpfovYpZBtuvStNUHlxvslqI4ML9Zl4LtqEhLrf62AEaaDmPUGmg
        ==
X-ME-Sender: <xms:kJqHYUcRe9T1LNret48Q8m1gXKuT5lT7qudWngX9KAF9HkL9UhPhHw>
    <xme:kJqHYWNBVtFB46ciu3PoMb27U9ZRT3jSzhRSD9j5X5lLRLoXh4ctEjtNP1WSCSeIX
    Yb98OtkLyenapE>
X-ME-Received: <xmr:kJqHYVghHbmirFIl3dCz9PqTtbQZJseBeWqXsQkd98oQF1KgdRKOtvUym43z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kJqHYZ-uX08SchdGP-eCr0Nrw1_TvU_1MuMpxNg2X6DoW9h3dv9tOQ>
    <xmx:kJqHYQv4d9uWer7iNCjoN13rXe_Jet30ulwXTfBTPqRoYMTZ7JhA4Q>
    <xmx:kJqHYQEb-e_3hLKTG5y8R8vkCyEmc-j7Zf4WKEz-BWDPjMdn8BlHcA>
    <xmx:kZqHYQHwf7u2x-sQlv_VL-D16y_x8CzyNO_kvdEHIAMTLfZtoh3bIzkrppE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Nov 2021 04:21:19 -0500 (EST)
Date:   Sun, 7 Nov 2021 11:21:17 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <YYeajTs6d4j39rJ2@shredder>
References: <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
 <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXmWb2PZJQhpMfrR@shredder>
 <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder>
 <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder>
 <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 12:55:47PM +0530, sundeep subbaraya wrote:
> Hi Ido,
> 
> On Thu, Oct 28, 2021 at 7:21 PM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Thu, Oct 28, 2021 at 05:48:02PM +0530, sundeep subbaraya wrote:
> > > Actually we also need a case where debugging is required when the
> > > logical link is
> > > up (so that packets flow from kernel to SerDes continuously) but the
> > > physical link
> > > is down.
> >
> > Can you explain the motivation for that? In the past we discussed use
> > cases for forcing the operational state to down while the administrative
> > state is up and couldn't find any.
> >
> To be honest we got this request from a customer to provide a command to modify
> physical link without tying it to a logical link. I have asked for
> more details on how
> they use it.

Thanks

> 
> > > We will change the commit description since it is giving the
> > > wrong impression.
> > > A command to change physical link up/down with no relation to ifconfig
> > > is needed.
> >
> > So it is obvious that some drivers default to not shutting down the
> > physical link upon admin down, but that some users want to change that.
> > In addition, we have your use case to control the physical link without
> > relation to the logical link. I wonder if it can all be solved with a
> > new ethtool attribute (part of LINKINFO_{SET,GET} ?) that describes the
> > physical link policy and has the following values:
> >
> > * auto: Physical link state is derived from logical link state
> > * up: Physical link state is always up
> > * down: Physical link state is always down
> >
> > IIUC, it should solve your problem and that of the "link-down-on-close"
> > private flag. It also has the added benefit of allowing user space to
> > query the default policy. The expectation is that it would be "auto",
> > but in some scenarios it is "up".
> 
> This looks good. Please note that we need the behavior such that after changing
> the flag a subsequent ifconfig command is not needed by the user.
> 
> auto : in ndo_open, ndo_close check the physical link flag is auto and
> send command
>           to firmware for bringing physical link up/down.
> up: send command to firmware instantaneously for physical link UP
> down: send command to firmware instantaneously for physical link DOWN

TBH, I'm not that happy with my ethtool suggestion. It is not very clear
which hardware entities the attribute controls. Maybe it's better to
implement it as a rtnetlink attribute that controls the carrier (e.g.,
"carrier_policy")? Note that we already have ndo_change_carrier(), but
the kdoc comment explicitly mentions that it shouldn't be used by
physical devices:

 * int (*ndo_change_carrier)(struct net_device *dev, bool new_carrier);
 *	Called to change device carrier. Soft-devices (like dummy, team, etc)
 *	which do not represent real hardware may define this to allow their
 *	userspace components to manage their virtual carrier state. Devices
 *	that determine carrier state from physical hardware properties (eg
 *	network cables) or protocol-dependent mechanisms (eg
 *	USB_CDC_NOTIFY_NETWORK_CONNECTION) should NOT implement this function.
