Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E11AE24C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgDQQ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgDQQ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:29:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6365DC061A0C;
        Fri, 17 Apr 2020 09:29:15 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so3768661wrx.4;
        Fri, 17 Apr 2020 09:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ys+l22g6Vc6ru2/885HJ1530x9tYnitfC6EcM+60JII=;
        b=X0/eIeNuAPgUo0BPE7P5AZ0jdfUVEmCeVLbYZBsFheHPiOnggrBCVgM5g7t/eRduhL
         2XNF3mwrJRU9K5msvzrOLRtlgQ5o1jLybIWVoMgke9HiQnBGnQ8Ds0i20/9sVLZaRkwP
         6y0UgELV/eJyxjdQjj0AT3CRU9gALb0BzwHTVYCbo8URkxqAd066yILDpe1rxttaxd4h
         4srbJGOt8vUc32LVKMqMiIdJeylcet5Q8xEwW3qb3SCos/ZP/wSL9jkHyLeiBxZGyd+q
         0MCwt5rwOrfaDFqGGsVBhOqjEJ7w3SGzEMEWe3XdJIGqKtZXZdMCVZhvZCCWy+q8KqJD
         sfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ys+l22g6Vc6ru2/885HJ1530x9tYnitfC6EcM+60JII=;
        b=dHbmhGczV8F6aAQLUVooSVZzPQW55Luw+vmS6Oeg2UqOcS+1SsUWuPq0Xg/S0TADah
         R7lgYd8Zeg+MAYKb6aFhhCIkn5YULm//50ZAqK00M9bWJoX1cXod4LIUh4IcQhLLRpiw
         TXlIBt0AVntW7qZKtr+rvRNzYGoLPBdcV0cQ1D0CdqsqTjg0L+h6q82KYLpnK+JL9NbZ
         0ciNLhQ3HKoK0/NsrwvGN5jSxXSPmkCxopYpIX9bieUrAisTkjmPf6MZ2jvgpW3++KNk
         S+gLI6mS1kfYBOZ95YrhG7J5NG52D0U4XFsCaBfr0RboV6bjLZezZPGYJR0Hk0Ar30vU
         NMSg==
X-Gm-Message-State: AGi0PuZqxDS0Lwt0a4APG/VSFeyUxczZ/llqo4zVLdf9lCCcZkeSFZYB
        +v+pI4YQEejV/0CKeuRrE0pP9sXT
X-Google-Smtp-Source: APiQypKixHLngDTI4MWGZA7gdLrkdfBhZcS9nibr8mREmKCnJcx7lDJea7dXkUGEObfH21yfwmsBtA==
X-Received: by 2002:a5d:4345:: with SMTP id u5mr4649907wrr.417.1587140953546;
        Fri, 17 Apr 2020 09:29:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:adc2:161e:aba7:d360? (p200300EA8F296000ADC2161EABA7D360.dip0.t-ipconnect.de. [2003:ea:8f29:6000:adc2:161e:aba7:d360])
        by smtp.googlemail.com with ESMTPSA id p5sm35541321wrg.49.2020.04.17.09.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 09:29:13 -0700 (PDT)
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
To:     =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@siol.net>,
        robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
 <20200416185758.1388148-3-jernej.skrabec@siol.net>
 <0340f85c-987f-900b-53c8-d29b4672a8fa@gmail.com>
 <3035405.oiGErgHkdL@jernej-laptop>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1d03b2a8-fed5-5de8-6326-81b7436637da@gmail.com>
