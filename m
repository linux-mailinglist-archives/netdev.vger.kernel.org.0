Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BDE175E8
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 12:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfEHKXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 06:23:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37151 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfEHKXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 06:23:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id y5so2539419wma.2
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 03:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ucZ6at1XKHJqIIhg2nk64ojJqaEj/3I/Bd6y724Puzw=;
        b=xmDIrN6YBuUemMu30+t7di/G2BekA2eQ9n223SnOV5gW0n9FfEBEunkgb9rKUSpjl7
         5Qp5uF+EYVDie44tNf2vPKouMQ8ktH45mIDaA3/N0y2rp5QnUQxDeYhfuBsN0o3NqI2b
         30+f6agZ+s91VZ56SSEsr4MhG284ISlBlC229/g7yMmLctkjEe3i2GJUVEIzXdByunAP
         esLHf0H/7mqc86oxFk5XQ3HhEHEoIWhUiM05qpYfHmPv4qO15I/Y3awCikP6oyKAitk5
         6m749VdHfdaNivAw00MGGlUMDZxqvPKgHLin8WToYJ4P9ZI1wiGB2wFW8L2zGJHMSs19
         DD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ucZ6at1XKHJqIIhg2nk64ojJqaEj/3I/Bd6y724Puzw=;
        b=PMVVr8/dog6yrls9dhUoe5cDjDLiobi3XYEm/j543lVRRzZY24LfUnUHW3skJXbxSN
         viVlALHo9HTBeTqyDBXhyVX0gnEVaMwnOxWr8QShxtDPSlplt00b14/lwrFNVLlCwsa5
         gdvBro/smr4x7JgyatRavJ/a5PaWHhw+uoTdNbUsAh3Wn4s7b1HF7Mp+736PsBtBuyvb
         QIrtOnEKcaHFD1GIefQAcRqtcb07nU0dC3uOJ3hvi5oj7GAfLL5+B69r3sPacO4hRlwF
         ZeOW20TpH9hS8V+OJqPoshgUwBJzUvGPm2D269z1t8imiV4H4UlcuoZrysqV8BZgVZ2U
         aB4A==
X-Gm-Message-State: APjAAAVndUq56BXFJqw/jvieXc/chG2uGlnC/oMS9x9eEs1GrxOEVK3e
        JWJ+Uim/9ENfdRfRHfVl9In/3g==
X-Google-Smtp-Source: APXvYqyn8yig8JdBl/ulUiq8jgpr+I/G+n1X4mGpfDPgm+VTb+T3QzEO+wqdYR4peDY/rUVLDTKp5w==
X-Received: by 2002:a1c:5fd4:: with SMTP id t203mr2421955wmb.56.1557310996144;
        Wed, 08 May 2019 03:23:16 -0700 (PDT)
Received: from dell ([2.27.167.43])
        by smtp.gmail.com with ESMTPSA id a20sm39077123wrf.37.2019.05.08.03.23.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 03:23:15 -0700 (PDT)
Date:   Wed, 8 May 2019 11:23:13 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20190508102313.GG3995@dell>
References: <20190409154610.6735-1-tbogendoerfer@suse.de>
 <20190409154610.6735-3-tbogendoerfer@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190409154610.6735-3-tbogendoerfer@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 09 Apr 2019, Thomas Bogendoerfer wrote:

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
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  arch/mips/include/asm/sn/ioc3.h       |  345 +++---
>  arch/mips/sgi-ip27/ip27-timer.c       |   20 -
>  drivers/mfd/Kconfig                   |   13 +
>  drivers/mfd/Makefile                  |    1 +
>  drivers/mfd/ioc3.c                    |  802 ++++++++++++++
>  drivers/net/ethernet/sgi/Kconfig      |    4 +-
>  drivers/net/ethernet/sgi/ioc3-eth.c   | 1867 ++++++++++++---------------------
>  drivers/tty/serial/8250/8250_ioc3.c   |   98 ++
>  drivers/tty/serial/8250/Kconfig       |   11 +
>  drivers/tty/serial/8250/Makefile      |    1 +
>  include/linux/platform_data/ioc3eth.h |   15 +
>  11 files changed, 1762 insertions(+), 1415 deletions(-)
>  create mode 100644 drivers/mfd/ioc3.c
>  create mode 100644 drivers/tty/serial/8250/8250_ioc3.c
>  create mode 100644 include/linux/platform_data/ioc3eth.h

