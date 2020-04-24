Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0311B6F85
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDXIF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgDXIFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:05:23 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7732C09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 01:05:21 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r26so9648355wmh.0
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 01:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WmaSZtcJ97CVuu5ovBVXDQ/oN+gMvGID2LE/mRUyMFg=;
        b=jMKF0/4ElvJJU7ACf8LJ4xPnX+osyHWbnXvCkZLDHI2ozVzE73WQ1ti40GmhmeQaf4
         W9d3u+Aq//ipqx5TPvpM0NqfkN+zhE5FqT5ZFFLJfeQEjbfeBxd+Ec+RCC1HWKrzeyBY
         tavYHXqgaU565PNno3ZyaLrtBJorwTriaG1N+LmnXJgQq2vJ7rysJHQSiMAreUdHwbeA
         iTB7d9JUrSt7OLQBpbRrlzf/icJxoRlONAW8+x3ndfwlF6G6yS9uv2iH2FQcFPL2l9zp
         vdCMQgjrw7hsYH99BsSLpgByq5izD+jxpJVsxD+iYbgVfl0wBfGn7bGmjephUqM3u80K
         b4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WmaSZtcJ97CVuu5ovBVXDQ/oN+gMvGID2LE/mRUyMFg=;
        b=E/yzNfy8gZTup/J9RaxgY7e970+tKAbAmwyjFsUPQHc9XTV+8rp7OsDpXoeiJUu3+R
         BJ2xCQgurW/zXi7Kc1VPJT3UiTQPGCN4x2ga0Fss+fwnLodU7XWO6llbp8hZUWBhBPT2
         3RJT092SfPWWyzBQliv/EEUxm6hb4RsWiVIEufhuyCzJiHSw2uFcea4pDkIop+msCvcf
         rQ8tJ0fgAWKwN6vL3+NIRXyS7RDtIvfu4NRwreS5/5D/WW1eOl0/bRPxGgXvYhTS1c4/
         xEYOfh3YXl9k+h+qw5uw2LlN0dpN4gyH73NzCpPrHJdwzxDNPLMCMOGki8t/NdJ/7KCm
         B8Zg==
X-Gm-Message-State: AGi0PubTBxEgiN3nn5k75bAfSf0GYDX3rKu3t7lBsKemUHrzxa6VET5N
        Ks3+UXjz2vDG/L2b+OSBOZXa1A==
X-Google-Smtp-Source: APiQypKfRbQHOEb26CmLxcxK7PdDhRB4YNVM3ll52lyYv4/YuYOGq4FejHAjcQ9F2GuTU8hNHZDCuw==
X-Received: by 2002:a1c:750a:: with SMTP id o10mr8535498wmc.124.1587715520195;
        Fri, 24 Apr 2020 01:05:20 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id d7sm6958518wrn.78.2020.04.24.01.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 01:05:18 -0700 (PDT)
Date:   Fri, 24 Apr 2020 09:05:17 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mripard@kernel.org, wens@csie.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] mfd: Add support for AC200
Message-ID: <20200424080517.GO3612@dell>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
 <20200416185758.1388148-2-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416185758.1388148-2-jernej.skrabec@siol.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020, Jernej Skrabec wrote:

> This adds support for AC200 multi functional IC. It can be packaged
> standalone or copackaged with SoC like Allwinner H6.
> 
> It has analog audio codec, CVBS encoder, RTC and Fast Ethernet PHY.
> Documentation also mention eFuses, but it seems that it's not used in
> copackaged variant.
> 
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> ---
>  drivers/mfd/Kconfig       |   9 ++
>  drivers/mfd/Makefile      |   1 +
>  drivers/mfd/ac200.c       | 188 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ac200.h | 210 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 408 insertions(+)
>  create mode 100644 drivers/mfd/ac200.c
>  create mode 100644 include/linux/mfd/ac200.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 0a59249198d3..1d6b7f3ae193 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -178,6 +178,15 @@ config MFD_AC100
>  	  This driver include only the core APIs. You have to select individual
>  	  components like codecs or RTC under the corresponding menus.
>  
> +config MFD_AC200
> +	tristate "X-Powers AC200"
> +	select MFD_CORE
> +	depends on I2C
> +	help
> +	  If you say Y here you get support for the X-Powers AC200 IC.