Date:   Fri, 17 Apr 2020 18:29:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3035405.oiGErgHkdL@jernej-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.04.2020 18:03, Jernej Škrabec wrote:
> Dne četrtek, 16. april 2020 ob 22:18:52 CEST je Heiner Kallweit napisal(a):
>> On 16.04.2020 20:57, Jernej Skrabec wrote:
>>> AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
>>>
>>> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
>>> ---
>>>
>>>  drivers/net/phy/Kconfig  |   7 ++
>>>  drivers/net/phy/Makefile |   1 +
>>>  drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 214 insertions(+)
>>>  create mode 100644 drivers/net/phy/ac200.c
>>>
>>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>>> index 3fa33d27eeba..16af69f69eaf 100644
>>> --- a/drivers/net/phy/Kconfig
>>> +++ b/drivers/net/phy/Kconfig
>>> @@ -288,6 +288,13 @@ config ADIN_PHY
>>>
>>>  	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
>>>  	  
>>>  	    Ethernet PHY
>>>
>>> +config AC200_PHY
>>> +	tristate "AC200 EPHY"
>>> +	depends on NVMEM
>>> +	depends on OF
>>> +	help
>>> +	  Fast ethernet PHY as found in X-Powers AC200 multi-function 
> device.
>>> +
>>>
>>>  config AMD_PHY
>>>  
>>>  	tristate "AMD PHYs"
>>>  	---help---
>>>
>>> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
>>> index 2f5c7093a65b..b0c5b91900fa 100644
>>> --- a/drivers/net/phy/Makefile
>>> +++ b/drivers/net/phy/Makefile
>>> @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
>>>
>>>  sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
>>>  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
>>>
>>> +obj-$(CONFIG_AC200_PHY)		+= ac200.o
>>>
>>>  obj-$(CONFIG_ADIN_PHY)		+= adin.o
>>>  obj-$(CONFIG_AMD_PHY)		+= amd.o
>>>  aquantia-objs			+= aquantia_main.o
>>>
>>> diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
>>> new file mode 100644
>>> index 000000000000..3d7856ff8f91
>>> --- /dev/null
>>> +++ b/drivers/net/phy/ac200.c
>>> @@ -0,0 +1,206 @@
>>> +// SPDX-License-Identifier: GPL-2.0+
>>> +/**
>>> + * Driver for AC200 Ethernet PHY
>>> + *
>>> + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/mfd/ac200.h>
>>> +#include <linux/nvmem-consumer.h>
>>> +#include <linux/of.h>
>>> +#include <linux/phy.h>
>>> +#include <linux/platform_device.h>
>>> +
>>> +#define AC200_EPHY_ID			0x00441400
>>> +#define AC200_EPHY_ID_MASK		0x0ffffff0
>>> +
>>
>> You could use PHY_ID_MATCH_MODEL() here.
> 
> Ok.
> 
>>
>>> +/* macros for system ephy control 0 register */
>>> +#define AC200_EPHY_RESET_INVALID	BIT(0)
>>> +#define AC200_EPHY_SYSCLK_GATING	BIT(1)
>>> +
>>> +/* macros for system ephy control 1 register */
>>> +#define AC200_EPHY_E_EPHY_MII_IO_EN	BIT(0)
>>> +#define AC200_EPHY_E_LNK_LED_IO_EN	BIT(1)
>>> +#define AC200_EPHY_E_SPD_LED_IO_EN	BIT(2)
>>> +#define AC200_EPHY_E_DPX_LED_IO_EN	BIT(3)
>>> +
>>> +/* macros for ephy control register */
>>> +#define AC200_EPHY_SHUTDOWN		BIT(0)
>>> +#define AC200_EPHY_LED_POL		BIT(1)
>>> +#define AC200_EPHY_CLK_SEL		BIT(2)
>>> +#define AC200_EPHY_ADDR(x)		(((x) & 0x1F) << 4)
>>> +#define AC200_EPHY_XMII_SEL		BIT(11)
>>> +#define AC200_EPHY_CALIB(x)		(((x) & 0xF) << 12)
>>> +
>>> +struct ac200_ephy_dev {
>>> +	struct phy_driver	*ephy;
>>
>> Why embedding a pointer and not a struct phy_driver directly?
>> Then you could omit the separate allocation.
> 
> Right.
> 
>>
>> ephy is not the best naming. It may be read as a phy_device.
>> Better use phydrv.
> 
> Ok.
> 
>>
>>> +	struct regmap		*regmap;
>>> +};
>>> +
>>> +static char *ac200_phy_name = "AC200 EPHY";
>>> +
>>
>> Why not using the name directly in the assignment?
> 
> phy_driver->name is pointer. Wouldn't that mean that string is allocated on 
> stack and next time pointer is used, it will return garbage?
> 
No, it's not on the stack. No problem here.

