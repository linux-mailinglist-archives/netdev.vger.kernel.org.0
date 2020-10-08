Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BBB2877D4
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbgJHPrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:47:18 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:60635 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbgJHPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:47:06 -0400
Received: from localhost.localdomain ([192.30.34.233]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N6szR-1kQzFZ04GF-018Kqj; Thu, 08 Oct 2020 17:46:30 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] net: remove am79c961a driver
Date:   Thu,  8 Oct 2020 17:46:00 +0200
Message-Id: <20201008154601.1901004-3-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201008154601.1901004-1-arnd@arndb.de>
References: <20201008154601.1901004-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:s5O0sfhALFOb6+MRPFncANZrRW2qs6RHVZ/1MLuDghwJe3O6uSK
 9zGBW3yymqlfPKMtksHktLqM1ERSGI3bh4viORN9b/mA0FoGkO46IrVY3cIORA8na1CUiw3
 usPD/+P1vXPzEYlW4iY2xa6wgP8CL83g8I4b4Kjr6SbL8CgA+HQlRDVOwif9JarKcHz7FzI
 n0714RtA8QwtjlUZnv+dw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UoB1ODQKRvE=:6OHk+5JixKLOTohxYHzYSO
 /X0cHra6Ztz7t/QMKAnsLYq3eowoTBMnHe+rHwIpW9WVikp63ooZydh24W4lV2EKv0Lf2T8NT
 JEP7BZ/hQDToPy7gG0JqQxefEFKPhzSNSCnZ/27I6+LrnjOSAe6Nn8mHvIeTksnMZPb4jJX9R
 cFTY2NMHYFI7H/HE+EbapHlCRNOjVEMgu1FVwH8WosOK6SfooReX2Yw3e005aJTVFVqYl4gcl
 yCb7iu3Wsk6tR53tJYbeo+7E6hQahfvxzhnjeZAzeZEO2ZEuEK3HEjrTdaQRD7/TwTCNRYhoh
 ZjMJIQ85Ze2o3hvEDVCT/gpwppGBPqGWrmaHpbeEaADnXYOce0x7BnkXGSEYyUEPYDpO/nuV9
 n/P6O0Kd3XiU2r/rk+7syhfLld/x/alingoiles4NOUrhW6FHNgyNUsgGKsnLuLE6zPS7aC/L
 +FW92KHYBgjm2bSM4fpc/QMAw+fhU73fFSCijD/5YBaZc7AjmuIC7u0jDwlYfYmjqYYRxpL7e
 UMMtefAD7w2h3Gl975yxG5zr64h4W5rP0+FktwrLXMitwXbqFzYumIynnu5/xlxTb0+S9gOO1
 NFXfyJveY4dbNn8oINKTNKXhaFRqEN7TTTEW6wESHmJy+XdNEMJIVrOEelhwoKhqo/4PxYwCu
 JmyIHit+HzXw8C0ZbNVTaBr+Z5eOTtFjikrxMh7ZFUVrfsFlhms+0gXFC97S6+4CkNuGQ+osM
 Cg4V0dPet/CmpDgi4hSMU0mO5OOcFjSJD69qmSwgmL6ODX3WZ2dWqQhjzpjRlmBkgCo6J3t69
 C/gwLueM6d5CLaua8q/6qhx2P7GvK+wlbtcAp0YwaiRpsE84nMeAwkI9ho8CtWtDtG0zYei
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was only used on the EBSA110 platform, which is now
getting removed, so the driver is no longer needed either.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/amd/Kconfig     |  10 +-
 drivers/net/ethernet/amd/Makefile    |   1 -
 drivers/net/ethernet/amd/am79c961a.c | 763 ---------------------------
 drivers/net/ethernet/amd/am79c961a.h | 143 -----
 4 files changed, 1 insertion(+), 916 deletions(-)
 delete mode 100644 drivers/net/ethernet/amd/am79c961a.c
 delete mode 100644 drivers/net/ethernet/amd/am79c961a.h

diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index db7d956a9c9b..d0b0609bbe23 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -8,7 +8,7 @@ config NET_VENDOR_AMD
 	default y
 	depends on DIO || MACH_DECSTATION || MVME147 || ATARI || SUN3 || \
 		   SUN3X || SBUS || PCI || ZORRO || (ISA && ISA_DMA_API) || \
-		   (ARM && ARCH_EBSA110) || ISA || EISA || PCMCIA || ARM64
+		   ISA || EISA || PCMCIA || ARM64
 	help
 	  If you have a network (Ethernet) chipset belonging to this class,
 	  say Y.
@@ -75,14 +75,6 @@ config ARIADNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called ariadne.
 
