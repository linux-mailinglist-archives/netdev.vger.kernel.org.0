Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0854585B5
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhKUR61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:58:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53805 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238020AbhKUR60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 12:58:26 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C8BD5C00CF;
        Sun, 21 Nov 2021 12:55:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 21 Nov 2021 12:55:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+ZncBV
        LucXYTM8cswccp937/4++gGHR59DhQ+v926I0=; b=XaWgCblu3mhqIocMUAh5gV
        qTjO3fODf8aGe01yuL/xELqvvBxfq4BaBelv3D7HpvliK1L9JI/RcY9mHpSNFanR
        zqKLVllhRxqarrxfvO3IPXHzcIStZEwEO2VCOXHwkmcgEJ7ea2ndDsmQiHRI0ptv
        DMJrEG02hN9b4UpHtorehz8hlmsHhT/MeDPUl4/Mf5OBiZFg1Pb/VHOZv8JHvf97
        NInsB/bO+PuaTUFgi6mx8KT8MSEKJG3riblGeoAc8NDfIiCr/gPUGTWD9Z2XxKi2
        d3IETF7ZPeIdfWwVbfWA5aGcV3QFoHVsMKuUV4+JgH3QY2fe9VJ/aRBaGCQFixlA
        ==
X-ME-Sender: <xms:CYiaYXYYesDkI_nxlVdWS00CSrD2cduHxR6KqPQF--FuuDVWAf6pKg>
    <xme:CYiaYWaKtM7OeqX0Xn5jQgT2kaMMxnfSdoR0tBaJr7PmnVZZSHiRHg8UB0xzaFnCB
    q5rfM_3OYUTQN4>
X-ME-Received: <xmr:CYiaYZ_pnjhfVfaL2zbrpKOPRANOufRpX-F2eWBHgcS6dppANxiH2VgMCv8M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgedvgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CYiaYdq-BWc6UZENczr503wEAtBA2DyhsQTAKholfx3cRL9scnB_sA>
    <xmx:CYiaYSrjJUDww9CbSzydwnmjSL36X5Y4DY3H0ti57BbboxyiOyySfQ>
    <xmx:CYiaYTQR2LHYLAF-p3-Z3rSJ_zreoKOc-jKJx0rbZBXHXKagw4lv_g>
    <xmx:CYiaYVXptc0AF6afAegNEOgDLY2N4kReTGmnSIS93A4tjpeaxlS9FQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 Nov 2021 12:55:20 -0500 (EST)
Date:   Sun, 21 Nov 2021 19:55:17 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net 0/3] net: nexthop: fix refcount issues when replacing
 groups
Message-ID: <YZqIBVcFwIzj6VZG@shredder>
References: <20211121152453.2580051-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121152453.2580051-1-razor@blackwall.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:24:50PM +0200, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set fixes a refcount bug when replacing nexthop groups and
> modifying routes. It is complex because the objects look valid when
> debugging memory dumps, but we end up having refcount dependency between
> unlinked objects which can never be released, so in turn they cannot
> free their resources and refcounts. The problem happens because we can
> have stale IPv6 per-cpu dsts in nexthops which were removed from a
> group. Even though the IPv6 gen is bumped, the dsts won't be released
> until traffic passes through them or the nexthop is freed, that can take
> arbitrarily long time, and even worse we can create a scenario[1] where it
> can never be released. The fix is to release the IPv6 per-cpu dsts of
> replaced nexthops after an RCU grace period so no new ones can be
> created. To do that we add a new IPv6 stub - fib6_nh_release_dsts, which
> is used by the nexthop code only when necessary. We can further optimize
> group replacement, but that is more suited for net-next as these patches
> would have to be backported to stable releases.

Will run regression with these patches tonight and report tomorrow
