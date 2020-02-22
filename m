Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91ED16925F
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 00:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgBVXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 18:47:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36983 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgBVXrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 18:47:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id a6so5660169wme.2;
        Sat, 22 Feb 2020 15:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3NLOKNuy3wOlKfDFx23/tDNafjli/SnJXKzCIElhmy0=;
        b=U/Rh4RRzcb8tY1cEJJ1T+DICzXvhtSGmYZGmUwMsDs4Bgz8zkc0zBAWuz8CMsAiKDk
         +upUtaj1bq0Sv+hd+yIAz0BawQj53DPmS61Ik+TSRH5jUI2hZHihrXr+tW1IXfjrf6Mp
         Xo5pRkiXFNBoU44atvYpaFZx+qU0wqa20SYMDHIhqgGJBnLKQVhZ8jjVcFr1LhD2tRbT
         8Y2JU9X36sCyXCoA+vRbM5kwTJCXsYv0St8BZfIY6qQMVyvI7QAUatHm51h5VkEX3A5X
         AifOqJumE9JCINt6W5q+fUfto3e8iF8Au+LSXgzkqV0uL+bQf2N7X4nU9kzGaNWEvZ+K
         YhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3NLOKNuy3wOlKfDFx23/tDNafjli/SnJXKzCIElhmy0=;
        b=a60lZYr7vll4cPUYB5eNb3IgfOtwsW71N53CbFyiJC0NP+5hYEw8VxAKpMt7H0oMIo
         ZM1T0i+AkZ129OEKzlkWtZCwq3j45h+2/wVOh+XQOE2T+VJuG3gn2SXYvjIIMv9WTX3D
         K5zM+Y7LoCCdvYDTsFHFADOTBiGzRE3F9ACfmujsN8+wz8vgNbqaHW4MzsQsOD7hYx5T
         +mJWYKTGggwe8kcoubRbjZOj2z0QxuheXptVxf+diTdhhgNq0pUwJJ7rwudbbmwG9fUv
         t1smooS9VJ6EtM9wN7fhedwkDR4MzDk1kdx68VB6Lsu89f7X4Jddlxk281ykImc2KcW2
         6YQA==
X-Gm-Message-State: APjAAAXB8B0I0qaArcf1uLxV5SEoynZDVfTMV9lMEWxjEElhQdiNnn/o
        RwLCy8C2/hxjmm+AfsKc8vg=
X-Google-Smtp-Source: APXvYqy2FFh037CfHljHCxw+h+qk9cVQiaBhO4c15GfY3LprPQwlAVx3YjqZ70WYga7e9oxvUR0cPg==
X-Received: by 2002:a1c:7512:: with SMTP id o18mr7791919wmc.110.1582415262627;
        Sat, 22 Feb 2020 15:47:42 -0800 (PST)
Received: from debian64.daheim (p5B0D74C0.dip0.t-ipconnect.de. [91.13.116.192])
        by smtp.gmail.com with ESMTPSA id u62sm10958245wmu.17.2020.02.22.15.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 15:47:41 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.93)
        (envelope-from <chunkeey@gmail.com>)
        id 1j5eUm-0005nV-Ns; Sun, 23 Feb 2020 00:47:40 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] net: mdio: add ipq8064 mdio driver
Date:   Sun, 23 Feb 2020 00:47:40 +0100
Message-ID: <4475595.vek7CkyBFf@debian64>
In-Reply-To: <20200222161629.1862-1-ansuelsmth@gmail.com>
References: <20200222161629.1862-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Saturday, 22 February 2020 17:16:26 CET Mr. Smith wrote:
> Currently ipq806x soc use generic bitbang driver to
> comunicate with the gmac ethernet interface.
> Add a dedicated driver created by chunkeey to fix this.

Ok, I'm officially a bit "out-of-the-loop" here (was looking for
a changelog, but I guess I missed that mail). So please excuse me,
if I say something that was already stated. Instead kindly reply
with a text extract (preferably with the link to the mail as I'm not
a regular linux-net subscriber) to that discussion.

> Co-developed-by: Christian Lamparter <chunkeey@gmail.com>
Ahh, I see that
"docs: Clarify the usage and sign-off requirements for Co-developed-by"
did away with the "original author" wording in the submitting-patches doc.
So keeping the original "From:" doesn't matter as such anymore.

Still, for reference (historical digs or if someone wants to take a peek):
Most of this patch comes from a patch named:
700-net-mdio-add-ipq8064-mdio-driver.patch

which is part of a bigger "ipq8064: ipq8064-mdio + dsa test" commit.
This is currently in a staging tree hosted on <git.openwrt.org>.
Here's a direct link: [0] (sadly, this is not self-updating).=20

