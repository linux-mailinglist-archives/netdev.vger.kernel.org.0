Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C960969BFCD
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjBSJpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjBSJpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:45:21 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31BB1043B;
        Sun, 19 Feb 2023 01:44:35 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i5-20020a05600c354500b003e1f5f2a29cso285823wmq.4;
        Sun, 19 Feb 2023 01:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMPdCMdS3VcScxunnSP7BsButuKXwgs+onI25X5O9Wc=;
        b=XumHyq0Cel+dqLclnreHmI24z4esM8bQ4QTXjRvnlukF87pE4zpQVADGHFMsOkwnvI
         +kRoyXBCMhN2n7Wk3f7YaVuguFfGb11LPoL56skE4G6TtIwU+Xt+RaKpA2aQR2TnAWv0
         G6l/edmC4Bzuxa1F3QV2QBDgnW4+tntG6InSHaRJ+kNbAZis7czCOaAmw43A+JZI1ZFf
         oMWw6bAayDEQroQsx3o4u/KUZcJs2DatuvYp9rPRcee91/Sq9nBB7I4ptgPtGtPQu4ES
         4pXVWMKAMybmyHn/n93UvLuiDQTItMIpf1qpKZygxgSwJrxiL5iPRvZdEVYMPoTBeNxj
         IjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMPdCMdS3VcScxunnSP7BsButuKXwgs+onI25X5O9Wc=;
        b=nJTU3xf7k6K/vnhTIlpqG5wpt1xgJdqsY9i6tymZyIJVFyrzTFCrGf7Y2xIY40RUsT
         NoNEzdxjZbWt3i8QmoiqWIdYEN2z7uFOsYG3eLefftzs1otWWD/uIrs0zRQ/x1NZ9jJN
         Pjrzo27mu4/JEoL68PBuMiNVW4gOwELVo/1FhGgJL6h6Pr3uFT0zJqsUPZYkEMUqQXs4
         1PJxDfclRz0/0dNxwespg8z2ZXmvh9Ngt9+urzo3ZH7XGDjLx8occI31EeVvQhAWUsBV
         2/nyq0LHvW3NZ6KadD4r0oroqjoGUQAcKMoFEFwxs7Y0qbnbVha8FU46hO/oUOhgyuNZ
         AVxQ==
X-Gm-Message-State: AO0yUKVlwTqkSs2UVxqxpNgJ+ZwwAI4fqXV9Vmx6TUXpioU1V/Cnlirn
        r2D4D2Kt/i6LzSHwJ1N+tPs=
X-Google-Smtp-Source: AK7set8atZ/0JasJukEMru+9LylLz33ZwjogL+rdHQbeUs6uRBoAyZ26dM6gZyx+5AdgFnEZFXIpig==
X-Received: by 2002:a05:600c:1895:b0:3e2:589:2512 with SMTP id x21-20020a05600c189500b003e205892512mr4627494wmp.21.1676799789000;
        Sun, 19 Feb 2023 01:43:09 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id u10-20020a05600c00ca00b003ddf2865aeasm5557673wmm.41.2023.02.19.01.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 01:43:08 -0800 (PST)
Message-ID: <07b5c523-7174-ac30-65cb-182e07db08dc@gmail.com>
Date:   Sun, 19 Feb 2023 11:43:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] net/mlx4_en: Introduce flexible array to silence overflow
 warning
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>, Tariq Toukan <tariqt@nvidia.com>
Cc:     Josef Oskera <joskera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20230218183842.never.954-kees@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230218183842.never.954-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/02/2023 20:38, Kees Cook wrote:
> The call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers a FORTIFY
> memcpy() warning on ppc64 platform:
> 
> In function ‘fortify_memcpy_chk’,
>      inlined from ‘skb_copy_from_linear_data’ at ./include/linux/skbuff.h:4029:2,
>      inlined from ‘build_inline_wqe’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
>      inlined from ‘mlx4_en_xmit’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
> ./include/linux/fortify-string.h:513:25: error: call to ‘__write_overflow_field’ declared with
> attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()?
> [-Werror=attribute-warning]
>    513 |                         __write_overflow_field(p_size_field, size);
>        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Same behaviour on x86 you can get if you use "__always_inline" instead of
> "inline" for skb_copy_from_linear_data() in skbuff.h
> 
> The call here copies data into inlined tx destricptor, which has 104
> bytes (MAX_INLINE) space for data payload. In this case "spc" is known
> in compile-time but the destination is used with hidden knowledge
> (real structure of destination is different from that the compiler
> can see). That cause the fortify warning because compiler can check
> bounds, but the real bounds are different.  "spc" can't be bigger than
> 64 bytes (MLX4_INLINE_ALIGN), so the data can always fit into inlined
> tx descriptor. The fact that "inl" points into inlined tx descriptor is
> determined earlier in mlx4_en_xmit().
> 
> Avoid confusing the compiler with "inl + 1" constructions to get to past
> the inl header by introducing a flexible array "data" to the struct so
> that the compiler can see that we are not dealing with an array of inl
> structs, but rather, arbitrary data following the structure. There are
> no changes to the structure layout reported by pahole, and the resulting
> machine code is actually smaller.
> 
> Reported-by: Josef Oskera <joskera@redhat.com>
> Link: https://lore.kernel.org/lkml/20230217094541.2362873-1-joskera@redhat.com
> Fixes: f68f2ff91512 ("fortify: Detect struct member overflows in memcpy() at compile-time")
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c | 22 +++++++++++-----------
>   include/linux/mlx4/qp.h                    |  1 +
>   2 files changed, 12 insertions(+), 11 deletions(-)
> 

