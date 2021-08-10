Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C957E3E5449
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhHJH1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:27:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52573 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231860AbhHJH1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:27:16 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 10FFF5C014E;
        Tue, 10 Aug 2021 03:26:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 10 Aug 2021 03:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FXtXEh
        UakaarjvmQzlKwHY9uwwqI2BRNZGTyMq3R2aE=; b=p1aBA1lwgMcG7Xc1pOD7/3
        67Mj2vmZGipADSDcUk9G6esWXFQEt1CwLRqczXeWdcqDr6D24fBW5sbU88oDxfWu
        U4VmwT+QxR7D0182/8fSLU8fqhppWks2//aS1dtxAFxntcArWIRS94ZLBQx8CNhe
        BkZs7G+IwhX3HYYJHn94VnCuFLp7iPdv93W8aEVrcHAtp1TTnld8e/beRgH9Cxzd
        IityD7UBhUd/YdhHpuYOKSf24Ez+3YqkXWDGgxm4wbWVmUEU/Cktog2hvDGbDKfq
        M8F6IlkYqGO41BVYAeTYL3r7a0z/yn59VAtypwnJug/KsoTNK4J66WgdzdEnvPqA
        ==
X-ME-Sender: <xms:PSoSYRlMtNYUUnjeaVSHnta6tJUsIOS38t16INqIJUYPg6CVw3-H8A>
    <xme:PSoSYc34JIR5X-_rvlrD5Q--UEi4qSFJBREb0cxm7oDpfB0LZMU7i5nF_3Qrv9EE-
    FiF5RZ8aj_zPPc>
X-ME-Received: <xmr:PSoSYXp1opWzTLcp05SGMdfSPGuanWunf_mvJlX3EStxeYxs9rmandOo_XuasZDEdQWAyQzYR7SQdAmCrR4qZuIKdvZNYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PSoSYRkNEwlJgr_T2dmuQ3Esng31lTxbJsWq-AxUjwY7zZWMNB5a_w>
    <xmx:PSoSYf3NMPhGy2sbTyCDdaiZJicJoNrZGfTiF_2fwsTRhUZAiWXSIw>
    <xmx:PSoSYQuf-1H0PtS9zxUS-P3SwEzyJeMNBETW5QL73xukzN8NAAzmAQ>
    <xmx:PyoSYZrpIHOkn9YKsGc-sVgrV4bnrD-6FGDdCtuSTzphipbEtao4SA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 03:26:52 -0400 (EDT)
Date:   Tue, 10 Aug 2021 10:26:49 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRIqOZrrjS0HOppg@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRE7kNndxlGQr+Hw@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 04:28:32PM +0200, Andrew Lunn wrote:
> On Mon, Aug 09, 2021 at 01:21:45PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> > 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> > modules parameters and retrieve their status.
> 
> Hi Ido
> 
> I've not read all the patchset yet, but i like the general direction.
> 
> > The first parameter to control is the low power mode of the module. It
> > is only relevant for paged memory modules, as flat memory modules always
> > operate in low power mode.
> > 
> > When a paged memory module is in low power mode, its power consumption
> > is reduced to the minimum, the management interface towards the host is
> > available and the data path is deactivated.
> > 
> > User space can choose to put modules that are not currently in use in
> > low power mode and transition them to high power mode before putting the
> > associated ports administratively up.
> > 
> > Transitioning into low power mode means loss of carrier, so error is
> > returned when the netdev is administratively up.
> 
> However, i don't get this use case. With copper PHYs, putting the link
> administratively down results in a call into phylib and into the
> driver to down the link. This effectively puts the PHY into a low
> power mode. The management interface, as defined by C22 and C45 remain
> available, but the data path is disabled. For a 1G PHY, this can save
> a few watts.
> 
> For SFPs managed by phylink and the kernal SFP driver, the exact same
> happens. The TX_ENABLE pin of the SFP is set to false. The I2C bus
> still works, but the data path is disabled.
> 
> So i would expect a driver using firmware, not Linux code to manage
> SFPs, to just do this on link down. Why do we need user space
> involved?

The transition from low power to high power can take a few seconds with
QSFP/QSFP-DD and it's likely to only get longer with future / more
complex modules. Therefore, to reduce link-up time, the firmware
automatically transitions modules to high power mode.

There is obviously a trade-off here between power consumption and
link-up time. My understanding is that Mellanox is not the only vendor
favoring shorter link-up times as users have the ability to control the
low power mode of the modules in other implementations.

Regarding "why do we need user space involved?", by default, it does not
need to be involved (the system works without this API), but if it wants
to reduce the power consumption by setting unused modules to low power
mode, then it will need to use this API.