[...]

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
> index b4569ed7f3f3..07255e499129 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -246,4 +246,5 @@ obj-$(CONFIG_MFD_MXS_LRADC)     += mxs-lradc.o
>  obj-$(CONFIG_MFD_SC27XX_PMIC)	+= sprd-sc27xx-spi.o
>  obj-$(CONFIG_RAVE_SP_CORE)	+= rave-sp.o
>  obj-$(CONFIG_MFD_ROHM_BD718XX)	+= rohm-bd718x7.o
> +obj-$(CONFIG_SGI_MFD_IOC3)	+= ioc3.o
>  
> diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
> new file mode 100644
> index 000000000000..ad715805b16e
> --- /dev/null
> +++ b/drivers/mfd/ioc3.c
> @@ -0,0 +1,802 @@
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
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/core.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/ioc3eth.h>

These should be in alphabetical order.

> +#include <asm/sn/ioc3.h>
> +#include <asm/pci/bridge.h>
> +
> +#define IOC3_ETH	BIT(0)
> +#define IOC3_SER	BIT(1)
> +#define IOC3_PAR	BIT(2)
> +#define IOC3_KBD	BIT(3)
> +#define IOC3_M48T35	BIT(4)
> +
> +static int ioc3_serial_id = 1;
> +static int ioc3_eth_id = 1;
> +static int ioc3_kbd_id = 1;
> +static struct mfd_cell ioc3_mfd_cells[5];
> +
> +struct ioc3_board_info {
> +	const char *name;
> +	int irq_offset;
> +	int funcs;
> +};
> +
> +struct ioc3_priv_data {
> +	struct ioc3_board_info *info;
> +	struct irq_domain *domain;
> +	struct ioc3 __iomem *regs;
> +	struct pci_dev *pdev;
> +	char nic_part[32];
> +	char nic_mac[6];
> +	int irq_io;
> +};
> +
> +#define MCR_PACK(pulse, sample)	(((pulse) << 10) | ((sample) << 2))
> +
> +static int ioc3_nic_wait(u32 __iomem *mcr)
> +{
> +	u32 mcr_val;
> +
> +	do {
> +		mcr_val = readl(mcr);
> +	} while (!(mcr_val & 2));

Why 2?  Is bit 2 always set on a successful read?

Either way, you should provide a comment to improve readability.

> +	return (mcr_val & 1);

Reads just a bit at a time?  Again, a comment please.

> +}
> +
> +static int ioc3_nic_reset(u32 __iomem *mcr)
> +{
> +	int presence;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	writel(MCR_PACK(520, 65), mcr);

What do these magic values mean?  Best to define them.

> +	presence = ioc3_nic_wait(mcr);
> +	local_irq_restore(flags);
> +
> +	udelay(500);

What are you waiting for?  Why 500us?

> +	return presence;
> +}
> +
> +static int ioc3_nic_read_bit(u32 __iomem *mcr)
> +{
> +	int result;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	writel(MCR_PACK(6, 13), mcr);

Why 6 and 13?

Define all magic values please.

> +	result = ioc3_nic_wait(mcr);
> +	local_irq_restore(flags);
> +
> +	udelay(100);

Why 100?

> +	return result;
> +}
> +
> +static u32 ioc3_nic_read_byte(u32 __iomem *mcr)
> +{
> +	u32 result = 0;
> +	int i;
> +
> +	for (i = 0; i < 8; i++)
> +		result = ((result >> 1) | (ioc3_nic_read_bit(mcr) << 7));
> +
> +	return result;
> +}
> +
> +static void ioc3_nic_write_bit(u32 __iomem *mcr, int bit)
> +{
> +	if (bit)
> +		writel(MCR_PACK(6, 110), mcr);
> +	else
> +		writel(MCR_PACK(80, 30), mcr);
> +
> +	ioc3_nic_wait(mcr);
> +}
> +
> +static void ioc3_nic_write_byte(u32 __iomem *mcr, int byte)
> +{
> +	int i;
> +
> +	for (i = 0; i < 8; i++) {
> +		ioc3_nic_write_bit(mcr, byte & 1);
> +		byte >>= 1;
> +	}
> +}
> +
> +static u64 ioc3_nic_find(u32 __iomem *mcr, int *last, u64 addr)
> +{
> +	int a, b, index, disc;
> +
> +	ioc3_nic_reset(mcr);
> +
> +	/* Search ROM.  */
> +	ioc3_nic_write_byte(mcr, 0xf0);

What does 0xf0 mean?

Please define it and all magic numbers that follow.

> +	/* Algorithm from ``Book of iButton Standards''.  */

That's great, but what is it actually doing.  Please provide suitable
comments such that the reader doesn't have to painstakingly work it
all out.

> +	for (index = 0, disc = 0; index < 64; index++) {
> +		a = ioc3_nic_read_bit(mcr);
> +		b = ioc3_nic_read_bit(mcr);
> +
> +		if (unlikely(a && b)) {
> +			pr_warn("ioc3: NIC search failed.\n");
> +			*last = 0;
> +			return 0;
> +		}
> +
> +		if (!a && !b) {
> +			if (index == *last)
> +				addr |= 1UL << index;
> +			else if (index > *last) {
> +				addr &= ~(1UL << index);
> +				disc = index;
> +			} else if ((addr & (1UL << index)) == 0)
> +				disc = index;
> +			ioc3_nic_write_bit(mcr, (addr >> index) & 1);
> +			continue;
> +		} else {
> +			if (a)
> +				addr |= (1UL << index);
> +			else
> +				addr &= ~(1UL << index);
> +			ioc3_nic_write_bit(mcr, a);
> +			continue;
> +		}
> +	}
> +	*last = disc;
> +	return addr;
> +}
> +
> +static void ioc3_nic_addr(u32 __iomem *mcr, u64 addr)
> +{
> +	int index;
> +
> +	ioc3_nic_reset(mcr);
> +	ioc3_nic_write_byte(mcr, 0xf0);
> +
> +	for (index = 0; index < 64; index++) {
> +		ioc3_nic_read_bit(mcr);
> +		ioc3_nic_read_bit(mcr);
> +		ioc3_nic_write_bit(mcr, ((addr >> index) & 1));
> +	}

What is this function doing?  Setting the NIC address?

Why are the 2 sequential reads required before each bit write?

> +}
> +
> +static void crc16_byte(u32 *crc, u8 db)
> +{
> +	int i;
> +
> +	for (i = 0; i < 8; i++) {
> +		*crc <<= 1;
> +		if ((db ^ (*crc >> 16)) & 1)
> +			*crc ^= 0x8005;
> +		db >>= 1;
> +	}
> +	*crc &= 0xffff;
> +}
> +
> +static u32 crc16_area(u8 *dbs, int size, u32 crc)
> +{
> +	while (size--)
> +		crc16_byte(&crc, *(dbs++));
> +
> +	return crc;
> +}
> +
> +static void crc8_byte(u32 *crc, u8 db)
> +{
> +	int i, f;
> +
> +	for (i = 0; i < 8; i++) {
> +		f = ((*crc ^ db) & 1);
> +		*crc >>= 1;
> +		db >>= 1;
> +		if (f)
> +			*crc ^= 0x8c;
> +	}
> +	*crc &= 0xff;
> +}
> +
> +static u32 crc8_addr(u64 addr)
> +{
> +	u32 crc = 0;
> +	int i;
> +
> +	for (i = 0; i < 64; i += 8)
> +		crc8_byte(&crc, addr >> i);
> +	return crc;
> +}

