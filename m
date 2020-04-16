Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC41ABB87
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 10:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502398AbgDPIoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 04:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502324AbgDPIoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:09 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDA4C061A41
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:43:12 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k133so15246912oih.12
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lRp9vdVZ7MTdl+9qiFqPxefNPFFCKsJZnMf3voId8jY=;
        b=j593R5BIiDTn5k58uLYv1wZ87WTppiXeaAFaR4tDuSqVUViZ9pG0B8UWph3jwGwbtU
         7CeTZRqoZMQgiCJr0ghOpBiMfSzltgnv5SdOm6UKhB6PtnKgJQA+hzQoCwbYuW5F8vrC
         zqKPHKRFQwrx/yeCHpsh/SNlicbazVTcG2IZK2MSLzm9JltGCWGsErofmHwKu7CJYJ2e
         V56nr0P2QN56tBUEpoy4/S/Txmx6GG9ftyUfRFADgyRXb2aDCmMCTPBa6KVkq8bHJN4c
         29NUjrcVDLcIo+3af6sT0h15nUximuihEJdBwmeXJmpZQlBXojjtHFldSPfYzkJCRiYj
         dJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lRp9vdVZ7MTdl+9qiFqPxefNPFFCKsJZnMf3voId8jY=;
        b=AfhrFRkEnEkzkIBIyGIeTA544pTegmBJGIhwujZ4+lLD3AWwaj84eJ+gIcPQh0mrpg
         3TPGcnstyF9O4o8ToJfhEDzL93BZqqHUUohfRXQs4JffargVzy1eN6axGgmorjYHGB0m
         A6a+wF5wMQcqBu7tc/GBzmbzRKscxpAaL8Q1NZvxfYmktMWYm7pEPoqXMdV+PQvXizEs
         tdhQaQqVxCUJ/XyRy4IRYVaQpQEU+wEaEMTTF2+xFwPJft9GE4M96cU8+6AdyBuvbjWY
         rNDm91obnbbelSI4PDJulDDclblkMSzDswDiHqc/tD0xg8Rf9jjuvoYIeJH5fGj1gBRK
         +9Wg==
X-Gm-Message-State: AGi0PuZPQSeI2Uc4iPwDJLTEK5DIh+g64LdDMkwI0G/dPD4poKUf7wxA
        ep1WNT6mVjslZ20yceY2Y7fXnEabvdj738yr/MT9Pw==
X-Google-Smtp-Source: APiQypK1jr4Gmk8/Yi4BeN+e309KBzjOnZ9by8FP5Ku+SdFAqKJPKy3NtKTXpyk4T4W3P7PKwaapefIvgYij5I4rLfw=
X-Received: by 2002:a54:448f:: with SMTP id v15mr2231604oiv.154.1587026591583;
 Thu, 16 Apr 2020 01:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200415150244.2737206-1-robert.marko@sartura.hr> <20200415234844.GH611399@lunn.ch>
In-Reply-To: <20200415234844.GH611399@lunn.ch>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Thu, 16 Apr 2020 10:43:00 +0200
Message-ID: <CA+HBbNEf7x0ef=Q5U55DrX_xMS_QjXiAEP5rYAof2wyOifWfcA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] net: phy: mdio: add IPQ40xx MDIO driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
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

On Thu, Apr 16, 2020 at 1:48 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Robert
>
> I should of said this earlier. With a patch set, you should include a
> cover note, patch 0 of X, explaining the big picture of what the
> patches do.