Please describe the IC here.

> +	  This driver include only the core APIs. You have to select individual
> +	  components like Ethernet PHY or RTC under the corresponding menus.
> +
>  config MFD_AXP20X
>  	tristate
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f935d10cbf0f..a20407290d6f 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -142,6 +142,7 @@ obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
>  obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
>  
>  obj-$(CONFIG_MFD_AC100)		+= ac100.o
> +obj-$(CONFIG_MFD_AC200)		+= ac200.o
>  obj-$(CONFIG_MFD_AXP20X)	+= axp20x.o
>  obj-$(CONFIG_MFD_AXP20X_I2C)	+= axp20x-i2c.o
>  obj-$(CONFIG_MFD_AXP20X_RSB)	+= axp20x-rsb.o
> diff --git a/drivers/mfd/ac200.c b/drivers/mfd/ac200.c
> new file mode 100644
> index 000000000000..cf2710b84879
> --- /dev/null
> +++ b/drivers/mfd/ac200.c
> @@ -0,0 +1,188 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * MFD core driver for X-Powers' AC200 IC
> + *
> + * The AC200 is a chip which is co-packaged with Allwinner H6 SoC and
> + * includes analog audio codec, analog TV encoder, ethernet PHY, eFuse
> + * and RTC.
> + *
> + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>

This usually goes higher in the header comment.

> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/ac200.h>
> +#include <linux/module.h>
> +#include <linux/of.h>

Alphabetical.

> +/* Interrupts */
> +#define AC200_IRQ_RTC  0
> +#define AC200_IRQ_EPHY 1
> +#define AC200_IRQ_TVE  2
> +
> +/* IRQ enable register */
> +#define AC200_SYS_IRQ_ENABLE_OUT_EN BIT(15)
> +#define AC200_SYS_IRQ_ENABLE_RTC    BIT(12)
> +#define AC200_SYS_IRQ_ENABLE_EPHY   BIT(8)
> +#define AC200_SYS_IRQ_ENABLE_TVE    BIT(4)
> +
> +static const struct regmap_range_cfg ac200_range_cfg[] = {
> +	{
> +		.range_min = AC200_SYS_VERSION,
> +		.range_max = AC200_IC_CHARA1,
> +		.selector_reg = AC200_TWI_REG_ADDR_H,
> +		.selector_mask = 0xff,
> +		.selector_shift = 0,
> +		.window_start = 0,
> +		.window_len = 256,
> +	}
> +};
> +
> +static const struct regmap_config ac200_regmap_config = {
> +	.reg_bits	= 8,
> +	.val_bits	= 16,
> +	.ranges		= ac200_range_cfg,
> +	.num_ranges	= ARRAY_SIZE(ac200_range_cfg),
> +	.max_register	= AC200_IC_CHARA1,
> +};
> +
> +static const struct regmap_irq ac200_regmap_irqs[] = {
> +	REGMAP_IRQ_REG(AC200_IRQ_RTC,  0, AC200_SYS_IRQ_ENABLE_RTC),
> +	REGMAP_IRQ_REG(AC200_IRQ_EPHY, 0, AC200_SYS_IRQ_ENABLE_EPHY),
> +	REGMAP_IRQ_REG(AC200_IRQ_TVE,  0, AC200_SYS_IRQ_ENABLE_TVE),
> +};
> +
> +static const struct regmap_irq_chip ac200_regmap_irq_chip = {
> +	.name			= "ac200_irq_chip",
> +	.status_base		= AC200_SYS_IRQ_STATUS,
> +	.mask_base		= AC200_SYS_IRQ_ENABLE,
> +	.mask_invert		= true,
> +	.irqs			= ac200_regmap_irqs,
> +	.num_irqs		= ARRAY_SIZE(ac200_regmap_irqs),
> +	.num_regs		= 1,
> +};
> +
> +static const struct resource ephy_resource[] = {
> +	DEFINE_RES_IRQ(AC200_IRQ_EPHY),
> +};
> +
> +static const struct mfd_cell ac200_cells[] = {
> +	{
> +		.name		= "ac200-ephy",
> +		.num_resources	= ARRAY_SIZE(ephy_resource),
> +		.resources	= ephy_resource,
> +		.of_compatible	= "x-powers,ac200-ephy",
> +	},
> +};

