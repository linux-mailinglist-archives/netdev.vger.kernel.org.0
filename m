Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD303483E56
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbiADImY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiADImY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:42:24 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B639C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 00:42:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o3so16420892wrh.10
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=barqnjH3p7fRKT0tLe0JVFPAeiGFjop5m8QS0KnEoeg=;
        b=1AxwPuYFc4Sam8ETMwAlTVU3EtGwflcPbf7StDTivbydGIbH4r3b3msG5YYo8jtZVC
         oXyyKVBq9rZjjnSzyoI+nJNpAtJQ9jvAZj3Xkd2GNE5mexKfYP9q2FhTR1dRHbrsgTJH
         pTIAAwCpYWLMkR7VRxr3hSVpoovjiyiz2kQUnDwHCIzcpOG4hq0Y25f4UiMmqanLYTNR
         HaLOGPp//ja8tax9EnjWy8pUQ6Jj1KE6NDFM8lgGniUJ+qvZdNLdg5eUnxRkxB22FHwG
         5nxRIJjkIJAFwSUAov73Jdc8qQCkBbpfoBDrSzyYUX28YDYhiuOUeqOjPWuSxvpm37d2
         XELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=barqnjH3p7fRKT0tLe0JVFPAeiGFjop5m8QS0KnEoeg=;
        b=tDXkyfDsnRLRFR7ldnfpwgIq2ywYIK+2K7X7eNxvbiYATwnYPoOpD9ixtpHNET/aym
         OgsoDNM0BnDOmWvAR7/g1Wp3Boigugd58asi8aSANEhKqB2qLGwPVCd6wqgpGlURiJdJ
         FCd6FVAM2qyQY1moPfOMFZQEsUmwZspkbLn51parN+atNIgqI/rf0NT7jCUIeiV/Ttcb
         T2W+c1kSu7LMip6/hpyJ/uGnZruNJ+SJyN4WPWRVPNHSAyao5kQuIjJ40wQp9/mhB/GM
         hr2YvBoIQswDMyi3mv0/u1XLoTlIh7Vv6A5tBC9m2xe7ZGvEWblRnXEVDeIZwIgnCHnP
         s6aw==
X-Gm-Message-State: AOAM532aQKsg5kojFzPnc2U3Tp9q4CN5SbovFJG8hOxiFvvrGk+LU3dY
        uwcDiMSmL6zyoxGQURmRiJ4Z/w==
X-Google-Smtp-Source: ABdhPJz+klqyzLgB8Ih+zYN1plyHR9OQ5WQs4Sk3Da4D+c9ZDZbfpGhv3+zj/sjyuElh2AEzzQzS/Q==
X-Received: by 2002:a5d:4568:: with SMTP id a8mr42639622wrc.471.1641285742516;
        Tue, 04 Jan 2022 00:42:22 -0800 (PST)
Received: from ?IPv6:2001:861:44c0:66c0:f6da:6ac:481:1df0? ([2001:861:44c0:66c0:f6da:6ac:481:1df0])
        by smtp.gmail.com with ESMTPSA id n8sm39740782wri.47.2022.01.04.00.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 00:42:22 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] net: stmmac: dwmac-oxnas: Add support for
 OX810SE
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-oxnas@groups.io, linux-kernel@vger.kernel.org
References: <20220103175638.89625-1-narmstrong@baylibre.com>
 <20220103175638.89625-3-narmstrong@baylibre.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
