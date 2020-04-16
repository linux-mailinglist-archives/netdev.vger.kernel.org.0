Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8E81AD0FE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgDPUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728305AbgDPUTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:19:00 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFD8C03C1A8;
        Thu, 16 Apr 2020 13:18:59 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so154475wmk.5;
        Thu, 16 Apr 2020 13:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KeGobbzqCkTR7T1/oxIiS/g+ICaDRVHdJ0lwdmRwZZQ=;
        b=Vkn/Bw5ZHEL4oFf1TdXwu/8h23AHMvHZ1G7mhs1wXf9wmk26o5llsSNHtp9UefcLCC
         kSpi2P5FJa5Xyh2J48U5QJcGCTODAh+WYcw4yKIGbT6mBl4i1M6eA9/1cSid2G73Ej8W
         Q+RtqDZPF5U0hXouiC0VD8NOYzGfvQsJlpxaLl+sJnyTWNP4W+bvEiZMclb87h6tIOUY
         e34YXIzMipLQ/pPC3Etns628qZZZlnbO1USfBBgQLtnJwO654VQXz0+9ut+IIPdMcpUr
         sviOwcSZDyBveLh0QpVl0FsQWDEXO7rRVcQJ0OtBnwQkRoSwvUEl/o5citUSHw+cW2HX
         R/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KeGobbzqCkTR7T1/oxIiS/g+ICaDRVHdJ0lwdmRwZZQ=;
        b=duOwrEXWlqDoguy2FGL5Ny+in1+KC/R8cNNT1chXl8YHVYDeY1qyN7PVBJIrpszTlJ
         lmGAqkaOz++3ush+sHh7Vk0S//hwR7fiUKRvsDlsYh3KGIxTkNWOFU/+U1t/tqpGwD8X
         RpaWNRwKGzria3PwaApwpWb3g6VnmNX6DkXX2VDZn6jb2Pd3OA3cXj3z+ZrL0vs5Fwl6
         HjK1bAjuukyL/nMCGVJ9+cjX9/OAhCfWX+jsVoElbKZYXU/tVAOh3J1vKuDnyPdDqKqI
         DfnK2bdMHN8AZss26Qvdje5xePhm5+PvtsacvZLdS3qbqek0KhJ1W0flplhF0gxYz5aa
         Qe4w==
X-Gm-Message-State: AGi0PuacLx9jw2sRd8YK8z1o+Qm0l2MUgBkoC+v7NghjrxUr9z9s6YuH
        p+RV936bIMjCAoKcvC8q02TSfQhM
X-Google-Smtp-Source: APiQypI/VTj/diYhY+2Q1KcF7/4k2NSO9eep1P7Eqqk9UFBoGdZOUOeJDMmU4EXefhFs44bxowS/1A==
X-Received: by 2002:a1c:9a96:: with SMTP id c144mr6646225wme.84.1587068338050;
        Thu, 16 Apr 2020 13:18:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b900:f290:558a:f094? (p200300EA8F296000B900F290558AF094.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b900:f290:558a:f094])
        by smtp.googlemail.com with ESMTPSA id l4sm4486820wrv.60.2020.04.16.13.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 13:18:57 -0700 (PDT)
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
To:     Jernej Skrabec <jernej.skrabec@siol.net>, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
 <20200416185758.1388148-3-jernej.skrabec@siol.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0340f85c-987f-900b-53c8-d29b4672a8fa@gmail.com>