Where are the reset of the devices?

> +static int ac200_i2c_probe(struct i2c_client *i2c,
> +			   const struct i2c_device_id *id)
> +{
> +	struct device *dev = &i2c->dev;
> +	struct ac200_dev *ac200;

struct ac200_ddata *ddata;

> +	int ret;
> +
> +	ac200 = devm_kzalloc(dev, sizeof(*ac200), GFP_KERNEL);
> +	if (!ac200)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, ac200);
> +
> +	ac200->regmap = devm_regmap_init_i2c(i2c, &ac200_regmap_config);
> +	if (IS_ERR(ac200->regmap)) {
> +		dev_err(dev, "regmap init failed\n");
> +		return PTR_ERR(ac200->regmap);
> +	}
> +
> +	ac200->clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(ac200->clk)) {
> +		dev_err(dev, "Can't obtain the clock!\n");
> +		return PTR_ERR(ac200->clk);
> +	}
> +
> +	ret = clk_prepare_enable(ac200->clk);
> +	if (ret)
> +		return ret;
> +
> +	/* do a reset to put chip in a known state */

If you define the magic values here, this comment become superfluous.

> +	ret = regmap_write(ac200->regmap, AC200_SYS_CONTROL, 0);
> +	if (ret)
> +		goto err_free_clk;
> +
> +	ret = regmap_write(ac200->regmap, AC200_SYS_CONTROL, 1);
> +	if (ret)
> +		goto err_free_clk;
> +
> +	/* enable interrupt pin */

This comment can be dropped.

> +	ret = regmap_write(ac200->regmap, AC200_SYS_IRQ_ENABLE,
> +			   AC200_SYS_IRQ_ENABLE_OUT_EN);
> +	if (ret)
> +		goto err_free_clk;
> +
> +	ret = regmap_add_irq_chip(ac200->regmap, i2c->irq, IRQF_ONESHOT, 0,
> +				  &ac200_regmap_irq_chip, &ac200->regmap_irqc);
> +	if (ret)
> +		goto err_free_clk;
> +
> +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, ac200_cells,
> +				   ARRAY_SIZE(ac200_cells), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(dev, "failed to add MFD devices: %d\n", ret);

"Failed to register child devices"

> +		goto err_del_irq_chip;
> +	}

Do you want to leave the clock running when you leave?

Seems wasteful.

> +	return 0;
> +
> +err_del_irq_chip:
> +	regmap_del_irq_chip(i2c->irq, ac200->regmap_irqc);

Use the devm_* version, then you do not have to clear up.

> +err_free_clk:
> +	clk_disable_unprepare(ac200->clk);
> +
> +	return ret;
> +}
> +
> +static int ac200_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct ac200_dev *ac200 = i2c_get_clientdata(i2c);
> +
> +	/* put chip in reset state */

Use defines, then remove the comment.

> +	regmap_write(ac200->regmap, AC200_SYS_CONTROL, 0);
> +
> +	mfd_remove_devices(&i2c->dev);

Use devm_* instead.

> +	regmap_del_irq_chip(i2c->irq, ac200->regmap_irqc);

Use devm_* instead.

> +	clk_disable_unprepare(ac200->clk);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ac200_ids[] = {
> +	{ "ac200", },
> +	{ /* sentinel */ }

No need for this comment.

In fact, no need for this table.  It can be removed.

> +};
> +MODULE_DEVICE_TABLE(i2c, ac200_ids);
> +
> +static const struct of_device_id ac200_of_match[] = {
> +	{ .compatible = "x-powers,ac200" },
> +	{ /* sentinel */ }

No need for this comment.

> +};
> +MODULE_DEVICE_TABLE(of, ac200_of_match);
> +
> +static struct i2c_driver ac200_i2c_driver = {
> +	.driver = {
> +		.name	= "ac200",
> +		.of_match_table	= of_match_ptr(ac200_of_match),
> +	},
> +	.probe	= ac200_i2c_probe,
> +	.remove = ac200_i2c_remove,
> +	.id_table = ac200_ids,
> +};
> +module_i2c_driver(ac200_i2c_driver);
> +
> +MODULE_DESCRIPTION("MFD core driver for AC200");

