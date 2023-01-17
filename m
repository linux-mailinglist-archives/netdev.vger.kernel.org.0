Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60B66E571
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjAQR5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAQRzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:55:22 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0C74F864;
        Tue, 17 Jan 2023 09:46:54 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so2224312wmq.0;
        Tue, 17 Jan 2023 09:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mT1iuA7LX+o7ZziOhsJvTdUaDR1kOXSBSq2ES2EqBkA=;
        b=DZyc0W3KOoru/lvxdYk0j9vkHfhE/2LntYlBgR8RQOEQ5lyb/QHbKj3mxSqdBCijNT
         jMGP9Vf59pe2RKIAzwjkQZughhJWKPXmFc2tAZA6dn59M2GG3d+oARJm0lkvi5qvt1SE
         netxw2yf1GRyBQArMasBzFHxwHMkYebF7l9RFISbv8yPc/OI/TQA17ykI9fMU14LVX/f
         aezJ7bYyDmQg4bFmPUI7Eq0j4jtrUCOcgJuJsWpbS4LrTkvgKTSFnDaLvqeJh/wvHg5A
         fjpHk75l2F9RTgTJ8sV0lrttKo21OT1DSvEOD68TP3EeAdJc4IJpG0EcSb9qhtIzS00N
         dCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mT1iuA7LX+o7ZziOhsJvTdUaDR1kOXSBSq2ES2EqBkA=;
        b=sWHy92KWI1atvAxWPJikEDMHyLc7H06hrQlaovhRhxbcVDQeOwiNJhVyK1W8yMOU/l
         nHsHyC5Kkn4LXunqu5IGOzQ5wEp42EfWYQce8Dio/Aot0uIeJ5pC+DgbcIpbzdtkG2Qh
         /vzak6OgVzIKy4VlpR2RDFlLq9kGUCeRawz4GZF2ReuNnJP6MwlBqq6e55dk+j222uzj
         GEL3ixxXu0UIKNcQCn7XHeNuUg2G0cTAsNRdpBRBstLQLoiQQ/q4Gbxg9yLRjqLtdmqO
         0MGWGLj68pwjeK3hdugTJDa5YHd3fB+lFGuSWvFwsO5CQoWFOYLZ+5l9isTp0DtGO5uY
         R5ww==
X-Gm-Message-State: AFqh2ko6yD4hxFXjt96bySOjJrpl8U+578BnxHq0fyhqrpVOm0ZkFwFq
        yPjeOYC361AqZnl/mvWmtwh6XX07t8SyoQ==
X-Google-Smtp-Source: AMrXdXv4A/kTfAAcbVCOm+owmm2mqDGCSCL8dJtYQTkzBudTo3nLX7sMTKs/96sOCjL/Fe0/7YDq5A==
X-Received: by 2002:a05:600c:1c2a:b0:3cf:d0b1:8aa1 with SMTP id j42-20020a05600c1c2a00b003cfd0b18aa1mr3917725wms.0.1673977613137;
        Tue, 17 Jan 2023 09:46:53 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id u18-20020adff892000000b002bded7da2b8sm9614477wrp.102.2023.01.17.09.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 09:46:52 -0800 (PST)
