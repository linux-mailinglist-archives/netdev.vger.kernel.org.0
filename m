Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1F15ED7B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGCU2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:28:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33334 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfGCU2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:28:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so4252947wru.0;
        Wed, 03 Jul 2019 13:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4RuuSF1aVRZQhu/zSR3wfaiY2yCCsY50QgpIhgnfugE=;
        b=ClFSxBUaA1th2NV8PZ4dEtzi3ROWRhZHoClA40CViFyXMWg6/dbYnCTZglTY7LyDcz
         5IFQLgJjvTwJID+fRDPjciGvp9XaJarOKyN/p3V/+AkfEMObTqV6XUDo8EVIjzGMTyg1
         v/N7S9PSQgqPKUfPNFwT29abfX7jGrdPCaWLvGkxwodlfjpRYwBePmG9qnn59DNsx9Hr
         mcTH3mTP6z5tY+POxIJ9cPGnFWaLKZGCQ8sJFH7mlmYzKstTTuWcHWCKxKpyfdPcFQOe
         Iux379RRzNX5PwZZnrCyL58axAqSvuE9Rj/FotzAxVT/FPS5ZMKNuJ8IIxeaj/5UJeeJ
         jjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4RuuSF1aVRZQhu/zSR3wfaiY2yCCsY50QgpIhgnfugE=;
        b=PgvGTHmi8jXpk4fcXEGUSfV5oJQjMaKUS7YYHY2aJPKRQEFpJSmLMLoOgb0EQZ7Ku/
         4vNWyXzgSUlMilnrRNMbRYGv0X9i1ZT2Y9j03QErvxlIB9dWAS2mofldAjb1u1D0ck4h
         0Vg7TAni2nEADmqq7PPone0/IftNNf2M14YHk6yToNIQiq3uCrto+KbjaRaIQUMY9/WH
         rn7cAungOEfO7o+nMePA8ohrObOY8/4nFlDmayUXXDgE4AMkCV1KIRcPkn8xVd7tCNKt
         2sYocDXNOTtJ+BqFfuTI/Bh9kVIhFf3HBEkpNfrgJACxH4WjX1y/9VIdNF5xDVat+fgd
         i2dg==
X-Gm-Message-State: APjAAAV5E5wqVOpxOumfAKXD2kRmlBYdz1S19gbIxN5Tk/4qPLo0gbHJ
        9a7wFGEz0QLD+boAqXYCiK0=
X-Google-Smtp-Source: APXvYqzqp3wkKlJW4bqh5QXHBGeOwR1GBjCj3aoil1HE/EWzT3oA8Hskis7h17iBGR4ZDMHmwsOpAg==
X-Received: by 2002:adf:82a8:: with SMTP id 37mr7127315wrc.332.1562185711828;
        Wed, 03 Jul 2019 13:28:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id w20sm8256560wra.96.2019.07.03.13.28.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:28:31 -0700 (PDT)
Subject: Re: [PATCH v2 7/7] net: phy: realtek: configure RTL8211E LEDs
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-7-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <189ec367-2085-056b-61a9-90f0044b55ba@gmail.com>
Date:   Wed, 3 Jul 2019 22:28:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703193724.246854-7-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> Configure the RTL8211E LEDs behavior when the device tree property
> 'realtek,led-modes' is specified.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - patch added to the series
> ---
>  drivers/net/phy/realtek.c | 63 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 45fee4612031..559aec547738 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -9,6 +9,7 @@
>   * Copyright (c) 2004 Freescale Semiconductor, Inc.
>   */
>  #include <linux/bitops.h>
> +#include <linux/bits.h>
>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -35,6 +36,15 @@
>  #define RTL8211E_EEE_LED_MODE1			0x05
>  #define RTL8211E_EEE_LED_MODE2			0x06
>  
> +/* RTL8211E extension page 44 */
> +#define RTL8211E_LACR				0x1a
> +#define RLT8211E_LACR_LEDACTCTRL_SHIFT		4
> +#define RLT8211E_LACR_LEDACTCTRL_MASK		GENMASK(6, 4)
> +#define RTL8211E_LCR				0x1c
> +#define RTL8211E_LCR_LEDCTRL_MASK		(GENMASK(2, 0) | \
> +						 GENMASK(6, 4) | \
> +						 GENMASK(10, 8))
> +
>  /* RTL8211E extension page 160 */
>  #define RTL8211E_SCR				0x1a
>  #define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
> @@ -124,6 +134,56 @@ static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
>  	return phy_restore_page(phydev, oldpage, ret);
>  }
>  
> +static int rtl8211e_config_leds(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	int count, i, oldpage, ret;
> +	u16 lacr_bits = 0, lcr_bits = 0;
> +
> +	if (!dev->of_node)
> +		return 0;
> +
> +	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
> +		rtl8211e_disable_eee_led_mode(phydev);
> +
> +	count = of_property_count_elems_of_size(dev->of_node,
> +						"realtek,led-modes",
> +						sizeof(u32));
> +	if (count < 0 || count > 3)
> +		return -EINVAL;
> +
> +	for (i = 0; i < count; i++) {
> +		u32 val;
> +
> +		of_property_read_u32_index(dev->of_node,
> +					   "realtek,led-modes", i, &val);
> +		lacr_bits |= (u16)(val >> 16) <<
> +			(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);

This may be done in an easier to read way:

if (val & RTL8211E_LINK_ACTIVITY)
	lacr_bits |= BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);


> +		lcr_bits |= (u16)(val & 0xf) << (i * 4);
> +	}
> +
> +	oldpage = rtl8211e_select_ext_page(phydev, 44);
> +	if (oldpage < 0) {
> +		dev_err(dev, "failed to select extended page: %d\n", oldpage);

In a PHY driver it may be more appropriate to use phydev_err() et al,
even though effectively it's the same.

> +		goto err;
> +	}
> +
> +	ret = __phy_modify(phydev, RTL8211E_LACR,
> +			   RLT8211E_LACR_LEDACTCTRL_MASK, lacr_bits);
> +	if (ret) {
> +		dev_err(dev, "failed to write LACR reg: %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret = __phy_modify(phydev, RTL8211E_LCR,
> +			   RTL8211E_LCR_LEDCTRL_MASK, lcr_bits);
> +	if (ret)
> +		dev_err(dev, "failed to write LCR reg: %d\n", ret);
> +
> +err:
> +	return phy_restore_page(phydev, oldpage, ret);
> +}
> +
>  static int rtl8211e_config_init(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
> @@ -137,8 +197,7 @@ static int rtl8211e_config_init(struct phy_device *phydev)
>  			dev_err(dev, "failed to enable SSC on RXC: %d\n", ret);
>  	}
>  
> -	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
> -		rtl8211e_disable_eee_led_mode(phydev);
> +	rtl8211e_config_leds(phydev);
>  
>  	return 0;
>  }
> 