Just saw your patch now, after commenting on the other thread. :)

So you choose not to fix similar usages in RDMA driver 
drivers/infiniband/hw/mlx4/qp.c, like:

3204         spc = MLX4_INLINE_ALIGN -
3205                 ((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
3206         if (header_size <= spc) {
3207                 inl->byte_count = cpu_to_be32(1 << 31 | header_size);
3208                 memcpy(inl + 1, sqp->header_buf, header_size);
3209                 i = 1;
3210         } else {
3211                 inl->byte_count = cpu_to_be32(1 << 31 | spc);
3212                 memcpy(inl + 1, sqp->header_buf, spc);
3213
3214                 inl = (void *) (inl + 1) + spc;
3215                 memcpy(inl + 1, sqp->header_buf + spc, header_size 
- spc);

This keeps the patch minimal indeed.

Did you repro the issue and test this solution?
Maybe Josef can also verify it works for him?

> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index c5758637b7be..2f79378fbf6e 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -699,32 +699,32 @@ static void build_inline_wqe(struct mlx4_en_tx_desc *tx_desc,
>   			inl->byte_count = cpu_to_be32(1 << 31 | skb->len);
>   		} else {
>   			inl->byte_count = cpu_to_be32(1 << 31 | MIN_PKT_LEN);
> -			memset(((void *)(inl + 1)) + skb->len, 0,
> +			memset(inl->data + skb->len, 0,
>   			       MIN_PKT_LEN - skb->len);
>   		}
> -		skb_copy_from_linear_data(skb, inl + 1, hlen);
> +		skb_copy_from_linear_data(skb, inl->data, hlen);
>   		if (shinfo->nr_frags)
> -			memcpy(((void *)(inl + 1)) + hlen, fragptr,
> +			memcpy(inl->data + hlen, fragptr,
>   			       skb_frag_size(&shinfo->frags[0]));
>   
>   	} else {
>   		inl->byte_count = cpu_to_be32(1 << 31 | spc);
>   		if (hlen <= spc) {
> -			skb_copy_from_linear_data(skb, inl + 1, hlen);
> +			skb_copy_from_linear_data(skb, inl->data, hlen);
>   			if (hlen < spc) {
> -				memcpy(((void *)(inl + 1)) + hlen,
> +				memcpy(inl->data + hlen,
>   				       fragptr, spc - hlen);
>   				fragptr +=  spc - hlen;
>   			}
> -			inl = (void *) (inl + 1) + spc;
> -			memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);
> +			inl = (void *)inl->data + spc;
> +			memcpy(inl->data, fragptr, skb->len - spc);
>   		} else {
> -			skb_copy_from_linear_data(skb, inl + 1, spc);
> -			inl = (void *) (inl + 1) + spc;
> -			skb_copy_from_linear_data_offset(skb, spc, inl + 1,
> +			skb_copy_from_linear_data(skb, inl->data, spc);
> +			inl = (void *)inl->data + spc;

No need now for all these (void *) castings.

> +			skb_copy_from_linear_data_offset(skb, spc, inl->data,
>   							 hlen - spc);
>   			if (shinfo->nr_frags)
> -				memcpy(((void *)(inl + 1)) + hlen - spc,
> +				memcpy(inl->data + hlen - spc,
>   				       fragptr,
>   				       skb_frag_size(&shinfo->frags[0]));
>   		}
> diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
> index c78b90f2e9a1..b9a7b1319f5d 100644
> --- a/include/linux/mlx4/qp.h
> +++ b/include/linux/mlx4/qp.h
> @@ -446,6 +446,7 @@ enum {
>   
>   struct mlx4_wqe_inline_seg {
>   	__be32			byte_count;
> +	__u8			data[];
>   };
>   
>   enum mlx4_update_qp_attr {