Message-ID: <98636010-fb0b-1771-e81f-cce90740d358@gmail.com>
Date:   Tue, 17 Jan 2023 19:46:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] mlx5: reduce stack usage in mlx5_setup_tc
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230117172825.3170190-1-arnd@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230117172825.3170190-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/01/2023 19:28, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Clang warns about excessive stack usage on 32-bit targets:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
> static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
> 
> It turns out that both the mlx5e_setup_tc_mqprio_dcb() function and
> the mlx5e_safe_switch_params() function it calls have a copy of
> 'struct mlx5e_params' on the stack, and this structure is fairly
> large.
> 
> Use dynamic allocation for both.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_main.c | 36 ++++++++++++-------
>   1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 6bb0fdaa5efa..e5198c26e383 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -2993,37 +2993,42 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
>   	return err;
>   }
>   
> -int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
> +noinline_for_stack int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
>   			     struct mlx5e_params *params,
>   			     mlx5e_fp_preactivate preactivate,
>   			     void *context, bool reset)
>   {
> -	struct mlx5e_channels new_chs = {};
> +	struct mlx5e_channels *new_chs;
>   	int err;
>   
>   	reset &= test_bit(MLX5E_STATE_OPENED, &priv->state);
>   	if (!reset)
>   		return mlx5e_switch_priv_params(priv, params, preactivate, context);
>   
> -	new_chs.params = *params;
> +	new_chs = kzalloc(sizeof(*new_chs), GFP_KERNEL);
> +	if (!new_chs)
> +		return -ENOMEM;
> +	new_chs->params = *params;
>   
> -	mlx5e_selq_prepare_params(&priv->selq, &new_chs.params);
> +	mlx5e_selq_prepare_params(&priv->selq, &new_chs->params);
>   
> -	err = mlx5e_open_channels(priv, &new_chs);
> +	err = mlx5e_open_channels(priv, new_chs);
>   	if (err)
>   		goto err_cancel_selq;
>   
> -	err = mlx5e_switch_priv_channels(priv, &new_chs, preactivate, context);
> +	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
>   	if (err)
>   		goto err_close;
>   
> +	kfree(new_chs);
>   	return 0;
>   
>   err_close:
> -	mlx5e_close_channels(&new_chs);
> +	mlx5e_close_channels(new_chs);
>   
>   err_cancel_selq:
>   	mlx5e_selq_cancel(&priv->selq);
> +	kfree(new_chs);
>   	return err;
>   }
>   
> @@ -3419,10 +3424,10 @@ static void mlx5e_params_mqprio_reset(struct mlx5e_params *params)
>   	mlx5e_params_mqprio_dcb_set(params, 1);
>   }
>   
> -static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
> +static noinline_for_stack int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
>   				     struct tc_mqprio_qopt *mqprio)
>   {
> -	struct mlx5e_params new_params;
> +	struct mlx5e_params *new_params;
>   	u8 tc = mqprio->num_tc;
>   	int err;
>   
> @@ -3431,10 +3436,13 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
>   	if (tc && tc != MLX5E_MAX_NUM_TC)
>   		return -EINVAL;
>   
> -	new_params = priv->channels.params;
> -	mlx5e_params_mqprio_dcb_set(&new_params, tc ? tc : 1);
> +	new_params = kmemdup(&priv->channels.params,
> +			     sizeof(priv->channels.params), GFP_KERNEL);
> +	if (!new_params)
> +		return -ENOMEM;
> +	mlx5e_params_mqprio_dcb_set(new_params, tc ? tc : 1);
>   
> -	err = mlx5e_safe_switch_params(priv, &new_params,
> +	err = mlx5e_safe_switch_params(priv, new_params,
>   				       mlx5e_num_channels_changed_ctx, NULL, true);
>   

Is this change really required, even after new_chs are dynamically 
allocated?
As this code pattern of static local new_params repeats in all callers 
of mlx5e_safe_switch_params, let's not change this one alone if not 
necessary.


Same for the noinline_for_stack. Are they really needed even after using 
dynamic allocation for new_chs?

>   	if (!err && priv->mqprio_rl) {
> @@ -3445,6 +3453,8 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
>   
>   	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
>   				    mlx5e_get_dcb_num_tc(&priv->channels.params));
> +
> +	kfree(new_params);
>   	return err;
>   }
>   
> @@ -3533,7 +3543,7 @@ static struct mlx5e_mqprio_rl *mlx5e_mqprio_rl_create(struct mlx5_core_dev *mdev
>   	return rl;
>   }
>   
> -static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
> +static noinline_for_stack int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
>   					 struct tc_mqprio_qopt_offload *mqprio)
>   {
>   	mlx5e_fp_preactivate preactivate;

