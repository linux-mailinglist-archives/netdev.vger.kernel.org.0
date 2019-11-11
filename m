Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85EFDF73AB
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKMPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:15:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39167 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKMPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:15:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id l7so2796942wrp.6
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RywKg2HyU5tFAgIwxGJ6/yn+kCsdUfA2jKToN6kGyz0=;
        b=DfsXjWi+IzBFkGWQImFRDXJmeGf0kAidskGsfGvbfp7B2LTxPXEuQ6bXrLZeLRXmPW
         nbfwf/CxL+Cu1mzftYeCWRYptCD0Ycpgn/Dry+2CNDoBu4u3RRTOG5LTvdbhIR/bagCi
         VMnbtHqCfjW/ip6MjQg4rncs7d3epqA02QQXwDPRKY9N/SucJDR1tjvDOZsnJjSGf4GX
         5Wvqgnh1fuEzVBL8TlP1ITe1K9JlQ+Jb1ifrQhB6oFeFIfa2bmEXSOJZN7GOfe2OQ7iU
         Bp4if+wzB9VUi6B2LIvj6r3QVl+/iUGQ3nvjrfPHMMhWGjD0ysulB/lXYlYaNs8H/Smy
         /zyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RywKg2HyU5tFAgIwxGJ6/yn+kCsdUfA2jKToN6kGyz0=;
        b=jGpS8s3WziYNgzNeekPpjI6Y5Xwc3LvfCti61loLwxRIPet79O+dSVMUNhFXiLEm6n
         8q9wZNhoyReCQatytSpP+pSdxbK3Qd8pzDtqI02Q5uZ6zz/ST3XOeu4DqOD4klxRCkCN
         OyJI8KPYwDRy3aV+yIJKNiOkGEmtvSyFAF3AlQ8fMwuyH8TIt6uX5cBZ9UMTmMnUyDuK
         9y2vUwXPv3EntKTw+irshjRXT0Mq7IaF+VyPpCbqWh+4pKfPlMAXfWABXqSscZatCIgQ
         RxjLpyLau7s/Z5UYl+EQnirJDrZgV/lzO7f4SxILSzoS96CwuiYRKf7RmlRD6ZbIpyoH
         YVGQ==
X-Gm-Message-State: APjAAAW82UkVMsjMy3b8qIt3vAeweqwl/s3f2TrX4oPWZWOEr2M9VVqw
        7R/jjvMURQjk6bMTsy21r7A=
X-Google-Smtp-Source: APXvYqyVAdd6p3sc/BVUx1wPB4LHhHPvZ3JM4GV9dyueqPh4hf4iAwQXbPAnUZNNFHEwIvAFndRqmQ==
X-Received: by 2002:a5d:4ad2:: with SMTP id y18mr20133024wrs.396.1573474513504;
        Mon, 11 Nov 2019 04:15:13 -0800 (PST)
Received: from ziggy.stardust ([95.169.226.39])
        by smtp.gmail.com with ESMTPSA id b196sm21189720wmd.24.2019.11.11.04.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 04:15:12 -0800 (PST)
Subject: Re: [PATCH V4 net-next 4/7] net: bcmgenet: Add BCM2711 support
To:     Stefan Wahren <wahrenst@gmx.net>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
References: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
 <1573455341-22813-5-git-send-email-wahrenst@gmx.net>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Autocrypt: addr=matthias.bgg@gmail.com; prefer-encrypt=mutual; keydata=
 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
 r2JwH1CJjrHWeQEI2ucSKsNa8FllDmG/fQ==
Message-ID: <ba7c387e-54f0-589a-ccdc-11867a45c978@gmail.com>
Date:   Mon, 11 Nov 2019 13:15:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1573455341-22813-5-git-send-email-wahrenst@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2019 07:55, Stefan Wahren wrote:
> The BCM2711 needs a different maximum DMA burst length. If not set
> accordingly a timeout in the transmit queue happens and no package
> can be sent. So use the new compatible to derive this value.
> 
> Until now the GENET HW version was used as the platform identifier.
> This doesn't work with SoC-specific modifications, so introduce a proper
> platform data structure.
> 
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Matthias Brugger <mbrugger@suse.com>