Date:   Thu, 16 Apr 2020 22:18:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416185758.1388148-3-jernej.skrabec@siol.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2020 20:57, Jernej Skrabec wrote:
> AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
> 
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> ---
>  drivers/net/phy/Kconfig  |   7 ++
>  drivers/net/phy/Makefile |   1 +
>  drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 214 insertions(+)
>  create mode 100644 drivers/net/phy/ac200.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 3fa33d27eeba..16af69f69eaf 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -288,6 +288,13 @@ config ADIN_PHY
>  	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
>  	    Ethernet PHY
>  
> +config AC200_PHY
> +	tristate "AC200 EPHY"
> +	depends on NVMEM
> +	depends on OF
> +	help
> +	  Fast ethernet PHY as found in X-Powers AC200 multi-function device.
> +
>  config AMD_PHY
>  	tristate "AMD PHYs"
>  	---help---
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 2f5c7093a65b..b0c5b91900fa 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
>  sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
>  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
>  
> +obj-$(CONFIG_AC200_PHY)		+= ac200.o
>  obj-$(CONFIG_ADIN_PHY)		+= adin.o
>  obj-$(CONFIG_AMD_PHY)		+= amd.o
>  aquantia-objs			+= aquantia_main.o
> diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
> new file mode 100644
> index 000000000000..3d7856ff8f91
> --- /dev/null
> +++ b/drivers/net/phy/ac200.c
> @@ -0,0 +1,206 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/**
> + * Driver for AC200 Ethernet PHY
> + *
> + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mfd/ac200.h>
> +#include <linux/nvmem-consumer.h>
> +#include <linux/of.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define AC200_EPHY_ID			0x00441400
> +#define AC200_EPHY_ID_MASK		0x0ffffff0
> +

You could use PHY_ID_MATCH_MODEL() here.

> +/* macros for system ephy control 0 register */
> +#define AC200_EPHY_RESET_INVALID	BIT(0)
> +#define AC200_EPHY_SYSCLK_GATING	BIT(1)
> +
> +/* macros for system ephy control 1 register */
> +#define AC200_EPHY_E_EPHY_MII_IO_EN	BIT(0)
> +#define AC200_EPHY_E_LNK_LED_IO_EN	BIT(1)
> +#define AC200_EPHY_E_SPD_LED_IO_EN	BIT(2)
> +#define AC200_EPHY_E_DPX_LED_IO_EN	BIT(3)
> +
> +/* macros for ephy control register */
> +#define AC200_EPHY_SHUTDOWN		BIT(0)
> +#define AC200_EPHY_LED_POL		BIT(1)
> +#define AC200_EPHY_CLK_SEL		BIT(2)
> +#define AC200_EPHY_ADDR(x)		(((x) & 0x1F) << 4)
> +#define AC200_EPHY_XMII_SEL		BIT(11)
> +#define AC200_EPHY_CALIB(x)		(((x) & 0xF) << 12)
> +
> +struct ac200_ephy_dev {
> +	struct phy_driver	*ephy;

Why embedding a pointer and not a struct phy_driver directly?
Then you could omit the separate allocation.

ephy is not the best naming. It may be read as a phy_device.
Better use phydrv.

> +	struct regmap		*regmap;
> +};
> +
> +static char *ac200_phy_name = "AC200 EPHY";
> +
Why not using the name directly in the assignment?
And better naming: "AC200 Fast Ethernet"

> +static int ac200_ephy_config_init(struct phy_device *phydev)
> +{
> +	const struct ac200_ephy_dev *priv = phydev->drv->driver_data;
> +	unsigned int value;
> +	int ret;
> +
> +	phy_write(phydev, 0x1f, 0x0100);	/* Switch to Page 1 */
> +	phy_write(phydev, 0x12, 0x4824);	/* Disable APS */
> +
> +	phy_write(phydev, 0x1f, 0x0200);	/* Switch to Page 2 */
> +	phy_write(phydev, 0x18, 0x0000);	/* PHYAFE TRX optimization */
> +
> +	phy_write(phydev, 0x1f, 0x0600);	/* Switch to Page 6 */
> +	phy_write(phydev, 0x14, 0x708f);	/* PHYAFE TX optimization */
> +	phy_write(phydev, 0x13, 0xF000);	/* PHYAFE RX optimization */
> +	phy_write(phydev, 0x15, 0x1530);
> +
> +	phy_write(phydev, 0x1f, 0x0800);	/* Switch to Page 6 */
> +	phy_write(phydev, 0x18, 0x00bc);	/* PHYAFE TRX optimization */
> +
> +	phy_write(phydev, 0x1f, 0x0100);	/* switch to page 1 */
> +	phy_clear_bits(phydev, 0x17, BIT(3));	/* disable intelligent IEEE */
> +
> +	/* next two blocks disable 802.3az IEEE */
> +	phy_write(phydev, 0x1f, 0x0200);	/* switch to page 2 */
> +	phy_write(phydev, 0x18, 0x0000);
> +
> +	phy_write(phydev, 0x1f, 0x0000);	/* switch to page 0 */
> +	phy_clear_bits_mmd(phydev, 0x7, 0x3c, BIT(1));

Better use the following:
phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
It makes clear that you disable advertising EEE completely.

> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RMII)
> +		value = AC200_EPHY_XMII_SEL;
> +	else
> +		value = 0;
> +
> +	ret = regmap_update_bits(priv->regmap, AC200_EPHY_CTL,
> +				 AC200_EPHY_XMII_SEL, value);
> +	if (ret)
> +		return ret;
> +

