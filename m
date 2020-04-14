Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB151A88FB
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503724AbgDNSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503714AbgDNSPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:15:39 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CC4C061A0F
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:15:39 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id i27so615584ota.7
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=311Ki1TayWq2eeNSKCfJ9oo9ldzggmhLsDapa5DYoDs=;
        b=gqYmzl18R7dYSMCGDAnJIqGqGaOsVxCrWxYNro4lrIR5BmPyweFDaSIg7IPVrP2hTR
         5Ij8NbE2oT/pDa95NEBc7oX03YFSadAHNj7nAYKhvHTwjmsCjNm54fBYvTeyycMOqTSp
         3NZifFagMAJgOx5pFOoXEy0KjV+I+ii15/yvtBJ/vjZcC5l6EzNL+8lUr/4i+O0H5FRi
         f+b1/oslzVQpBP6XG76bqYDqi2tbj/Y59ER8jR8N5csJxSu/lKQsI0oFduaDTLOZzR9j
         /REDXXHng/PXkT5+ZJG/h36znxbG1O1MPvkrh8JWadmHCVrrSDputuV8eQTel3ZlzHFX
         NDzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=311Ki1TayWq2eeNSKCfJ9oo9ldzggmhLsDapa5DYoDs=;
        b=LXNjKBwTX2QX+A5pAIndAtKRKLEFHV+O0VKAyQNr+Y2eUFQTomxC8rnXH90bPzVPlU
         oueKe075u+q3VwzUPLj36wGAjtWjWiLbUCXKMdZj6ml3ZgVonq9x57QsuOxjDm88Qlhv
         ZcBlagfqpgH9pBivhlhMuaCLiuJMHJLR3SLo/bbj4L5CFnAFtkINIAlAgHj8quxKqA8e
         +Iv/0gHy+Zm/xlHnTrXnsygQIvpTM/iKeJ6QRT7xIHLW2awBFM415hPoKcDEBfE1uZNJ
         ZmRBcVOQsy5wJzI6l3rYjbSzpIct1PLgWmihI9p4uhEeUqB02Z183aF1KEvjILg6i063
         k8iA==
X-Gm-Message-State: AGi0PuaxqOd7rfHtTv9Tq3VuGLwK0oJSmddPw7euQmuqPQZTUjSy/1c4
        SveSEnLaL77lVVppiAT5zyFdhFRuLxgHBsn3oDxL3w==
X-Google-Smtp-Source: APiQypJ7880lb72c5yAW+klTFHXowNzhF/TD3UkRRP9dfwmkA4vImAC5OG87XN4glONyeHJ9ROt9dacjemejij/Mnh4=
X-Received: by 2002:a9d:ef8:: with SMTP id 111mr19768445otj.94.1586888138571;
 Tue, 14 Apr 2020 11:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200413170107.246509-1-robert.marko@sartura.hr> <787129c5-f711-5f85-9306-35fb93c68d7b@gmail.com>
