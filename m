Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B3329D44B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgJ1VvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:51:05 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38725 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728100AbgJ1Vuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:50:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 18DA9CCF;
        Wed, 28 Oct 2020 13:34:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 28 Oct 2020 13:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zwyiSY
        YSrvu1PAtB2VcRk8Q+WrFotOSE2VIulZuQkPk=; b=UOBUODOoLcRAih1rduuIVE
        tHtb96MZoMNy5FHhcdANBOmNb5jdq3mDj99Dg5bWjFTd2OUp1sv+bDaY+MHRp1oa
        7cm+lVqBkMtp/hA5AC17IY3lKzBuXaItRforH0ObfkHWFXYf8GE1dZF4hSIh3ttB
        8SdYqcZOu2vA31urXvLi6Qt6W+rFz+Ls/4/ZMIanzgH58diKQfBiBtP63DyeyjKH
        BI7ReajJdx73nB/KkOrW0L4GdoXjf15LeYY7wSMVMYU3M9mKBeiJmT1NSbV+37UZ
        AJhkdvmVKysKN9BVolfG8SHpkVQeuj4PaYbRt+pYTNocia8TPHRJvYC3jmXXkdiQ
        ==
X-ME-Sender: <xms:sKuZX6LmikOrvEultMldYR0NglxDk8Up_8TpVUR5L1AB9ofnjs0tuQ>
    <xme:sKuZXyLbp-7lYJHxiAllk6OO6ysbu6G54eMZ60ky7hpnBCohUaS2MSGiBfCwEtYwg
    NpOSp5oGgCfd_Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrledugddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sKuZX6sxEeObqrXwRguWRt5KAZYQI6jWoUvX3CxgpyQdrkwTW0hDBQ>
    <xmx:sKuZX_YzeXkobJg6fGV83ulhSWXtIXsNyXtG9Qkxr1qetSAQl5zQrA>
    <xmx:sKuZXxboVRSJBN4DhdQdVDKij7ya-0yqtKgLoAM8XgjcDX1z0xsp-g>
    <xmx:squZX0xD0uH0-PF3UrHD9IPaByptmM-ZBV2RLbPRxftWptI0VdPTow>
Received: from localhost (igld-84-229-153-9.inter.net.il [84.229.153.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF5F63280059;
        Wed, 28 Oct 2020 13:34:39 -0400 (EDT)
Date:   Wed, 28 Oct 2020 19:34:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        David.Laight@aculab.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201028173436.GA504959@shredder>
References: <20201027145114.226918-1-idosch@idosch.org>
 <20201027145305.48ca1123@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201028005339.45daonidsidbzawn@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028005339.45daonidsidbzawn@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 01:53:39AM +0100, Michal Kubecek wrote:
> On Tue, Oct 27, 2020 at 02:53:05PM -0700, Jakub Kicinski wrote:
> > On Tue, 27 Oct 2020 16:51:14 +0200 Ido Schimmel wrote:
> > > From: Ido Schimmel <idosch@nvidia.com>
> > > 
> > > With the ioctl interface, when autoneg is enabled, but without
> > > specifying speed, duplex or link modes, the advertised link modes are
> > > set to the supported link modes by the ethtool user space utility.
> > 
> > > With the netlink interface, the same thing is done by the kernel, but
> > > only if speed or duplex are specified. In which case, the advertised
> > > link modes are set by traversing the supported link modes and picking
> > > the ones matching the specified speed or duplex.
> > 
> > > Fix this incompatibility problem by introducing a new flag in the
> > > ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
> > > the flag is to indicate to the kernel that it needs to be compatible
> > > with the legacy ioctl interface. A patch to the ethtool user space
> > > utility will make sure the flag is set, when supported by the kernel.
> > 
> > I did not look at the legacy code but I'm confused by what you wrote.
> > 
> > IIUC for ioctl it's the user space that sets the advertised.
> > For netlink it's the kernel.
> > So how does the legacy flag make the kernel behave like it used to?
> 
> The idea why I suggested "legacy" as the name was that it allowed
> ethtool to preserve the old behaviour (without having to query for
> supported modes first). But from this point of view it's indeed a bit
> confusing.

I think it would be best to solve this by having user space query the
kernel for supported link modes if autoneg is being enabled without
additional parameters. Then user space will issue a set request with
ETHTOOL_A_LINKMODES_OURS being set to all supported link modes.

It does not require kernel changes and would be easier on users that
currently need to resort to old ethtool despite having a kernel that
supports netlink-based ethtool.
