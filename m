Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B074D6D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404276AbfGYLrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:47:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45220 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404236AbfGYLrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:47:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so50391871wre.12
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 04:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Lf+XQWhjcXvLf8ENOnQhTMp3PxrGkgUL3ekpj3zszaM=;
        b=Wle+NqpJmbv1kzNbn5YRqw3I5KUTinRI75u4rznKQ+7O5pW6fZz2Jo22a2hMTvDLU1
         GNY9Yggkbh97MDJSPr4pw/nucG008sxXO+V/agdUH72i3lRizwsaV4Ln2UqlFuzcwV/Z
         8em3YLUoHqCT8EDiz8NMNGrQVZEIhv91xzLX/VDZKX3yZsGMLk1qIpnrGEnktT9GNC3y
         WkN7/yebsuG1/oVm+s7bYRTjCTYRV4DJyIK7Wu4M1ht+i1HUD/+PX+ZsSSk0uOMPymcj
         PkWjD03rkfZdlhW95LLkIcIbAaMeJa3TcMF+FaXpu/d8FZmQxpo/5TkKpyZ094wGl1sC
         CtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Lf+XQWhjcXvLf8ENOnQhTMp3PxrGkgUL3ekpj3zszaM=;
        b=NaHP5Jx0+UrSnJgbasA2tj525duvnm7kl3YfqcTcn/Zrqoru1r8eM7DT1Wb4BV1v82
         XWNjzGgak6kZU1nU01gm+XKkOXzgLQhX3Hd5d4v+2NGDyRYWVZI6zJjAlUWOqq2W50QH
         Trd/3JA89iwESuSGFvg//zRVllDws0aKSOU/aq/OLCax4KeOlIEegOcK4iu0+iJlR8Gc
         PsZhw3vWE2Kw5FV8vYnARG3QGHSHdqJDJxKik96IlG8fUAXLaEnYSjOsEThXk7c4omKi
         dtR2GiIXEJsq7Mhs+TxlVg7HCb3WxHQ8WfRvoRjLEX5e4sIzYIyjX4AzVfW/hpCWsXzs
         mPLQ==
X-Gm-Message-State: APjAAAXvM1s/JQvjKws6HL0Qi9M0g/w6VB/+3wytaP8KarWSfJyJFlag
        oDDlchuTxgmzj/2zvEsyVhJTYDKsvUI=
X-Google-Smtp-Source: APXvYqxSKGgu8fNQhRM9enbXjL0aiu9NZoh0NzhgrH192IhJ5jqqTVonYv+FApuhkZTL/Nt4cruiUw==
X-Received: by 2002:adf:ea82:: with SMTP id s2mr87893381wrm.91.1564055256647;
        Thu, 25 Jul 2019 04:47:36 -0700 (PDT)
Received: from dell ([2.27.35.164])
        by smtp.gmail.com with ESMTPSA id q1sm38561214wmq.25.2019.07.25.04.47.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jul 2019 04:47:35 -0700 (PDT)
Date:   Thu, 25 Jul 2019 12:47:16 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20190725114716.GB23883@dell>
References: <20190613170636.6647-1-tbogendoerfer@suse.de>
 <20190613170636.6647-6-tbogendoerfer@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613170636.6647-6-tbogendoerfer@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019, Thomas Bogendoerfer wrote:

> SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> It also supports connecting a SuperIO chip for serial and parallel
> interfaces. IOC3 is used inside various SGI systemboards and add-on
> cards with different equipped external interfaces.
> 
> Support for ethernet and serial interfaces were implemented inside
> the network driver. This patchset moves out the not network related
> parts to a new MFD driver, which takes care of card detection,
> setup of platform devices and interrupt distribution for the subdevices.
> 
> Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  arch/mips/include/asm/sn/ioc3.h     |  345 +++----
>  arch/mips/sgi-ip27/ip27-timer.c     |   20 -

>  drivers/mfd/Kconfig                 |   13 +
>  drivers/mfd/Makefile                |    1 +
>  drivers/mfd/ioc3.c                  |  683 +++++++++++++

A vast improvement, but still a little work to do.