Not looked into these in any detail, but are you not able to use the
CRC functions already provided by the kernel?

> +static void ioc3_read_redir_page(u32 __iomem *mcr, u64 addr, int page,

What is a redir page?

> +				 u8 *redir, u8 *data)
> +{
> +	int loops = 16, i;
> +
> +	while (redir[page] != 0xff) {
> +		page = (redir[page] ^ 0xff);
> +		loops--;
> +		if (unlikely(loops < 0)) {
> +			pr_err("ioc3: NIC circular redirection\n");
> +			return;
> +		}
> +	}
> +
> +	loops = 3;
> +	while (loops > 0) {
> +		ioc3_nic_addr(mcr, addr);
> +		ioc3_nic_write_byte(mcr, 0xf0);
> +		ioc3_nic_write_byte(mcr, (page << 5) & 0xe0);
> +		ioc3_nic_write_byte(mcr, (page >> 3) & 0x1f);
> +
> +		for (i = 0; i < 0x20; i++)
> +			data[i] = ioc3_nic_read_byte(mcr);
> +
> +		if (crc16_area(data, 0x20, 0) == 0x800d)
> +			return;
> +
> +		loops--;
> +	}
> +
> +	pr_err("ioc3: CRC error in data page\n");
> +	for (i = 0; i < 0x20; i++)
> +		data[i] = 0x00;

Comments required throughout.

> +}
> +
> +static void ioc3_read_redir_map(u32 __iomem *mcr, u64 addr, u8 *redir)
> +{
> +	int i, j, crc_ok, loops = 3;
> +	u32 crc;
> +
> +	while (loops > 0) {
> +		crc_ok = 1;
> +		ioc3_nic_addr(mcr, addr);
> +		ioc3_nic_write_byte(mcr, 0xaa);
> +		ioc3_nic_write_byte(mcr, 0x00);
> +		ioc3_nic_write_byte(mcr, 0x01);
> +
> +		for (i = 0; i < 64; i += 8) {
> +			for (j = 0; j < 8; j++)
> +				redir[i + j] = ioc3_nic_read_byte(mcr);
> +
> +			crc = crc16_area(redir + i, 8, i == 0 ? 0x8707 : 0);
> +
> +			crc16_byte(&crc, ioc3_nic_read_byte(mcr));
> +			crc16_byte(&crc, ioc3_nic_read_byte(mcr));
> +
> +			if (crc != 0x800d)
> +				crc_ok = 0;
> +		}
> +		if (crc_ok)
> +			return;
> +		loops--;
> +	}
> +	pr_err("ioc3: CRC error in redirection page\n");
> +	for (i = 0; i < 64; i++)
> +		redir[i] = 0xff;

As above.

> +}
> +
> +static void ioc3_read_nic(struct ioc3_priv_data *ipd, u32 __iomem *mcr,
> +			  u64 addr)
> +{
> +	u8 redir[64];
> +	u8 data[64], part[32];
> +	int i, j;
> +
> +	/* Read redirections */
> +	ioc3_read_redir_map(mcr, addr, redir);
> +
> +	/* Read data pages */
> +	ioc3_read_redir_page(mcr, addr, 0, redir, data);
> +	ioc3_read_redir_page(mcr, addr, 1, redir, (data + 32));
> +
> +	/* Assemble the part # */
> +	j = 0;
> +	for (i = 0; i < 19; i++)
> +		if (data[i + 11] != ' ')
> +			part[j++] = data[i + 11];
> +
> +	for (i = 0; i < 6; i++)
> +		if (data[i + 32] != ' ')
> +			part[j++] = data[i + 32];
> +
> +	part[j] = 0;
> +
> +	/* Skip Octane (IP30) power supplies */
> +	if (!(strncmp(part, "060-0035-", 9)) ||
> +	    !(strncmp(part, "060-0038-", 9)) ||
> +	    !(strncmp(part, "060-0028-", 9)))
> +		return;
> +
> +	strlcpy(ipd->nic_part, part, sizeof(ipd->nic_part));
> +}
> +
> +static void ioc3_read_mac(struct ioc3_priv_data *ipd, u64 addr)
> +{
> +	int i, loops = 3;
> +	u8 data[13];
> +	u32 __iomem *mcr = &ipd->regs->mcr;
> +
> +	while (loops > 0) {
> +		ioc3_nic_addr(mcr, addr);
> +		ioc3_nic_write_byte(mcr, 0xf0);
> +		ioc3_nic_write_byte(mcr, 0x00);
> +		ioc3_nic_write_byte(mcr, 0x00);
> +		ioc3_nic_read_byte(mcr);
> +
> +		for (i = 0; i < 13; i++)
> +			data[i] = ioc3_nic_read_byte(mcr);
> +
> +		if (crc16_area(data, 13, 0) == 0x800d) {
> +			for (i = 10; i > 4; i--)
> +				ipd->nic_mac[10 - i] = data[i];
> +			return;
> +		}
> +		loops--;
> +	}
> +
> +	pr_err("ioc3: CRC error in MAC address\n");
> +	for (i = 0; i < 6; i++)
> +		ipd->nic_mac[i] = 0x00;
> +}
> +
> +static void ioc3_probe_nic(struct ioc3_priv_data *ipd, u32 __iomem *mcr)
> +{
> +	int save = 0, loops = 3;
> +	u64 first, addr;
> +
> +	while (loops > 0) {
> +		ipd->nic_part[0] = 0;
> +		first = ioc3_nic_find(mcr, &save, 0);
> +		addr = first;
> +
> +		if (unlikely(!first))
> +			return;
> +
> +		while (1) {
> +			if (crc8_addr(addr))
> +				break;
> +
> +			switch (addr & 0xff) {
> +			case 0x0b:
> +				ioc3_read_nic(ipd, mcr, addr);
> +				break;
> +			case 0x09:
> +			case 0x89:
> +			case 0x91:
> +				ioc3_read_mac(ipd, addr);
> +				break;
> +			}
> +
> +			addr = ioc3_nic_find(mcr, &save, addr);
> +			if (addr == first)
> +				return;
> +		}
> +		loops--;
> +	}
> +	pr_err("ioc3: CRC error in NIC address\n");
> +}

