Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7E82D8896
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405898AbgLLRZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:25:52 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39475 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbgLLRZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 12:25:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B38C95C0143;
        Sat, 12 Dec 2020 12:25:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 12 Dec 2020 12:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=bOPa7BM4H8hfQz+efzxXUEI3lX5JYC+qy5LBxGlDR
        v0=; b=pQe13pyST5vjrAXRc2+o0as7oaKNLGNTJuRxUM99YWVhzdyPJ36J3ONJA
        VXn5Qu3+LEMOoQBzq2tT83km5Xzs4wWiuA7AUdIeQDqijb4/FUm0e0YaiTDtxI+1
        No8tBM1tdzIiLb+l/1MvrSY8ZL87KKW0CFJ4v6FtY899eAERCEZjZyvw1LyM5c2g
        t6N49r28C9uNUIwe8gARP2xQbaBU7gCaw3ewmtRqbmv9qfY45a8QAq7nBf5ly8uP
        d/pzN+D7nCMBhwABrxOI/YtKesMq8ChFvHkkwCMaLxmXCFcHkjF5pd1QL1GPWMOZ
        y4inFLnmpWGJPZ5/ulyO8LYjkz1bQ==
X-ME-Sender: <xms:8fzUX9k5LwlLJudMdRaTr5HUUt1Ta5HQP_CSgyrGjWBV9i-TjlgJ3Q>
    <xme:8fzUX42zFiGHLHmVPDeZfv7kKm83VhpuFzF6txWSKvP6kuNV6pKAu0r5t0gVpIcJk
    mBcNktFwtHd1U4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekgedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjgesth
    ekredttddtjeenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnhepuefgjeefveeivdektdfggefhge
    evudegvefgtedugfetveevuedtgffhkefggefgnecukfhppeekgedrvddvledrudehfedr
    jeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8fzUXzp5Vz82mE97qHQXyzD72jGGHgJDa_MqFNcVcSh3iGEl_-ov4w>
    <xmx:8fzUX9klhOHeNcMGeAwOAR7He8m1c9Zo2wnEdK2MCAaoczUHRnvriA>
    <xmx:8fzUX73XlA1SA8Pb3nfb6bck9i4aGgFRS2ndlqsbCWZnLvqWFK6CyQ>
    <xmx:8fzUX5A_SoBJ92J_UZJhFSEXg0KwIFJvAj_HWUR771vt1GQJVI5pIw>
Received: from localhost (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11EA7108005B;
        Sat, 12 Dec 2020 12:25:04 -0500 (EST)
Date:   Sat, 12 Dec 2020 19:25:02 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 13/15] mlxsw: spectrum_router_xm: Introduce
 basic XM cache flushing
Message-ID: <20201212172502.GA2431723@shredder.lan>
References: <20201211170413.2269479-1-idosch@idosch.org>
 <20201211170413.2269479-14-idosch@idosch.org>
 <20201211202427.5871de8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201211202427.5871de8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 08:24:27PM -0800, Jakub Kicinski wrote:
> On Fri, 11 Dec 2020 19:04:11 +0200 Ido Schimmel wrote:
> > From: Jiri Pirko <jiri@nvidia.com>
> > 
> > Upon route insertion and removal, it is needed to flush possibly cached
> > entries from the XM cache. Extend XM op context to carry information
> > needed for the flush. Implement the flush in delayed work since for HW
> > design reasons there is a need to wait 50usec before the flush can be
> > done. If during this time comes the same flush request, consolidate it
> > to the first one. Implement this queued flushes by a hashtable.
> > 
> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> 32 bit does not like this patch:

Thanks

Jiri, looks like this fix is needed:

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
index b680c22eff7d..d213af723a2a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -358,7 +358,7 @@ mlxsw_sp_router_xm_cache_flush_node_destroy(struct mlxsw_sp *mlxsw_sp,
 
 static u32 mlxsw_sp_router_xm_flush_mask4(u8 prefix_len)
 {
-       return GENMASK(32, 32 - prefix_len);
+       return GENMASK(31, 32 - prefix_len);
 }
 
 static unsigned char *mlxsw_sp_router_xm_flush_mask6(u8 prefix_len)

> 
> In file included from ../include/linux/bitops.h:5,
>                  from ../include/linux/kernel.h:12,
>                  from ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:4:
> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c: In function ‘mlxsw_sp_router_xm_flush_mask4’:
> ../include/linux/bits.h:36:11: warning: right shift count is negative [-Wshift-count-negative]
>    36 |   (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>       |           ^~
> ../include/linux/bits.h:38:31: note: in expansion of macro ‘__GENMASK’
>    38 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>       |                               ^~~~~~~~~
> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:9: note: in expansion of macro ‘GENMASK’
>   361 |  return GENMASK(32, 32 - prefix_len);
>       |         ^~~~~~~
> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:16: warning: shift count is negative (-1)
> In file included from ../include/linux/bitops.h:5,
>                  from ../include/linux/kernel.h:12,
>                  from ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:4:
> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c: In function ‘mlxsw_sp_router_xm_flush_mask4’:
> ../include/linux/bits.h:36:11: warning: right shift count is negative [-Wshift-count-negative]
>    36 |   (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>       |           ^~
> ../include/linux/bits.h:38:31: note: in expansion of macro ‘__GENMASK’
>    38 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>       |                               ^~~~~~~~~
> ../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:9: note: in expansion of macro ‘GENMASK’
>   361 |  return GENMASK(32, 32 - prefix_len);
>       |         ^~~~~~~