Background: This driver was mainly written to make and test the qca8k
patches I posted to the linux-net ML last year. The Idea was that I
didn't have to deal with the odd random timing issues on the slow debug
kernels, when I was perfing/hammering the device.=20
(The IPQ8064 has/had various scaling problems so, this might be already
fixed by some of Mr. Smith's other work for the abandoned IPQ8064).

=46rom what I know, this patch mostly helps/fixes a problem with the
out-of-tree OpenWrt swconfig-based ar8216/ar8236 driver for the
used QCA8337 switch.
This driver really needs the faster, more efficient reads due to having
a statistics worker which is just gobbing cycles because of all the
exclusive-access bit-banging taking place.
(Remember, the worker could read all the phy-counters for each of the 7
ports over gpio-mdio (there have been attempts to make it less hoggy
in the mean time though). While the IPQ8064 SoC has a beefy dual-core
Cortex-A15 with up to 1.4GHz*, this bitbanging will result in a
considerable load on at least one of the cores.)

Mr. Smith knows more about this though, as he has the hardware and
is the upcoming IPQ8064 expert on this.=20

=46rom my POV, I never anticipated this hack was up to standards of linux-n=
et.
As there is this ugly dependency on having the "master" MAC (handled by the=
=20
sttmac/dwmac-ipq806x.c) part up and operational all the time (that's why
the "master" property is needed for some devices at least).
=20
I had hopes to do this properly and integrate it into
dwmac-ipq806x.c, but this requires much more work and ultimately
"virtual-mdio" was "just good enough=E2=84=A2=EF=B8=8F" for standard, produ=
ction kernels.
=46rom what I remember the Qualcomm devs themselves never bothered in their
abandoned posts with the DeviceTree for the qcom-ipq8064.dts to include a
standalone mdio driver. Instead the dev went straight to "virtual-mdio".
(but this was too long ago to really remember the details and it's getting =
late)

But Ok, if linux-net is content with the standalone mdio-ipq8064 approach,
then: Sure!

> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 9dabe03a668c..ec2a5493a7e8 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -157,6 +157,14 @@ config MDIO_I2C
> =20
>  	  This is library mode.
> =20
> +config MDIO_IPQ8064
> +	tristate "Qualcomm IPQ8064 MDIO interface support"
> +	depends on HAS_IOMEM && OF_MDIO
> +	depends on MFD_SYSCON
> +	help
> +	  This driver supports the MDIO interface found in the network
> +	  interface units of the IPQ8064 SoC
> +
>  config MDIO_MOXART
>  	tristate "MOXA ART MDIO interface support"
>  	depends on ARCH_MOXART || COMPILE_TEST
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index fe5badf13b65..8f02bd2089f3 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+=3D mdio-cavium.o
>  obj-$(CONFIG_MDIO_GPIO)		+=3D mdio-gpio.o
>  obj-$(CONFIG_MDIO_HISI_FEMAC)	+=3D mdio-hisi-femac.o
>  obj-$(CONFIG_MDIO_I2C)		+=3D mdio-i2c.o
> +obj-$(CONFIG_MDIO_IPQ8064)	+=3D mdio-ipq8064.o
>  obj-$(CONFIG_MDIO_MOXART)	+=3D mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)	+=3D mdio-mscc-miim.o
>  obj-$(CONFIG_MDIO_OCTEON)	+=3D mdio-octeon.o
> diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/phy/mdio-ipq806=
4.c
> new file mode 100644
> index 000000000000..74d6b92a6f48
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq8064.c
> @@ -0,0 +1,166 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//
> +// Qualcomm IPQ8064 MDIO interface driver
> +//
> +// Copyright (C) 2019 Christian Lamparter <chunkeey@gmail.com>
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/syscon.h>
> +
> +/* MII address register definitions */
> +#define MII_ADDR_REG_ADDR                       0x10
> +#define MII_BUSY                                BIT(0)
> +#define MII_WRITE                               BIT(1)
> +#define MII_CLKRANGE_60_100M                    (0 << 2)
> +#define MII_CLKRANGE_100_150M                   (1 << 2)
> +#define MII_CLKRANGE_20_35M                     (2 << 2)
> +#define MII_CLKRANGE_35_60M                     (3 << 2)
> +#define MII_CLKRANGE_150_250M                   (4 << 2)
> +#define MII_CLKRANGE_250_300M                   (5 << 2)
> +#define MII_CLKRANGE_MASK			GENMASK(4, 2)
> +#define MII_REG_SHIFT				6
> +#define MII_REG_MASK				GENMASK(10, 6)
> +#define MII_ADDR_SHIFT				11
> +#define MII_ADDR_MASK				GENMASK(15, 11)
Is it just me, or is something weird going on with tabs vs. spaces here
(and below in ipq8064_mdio_wait_busy() )?