-config ARM_AM79C961A
-	bool "ARM EBSA110 AM79C961A support"
-	depends on ARM && ARCH_EBSA110
-	select CRC32
-	help
-	  If you wish to compile a kernel for the EBSA-110, then you should
-	  always answer Y to this.
-
 config ATARILANCE
 	tristate "Atari LANCE support"
 	depends on ATARI
diff --git a/drivers/net/ethernet/amd/Makefile b/drivers/net/ethernet/amd/Makefile
index 45f86822a5f7..0d2f478b49a5 100644
--- a/drivers/net/ethernet/amd/Makefile
+++ b/drivers/net/ethernet/amd/Makefile
@@ -5,7 +5,6 @@
 
 obj-$(CONFIG_A2065) += a2065.o
 obj-$(CONFIG_AMD8111_ETH) += amd8111e.o
-obj-$(CONFIG_ARM_AM79C961A) += am79c961a.o
 obj-$(CONFIG_ARIADNE) += ariadne.o
 obj-$(CONFIG_ATARILANCE) += atarilance.o
 obj-$(CONFIG_DECLANCE) += declance.o
diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/amd/am79c961a.c
deleted file mode 100644
index 1c53408f5d47..000000000000
--- a/drivers/net/ethernet/amd/am79c961a.c
+++ /dev/null
@@ -1,763 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- *  linux/drivers/net/ethernet/amd/am79c961a.c
- *
- *  by Russell King <rmk@arm.linux.org.uk> 1995-2001.
- *
- * Derived from various things including skeleton.c
- *
- * This is a special driver for the am79c961A Lance chip used in the
- * Intel (formally Digital Equipment Corp) EBSA110 platform.  Please
- * note that this can not be built as a module (it doesn't make sense).
- */
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/errno.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/crc32.h>
-#include <linux/bitops.h>
-#include <linux/platform_device.h>
-#include <linux/io.h>
-
-#include <mach/hardware.h>
-
-#define TX_BUFFERS 15
-#define RX_BUFFERS 25
-
-#include "am79c961a.h"
-
-static irqreturn_t
-am79c961_interrupt (int irq, void *dev_id);
-
-static unsigned int net_debug = NET_DEBUG;
-
-static const char version[] =
-	"am79c961 ethernet driver (C) 1995-2001 Russell King v0.04\n";
-
-/* --------------------------------------------------------------------------- */
-
-#ifdef __arm__
-static void write_rreg(u_long base, u_int reg, u_int val)
-{
-	asm volatile(
-	"strh	%1, [%2]	@ NET_RAP\n\t"
-	"strh	%0, [%2, #-4]	@ NET_RDP"
-	:
-	: "r" (val), "r" (reg), "r" (ISAIO_BASE + 0x0464));
-}
-
-static inline unsigned short read_rreg(u_long base_addr, u_int reg)
-{
-	unsigned short v;
-	asm volatile(
-	"strh	%1, [%2]	@ NET_RAP\n\t"
-	"ldrh	%0, [%2, #-4]	@ NET_RDP"
-	: "=r" (v)
-	: "r" (reg), "r" (ISAIO_BASE + 0x0464));
-	return v;
-}
-
-static inline void write_ireg(u_long base, u_int reg, u_int val)
-{
-	asm volatile(
-	"strh	%1, [%2]	@ NET_RAP\n\t"
-	"strh	%0, [%2, #8]	@ NET_IDP"
-	:
-	: "r" (val), "r" (reg), "r" (ISAIO_BASE + 0x0464));
-}
-
-static inline unsigned short read_ireg(u_long base_addr, u_int reg)
-{
-	u_short v;
-	asm volatile(
-	"strh	%1, [%2]	@ NAT_RAP\n\t"
-	"ldrh	%0, [%2, #8]	@ NET_IDP\n\t"
-	: "=r" (v)
-	: "r" (reg), "r" (ISAIO_BASE + 0x0464));
-	return v;
-}
-
-#define am_writeword(dev,off,val) __raw_writew(val, ISAMEM_BASE + ((off) << 1))
-#define am_readword(dev,off)      __raw_readw(ISAMEM_BASE + ((off) << 1))
-
-static void
-am_writebuffer(struct net_device *dev, u_int offset, unsigned char *buf, unsigned int length)
-{
-	offset = ISAMEM_BASE + (offset << 1);
-	length = (length + 1) & ~1;
-	if ((int)buf & 2) {
-		asm volatile("strh	%2, [%0], #4"
-		 : "=&r" (offset) : "0" (offset), "r" (buf[0] | (buf[1] << 8)));
-		buf += 2;
-		length -= 2;
-	}
-	while (length > 8) {
-		register unsigned int tmp asm("r2"), tmp2 asm("r3");
-		asm volatile(
-			"ldmia	%0!, {%1, %2}"
-			: "+r" (buf), "=&r" (tmp), "=&r" (tmp2));
-		length -= 8;
-		asm volatile(
-			"strh	%1, [%0], #4\n\t"
-			"mov	%1, %1, lsr #16\n\t"
-			"strh	%1, [%0], #4\n\t"
-			"strh	%2, [%0], #4\n\t"
-			"mov	%2, %2, lsr #16\n\t"
-			"strh	%2, [%0], #4"
-		: "+r" (offset), "=&r" (tmp), "=&r" (tmp2));
-	}
-	while (length > 0) {
-		asm volatile("strh	%2, [%0], #4"
-		 : "=&r" (offset) : "0" (offset), "r" (buf[0] | (buf[1] << 8)));
-		buf += 2;
-		length -= 2;
-	}
-}
-
-static void
-am_readbuffer(struct net_device *dev, u_int offset, unsigned char *buf, unsigned int length)
-{
-	offset = ISAMEM_BASE + (offset << 1);
-	length = (length + 1) & ~1;
-	if ((int)buf & 2) {
-		unsigned int tmp;
-		asm volatile(
-			"ldrh	%2, [%0], #4\n\t"
-			"strb	%2, [%1], #1\n\t"
-			"mov	%2, %2, lsr #8\n\t"
-			"strb	%2, [%1], #1"
-		: "=&r" (offset), "=&r" (buf), "=r" (tmp): "0" (offset), "1" (buf));
-		length -= 2;
-	}
-	while (length > 8) {
-		register unsigned int tmp asm("r2"), tmp2 asm("r3"), tmp3;
-		asm volatile(
-			"ldrh	%2, [%0], #4\n\t"
-			"ldrh	%4, [%0], #4\n\t"
-			"ldrh	%3, [%0], #4\n\t"
-			"orr	%2, %2, %4, lsl #16\n\t"
-			"ldrh	%4, [%0], #4\n\t"
-			"orr	%3, %3, %4, lsl #16\n\t"
-			"stmia	%1!, {%2, %3}"
-		: "=&r" (offset), "=&r" (buf), "=r" (tmp), "=r" (tmp2), "=r" (tmp3)
-		: "0" (offset), "1" (buf));
-		length -= 8;
-	}
-	while (length > 0) {
-		unsigned int tmp;
-		asm volatile(
-			"ldrh	%2, [%0], #4\n\t"
-			"strb	%2, [%1], #1\n\t"
-			"mov	%2, %2, lsr #8\n\t"
-			"strb	%2, [%1], #1"
-		: "=&r" (offset), "=&r" (buf), "=r" (tmp) : "0" (offset), "1" (buf));
-		length -= 2;
-	}
-}
-#else
-#error Not compatible
-#endif
-
-static int
-am79c961_ramtest(struct net_device *dev, unsigned int val)
-{
-	unsigned char *buffer = kmalloc (65536, GFP_KERNEL);
-	int i, error = 0, errorcount = 0;
-
-	if (!buffer)
-		return 0;
-	memset (buffer, val, 65536);
-	am_writebuffer(dev, 0, buffer, 65536);
-	memset (buffer, val ^ 255, 65536);
-	am_readbuffer(dev, 0, buffer, 65536);
-	for (i = 0; i < 65536; i++) {
-		if (buffer[i] != val && !error) {
-			printk ("%s: buffer error (%02X %02X) %05X - ", dev->name, val, buffer[i], i);
-			error = 1;
-			errorcount ++;
-		} else if (error && buffer[i] == val) {
-			printk ("%05X\n", i);
-			error = 0;
-		}
-	}
-	if (error)
-		printk ("10000\n");
-	kfree (buffer);
-	return errorcount;
-}
-
-static void am79c961_mc_hash(char *addr, u16 *hash)
-{
-	int idx, bit;
-	u32 crc;
-
-	crc = ether_crc_le(ETH_ALEN, addr);
-
-	idx = crc >> 30;
-	bit = (crc >> 26) & 15;
-
-	hash[idx] |= 1 << bit;
-}
-
-static unsigned int am79c961_get_rx_mode(struct net_device *dev, u16 *hash)
-{
-	unsigned int mode = MODE_PORT_10BT;
-
-	if (dev->flags & IFF_PROMISC) {
-		mode |= MODE_PROMISC;
-		memset(hash, 0xff, 4 * sizeof(*hash));
-	} else if (dev->flags & IFF_ALLMULTI) {
-		memset(hash, 0xff, 4 * sizeof(*hash));
-	} else {
-		struct netdev_hw_addr *ha;
-
-		memset(hash, 0, 4 * sizeof(*hash));
-
-		netdev_for_each_mc_addr(ha, dev)
-			am79c961_mc_hash(ha->addr, hash);
-	}
-
-	return mode;
-}
-
-static void
-am79c961_init_for_open(struct net_device *dev)
-{
-	struct dev_priv *priv = netdev_priv(dev);
-	unsigned long flags;
-	unsigned char *p;
-	u_int hdr_addr, first_free_addr;
-	u16 multi_hash[4], mode = am79c961_get_rx_mode(dev, multi_hash);
-	int i;
-
-	/*
-	 * Stop the chip.
-	 */
-	spin_lock_irqsave(&priv->chip_lock, flags);
-	write_rreg (dev->base_addr, CSR0, CSR0_BABL|CSR0_CERR|CSR0_MISS|CSR0_MERR|CSR0_TINT|CSR0_RINT|CSR0_STOP);
-	spin_unlock_irqrestore(&priv->chip_lock, flags);
-
-	write_ireg (dev->base_addr, 5, 0x00a0); /* Receive address LED */
-	write_ireg (dev->base_addr, 6, 0x0081); /* Collision LED */
-	write_ireg (dev->base_addr, 7, 0x0090); /* XMIT LED */
-	write_ireg (dev->base_addr, 2, 0x0000); /* MODE register selects media */
-
-	for (i = LADRL; i <= LADRH; i++)
-		write_rreg (dev->base_addr, i, multi_hash[i - LADRL]);
-
-	for (i = PADRL, p = dev->dev_addr; i <= PADRH; i++, p += 2)
-		write_rreg (dev->base_addr, i, p[0] | (p[1] << 8));
-
-	write_rreg (dev->base_addr, MODE, mode);
-	write_rreg (dev->base_addr, POLLINT, 0);
-	write_rreg (dev->base_addr, SIZERXR, -RX_BUFFERS);
-	write_rreg (dev->base_addr, SIZETXR, -TX_BUFFERS);
-
-	first_free_addr = RX_BUFFERS * 8 + TX_BUFFERS * 8 + 16;
-	hdr_addr = 0;
-
-	priv->rxhead = 0;
-	priv->rxtail = 0;
-	priv->rxhdr = hdr_addr;
-
-	for (i = 0; i < RX_BUFFERS; i++) {
-		priv->rxbuffer[i] = first_free_addr;
-		am_writeword (dev, hdr_addr, first_free_addr);
-		am_writeword (dev, hdr_addr + 2, RMD_OWN);
-		am_writeword (dev, hdr_addr + 4, (-1600));
-		am_writeword (dev, hdr_addr + 6, 0);
-		first_free_addr += 1600;
-		hdr_addr += 8;
-	}
-	priv->txhead = 0;
-	priv->txtail = 0;
-	priv->txhdr = hdr_addr;
-	for (i = 0; i < TX_BUFFERS; i++) {
-		priv->txbuffer[i] = first_free_addr;
-		am_writeword (dev, hdr_addr, first_free_addr);
-		am_writeword (dev, hdr_addr + 2, TMD_STP|TMD_ENP);
-		am_writeword (dev, hdr_addr + 4, 0xf000);
-		am_writeword (dev, hdr_addr + 6, 0);
-		first_free_addr += 1600;
-		hdr_addr += 8;
-	}
-
-	write_rreg (dev->base_addr, BASERXL, priv->rxhdr);
-	write_rreg (dev->base_addr, BASERXH, 0);
-	write_rreg (dev->base_addr, BASETXL, priv->txhdr);
-	write_rreg (dev->base_addr, BASERXH, 0);
-	write_rreg (dev->base_addr, CSR0, CSR0_STOP);
-	write_rreg (dev->base_addr, CSR3, CSR3_IDONM|CSR3_BABLM|CSR3_DXSUFLO);
-	write_rreg (dev->base_addr, CSR4, CSR4_APAD_XMIT|CSR4_MFCOM|CSR4_RCVCCOM|CSR4_TXSTRTM|CSR4_JABM);
-	write_rreg (dev->base_addr, CSR0, CSR0_IENA|CSR0_STRT);
-}
-
-static void am79c961_timer(struct timer_list *t)
-{
-	struct dev_priv *priv = from_timer(priv, t, timer);
-	struct net_device *dev = priv->dev;
-	unsigned int lnkstat, carrier;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->chip_lock, flags);
-	lnkstat = read_ireg(dev->base_addr, ISALED0) & ISALED0_LNKST;
-	spin_unlock_irqrestore(&priv->chip_lock, flags);
-	carrier = netif_carrier_ok(dev);
-
-	if (lnkstat && !carrier) {
-		netif_carrier_on(dev);
-		printk("%s: link up\n", dev->name);
-	} else if (!lnkstat && carrier) {
-		netif_carrier_off(dev);
-		printk("%s: link down\n", dev->name);
-	}
-
-	mod_timer(&priv->timer, jiffies + msecs_to_jiffies(500));
-}
-
-/*
- * Open/initialize the board.
- */
-static int
-am79c961_open(struct net_device *dev)
-{
-	struct dev_priv *priv = netdev_priv(dev);
-	int ret;
-
-	ret = request_irq(dev->irq, am79c961_interrupt, 0, dev->name, dev);
-	if (ret)
-		return ret;
-
-	am79c961_init_for_open(dev);
-
-	netif_carrier_off(dev);
-
-	priv->timer.expires = jiffies;
-	add_timer(&priv->timer);
-
-	netif_start_queue(dev);
-
-	return 0;
-}
-
-/*
- * The inverse routine to am79c961_open().
- */
-static int
-am79c961_close(struct net_device *dev)
-{
-	struct dev_priv *priv = netdev_priv(dev);
-	unsigned long flags;
-
-	del_timer_sync(&priv->timer);
-
-	netif_stop_queue(dev);
-	netif_carrier_off(dev);
-
-	spin_lock_irqsave(&priv->chip_lock, flags);
-	write_rreg (dev->base_addr, CSR0, CSR0_STOP);
-	write_rreg (dev->base_addr, CSR3, CSR3_MASKALL);
-	spin_unlock_irqrestore(&priv->chip_lock, flags);
-
-	free_irq (dev->irq, dev);
-
-	return 0;
-}
-
-/*
- * Set or clear promiscuous/multicast mode filter for this adapter.
- */
-static void am79c961_setmulticastlist (struct net_device *dev)
-{
-	struct dev_priv *priv = netdev_priv(dev);
-	unsigned long flags;
-	u16 multi_hash[4], mode = am79c961_get_rx_mode(dev, multi_hash);
-	int i, stopped;
-
-	spin_lock_irqsave(&priv->chip_lock, flags);
-
-	stopped = read_rreg(dev->base_addr, CSR0) & CSR0_STOP;
-
-	if (!stopped) {
-		/*
-		 * Put the chip into suspend mode
-		 */
-		write_rreg(dev->base_addr, CTRL1, CTRL1_SPND);
-
-		/*
-		 * Spin waiting for chip to report suspend mode
-		 */
-		while ((read_rreg(dev->base_addr, CTRL1) & CTRL1_SPND) == 0) {
-			spin_unlock_irqrestore(&priv->chip_lock, flags);
-			nop();
-			spin_lock_irqsave(&priv->chip_lock, flags);
-		}
-	}
-
-	/*
-	 * Update the multicast hash table
-	 */
-	for (i = 0; i < ARRAY_SIZE(multi_hash); i++)
-		write_rreg(dev->base_addr, i + LADRL, multi_hash[i]);
-
-	/*
-	 * Write the mode register
-	 */
-	write_rreg(dev->base_addr, MODE, mode);
-
-	if (!stopped) {
-		/*
-		 * Put the chip back into running mode
-		 */
-		write_rreg(dev->base_addr, CTRL1, 0);
-	}
-
-	spin_unlock_irqrestore(&priv->chip_lock, flags);
-}
-
-static void am79c961_timeout(struct net_device *dev, unsigned int txqueue)
-{
-	printk(KERN_WARNING "%s: transmit timed out, network cable problem?\n",
-		dev->name);
-
-	/*
-	 * ought to do some setup of the tx side here
-	 */
-
-	netif_wake_queue(dev);
-}
-
-/*
- * Transmit a packet
- */
-static netdev_tx_t
-am79c961_sendpacket(struct sk_buff *skb, struct net_device *dev)
-{
-	struct dev_priv *priv = netdev_priv(dev);
-	unsigned int hdraddr, bufaddr;
-	unsigned int head;
-	unsigned long flags;
-
-	head = priv->txhead;
-	hdraddr = priv->txhdr + (head << 3);
-	bufaddr = priv->txbuffer[head];
-	head += 1;
-	if (head >= TX_BUFFERS)
-		head = 0;
-
-	am_writebuffer (dev, bufaddr, skb->data, skb->len);
-	am_writeword (dev, hdraddr + 4, -skb->len);
-	am_writeword (dev, hdraddr + 2, TMD_OWN|TMD_STP|TMD_ENP);
-	priv->txhead = head;
-
-	spin_lock_irqsave(&priv->chip_lock, flags);
-	write_rreg (dev->base_addr, CSR0, CSR0_TDMD|CSR0_IENA);
-	spin_unlock_irqrestore(&priv->chip_lock, flags);
-
-	/*
-	 * If the next packet is owned by the ethernet device,
-	 * then the tx ring is full and we can't add another
-	 * packet.
-	 */
-	if (am_readword(dev, priv->txhdr + (priv->txhead << 3) + 2) & TMD_OWN)
-		netif_stop_queue(dev);
-
-	dev_consume_skb_any(skb);
-
-	return NETDEV_TX_OK;
-}
-
-/*
- * If we have a good packet(s), get it/them out of the buffers.
- */
-static void
-am79c961_rx(struct net_device *dev, struct dev_priv *priv)
-{
-	do {
-		struct sk_buff *skb;
-		u_int hdraddr;
-		u_int pktaddr;
-		u_int status;
-		int len;
-
-		hdraddr = priv->rxhdr + (priv->rxtail << 3);
-		pktaddr = priv->rxbuffer[priv->rxtail];
-
-		status = am_readword (dev, hdraddr + 2);
-		if (status & RMD_OWN) /* do we own it? */
-			break;
-
-		priv->rxtail ++;
-		if (priv->rxtail >= RX_BUFFERS)
-			priv->rxtail = 0;
-
-		if ((status & (RMD_ERR|RMD_STP|RMD_ENP)) != (RMD_STP|RMD_ENP)) {
-			am_writeword (dev, hdraddr + 2, RMD_OWN);
-			dev->stats.rx_errors++;
-			if (status & RMD_ERR) {
-				if (status & RMD_FRAM)
-					dev->stats.rx_frame_errors++;
-				if (status & RMD_CRC)
-					dev->stats.rx_crc_errors++;
-			} else if (status & RMD_STP)
-				dev->stats.rx_length_errors++;
-			continue;
-		}
-
-		len = am_readword(dev, hdraddr + 6);
-		skb = netdev_alloc_skb(dev, len + 2);
-
-		if (skb) {
-			skb_reserve(skb, 2);
-
-			am_readbuffer(dev, pktaddr, skb_put(skb, len), len);
-			am_writeword(dev, hdraddr + 2, RMD_OWN);
-			skb->protocol = eth_type_trans(skb, dev);
-			netif_rx(skb);
-			dev->stats.rx_bytes += len;
-			dev->stats.rx_packets++;
-		} else {
-			am_writeword (dev, hdraddr + 2, RMD_OWN);
-			dev->stats.rx_dropped++;
-			break;
-		}
-	} while (1);
-}
-
-/*
- * Update stats for the transmitted packet
- */
-static void
-am79c961_tx(struct net_device *dev, struct dev_priv *priv)
-{
-	do {
-		short len;
-		u_int hdraddr;
-		u_int status;
-
-		hdraddr = priv->txhdr + (priv->txtail << 3);
-		status = am_readword (dev, hdraddr + 2);
-		if (status & TMD_OWN)
-			break;
-
-		priv->txtail ++;
-		if (priv->txtail >= TX_BUFFERS)
-			priv->txtail = 0;
-
-		if (status & TMD_ERR) {
-			u_int status2;
-
-			dev->stats.tx_errors++;
-
-			status2 = am_readword (dev, hdraddr + 6);
-
-			/*
-			 * Clear the error byte
-			 */
-			am_writeword (dev, hdraddr + 6, 0);
-
-			if (status2 & TST_RTRY)
-				dev->stats.collisions += 16;
-			if (status2 & TST_LCOL)
-				dev->stats.tx_window_errors++;
-			if (status2 & TST_LCAR)
-				dev->stats.tx_carrier_errors++;
-			if (status2 & TST_UFLO)
-				dev->stats.tx_fifo_errors++;
-			continue;
-		}
-		dev->stats.tx_packets++;
-		len = am_readword (dev, hdraddr + 4);
-		dev->stats.tx_bytes += -len;
-	} while (priv->txtail != priv->txhead);
-
-	netif_wake_queue(dev);
-}
-
-static irqreturn_t
-am79c961_interrupt(int irq, void *dev_id)
-{
-	struct net_device *dev = (struct net_device *)dev_id;
-	struct dev_priv *priv = netdev_priv(dev);
-	u_int status, n = 100;
-	int handled = 0;
-
-	do {
-		status = read_rreg(dev->base_addr, CSR0);
-		write_rreg(dev->base_addr, CSR0, status &
-			   (CSR0_IENA|CSR0_TINT|CSR0_RINT|
-			    CSR0_MERR|CSR0_MISS|CSR0_CERR|CSR0_BABL));
-
-		if (status & CSR0_RINT) {
-			handled = 1;
-			am79c961_rx(dev, priv);
-		}
-		if (status & CSR0_TINT) {
-			handled = 1;
-			am79c961_tx(dev, priv);
-		}
-		if (status & CSR0_MISS) {
-			handled = 1;
-			dev->stats.rx_dropped++;
-		}
-		if (status & CSR0_CERR) {
-			handled = 1;
-			mod_timer(&priv->timer, jiffies);
-		}
-	} while (--n && status & (CSR0_RINT | CSR0_TINT));
-
-	return IRQ_RETVAL(handled);
-}
-
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void am79c961_poll_controller(struct net_device *dev)
-{
-	unsigned long flags;
-	local_irq_save(flags);
-	am79c961_interrupt(dev->irq, dev);
-	local_irq_restore(flags);
-}
-#endif
-
-/*
- * Initialise the chip.  Note that we always expect
- * to be entered with interrupts enabled.
- */
-static int
-am79c961_hw_init(struct net_device *dev)
-{
-	struct dev_priv *priv = netdev_priv(dev);
-
-	spin_lock_irq(&priv->chip_lock);
-	write_rreg (dev->base_addr, CSR0, CSR0_STOP);
-	write_rreg (dev->base_addr, CSR3, CSR3_MASKALL);
-	spin_unlock_irq(&priv->chip_lock);
-
-	am79c961_ramtest(dev, 0x66);
-	am79c961_ramtest(dev, 0x99);
-
-	return 0;
-}
-
-static void __init am79c961_banner(void)
-{
-	static unsigned version_printed;
-
-	if (net_debug && version_printed++ == 0)
-		printk(KERN_INFO "%s", version);
-}
-static const struct net_device_ops am79c961_netdev_ops = {
-	.ndo_open		= am79c961_open,
-	.ndo_stop		= am79c961_close,
-	.ndo_start_xmit		= am79c961_sendpacket,
-	.ndo_set_rx_mode	= am79c961_setmulticastlist,
-	.ndo_tx_timeout		= am79c961_timeout,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_mac_address	= eth_mac_addr,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= am79c961_poll_controller,
-#endif
-};
-
-static int am79c961_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	struct net_device *dev;
-	struct dev_priv *priv;
-	int i, ret;
-
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!res)
-		return -ENODEV;
-
-	dev = alloc_etherdev(sizeof(struct dev_priv));
-	ret = -ENOMEM;
-	if (!dev)
-		goto out;
-
-	SET_NETDEV_DEV(dev, &pdev->dev);
-
-	priv = netdev_priv(dev);
-
-	/*
-	 * Fixed address and IRQ lines here.
-	 * The PNP initialisation should have been
-	 * done by the ether bootp loader.
-	 */
-	dev->base_addr = res->start;
-	ret = platform_get_irq(pdev, 0);
-
-	if (ret < 0) {
-		ret = -ENODEV;
-		goto nodev;
-	}
-	dev->irq = ret;
-
-	ret = -ENODEV;
-	if (!request_region(dev->base_addr, 0x18, dev->name))
-		goto nodev;
-
-	/*
-	 * Reset the device.
-	 */
-	inb(dev->base_addr + NET_RESET);
-	udelay(5);
-
-	/*
-	 * Check the manufacturer part of the
-	 * ether address.
-	 */
-	if (inb(dev->base_addr) != 0x08 ||
-	    inb(dev->base_addr + 2) != 0x00 ||
-	    inb(dev->base_addr + 4) != 0x2b)
-	    	goto release;
-
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(dev->base_addr + i * 2) & 0xff;
-
-	am79c961_banner();
-
-	spin_lock_init(&priv->chip_lock);
-	priv->dev = dev;
-	timer_setup(&priv->timer, am79c961_timer, 0);
-
-	if (am79c961_hw_init(dev))
-		goto release;
-
-	dev->netdev_ops = &am79c961_netdev_ops;
-
-	ret = register_netdev(dev);
-	if (ret == 0) {
-		printk(KERN_INFO "%s: ether address %pM\n",
-		       dev->name, dev->dev_addr);
-		return 0;
-	}
-
-release:
-	release_region(dev->base_addr, 0x18);
-nodev:
-	free_netdev(dev);
-out:
-	return ret;
-}
-
-static struct platform_driver am79c961_driver = {
-	.probe		= am79c961_probe,
-	.driver		= {
-		.name	= "am79c961",
-	},
-};
-
-static int __init am79c961_init(void)
-{
-	return platform_driver_register(&am79c961_driver);
-}
-
-__initcall(am79c961_init);
diff --git a/drivers/net/ethernet/amd/am79c961a.h b/drivers/net/ethernet/amd/am79c961a.h
deleted file mode 100644
index 73679e053ceb..000000000000
--- a/drivers/net/ethernet/amd/am79c961a.h
+++ /dev/null
@@ -1,143 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * linux/drivers/net/ethernet/amd/am79c961a.h
- */
-
-#ifndef _LINUX_am79c961a_H
-#define _LINUX_am79c961a_H
-
-/* use 0 for production, 1 for verification, >2 for debug. debug flags: */
-#define DEBUG_TX	 2
-#define DEBUG_RX	 4
-#define DEBUG_INT	 8
-#define DEBUG_IC	16
-#ifndef NET_DEBUG
-#define NET_DEBUG 	0
-#endif
-
-#define NET_UID		0
-#define NET_RDP		0x10
-#define NET_RAP		0x12
-#define NET_RESET	0x14
-#define NET_IDP		0x16
-
-/*
- * RAP registers
- */
-#define CSR0		0
-#define CSR0_INIT	0x0001
-#define CSR0_STRT	0x0002
-#define CSR0_STOP	0x0004
-#define CSR0_TDMD	0x0008
-#define CSR0_TXON	0x0010
-#define CSR0_RXON	0x0020
-#define CSR0_IENA	0x0040
-#define CSR0_INTR	0x0080
-#define CSR0_IDON	0x0100
-#define CSR0_TINT	0x0200
-#define CSR0_RINT	0x0400
-#define CSR0_MERR	0x0800
-#define CSR0_MISS	0x1000
-#define CSR0_CERR	0x2000
-#define CSR0_BABL	0x4000
-#define CSR0_ERR	0x8000
-
-#define CSR3		3
-#define CSR3_EMBA	0x0008
-#define CSR3_DXMT2PD	0x0010
-#define CSR3_LAPPEN	0x0020
-#define CSR3_DXSUFLO	0x0040
-#define CSR3_IDONM	0x0100
-#define CSR3_TINTM	0x0200
-#define CSR3_RINTM	0x0400
-#define CSR3_MERRM	0x0800
-#define CSR3_MISSM	0x1000
-#define CSR3_BABLM	0x4000
-#define CSR3_MASKALL	0x5F00
-
-#define CSR4		4
-#define CSR4_JABM	0x0001
-#define CSR4_JAB	0x0002
-#define CSR4_TXSTRTM	0x0004
-#define CSR4_TXSTRT	0x0008
-#define CSR4_RCVCCOM	0x0010
-#define CSR4_RCVCCO	0x0020
-#define CSR4_MFCOM	0x0100
-#define CSR4_MFCO	0x0200
-#define CSR4_ASTRP_RCV	0x0400
-#define CSR4_APAD_XMIT	0x0800
-
-#define CTRL1		5
-#define CTRL1_SPND	0x0001
-
-#define LADRL		8
-#define LADRM1		9
-#define LADRM2		10
-#define LADRH		11
-#define PADRL		12
-#define PADRM		13
-#define PADRH		14
-
-#define MODE		15
-#define MODE_DISRX	0x0001
-#define MODE_DISTX	0x0002
-#define MODE_LOOP	0x0004
-#define MODE_DTCRC	0x0008
-#define MODE_COLL	0x0010
-#define MODE_DRETRY	0x0020
-#define MODE_INTLOOP	0x0040
-#define MODE_PORT_AUI	0x0000
-#define MODE_PORT_10BT	0x0080
-#define MODE_DRXPA	0x2000
-#define MODE_DRXBA	0x4000
-#define MODE_PROMISC	0x8000
-
-#define BASERXL		24
-#define BASERXH		25
-#define BASETXL		30
-#define BASETXH		31
-
-#define POLLINT		47
-
-#define SIZERXR		76
-#define SIZETXR		78
-
-#define CSR_MFC		112
-
-#define RMD_ENP		0x0100
-#define RMD_STP		0x0200
-#define RMD_CRC		0x0800
-#define RMD_FRAM	0x2000
-#define RMD_ERR		0x4000
-#define RMD_OWN		0x8000
-
-#define TMD_ENP		0x0100
-#define TMD_STP		0x0200
-#define TMD_MORE	0x1000
-#define TMD_ERR		0x4000
-#define TMD_OWN		0x8000
-
-#define TST_RTRY	0x0400
-#define TST_LCAR	0x0800
-#define TST_LCOL	0x1000
-#define TST_UFLO	0x4000
-#define TST_BUFF	0x8000
-
-#define ISALED0		0x0004
-#define ISALED0_LNKST	0x8000
-
-struct dev_priv {
-    unsigned long	rxbuffer[RX_BUFFERS];
-    unsigned long	txbuffer[TX_BUFFERS];
-    unsigned char	txhead;
-    unsigned char	txtail;
-    unsigned char	rxhead;
-    unsigned char	rxtail;
-    unsigned long	rxhdr;
-    unsigned long	txhdr;
-    spinlock_t		chip_lock;
-    struct timer_list	timer;
-    struct net_device   *dev;
-};
-
-#endif
-- 
2.27.0