This all looks like networking code.  If this is the case, it should
be moved to drivers/networking or similar.

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
> +#define IOC3_LVL_MASK	(BIT(0) | BIT(2) | BIT(6) | BIT(9) | BIT(11) | BIT(15))

You need to define what each of these bits are.  BIT(2) doesn't tell
the reader anything, meaning the code is unreadable.

> +static int ioc3_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +			      irq_hw_number_t hwirq)
> +{
> +	if (BIT(hwirq) & IOC3_LVL_MASK)

Comment needed.

> +		irq_set_chip_and_handler(irq, &ioc3_irq_chip, handle_level_irq);
> +	else
> +		irq_set_chip_and_handler(irq, &ioc3_irq_chip, handle_edge_irq);
> +
> +	irq_set_chip_data(irq, d->host_data);
> +	return 0;
> +}
> +
> +

Drop the superfluous '\n'.

> +static const struct irq_domain_ops ioc3_irq_domain_ops = {
> +	.map = ioc3_irq_domain_map,
> +};
> +
> +static void ioc3_irq_handler(struct irq_desc *desc)
> +{
> +	struct irq_domain *domain = irq_desc_get_handler_data(desc);
> +	struct ioc3_priv_data *ipd = domain->host_data;
> +	struct ioc3 __iomem *regs = ipd->regs;
> +	unsigned int irq = 0;

Why does these need to be pre-assigned?

> +	u32 pending;
> +
> +	pending = readl(&regs->sio_ir);
> +	pending &= readl(&regs->sio_ies);

Comment required.

> +	if (pending)
> +		irq = irq_find_mapping(domain, __ffs(pending));
> +	else if (!ipd->info->irq_offset &&
> +		 (readl(&regs->eth.eisr) & readl(&regs->eth.eier)))

Comment required.

> +		irq = irq_find_mapping(domain, 23);
> +
> +	if (irq)
> +		generic_handle_irq(irq);
> +	else
> +		spurious_interrupt();
> +}
> +
> +static struct resource ioc3_uarta_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uarta),