>  drivers/net/ethernet/sgi/Kconfig    |    4 +-
>  drivers/net/ethernet/sgi/ioc3-eth.c | 1932 ++++++++++++++---------------------
>  drivers/tty/serial/8250/8250_ioc3.c |   98 ++
>  drivers/tty/serial/8250/Kconfig     |   11 +
>  drivers/tty/serial/8250/Makefile    |    1 +
>  10 files changed, 1693 insertions(+), 1415 deletions(-)
>  create mode 100644 drivers/mfd/ioc3.c
>  create mode 100644 drivers/tty/serial/8250/8250_ioc3.c

[...]

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index a17d275bf1d4..5c9f1bd9bd0a 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1989,5 +1989,18 @@ config RAVE_SP_CORE
>  	  Select this to get support for the Supervisory Processor
>  	  device found on several devices in RAVE line of hardware.
>  
> +config SGI_MFD_IOC3
> +	tristate "SGI IOC3 core driver"
> +	depends on PCI && MIPS
> +	select MFD_CORE
> +	help
> +	  This option enables basic support for the SGI IOC3-based
> +	  controller cards.  This option does not enable any specific
> +	  functions on such a card, but provides necessary infrastructure
> +	  for other drivers to utilize.
> +
> +	  If you have an SGI Origin, Octane, or a PCI IOC3 card,
> +	  then say Y. Otherwise say N.
> +
>  endmenu
>  endif
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 52b1a90ff515..bba0d9eb0b18 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -249,3 +249,4 @@ obj-$(CONFIG_MFD_SC27XX_PMIC)	+= sprd-sc27xx-spi.o
>  obj-$(CONFIG_RAVE_SP_CORE)	+= rave-sp.o
>  obj-$(CONFIG_MFD_ROHM_BD718XX)	+= rohm-bd718x7.o
>  obj-$(CONFIG_MFD_STMFX) 	+= stmfx.o
> +obj-$(CONFIG_SGI_MFD_IOC3)	+= ioc3.o
> diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
> new file mode 100644
> index 000000000000..0c0d1b3475d0
> --- /dev/null
> +++ b/drivers/mfd/ioc3.c
> @@ -0,0 +1,683 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * SGI IOC3 multifunction device driver
> + *
> + * Copyright (C) 2018, 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
> + *
> + * Based on work by:
> + *   Stanislaw Skowronek <skylark@unaligned.org>
> + *   Joshua Kinard <kumba@gentoo.org>
> + *   Brent Casavant <bcasavan@sgi.com> - IOC4 master driver
> + *   Pat Gefre <pfg@sgi.com> - IOC3 serial port IRQ demuxer
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/sgi-w1.h>
> +#include <linux/rtc/ds1685.h>
> +
> +#include <asm/pci/bridge.h>
> +#include <asm/sn/ioc3.h>
> +
> +#define IOC3_IRQ_SERIAL_A	6
> +#define IOC3_IRQ_SERIAL_B	15
> +#define IOC3_IRQ_KBD		22
> +#define IOC3_IRQ_ETH_DOMAIN	23
> +
> +static int ioc3_serial_id;
> +static int ioc3_eth_id;
> +static int ioc3_kbd_id;
> +
> +struct ioc3_priv_data {
> +	struct irq_domain *domain;
> +	struct ioc3 __iomem *regs;
> +	struct pci_dev *pdev;
> +	int domain_irq;
> +};
> +
> +static void ioc3_irq_ack(struct irq_data *d)
> +{
> +	struct ioc3_priv_data *ipd = irq_data_get_irq_chip_data(d);
> +	unsigned int hwirq = irqd_to_hwirq(d);
> +
> +	writel(BIT(hwirq), &ipd->regs->sio_ir);
> +}
> +
> +static void ioc3_irq_mask(struct irq_data *d)
> +{
> +	struct ioc3_priv_data *ipd = irq_data_get_irq_chip_data(d);
> +	unsigned int hwirq = irqd_to_hwirq(d);
> +
> +	writel(BIT(hwirq), &ipd->regs->sio_iec);
> +}
> +
> +static void ioc3_irq_unmask(struct irq_data *d)
> +{
> +	struct ioc3_priv_data *ipd = irq_data_get_irq_chip_data(d);
> +	unsigned int hwirq = irqd_to_hwirq(d);
> +
> +	writel(BIT(hwirq), &ipd->regs->sio_ies);
> +}
> +
> +static struct irq_chip ioc3_irq_chip = {
> +	.name		= "IOC3",
> +	.irq_ack	= ioc3_irq_ack,
> +	.irq_mask	= ioc3_irq_mask,
> +	.irq_unmask	= ioc3_irq_unmask,
> +};
> +
> +#define IOC3_LVL_MASK	(BIT(IOC3_IRQ_SERIAL_A) | BIT(IOC3_IRQ_SERIAL_B))
> +
> +static int ioc3_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +			      irq_hw_number_t hwirq)
> +{
> +	/* use level irqs for every interrupt contained in IOC3_LVL_MASK */

Nit: Could you use proper grammar (less the full stops) in the
comments please?  Start with an uppercase character and things like
"irq" should be "IRQ", etc.

> +	if (BIT(hwirq) & IOC3_LVL_MASK)
> +		irq_set_chip_and_handler(irq, &ioc3_irq_chip, handle_level_irq);
> +	else
> +		irq_set_chip_and_handler(irq, &ioc3_irq_chip, handle_edge_irq);
> +
> +	irq_set_chip_data(irq, d->host_data);
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops ioc3_irq_domain_ops = {
> +	.map = ioc3_irq_domain_map,
> +};
> +
> +static void ioc3_irq_handler(struct irq_desc *desc)
> +{
> +	struct irq_domain *domain = irq_desc_get_handler_data(desc);
> +	struct ioc3_priv_data *ipd = domain->host_data;
> +	struct ioc3 __iomem *regs = ipd->regs;
> +	u32 pending, mask;
> +	unsigned int irq;
> +
> +	pending = readl(&regs->sio_ir);
> +	mask = readl(&regs->sio_ies);
> +	pending &= mask; /* mask off not enabled but pending irqs */
> +
> +	if (mask & BIT(IOC3_IRQ_ETH_DOMAIN))
> +		/* if eth irq is enabled we need to check in eth irq regs */
> +		if (readl(&regs->eth.eisr) & readl(&regs->eth.eier))
> +			pending |= IOC3_IRQ_ETH_DOMAIN;
> +
> +	if (pending) {
> +		irq = irq_find_mapping(domain, __ffs(pending));
> +		if (irq)
> +			generic_handle_irq(irq);
> +	} else  {
> +		spurious_interrupt();
> +	}
> +}
> +
> +/*
> + * System boards/BaseIOs use more interrupt pins of the bridge asic

"ASIC"

> + * to which the IOC3 is connected. Since the IOC3 MFD driver
> + * knows wiring of these extra pins, we use the map_irq function
> + * to get interrupts activated
> + */
> +static int ioc3_map_irq(struct pci_dev *pdev, int pin)
> +{
> +	struct pci_host_bridge *hbrg = pci_find_host_bridge(pdev->bus);
> +
> +	return hbrg->map_irq(pdev, pin, 0);
> +}
> +
> +static int ioc3_irq_domain_setup(struct ioc3_priv_data *ipd, int irq)
> +{
> +	struct irq_domain *domain;
> +	struct fwnode_handle *fn;
> +
> +	fn = irq_domain_alloc_named_fwnode("IOC3");
> +	if (!fn)
> +		goto err;
> +
> +	domain = irq_domain_create_linear(fn, 24, &ioc3_irq_domain_ops, ipd);
> +	if (!domain)
> +		goto err;
> +
> +	irq_domain_free_fwnode(fn);
> +	ipd->domain = domain;
> +
> +	irq_set_chained_handler_and_data(irq, ioc3_irq_handler, domain);
> +	ipd->domain_irq = irq;
> +	return 0;
> +err:
> +	dev_err(&ipd->pdev->dev, "irq domain setup failed\n");
> +	return -ENOMEM;
> +}
> +
> +static struct resource ioc3_uarta_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uarta),
> +		       sizeof_field(struct ioc3, sregs.uarta)),
> +	DEFINE_RES_IRQ(IOC3_IRQ_SERIAL_A)
> +};
> +
> +static struct resource ioc3_uartb_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uartb),
> +		       sizeof_field(struct ioc3, sregs.uartb)),
> +	DEFINE_RES_IRQ(IOC3_IRQ_SERIAL_B)
> +};
> +
> +static struct mfd_cell ioc3_serial_cells[] = {
> +	{
> +		.name = "ioc3-serial8250",
> +		.resources = ioc3_uarta_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_uarta_resources),
> +		.id = 0,
> +	},
> +	{
> +		.name = "ioc3-serial8250",
> +		.resources = ioc3_uartb_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_uartb_resources),
> +		.id = 1,

