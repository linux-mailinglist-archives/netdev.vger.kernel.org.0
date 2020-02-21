Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A285F166C1A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgBUAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:49:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53715 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729365AbgBUAtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:49:24 -0500
Received: by mail-wm1-f68.google.com with SMTP id s10so454899wmh.3;
        Thu, 20 Feb 2020 16:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=TUpgFvCUo1t8bKlaum1Vfawy9XPhXrFVUMDpr7fMy/0=;
        b=k50Fxfzuub5Of7FhShXrOIA/2Kv26wvdhFm0NWbcqJ0k4gJPdZwB4aY1owcwbOXk2+
         0TQmj0U9syBQ/COVozIYPUGn8xF+mfL+cVgM1MpPlTv6HZRWaWG+cdO9ootXzbXqZYC9
         1t0BLM4uLdxpyTT2DdeLVB1ozGDFKD/ALDLrLkuww9L3afat1uaW7nrDPPXPiw5Ziu6w
         OTLc2h1uSlzsWcNYXAvy2RxRSEkVY3pVUYY6ZniYL1EZ7FfAfK8IcGJkj4FfgxBRynbQ
         /BjzCSGa8E4J/cu3O9Hpl4ICKImh+gCF4teZ5SQtDlJx4gHQoXvNYpHHMxcptdN+QdwZ
         cI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=TUpgFvCUo1t8bKlaum1Vfawy9XPhXrFVUMDpr7fMy/0=;
        b=obxMY5gdEBq7jRS2e6t5i/A9RFwJ2DaB4tOp/vg69Vew2R9Y9mSX27fHrzaWNyYm8Q
         bWzzuLVEgmUKlUAofh3I9eQZ63cTi/kHkJKDrm2oZX9bX8kUCCWqGp9ptprLNis8abJK
         8Dx40/5bnLy2cXaoZPaWb2k2sEsUlwTOlSDl/nnrW9cvrv2DnkTlWJHg0Xzz6zpuMo11
         lUSPMruqUpBf1Y0vWcp5E41dOpj37TLHDdAvBGtmVEoQsr7sz+SnzWWretqGWG9Z+GW2
         J+7EVyw55Ew9D9Bg0SHJzFpP3eeg66fsoEj/9+dN2Z+wkusoJIExvk3zLnj5oKb+qu/y
         JxTQ==
X-Gm-Message-State: APjAAAVZfeCJxyPPLS/kYk2JixrQ+hlm/rPM1iK/SPAbJzO+UUWvsatV
        N5gKLLtacrXD37GGxQrxWZ2Z2PfdG7U=
X-Google-Smtp-Source: APXvYqwj21jD0rPT6EwGXCZyPPi39P5w9BN875IX6Nxot00sxfue3FdwlmbscFUmUaKOv9J3ior7pg==
X-Received: by 2002:a05:600c:218b:: with SMTP id e11mr7401006wme.56.1582246161826;
        Thu, 20 Feb 2020 16:49:21 -0800 (PST)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id c9sm1694064wrq.44.2020.02.20.16.49.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 16:49:21 -0800 (PST)
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
References: <20200220232624.7001-1-ansuelsmth@gmail.com> <20200221004013.GF25745@shell.armlinux.org.uk>
In-Reply-To: <20200221004013.GF25745@shell.armlinux.org.uk>
Subject: R: [PATCH v3 1/2] net: mdio: add ipq8064 mdio driver
Date:   Fri, 21 Feb 2020 01:49:17 +0100
Message-ID: <000601d5e850$c0161cc0$40425640$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQC5BnfVD9qIQfuabKNYdaQfon7jHAE69gxCqlS7flA=
Content-Language: it
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Feb 21, 2020 at 12:26:21AM +0100, Ansuel Smith wrote:
> > Currently ipq806x soc use generi bitbang driver to
> > comunicate with the gmac ethernet interface.
> > Add a dedicated driver created by chunkeey to fix this.
> >
> > Christian Lamparter <chunkeey@gmail.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/phy/Kconfig        |   8 ++
> >  drivers/net/phy/Makefile       |   1 +
> >  drivers/net/phy/mdio-ipq8064.c | 163
> +++++++++++++++++++++++++++++++++
> >  3 files changed, 172 insertions(+)
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
> > index 000000000000..e974a6f5d5ef
> > --- /dev/null
> > +++ b/drivers/net/phy/mdio-ipq8064.c
> > @@ -0,0 +1,163 @@
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
> 
> Maybe name this MII_MDIO_DELAY_USEC to show that it is in
> microseconds?
> 
> > +#define MII_MDIO_RETRY                          (10)
> 
> Maybe name this MII_MDIO_RETRY_MSEC to show that it is in
> milliseconds?
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
> 
> Thanks.
> 
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
> 
> Thanks.
> 
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
> 
> Thanks.
> 
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
> > +	if (IS_ERR_OR_NULL(priv->base)) {
> > +		priv->base = syscon_regmap_lookup_by_phandle(np,
> "master");
> > +		if (IS_ERR_OR_NULL(priv->base)) {
> > +			dev_err(&pdev->dev, "master phandle not
> found\n");
> > +			return -EINVAL;
> > +		}
> > +	}
> 
> I'm curious why you've kept this as-is given my comments?
> 
> If you don't agree with them, it would be helpful to reply to the
> review email giving the reasons why.
> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down
> 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
I hope it's not a problem if I answer here.
I read your command and now I understand what you mean. Since they both
never return NULL the IS_ERR_OR_NULL is wrong and only IS_ERR should be
used. Correct me if I'm wrong.
About the error propagation, should I return the
syscon_regmap_lookup_by_phandle
error or I can keep the EINVAL error? 