You are the first user of offsetof() in MFD.  Could you tell me why
it's required please?

> +		       sizeof_field(struct ioc3, sregs.uarta)),
> +	DEFINE_RES_IRQ(6)

Please define all magic numbers.

> +};
> +
> +static struct resource ioc3_uartb_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uartb),
> +		       sizeof_field(struct ioc3, sregs.uartb)),
> +	DEFINE_RES_IRQ(15)
> +};
> +
> +static struct resource ioc3_kbd_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, serio),
> +		       sizeof_field(struct ioc3, serio)),
> +	DEFINE_RES_IRQ(22)
> +};
> +
> +static struct resource ioc3_eth_resources[] = {
> +	DEFINE_RES_MEM(offsetof(struct ioc3, eth),
> +		       sizeof_field(struct ioc3, eth)),
> +	DEFINE_RES_MEM(offsetof(struct ioc3, ssram),
> +		       sizeof_field(struct ioc3, ssram)),
> +	DEFINE_RES_IRQ(0)
> +};
> +
> +static struct ioc3eth_platform_data ioc3_eth_platform_data;

I doubt you'll need this in here.  The MAC address info will need to
be moved out to a networking driver of some sort.

> +#ifdef CONFIG_SGI_IP27

#ifery in C files is highly discouraged.  Please remove them.