Any reason for not using PLATFORM_DEVID_AUTO.

> +	}
> +};
> +
> +static int ioc3_serial_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	/* set gpio pins for RS232/RS422 mode selection */
> +	writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL,
> +		&ipd->regs->gpcr_s);
> +	/* select RS232 mode for uart a */
> +	writel(0, &ipd->regs->gppr[6]);
> +	/* select RS232 mode for uart b */
> +	writel(0, &ipd->regs->gppr[7]);
> +
> +	/* switch both ports to 16650 mode */
> +	writel(readl(&ipd->regs->port_a.sscr) & ~SSCR_DMA_EN,
> +	       &ipd->regs->port_a.sscr);
> +	writel(readl(&ipd->regs->port_b.sscr) & ~SSCR_DMA_EN,
> +	       &ipd->regs->port_b.sscr);
> +	udelay(1000); /* wait until mode switch is done */
> +
> +	ret = mfd_add_devices(&ipd->pdev->dev, ioc3_serial_id,

Any reason for not using PLATFORM_DEVID_AUTO.

> +			      ioc3_serial_cells, ARRAY_SIZE(ioc3_serial_cells),
> +			      &ipd->pdev->resource[0], 0, ipd->domain);
> +	if (ret) {
> +		dev_err(&ipd->pdev->dev, "Failed to add 16550 subdevs\n");
> +		return ret;
> +	}
> +	ioc3_serial_id += 2;

