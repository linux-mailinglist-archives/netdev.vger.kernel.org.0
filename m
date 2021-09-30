Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73441D468
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348634AbhI3HVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348542AbhI3HVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:21:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C4C06161C;
        Thu, 30 Sep 2021 00:19:27 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dn26so18271174edb.13;
        Thu, 30 Sep 2021 00:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IGscHQDcj5f5OOq0t4VfEFHBd8tbIZ0eSx7ZGXQG3Tg=;
        b=h1r5QZFqMVmtW+uMlhNFVGScty/qAjRdRpVWxepldiXF0s6V5tTtWherlTzWJ9gq1P
         w4R7IaXhtm1UcF8AZirl465whGzjrU95KzqItrN6Vtp7PNcIzK2KDsGhzXQ+jPfi1WMW
         SwgcNCNoacdN8BpOlxaGDIykzUUDJmVje+4TYpfGP8KgpvCYYSjaTeYciYf2+hqawUPv
         2Yb4IHjRxZ6IRGeOG9vMkV7rzv04qe2IA+mb1W0zSA1RDTp/mr82gALN/9rdxzmXjuGl
         6jv1VJvERVWVPNx7b8AemetJuFEwejqzdw0dZsYxFx/JYKTUtoRqvLbkebBRQ9fNNbVq
         mGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IGscHQDcj5f5OOq0t4VfEFHBd8tbIZ0eSx7ZGXQG3Tg=;
        b=CT8rJC+wEVhiQOep9UfkabkaII4MhpQD2SC/FqPfEqFhkPWdMYbWFHr8k65SJ0Z25C
         jPG7W8NEcmIOYs4mkxRb/LTCA20dC6n8koikD9CaQ/Rrs569mNr6WHFyXxq/pYlCxMXs
         07YHQq7/vtG3M+0XuI6RZ/y4HKPRwZ2uE+H4ykHChWKk77rpOaviiRQclm1ShhznJslM
         cC7z84/m2aB1cR4jJsOEHK3DybewUj+3D7wS/AfJY+k91rYziIZyf8eAXFoqMRNN+WOU
         viOf2wEUZ1G4L3lFLnTDq/DhbXrMGsVJin5QiGktizSuwT8zCR+PjvjwfTUsQoPMtwzt
         5lng==
X-Gm-Message-State: AOAM530cZ8pvokunSnLW4qtCfDK+dmWKSIgCEcoZxW7QB7ngLBw+81Us
        6toXcaNRssfhaua1iI1K7ofBCeM7zJc=
X-Google-Smtp-Source: ABdhPJzJL9OJCMu5yyFUH4lpB5G6TBjolavM2FH4JVZ+L05rleHdoX5TNoOT6GWfUt83XoIZ4My9eA==
X-Received: by 2002:a17:906:9485:: with SMTP id t5mr5201749ejx.66.1632986365259;
        Thu, 30 Sep 2021 00:19:25 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id n23sm991273edw.75.2021.09.30.00.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:19:24 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net/mlx4_en: Add XDP_REDIRECT statistics
To:     Joshua Roys <roysjosh@gmail.com>, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        bpf@vger.kernel.org, tariqt@nvidia.com, linux-rdma@vger.kernel.org
References: <20210928132602.1488-1-roysjosh@gmail.com>
 <20210930023023.245528-1-roysjosh@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <7e72f6d7-f770-c19e-f634-0e4fbed569b4@gmail.com>
Date:   Thu, 30 Sep 2021 10:19:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930023023.245528-1-roysjosh@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2021 5:30 AM, Joshua Roys wrote:
> Add counters for XDP REDIRECT success and failure. This brings the
> redirect path in line with metrics gathered via the other XDP paths.
> 
> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 8 ++++++++
>   drivers/net/ethernet/mellanox/mlx4/en_port.c    | 4 ++++
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c      | 4 +++-
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h    | 2 ++
>   drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h | 4 +++-
>   5 files changed, 20 insertions(+), 2 deletions(-)
> 
> Sorry, this version fixes the full/fail typo.
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
> index 0158b88bea5b..f25794a92241 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_port.c
> @@ -244,6 +244,8 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
>   	priv->port_stats.rx_chksum_complete = 0;
>   	priv->port_stats.rx_alloc_pages = 0;
>   	priv->xdp_stats.rx_xdp_drop    = 0;
> +	priv->xdp_stats.rx_xdp_redirect = 0;
> +	priv->xdp_stats.rx_xdp_redirect_fail = 0;
>   	priv->xdp_stats.rx_xdp_tx      = 0;
>   	priv->xdp_stats.rx_xdp_tx_full = 0;
>   	for (i = 0; i < priv->rx_ring_num; i++) {
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
> index 557d7daac2d3..650e6a1844ae 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -793,11 +793,13 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   			case XDP_PASS:
>   				break;
>   			case XDP_REDIRECT:
> -				if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {
> +				if (likely(!xdp_do_redirect(dev, &xdp, xdp_prog))) {
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

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