In-Reply-To: <787129c5-f711-5f85-9306-35fb93c68d7b@gmail.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Tue, 14 Apr 2020 20:15:27 +0200
Message-ID: <CA+HBbNFhzRGWdXYm+f2okXYSOPZyADz8ysPCttuU2uK_VoV+wg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: phy: mdio: add IPQ40xx MDIO driver
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 7:18 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 13.04.2020 19:01, Robert Marko wrote:
> > This patch adds the driver for the MDIO interface
> > inside of Qualcomm IPQ40xx series SoC-s.
> >
> > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > Cc: Luka Perkov <luka.perkov@sartura.hr>
> > ---
> >  drivers/net/phy/Kconfig        |   7 ++
> >  drivers/net/phy/Makefile       |   1 +
> >  drivers/net/phy/mdio-ipq40xx.c | 180 +++++++++++++++++++++++++++++++++
> >  3 files changed, 188 insertions(+)
> >  create mode 100644 drivers/net/phy/mdio-ipq40xx.c
> >
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 9dabe03a668c..614d08635012 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -157,6 +157,13 @@ config MDIO_I2C
> >
> >         This is library mode.
> >
> > +config MDIO_IPQ40XX
> > +     tristate "Qualcomm IPQ40xx MDIO interface"
> > +     depends on HAS_IOMEM && OF
> > +     help
> > +       This driver supports the MDIO interface found in Qualcomm
> > +       IPQ40xx series Soc-s.
> > +
> >  config MDIO_MOXART
> >       tristate "MOXA ART MDIO interface support"
> >       depends on ARCH_MOXART || COMPILE_TEST
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index fe5badf13b65..c89fc187fd74 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)   += mdio-cavium.o
> >  obj-$(CONFIG_MDIO_GPIO)              += mdio-gpio.o
> >  obj-$(CONFIG_MDIO_HISI_FEMAC)        += mdio-hisi-femac.o
> >  obj-$(CONFIG_MDIO_I2C)               += mdio-i2c.o
> > +obj-$(CONFIG_MDIO_IPQ40XX)   += mdio-ipq40xx.o
> >  obj-$(CONFIG_MDIO_MOXART)    += mdio-moxart.o
> >  obj-$(CONFIG_MDIO_MSCC_MIIM) += mdio-mscc-miim.o
> >  obj-$(CONFIG_MDIO_OCTEON)    += mdio-octeon.o
> > diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> > new file mode 100644
> > index 000000000000..8068f1e6a077
> > --- /dev/null
> > +++ b/drivers/net/phy/mdio-ipq40xx.c
> > @@ -0,0 +1,180 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> > +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/io.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define MDIO_CTRL_0_REG              0x40
> > +#define MDIO_CTRL_1_REG              0x44
> > +#define MDIO_CTRL_2_REG              0x48
> > +#define MDIO_CTRL_3_REG              0x4c
> > +#define MDIO_CTRL_4_REG              0x50
> > +#define MDIO_CTRL_4_ACCESS_BUSY              BIT(16)
> > +#define MDIO_CTRL_4_ACCESS_START             BIT(8)
> > +#define MDIO_CTRL_4_ACCESS_CODE_READ         0
> > +#define MDIO_CTRL_4_ACCESS_CODE_WRITE        1
> > +#define CTRL_0_REG_DEFAULT_VALUE     0x150FF
> > +
> > +#define IPQ40XX_MDIO_RETRY   1000
> > +#define IPQ40XX_MDIO_DELAY   10
> > +
> > +struct ipq40xx_mdio_data {
> > +     struct mii_bus  *mii_bus;
> > +     void __iomem    *membase;
> > +     struct device   *dev;
> > +};
> > +
> > +static int ipq40xx_mdio_wait_busy(struct ipq40xx_mdio_data *am)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
> > +             unsigned int busy;
> > +
> > +             busy = readl(am->membase + MDIO_CTRL_4_REG) &
> > +                     MDIO_CTRL_4_ACCESS_BUSY;
> > +             if (!busy)
> > +                     return 0;
> > +
> > +             /* BUSY might take to be cleard by 15~20 times of loop */
> > +             udelay(IPQ40XX_MDIO_DELAY);
> > +     }
> > +
> > +     dev_err(am->dev, "%s: MDIO operation timed out\n", am->mii_bus->name);
> > +
> > +     return -ETIMEDOUT;
> > +}
> > +
> > +static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> > +{
> > +     struct ipq40xx_mdio_data *am = bus->priv;
> > +     int value = 0;
> > +     unsigned int cmd = 0;
> > +
> > +     lockdep_assert_held(&bus->mdio_lock);
> > +
> > +     if (ipq40xx_mdio_wait_busy(am))
> > +             return -ETIMEDOUT;
> > +
> > +     /* issue the phy address and reg */
> > +     writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
> > +
> > +     cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_READ;
> > +
> > +     /* issue read command */
> > +     writel(cmd, am->membase + MDIO_CTRL_4_REG);
> > +
> > +     /* Wait read complete */
> > +     if (ipq40xx_mdio_wait_busy(am))
> > +             return -ETIMEDOUT;
> > +
> > +     /* Read data */
> > +     value = readl(am->membase + MDIO_CTRL_3_REG);
> > +
> > +     return value;
> > +}
> > +
> > +static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> > +                                                      u16 value)
> > +{
> > +     struct ipq40xx_mdio_data *am = bus->priv;
> > +     unsigned int cmd = 0;
> > +
> > +     lockdep_assert_held(&bus->mdio_lock);
> > +
> > +     if (ipq40xx_mdio_wait_busy(am))
> > +             return -ETIMEDOUT;
> > +
> > +     /* issue the phy address and reg */
> > +     writel((mii_id << 8) | regnum, am->membase + MDIO_CTRL_1_REG);
> > +
> > +     /* issue write data */
> > +     writel(value, am->membase + MDIO_CTRL_2_REG);
> > +
> > +     cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_WRITE;
> > +     /* issue write command */
> > +     writel(cmd, am->membase + MDIO_CTRL_4_REG);
> > +
> > +     /* Wait write complete */
> > +     if (ipq40xx_mdio_wait_busy(am))
> > +             return -ETIMEDOUT;
> > +
> > +     return 0;
> > +}
> > +
> > +static int ipq40xx_mdio_probe(struct platform_device *pdev)
> > +{
> > +     struct ipq40xx_mdio_data *am;
> > +     struct resource *res;
> > +
> > +     am = devm_kzalloc(&pdev->dev, sizeof(*am), GFP_KERNEL);
> > +     if (!am)
> > +             return -ENOMEM;
> > +
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +     if (!res) {
> > +             dev_err(&pdev->dev, "no iomem resource found\n");
> > +             return -ENXIO;
> > +     }
> > +
> > +     am->membase = devm_ioremap_resource(&pdev->dev, res);
>
> You can use devm_platform_ioremap_resource() here.
Thanks, its now used in v2.
>
> > +     if (IS_ERR(am->membase)) {
> > +             dev_err(&pdev->dev, "unable to ioremap registers\n");
> > +             return PTR_ERR(am->membase);
> > +     }
> > +
> > +     am->mii_bus = devm_mdiobus_alloc(&pdev->dev);
> > +     if (!am->mii_bus)
> > +             return  -ENOMEM;
> > +
>
> You could use devm_mdiobus_alloc_size() and omit allocating am
> separately.
Thanks, I switched to it in v2 along some other improvements.
>
> > +     writel(CTRL_0_REG_DEFAULT_VALUE, am->membase + MDIO_CTRL_0_REG);
> > +
> > +     am->mii_bus->name = "ipq40xx_mdio";
> > +     am->mii_bus->read = ipq40xx_mdio_read;
> > +     am->mii_bus->write = ipq40xx_mdio_write;
> > +     am->mii_bus->priv = am;
> > +     am->mii_bus->parent = &pdev->dev;
> > +     snprintf(am->mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(&pdev->dev));
> > +
> > +     am->dev = &pdev->dev;
> > +     platform_set_drvdata(pdev, am);
> > +
> > +     return of_mdiobus_register(am->mii_bus, pdev->dev.of_node);
> > +}
> > +
> > +static int ipq40xx_mdio_remove(struct platform_device *pdev)
> > +{
> > +     struct ipq40xx_mdio_data *am = platform_get_drvdata(pdev);
> > +
> > +     mdiobus_unregister(am->mii_bus);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct of_device_id ipq40xx_mdio_dt_ids[] = {
> > +     { .compatible = "qcom,ipq40xx-mdio" },
> > +     { }
> > +};
> > +MODULE_DEVICE_TABLE(of, ipq40xx_mdio_dt_ids);
> > +
> > +static struct platform_driver ipq40xx_mdio_driver = {
> > +     .probe = ipq40xx_mdio_probe,
> > +     .remove = ipq40xx_mdio_remove,
> > +     .driver = {
> > +             .name = "ipq40xx-mdio",
> > +             .of_match_table = ipq40xx_mdio_dt_ids,
> > +     },
> > +};
> > +
> > +module_platform_driver(ipq40xx_mdio_driver);
> > +
> > +MODULE_DESCRIPTION("IPQ40XX MDIO interface driver");
> > +MODULE_AUTHOR("Qualcomm Atheros");
> > +MODULE_LICENSE("Dual BSD/GPL");
> >
>
