Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD88D1A6B31
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgDMRSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732635AbgDMRSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:18:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3894C0A3BDC;
        Mon, 13 Apr 2020 10:18:21 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r26so10761982wmh.0;
        Mon, 13 Apr 2020 10:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aN2QMQIiZ+fbzXx89kWfhruKgWBRabD+TZRiB8Om83o=;
        b=kr4Po8TapDPqfgo9+vMRhLZGS11uCB8r6Nr/qh639YeXFbasmmmcv7HvvImopL+CCT
         hM0fscXSDe1C64zYsDHEyQgmzsv7UeqA0e9/npW83g0zIZQL3H7IQvPem9czu8m1NLZb
         DX0/UmflttKOY93o2nJlw7dNUZEfLZMpV7x2ls0PTN1k8RJKUKROh6A15C/iSFudCqjs
         P8B1dFdfo2uVRwmlrWJ0P+juDq6iqqocQBnxM7tbpZUXKdft232Wr69uGZC765WYL8gy
         q6EnfV+Va3e7XL67z6nuxQWRW2Z9UWiKLSgSwdvMHnukEzOmPHqitX7fCFpUuf6xgAE4
         95ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aN2QMQIiZ+fbzXx89kWfhruKgWBRabD+TZRiB8Om83o=;
        b=VVVZ9YOVmAFfMwbtWNMcndRw5GJzvbpzzQRYZOlPoaLqnJZ8B88uHiOgAXesVrLDL7
         1aEaSo/m3wYOoDs6WKb8tnOsKjf0uORVllaXG93is4+O9vD4BgUWNHMk41iavsj2NyWG
         TfY+6mQQEHJxY3Ln4Hjt+X+6JHXsQXCgzFWKxizhHRmI4veIXtRINNqMIjuHZUvSY77q
         hg53QKl+XrOfnpdjlq+7j6BwB349PPlJGmp7OrSvoEMe5eH84Qltz+uuwkmwMfvsose1
         SA93WLN8q93VZpK1Fy4+FRZx2brOwoUNuowsvgfjyK1Yp21lTHl16YFqxldiTxlaFCws
         TkIw==
X-Gm-Message-State: AGi0PuaWxddy9C+2hAEZCZ+F6MGhsimcBwOl9dcnKxuxPS1oF67eLUUN
        qeR+pczrRKyAAcyIiteQuap/K74j
X-Google-Smtp-Source: APiQypJP9/nTIk6E1eY6hBX6IjFs+1I7vAIgou3RoTK6/JqTTcTgQrO/3xDrVBpzBORS1iWYL2gBZA==
X-Received: by 2002:a1c:e242:: with SMTP id z63mr18705439wmg.184.1586798298947;
        Mon, 13 Apr 2020 10:18:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:ecd0:ef61:dfee:4535? (p200300EA8F296000ECD0EF61DFEE4535.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ecd0:ef61:dfee:4535])
        by smtp.googlemail.com with ESMTPSA id x132sm10968002wmg.33.2020.04.13.10.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 10:18:18 -0700 (PDT)