> =2D--
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 63 +++++++++++++++++++++=
> +----
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h |  1 +
>  2 files changed, 54 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
> ethernet/broadcom/genet/bcmgenet.c
> index ee4d8ef..120fa05 100644
> =2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -2576,7 +2576,8 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *p=
> riv)
>  	}
> 
>  	/* Init rDma */
> -	bcmgenet_rdma_writel(priv, DMA_MAX_BURST_LENGTH, DMA_SCB_BURST_SIZE);
> +	bcmgenet_rdma_writel(priv, priv->dma_max_burst_length,
> +			     DMA_SCB_BURST_SIZE);
> 
>  	/* Initialize Rx queues */
>  	ret =3D bcmgenet_init_rx_queues(priv->dev);
> @@ -2589,7 +2590,8 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *p=
> riv)
>  	}
> 
>  	/* Init tDma */
> -	bcmgenet_tdma_writel(priv, DMA_MAX_BURST_LENGTH, DMA_SCB_BURST_SIZE);
> +	bcmgenet_tdma_writel(priv, priv->dma_max_burst_length,
> +			     DMA_SCB_BURST_SIZE);
> 
>  	/* Initialize Tx queues */
>  	bcmgenet_init_tx_queues(priv->dev);
> @@ -3420,12 +3422,48 @@ static void bcmgenet_set_hw_params(struct bcmgenet=
> _priv *priv)
>  		params->words_per_bd);
>  }
> 
> +struct bcmgenet_plat_data {
> +	enum bcmgenet_version version;
> +	u32 dma_max_burst_length;
> +};
> +
> +static const struct bcmgenet_plat_data v1_plat_data =3D {
> +	.version =3D GENET_V1,
> +	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
> +};
> +
> +static const struct bcmgenet_plat_data v2_plat_data =3D {
> +	.version =3D GENET_V2,
> +	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
> +};
> +
> +static const struct bcmgenet_plat_data v3_plat_data =3D {
> +	.version =3D GENET_V3,
> +	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
> +};
> +
> +static const struct bcmgenet_plat_data v4_plat_data =3D {
> +	.version =3D GENET_V4,
> +	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
> +};
> +
> +static const struct bcmgenet_plat_data v5_plat_data =3D {
> +	.version =3D GENET_V5,
> +	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
> +};
> +
> +static const struct bcmgenet_plat_data bcm2711_plat_data =3D {
> +	.version =3D GENET_V5,
> +	.dma_max_burst_length =3D 0x08,
> +};
> +
>  static const struct of_device_id bcmgenet_match[] =3D {
> -	{ .compatible =3D "brcm,genet-v1", .data =3D (void *)GENET_V1 },
> -	{ .compatible =3D "brcm,genet-v2", .data =3D (void *)GENET_V2 },
> -	{ .compatible =3D "brcm,genet-v3", .data =3D (void *)GENET_V3 },
> -	{ .compatible =3D "brcm,genet-v4", .data =3D (void *)GENET_V4 },
> -	{ .compatible =3D "brcm,genet-v5", .data =3D (void *)GENET_V5 },
> +	{ .compatible =3D "brcm,genet-v1", .data =3D &v1_plat_data },
> +	{ .compatible =3D "brcm,genet-v2", .data =3D &v2_plat_data },
> +	{ .compatible =3D "brcm,genet-v3", .data =3D &v3_plat_data },
> +	{ .compatible =3D "brcm,genet-v4", .data =3D &v4_plat_data },
> +	{ .compatible =3D "brcm,genet-v5", .data =3D &v5_plat_data },
> +	{ .compatible =3D "brcm,bcm2711-genet-v5", .data =3D &bcm2711_plat_data =
> },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, bcmgenet_match);
> @@ -3435,6 +3473,7 @@ static int bcmgenet_probe(struct platform_device *pd=
> ev)
>  	struct bcmgenet_platform_data *pd =3D pdev->dev.platform_data;
>  	struct device_node *dn =3D pdev->dev.of_node;
>  	const struct of_device_id *of_id =3D NULL;
> +	const struct bcmgenet_plat_data *pdata;
>  	struct bcmgenet_priv *priv;
>  	struct net_device *dev;
>  	const void *macaddr;
> @@ -3516,10 +3555,14 @@ static int bcmgenet_probe(struct platform_device *=
> pdev)
> 
>  	priv->dev =3D dev;
>  	priv->pdev =3D pdev;
> -	if (of_id)
> -		priv->version =3D (enum bcmgenet_version)of_id->data;
> -	else
> +	if (of_id) {
> +		pdata =3D of_id->data;
> +		priv->version =3D pdata->version;
> +		priv->dma_max_burst_length =3D pdata->dma_max_burst_length;
> +	} else {
>  		priv->version =3D pd->genet_version;
> +		priv->dma_max_burst_length =3D DMA_MAX_BURST_LENGTH;
> +	}
> 
>  	priv->clk =3D devm_clk_get(&priv->pdev->dev, "enet");
>  	if (IS_ERR(priv->clk)) {
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/=
> ethernet/broadcom/genet/bcmgenet.h
> index dbc69d8..a565919 100644
> =2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> @@ -664,6 +664,7 @@ struct bcmgenet_priv {
>  	bool crc_fwd_en;
> 
>  	unsigned int dma_rx_chk_bit;
> +	u32 dma_max_burst_length;
> 
>  	u32 msg_enable;
> 
> =2D-
> 2.7.4
> 