> +static struct resource ioc3_rtc_resources[] = {
> +	DEFINE_RES_MEM(IOC3_BYTEBUS_DEV0, 32768)

Define all magic numbers please.

> +};
> +
> +static struct ioc3_board_info ip27_baseio_info = {
> +	.name = "IP27 BaseIO",
> +	.funcs = IOC3_ETH | IOC3_SER | IOC3_M48T35,
> +	.irq_offset = 2
> +};
> +
> +static struct ioc3_board_info ip27_baseio6g_info = {
> +	.name = "IP27 BaseIO6G",
> +	.funcs = IOC3_ETH | IOC3_SER | IOC3_KBD | IOC3_M48T35,
> +	.irq_offset = 2
> +};
> +
> +static struct ioc3_board_info ip27_mio_info = {
> +	.name = "MIO",
> +	.funcs = IOC3_SER | IOC3_PAR | IOC3_KBD,
> +	.irq_offset = 0
> +};
> +
> +static struct ioc3_board_info ip29_baseio_info = {
> +	.name = "IP29 System Board",
> +	.funcs = IOC3_ETH | IOC3_SER | IOC3_PAR | IOC3_KBD | IOC3_M48T35,
> +	.irq_offset = 1
> +};
> +
> +#endif /* CONFIG_SGI_IP27 */
> +
> +static struct ioc3_board_info ioc3_menet_info = {
> +	.name = "MENET",
> +	.funcs = IOC3_ETH | IOC3_SER,
> +	.irq_offset = 4
> +};
> +
> +static struct ioc3_board_info ioc3_cad_duo_info = {
> +	.name = "CAD DUO",
> +	.funcs = IOC3_ETH | IOC3_KBD,
> +	.irq_offset = 0
> +};

Please drop all of these and statically create the MFD cells like
almost all other MFD drivers do.

> +#define IOC3_BOARD(_partno, _info) {   .info = _info, .match = _partno }
> +
> +static struct {
> +	struct ioc3_board_info *info;
> +	const char *match;
> +} ioc3_boards[] = {
> +#ifdef CONFIG_SGI_IP27
> +	IOC3_BOARD("030-0734-", &ip27_baseio6g_info),
> +	IOC3_BOARD("030-1023-", &ip27_baseio_info),
> +	IOC3_BOARD("030-1124-", &ip27_baseio_info),
> +	IOC3_BOARD("030-1025-", &ip29_baseio_info),
> +	IOC3_BOARD("030-1244-", &ip29_baseio_info),
> +	IOC3_BOARD("030-1389-", &ip29_baseio_info),
> +	IOC3_BOARD("030-0880-", &ip27_mio_info),
> +#endif
> +	IOC3_BOARD("030-0873-", &ioc3_menet_info),
> +	IOC3_BOARD("030-1155-", &ioc3_cad_duo_info),
> +};
> +
> +static int ioc3_identify(struct ioc3_priv_data *idp)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ioc3_boards); i++)
> +		if (!strncmp(idp->nic_part, ioc3_boards[i].match,
> +			     strlen(ioc3_boards[i].match))) {
> +			idp->info = ioc3_boards[i].info;
> +			return 0;
> +		}
> +
> +	return -1;

Please return a proper Linux error code.

