Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A799B645A03
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLGMlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLGMku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:40:50 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497772873E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:40:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vp12so13660713ejc.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 04:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C3dN6ExLZI+mBVJseiAIpaow0SqjB0M/lgAVHyND5CQ=;
        b=K0EOhVjaR5/qVyzZmLOlgjaMQge68Pn4v05hQPYJGCeMMLjZ1gJEIRmIcD0NNJu2R8
         Vbv4sxEoucnCuQwd1XIAYh9c8T6wEKm3Eg08WCE+2d5ZviYorPAu6q3gQWmJXDp2cSxB
         m1I4In39uiOAf0EcSHUHoJte8ghBMIL5yTSOxBjw+tnMxQyc7jVxcd1CFpbUuzP7oiUE
         X86G8dmHdKhVBrW6UtSWNxffQiFxzhbX4omHJxnQtufEnn92VuFHeyeM99UIzUvmZPy7
         jEFPxWL79y5hCmMlD4Jg39xa9/zioYRecGw6IeUWIT/BGB+D5I39esriqXGui4DY6W4t
         jFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3dN6ExLZI+mBVJseiAIpaow0SqjB0M/lgAVHyND5CQ=;
        b=IjZ1syxLvWgIAy+HmF/wskVaFkCcIhWpnt+p6U13abkQiSdNiv8LL3J3u7mqwI5Zru
         GVLe1XU3qdD9NtHMWGV4GcS1p6r46Cykw4a3QV/g2shgR3vIlECaqgHr2Lt4D4VMvLg3
         /0akpfmGohph6uDTqGWo8cra0CH7k6b3vCj7nzJe3wy1jf+U7vgkje7VEZuBGEpUIQmc
         +ISaGYI7l8Xjdj5BT9MRAcgUW0BeSeQ74vEVy6p4nr065uYNlUGj0FJ1Z0XQV8Jjbncn
         tGPMrsUuA7RfQXU0fNwt+9M6rkQngqITrBI9MDiP4OyWL4h9N/gweanlznETbu1nESYX
         DTUQ==
X-Gm-Message-State: ANoB5pkhPatyEaMpQmkZOdmpIvoWuCZl66mvIYUq+BQ+Y7zbnd1LL+U8
        yACBoe12flD1zw7lPD2pBQiEII3SWrI=
X-Google-Smtp-Source: AA0mqf54vi3x/H9tfeW/9H8vQ2CZNdYTEmhvjL7vXx78ycuru8GWkDzK6ktzugqO7w1vvfUkKDP/lQ==
X-Received: by 2002:a17:906:a148:b0:7ad:b286:8ee2 with SMTP id bu8-20020a170906a14800b007adb2868ee2mr33335673ejb.511.1670416822787;
        Wed, 07 Dec 2022 04:40:22 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id rr25-20020a170907899900b007c00323cc23sm8434733ejc.27.2022.12.07.04.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 04:40:22 -0800 (PST)
Message-ID: <40ca4e2e-8f34-545a-7063-09aee0a5dd4c@gmail.com>
Date:   Wed, 7 Dec 2022 14:40:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends
 on MAX_SKB_FRAGS
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20221206055059.1877471-1-edumazet@google.com>
 <20221206055059.1877471-3-edumazet@google.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221206055059.1877471-3-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/2022 7:50 AM, Eric Dumazet wrote:
> Google production kernel has increased MAX_SKB_FRAGS to 45
> for BIG-TCP rollout.
> 
> Unfortunately mlx4 TX bounce buffer is not big enough whenever
> an skb has up to 45 page fragments.
> 
> This can happen often with TCP TX zero copy, as one frag usually
> holds 4096 bytes of payload (order-0 page).
> 
> Tested:
>   Kernel built with MAX_SKB_FRAGS=45
>   ip link set dev eth0 gso_max_size 185000
>   netperf -t TCP_SENDFILE
> 
> I made sure that "ethtool -G eth0 tx 64" was properly working,
> ring->full_size being set to 16.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Wei Wang <weiwan@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index 7cc288db2a64f75ffe64882e3c25b90715e68855..120b8c361e91d443f83f100a1afabcabc776a92a 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -89,8 +89,18 @@
>   #define MLX4_EN_FILTER_HASH_SHIFT 4
>   #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
>   
> -/* Typical TSO descriptor with 16 gather entries is 352 bytes... */
> -#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
> +#define CTRL_SIZE	sizeof(struct mlx4_wqe_ctrl_seg)
> +#define DS_SIZE		sizeof(struct mlx4_wqe_data_seg)
> +
> +/* Maximal size of the bounce buffer:
> + * 256 bytes for LSO headers.
> + * CTRL_SIZE for control desc.
> + * DS_SIZE if skb->head contains some payload.
> + * MAX_SKB_FRAGS frags.
> + */
> +#define MLX4_TX_BOUNCE_BUFFER_SIZE (256 + CTRL_SIZE + DS_SIZE +		\
> +				    MAX_SKB_FRAGS * DS_SIZE)
> +
>   #define MLX4_MAX_DESC_TXBBS	   (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
>  

Now as MLX4_TX_BOUNCE_BUFFER_SIZE might not be a multiple of TXBB_SIZE, 
simple integer division won't work to calculate the max num of TXBBs.
Roundup is needed.

>   /*
> @@ -217,9 +227,7 @@ struct mlx4_en_tx_info {
>   
>   
>   #define MLX4_EN_BIT_DESC_OWN	0x80000000
> -#define CTRL_SIZE	sizeof(struct mlx4_wqe_ctrl_seg)
>   #define MLX4_EN_MEMTYPE_PAD	0x100
> -#define DS_SIZE		sizeof(struct mlx4_wqe_data_seg)
>   
>   
>   struct mlx4_en_tx_desc {