> +
> +#define MII_DATA_REG_ADDR                       0x14
> +
> +#define MII_MDIO_DELAY_USEC                     (1000)
> +#define MII_MDIO_RETRY_MSEC                     (10)
> +
> +struct ipq8064_mdio {
> +	struct regmap *base; /* NSS_GMAC0_BASE */
> +};
> +
> +static int
> +ipq8064_mdio_wait_busy(struct ipq8064_mdio *priv)
> +{
> +	u32 busy;
> +
> +	return regmap_read_poll_timeout(priv->base, MII_ADDR_REG_ADDR, busy,
> +					!(busy & MII_BUSY), MII_MDIO_DELAY_USEC,
> +					MII_MDIO_RETRY_MSEC * USEC_PER_MSEC);
Didn't know this macro existed. This look much nicer.


> +}
> +
> +static int
> +ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
> +{
> +	struct ipq8064_mdio *priv =3D bus->priv;
> +	u32 miiaddr =3D MII_BUSY | MII_CLKRANGE_250_300M;
> +	u32 ret_val;
> +	int err;
> +
> +	/* Reject clause 45 */
> +	if (reg_offset & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
Heh, C45 on IPQ806X? Ok, anyone know the hardware or is this some fancy
forward-thinking future-proofing?
(So it this will not break in the future. Not that the SoC of the
ipq8064 could more than 1GBit/s per port from what I know.)

> +
> +	miiaddr |=3D ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> +
> +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> +	usleep_range(10, 20);
Yeeah, this looks a bit different. I did measure with a for-loop how many
udelay(1); a operation took. I can't remember the exact values (I think it
was "8", so the "
	SLEEPING FOR "A FEW" USECS ( < ~10us? ):
		* Use udelay" from the timers-howto.txt applies, right?

But I know that "8" (again, 8 is the stand-in value) would seemed
too bike-sheddy... And looks like it was since this got changed.

> +
> +	err =3D ipq8064_mdio_wait_busy(priv);
> +	if (err)
> +		return err;
> +
> +	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
> +	return (int)ret_val;
> +}
> +
> +static int
> +ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u1=
6 data)
> +{
> +	struct ipq8064_mdio *priv =3D bus->priv;
> +	u32 miiaddr =3D MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
> +
> +	/* Reject clause 45 */
> +	if (reg_offset & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
> +
> +	miiaddr |=3D ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> +
> +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> +	usleep_range(10, 20);
> +
> +	return ipq8064_mdio_wait_busy(priv);
> +}
> +
> +static int
> +ipq8064_mdio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct ipq8064_mdio *priv;
> +	struct mii_bus *bus;
> +	int ret;
> +
> +	bus =3D devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name =3D "ipq8064_mdio_bus";
> +	bus->read =3D ipq8064_mdio_read;
> +	bus->write =3D ipq8064_mdio_write;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
> +	bus->parent =3D &pdev->dev;
> +
> +	priv =3D bus->priv;
> +	priv->base =3D syscon_node_to_regmap(np);
> +	if (IS_ERR(priv->base) && priv->base !=3D ERR_PTR(-EPROBE_DEFER))
> +		priv->base =3D syscon_regmap_lookup_by_phandle(np, "master");
> +
> +	if (priv->base =3D=3D ERR_PTR(-EPROBE_DEFER)) {
> +		return -EPROBE_DEFER;
> +	} else if (IS_ERR(priv->base)) {
> +		dev_err(&pdev->dev, "error getting syscon regmap, error=3D%pe\n",
> +			priv->base);
> +		return PTR_ERR(priv->base);
> +	}
> +
> +	ret =3D of_mdiobus_register(bus, np);
> +	if (ret)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, bus);
> +	return 0;
> +}
> +
> +static int
> +ipq8064_mdio_remove(struct platform_device *pdev)
> +{
> +	struct mii_bus *bus =3D platform_get_drvdata(pdev);
> +
> +	mdiobus_unregister(bus);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id ipq8064_mdio_dt_ids[] =3D {
> +	{ .compatible =3D "qcom,ipq8064-mdio" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ipq8064_mdio_dt_ids);
> +
> +static struct platform_driver ipq8064_mdio_driver =3D {
> +	.probe =3D ipq8064_mdio_probe,
> +	.remove =3D ipq8064_mdio_remove,
> +	.driver =3D {
> +		.name =3D "ipq8064-mdio",
> +		.of_match_table =3D ipq8064_mdio_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(ipq8064_mdio_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm IPQ8064 MDIO interface driver");
> +MODULE_AUTHOR("Christian Lamparter <chunkeey@gmail.com>");
@Mr. Smith: Don't you want to add yourself there (and in the boilerplate)
as well then?=20

> +MODULE_LICENSE("GPL");
>=20

Cheers and good night,
Christian

=2D--
[0] <https://git.openwrt.org/?p=3Dopenwrt/staging/chunkeey.git;a=3Dblob;f=
=3Dtarget/linux/ipq806x/patches-4.19/700-net-mdio-add-ipq8064-mdio-driver.p=
atch;h=3D6f25b895cacb34b7fcf3e275c15ab26e25252fa8;hb=3D1034741b8735608b022d=
55b08df34d4cff423b46>