Subject: Re: [PATCH 1/3] net: phy: mdio: add IPQ40xx MDIO driver
To:     Robert Marko <robert.marko@sartura.hr>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
References: <20200413170107.246509-1-robert.marko@sartura.hr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <787129c5-f711-5f85-9306-35fb93c68d7b@gmail.com>
Date:   Mon, 13 Apr 2020 19:18:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200413170107.246509-1-robert.marko@sartura.hr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2020 19:01, Robert Marko wrote:
> This patch adds the driver for the MDIO interface
> inside of Qualcomm IPQ40xx series SoC-s.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>
> ---
>  drivers/net/phy/Kconfig        |   7 ++
>  drivers/net/phy/Makefile       |   1 +
>  drivers/net/phy/mdio-ipq40xx.c | 180 +++++++++++++++++++++++++++++++++
>  3 files changed, 188 insertions(+)
>  create mode 100644 drivers/net/phy/mdio-ipq40xx.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 9dabe03a668c..614d08635012 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -157,6 +157,13 @@ config MDIO_I2C
>  
>  	  This is library mode.
>  
> +config MDIO_IPQ40XX
> +	tristate "Qualcomm IPQ40xx MDIO interface"
> +	depends on HAS_IOMEM && OF
> +	help
> +	  This driver supports the MDIO interface found in Qualcomm
> +	  IPQ40xx series Soc-s.
> +
>  config MDIO_MOXART
>  	tristate "MOXA ART MDIO interface support"
>  	depends on ARCH_MOXART || COMPILE_TEST
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index fe5badf13b65..c89fc187fd74 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
>  obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
>  obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
>  obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
> +obj-$(CONFIG_MDIO_IPQ40XX)	+= mdio-ipq40xx.o
>  obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
>  obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
> diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> new file mode 100644
> index 000000000000..8068f1e6a077
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq40xx.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define MDIO_CTRL_0_REG		0x40
> +#define MDIO_CTRL_1_REG		0x44
> +#define MDIO_CTRL_2_REG		0x48
> +#define MDIO_CTRL_3_REG		0x4c
> +#define MDIO_CTRL_4_REG		0x50
> +#define MDIO_CTRL_4_ACCESS_BUSY		BIT(16)
> +#define MDIO_CTRL_4_ACCESS_START		BIT(8)
> +#define MDIO_CTRL_4_ACCESS_CODE_READ		0
> +#define MDIO_CTRL_4_ACCESS_CODE_WRITE	1
> +#define CTRL_0_REG_DEFAULT_VALUE	0x150FF
> +
> +#define IPQ40XX_MDIO_RETRY	1000
> +#define IPQ40XX_MDIO_DELAY	10
> +
> +struct ipq40xx_mdio_data {
> +	struct mii_bus	*mii_bus;
> +	void __iomem	*membase;
> +	struct device	*dev;
> +};
> +
> +static int ipq40xx_mdio_wait_busy(struct ipq40xx_mdio_data *am)
> +{
> +	int i;
> +
> +	for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
> +		unsigned int busy;
> +
> +		busy = readl(am->membase + MDIO_CTRL_4_REG) &
> +			MDIO_CTRL_4_ACCESS_BUSY;
> +		if (!busy)
> +			return 0;
> +
> +		/* BUSY might take to be cleard by 15~20 times of loop */
> +		udelay(IPQ40XX_MDIO_DELAY);
> +	}
> +
> +	dev_err(am->dev, "%s: MDIO operation timed out\n", am->mii_bus->name);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +{
> +	struct ipq40xx_mdio_data *am = bus->priv;
> +	int value = 0;
> +	unsigned int cmd = 0;
> +
> +	lockdep_assert_held(&bus->mdio_lock);
> +
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
> +
> +	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_READ;
> +
> +	/* issue read command */
> +	writel(cmd, am->membase + MDIO_CTRL_4_REG);
> +
> +	/* Wait read complete */
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	/* Read data */
> +	value = readl(am->membase + MDIO_CTRL_3_REG);
> +
> +	return value;
> +}
> +
> +static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> +							 u16 value)
> +{
> +	struct ipq40xx_mdio_data *am = bus->priv;
> +	unsigned int cmd = 0;
> +
> +	lockdep_assert_held(&bus->mdio_lock);
> +
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
> +
> +	/* issue write data */
> +	writel(value, am->membase + MDIO_CTRL_2_REG);
> +
> +	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_WRITE;
> +	/* issue write command */
> +	writel(cmd, am->membase + MDIO_CTRL_4_REG);
> +
> +	/* Wait write complete */
> +	if (ipq40xx_mdio_wait_busy(am))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static int ipq40xx_mdio_probe(struct platform_device *pdev)
> +{
> +	struct ipq40xx_mdio_data *am;
> +	struct resource *res;
> +
> +	am = devm_kzalloc(&pdev->dev, sizeof(*am), GFP_KERNEL);
> +	if (!am)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no iomem resource found\n");
> +		return -ENXIO;
> +	}
> +
> +	am->membase = devm_ioremap_resource(&pdev->dev, res);

You can use devm_platform_ioremap_resource() here.

> +	if (IS_ERR(am->membase)) {
> +		dev_err(&pdev->dev, "unable to ioremap registers\n");
> +		return PTR_ERR(am->membase);
> +	}
> +
> +	am->mii_bus = devm_mdiobus_alloc(&pdev->dev);
> +	if (!am->mii_bus)
> +		return  -ENOMEM;
> +

You could use devm_mdiobus_alloc_size() and omit allocating am
separately.

> +	writel(CTRL_0_REG_DEFAULT_VALUE, am->membase + MDIO_CTRL_0_REG);
> +
> +	am->mii_bus->name = "ipq40xx_mdio";
> +	am->mii_bus->read = ipq40xx_mdio_read;
> +	am->mii_bus->write = ipq40xx_mdio_write;
> +	am->mii_bus->priv = am;
> +	am->mii_bus->parent = &pdev->dev;
> +	snprintf(am->mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(&pdev->dev));
> +
> +	am->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, am);
> +
> +	return of_mdiobus_register(am->mii_bus, pdev->dev.of_node);
> +}
> +
> +static int ipq40xx_mdio_remove(struct platform_device *pdev)
> +{
> +	struct ipq40xx_mdio_data *am = platform_get_drvdata(pdev);
> +
> +	mdiobus_unregister(am->mii_bus);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ipq40xx_mdio_dt_ids[] = {
> +	{ .compatible = "qcom,ipq40xx-mdio" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ipq40xx_mdio_dt_ids);
> +
> +static struct platform_driver ipq40xx_mdio_driver = {
> +	.probe = ipq40xx_mdio_probe,
> +	.remove = ipq40xx_mdio_remove,
> +	.driver = {
> +		.name = "ipq40xx-mdio",
> +		.of_match_table = ipq40xx_mdio_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(ipq40xx_mdio_driver);
> +
> +MODULE_DESCRIPTION("IPQ40XX MDIO interface driver");
> +MODULE_AUTHOR("Qualcomm Atheros");
> +MODULE_LICENSE("Dual BSD/GPL");
> 

