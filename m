Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED9D41C29A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245332AbhI2KVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245125AbhI2KU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 06:20:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06926C06161C;
        Wed, 29 Sep 2021 03:19:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id dn26so6523960edb.13;
        Wed, 29 Sep 2021 03:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bx/2C+HXBotIPqznZhQEX8s1vNGSCbDgiHrtAcPp7ks=;
        b=AY3G2dwDY10Je5oEMZqoZqLvv8DoF63AOwbgCdP2bd27LiggDdf03oqAqpJVjMa+U7
         OwL8lUUebg0KLcGQy1DMZjcnkT+2KmjkghKxxCGJvm/76OAEpSUIE96/en2g8jPpPs7g
         l2NHrW96iLGAJsHAflfLKGPbyJC1MMyy4PHTiU7CA7ntITLCeyS+roritsdFgUfzSZ73
         YuGsOiIEUQG4oPReApkdgWiSQAYULNZjQdmuXox63KjRdQKcK83F8eVU77V3f/rTb/Mb
         TX0aBoZwOWGVbToo2JkoloRBHnTvvrD7SdfCzKnPAvAX6bJ7icWj4xzZ3XiljDUs0Np/
         Mp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bx/2C+HXBotIPqznZhQEX8s1vNGSCbDgiHrtAcPp7ks=;
        b=6R2rzYB6N5hQspjX3weZ53kO/Mh0G+p18pUaTE/DyPtqb7++uvKO3VxYuffTCkoUT6
         0NTLd79B2MpHJNhwk0yIy95iimCAdMlENwQJi9NftfhrZeqhKgGk36zw+k+1CeY2V3fe
         vVDijHBHe3lKJ5fT/2BpLu4pyDNY1HuzV6JjfpC/ksPUYVGNVhyggzdDgwdbUprmfrRf
         cBhU6Yfv7B/VUVrxiKFx4gufNumH9ZIQIydQyUWFFv8EMr5nXgTDDx7PEekibNVE8Ud5
         E0vAWOpHNyvC6ISVzftaDGOHjvFgsERwzOFzSgWVGcFAbH4Lgkq3adfArkieuugiBfJA
         87Rw==
X-Gm-Message-State: AOAM530UTTXBvSy4bgTkmSpKuhh00GduXqKFKXeR8CrC+nLk0OMSknIR
        C/4LCOXzF1tYxMGjyTM/N5ywflGRsgQ=
X-Google-Smtp-Source: ABdhPJwFazyWhbockLmljqCImO6SEjvWsq2N53AGWc8uUHlhLZc1fFuY56HxIfrjDtQFwHi8YUsYOg==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr14046853edc.222.1632910754458;
        Wed, 29 Sep 2021 03:19:14 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id y4sm1092881ejr.101.2021.09.29.03.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 03:19:14 -0700 (PDT)
Subject: Re: [PATCH net-next] net: mlx4: Add XDP_REDIRECT statistics
To:     Joshua Roys <roysjosh@gmail.com>, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        bpf@vger.kernel.org, tariqt@nvidia.com, linux-rdma@vger.kernel.org
References: <8d7773a0-054a-84d5-e0b6-66a13509149e@gmail.com>
 <20210928132602.1488-1-roysjosh@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <490d45ff-187a-8e20-7eeb-ce73cfa2e335@gmail.com>
Date:   Wed, 29 Sep 2021 13:19:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928132602.1488-1-roysjosh@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


For changes in the mlx4 ethernet driver, please use "net/mlx4_en" prefix 
in patch subject.

On 9/28/2021 4:26 PM, Joshua Roys wrote:
> Address feedback for XDP_REDIRECT patch.
> 

Description is not helpful at all.
Please provide technical description of the content, motivation, why it 
is needed, etc...

> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>   .../net/ethernet/mellanox/mlx4/en_ethtool.c    |  8 ++++++++
>   drivers/net/ethernet/mellanox/mlx4/en_port.c   | 18 +++++++++++-------
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c     |  4 +++-
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |  2 ++
>   .../net/ethernet/mellanox/mlx4/mlx4_stats.h    |  4 +++-
>   5 files changed, 27 insertions(+), 9 deletions(-)
> 
> Tested with VPP 21.06 on Fedora 34.
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> index ef518b1040f7..66c8ae29bc7a 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> @@ -197,6 +197,8 @@ static const char main_strings[][ETH_GSTRING_LEN] = {
>   
>   	/* xdp statistics */
>   	"rx_xdp_drop",
> +	"rx_xdp_redirect",
> +	"rx_xdp_redirect_fail",
>   	"rx_xdp_tx",
>   	"rx_xdp_tx_full",
>   
> @@ -428,6 +430,8 @@ static void mlx4_en_get_ethtool_stats(struct net_device *dev,
>   		data[index++] = priv->rx_ring[i]->bytes;
>   		data[index++] = priv->rx_ring[i]->dropped;
>   		data[index++] = priv->rx_ring[i]->xdp_drop;
> +		data[index++] = priv->rx_ring[i]->xdp_redirect;
> +		data[index++] = priv->rx_ring[i]->xdp_redirect_fail;
>   		data[index++] = priv->rx_ring[i]->xdp_tx;
>   		data[index++] = priv->rx_ring[i]->xdp_tx_full;
>   	}
> @@ -519,6 +523,10 @@ static void mlx4_en_get_strings(struct net_device *dev,
>   				"rx%d_dropped", i);
>   			sprintf(data + (index++) * ETH_GSTRING_LEN,
>   				"rx%d_xdp_drop", i);
> +			sprintf(data + (index++) * ETH_GSTRING_LEN,
> +				"rx%d_xdp_redirect", i);
> +			sprintf(data + (index++) * ETH_GSTRING_LEN,
> +				"rx%d_xdp_redirect_fail", i);
>   			sprintf(data + (index++) * ETH_GSTRING_LEN,
>   				"rx%d_xdp_tx", i);
>   			sprintf(data + (index++) * ETH_GSTRING_LEN,
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_port.c b/drivers/net/ethernet/mellanox/mlx4/en_port.c
> index 0158b88bea5b..043cc9d75b3e 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_port.c
> @@ -239,13 +239,15 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
>   
>   	mlx4_en_fold_software_stats(dev);
>   
> -	priv->port_stats.rx_chksum_good = 0;
> -	priv->port_stats.rx_chksum_none = 0;
> -	priv->port_stats.rx_chksum_complete = 0;
> -	priv->port_stats.rx_alloc_pages = 0;
> -	priv->xdp_stats.rx_xdp_drop    = 0;
> -	priv->xdp_stats.rx_xdp_tx      = 0;
> -	priv->xdp_stats.rx_xdp_tx_full = 0;
> +	priv->port_stats.rx_chksum_good      = 0;
> +	priv->port_stats.rx_chksum_none      = 0;
> +	priv->port_stats.rx_chksum_complete  = 0;
> +	priv->port_stats.rx_alloc_pages      = 0;
> +	priv->xdp_stats.rx_xdp_drop          = 0;
> +	priv->xdp_stats.rx_xdp_redirect      = 0;
> +	priv->xdp_stats.rx_xdp_redirect_fail = 0;
> +	priv->xdp_stats.rx_xdp_tx            = 0;
> +	priv->xdp_stats.rx_xdp_tx_full       = 0;

No need to touch existing lines.
Add yours without fixing the existing indintations.

>   	for (i = 0; i < priv->rx_ring_num; i++) {
>   		const struct mlx4_en_rx_ring *ring = priv->rx_ring[i];
>   
> @@ -255,6 +257,8 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
>   		priv->port_stats.rx_chksum_complete += READ_ONCE(ring->csum_complete);
>   		priv->port_stats.rx_alloc_pages += READ_ONCE(ring->rx_alloc_pages);
>   		priv->xdp_stats.rx_xdp_drop	+= READ_ONCE(ring->xdp_drop);
> +		priv->xdp_stats.rx_xdp_redirect += READ_ONCE(ring->xdp_redirect);
> +		priv->xdp_stats.rx_xdp_redirect_fail += READ_ONCE(ring->xdp_redirect_fail);
>   		priv->xdp_stats.rx_xdp_tx	+= READ_ONCE(ring->xdp_tx);
>   		priv->xdp_stats.rx_xdp_tx_full	+= READ_ONCE(ring->xdp_tx_full);
>   	}
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 557d7daac2d3..8f09b1de4125 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -793,11 +793,13 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   			case XDP_PASS:
>   				break;
>   			case XDP_REDIRECT:
> -				if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {
> +				if (!xdp_do_redirect(dev, &xdp, xdp_prog)) {

use likely()

> +					ring->xdp_redirect++;
>   					xdp_redir_flush = true;
>   					frags[0].page = NULL;
>   					goto next;
>   				}
> +				ring->xdp_redirect_fail++;
>   				trace_xdp_exception(dev, xdp_prog, act);
>   				goto xdp_drop_no_cnt;
>   			case XDP_TX:
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index f3d1a20201ef..f6c90e97b4cd 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -340,6 +340,8 @@ struct mlx4_en_rx_ring {
>   	unsigned long csum_complete;
>   	unsigned long rx_alloc_pages;
>   	unsigned long xdp_drop;
> +	unsigned long xdp_redirect;
> +	unsigned long xdp_redirect_fail;
>   	unsigned long xdp_tx;
>   	unsigned long xdp_tx_full;
>   	unsigned long dropped;
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
> index 7b51ae8cf759..e9cd4bb6f83d 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
> @@ -42,9 +42,11 @@ struct mlx4_en_port_stats {
>   
>   struct mlx4_en_xdp_stats {
>   	unsigned long rx_xdp_drop;
> +	unsigned long rx_xdp_redirect;
> +	unsigned long rx_xdp_redirect_fail;
>   	unsigned long rx_xdp_tx;
>   	unsigned long rx_xdp_tx_full;
> -#define NUM_XDP_STATS		3
> +#define NUM_XDP_STATS		5
>   };
>   
>   struct mlx4_en_phy_stats {
> 