When is this likely to be re-read?

> +	return 0;
> +}
> +
> +static struct resource ioc3_kbd_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, serio),
> +		       sizeof_field(struct ioc3, serio)),
> +	DEFINE_RES_IRQ(IOC3_IRQ_KBD)
> +};
> +
> +static struct mfd_cell ioc3_kbd_cells[] = {
> +	{
> +		.name = "ioc3-kbd",
> +		.resources = ioc3_kbd_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_kbd_resources),
> +	}
> +};
> +
> +static int ioc3_kbd_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = mfd_add_devices(&ipd->pdev->dev, ioc3_kbd_id, ioc3_kbd_cells,
> +			      ARRAY_SIZE(ioc3_kbd_cells),
> +			      &ipd->pdev->resource[0], 0, ipd->domain);
> +	if (ret) {
> +		dev_err(&ipd->pdev->dev, "Failed to add 16550 subdevs\n");
> +		return ret;
> +	}
> +	ioc3_kbd_id++;

Nit: '\n' here

> +	return 0;
> +}
> +
> +static struct resource ioc3_eth_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, eth),
> +		       sizeof_field(struct ioc3, eth)),
> +	DEFINE_RES_MEM(offsetof(struct ioc3, ssram),
> +		       sizeof_field(struct ioc3, ssram)),
> +	DEFINE_RES_IRQ(0)
> +};
> +
> +static struct resource ioc3_w1_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, mcr),
> +		       sizeof_field(struct ioc3, mcr)),
> +};
> +static struct sgi_w1_platform_data ioc3_w1_platform_data;
> +
> +static struct mfd_cell ioc3_eth_cells[] = {
> +	{
> +		.name = "ioc3-eth",
> +		.resources = ioc3_eth_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_eth_resources),
> +	},
> +	{
> +		.name = "sgi_w1",
> +		.resources = ioc3_w1_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_w1_resources),
> +		.platform_data = &ioc3_w1_platform_data,
> +		.pdata_size = sizeof(ioc3_w1_platform_data),
> +	}
> +};
> +
> +static int ioc3_eth_setup(struct ioc3_priv_data *ipd, bool use_domain)
> +{
> +	int irq = ipd->pdev->irq;
> +	int ret;
> +
> +	/* enable One-Wire bus */
> +	writel(GPCR_MLAN_EN, &ipd->regs->gpcr_s);
> +
> +	/* generate unique identifier */
> +	snprintf(ioc3_w1_platform_data.dev_id,
> +		 sizeof(ioc3_w1_platform_data.dev_id), "ioc3-%012llx",
> +		 ipd->pdev->resource->start);
> +
> +	if (use_domain)
> +		irq = irq_create_mapping(ipd->domain, IOC3_IRQ_ETH_DOMAIN);
> +
> +	ret = mfd_add_devices(&ipd->pdev->dev, ioc3_eth_id, ioc3_eth_cells,
> +			      ARRAY_SIZE(ioc3_eth_cells),
> +			      &ipd->pdev->resource[0], irq, NULL);
> +	if (ret) {
> +		dev_err(&ipd->pdev->dev, "Failed to add ETH/W1 subdev\n");
> +		return ret;
> +	}
> +

Nit: Remove this line and place it below:

> +	ioc3_eth_id++;

Nit: '\n' here

> +	return 0;
> +}
> +
> +#define M48T35_REG_SIZE	32768	/* size of m48t35 registers */
> +
> +static struct resource ioc3_m48t35_resources[] = {
> +	DEFINE_RES_MEM(IOC3_BYTEBUS_DEV0, M48T35_REG_SIZE)
> +};
> +
> +static struct mfd_cell ioc3_m48t35_cells[] = {
> +	{
> +		.name = "rtc-m48t35",
> +		.resources = ioc3_m48t35_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_m48t35_resources),
> +	}
> +};
> +
> +static int ioc3_m48t35_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = mfd_add_devices(&ipd->pdev->dev, PLATFORM_DEVID_AUTO,
> +			      ioc3_m48t35_cells, ARRAY_SIZE(ioc3_m48t35_cells),
> +			      &ipd->pdev->resource[0], 0, ipd->domain);
> +	if (ret)
> +		dev_err(&ipd->pdev->dev, "Failed to add M48T35 subdev\n");
> +
> +	return ret;
> +}
> +
> +/*
> + * On IP30 the RTC (a DS1687) is behind the IOC3 on the generic
> + * ByteBus regions. We have to write the RTC address of interest to
> + * IOC3_BYTEBUS_DEV1, then read the data from IOC3_BYTEBUS_DEV2.
> + * rtc->regs already points to IOC3_BYTEBUS_DEV1.
> + */
> +#define IP30_RTC_ADDR(rtc) (rtc->regs)
> +#define IP30_RTC_DATA(rtc) ((rtc->regs) + IOC3_BYTEBUS_DEV2 - IOC3_BYTEBUS_DEV1)
> +
> +static u8 ip30_rtc_read(struct ds1685_priv *rtc, int reg)
> +{
> +	writeb((reg & 0x7f), IP30_RTC_ADDR(rtc));
> +	return readb(IP30_RTC_DATA(rtc));
> +}
> +
> +static void ip30_rtc_write(struct ds1685_priv *rtc, int reg, u8 value)
> +{
> +	writeb((reg & 0x7f), IP30_RTC_ADDR(rtc));
> +	writeb(value, IP30_RTC_DATA(rtc));
> +}

