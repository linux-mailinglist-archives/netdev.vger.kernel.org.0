Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7271DED03
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgEVQNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgEVQNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 12:13:42 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DDBC061A0E;
        Fri, 22 May 2020 09:13:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p30so5181769pgl.11;
        Fri, 22 May 2020 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=inphvhrYaeLRa+Bv0qEoz3wy1P39esqf1NVanFuzchE=;
        b=THfQCNDuDi1AyNgQPCNIVoTLcP/s9cJqcqkLRMaBn1gy0CSbEFYU2glychWYzRTw7q
         wKFC462DVT39rV6RbercxCc10mjPxVVm5CvqJo+RZ6xHlJWr6u/e0Q18ASl+rE4mJ7Ws
         fPrgZd5glR0Bk/rn5GBu8yY83MEB2auGhOA4xt9cUTvg5cMq0miYg17iK1KkTH8EtBVo
         JucQF1sJKLpfWFby80JZkIvUEzq/DMwYVGOoTTGcUMdv3H5HczqKws/OYW2GLEfJqiGu
         GkzlM8aimrVrK8qJ5y+zecexL8K+/CZi9EYoTXs7S71CrgMxz6ynCtiqtJsMOtIv0lB0
         2XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inphvhrYaeLRa+Bv0qEoz3wy1P39esqf1NVanFuzchE=;
        b=g5jHIFgXcTIFO5BD0fCXvdkCguMzIVst6UBadmyJdpyJqOGr6LM7ZEPi6pBjHtFftN
         h/4oQKIMtyTfbdIiooOBHpG853Cmo/fbiXOICJnxgSbUTr/v2uXoIO4vWIt8GMw/+PKV
         bOyD72lprpMu3Z8p3Wqj4MoBzj1PFnoqmF7CJmtqJkaqhQTGocLkYZQD+sE35Shm6ckR
         +nwb7z83W/wupbotIplL8waN5niNLGZSrXvASVXhwrHhRo6LXpm+KpfJ0I1HjQ/KLpka
         +4RNfY8p5t4A7HbZ0ntC3clem9gvYwAS5DC6iiAWOf0aSKIcOHxm8z7EC084ZTawdbzs
         xICg==
X-Gm-Message-State: AOAM530gWNUUKwuFK8zoFA4mMb+z7vpxX21LqmZ6mDbIWRbOPkflRtIm
        jutVUnXay4z6T8tBGCQSJmxzIkYj
X-Google-Smtp-Source: ABdhPJwTcBbsXQRiuNeuUbOcAr6AYq3qMizGpgIsqL20+jgPo+SLYj8CrW6zAwdwmJ5J751zC5RKNw==
X-Received: by 2002:a63:f64d:: with SMTP id u13mr14109699pgj.151.1590164021901;
        Fri, 22 May 2020 09:13:41 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x6sm7658387pfn.90.2020.05.22.09.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 09:13:41 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-5-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
Date:   Fri, 22 May 2020 09:13:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522122534.3353-5-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2020 5:25 AM, Dan Murphy wrote:
> Add RGMII internal delay configuration for Rx and Tx.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83869.c | 101 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 101 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index cfb22a21a2e6..a9008d32e2b6 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -99,6 +99,14 @@
>  #define DP83869_OP_MODE_MII			BIT(5)
>  #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
>  
> +/* RGMIIDCTL bits */
> +#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
> +#define DP83869_RGMII_CLK_DELAY_INV		0
> +
> +static int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500, 1750,
> +				       2000, 2250, 2500, 2750, 3000, 3250,
> +				       3500, 3750, 4000};
> +
>  enum {
>  	DP83869_PORT_MIRRORING_KEEP,
>  	DP83869_PORT_MIRRORING_EN,
> @@ -108,6 +116,8 @@ enum {
>  struct dp83869_private {
>  	int tx_fifo_depth;
>  	int rx_fifo_depth;
> +	u32 rx_id_delay;
> +	u32 tx_id_delay;
>  	int io_impedance;
>  	int port_mirroring;
>  	bool rxctrl_strap_quirk;
> @@ -182,6 +192,7 @@ static int dp83869_of_init(struct phy_device *phydev)
>  	struct dp83869_private *dp83869 = phydev->priv;
>  	struct device *dev = &phydev->mdio.dev;
>  	struct device_node *of_node = dev->of_node;
> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
>  	int ret;
>  
>  	if (!of_node)
> @@ -232,6 +243,26 @@ static int dp83869_of_init(struct phy_device *phydev)
>  				 &dp83869->tx_fifo_depth))
>  		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>  
> +	dp83869->rx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
> +	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
> +				   &dp83869->rx_id_delay);
> +	if (!ret && dp83869->rx_id_delay > dp83869_internal_delay[delay_size]) {
> +		phydev_err(phydev,
> +			   "rx-internal-delay value of %u out of range\n",
> +			   dp83869->rx_id_delay);
> +		return -EINVAL;
> +	}
> +
> +	dp83869->tx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
> +				   &dp83869->tx_id_delay);
> +	if (!ret && dp83869->tx_id_delay > dp83869_internal_delay[delay_size]) {
> +		phydev_err(phydev,
> +			   "tx-internal-delay value of %u out of range\n",
> +			   dp83869->tx_id_delay);
> +		return -EINVAL;
> +	}