Message-ID: <4a0ea0f1-9cc5-a242-75af-ed4bd0537b16@baylibre.com>
Date:   Tue, 4 Jan 2022 09:42:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103175638.89625-3-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/01/2022 18:56, Neil Armstrong wrote:
> Add support for OX810SE dwmac glue setup, which is a simplified version
> of the OX820 introduced later with more control on the PHY interface.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c | 92 ++++++++++++++-----
>  1 file changed, 70 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
> index adfeb8d3293d..7ffa4a4eb30f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
> @@ -12,6 +12,7 @@
>  #include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/syscon.h>
> @@ -48,12 +49,58 @@
>  #define DWMAC_RX_VARDELAY(d)		((d) << DWMAC_RX_VARDELAY_SHIFT)
>  #define DWMAC_RXN_VARDELAY(d)		((d) << DWMAC_RXN_VARDELAY_SHIFT)
>  
> +struct oxnas_dwmac;
> +
> +struct oxnas_dwmac_data {
> +	void (*setup)(struct oxnas_dwmac *dwmac);
> +};
> +
>  struct oxnas_dwmac {
>  	struct device	*dev;
>  	struct clk	*clk;
>  	struct regmap	*regmap;
> +	const struct oxnas_dwmac_data	*data;
>  };
>  
> +static void oxnas_dwmac_setup_ox810se(struct oxnas_dwmac *dwmac)
> +{
> +	unsigned int value;
> +
> +	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
> +	value = BIT(DWMAC_CKEN_GTX)		|
> +		 /* Use simple mux for 25/125 Mhz clock switching */
> +		 BIT(DWMAC_SIMPLE_MUX);
> +
> +	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
> +}
> +
> +static void oxnas_dwmac_setup_ox820(struct oxnas_dwmac *dwmac)
> +{
> +	unsigned int value;
> +
> +	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
> +	value = BIT(DWMAC_CKEN_GTX)		|
> +		 /* Use simple mux for 25/125 Mhz clock switching */
> +		BIT(DWMAC_SIMPLE_MUX)		|
> +		/* set auto switch tx clock source */
> +		BIT(DWMAC_AUTO_TX_SOURCE)	|
> +		/* enable tx & rx vardelay */
> +		BIT(DWMAC_CKEN_TX_OUT)		|
> +		BIT(DWMAC_CKEN_TXN_OUT)	|
> +		BIT(DWMAC_CKEN_TX_IN)		|
> +		BIT(DWMAC_CKEN_RX_OUT)		|
> +		BIT(DWMAC_CKEN_RXN_OUT)	|
> +		BIT(DWMAC_CKEN_RX_IN);
> +	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
> +
> +	/* set tx & rx vardelay */
> +	value = DWMAC_TX_VARDELAY(4)	|
> +		DWMAC_TXN_VARDELAY(2)	|
> +		DWMAC_RX_VARDELAY(10)	|
> +		DWMAC_RXN_VARDELAY(8);
> +	regmap_write(dwmac->regmap, OXNAS_DWMAC_DELAY_REGOFFSET, value);
> +}
> +
>  static int oxnas_dwmac_init(struct platform_device *pdev, void *priv)
>  {
>  	struct oxnas_dwmac *dwmac = priv;
> @@ -75,27 +122,7 @@ static int oxnas_dwmac_init(struct platform_device *pdev, void *priv)
>  		return ret;
>  	}

There's an issue with the patch, the value read from register is not used, I'll send a V2 with the fix.

Neil

>  
> -	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
> -	value |= BIT(DWMAC_CKEN_GTX)		|
> -		 /* Use simple mux for 25/125 Mhz clock switching */
> -		 BIT(DWMAC_SIMPLE_MUX)		|
> -		 /* set auto switch tx clock source */
> -		 BIT(DWMAC_AUTO_TX_SOURCE)	|
> -		 /* enable tx & rx vardelay */
> -		 BIT(DWMAC_CKEN_TX_OUT)		|
> -		 BIT(DWMAC_CKEN_TXN_OUT)	|
> -		 BIT(DWMAC_CKEN_TX_IN)		|
> -		 BIT(DWMAC_CKEN_RX_OUT)		|
> -		 BIT(DWMAC_CKEN_RXN_OUT)	|
> -		 BIT(DWMAC_CKEN_RX_IN);
> -	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
> -
> -	/* set tx & rx vardelay */
> -	value = DWMAC_TX_VARDELAY(4)	|
> -		DWMAC_TXN_VARDELAY(2)	|
> -		DWMAC_RX_VARDELAY(10)	|
> -		DWMAC_RXN_VARDELAY(8);
> -	regmap_write(dwmac->regmap, OXNAS_DWMAC_DELAY_REGOFFSET, value);
> +	dwmac->data->setup(dwmac);
>  
>  	return 0;
>  }
> @@ -128,6 +155,12 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
>  		goto err_remove_config_dt;
>  	}
>  
> +	dwmac->data = (const struct oxnas_dwmac_data *)of_device_get_match_data(&pdev->dev);
> +	if (!dwmac->data) {
> +		ret = -EINVAL;
> +		goto err_remove_config_dt;
> +	}
> +
>  	dwmac->dev = &pdev->dev;
>  	plat_dat->bsp_priv = dwmac;
>  	plat_dat->init = oxnas_dwmac_init;
> @@ -166,8 +199,23 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> +static const struct oxnas_dwmac_data ox810se_dwmac_data = {
> +	.setup = oxnas_dwmac_setup_ox810se,
> +};
> +
> +static const struct oxnas_dwmac_data ox820_dwmac_data = {
> +	.setup = oxnas_dwmac_setup_ox820,
> +};
> +
>  static const struct of_device_id oxnas_dwmac_match[] = {
> -	{ .compatible = "oxsemi,ox820-dwmac" },
> +	{
> +		.compatible = "oxsemi,ox810se-dwmac",
> +		.data = &ox810se_dwmac_data,
> +	},
> +	{
> +		.compatible = "oxsemi,ox820-dwmac",
> +		.data = &ox820_dwmac_data,
> +	},
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, oxnas_dwmac_match);
> 