Why is this not in the RTC driver?

> +static struct ds1685_rtc_platform_data ip30_rtc_platform_data = {
> +	.bcd_mode = false,
> +	.no_irq = false,
> +	.uie_unsupported = true,
> +	.alloc_io_resources = true,

> +	.plat_read = ip30_rtc_read,
> +	.plat_write = ip30_rtc_write,

Call-backs in a non-subsystem API is pretty ugly IMHO.

Where are these called from?

> +};
> +
> +static struct resource ioc3_rtc_ds1685_resources[] = {
> +	DEFINE_RES_MEM(IOC3_BYTEBUS_DEV1,
> +		       IOC3_BYTEBUS_DEV2 - IOC3_BYTEBUS_DEV1 + 1),
> +	DEFINE_RES_IRQ(0)
> +};
> +
> +static struct mfd_cell ioc3_ds1685_cells[] = {
> +	{
> +		.name = "rtc-ds1685",
> +		.resources = ioc3_rtc_ds1685_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_rtc_ds1685_resources),
> +		.platform_data = &ip30_rtc_platform_data,
> +		.pdata_size = sizeof(ip30_rtc_platform_data),

> +		.id = -1,

Use the #define.  Same goes for below.

> +	}
> +};
> +
> +static int ioc3_ds1685_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, irq;
> +
> +	irq = ioc3_map_irq(ipd->pdev, 6);

Nit: '\n' here

