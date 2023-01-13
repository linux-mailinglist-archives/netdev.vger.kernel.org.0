Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA269668D02
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbjAMG3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240573AbjAMGZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:25:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE1410073;
        Thu, 12 Jan 2023 22:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yNX/9/e3mCL8Z9/A5TRWG0UKPW9ZyWcnD51C6LTuRVI=; b=Ylt8A4HngYHMxsdrT3HnhJDlSV
        iJ170NFOhoE5/jm4B0r2iZEgG/7ENapsBN7EG3eTyLKpN5X9ZYXjsypPqcTfmEHfo+RwMWyPpP/3+
        mjrTudLbbjWOokwEpDHR/SYDPQjEdYu2BrhFltpnBqms3qC6BjqFpSVzUExolaX5+7GIWz7XCFYWp
        EnNcdwUy6QpwLO2RM/m2LT0BcRLf2dwVUO5JUTWY6khIjWo2kMDSALL69dwv9d7JksbiErk0cYjJy
        F0GEfksn110Oud3Mh6LP7zQRl0CYW85Mx25oaHsuUudRug/Y9kNkATuSeuGsCBnzF27GOv603zDC4
        VB09RLNw==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUH-000ljq-PK; Fri, 13 Jan 2023 06:24:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 12/22] net/ethernet/8390: remove stnic
Date:   Fri, 13 Jan 2023 07:23:29 +0100
Message-Id: <20230113062339.1909087-13-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113062339.1909087-1-hch@lst.de>
References: <20230113062339.1909087-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that arch/sh is removed this driver is dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/8390/Kconfig  |  12 --
 drivers/net/ethernet/8390/Makefile |   1 -
 drivers/net/ethernet/8390/stnic.c  | 302 -----------------------------
 3 files changed, 315 deletions(-)
 delete mode 100644 drivers/net/ethernet/8390/stnic.c

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index eb90de04c88419..a7976743be9ee3 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -155,18 +155,6 @@ config PCMCIA_PCNET
 	  To compile this driver as a module, choose M here: the module will be
 	  called pcnet_cs.  If unsure, say N.
 
-config STNIC
-	tristate "National DP83902AV  support"
-	depends on SUPERH
-	select CRC32
-	help
-	  Support for cards based on the National Semiconductor DP83902AV
-	  ST-NIC Serial Network Interface Controller for Twisted Pair.  This
-	  is a 10Mbit/sec Ethernet controller.  Product overview and specs at
-	  <http://www.national.com/pf/DP/DP83902A.html>.
-
-	  If unsure, say N.
-
 config ULTRA
 	tristate "SMC Ultra support"
 	depends on ISA
diff --git a/drivers/net/ethernet/8390/Makefile b/drivers/net/ethernet/8390/Makefile
index 85c83c566ec663..3819a3bb75a1c9 100644
--- a/drivers/net/ethernet/8390/Makefile
+++ b/drivers/net/ethernet/8390/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_NE2000) += ne.o 8390p.o
 obj-$(CONFIG_NE2K_PCI) += ne2k-pci.o 8390.o
 obj-$(CONFIG_PCMCIA_AXNET) += axnet_cs.o 8390.o
 obj-$(CONFIG_PCMCIA_PCNET) += pcnet_cs.o 8390.o
