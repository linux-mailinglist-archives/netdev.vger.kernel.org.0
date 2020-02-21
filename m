Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A43167F6D
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgBUN7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:59:03 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43683 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUN7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 08:59:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so2179850wrq.10;
        Fri, 21 Feb 2020 05:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=QCTQpeQR9EFmH5Ixz+DSqWseXJrj40CO/WB+i18jAhE=;
        b=aGh1XZNB9jKNpkNpAnPJitvAoOyq37luweD9DoRP3fGjxQnYgkfWyUY0TxPwib1Iod
         CdWPFAspqTwqcCTyxYOu/3kPljqp4xb69Hc+zll4eAb+e3D9ryRGLExcLflpqYX6x5z6
         KFLl8BQaTYeoFCt2+oWQXqF6kbuQVYPJxbZvze4g9gtHF5ZAaHNyftTo6vMKsK/W7gXP
         JOgWhNcJPPw+fBlb4QB0ZfW0UxJEDVysCKcziaNkRyott2Vn9o6cgcF+u1Uc2R0nKQHt
         twe4rcZUF14fqIXyJglj01TyAVsKLhslLkHhqsaJAXLsYt6U14Mn13NjJFg9re3YD8Eb
         y4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=QCTQpeQR9EFmH5Ixz+DSqWseXJrj40CO/WB+i18jAhE=;
        b=X7sovSFD3Yy2X/ijeEGo3J4jn2GWpQaCYimMZlw1799q53b5w/m1LDSGE4m2g58jO1
         Xbxbiohyv9YfhkZ3mAYBaPZ4wXdf4f+aoa7zOxW/ZWoSrEwFGOQm7SJ5gz53RbOTPsjb
         ywI5QaVZ7nyz27r9m1yRD0EOJjNMcG0NBiGq59dVbfpI555Us737nmCuJcs7stIZYRkX
         HIbHresOxUiXEpbkynTkusQJK5/H//hbN6ndScVnDZYPwoa9uodHLx/pJvoEogg9tHbO
         yOkSDr3FnBthpq+r/mn0A9rdk9M2NJgmmqZKmhEXAdO9/7ipZuUJsbbgr1knms9j7oyc
         0a+Q==
X-Gm-Message-State: APjAAAUZpafUvqn2KvxedtRijeUQ0DTp8kZw9koqX3ILso6nahGuhfSs
        htRkzefoPuci/6l7iUr84K4=
X-Google-Smtp-Source: APXvYqxtjWkAR3NrBTvql+K7iEH5P9GKiAYvJB85FR4aQSJcC+d8lGU2B+sNzarRQkO8AVAF6XFj+Q==
X-Received: by 2002:a5d:69cf:: with SMTP id s15mr21536663wrw.184.1582293540132;
        Fri, 21 Feb 2020 05:59:00 -0800 (PST)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id q10sm3985660wme.16.2020.02.21.05.58.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Feb 2020 05:58:59 -0800 (PST)
From:   <ansuelsmth@gmail.com>
To:     "'Russell King - ARM Linux admin'" <linux@armlinux.org.uk>
Cc:     "'Andy Gross'" <agross@kernel.org>,
        "'Bjorn Andersson'" <bjorn.andersson@linaro.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200221132834.20719-1-ansuelsmth@gmail.com> <20200221135325.GI25745@shell.armlinux.org.uk>
