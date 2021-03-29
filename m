Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EBA34C4A5
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 09:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhC2HNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 03:13:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59705 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229630AbhC2HNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 03:13:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A50725C00C8;
        Mon, 29 Mar 2021 03:13:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 03:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/7uC47
        tyZHed3ZcIIKccZiAosvBtxSCbPo8oJazuqbA=; b=oKc7KRwd3zDaQ5ve+L7Y5X
        LR5lCOaAcxC2KAiA+maMccaqr2VFX2eoJg14+bNmo1NjULx9wE+B6Avbk3buKnLN
        0dtln7lWkBKxYq2u55zHfOtWR63yXmhNlCS+DNw0DDIgyi2BJQ/VMzVf3j7FEPgj
        zT5wkLsHQcmbIBaeEMz0bfm3F67NYRRreCBT61z9gToHbmSLA21llPy94Jy5Y0tB
        /3rRBfAYj2GBEUDEMVJhZem2atAxszxObevLuBTjgXrILjUkM16zFxLXvbuD5jE3
        qvdO9Wr9GBq18NqWIqdZbF1oBsPP0P2c4Scif4fY2IP3H/FzL0qO/oEGFWjKpNFw
        ==
X-ME-Sender: <xms:E35hYO3YVb9zKzrR4_C_-gBwDZ0V12ZboqhYR5c3iz1jYbozkcisIg>
    <xme:E35hYBFn5GAemnDM60S8MG-b8-KuxN2wVa1YzjM58bDOwIfQlD8d2YaIoLwjGRu6T
    XKmrwzXaBSHBwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehjedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:E35hYG6A5S73fSW8wMYIMJOFNkeDuV45YQmHKVUS-0K8e4x5X7yqhg>
    <xmx:E35hYP3uZTeKfaRPFgPt27g0IF2MoLRcR3JqlPW0ZbzhQ_SASpKqWQ>
    <xmx:E35hYBHUnR6Hz2lnn24soLudwoYa8KntKfWa3YmCRH4NzhiNnK4RuA>
    <xmx:FH5hYKO_nwXcHg-PMB_m_3ds_H9FTCAneOSS_xwKix1b4a1GveVcMg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 70DEB24005D;
        Mon, 29 Mar 2021 03:13:23 -0400 (EDT)
Date:   Mon, 29 Mar 2021 10:13:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        petrm@nvidia.com
Subject: Re: [PATCH][next] mlxsw: spectrum_router: remove redundant
 initialization of variable force
Message-ID: <YGF+D6fXNIbNVzff@shredder.lan>
References: <20210327223334.24655-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210327223334.24655-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 10:33:34PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable force is being initialized with a value that is
> never read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 6ccaa194733b..ff240e3c29f7 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -5059,7 +5059,7 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
>  {
>  	u16 bucket_index = info->nh_res_bucket->bucket_index;
>  	struct netlink_ext_ack *extack = info->extack;
> -	bool force = info->nh_res_bucket->force;
> +	bool force;

Actually, there is a bug to be fixed here:

```
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6ccaa194733b..41259c0004d1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5068,8 +5068,9 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
        /* No point in trying an atomic replacement if the idle timer interval
         * is smaller than the interval in which we query and clear activity.
         */
-       force = info->nh_res_bucket->idle_timer_ms <
-               MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL;
+       if (!force && info->nh_res_bucket->idle_timer_ms <
+           MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL)
+               force = true;
 
        adj_index = nh->nhgi->adj_index + bucket_index;
        err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh, force, ratr_pl);
```

We should only fallback to a non-atomic replacement when the current
replacement is atomic and the idle timer is too short.

We currently ignore the value of 'force'. This means that a non-atomic
replacement ('force' is true) can be made atomic if idle timer is larger
than 1 second.

Colin, do you mind if I submit it formally as a fix later this week? I
want to run it through our usual process. Will mention you in
Reported-by, obviously.

>  	char ratr_pl_new[MLXSW_REG_RATR_LEN];
>  	char ratr_pl[MLXSW_REG_RATR_LEN];
>  	u32 adj_index;
> -- 
> 2.30.2
> 
