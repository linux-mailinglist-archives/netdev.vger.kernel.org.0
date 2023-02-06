Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B477368B7A4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBFIqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFIqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:46:12 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6CB1700
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 00:46:09 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q8so8078067wmo.5
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 00:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i4g1DnGvekJdcdvEu0HFkRwdB/mROBG5cpWSWwk0tjo=;
        b=SBRDT3DUmOMxbYtbad/bHQbbl6tCCnVi1LVRKiaqPR6CkImpeB/qbx83afzxp2Sa5c
         YXJbBNLGt3jKDXv1V3f9UIaNKJUHt5VnRgX8TFYFdFBRjHOUKDmyrs4Opl1Lf4R3sWxc
         34jtR7tVJS4CsoPaD5H3eWKv2mTXYJ2lqVHhiaNpuHnp8NQgop+xc6vDsyhoaLVGHrUS
         7pHcKwAtOYhUmd2KqBVH+2CnjcsSVJWNJjXlqywYqnizGpxy9ObLjOYH60Jn6r3Kg/Z+
         mJ6ogThRhNepntFnmgnSBwbMT/hzVF9NBZU5VuZ8sKONEfQHnnQoX0FxBmr0RVHhyLYe
         BZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i4g1DnGvekJdcdvEu0HFkRwdB/mROBG5cpWSWwk0tjo=;
        b=mUCvBjjaKinlnUs+smDfvb+BFj20BytV5qN30X9TmcgugW/I6eA//5x0HWTc7MSI+N
         19l/Ub18Bm1CxE28WunoQmUlXDMOJ5dSw6l0qEBwq9BGKvycA2x9Kgfsgm3Oe0aOZGmZ
         Pqx7KIMHbJ/fW/UrSnjFSjsalqEJjNdn4o3woBKRevmjUCnoBRepsyWk+JuAbXV4JPf8
         fC+3cRGKl49+MRY+NGUujikt5lIUmYeev6IXxn9RbV2ssEWtrE1dM5UFuJUfzbdhuGi/
         +40GjjJ5ZEgbLj5dHKdNeHKY9IxuZxE7nPM1FMRQTlxwWhWRMJqc0tO8dbx4sDRVfet5
         o4Mg==
X-Gm-Message-State: AO0yUKUDDrY0toWBTn4ENEI1uFtg+jzuu9mNAKW2KL1QOSRne0Ynldz4
        A4YAlrcZOCUeOJ04C5KWkd0=
X-Google-Smtp-Source: AK7set+AreHxlN8zkgcULAHanDzvlNpVklzXYnqUyKMZa9tMEHsXf2BxDSaGz3oKUYq3GGI5KIUd8Q==
X-Received: by 2002:a05:600c:511f:b0:3dc:55d9:ec8 with SMTP id o31-20020a05600c511f00b003dc55d90ec8mr22062627wms.41.1675673167900;
        Mon, 06 Feb 2023 00:46:07 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c470900b003dfe549da4fsm10553204wmo.18.2023.02.06.00.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 00:46:07 -0800 (PST)
Message-ID: <1ba621ec-224d-5688-1566-f558fdfde6ad@gmail.com>
Date:   Mon, 6 Feb 2023 10:46:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v3 1/2] net/mlx5e: XDP, Allow growing tail for XDP
 multi buffer
To:     Maxim Mikityanskiy <maxtram95@gmail.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230204151139.222900-1-maxtram95@gmail.com>
 <20230204151139.222900-2-maxtram95@gmail.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230204151139.222900-2-maxtram95@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/02/2023 17:11, Maxim Mikityanskiy wrote:
> The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
> is required by bpf_xdp_adjust_tail to support growing the tail pointer
> in fragmented packets. Pass the missing parameter when the current RQ
> mode allows XDP multi buffer.
> 
> Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
> Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 8 ++++++--
>   drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 7 ++++---
>   3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> index 4ad19c981294..857cb4e59050 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -662,7 +662,8 @@ static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size, bool xdp)
>   static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>   				     struct mlx5e_params *params,
>   				     struct mlx5e_xsk_param *xsk,
> -				     struct mlx5e_rq_frags_info *info)
> +				     struct mlx5e_rq_frags_info *info,
> +				     u32 *xdp_frag_size)
>   {
>   	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
>   	int frag_size_max = DEFAULT_FRAG_SIZE;
> @@ -772,6 +773,8 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>   
>   	info->log_num_frags = order_base_2(info->num_frags);
>   
> +	*xdp_frag_size = info->num_frags > 1 && params->xdp_prog ? PAGE_SIZE : 0;
> +
>   	return 0;
>   }
>   
> @@ -917,7 +920,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
>   	}
>   	default: /* MLX5_WQ_TYPE_CYCLIC */
>   		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
> -		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
> +		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info,
> +						&param->xdp_frag_size);
>   		if (err)
>   			return err;
>   		ndsegs = param->frags_info.num_frags;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> index c9be6eb88012..e5930fe752e5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> @@ -24,6 +24,7 @@ struct mlx5e_rq_param {
>   	u32                        rqc[MLX5_ST_SZ_DW(rqc)];
>   	struct mlx5_wq_param       wq;
>   	struct mlx5e_rq_frags_info frags_info;
> +	u32                        xdp_frag_size;
>   };
>   
>   struct mlx5e_sq_param {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index abcc614b6191..d02af93035b2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -576,7 +576,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
>   }
>   
>   static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
> -			     struct mlx5e_rq *rq)
> +			     u32 xdp_frag_size, struct mlx5e_rq *rq)
>   {
>   	struct mlx5_core_dev *mdev = c->mdev;
>   	int err;
> @@ -599,7 +599,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>   	if (err)
>   		return err;
>   
> -	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
> +	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
> +				  xdp_frag_size);
>   }
>   
>   static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
> @@ -2214,7 +2215,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>   {
>   	int err;
>   
> -	err = mlx5e_init_rxq_rq(c, params, &c->rq);
> +	err = mlx5e_init_rxq_rq(c, params, rq_params->xdp_frag_size, &c->rq);
>   	if (err)
>   		return err;
>   

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