>> And better naming: "AC200 Fast Ethernet"
> 
> Ok.
> 
>>
>>> +static int ac200_ephy_config_init(struct phy_device *phydev)
>>> +{
>>> +	const struct ac200_ephy_dev *priv = phydev->drv->driver_data;
>>> +	unsigned int value;
>>> +	int ret;
>>> +
>>> +	phy_write(phydev, 0x1f, 0x0100);	/* Switch to Page 1 */
>>> +	phy_write(phydev, 0x12, 0x4824);	/* Disable APS */
>>> +
>>> +	phy_write(phydev, 0x1f, 0x0200);	/* Switch to Page 2 */
>>> +	phy_write(phydev, 0x18, 0x0000);	/* PHYAFE TRX optimization */
>>> +
>>> +	phy_write(phydev, 0x1f, 0x0600);	/* Switch to Page 6 */
>>> +	phy_write(phydev, 0x14, 0x708f);	/* PHYAFE TX optimization */
>>> +	phy_write(phydev, 0x13, 0xF000);	/* PHYAFE RX optimization */
>>> +	phy_write(phydev, 0x15, 0x1530);
>>> +
>>> +	phy_write(phydev, 0x1f, 0x0800);	/* Switch to Page 6 */
>>> +	phy_write(phydev, 0x18, 0x00bc);	/* PHYAFE TRX optimization */
>>> +
>>> +	phy_write(phydev, 0x1f, 0x0100);	/* switch to page 1 */
>>> +	phy_clear_bits(phydev, 0x17, BIT(3));	/* disable intelligent 
> IEEE */
>>> +
>>> +	/* next two blocks disable 802.3az IEEE */
>>> +	phy_write(phydev, 0x1f, 0x0200);	/* switch to page 2 */
>>> +	phy_write(phydev, 0x18, 0x0000);
>>> +
>>> +	phy_write(phydev, 0x1f, 0x0000);	/* switch to page 0 */
>>> +	phy_clear_bits_mmd(phydev, 0x7, 0x3c, BIT(1));
>>
>> Better use the following:
>> phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
>> It makes clear that you disable advertising EEE completely.
> 
> Ok.
> 
>>
>>> +
>>> +	if (phydev->interface == PHY_INTERFACE_MODE_RMII)
>>> +		value = AC200_EPHY_XMII_SEL;
>>> +	else
>>> +		value = 0;
>>> +
>>> +	ret = regmap_update_bits(priv->regmap, AC200_EPHY_CTL,
>>> +				 AC200_EPHY_XMII_SEL, value);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>
>> I had a brief look at the spec, and it's not fully clear
>> to me what this register setting does. Does it affect the
>> MAC side and/or the PHY side?
> 
> It's my understanding that it selects interface mode on PHY. Besides datasheet 
> mentioned in cover letter, BSP drivers (one for MFD and one for PHY) are the 
> only other source of information. BSP PHY driver is located here:
> https://github.com/Allwinner-Homlet/H6-BSP4.9-linux/blob/master/drivers/net/
> phy/sunxi-ephy.c
> 
>> If it affects the PHY side, then I'd expect that the chip
>> has to talk to the PHY via the MDIO bus. Means there should
>> be a PHY register for setting MII vs. RMII.
>> In this case the setup could be very much simplified.
>> Then the PHY driver wouldn't have to be embedded in the
>> platform driver.
> 
> Actually, PHY has to be configured first through I2C and then through MDIO. I2C 
> is used to enable it (power it up), configure LED polarity, set PHY address, 
> write calibration value stored elsewhere.
> 
> Based on all available documentation I have (code and datasheet), this I2C 
> register is the only way to select MII or RMII mode.
> 
Then how and where is the PHY interface mode configured on the MAC side?
If there is no such setting, then I'd assume that this register bit
configures both sides. This leads to the question whether the interface
mode really needs to be set in the PHY driver's config_init().
If we could avoid this, then you could make the PHY driver static.

You could set the PHY interface mode as soon as the PHY interface mode
is read from DT. So why not set the interface mode at the place where
you configure the other values like PHY address?

>>
>>> +	/* FIXME: This is H6 specific */
>>> +	phy_set_bits(phydev, 0x13, BIT(12));
>>> +
>>
>> This seems to indicate that the same PHY is used in a slightly
>> different version with other Hx models. Do they use different
>> PHY ID's?
> 
> Situation is a bit complicated. Same PHY, at least with same PHY ID, is used 
> in different ways.
> 1. as part of standalone AC200 MFD IC
> 2. as part of AC200 wafer copackaged with H6 SoC wafer in same package. This 
> in theory shouldn't be any different than standalone IC, but it apparently is, 
> based on the BSP driver code.
> 3. integrated directly in SoCs like H3, H5 and V3s. There is no I2C access to 
> configuration register. Instead, it's memory mapped and slightly different.
> 
> In all cases PHY ID is same, just glue logic is different.
> 
> I asked Allwinner if above setting is really necessary for H6 and what it 
> does, but I didn't get any useful answer back.
> 
> So maybe another compatible is needed for H6.
> 
> Best regards,
> Jernej
> 
>>
>>> +	return 0;
>>> +}
>>> +
>>> +static int ac200_ephy_probe(struct platform_device *pdev)
>>> +{
>>> +	struct ac200_dev *ac200 = dev_get_drvdata(pdev->dev.parent);
>>> +	struct device *dev = &pdev->dev;
>>> +	struct ac200_ephy_dev *priv;
>>> +	struct nvmem_cell *calcell;
>>> +	struct phy_driver *ephy;
>>> +	u16 *caldata, calib;
>>> +	size_t callen;
>>> +	int ret;
>>> +
>>> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>>> +	if (!priv)
>>> +		return -ENOMEM;
>>> +
>>> +	ephy = devm_kzalloc(dev, sizeof(*ephy), GFP_KERNEL);
>>> +	if (!ephy)
>>> +		return -ENOMEM;
>>> +
>>> +	calcell = devm_nvmem_cell_get(dev, "calibration");
>>> +	if (IS_ERR(calcell)) {
>>> +		dev_err(dev, "Unable to find calibration data!\n");
>>> +		return PTR_ERR(calcell);
>>> +	}
>>> +
>>> +	caldata = nvmem_cell_read(calcell, &callen);
>>> +	if (IS_ERR(caldata)) {
>>> +		dev_err(dev, "Unable to read calibration data!\n");
>>> +		return PTR_ERR(caldata);
>>> +	}
>>> +
>>> +	if (callen != 2) {
>>> +		dev_err(dev, "Calibration data has wrong length: 2 != 
> %zu\n",
>>> +			callen);
>>> +		kfree(caldata);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	calib = *caldata + 3;
>>> +	kfree(caldata);
>>> +
>>> +	ephy->phy_id = AC200_EPHY_ID;
>>> +	ephy->phy_id_mask = AC200_EPHY_ID_MASK;
>>> +	ephy->name = ac200_phy_name;
>>> +	ephy->driver_data = priv;
>>> +	ephy->soft_reset = genphy_soft_reset;
>>> +	ephy->config_init = ac200_ephy_config_init;
>>> +	ephy->suspend = genphy_suspend;
>>> +	ephy->resume = genphy_resume;
>>> +
>>> +	priv->ephy = ephy;
>>> +	priv->regmap = ac200->regmap;
>>> +	platform_set_drvdata(pdev, priv);
>>> +
>>> +	ret = regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL0,
>>> +			   AC200_EPHY_RESET_INVALID |
>>> +			   AC200_EPHY_SYSCLK_GATING);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL1,
>>> +			   AC200_EPHY_E_EPHY_MII_IO_EN |
>>> +			   AC200_EPHY_E_LNK_LED_IO_EN |
>>> +			   AC200_EPHY_E_SPD_LED_IO_EN |
>>> +			   AC200_EPHY_E_DPX_LED_IO_EN);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = regmap_write(ac200->regmap, AC200_EPHY_CTL,
>>> +			   AC200_EPHY_LED_POL |
>>> +			   AC200_EPHY_CLK_SEL |
>>> +			   AC200_EPHY_ADDR(1) |
>>> +			   AC200_EPHY_CALIB(calib));
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = phy_driver_register(priv->ephy, THIS_MODULE);
>>> +	if (ret) {
>>> +		dev_err(dev, "Unable to register phy\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int ac200_ephy_remove(struct platform_device *pdev)
>>> +{
>>> +	struct ac200_ephy_dev *priv = platform_get_drvdata(pdev);
>>> +
>>> +	phy_driver_unregister(priv->ephy);
>>> +
>>> +	regmap_write(priv->regmap, AC200_EPHY_CTL, AC200_EPHY_SHUTDOWN);
>>> +	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL1, 0);
>>> +	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL0, 0);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct of_device_id ac200_ephy_match[] = {
>>> +	{ .compatible = "x-powers,ac200-ephy" },
>>> +	{ /* sentinel */ }
>>> +};
>>> +MODULE_DEVICE_TABLE(of, ac200_ephy_match);
>>> +
>>> +static struct platform_driver ac200_ephy_driver = {
>>> +	.probe		= ac200_ephy_probe,
>>> +	.remove		= ac200_ephy_remove,
>>> +	.driver		= {
>>> +		.name		= "ac200-ephy",
>>> +		.of_match_table	= ac200_ephy_match,
>>> +	},
>>> +};
>>> +module_platform_driver(ac200_ephy_driver);
>>> +
>>> +MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
>>> +MODULE_DESCRIPTION("AC200 Ethernet PHY driver");
>>> +MODULE_LICENSE("GPL");
> 
> 
> 
> 