I had a brief look at the spec, and it's not fully clear
to me what this register setting does. Does it affect the
MAC side and/or the PHY side?
If it affects the PHY side, then I'd expect that the chip
has to talk to the PHY via the MDIO bus. Means there should
be a PHY register for setting MII vs. RMII.
In this case the setup could be very much simplified.
Then the PHY driver wouldn't have to be embedded in the
platform driver.

> +	/* FIXME: This is H6 specific */
> +	phy_set_bits(phydev, 0x13, BIT(12));
> +

This seems to indicate that the same PHY is used in a slightly
different version with other Hx models. Do they use different
PHY ID's?

> +	return 0;
> +}
> +
> +static int ac200_ephy_probe(struct platform_device *pdev)
> +{
> +	struct ac200_dev *ac200 = dev_get_drvdata(pdev->dev.parent);
> +	struct device *dev = &pdev->dev;
> +	struct ac200_ephy_dev *priv;
> +	struct nvmem_cell *calcell;
> +	struct phy_driver *ephy;
> +	u16 *caldata, calib;
> +	size_t callen;
> +	int ret;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	ephy = devm_kzalloc(dev, sizeof(*ephy), GFP_KERNEL);
> +	if (!ephy)
> +		return -ENOMEM;
> +
> +	calcell = devm_nvmem_cell_get(dev, "calibration");
> +	if (IS_ERR(calcell)) {
> +		dev_err(dev, "Unable to find calibration data!\n");
> +		return PTR_ERR(calcell);
> +	}
> +
> +	caldata = nvmem_cell_read(calcell, &callen);
> +	if (IS_ERR(caldata)) {
> +		dev_err(dev, "Unable to read calibration data!\n");
> +		return PTR_ERR(caldata);
> +	}
> +
> +	if (callen != 2) {
> +		dev_err(dev, "Calibration data has wrong length: 2 != %zu\n",
> +			callen);
> +		kfree(caldata);
> +		return -EINVAL;
> +	}
> +
> +	calib = *caldata + 3;
> +	kfree(caldata);
> +
> +	ephy->phy_id = AC200_EPHY_ID;
> +	ephy->phy_id_mask = AC200_EPHY_ID_MASK;
> +	ephy->name = ac200_phy_name;
> +	ephy->driver_data = priv;
> +	ephy->soft_reset = genphy_soft_reset;
> +	ephy->config_init = ac200_ephy_config_init;
> +	ephy->suspend = genphy_suspend;
> +	ephy->resume = genphy_resume;
> +
> +	priv->ephy = ephy;
> +	priv->regmap = ac200->regmap;
> +	platform_set_drvdata(pdev, priv);
> +
> +	ret = regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL0,
> +			   AC200_EPHY_RESET_INVALID |
> +			   AC200_EPHY_SYSCLK_GATING);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(ac200->regmap, AC200_SYS_EPHY_CTL1,
> +			   AC200_EPHY_E_EPHY_MII_IO_EN |
> +			   AC200_EPHY_E_LNK_LED_IO_EN |
> +			   AC200_EPHY_E_SPD_LED_IO_EN |
> +			   AC200_EPHY_E_DPX_LED_IO_EN);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(ac200->regmap, AC200_EPHY_CTL,
> +			   AC200_EPHY_LED_POL |
> +			   AC200_EPHY_CLK_SEL |
> +			   AC200_EPHY_ADDR(1) |
> +			   AC200_EPHY_CALIB(calib));
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_driver_register(priv->ephy, THIS_MODULE);
> +	if (ret) {
> +		dev_err(dev, "Unable to register phy\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ac200_ephy_remove(struct platform_device *pdev)
> +{
> +	struct ac200_ephy_dev *priv = platform_get_drvdata(pdev);
> +
> +	phy_driver_unregister(priv->ephy);
> +
> +	regmap_write(priv->regmap, AC200_EPHY_CTL, AC200_EPHY_SHUTDOWN);
> +	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL1, 0);
> +	regmap_write(priv->regmap, AC200_SYS_EPHY_CTL0, 0);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ac200_ephy_match[] = {
> +	{ .compatible = "x-powers,ac200-ephy" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ac200_ephy_match);
> +
> +static struct platform_driver ac200_ephy_driver = {
> +	.probe		= ac200_ephy_probe,
> +	.remove		= ac200_ephy_remove,
> +	.driver		= {
> +		.name		= "ac200-ephy",
> +		.of_match_table	= ac200_ephy_match,
> +	},
> +};
> +module_platform_driver(ac200_ephy_driver);
> +
> +MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
> +MODULE_DESCRIPTION("AC200 Ethernet PHY driver");
> +MODULE_LICENSE("GPL");
> 

