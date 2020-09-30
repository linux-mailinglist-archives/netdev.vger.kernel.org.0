Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A77227EB2E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgI3Onm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:43:42 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50729 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727426AbgI3Onm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:43:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 733E558036C;
        Wed, 30 Sep 2020 10:43:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Sep 2020 10:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3ChX5q
        XMKUTwZ8FejWMkBUMw16i3+H4w9h/X8vC0n0Q=; b=gw9X79DTJ1jQpTV7IylbXR
        iabL8W+lKvDzmdPFFgnP9GTHBkgyHyGVO9CvUMdffWNDfuYGC68o6r6zcl2+zgeM
        e1PeF/MgcXnSAUhwxKJ2sYS8cc1zqztQGiyJUcZRAx7/6+ZeVDF7JGpPIW/b5IZE
        UQ10gDUeZO1gkFkJHUrIITa/ue1TMTAgCjNAZhu5udWUysmkW62gCDYQgO/kFjnV
        h3i9EO+joL/Igpe3fXYG8KCkVa/0pVFLMmPzkV3UrlTnp2aMVAq0iVFRxzNv5DTs
        6Y7lwjlkkscQm1Qh5Syy+boqr+cyCtH6yz58L4SXPZoKc7VmPuL1A8ywUWncBW9Q
        ==
X-ME-Sender: <xms:nZl0X5Cxv_DFK0p5r8PXRfD5hy1nOaZ5G0i7h82ca9bo5LgjzKwdlg>
    <xme:nZl0X3gW3JOUpSNddig6Gyk9u9P_bUw4tnhn0vSJxv0RavLcQHdyrYLTRYs73gdje
    -4uQh9TyXSXntI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleehkeeu
    necuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeegrddvvdelrdefjedrud
    egkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehi
    ughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nZl0X0m55W5HC-IfZeIqTrCeUk_-REAF4NI1d945LRb8y9SWnDxI8g>
    <xmx:nZl0Xzzmdv47kQNGFdsoKfRnOJwv72DInZHCwAtz9xSB8P5ZM4GbHg>
    <xmx:nZl0X-SzDa9Kgs_p9UHCebKeJtwQtjH_Ogf_zPf-keIh5LNg_72CJA>
    <xmx:nZl0X7Qu2GPVsB_MT5CvbeCF50BpHzIMnpt316KB4mF45jP_4KpXag>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9DC9C3064610;
        Wed, 30 Sep 2020 10:43:40 -0400 (EDT)
Date:   Wed, 30 Sep 2020 17:43:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        ayal@nvidia.com, danieller@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930144337.GA1826036@shredder>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
 <20200930072529.GA1788067@shredder>
 <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
 <20200930141909.GJ3996795@lunn.ch>
 <20200930143527.GA1824481@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930143527.GA1824481@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:35:31PM +0300, Ido Schimmel wrote:
> https://github.com/torvalds/linux/blob/master/net/ethtool/linkmodes.c#L2

Should be:

https://github.com/torvalds/linux/blob/master/net/ethtool/linkmodes.c#L290
