Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1710A3E848A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhHJUq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:46:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45025 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbhHJUq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 16:46:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 53A605C0131;
        Tue, 10 Aug 2021 16:46:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 10 Aug 2021 16:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Trvu9S
        7nqSBTGQq1UvtfvyUk8kRgSHJmfw8XmZuhDz4=; b=SooODXlQ/QTYJjv6DRwwnn
        Ipth308A82bsOmZLJlRB9+bjJiHmpxuWB+kcgKlhQLhEjE+y21If0tt2hp8yw1rg
        SIQvsdAFaFKFQgmJNZcv+chwtdyD2RtO2AXaPD9cqWhsmnwQ3kDvZFlFi5m+MFyx
        IOlE2uY4dmXsKF0TVpivr4z2srXXr15ovG7+b1t13HNvs9SnV/bb0Ihzt2yC8Srv
        yhrDkeJqpLCxLSw0PFWg7UDnQ+ZVDOB3lJvt5ONwK0o6jm1Em0BtnQ2wvsoXdquu
        ANzg8EuOp/lMlEuYwVAuiY9VX9Dj5zjmMsgNk7f/LPLsu+KKtmUFD7SepmEl9VXQ
        ==
X-ME-Sender: <xms:qeUSYbP2BMsqkgfHeAosd5-h-klULab8xEaQTK0vo5Hgdyd4240cyw>
    <xme:qeUSYV_4u9V5o4_OowkZQXUB17E0b9j5M4MJcPkiOf2g36-tMiO6S5jnE_H3jyCAq
    _GY9Da3IHqwcEQ>
X-ME-Received: <xmr:qeUSYaRyIjOTq9P7DSCQneKc859uPbweazXQdDYuoD2EAMyBoWK8CA-ewmQVoOoBESfowz_PW3fDIchtyaUUqzWvlo2RJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeelgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeekvdffvdeulefgkeekheegffdtgeekkefhfeelgeeitdduveegueehjedukeei
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qeUSYfuTveSCDu9mOnY3-QLm-7cTrR-hPhUhcveqI4YH36T85NzezQ>
    <xmx:qeUSYTdIUwmgFyMGKHeLXWm_HtjKfQZVLbKW8932JAE5Boe-waP_9A>
    <xmx:qeUSYb3F8ZDVBXbvAqt2mFTHuSNdHaS4ZYqDteyD-4w_w3vwC4M2FA>
    <xmx:quUSYVtYINp0I8JSc-tgKe9taEq5jQDA-P1dcD5d9dQd5tufMpyEmw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 16:46:32 -0400 (EDT)
Date:   Tue, 10 Aug 2021 23:46:28 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRLlpCutXmthqtOg@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 06:59:54AM -0700, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 15:52:20 +0200 Andrew Lunn wrote:
> > > The transition from low power to high power can take a few seconds with
> > > QSFP/QSFP-DD and it's likely to only get longer with future / more
> > > complex modules. Therefore, to reduce link-up time, the firmware
> > > automatically transitions modules to high power mode.
> > > 
> > > There is obviously a trade-off here between power consumption and
> > > link-up time. My understanding is that Mellanox is not the only vendor
> > > favoring shorter link-up times as users have the ability to control the
> > > low power mode of the modules in other implementations.
> > > 
> > > Regarding "why do we need user space involved?", by default, it does not
> > > need to be involved (the system works without this API), but if it wants
> > > to reduce the power consumption by setting unused modules to low power
> > > mode, then it will need to use this API.  
> > 
> > O.K. Thanks for the better explanation. Some of this should go into
> > the commit message.
> > 
> > I suggest it gets a different name and semantics, to avoid
> > confusion. I think we should consider this the default power mode for
> > when the link is administratively down, rather than direct control
> > over the modules power mode. The driver should transition the module
> > to this setting on link down, be it high power or low power. That
> > saves a lot of complexity, since i assume you currently need a udev
> > script or something which sets it to low power mode on link down,
> > where as you can avoid this be configuring the default and let the
> > driver do it.
> 
> Good point. And actually NICs have similar knobs, exposed via ethtool
> priv flags today. Intel NICs for example. Maybe we should create a
> "really power the port down policy" API?

See below about Intel. I'm not sure it's the same thing...

I'm against adding a vague "really power the port down policy" API. The
API proposed in the patch is well-defined, its implementation is
documented in standards, its implications are clear and we offer APIs
that give user space full observability into its operation.

A vague API means that it is going to be abused and user space will get
different results over different implementations. After reading the
*commit messages* about the private flags, I'm not sure what the flags
really do, what is their true motivation, implications or how do I get
observability into their operation. I'm not too hopeful about the user
documentation.

Also, like I mentioned in the cover letter, given the complexity of
these modules and as they become more common, it is likely that we will
need to extend the API to control more parameters and expose more
diagnostic information. I would really like to keep it clean and
contained in 'ETHTOOL_MSG_MODULE_*' messages and not spread it over
different APIs.

> 
> Jake do you know what the use cases for Intel are? Are they SFP, MAC,
> or NC-SI related?

I went through all the Intel drivers that implement these operations and
I believe you are talking about these commits:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c3880bd159d431d06b687b0b5ab22e24e6ef0070
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d5ec9e2ce41ac198de2ee18e0e529b7ebbc67408
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ab4ab73fc1ec6dec548fa36c5e383ef5faa7b4c1

There isn't too much information about the motivation, but maybe it has
something to do with multi-host controllers where you want to prevent
one host from taking the physical link down for all the other hosts
sharing it? I remember such issues with mlx5.

> 
> > I also wonder if a hierarchy is needed? You can set the default for
> > the switch, and then override is per module? I _guess_ most users will
> > decide at a switch level they want to save power and pay the penalty
> > over longer link up times. But then we have the question, is it an
> > ethtool option, or a devlink parameter?