> +	ret = mfd_add_devices(&ipd->pdev->dev, 0, ioc3_ds1685_cells,
> +			      ARRAY_SIZE(ioc3_ds1685_cells),
> +			      &ipd->pdev->resource[0], irq, NULL);
> +	if (ret)
> +		dev_err(&ipd->pdev->dev, "Failed to add DS1685 subdev\n");
> +
> +	return ret;
> +};
> +
> +
> +static struct resource ioc3_leds_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, gppr[0]),
> +		       sizeof_field(struct ioc3, gppr[0])),
> +	DEFINE_RES_MEM(offsetof(struct ioc3, gppr[1]),
> +		       sizeof_field(struct ioc3, gppr[1])),
> +};
> +
> +static struct mfd_cell ioc3_led_cells[] = {
> +	{
> +		.name = "ip30-leds",
> +		.resources = ioc3_leds_resources,
> +		.num_resources = ARRAY_SIZE(ioc3_leds_resources),
> +		.id = -1,
> +	}
> +};
> +
> +static int ioc3_led_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = mfd_add_devices(&ipd->pdev->dev, 0, ioc3_led_cells,
> +			      ARRAY_SIZE(ioc3_led_cells),
> +			      &ipd->pdev->resource[0], 0, ipd->domain);
> +	if (ret)
> +		dev_err(&ipd->pdev->dev, "Failed to add LED subdev\n");

Nit: '\n' here

> +	return ret;
> +}
> +
> +static int ip27_baseio_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 2);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;

Nit: '\n' here

> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;

Nit: '\n' here

> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;

Nit: '\n' here

Etc, etc, etc ... same for all of the instances below.

> +	return ioc3_m48t35_setup(ipd);
> +}
> +
> +static int ip27_baseio6g_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 2);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_m48t35_setup(ipd);
> +	if (ret)
> +		return ret;
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +static int ip27_mio_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +static int ip29_sysboard_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 1);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_m48t35_setup(ipd);
> +	if (ret)
> +		return ret;
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +static int ip30_sysboard_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 2);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_serial_setup(ipd);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_kbd_setup(ipd);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_ds1685_setup(ipd);
> +	if (ret)
> +		return ret;
> +	return ioc3_led_setup(ipd);
> +}
> +
> +static int ioc3_menet_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret, io_irq;
> +
> +	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 4);
> +	ret = ioc3_irq_domain_setup(ipd, io_irq);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_eth_setup(ipd, false);
> +	if (ret)
> +		return ret;
> +	return ioc3_serial_setup(ipd);
> +}
> +
> +static int ioc3_menet4_setup(struct ioc3_priv_data *ipd)
> +{
> +	return  ioc3_eth_setup(ipd, false);
> +}
> +
> +static int ioc3_cad_duo_setup(struct ioc3_priv_data *ipd)
> +{
> +	int ret;
> +
> +	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
> +	if (ret)
> +		return ret;
> +	ret = ioc3_eth_setup(ipd, true);
> +	if (ret)
> +		return ret;
> +	return ioc3_kbd_setup(ipd);
> +}
> +
> +#define IOC3_SID(_name, _sid, _setup) \
> +	{								   \
> +		.name = _name,						   \
> +		.sid = (PCI_VENDOR_ID_SGI << 16) | IOC3_SUBSYS_ ## _sid,   \
> +		.setup = _setup,					   \
> +	}
> +
> +static struct {
> +	const char *name;
> +	u32 sid;
> +	int (*setup)(struct ioc3_priv_data *ipd);
> +} ioc3_infos[] = {

IMHO it's neater if you separate the definition and static data part.

> +	IOC3_SID("IP27 BaseIO6G", IP27_BASEIO6G, &ip27_baseio6g_setup),
> +	IOC3_SID("IP27 MIO", IP27_MIO, &ip27_mio_setup),
> +	IOC3_SID("IP27 BaseIO", IP27_BASEIO, &ip27_baseio_setup),
> +	IOC3_SID("IP29 System Board", IP29_SYSBOARD, &ip29_sysboard_setup),
> +	IOC3_SID("IP30 System Board", IP30_SYSBOARD, &ip30_sysboard_setup),
> +	IOC3_SID("MENET", MENET, &ioc3_menet_setup),
> +	IOC3_SID("MENET4", MENET4, &ioc3_menet4_setup)
> +};
> +
> +static int ioc3_setup(struct ioc3_priv_data *ipd)
> +{
> +	u32 sid;
> +	int i;
> +
> +	/* Clear IRQs */
> +	writel(~0, &ipd->regs->sio_iec);
> +	writel(~0, &ipd->regs->sio_ir);
> +	writel(0, &ipd->regs->eth.eier);
> +	writel(~0, &ipd->regs->eth.eisr);
> +
> +	/* read subsystem vendor id and subsystem id */
> +	pci_read_config_dword(ipd->pdev, PCI_SUBSYSTEM_VENDOR_ID, &sid);
> +
> +	for (i = 0; i < ARRAY_SIZE(ioc3_infos); i++)
> +		if (sid == ioc3_infos[i].sid) {
> +			pr_info("ioc3: %s\n", ioc3_infos[i].name);
> +			return ioc3_infos[i].setup(ipd);
> +		}
> +
> +	/* treat everything not identified by PCI subid as CAD DUO */
> +	pr_info("ioc3: CAD DUO\n");
> +	return ioc3_cad_duo_setup(ipd);
> +}
> +
> +static int ioc3_mfd_probe(struct pci_dev *pdev,
> +			  const struct pci_device_id *pci_id)
> +{
> +	struct ioc3_priv_data *ipd;
> +	struct ioc3 __iomem *regs;
> +	int ret;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);

