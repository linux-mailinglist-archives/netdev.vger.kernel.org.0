Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C45257ED0
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgHaQc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbgHaQc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:32:28 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF18C061573;
        Mon, 31 Aug 2020 09:32:28 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so75220pjb.1;
        Mon, 31 Aug 2020 09:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GO84KFDjzKqZnM+oXBshZ6ykzfpiT7fbcx/i6Jrj8yQ=;
        b=NknzGhjeF6rOldcWqvBMLiTO+zE9jpbabe0R1T6YL5HaD79HiY7mbiGSahDDYSPgKr
         95WBuDvL6bdBHlBSkOIwHmjU4LqKaFsmlPRiifpkA1jLc5Kw27HPUtO5k47xjb6r9U1Y
         XFdwJIzeyJq3iDybIQfLiCVpur2M8pOxwDJXwkEACM3qeZXHmeowLGmF/522RwTmjvzJ
         gf30Cpl+tWzK7rX1XiS5DPu8aDhYh8aoiFLQbWNJYKU/8PZff1+Z8asOTDLoeSTaMwSG
         V9PSTYY1SxL9Tvj5kt2Hw3QSeiATy3c4FKF4uGGvqD19kqmJCxbbqyTunoCC6H71v9ec
         s5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GO84KFDjzKqZnM+oXBshZ6ykzfpiT7fbcx/i6Jrj8yQ=;
        b=q9qNSSSLyFiSSMrAezLWoPAdZJLUvb2LVC7rhONKwEjXXoI6wyBbIJ4SiOGEyeR+ix
         AbAUrQwmZPXr1IrJrEi+KhLgw+OlITP63PIMcMkD4TstPFqDrrogCgZCCsyokIcyr4pB
         5rl+YecTT4/BwpYpBhUi1Oo3a5TB+k2gm4DpW8wxamKnUUAq5G+E3FZ6Qb3oLrhFp6JJ
         OgjEzUmrzOLU864ypCBQPArPrBaA9t8upu3DHDdh6cvilofXh5SKgaN4vrSUghbssPxf
         i9w5Y3e+CLSIq20RV8Hf9FtN4fXB6RV0cd8lSKL3u1G/Oz50b6I1UmpXOujCoGQH2ZBc
         uxnA==
X-Gm-Message-State: AOAM533Yyo/HACc5O61qUm5uUb9uu9/IGk0oEXPs6123LJ0KO/SCXkY5
        Hmy5EZ1u57HL5UaFzhcZv/E=
X-Google-Smtp-Source: ABdhPJyJ0tw9GFzG+/xcdED+T/Wd2PDmFe9GtcOniuNQpFiY059kUrrFefyYGmnAo8fvsy418tfPaQ==
X-Received: by 2002:a17:90b:1194:: with SMTP id gk20mr207939pjb.54.1598891547511;
        Mon, 31 Aug 2020 09:32:27 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g4sm84838pjh.32.2020.08.31.09.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 09:32:26 -0700 (PDT)
Subject: Re: [PATCH 4/5] net: phy: smsc: add phy refclk in support
To:     Marco Felsch <m.felsch@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-5-m.felsch@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2993e0ed-ebe9-fd85-4650-7e53c15cfe34@gmail.com>
Date:   Mon, 31 Aug 2020 09:32:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200831134836.20189-5-m.felsch@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2020 6:48 AM, Marco Felsch wrote:
> Add support to specify the clock provider for the phy refclk and don't
> rely on 'magic' host clock setup. [1] tried to address this by
> introducing a flag and fixing the corresponding host. But this commit
> breaks the IRQ support since the irq setup during .config_intr() is
> thrown away because the reset comes from the side without respecting the
> current phy-state within the phy-state-machine. Furthermore the commit
> fixed the problem only for FEC based hosts other hosts acting like the
> FEC are not covered.
> 
> This commit goes the other way around to address the bug fixed by [1].
> Instead of resetting the device from the side every time the refclk gets
> (re-)enabled it requests and enables the clock till the device gets
> removed. The phy is still rest but now within the phylib and  with
> respect to the phy-state-machine.
> 
> [1] commit 7f64e5b18ebb ("net: phy: smsc: LAN8710/20: add
>      PHY_RST_AFTER_CLK_EN flag")
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>   drivers/net/phy/smsc.c | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 79574fcbd880..b98a7845681f 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -12,6 +12,7 @@
>    *
>    */
>   
> +#include <linux/clk.h>
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/mii.h>
> @@ -33,6 +34,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
>   
>   struct smsc_phy_priv {
>   	bool energy_enable;
> +	struct clk *refclk;
>   };
>   
>   static int smsc_phy_config_intr(struct phy_device *phydev)
> @@ -194,11 +196,19 @@ static void smsc_get_stats(struct phy_device *phydev,
>   		data[i] = smsc_get_stat(phydev, i);
>   }
>   
> +static void smsc_clk_disable_action(void *data)
> +{
> +	struct smsc_phy_priv *priv = data;
> +
> +	clk_disable_unprepare(priv->refclk);
> +}
> +
>   static int smsc_phy_probe(struct phy_device *phydev)
>   {
>   	struct device *dev = &phydev->mdio.dev;
>   	struct device_node *of_node = dev->of_node;
>   	struct smsc_phy_priv *priv;
> +	int ret;
>   
>   	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>   	if (!priv)
> @@ -211,6 +221,26 @@ static int smsc_phy_probe(struct phy_device *phydev)
>   
>   	phydev->priv = priv;
>   
> +	priv->refclk = devm_clk_get_optional(dev, NULL);
> +	if (IS_ERR(priv->refclk)) {
> +		if (PTR_ERR(priv->refclk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		/* Clocks are optional all errors should be ignored here */
> +		return 0;
> +	}
> +
> +	/* Starting from here errors should not be ignored anymore */
> +	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
> +	if (ret)
> +		return ret;

The clock should be enabled first before attempting a rate change, and 
this also causes a more fundamental question: what is the sate of the 
clock when the PHY driver is probed, and is the reference clock feeding 
into the MDIO logic of the PHY.

By that I mean that if the reference clock was disabled, would the PHY 
still respond to MDIO reads such that you would be able to probe and 
identify it?

If not, your demv_clk_get_optional() is either too late, or assuming a 
prior state, or you are working around this in Device Tree by using a 
compatible string with the form 
"^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$" in which case, this is a 
making assumptions about how the OF MDIO layer works which is not ideal.

I am preparing some patches that aim at enabling a given MDIO device's 
clock prior to probing it and should be able to post them by today.

> +
> +	ret = clk_prepare_enable(priv->refclk);
> +	if (ret)
> +		return ret;
> +
> +	devm_add_action_or_reset(dev, smsc_clk_disable_action, priv);
> +
>   	return 0;
>   }
>   
> 

-- 
Florian
