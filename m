Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810483F1482
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhHSHrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:47:45 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35035 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhHSHro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:47:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9104C580CAB;
        Thu, 19 Aug 2021 03:47:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 19 Aug 2021 03:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GlQgJt
        FBI/MfHD6x/V2x/oXhBhoMITO68U/oYnnh/mk=; b=GkApLT9f+LBu8mDflixjE/
        XtQY9fNSSmG3P7Pqqo4QcBxerajdG00YoPSE4FouYw2CBUtNONyJz1R5q+vQZG1f
        facOBb22m791TCmmvtdxfGLkBU8Rhk4dZjDiFBdwxKg+UqIwNKQgBacXltOGmLk3
        J3qNq8IDhcEXukcUolThODEtWQ8T7/OC+omTqorb3aZafN+dlNTtQvwQrbXC8qpt
        ogp8/Odfjwm0RocApJaufsEMyEmm0KWWlJCiFJ5qOsKYpgZ1kttYs3bnKW3tA5Ge
        AbY5Efnb1qL6CMyBzUP5NPBNhRiqd1jeoO9gU0CsjNKgutLqBKUWd6EyVCFOe3Fg
        ==
X-ME-Sender: <xms:ewweYeGBvRbcASKZBLaTVmd1JY5BqOI6bAjCZRarzr9uxYsRKMtmJw>
    <xme:ewweYfWOwhJCoZk2aIk5LY6lBIMOjSRGEWRB-yd7prK6WfvVFFIdr7ugk7sGPNwj0
    Fk0wNBrFt8nd9I>
X-ME-Received: <xmr:ewweYYJUgwB9mAy3QFSXB96uS4oXUElop8jMHMdCRc7gvTv8mkXoE0TT41-vQW1cEDkUUgexjR9P_TYa4EUQBRvEbBiHbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleeigdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ewweYYEzkx7yeX6q94zYCwfGaM75_LLVDEPLFRGXhGRU51aTMFhBmg>
    <xmx:ewweYUWYIto910DYbH_tF9RJIiD3zFa-rLOLeb5Ka4c-ICoiR276iQ>
    <xmx:ewweYbNvC6zFZsqfCEQzbqydeuw_S193VajWvKVmxSnRIgvpWz-sgg>
    <xmx:fAweYYphmGp24czLXQoMffQC7cTvNszcvmHdbH2HWrVP3rNJMRcvCQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Aug 2021 03:47:06 -0400 (EDT)
Date:   Thu, 19 Aug 2021 10:47:03 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <YR4Md0MJeAPOuuQw@shredder>
References: <20210818155202.1278177-1-idosch@idosch.org>
 <20210818155202.1278177-2-idosch@idosch.org>
 <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 03:32:41PM -0700, Jakub Kicinski wrote:
> On Wed, 18 Aug 2021 18:51:57 +0300 Ido Schimmel wrote:
> > +MODULE_SET
> > +==========
> > +
> > +Sets transceiver module parameters.
> > +
> > +Request contents:
> > +
> > +  ======================================  ======  ==========================
> > +  ``ETHTOOL_A_MODULE_HEADER``             nested  request header
> > +  ``ETHTOOL_A_MODULE_POWER_MODE_POLICY``  u8      power mode policy
> > +  ======================================  ======  ==========================
> > +
> > +When set, the optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute is used
> > +to set the transceiver module power policy enforced by the host. Possible
> > +values are:
> > +
> > +.. kernel-doc:: include/uapi/linux/ethtool.h
> > +    :identifiers: ethtool_module_power_mode_policy
> > +
> > +For SFF-8636 modules, low power mode is forced by the host according to table
> > +6-10 in revision 2.10a of the specification.
> > +
> > +For CMIS modules, low power mode is forced by the host according to table 6-12
> > +in revision 5.0 of the specification.
> > +
> > +To avoid changes to the operational state of the device, power mode policy can
> > +only be set when the device is administratively down.
> 
> Would you mind explaining why?

Yes, it is more restrictive than it should be. The check can be relaxed
to only disallow transition to low power mode when the device is
administratively up.

> 
> > +/**
> > + * enum ethtool_module_power_mode_policy - plug-in module power mode policy
> > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.
> 
> Did you have a use case for this one or is it for completeness? Seems
> like user can just bring the port down if they want no carrier? My
> understanding was you primarily wanted the latter two, and those can
> be freely changed when netdev is running, right?

In all the implementations I could find (3), the user interface is
high/low (on/off). The proposed interface is more flexible as it
contains both the 'high' / 'low' policies in addition to the more user
friendly 'high-on-up' ('auto') policy.

Given that keeping the 'low' policy does not complicate the
implementation / maintenance and that it provides users with a similar
interface to what they are used to from other implementations, I would
like to keep it in addition to the other two policies.

> 
> > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
> > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP: Module is transitioned by the
> > + *	host to high power mode when the first port using it is put
> > + *	administratively up and to low power mode when the last port using it
> > + *	is put administratively down.
> 
> s/HIGH_ON_UP/AUTO/ ?

OK

> high on up == low on down, right, seems arbitrary to pick one over the
> other
