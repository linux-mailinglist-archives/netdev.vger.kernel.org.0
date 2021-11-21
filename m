Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDA45857B
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhKURi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:38:26 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60895 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231519AbhKURi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 12:38:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D71AD5C0178;
        Sun, 21 Nov 2021 12:35:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 21 Nov 2021 12:35:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nwrzCy
        LhAuB9F8Gt2/NiQNrd4xBbwZ48U7MNTLuRTts=; b=Jgsvd17xbB6u4tM76YwwXx
        KhvbKy4/hov2mLVO125TC9ViD9O2+tXbcil4iaCR7mSwl4QByG2pqPi/IEQpyz2w
        o0iS4jTxn5fXTsAIJBzH4NajeXZ6XCyivCl+vZDUkXX+ISVNAHhVfbjewN7OFH+G
        TxNVN6h+xhjgitFiPeE+iSi9v2NFz1ynNc2mOD/6hl8uFnqpAE2sZjtHGh+ZMI5+
        DvHYD5+nmfD0qR8Dmf9rchwAekrKcoOqTgoaV/KjgGQJ6v0HZb1ymYXKWFSG9iqh
        jkFOk95iu/RnTTk02KcfMaYTy5hDtoO5EGRD3c/Pov6fxj3h6O+L/9R9FghpsQ7Q
        ==
X-ME-Sender: <xms:WIOaYX1x4fkTaFY-pBfkhEENjDa6K8RTf2zXKuAmufbYjmksk_VtVw>
    <xme:WIOaYWG8JT6eCHnlmJV3rMgLagK9rehTeWWKTZMH-blDcFUOU8QjrutuSRX6T2oup
    U09VhR9WTWtQ1Y>
X-ME-Received: <xmr:WIOaYX6zHBx5Ayk3a2kYpkj4aIgNNczxI2GtGYqyVISS2l65F8vREG51Fw-H>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgedvgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgjeevhfdvgeeiudekteduveegueejfefffeefteekkeeuueehjeduledtjeeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WIOaYc0Mh8JKBbe5-qqPG3dZcRGAn8-1DyIlgZbvqGxnBMpd8goI2w>
    <xmx:WIOaYaFlQPhRA6a0Pd6wTAH0D5j68Yz8_365aIn7a110C80hFGXKWg>
    <xmx:WIOaYd-HDF4jbJZA8Bg_FQI29bwAFtQEtygPqAlHDwHS2SvP4S8Gjw>
    <xmx:WIOaYWBq5PGYUDW_dBYhsJ_3dmBHEhBL3kUoEKYZNDlYQ7ZuH6RxyQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 Nov 2021 12:35:19 -0500 (EST)
Date:   Sun, 21 Nov 2021 19:35:17 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net 2/3] net: nexthop: release IPv6 per-cpu dsts when
 replacing a nexthop group
Message-ID: <YZqDVQiqSCMsDEZh@shredder>
References: <20211121152453.2580051-1-razor@blackwall.org>
 <20211121152453.2580051-3-razor@blackwall.org>
 <YZp/MvIX/YCHJY9K@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZp/MvIX/YCHJY9K@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 07:17:41PM +0200, Ido Schimmel wrote:
> On Sun, Nov 21, 2021 at 05:24:52PM +0200, Nikolay Aleksandrov wrote:
> > From: Nikolay Aleksandrov <nikolay@nvidia.com>
> Can we avoid two synchronize_net() per resilient group by removing the
> one added here and instead do:
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index a69a9e76f99f..a47ce43ab1ff 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -2002,9 +2002,10 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
>  
>         rcu_assign_pointer(old->nh_grp, newg);
>  
> +       /* Make sure concurrent readers are not using 'oldg' anymore. */
> +       synchronize_net();
> +
>         if (newg->resilient) {
> -               /* Make sure concurrent readers are not using 'oldg' anymore. */
> -               synchronize_net();
>                 rcu_assign_pointer(oldg->res_table, tmp_table);
>                 rcu_assign_pointer(oldg->spare->res_table, tmp_table);
>         }

Discussed this with Nik. It is possible and would be a good cleanup for
net-next. For net it is best to leave synchronize_net() where it is so
that the patch will be easier to backport. Resilient nexthop groups were
only added in 5.13 whereas nexthop objects were added in 5.3