-obj-$(CONFIG_STNIC) += stnic.o 8390.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
 obj-$(CONFIG_WD80x3) += wd.o 8390.o
 obj-$(CONFIG_XSURF100) += xsurf100.o
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
deleted file mode 100644
index bd89ca8a92dfbc..00000000000000
--- a/drivers/net/ethernet/8390/stnic.c
+++ /dev/null
@@ -1,302 +0,0 @@
-/* stnic.c : A SH7750 specific part of driver for NS DP83902A ST-NIC.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1999 kaz Kojima
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-
-#include <asm/io.h>
-#include <mach-se/mach/se.h>
-#include <asm/machvec.h>
-#ifdef CONFIG_SH_STANDARD_BIOS
-#include <asm/sh_bios.h>
-#endif
-
-#include "8390.h"
-
-#define DRV_NAME "stnic"
-
-#define byte	unsigned char
-#define half	unsigned short
-#define word	unsigned int
-#define vbyte	volatile unsigned char
-#define vhalf	volatile unsigned short
-#define vword	volatile unsigned int
-
-#define STNIC_RUN	0x01	/* 1 == Run, 0 == reset. */
-
-#define START_PG	0	/* First page of TX buffer */
-#define STOP_PG		128	/* Last page +1 of RX ring */
-
-/* Alias */
-#define STNIC_CR	E8390_CMD
-#define PG0_RSAR0	EN0_RSARLO
-#define PG0_RSAR1	EN0_RSARHI
-#define PG0_RBCR0	EN0_RCNTLO
-#define PG0_RBCR1	EN0_RCNTHI
-
-#define CR_RRD		E8390_RREAD
-#define CR_RWR		E8390_RWRITE
-#define CR_PG0		E8390_PAGE0
-#define CR_STA		E8390_START
-#define CR_RDMA		E8390_NODMA
-
-/* FIXME! YOU MUST SET YOUR OWN ETHER ADDRESS.  */
-static byte stnic_eadr[6] =
-{0x00, 0xc0, 0x6e, 0x00, 0x00, 0x07};
-
-static struct net_device *stnic_dev;
-
-static void stnic_reset (struct net_device *dev);
-static void stnic_get_hdr (struct net_device *dev, struct e8390_pkt_hdr *hdr,
-			   int ring_page);
-static void stnic_block_input (struct net_device *dev, int count,
-			       struct sk_buff *skb , int ring_offset);
-static void stnic_block_output (struct net_device *dev, int count,
-				const unsigned char *buf, int start_page);
-
-static void stnic_init (struct net_device *dev);
-
-static u32 stnic_msg_enable;
-
-module_param_named(msg_enable, stnic_msg_enable, uint, 0444);
-MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
-
-/* SH7750 specific read/write io. */
-static inline void
-STNIC_DELAY (void)
-{
-  vword trash;
-  trash = *(vword *) 0xa0000000;
-  trash = *(vword *) 0xa0000000;
-  trash = *(vword *) 0xa0000000;
-}
-
-static inline byte
-STNIC_READ (int reg)
-{
-  byte val;
-
-  val = (*(vhalf *) (PA_83902 + ((reg) << 1)) >> 8) & 0xff;
-  STNIC_DELAY ();
-  return val;
-}
-
-static inline void
-STNIC_WRITE (int reg, byte val)
-{
-  *(vhalf *) (PA_83902 + ((reg) << 1)) = ((half) (val) << 8);
-  STNIC_DELAY ();
-}
-
-static int __init stnic_probe(void)
-{
-  struct net_device *dev;
-  struct ei_device *ei_local;
-  int err;
-
-  /* If we are not running on a SolutionEngine, give up now */
-  if (! MACH_SE)
-    return -ENODEV;
-
-  /* New style probing API */
-  dev = alloc_ei_netdev();
-  if (!dev)
-	return -ENOMEM;
-
-#ifdef CONFIG_SH_STANDARD_BIOS
-  sh_bios_get_node_addr (stnic_eadr);
-#endif
-  eth_hw_addr_set(dev, stnic_eadr);
-
-  /* Set the base address to point to the NIC, not the "real" base! */
-  dev->base_addr = 0x1000;
-  dev->irq = IRQ_STNIC;
-  dev->netdev_ops = &ei_netdev_ops;
-
-  /* Snarf the interrupt now.  There's no point in waiting since we cannot
-     share and the board will usually be enabled. */
-  err = request_irq (dev->irq, ei_interrupt, 0, DRV_NAME, dev);
-  if (err)  {
-	netdev_emerg(dev, " unable to get IRQ %d.\n", dev->irq);
-	free_netdev(dev);
-	return err;
-  }
-
-  ei_status.name = dev->name;
-  ei_status.word16 = 1;
-#ifdef __LITTLE_ENDIAN__
-  ei_status.bigendian = 0;
-#else
-  ei_status.bigendian = 1;
-#endif
-  ei_status.tx_start_page = START_PG;
-  ei_status.rx_start_page = START_PG + TX_PAGES;
-  ei_status.stop_page = STOP_PG;
-
-  ei_status.reset_8390 = &stnic_reset;
-  ei_status.get_8390_hdr = &stnic_get_hdr;
-  ei_status.block_input = &stnic_block_input;
-  ei_status.block_output = &stnic_block_output;
-
-  stnic_init (dev);
-  ei_local = netdev_priv(dev);
-  ei_local->msg_enable = stnic_msg_enable;
-
-  err = register_netdev(dev);
-  if (err) {
-    free_irq(dev->irq, dev);
-    free_netdev(dev);
-    return err;
-  }
-  stnic_dev = dev;
-
-  netdev_info(dev, "NS ST-NIC 83902A\n");
-
-  return 0;
-}
-
-static void
-stnic_reset (struct net_device *dev)
-{
-  struct ei_device *ei_local = netdev_priv(dev);
-
-  *(vhalf *) PA_83902_RST = 0;
-  udelay (5);
-  netif_warn(ei_local, hw, dev, "8390 reset done (%ld).\n", jiffies);
-  *(vhalf *) PA_83902_RST = ~0;
-  udelay (5);
-}
-
-static void
-stnic_get_hdr (struct net_device *dev, struct e8390_pkt_hdr *hdr,
-	       int ring_page)
-{
-  struct ei_device *ei_local = netdev_priv(dev);
-
-  half buf[2];
-
-  STNIC_WRITE (PG0_RSAR0, 0);
-  STNIC_WRITE (PG0_RSAR1, ring_page);
-  STNIC_WRITE (PG0_RBCR0, 4);
-  STNIC_WRITE (PG0_RBCR1, 0);
-  STNIC_WRITE (STNIC_CR, CR_RRD | CR_PG0 | CR_STA);
-
-  buf[0] = *(vhalf *) PA_83902_IF;
-  STNIC_DELAY ();
-  buf[1] = *(vhalf *) PA_83902_IF;
-  STNIC_DELAY ();
-  hdr->next = buf[0] >> 8;
-  hdr->status = buf[0] & 0xff;
-#ifdef __LITTLE_ENDIAN__
-  hdr->count = buf[1];
-#else
-  hdr->count = ((buf[1] >> 8) & 0xff) | (buf[1] << 8);
-#endif
-
-  netif_dbg(ei_local, probe, dev, "ring %x status %02x next %02x count %04x.\n",
-	    ring_page, hdr->status, hdr->next, hdr->count);
-
-  STNIC_WRITE (STNIC_CR, CR_RDMA | CR_PG0 | CR_STA);
-}
-
-/* Block input and output, similar to the Crynwr packet driver. If you are
-   porting to a new ethercard look at the packet driver source for hints.
-   The HP LAN doesn't use shared memory -- we put the packet
-   out through the "remote DMA" dataport. */
-
-static void
-stnic_block_input (struct net_device *dev, int length, struct sk_buff *skb,
-		   int offset)
-{
-  char *buf = skb->data;
-  half val;
-
-  STNIC_WRITE (PG0_RSAR0, offset & 0xff);
-  STNIC_WRITE (PG0_RSAR1, offset >> 8);
-  STNIC_WRITE (PG0_RBCR0, length & 0xff);
-  STNIC_WRITE (PG0_RBCR1, length >> 8);
-  STNIC_WRITE (STNIC_CR, CR_RRD | CR_PG0 | CR_STA);
-
-  if (length & 1)
-    length++;
-
-  while (length > 0)
-    {
-      val = *(vhalf *) PA_83902_IF;
-#ifdef __LITTLE_ENDIAN__
-      *buf++ = val & 0xff;
-      *buf++ = val >> 8;
-#else
-      *buf++ = val >> 8;
-      *buf++ = val & 0xff;
-#endif
-      STNIC_DELAY ();
-      length -= sizeof (half);
-    }
-
-  STNIC_WRITE (STNIC_CR, CR_RDMA | CR_PG0 | CR_STA);
-}
-
-static void
-stnic_block_output (struct net_device *dev, int length,
-		    const unsigned char *buf, int output_page)
-{
-  STNIC_WRITE (PG0_RBCR0, 1);	/* Write non-zero value */
-  STNIC_WRITE (STNIC_CR, CR_RRD | CR_PG0 | CR_STA);
-  STNIC_DELAY ();
-
-  STNIC_WRITE (PG0_RBCR0, length & 0xff);
-  STNIC_WRITE (PG0_RBCR1, length >> 8);
-  STNIC_WRITE (PG0_RSAR0, 0);
-  STNIC_WRITE (PG0_RSAR1, output_page);
-  STNIC_WRITE (STNIC_CR, CR_RWR | CR_PG0 | CR_STA);
-
-  if (length & 1)
-    length++;
-
-  while (length > 0)
-    {
-#ifdef __LITTLE_ENDIAN__
-      *(vhalf *) PA_83902_IF = ((half) buf[1] << 8) | buf[0];
-#else
-      *(vhalf *) PA_83902_IF = ((half) buf[0] << 8) | buf[1];
-#endif
-      STNIC_DELAY ();
-      buf += sizeof (half);
-      length -= sizeof (half);
-    }
-
-  STNIC_WRITE (STNIC_CR, CR_RDMA | CR_PG0 | CR_STA);
-}
-
-/* This function resets the STNIC if something screws up.  */
-static void
-stnic_init (struct net_device *dev)
-{
-  stnic_reset (dev);
-  NS8390_init (dev, 0);
-}
-
-static void __exit stnic_cleanup(void)
-{
-	unregister_netdev(stnic_dev);
-	free_irq(stnic_dev->irq, stnic_dev);
-	free_netdev(stnic_dev);
-}
-
-module_init(stnic_probe);
-module_exit(stnic_cleanup);
-MODULE_LICENSE("GPL");
-- 
2.39.0