What does 64 mean here?  Define it perhaps?

> +	pci_set_master(pdev);
> +
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_warn(&pdev->dev, "Warning: couldn_t set 64-bit DMA mask\n");

Remove the "Warning:" part please.

"Failed to set 64-bit DMA mask - trying 32-bit" ?

> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			dev_err(&pdev->dev, "Can't set DMA mask, aborting\n");
> +			return ret;
> +		}
> +	}
> +
> +	/* Set up per-IOC3 data */
> +	ipd = devm_kzalloc(&pdev->dev, sizeof(struct ioc3_priv_data),
> +			   GFP_KERNEL);
> +	if (!ipd) {
> +		ret = -ENOMEM;
> +		goto out_disable_device;
> +	}
> +	ipd->pdev = pdev;
> +
> +	/*
> +	 * Map all IOC3 registers.  These are shared between subdevices
> +	 * so the main IOC3 module manages them.
> +	 */
> +	regs = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
> +			    pci_resource_len(pdev, 0));
> +	if (!regs) {
> +		pr_warn("ioc3: Unable to remap PCI BAR for %s.\n",
> +			pci_name(pdev));

Why are you using pr_warn() here?

> +		ret = -ENOMEM;
> +		goto out_disable_device;
> +	}
> +	ipd->regs = regs;
> +
> +	/* Track PCI-device specific data */
> +	pci_set_drvdata(pdev, ipd);
> +
> +	ret = ioc3_setup(ipd);
> +	if (ret)
> +		goto out_disable_device;
> +
> +	return 0;
> +
> +out_disable_device:
> +	pci_disable_device(pdev);
> +	return ret;
> +}
> +
> +static void ioc3_mfd_remove(struct pci_dev *pdev)
> +{
> +	struct ioc3_priv_data *ipd;
> +
> +	ipd = pci_get_drvdata(pdev);
> +
> +	/* Clear and disable all IRQs */
> +	writel(~0, &ipd->regs->sio_iec);
> +	writel(~0, &ipd->regs->sio_ir);
> +
> +	/* Release resources */
> +	if (ipd->domain) {
> +		irq_domain_remove(ipd->domain);
> +		free_irq(ipd->domain_irq, (void *)ipd);
> +	}
> +	pci_disable_device(pdev);
> +}
> +
> +static struct pci_device_id ioc3_mfd_id_table[] = {
> +	{ PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC3, PCI_ANY_ID, PCI_ANY_ID },
> +	{ 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, ioc3_mfd_id_table);
> +
> +static struct pci_driver ioc3_mfd_driver = {
> +	.name = "IOC3",
> +	.id_table = ioc3_mfd_id_table,
> +	.probe = ioc3_mfd_probe,
> +	.remove = ioc3_mfd_remove,
> +};
> +
> +module_pci_driver(ioc3_mfd_driver);
> +
> +MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfer@suse.de>");
> +MODULE_DESCRIPTION("SGI IOC3 MFD driver");
> +MODULE_LICENSE("GPL");

GPL v2 ?

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