> +}
> +
> +static void ioc3_create_devices(struct ioc3_priv_data *ipd)
> +{
> +	struct mfd_cell *cell;
> +
> +	memset(ioc3_mfd_cells, 0, sizeof(ioc3_mfd_cells));
> +	cell = ioc3_mfd_cells;
> +
> +	if (ipd->info->funcs & IOC3_ETH) {
> +		memcpy(ioc3_eth_platform_data.mac_addr, ipd->nic_mac,
> +		       sizeof(ioc3_eth_platform_data.mac_addr));

Better to pull the MAC address from within the Ethernet driver.

> +		cell->name = "ioc3-eth";
> +		cell->id = ioc3_eth_id++;
> +		cell->resources = ioc3_eth_resources;
> +		cell->num_resources = ARRAY_SIZE(ioc3_eth_resources);
> +		cell->platform_data = &ioc3_eth_platform_data;
> +		cell->pdata_size = sizeof(ioc3_eth_platform_data);

Please define all of this in a static struct, external to this
function.

> +		if (ipd->info->irq_offset) {
> +			/*
> +			 * Ethernet interrupt is on an extra interrupt
> +			 * not inside the irq domain, so we need an
> +			 * extra mfd_add_devices without the domain
> +			 * argument
> +			 */
> +			ioc3_eth_resources[2].start = ipd->pdev->irq;
> +			ioc3_eth_resources[2].end = ipd->pdev->irq;

Using '2' is fragile.

In this case, seeing as you're using the parent's IRQ, you can obtain
the IRQ using the usual platform_*() handlers, using pdev->parent.

> +			mfd_add_devices(&ipd->pdev->dev, -1, cell, 1,

Don't use -1, use the defines instead.

Instead of 1, use ARRAY_SIZE() once the cells are defined statically.

> +					&ipd->pdev->resource[0], 0, NULL);
> +			memset(cell, 0, sizeof(*cell));
> +		} else {
> +			/* fake hwirq in domain */

What does this mean?

> +			ioc3_eth_resources[2].start = 23;
> +			ioc3_eth_resources[2].end = 23;
> +			cell++;
> +		}
> +	}
> +	if (ipd->info->funcs & IOC3_SER) {
> +		writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL,
> +			&ipd->regs->gpcr_s);
> +		writel(0, &ipd->regs->gppr[6]);
> +		writel(0, &ipd->regs->gppr[7]);
> +		udelay(100);
> +		writel(readl(&ipd->regs->port_a.sscr) & ~SSCR_DMA_EN,
> +		       &ipd->regs->port_a.sscr);
> +		writel(readl(&ipd->regs->port_b.sscr) & ~SSCR_DMA_EN,
> +		       &ipd->regs->port_b.sscr);
> +		udelay(1000);

No idea what any of this does.

It looks like it belongs in the serial driver (and needs comments).

> +		cell->name = "ioc3-serial8250";
> +		cell->id = ioc3_serial_id++;
> +		cell->resources = ioc3_uarta_resources;
> +		cell->num_resources = ARRAY_SIZE(ioc3_uarta_resources);
> +		cell++;
> +		cell->name = "ioc3-serial8250";
> +		cell->id = ioc3_serial_id++;
> +		cell->resources = ioc3_uartb_resources;
> +		cell->num_resources = ARRAY_SIZE(ioc3_uartb_resources);
> +		cell++;

Please define this statically.

> +	}
> +	if (ipd->info->funcs & IOC3_KBD) {
> +		cell->name = "ioc3-kbd",
> +		cell->id = ioc3_kbd_id++;
> +		cell->resources = ioc3_kbd_resources,
> +		cell->num_resources = ARRAY_SIZE(ioc3_kbd_resources),
> +		cell++;

As above.

> +	}
> +#if defined(CONFIG_SGI_IP27)

What is this?  Can't you obtain this dynamically by probing the H/W?