In-Reply-To: <20200221135325.GI25745@shell.armlinux.org.uk>
Subject: R: [PATCH v4 1/2] net: mdio: add ipq8064 mdio driver
Date:   Fri, 21 Feb 2020 14:58:55 +0100
Message-ID: <006d01d5e8bf$0f02ffb0$2d08ff10$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: it
Thread-Index: AQHAUcxL/1P9swnLMFfb54l88twcFAICFiORqEDI+3A=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Feb 21, 2020 at 02:28:31PM +0100, Ansuel Smith wrote:
> > Currently ipq806x soc use generi bitbang driver to
> > comunicate with the gmac ethernet interface.
> > Add a dedicated driver created by chunkeey to fix this.
> >
> > Christian Lamparter <chunkeey@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/phy/Kconfig        |   8 ++
> >  drivers/net/phy/Makefile       |   1 +
> >  drivers/net/phy/mdio-ipq8064.c | 166
> +++++++++++++++++++++++++++++++++
> >  3 files changed, 175 insertions(+)
> >  create mode 100644 drivers/net/phy/mdio-ipq8064.c
> >
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 9dabe03a668c..ec2a5493a7e8 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -157,6 +157,14 @@ config MDIO_I2C
> >
> >  	  This is library mode.
> >
> > +config MDIO_IPQ8064
> > +	tristate "Qualcomm IPQ8064 MDIO interface support"
> > +	depends on HAS_IOMEM && OF_MDIO
> > +	depends on MFD_SYSCON
> > +	help
> > +	  This driver supports the MDIO interface found in the network
> > +	  interface units of the IPQ8064 SoC
> > +
> >  config MDIO_MOXART
> >  	tristate "MOXA ART MDIO interface support"
> >  	depends on ARCH_MOXART || COMPILE_TEST
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index fe5badf13b65..8f02bd2089f3 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-
> cavium.o
> >  obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
> >  obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
> >  obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
> > +obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
> >  obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
> >  obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
> >  obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
> > diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/phy/mdio-
> ipq8064.c
> > new file mode 100644
> > index 000000000000..fd856b798194
> > --- /dev/null
> > +++ b/drivers/net/phy/mdio-ipq8064.c
> > @@ -0,0 +1,166 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +//
> > +// Qualcomm IPQ8064 MDIO interface driver
> > +//
> > +// Copyright (C) 2019 Christian Lamparter <chunkeey@gmail.com>
> > +
> > +#include <linux/delay.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/syscon.h>
> > +
> > +/* MII address register definitions */
> > +#define MII_ADDR_REG_ADDR                       0x10
> > +#define MII_BUSY                                BIT(0)
> > +#define MII_WRITE                               BIT(1)
> > +#define MII_CLKRANGE_60_100M                    (0 << 2)
> > +#define MII_CLKRANGE_100_150M                   (1 << 2)
> > +#define MII_CLKRANGE_20_35M                     (2 << 2)
> > +#define MII_CLKRANGE_35_60M                     (3 << 2)
> > +#define MII_CLKRANGE_150_250M                   (4 << 2)
> > +#define MII_CLKRANGE_250_300M                   (5 << 2)
> > +#define MII_CLKRANGE_MASK			GENMASK(4, 2)
> > +#define MII_REG_SHIFT				6
> > +#define MII_REG_MASK				GENMASK(10, 6)
> > +#define MII_ADDR_SHIFT				11
> > +#define MII_ADDR_MASK				GENMASK(15, 11)
> > +
> > +#define MII_DATA_REG_ADDR                       0x14
> > +
> > +#define MII_MDIO_DELAY                          (1000)
> > +#define MII_MDIO_RETRY                          (10)
> 
> You've missed my comments on these.
> 
> > +
> > +struct ipq8064_mdio {
> > +	struct regmap *base; /* NSS_GMAC0_BASE */
> > +};
> > +
> > +static int
> > +ipq8064_mdio_wait_busy(struct ipq8064_mdio *priv)
> > +{
> > +	u32 busy;
> > +
> > +	return regmap_read_poll_timeout(priv->base,
> MII_ADDR_REG_ADDR, busy,
> > +				   !(busy & MII_BUSY), MII_MDIO_DELAY,
> > +				   MII_MDIO_RETRY * USEC_PER_MSEC);
> > +}
> > +
> > +static int
> > +ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
> > +{
> > +	struct ipq8064_mdio *priv = bus->priv;
> > +	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
> > +	u32 ret_val;
> > +	int err;
> > +
> > +	/* Reject clause 45 */
> > +	if (reg_offset & MII_ADDR_C45)
> > +		return -EOPNOTSUPP;
> > +
> > +	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> > +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> > +
> > +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> > +	usleep_range(10, 20);
> > +
> > +	err = ipq8064_mdio_wait_busy(priv);
> > +	if (err)
> > +		return err;
> > +
> > +	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
> > +	return (int)ret_val;
> > +}
> > +
> > +static int
> > +ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset,
> u16 data)
> > +{
> > +	struct ipq8064_mdio *priv = bus->priv;
> > +	u32 miiaddr = MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
> > +
> > +	/* Reject clause 45 */
> > +	if (reg_offset & MII_ADDR_C45)
> > +		return -EOPNOTSUPP;
> > +
> > +	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
> > +
> > +	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> > +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> > +
> > +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> > +	usleep_range(10, 20);
> > +
> > +	return ipq8064_mdio_wait_busy(priv);
> > +}
> > +
> > +static int
> > +ipq8064_mdio_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct ipq8064_mdio *priv;
> > +	struct mii_bus *bus;
> > +	int ret;
> > +
> > +	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> > +	if (!bus)
> > +		return -ENOMEM;
> > +
> > +	bus->name = "ipq8064_mdio_bus";
> > +	bus->read = ipq8064_mdio_read;
> > +	bus->write = ipq8064_mdio_write;
> > +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev-
> >dev));
> > +	bus->parent = &pdev->dev;
> > +
> > +	priv = bus->priv;
> > +	priv->base = syscon_node_to_regmap(np);
> > +	if (IS_ERR(priv->base) && priv->base != ERR_PTR(-EPROBE_DEFER))
> > +		priv->base = syscon_regmap_lookup_by_phandle(np,
> "master");
> > +
> > +	if (priv->base == ERR_PTR(-EPROBE_DEFER)) {
> > +		return -EPROBE_DEFER;
> > +	} else if (IS_ERR(priv->base)) {
> > +		dev_err(&pdev->dev, "error getting syscon regmap,
> error=%ld\n",
> > +			PTR_ERR(priv->base));
> 
> Why not %pe as I suggested, which is documented in printk-formats to
> optionally give a symbolic error string.
> 
I thought that print the error code was better than error=(ptrval)
If I need to follow the documentation then sorry, I will restore %pe
> > +		return PTR_ERR(priv->base);
> > +	}
> 
> And have you even tested the above - you haven't said whether you have
> or not...
> 
Yes I tested the changes, it does errors correctly.
> > +
> > +	ret = of_mdiobus_register(bus, np);
> > +	if (ret)
> > +		return ret;
> > +
> > +	platform_set_drvdata(pdev, bus);
> > +	return 0;
> > +}
> > +
> > +static int
> > +ipq8064_mdio_remove(struct platform_device *pdev)
> > +{
> > +	struct mii_bus *bus = platform_get_drvdata(pdev);
> > +
> > +	mdiobus_unregister(bus);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id ipq8064_mdio_dt_ids[] = {
> > +	{ .compatible = "qcom,ipq8064-mdio" },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, ipq8064_mdio_dt_ids);
> > +
> > +static struct platform_driver ipq8064_mdio_driver = {
> > +	.probe = ipq8064_mdio_probe,
> > +	.remove = ipq8064_mdio_remove,
> > +	.driver = {
> > +		.name = "ipq8064-mdio",
> > +		.of_match_table = ipq8064_mdio_dt_ids,
> > +	},
> > +};
> > +
> > +module_platform_driver(ipq8064_mdio_driver);
> > +
> > +MODULE_DESCRIPTION("Qualcomm IPQ8064 MDIO interface driver");
> > +MODULE_AUTHOR("Christian Lamparter <chunkeey@gmail.com>");
> > +MODULE_LICENSE("GPL");
> > --
> > 2.25.0
> >
> >
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down
> 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