This is the kind of validation that I would be expecting from the PHY
library to do, in fact, since you use Device Tree standard property, I
would expect you only need to pass the maximum delay value and some
storage for your array of delays.

> +
>  	return ret;
>  }
>  #else
> @@ -270,6 +301,29 @@ static int dp83869_configure_rgmii(struct phy_device *phydev,
>  	return ret;
>  }
>  
> +static int dp83869_verify_rgmii_cfg(struct phy_device *phydev)
> +{
> +	struct dp83869_private *dp83869 = phydev->priv;
> +
> +	/* RX delay *must* be specified if internal delay of RX is used. */
> +	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	     phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) &&
> +	     dp83869->rx_id_delay == DP83869_RGMII_CLK_DELAY_INV) {
> +		phydev_err(phydev, "ti,rx-internal-delay must be specified\n");
> +		return -EINVAL;
> +	}
> +
> +	/* TX delay *must* be specified if internal delay of TX is used. */
> +	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	     phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) &&
> +	     dp83869->tx_id_delay == DP83869_RGMII_CLK_DELAY_INV) {
> +		phydev_err(phydev, "ti,tx-internal-delay must be specified\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int dp83869_configure_mode(struct phy_device *phydev,
>  				  struct dp83869_private *dp83869)
>  {
> @@ -371,6 +425,12 @@ static int dp83869_config_init(struct phy_device *phydev)
>  {
>  	struct dp83869_private *dp83869 = phydev->priv;
>  	int ret, val;
> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
> +	int delay = 0;
> +
> +	ret = dp83869_verify_rgmii_cfg(phydev);
> +	if (ret)
> +		return ret;
>  
>  	ret = dp83869_configure_mode(phydev, dp83869);
>  	if (ret)
> @@ -394,6 +454,47 @@ static int dp83869_config_init(struct phy_device *phydev)
>  				     dp83869->clk_output_sel <<
>  				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
>  
> +	if (phy_interface_is_rgmii(phydev)) {
> +		val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL);
> +
> +		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN | DP83869_RGMII_RX_CLK_DELAY_EN);
> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> +			val |= (DP83869_RGMII_TX_CLK_DELAY_EN | DP83869_RGMII_RX_CLK_DELAY_EN);
> +
> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +			val |= DP83869_RGMII_TX_CLK_DELAY_EN;
> +
> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +			val |= DP83869_RGMII_RX_CLK_DELAY_EN;
> +
> +		phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL, val);
> +
> +		if (dp83869->rx_id_delay) {
> +			val = phy_get_delay_index(phydev,
> +						  &dp83869_internal_delay[0],
> +						  delay_size,
> +						  dp83869->rx_id_delay);
> +			if (val < 0)
> +				return val;
> +
> +			delay |= val;

Don't you need to do a bitwise AND with the maximum delay value
supported by the range since you do a Read/Modify/Write operation here?

> +		}
> +
> +		if (dp83869->tx_id_delay) {
> +			val = phy_get_delay_index(phydev,
> +						  &dp83869_internal_delay[0],
> +						  delay_size,
> +						  dp83869->tx_id_delay);
> +			if (val < 0)
> +				return val;
> +
> +			delay |= val << DP83869_RGMII_TX_CLK_DELAY_SHIFT;

Likewise.

> +		}
> +
> +		phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIIDCTL,
> +			      delay);
> +	}
> +
>  	return ret;
>  }
>  
> 

-- 
Florian
