Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719433F1487
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhHSHvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:51:22 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45983 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhHSHvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:51:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 12EEA580CB1;
        Thu, 19 Aug 2021 03:50:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 19 Aug 2021 03:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9ZqtJn
        J0H+EdolVALfJ0fnZU/c0Rk6VytaazMf6oyuk=; b=lDS8qoC7R4OglpoH7ph+N2
        NntI/nnJyXQ/t/Y3LOQ3b8t7skehEIFGn4AbBHxjaD2u5D39aXxRshWfAiZDVihn
        37FVNt9XUaHPI7bfaQ4zCY9sBHuhdHmVR+vLCwWzdV7DTFpO3iNKorPHPXQh2YAl
        oAkZ6eG6DQ4icZBsEM8wIRnJihB2mhutTqqPelE0HOKgLcRRysIpLgUvOh8EDk/C
        CuTHtMygO0YY0UIA7u7BfPuaKH5rao8R+IzPsjOn3vVZ8534tSQ6F884oTwRNJpa
        r+3j0p9Jj18shjxswwVSr3UbE4rGTitG5KKzp7AuZfI3dJkr7ppWl1345kiNbQpA
        ==
X-ME-Sender: <xms:Ug0eYY1kqG-95NS98PcUTTH04WKMeWUtWyDfoHt8MYRmEof4NwBE7Q>
    <xme:Ug0eYTGa-xQkJSbK_cyNEXoC1tWrDSx6tKeQu9aNffnBPWw2O22wBzvia6vQdjt9k
    kL5yI2wqeZ9GTk>
X-ME-Received: <xmr:Ug0eYQ4FNZadOg-ga7s_RGdiW28ugYqYF7tskbswzYT7QHhyO7fNWgSaR_dcvyJAAL86vxjqHeu4X544Mdqh1rPFbciQ_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleeigdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ug0eYR0n6agO5ct5EntaFUwCtgemS6iqJCTM_UvgPmg957rrXb_YmA>
    <xmx:Ug0eYbF5adVIaN6CZuXmayAPBdd-kHXKfvltdaVnAzr6JbpClzrJlA>
    <xmx:Ug0eYa9yUM9rF6kq8sezLMU6iZArhkbhBW0nZGD7NOLXwLzL8hL8Zw>
    <xmx:VQ0eYRZNh0_SbqM_ZUMWJrlxYCI1_hBRv2vrnCQUt5vssRB_YJfOgQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Aug 2021 03:50:42 -0400 (EDT)
Date:   Thu, 19 Aug 2021 10:50:39 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <YR4NTylFy2ejODV6@shredder>
References: <20210818155202.1278177-1-idosch@idosch.org>
 <20210818155202.1278177-2-idosch@idosch.org>
 <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YR2P7+1ZGiEBDtAq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR2P7+1ZGiEBDtAq@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 12:55:43AM +0200, Andrew Lunn wrote:
> On Wed, Aug 18, 2021 at 03:32:41PM -0700, Jakub Kicinski wrote:
> > On Wed, 18 Aug 2021 18:51:57 +0300 Ido Schimmel wrote:
> > > +MODULE_SET
> > > +==========
> > > +
> > > +Sets transceiver module parameters.
> > > +
> > > +Request contents:
> > > +
> > > +  ======================================  ======  ==========================
> > > +  ``ETHTOOL_A_MODULE_HEADER``             nested  request header
> > > +  ``ETHTOOL_A_MODULE_POWER_MODE_POLICY``  u8      power mode policy
> > > +  ======================================  ======  ==========================
> > > +
> > > +When set, the optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute is used
> > > +to set the transceiver module power policy enforced by the host. Possible
> > > +values are:
> > > +
> > > +.. kernel-doc:: include/uapi/linux/ethtool.h
> > > +    :identifiers: ethtool_module_power_mode_policy
> > > +
> > > +For SFF-8636 modules, low power mode is forced by the host according to table
> > > +6-10 in revision 2.10a of the specification.
> > > +
> > > +For CMIS modules, low power mode is forced by the host according to table 6-12
> > > +in revision 5.0 of the specification.
> > > +
> > > +To avoid changes to the operational state of the device, power mode policy can
> > > +only be set when the device is administratively down.
> > 
> > Would you mind explaining why?
> 
> Part of the issue is we have two different sorts of policy mixed
> together.
> 
> ETHTOOL_MODULE_POWER_MODE_POLICY_LOW and
> ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH change the state now. This could
> be a surprise to a user when there link disappears for the
> ETHTOOL_MODULE_POWER_MODE_POLICY_LOW case, when the interface is admin up.
> 
> ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP however follows the state
> of the interface. So there should not be any surprises.
> 
> I actually think ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP should be
> allowed at any time, just to make it easier to use.

Yes

> 
> > > +/**
> > > + * enum ethtool_module_power_mode_policy - plug-in module power mode policy
> > > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.
> > 
> > Did you have a use case for this one or is it for completeness? Seems
> > like user can just bring the port down if they want no carrier? My
> > understanding was you primarily wanted the latter two, and those can
> > be freely changed when netdev is running, right?
> > 
> > > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
> > > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP: Module is transitioned by the
> > > + *	host to high power mode when the first port using it is put
> > > + *	administratively up and to low power mode when the last port using it
> > > + *	is put administratively down.
> > 
> > s/HIGH_ON_UP/AUTO/ ?
> > high on up == low on down, right, seems arbitrary to pick one over the
> > other
> 
> Should we also document what the default is? Seems like
> ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP is the generic network
> interface default, so maybe it should also be the default for SFPs?

I will add a note in Documentation/networking/ethtool-netlink.rst that
the default power mode policy is driver-dependent (can be queried) and
that it can either be 'high' or 'auto'.

> 
> 	  Andrew