Sorry, I thought that was a relatively small patch set and cover
letter was not needed.
>
> Also, for network patches, the subject line should indicate which tree
> these patches are for. So
>
> [PATCH net-next v3 0/3]
OK, this is my first contribution to networking and I did not check first.
I am used to sending patches without it.
Now I know for the future,
Thanks
>
> On Wed, Apr 15, 2020 at 05:02:43PM +0200, Robert Marko wrote:
> > This patch adds the driver for the MDIO interface
> > inside of Qualcomm IPQ40xx series SoC-s.
> >
> > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > Cc: Luka Perkov <luka.perkov@sartura.hr>
> > ---
> > Changes from v2 to v3:
> > * Rename registers
> > * Remove unnecessary variable initialisations
> > * Switch to readl_poll_timeout() instead of custom solution
> > * Drop unused header
> >
> > Changes from v1 to v2:
> > * Remove magic default value
> > * Remove lockdep_assert_held
> > * Add C45 check
> > * Simplify the driver
> > * Drop device and mii_bus structs from private struct
> > * Use devm_mdiobus_alloc_size()
> >
> >  drivers/net/phy/Kconfig        |   7 ++
> >  drivers/net/phy/Makefile       |   1 +
> >  drivers/net/phy/mdio-ipq40xx.c | 160 +++++++++++++++++++++++++++++++++
> >  3 files changed, 168 insertions(+)
> >  create mode 100644 drivers/net/phy/mdio-ipq40xx.c
> >
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 3fa33d27eeba..23bb5db033e3 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -157,6 +157,13 @@ config MDIO_I2C
> >
> >         This is library mode.
> >
> > +config MDIO_IPQ40XX
> > +     tristate "Qualcomm IPQ40xx MDIO interface"
> > +     depends on HAS_IOMEM && OF_MDIO
> > +     help
> > +       This driver supports the MDIO interface found in Qualcomm
> > +       IPQ40xx series Soc-s.
> > +
> >  config MDIO_IPQ8064
> >       tristate "Qualcomm IPQ8064 MDIO interface support"
> >       depends on HAS_IOMEM && OF_MDIO
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index 2f5c7093a65b..36aafc6128c4 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -37,6 +37,7 @@ obj-$(CONFIG_MDIO_CAVIUM)   += mdio-cavium.o
> >  obj-$(CONFIG_MDIO_GPIO)              += mdio-gpio.o
> >  obj-$(CONFIG_MDIO_HISI_FEMAC)        += mdio-hisi-femac.o
> >  obj-$(CONFIG_MDIO_I2C)               += mdio-i2c.o
> > +obj-$(CONFIG_MDIO_IPQ40XX)   += mdio-ipq40xx.o
> >  obj-$(CONFIG_MDIO_IPQ8064)   += mdio-ipq8064.o
> >  obj-$(CONFIG_MDIO_MOXART)    += mdio-moxart.o
> >  obj-$(CONFIG_MDIO_MSCC_MIIM) += mdio-mscc-miim.o
> > diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> > new file mode 100644
> > index 000000000000..acf1230341bd
> > --- /dev/null
> > +++ b/drivers/net/phy/mdio-ipq40xx.c
> > @@ -0,0 +1,160 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> > +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> > +/* Copyright (c) 2020 Sartura Ltd. */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/io.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define MDIO_ADDR_REG                                0x44
> > +#define MDIO_DATA_WRITE_REG                  0x48
> > +#define MDIO_DATA_READ_REG                   0x4c
> > +#define MDIO_CMD_REG                         0x50
> > +#define MDIO_CMD_ACCESS_BUSY         BIT(16)
> > +#define MDIO_CMD_ACCESS_START                BIT(8)
> > +#define MDIO_CMD_ACCESS_CODE_READ    0
> > +#define MDIO_CMD_ACCESS_CODE_WRITE   1
> > +
> > +#define IPQ40XX_MDIO_TIMEOUT 10000
> > +#define IPQ40XX_MDIO_SLEEP           10
> > +
> > +struct ipq40xx_mdio_data {
> > +     void __iomem    *membase;
> > +};
> > +
> > +static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
> > +{
> > +     struct ipq40xx_mdio_data *priv = bus->priv;
> > +     unsigned int busy;
> > +
> > +     return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
> > +                               (busy & MDIO_CMD_ACCESS_BUSY) == 0,
> > +                               IPQ40XX_MDIO_SLEEP, IPQ40XX_MDIO_TIMEOUT);
>
> Do you have any documentation about _START and _BUSY? You are making
> the assumption that the next read after writing the START bit will
> have the BUSY bit set. That the hardware reacts that fast. It is not
> an unreasonable assumption, but i've seen more designed where the
> START bit is also the BUSY bit, so the write implicitly sets the busy
> bit, and the hardware needs to clear it when it is done.
No, I don't have any docs at all for the SoC.
It's all based on GPL drivers from SDK and QCA comments in
the drivers as well as U-boot drivers.
>
> As i said, this is not unreasonable, so:
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew
>