"Parent driver ..."

> +MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/ac200.h b/include/linux/mfd/ac200.h
> new file mode 100644
> index 000000000000..f75baf0d910c
> --- /dev/null
> +++ b/include/linux/mfd/ac200.h
> @@ -0,0 +1,210 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * AC200 register list
> + *
> + * Copyright (C) 2019 Jernej Skrabec <jernej.skrabec@siol.net>

This usually sits higher.

> + */
> +
> +#ifndef __LINUX_MFD_AC200_H
> +#define __LINUX_MFD_AC200_H
> +
> +#include <linux/clk.h>
> +#include <linux/regmap.h>
> +
> +/* interface registers (can be accessed from any page) */

Please use correct grammar in comments.

"Interface"

> +#define AC200_TWI_CHANGE_TO_RSB		0x3E
> +#define AC200_TWI_PAD_DELAY		0xC4
> +#define AC200_TWI_REG_ADDR_H		0xFE
> +
> +/* General registers */
> +#define AC200_SYS_VERSION		0x0000
> +#define AC200_SYS_CONTROL		0x0002
> +#define AC200_SYS_IRQ_ENABLE		0x0004
> +#define AC200_SYS_IRQ_STATUS		0x0006
> +#define AC200_SYS_CLK_CTL		0x0008
> +#define AC200_SYS_DLDO_OSC_CTL		0x000A
> +#define AC200_SYS_PLL_CTL0		0x000C
> +#define AC200_SYS_PLL_CTL1		0x000E
> +#define AC200_SYS_AUDIO_CTL0		0x0010
> +#define AC200_SYS_AUDIO_CTL1		0x0012
> +#define AC200_SYS_EPHY_CTL0		0x0014
> +#define AC200_SYS_EPHY_CTL1		0x0016
> +#define AC200_SYS_TVE_CTL0		0x0018
> +#define AC200_SYS_TVE_CTL1		0x001A
> +
> +/* Audio Codec registers */
> +#define AC200_AC_SYS_CLK_CTL		0x2000
> +#define AC200_SYS_MOD_RST		0x2002
> +#define AC200_SYS_SAMP_CTL		0x2004
> +#define AC200_I2S_CTL			0x2100
> +#define AC200_I2S_CLK			0x2102
> +#define AC200_I2S_FMT0			0x2104
> +#define AC200_I2S_FMT1			0x2108
> +#define AC200_I2S_MIX_SRC		0x2114
> +#define AC200_I2S_MIX_GAIN		0x2116
> +#define AC200_I2S_DACDAT_DVC		0x2118
> +#define AC200_I2S_ADCDAT_DVC		0x211A
> +#define AC200_AC_DAC_DPC		0x2200
> +#define AC200_AC_DAC_MIX_SRC		0x2202
> +#define AC200_AC_DAC_MIX_GAIN		0x2204
> +#define AC200_DACA_OMIXER_CTRL		0x2220
> +#define AC200_OMIXER_SR			0x2222
> +#define AC200_LINEOUT_CTRL		0x2224
> +#define AC200_AC_ADC_DPC		0x2300
> +#define AC200_MBIAS_CTRL		0x2310
> +#define AC200_ADC_MIC_CTRL		0x2320
> +#define AC200_ADCMIXER_SR		0x2322
> +#define AC200_ANALOG_TUNING0		0x232A
> +#define AC200_ANALOG_TUNING1		0x232C
> +#define AC200_AC_AGC_SEL		0x2480
> +#define AC200_ADC_DAPLCTRL		0x2500
> +#define AC200_ADC_DAPRCTRL		0x2502
> +#define AC200_ADC_DAPLSTA		0x2504
> +#define AC200_ADC_DAPRSTA		0x2506
> +#define AC200_ADC_DAPLTL		0x2508
> +#define AC200_ADC_DAPRTL		0x250A
> +#define AC200_ADC_DAPLHAC		0x250C
> +#define AC200_ADC_DAPLLAC		0x250E
> +#define AC200_ADC_DAPRHAC		0x2510
> +#define AC200_ADC_DAPRLAC		0x2512
> +#define AC200_ADC_DAPLDT		0x2514
> +#define AC200_ADC_DAPLAT		0x2516
> +#define AC200_ADC_DAPRDT		0x2518
> +#define AC200_ADC_DAPRAT		0x251A
> +#define AC200_ADC_DAPNTH		0x251C
> +#define AC200_ADC_DAPLHNAC		0x251E
> +#define AC200_ADC_DAPLLNAC		0x2520
> +#define AC200_ADC_DAPRHNAC		0x2522
> +#define AC200_ADC_DAPRLNAC		0x2524
> +#define AC200_AC_DAPHHPFC		0x2526
> +#define AC200_AC_DAPLHPFC		0x2528
> +#define AC200_AC_DAPOPT			0x252A
> +#define AC200_AC_DAC_DAPCTRL		0x3000
> +#define AC200_AC_DRC_HHPFC		0x3002
> +#define AC200_AC_DRC_LHPFC		0x3004
> +#define AC200_AC_DRC_CTRL		0x3006
> +#define AC200_AC_DRC_LPFHAT		0x3008
> +#define AC200_AC_DRC_LPFLAT		0x300A
> +#define AC200_AC_DRC_RPFHAT		0x300C
> +#define AC200_AC_DRC_RPFLAT		0x300E
> +#define AC200_AC_DRC_LPFHRT		0x3010
> +#define AC200_AC_DRC_LPFLRT		0x3012
> +#define AC200_AC_DRC_RPFHRT		0x3014
> +#define AC200_AC_DRC_RPFLRT		0x3016
> +#define AC200_AC_DRC_LRMSHAT		0x3018
> +#define AC200_AC_DRC_LRMSLAT		0x301A
> +#define AC200_AC_DRC_RRMSHAT		0x301C
> +#define AC200_AC_DRC_RRMSLAT		0x301E
> +#define AC200_AC_DRC_HCT		0x3020
> +#define AC200_AC_DRC_LCT		0x3022
> +#define AC200_AC_DRC_HKC		0x3024
> +#define AC200_AC_DRC_LKC		0x3026
> +#define AC200_AC_DRC_HOPC		0x3028
> +#define AC200_AC_DRC_LOPC		0x302A
> +#define AC200_AC_DRC_HLT		0x302C
> +#define AC200_AC_DRC_LLT		0x302E
> +#define AC200_AC_DRC_HKI		0x3030
> +#define AC200_AC_DRC_LKI		0x3032
> +#define AC200_AC_DRC_HOPL		0x3034
> +#define AC200_AC_DRC_LOPL		0x3036
> +#define AC200_AC_DRC_HET		0x3038
> +#define AC200_AC_DRC_LET		0x303A
> +#define AC200_AC_DRC_HKE		0x303C
> +#define AC200_AC_DRC_LKE		0x303E
> +#define AC200_AC_DRC_HOPE		0x3040
> +#define AC200_AC_DRC_LOPE		0x3042
> +#define AC200_AC_DRC_HKN		0x3044
> +#define AC200_AC_DRC_LKN		0x3046
> +#define AC200_AC_DRC_SFHAT		0x3048
> +#define AC200_AC_DRC_SFLAT		0x304A
> +#define AC200_AC_DRC_SFHRT		0x304C
> +#define AC200_AC_DRC_SFLRT		0x304E
> +#define AC200_AC_DRC_MXGHS		0x3050
> +#define AC200_AC_DRC_MXGLS		0x3052
> +#define AC200_AC_DRC_MNGHS		0x3054
> +#define AC200_AC_DRC_MNGLS		0x3056
> +#define AC200_AC_DRC_EPSHC		0x3058
> +#define AC200_AC_DRC_EPSLC		0x305A
> +#define AC200_AC_DRC_HPFHGAIN		0x305E
> +#define AC200_AC_DRC_HPFLGAIN		0x3060
> +#define AC200_AC_DRC_BISTCR		0x3100
> +#define AC200_AC_DRC_BISTST		0x3102
> +
> +/* TVE registers */
> +#define AC200_TVE_CTL0			0x4000
> +#define AC200_TVE_CTL1			0x4002
> +#define AC200_TVE_MOD0			0x4004
> +#define AC200_TVE_MOD1			0x4006
> +#define AC200_TVE_DAC_CFG0		0x4008
> +#define AC200_TVE_DAC_CFG1		0x400A
> +#define AC200_TVE_YC_DELAY		0x400C
> +#define AC200_TVE_YC_FILTER		0x400E
> +#define AC200_TVE_BURST_FRQ0		0x4010
> +#define AC200_TVE_BURST_FRQ1		0x4012
> +#define AC200_TVE_FRONT_PORCH		0x4014
> +#define AC200_TVE_BACK_PORCH		0x4016
> +#define AC200_TVE_TOTAL_LINE		0x401C
> +#define AC200_TVE_FIRST_ACTIVE		0x401E
> +#define AC200_TVE_BLACK_LEVEL		0x4020
> +#define AC200_TVE_BLANK_LEVEL		0x4022
> +#define AC200_TVE_PLUG_EN		0x4030
> +#define AC200_TVE_PLUG_IRQ_EN		0x4032
> +#define AC200_TVE_PLUG_IRQ_STA		0x4034
> +#define AC200_TVE_PLUG_STA		0x4038
> +#define AC200_TVE_PLUG_DEBOUNCE		0x4040
> +#define AC200_TVE_DAC_TEST		0x4042
> +#define AC200_TVE_PLUG_PULSE_LEVEL	0x40F4
> +#define AC200_TVE_PLUG_PULSE_START	0x40F8
> +#define AC200_TVE_PLUG_PULSE_PERIOD	0x40FA
> +#define AC200_TVE_IF_CTL		0x5000
> +#define AC200_TVE_IF_TIM0		0x5008
> +#define AC200_TVE_IF_TIM1		0x500A
> +#define AC200_TVE_IF_TIM2		0x500C
> +#define AC200_TVE_IF_TIM3		0x500E
> +#define AC200_TVE_IF_SYNC0		0x5010
> +#define AC200_TVE_IF_SYNC1		0x5012
> +#define AC200_TVE_IF_SYNC2		0x5014
> +#define AC200_TVE_IF_TIM4		0x5016
> +#define AC200_TVE_IF_STATUS		0x5018
> +
> +/* EPHY registers */
> +#define AC200_EPHY_CTL			0x6000
> +#define AC200_EPHY_BIST			0x6002
> +
> +/* eFuse registers (0x8000 - 0x9FFF, layout unknown) */
> +
> +/* RTC registers */
> +#define AC200_LOSC_CTRL0		0xA000
> +#define AC200_LOSC_CTRL1		0xA002
> +#define AC200_LOSC_AUTO_SWT_STA		0xA004
> +#define AC200_INTOSC_CLK_PRESCAL	0xA008
> +#define AC200_RTC_YY_MM_DD0		0xA010
> +#define AC200_RTC_YY_MM_DD1		0xA012
> +#define AC200_RTC_HH_MM_SS0		0xA014
> +#define AC200_RTC_HH_MM_SS1		0xA016
> +#define AC200_ALARM0_CUR_VLU0		0xA024
> +#define AC200_ALARM0_CUR_VLU1		0xA026
> +#define AC200_ALARM0_ENABLE		0xA028
> +#define AC200_ALARM0_IRQ_EN		0xA02C
> +#define AC200_ALARM0_IRQ_STA		0xA030
> +#define AC200_ALARM1_WK_HH_MM_SS0	0xA040
> +#define AC200_ALARM1_WK_HH_MM_SS1	0xA042
> +#define AC200_ALARM1_ENABLE		0xA044
> +#define AC200_ALARM1_IRQ_EN		0xA048
> +#define AC200_ALARM1_IRQ_STA		0xA04C
> +#define AC200_ALARM_CONFIG		0xA050
> +#define AC200_LOSC_OUT_GATING		0xA060
> +#define AC200_GP_DATA(x)		(0xA100 + (x) * 2)
> +#define AC200_RTC_DEB			0xA170
> +#define AC200_GPL_HOLD_OUTPUT		0xA180
> +#define AC200_VDD_RTC			0xA190
> +#define AC200_IC_CHARA0			0xA1F0
> +#define AC200_IC_CHARA1			0xA1F2
> +
> +struct ac200_dev {
> +	struct clk			*clk;
> +	struct regmap			*regmap;
> +	struct regmap_irq_chip_data	*regmap_irqc;
> +};
> +
> +#endif /* __LINUX_MFD_AC200_H */

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