> +	if (ipd->info->funcs & IOC3_M48T35) {
> +		cell->name = "rtc-m48t35";
> +		cell->id = -1;
> +		cell->resources = ioc3_rtc_resources;
> +		cell->num_resources = ARRAY_SIZE(ioc3_rtc_resources);
> +		cell++;

Static please.

> +	}
> +#endif
> +	mfd_add_devices(&ipd->pdev->dev, -1, ioc3_mfd_cells,

Use the defines.

> +			cell - ioc3_mfd_cells, &ipd->pdev->resource[0],

?

> +			0, ipd->domain);
> +}
> +
> +static int ioc3_mfd_probe(struct pci_dev *pdev,
> +			  const struct pci_device_id *pci_id)
> +{
> +	struct ioc3_priv_data *ipd;
> +	int err, ret = -ENODEV, io_irqno;
> +	struct ioc3 __iomem *regs;
> +	struct irq_domain *domain;
> +	struct fwnode_handle *fn;
> +
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		return err;
> +
> +	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
> +	pci_set_master(pdev);
> +
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_warn(&pdev->dev, "Warning: couldn_t set 64-bit DMA mask\n");
> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			dev_err(&pdev->dev, "Can't set DMA mask, aborting\n");
> +			return ret;
> +		}
> +	}
> +
> +	/* Set up per-IOC3 data */
> +	ipd = kzalloc(sizeof(struct ioc3_priv_data), GFP_KERNEL);

Does PCI not provide managed (devm_*() like) helpers?

> +	if (!ipd) {
> +		ret = -ENOMEM;
> +		goto out_disable_device;
> +	}
> +	ipd->pdev = pdev;

'\n'

> +	/*
> +	 * Map all IOC3 registers.  These are shared between subdevices
> +	 * so the main IOC3 module manages them.
> +	 */
> +	regs = pci_ioremap_bar(pdev, 0);
> +	if (!regs) {
> +		pr_warn("ioc3: Unable to remap PCI BAR for %s.\n",
> +			pci_name(pdev));
> +		goto out_free_ipd;
> +	}
> +	ipd->regs = regs;
> +
> +	/* Track PCI-device specific data */
> +	pci_set_drvdata(pdev, ipd);

Do you don't need 'ipd->pdev = pdev' then.

> +	writel(GPCR_MLAN_EN, &ipd->regs->gpcr_s);
> +	ioc3_probe_nic(ipd, &regs->mcr);

This should probably be moved to the networking driver.

> +#ifdef CONFIG_SGI_IP27

No #ifery in MFD c-files please.

> +	/* BaseIO NIC is attached to bridge */
> +	if (!ipd->nic_part[0]) {
> +		struct bridge_controller *bc = BRIDGE_CONTROLLER(pdev->bus);
> +
> +		ioc3_probe_nic(ipd, &bc->base->b_nic);
> +	}
> +#endif
> +
> +	if (ioc3_identify(ipd)) {
> +		pr_err("ioc3: part: [%s] unknown card\n", ipd->nic_part);
> +		goto out_iounmap;
> +	}
> +
> +	pr_info("ioc3: part: [%s] %s\n", ipd->nic_part, ipd->info->name);
> +
> +	/* Clear IRQs */

A comment!  I just fell off my chair! =;-)

> +	writel(~0, &regs->sio_iec);
> +	writel(~0, &regs->sio_ir);
> +	writel(0, &regs->eth.eier);
> +	writel(~0, &regs->eth.eisr);
> +
> +	if (ipd->info->irq_offset) {

What does this really signify?

> +		struct pci_host_bridge *hbrg = pci_find_host_bridge(pdev->bus);
> +
> +		io_irqno = hbrg->map_irq(pdev,
> +			PCI_SLOT(pdev->devfn) + ipd->info->irq_offset, 0);
> +	} else {
> +		io_irqno = pdev->irq;
> +	}
> +	ipd->irq_io = io_irqno;
> +
> +	fn = irq_domain_alloc_named_fwnode("IOC3");
> +	if (!fn)
> +		goto out_iounmap;
> +
> +	domain = irq_domain_create_linear(fn, 24, &ioc3_irq_domain_ops, ipd);
> +	irq_domain_free_fwnode(fn);
> +	if (!domain)
> +		goto out_iounmap;
> +	ipd->domain = domain;
> +
> +	irq_set_chained_handler_and_data(io_irqno, ioc3_irq_handler, domain);
> +
> +	ioc3_create_devices(ipd);
> +
> +	return 0;
> +
> +out_iounmap:
> +	iounmap(ipd->regs);
> +
> +out_free_ipd:
> +	kfree(ipd);
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
> +	irq_domain_remove(ipd->domain);
> +	free_irq(ipd->irq_io, (void *)ipd);
> +	iounmap(ipd->regs);
> +
> +	pci_disable_device(pdev);
> +
> +	kfree(ipd);
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

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
