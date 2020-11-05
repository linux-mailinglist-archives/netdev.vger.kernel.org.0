Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C03C2A7812
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKEHeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgKEHep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 02:34:45 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAB5C0613CF;
        Wed,  4 Nov 2020 23:34:44 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 62so751079pgg.12;
        Wed, 04 Nov 2020 23:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6e+CsaJX8fukWWHIy+qNSjlNFzsithihaesltfXoXeU=;
        b=CiPd4coTY3TQmHtrGBLRmA/cz8yjmgsscBx1ObKiBFdxQ4YQlqHfm+oKow1kFasoD0
         ABzMIeUz0Oi5SfszOsVX3le0+FU7sFgRlCzVxE6ZgQdY8Ft0j4y2iDGy3hLm/0t2foHg
         SfAuT2g+0qknNuMnMA+p2UtH6JzPKR19l21mP4lh68TLoRROPvqS2G41i+dOa81BZQWd
         4BWFU1LGA77IDTtZT++LOvSBhXFxRAZtIYw+Xk+cZGubmj0sqsNl/EvSkDrwH1ty99R8
         Z9ALSIOJGBbTP0o6WvqSPILZoVyzqz+LMoxzw4Y+YOpc5+vk5CLiPzpThqNaiDD6MNeH
         Ax6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6e+CsaJX8fukWWHIy+qNSjlNFzsithihaesltfXoXeU=;
        b=Tgb4/Y2gfnlNg+dORQd8/vx4A1V7DyEPejLYQ3cGN1TNWFWqsX/o8rARRtwGMhiGme
         itu62tqTPvsQ1ovNTioxR3ZrswBJu/mv17hGFxttXybWfTKnH9QSCE5P8wQQeh/XsAgT
         USih5RrVhJeXchSXXZKxjXkwg6LqhhKqdIJKdRZXn6pBSX8On7UIxUz7a/4ctClSp2MN
         qJ5738GnrRgd6MduGvj1cKVVYY8Hng5KVDEnox4gO0nq56UiIi7jR9FKQd+6T++Zcprr
         MrqxVMd3CV0xbt/Y9zgiIb1mM0BWc23iF4zITrRtro7Dr3Y6z03G1ToVtM01ArqWooqC
         jgXg==
X-Gm-Message-State: AOAM530zr1yx/yNezniDk1q6scT3WyGu8uIxOHiwcG/lhr2duF7hhqWX
        j3fIzlSdJml+guFgAVUJUuM=
X-Google-Smtp-Source: ABdhPJy0ChJx6Pj7KYj5BIunroQaHnKZj7X/jkDAv9aNrw8EK15W7RqXhrxP5zdFRBGh1XImQuNfPg==
X-Received: by 2002:a17:90b:715:: with SMTP id s21mr1118913pjz.43.1604561683573;
        Wed, 04 Nov 2020 23:34:43 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:fa27:be92:e420:b669])
        by smtp.gmail.com with ESMTPSA id e7sm1320174pfn.180.2020.11.04.23.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 23:34:43 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Date:   Wed,  4 Nov 2020 23:34:34 -0800
Message-Id: <20201105073434.429307-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver transports LAPB (X.25 link layer) frames over TTY links.

I can safely say that this driver has no actual user because it was
not working at all until:
commit 8fdcabeac398 ("drivers/net/wan/x25_asy: Fix to make it work")

The code in its current state still has problems:

1.
The uses of "struct x25_asy" in x25_asy_unesc (when receiving) and in
x25_asy_write_wakeup (when sending) are not protected by locks against
x25_asy_change_mtu's changing of the transmitting/receiving buffers.
Also, all "netif_running" checks in this driver are not protected by
locks against the ndo_stop function.

2.
The driver stops all TTY read/write when the netif is down.
I think this is not right because this may cause the last outgoing frame
before the netif goes down to be incompletely transmitted, and the first
incoming frame after the netif goes up to be incompletely received.

And there may also be other problems.

I was planning to fix these problems but after recent discussions about
deleting other old networking code, I think we may just delete this
driver, too.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 Documentation/process/magic-number.rst        |   1 -
 .../it_IT/process/magic-number.rst            |   1 -
 .../zh_CN/process/magic-number.rst            |   1 -
 arch/mips/configs/gpr_defconfig               |   1 -
 arch/mips/configs/mtx1_defconfig              |   1 -
 drivers/net/wan/Kconfig                       |  15 -
 drivers/net/wan/Makefile                      |   1 -
 drivers/net/wan/x25_asy.c                     | 836 ------------------
 drivers/net/wan/x25_asy.h                     |  46 -
 9 files changed, 903 deletions(-)
 delete mode 100644 drivers/net/wan/x25_asy.c
 delete mode 100644 drivers/net/wan/x25_asy.h

diff --git a/Documentation/process/magic-number.rst b/Documentation/process/magic-number.rst
index eee9b44553b3..e02ff5ffb653 100644
--- a/Documentation/process/magic-number.rst
+++ b/Documentation/process/magic-number.rst
@@ -84,7 +84,6 @@ PPP_MAGIC             0x5002           ppp                      ``include/linux/
 SSTATE_MAGIC          0x5302           serial_state             ``include/linux/serial.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
 STRIP_MAGIC           0x5303           strip                    ``drivers/net/strip.c``
-X25_ASY_MAGIC         0x5303           x25_asy                  ``drivers/net/x25_asy.h``
 SIXPACK_MAGIC         0x5304           sixpack                  ``drivers/net/hamradio/6pack.h``
 AX25_MAGIC            0x5316           ax_disp                  ``drivers/net/mkiss.h``
 TTY_MAGIC             0x5401           tty_struct               ``include/linux/tty.h``
diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Documentation/translations/it_IT/process/magic-number.rst
index 783e0de314a0..0243d32a0b59 100644
--- a/Documentation/translations/it_IT/process/magic-number.rst
+++ b/Documentation/translations/it_IT/process/magic-number.rst
@@ -90,7 +90,6 @@ PPP_MAGIC             0x5002           ppp                      ``include/linux/
 SSTATE_MAGIC          0x5302           serial_state             ``include/linux/serial.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
 STRIP_MAGIC           0x5303           strip                    ``drivers/net/strip.c``
-X25_ASY_MAGIC         0x5303           x25_asy                  ``drivers/net/x25_asy.h``
 SIXPACK_MAGIC         0x5304           sixpack                  ``drivers/net/hamradio/6pack.h``
 AX25_MAGIC            0x5316           ax_disp                  ``drivers/net/mkiss.h``
 TTY_MAGIC             0x5401           tty_struct               ``include/linux/tty.h``
diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Documentation/translations/zh_CN/process/magic-number.rst
index e4c225996af0..de182bf4191c 100644
--- a/Documentation/translations/zh_CN/process/magic-number.rst
+++ b/Documentation/translations/zh_CN/process/magic-number.rst
@@ -73,7 +73,6 @@ PPP_MAGIC             0x5002           ppp                      ``include/linux/
 SSTATE_MAGIC          0x5302           serial_state             ``include/linux/serial.h``
 SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
 STRIP_MAGIC           0x5303           strip                    ``drivers/net/strip.c``
-X25_ASY_MAGIC         0x5303           x25_asy                  ``drivers/net/x25_asy.h``
 SIXPACK_MAGIC         0x5304           sixpack                  ``drivers/net/hamradio/6pack.h``
 AX25_MAGIC            0x5316           ax_disp                  ``drivers/net/mkiss.h``
 TTY_MAGIC             0x5401           tty_struct               ``include/linux/tty.h``
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index 9085f4d6c698..599d5604aabe 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -230,7 +230,6 @@ CONFIG_DSCC4_PCISYNC=y
 CONFIG_DSCC4_PCI_RST=y
 CONFIG_DLCI=m
 CONFIG_LAPBETHER=m
-CONFIG_X25_ASY=m
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_SERIO is not set
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 914af125a7fa..dc69b054181c 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -380,7 +380,6 @@ CONFIG_DSCC4_PCISYNC=y
 CONFIG_DSCC4_PCI_RST=y
 CONFIG_DLCI=m
 CONFIG_LAPBETHER=m
-CONFIG_X25_ASY=m
 # CONFIG_KEYBOARD_ATKBD is not set
 CONFIG_KEYBOARD_GPIO=y
 # CONFIG_INPUT_MOUSE is not set
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 39e5ab261d7c..2cf98a732a26 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -383,21 +383,6 @@ config LAPBETHER
 
 	  If unsure, say N.
 
-config X25_ASY
-	tristate "X.25 async driver"
-	depends on LAPB && X25 && TTY
-	help
-	  Send and receive X.25 frames over regular asynchronous serial
-	  lines such as telephone lines equipped with ordinary modems.
-
-	  Experts should note that this driver doesn't currently comply with
-	  the asynchronous HDLS framing protocols in CCITT recommendation X.25.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called x25_asy.
-
-	  If unsure, say N.
-
 config SBNI
 	tristate "Granch SBNI12 Leased Line adapter support"
 	depends on X86
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 380271a011e4..5b9dc85eae34 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	hostess_sv11.o
 obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	sealevel.o
 obj-$(CONFIG_COSA)		+= cosa.o
 obj-$(CONFIG_FARSYNC)		+= farsync.o
-obj-$(CONFIG_X25_ASY)		+= x25_asy.o
 
 obj-$(CONFIG_LANMEDIA)		+= lmc/
 
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
deleted file mode 100644
index 54b1a5aee82d..000000000000
--- a/drivers/net/wan/x25_asy.c
+++ /dev/null
@@ -1,836 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- *	Things to sort out:
- *
- *	o	tbusy handling
- *	o	allow users to set the parameters
- *	o	sync/async switching ?
- *
- *	Note: This does _not_ implement CCITT X.25 asynchronous framing
- *	recommendations. Its primarily for testing purposes. If you wanted
- *	to do CCITT then in theory all you need is to nick the HDLC async
- *	checksum routines from ppp.c
- *      Changes:
- *
- *	2000-10-29	Henner Eisen	lapb_data_indication() return status.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-
-#include <linux/uaccess.h>
-#include <linux/bitops.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/in.h>
-#include <linux/tty.h>
-#include <linux/errno.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/lapb.h>
-#include <linux/init.h>
-#include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <net/x25device.h>
-#include "x25_asy.h"
-
-static struct net_device **x25_asy_devs;
-static int x25_asy_maxdev = SL_NRUNIT;
-
-module_param(x25_asy_maxdev, int, 0);
-MODULE_LICENSE("GPL");
-
-static int x25_asy_esc(unsigned char *p, unsigned char *d, int len);
-static void x25_asy_unesc(struct x25_asy *sl, unsigned char c);
-static void x25_asy_setup(struct net_device *dev);
-
-/* Find a free X.25 channel, and link in this `tty' line. */
-static struct x25_asy *x25_asy_alloc(void)
-{
-	struct net_device *dev = NULL;
-	struct x25_asy *sl;
-	int i;
-
-	if (x25_asy_devs == NULL)
-		return NULL;	/* Master array missing ! */
-
-	for (i = 0; i < x25_asy_maxdev; i++) {
-		dev = x25_asy_devs[i];
-
-		/* Not allocated ? */
-		if (dev == NULL)
-			break;
-
-		sl = netdev_priv(dev);
-		/* Not in use ? */
-		if (!test_and_set_bit(SLF_INUSE, &sl->flags))
-			return sl;
-	}
-
-
-	/* Sorry, too many, all slots in use */
-	if (i >= x25_asy_maxdev)
-		return NULL;
-
-	/* If no channels are available, allocate one */
-	if (!dev) {
-		char name[IFNAMSIZ];
-		sprintf(name, "x25asy%d", i);
-
-		dev = alloc_netdev(sizeof(struct x25_asy), name,
-				   NET_NAME_UNKNOWN, x25_asy_setup);
-		if (!dev)
-			return NULL;
-
-		/* Initialize channel control data */
-		sl = netdev_priv(dev);
-		dev->base_addr    = i;
-
-		/* register device so that it can be ifconfig'ed       */
-		if (register_netdev(dev) == 0) {
-			/* (Re-)Set the INUSE bit.   Very Important! */
-			set_bit(SLF_INUSE, &sl->flags);
-			x25_asy_devs[i] = dev;
-			return sl;
-		} else {
-			pr_warn("%s(): register_netdev() failure\n", __func__);
-			free_netdev(dev);
-		}
-	}
-	return NULL;
-}
-
-
-/* Free an X.25 channel. */
-static void x25_asy_free(struct x25_asy *sl)
-{
-	/* Free all X.25 frame buffers. */
-	kfree(sl->rbuff);
-	sl->rbuff = NULL;
-	kfree(sl->xbuff);
-	sl->xbuff = NULL;
-
-	if (!test_and_clear_bit(SLF_INUSE, &sl->flags))
-		netdev_err(sl->dev, "x25_asy_free for already free unit\n");
-}
-
-static int x25_asy_change_mtu(struct net_device *dev, int newmtu)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-	unsigned char *xbuff, *rbuff;
-	int len;
-
-	len = 2 * newmtu;
-	xbuff = kmalloc(len + 4, GFP_ATOMIC);
-	rbuff = kmalloc(len + 4, GFP_ATOMIC);
-
-	if (xbuff == NULL || rbuff == NULL) {
-		kfree(xbuff);
-		kfree(rbuff);
-		return -ENOMEM;
-	}
-
-	spin_lock_bh(&sl->lock);
-	xbuff    = xchg(&sl->xbuff, xbuff);
-	if (sl->xleft)  {
-		if (sl->xleft <= len)  {
-			memcpy(sl->xbuff, sl->xhead, sl->xleft);
-		} else  {
-			sl->xleft = 0;
-			dev->stats.tx_dropped++;
-		}
-	}
-	sl->xhead = sl->xbuff;
-
-	rbuff	 = xchg(&sl->rbuff, rbuff);
-	if (sl->rcount)  {
-		if (sl->rcount <= len) {
-			memcpy(sl->rbuff, rbuff, sl->rcount);
-		} else  {
-			sl->rcount = 0;
-			dev->stats.rx_over_errors++;
-			set_bit(SLF_ERROR, &sl->flags);
-		}
-	}
-
-	dev->mtu    = newmtu;
-	sl->buffsize = len;
-
-	spin_unlock_bh(&sl->lock);
-
-	kfree(xbuff);
-	kfree(rbuff);
-	return 0;
-}
-
-
-/* Set the "sending" flag.  This must be atomic, hence the ASM. */
-
-static inline void x25_asy_lock(struct x25_asy *sl)
-{
-	netif_stop_queue(sl->dev);
-}
-
-
-/* Clear the "sending" flag.  This must be atomic, hence the ASM. */
-
-static inline void x25_asy_unlock(struct x25_asy *sl)
-{
-	netif_wake_queue(sl->dev);
-}
-
-/* Send an LAPB frame to the LAPB module to process. */
-
-static void x25_asy_bump(struct x25_asy *sl)
-{
-	struct net_device *dev = sl->dev;
-	struct sk_buff *skb;
-	int count;
-	int err;
-
-	count = sl->rcount;
-	dev->stats.rx_bytes += count;
-
-	skb = dev_alloc_skb(count);
-	if (skb == NULL) {
-		netdev_warn(sl->dev, "memory squeeze, dropping packet\n");
-		dev->stats.rx_dropped++;
-		return;
-	}
-	skb_put_data(skb, sl->rbuff, count);
-	err = lapb_data_received(sl->dev, skb);
-	if (err != LAPB_OK) {
-		kfree_skb(skb);
-		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
-	} else {
-		dev->stats.rx_packets++;
-	}
-}
-
-/* Encapsulate one IP datagram and stuff into a TTY queue. */
-static void x25_asy_encaps(struct x25_asy *sl, unsigned char *icp, int len)
-{
-	unsigned char *p;
-	int actual, count, mtu = sl->dev->mtu;
-
-	if (len > mtu) {
-		/* Sigh, shouldn't occur BUT ... */
-		len = mtu;
-		printk(KERN_DEBUG "%s: truncating oversized transmit packet!\n",
-					sl->dev->name);
-		sl->dev->stats.tx_dropped++;
-		x25_asy_unlock(sl);
-		return;
-	}
-
-	p = icp;
-	count = x25_asy_esc(p, sl->xbuff, len);
-
-	/* Order of next two lines is *very* important.
-	 * When we are sending a little amount of data,
-	 * the transfer may be completed inside driver.write()
-	 * routine, because it's running with interrupts enabled.
-	 * In this case we *never* got WRITE_WAKEUP event,
-	 * if we did not request it before write operation.
-	 *       14 Oct 1994  Dmitry Gorodchanin.
-	 */
-	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
-	actual = sl->tty->ops->write(sl->tty, sl->xbuff, count);
-	sl->xleft = count - actual;
-	sl->xhead = sl->xbuff + actual;
-}
-
-/*
- * Called by the driver when there's room for more data.  If we have
- * more packets to send, we send them here.
- */
-static void x25_asy_write_wakeup(struct tty_struct *tty)
-{
-	int actual;
-	struct x25_asy *sl = tty->disc_data;
-
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
-		return;
-
-	if (sl->xleft <= 0) {
-		/* Now serial buffer is almost free & we can start
-		 * transmission of another packet */
-		sl->dev->stats.tx_packets++;
-		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-		x25_asy_unlock(sl);
-		return;
-	}
-
-	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
-	sl->xleft -= actual;
-	sl->xhead += actual;
-}
-
-static void x25_asy_timeout(struct net_device *dev, unsigned int txqueue)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-
-	spin_lock(&sl->lock);
-	if (netif_queue_stopped(dev)) {
-		/* May be we must check transmitter timeout here ?
-		 *      14 Oct 1994 Dmitry Gorodchanin.
-		 */
-		netdev_warn(dev, "transmit timed out, %s?\n",
-			    (tty_chars_in_buffer(sl->tty) || sl->xleft) ?
-			    "bad line quality" : "driver error");
-		sl->xleft = 0;
-		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
-		x25_asy_unlock(sl);
-	}
-	spin_unlock(&sl->lock);
-}
-
-/* Encapsulate an IP datagram and kick it into a TTY queue. */
-
-static netdev_tx_t x25_asy_xmit(struct sk_buff *skb,
-				      struct net_device *dev)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-	int err;
-
-	if (!netif_running(sl->dev)) {
-		netdev_err(dev, "xmit call when iface is down\n");
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
-	/* There should be a pseudo header of 1 byte added by upper layers.
-	 * Check to make sure it is there before reading it.
-	 */
-	if (skb->len < 1) {
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-
-	switch (skb->data[0]) {
-	case X25_IFACE_DATA:
-		break;
-	case X25_IFACE_CONNECT: /* Connection request .. do nothing */
-		err = lapb_connect_request(dev);
-		if (err != LAPB_OK)
-			netdev_err(dev, "lapb_connect_request error: %d\n",
-				   err);
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	case X25_IFACE_DISCONNECT: /* do nothing - hang up ?? */
-		err = lapb_disconnect_request(dev);
-		if (err != LAPB_OK)
-			netdev_err(dev, "lapb_disconnect_request error: %d\n",
-				   err);
-		fallthrough;
-	default:
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-	skb_pull(skb, 1);	/* Remove control byte */
-	/*
-	 * If we are busy already- too bad.  We ought to be able
-	 * to queue things at this point, to allow for a little
-	 * frame buffer.  Oh well...
-	 * -----------------------------------------------------
-	 * I hate queues in X.25 driver. May be it's efficient,
-	 * but for me latency is more important. ;)
-	 * So, no queues !
-	 *        14 Oct 1994  Dmitry Gorodchanin.
-	 */
-
-	err = lapb_data_request(dev, skb);
-	if (err != LAPB_OK) {
-		netdev_err(dev, "lapb_data_request error: %d\n", err);
-		kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
-	return NETDEV_TX_OK;
-}
-
-
-/*
- *	LAPB interface boilerplate
- */
-
-/*
- *	Called when I frame data arrive. We add a pseudo header for upper
- *	layers and pass it to upper layers.
- */
-
-static int x25_asy_data_indication(struct net_device *dev, struct sk_buff *skb)
-{
-	if (skb_cow(skb, 1)) {
-		kfree_skb(skb);
-		return NET_RX_DROP;
-	}
-	skb_push(skb, 1);
-	skb->data[0] = X25_IFACE_DATA;
-
-	skb->protocol = x25_type_trans(skb, dev);
-
-	return netif_rx(skb);
-}
-
-/*
- *	Data has emerged from the LAPB protocol machine. We don't handle
- *	busy cases too well. Its tricky to see how to do this nicely -
- *	perhaps lapb should allow us to bounce this ?
- */
-
-static void x25_asy_data_transmit(struct net_device *dev, struct sk_buff *skb)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-
-	spin_lock(&sl->lock);
-	if (netif_queue_stopped(sl->dev) || sl->tty == NULL) {
-		spin_unlock(&sl->lock);
-		netdev_err(dev, "tbusy drop\n");
-		kfree_skb(skb);
-		return;
-	}
-	/* We were not busy, so we are now... :-) */
-	if (skb != NULL) {
-		x25_asy_lock(sl);
-		dev->stats.tx_bytes += skb->len;
-		x25_asy_encaps(sl, skb->data, skb->len);
-		dev_kfree_skb(skb);
-	}
-	spin_unlock(&sl->lock);
-}
-
-/*
- *	LAPB connection establish/down information.
- */
-
-static void x25_asy_connected(struct net_device *dev, int reason)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-	struct sk_buff *skb;
-	unsigned char *ptr;
-
-	skb = dev_alloc_skb(1);
-	if (skb == NULL) {
-		netdev_err(dev, "out of memory\n");
-		return;
-	}
-
-	ptr  = skb_put(skb, 1);
-	*ptr = X25_IFACE_CONNECT;
-
-	skb->protocol = x25_type_trans(skb, sl->dev);
-	netif_rx(skb);
-}
-
-static void x25_asy_disconnected(struct net_device *dev, int reason)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-	struct sk_buff *skb;
-	unsigned char *ptr;
-
-	skb = dev_alloc_skb(1);
-	if (skb == NULL) {
-		netdev_err(dev, "out of memory\n");
-		return;
-	}
-
-	ptr  = skb_put(skb, 1);
-	*ptr = X25_IFACE_DISCONNECT;
-
-	skb->protocol = x25_type_trans(skb, sl->dev);
-	netif_rx(skb);
-}
-
-static const struct lapb_register_struct x25_asy_callbacks = {
-	.connect_confirmation = x25_asy_connected,
-	.connect_indication = x25_asy_connected,
-	.disconnect_confirmation = x25_asy_disconnected,
-	.disconnect_indication = x25_asy_disconnected,
-	.data_indication = x25_asy_data_indication,
-	.data_transmit = x25_asy_data_transmit,
-};
-
-
-/* Open the low-level part of the X.25 channel. Easy! */
-static int x25_asy_open(struct net_device *dev)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-	unsigned long len;
-
-	if (sl->tty == NULL)
-		return -ENODEV;
-
-	/*
-	 * Allocate the X.25 frame buffers:
-	 *
-	 * rbuff	Receive buffer.
-	 * xbuff	Transmit buffer.
-	 */
-
-	len = dev->mtu * 2;
-
-	sl->rbuff = kmalloc(len + 4, GFP_KERNEL);
-	if (sl->rbuff == NULL)
-		goto norbuff;
-	sl->xbuff = kmalloc(len + 4, GFP_KERNEL);
-	if (sl->xbuff == NULL)
-		goto noxbuff;
-
-	sl->buffsize = len;
-	sl->rcount   = 0;
-	sl->xleft    = 0;
-	sl->flags   &= (1 << SLF_INUSE);      /* Clear ESCAPE & ERROR flags */
-
-	return 0;
-
-	/* Cleanup */
-	kfree(sl->xbuff);
-	sl->xbuff = NULL;
-noxbuff:
-	kfree(sl->rbuff);
-	sl->rbuff = NULL;
-norbuff:
-	return -ENOMEM;
-}
-
-
-/* Close the low-level part of the X.25 channel. Easy! */
-static int x25_asy_close(struct net_device *dev)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-
-	spin_lock(&sl->lock);
-	if (sl->tty)
-		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
-
-	sl->rcount = 0;
-	sl->xleft  = 0;
-	spin_unlock(&sl->lock);
-	return 0;
-}
-
-/*
- * Handle the 'receiver data ready' interrupt.
- * This function is called by the 'tty_io' module in the kernel when
- * a block of X.25 data has been received, which can now be decapsulated
- * and sent on to some IP layer for further processing.
- */
-
-static void x25_asy_receive_buf(struct tty_struct *tty,
-				const unsigned char *cp, char *fp, int count)
-{
-	struct x25_asy *sl = tty->disc_data;
-
-	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
-		return;
-
-
-	/* Read the characters out of the buffer */
-	while (count--) {
-		if (fp && *fp++) {
-			if (!test_and_set_bit(SLF_ERROR, &sl->flags))
-				sl->dev->stats.rx_errors++;
-			cp++;
-			continue;
-		}
-		x25_asy_unesc(sl, *cp++);
-	}
-}
-
-/*
- * Open the high-level part of the X.25 channel.
- * This function is called by the TTY module when the
- * X.25 line discipline is called for.  Because we are
- * sure the tty line exists, we only have to link it to
- * a free X.25 channel...
- */
-
-static int x25_asy_open_tty(struct tty_struct *tty)
-{
-	struct x25_asy *sl;
-	int err;
-
-	if (tty->ops->write == NULL)
-		return -EOPNOTSUPP;
-
-	/* OK.  Find a free X.25 channel to use. */
-	sl = x25_asy_alloc();
-	if (sl == NULL)
-		return -ENFILE;
-
-	sl->tty = tty;
-	tty->disc_data = sl;
-	tty->receive_room = 65536;
-	tty_driver_flush_buffer(tty);
-	tty_ldisc_flush(tty);
-
-	/* Restore default settings */
-	sl->dev->type = ARPHRD_X25;
-
-	/* Perform the low-level X.25 async init */
-	err = x25_asy_open(sl->dev);
-	if (err) {
-		x25_asy_free(sl);
-		return err;
-	}
-	/* Done.  We have linked the TTY line to a channel. */
-	return 0;
-}
-
-
-/*
- * Close down an X.25 channel.
- * This means flushing out any pending queues, and then restoring the
- * TTY line discipline to what it was before it got hooked to X.25
- * (which usually is TTY again).
- */
-static void x25_asy_close_tty(struct tty_struct *tty)
-{
-	struct x25_asy *sl = tty->disc_data;
-
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != X25_ASY_MAGIC)
-		return;
-
-	rtnl_lock();
-	if (sl->dev->flags & IFF_UP)
-		dev_close(sl->dev);
-	rtnl_unlock();
-
-	tty->disc_data = NULL;
-	sl->tty = NULL;
-	x25_asy_free(sl);
-}
-
- /************************************************************************
-  *			STANDARD X.25 ENCAPSULATION		  	 *
-  ************************************************************************/
-
-static int x25_asy_esc(unsigned char *s, unsigned char *d, int len)
-{
-	unsigned char *ptr = d;
-	unsigned char c;
-
-	/*
-	 * Send an initial END character to flush out any
-	 * data that may have accumulated in the receiver
-	 * due to line noise.
-	 */
-
-	*ptr++ = X25_END;	/* Send 10111110 bit seq */
-
-	/*
-	 * For each byte in the packet, send the appropriate
-	 * character sequence, according to the X.25 protocol.
-	 */
-
-	while (len-- > 0) {
-		switch (c = *s++) {
-		case X25_END:
-			*ptr++ = X25_ESC;
-			*ptr++ = X25_ESCAPE(X25_END);
-			break;
-		case X25_ESC:
-			*ptr++ = X25_ESC;
-			*ptr++ = X25_ESCAPE(X25_ESC);
-			break;
-		default:
-			*ptr++ = c;
-			break;
-		}
-	}
-	*ptr++ = X25_END;
-	return ptr - d;
-}
-
-static void x25_asy_unesc(struct x25_asy *sl, unsigned char s)
-{
-
-	switch (s) {
-	case X25_END:
-		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
-		    sl->rcount >= 2)
-			x25_asy_bump(sl);
-		clear_bit(SLF_ESCAPE, &sl->flags);
-		sl->rcount = 0;
-		return;
-	case X25_ESC:
-		set_bit(SLF_ESCAPE, &sl->flags);
-		return;
-	case X25_ESCAPE(X25_ESC):
-	case X25_ESCAPE(X25_END):
-		if (test_and_clear_bit(SLF_ESCAPE, &sl->flags))
-			s = X25_UNESCAPE(s);
-		break;
-	}
-	if (!test_bit(SLF_ERROR, &sl->flags)) {
-		if (sl->rcount < sl->buffsize) {
-			sl->rbuff[sl->rcount++] = s;
-			return;
-		}
-		sl->dev->stats.rx_over_errors++;
-		set_bit(SLF_ERROR, &sl->flags);
-	}
-}
-
-
-/* Perform I/O control on an active X.25 channel. */
-static int x25_asy_ioctl(struct tty_struct *tty, struct file *file,
-			 unsigned int cmd,  unsigned long arg)
-{
-	struct x25_asy *sl = tty->disc_data;
-
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != X25_ASY_MAGIC)
-		return -EINVAL;
-
-	switch (cmd) {
-	case SIOCGIFNAME:
-		if (copy_to_user((void __user *)arg, sl->dev->name,
-					strlen(sl->dev->name) + 1))
-			return -EFAULT;
-		return 0;
-	case SIOCSIFHWADDR:
-		return -EINVAL;
-	default:
-		return tty_mode_ioctl(tty, file, cmd, arg);
-	}
-}
-
-static int x25_asy_open_dev(struct net_device *dev)
-{
-	int err;
-	struct x25_asy *sl = netdev_priv(dev);
-	if (sl->tty == NULL)
-		return -ENODEV;
-
-	err = lapb_register(dev, &x25_asy_callbacks);
-	if (err != LAPB_OK)
-		return -ENOMEM;
-
-	netif_start_queue(dev);
-
-	return 0;
-}
-
-static int x25_asy_close_dev(struct net_device *dev)
-{
-	int err;
-
-	netif_stop_queue(dev);
-
-	err = lapb_unregister(dev);
-	if (err != LAPB_OK)
-		pr_err("%s: lapb_unregister error: %d\n",
-		       __func__, err);
-
-	x25_asy_close(dev);
-
-	return 0;
-}
-
-static const struct net_device_ops x25_asy_netdev_ops = {
-	.ndo_open	= x25_asy_open_dev,
-	.ndo_stop	= x25_asy_close_dev,
-	.ndo_start_xmit	= x25_asy_xmit,
-	.ndo_tx_timeout	= x25_asy_timeout,
-	.ndo_change_mtu	= x25_asy_change_mtu,
-};
-
-/* Initialise the X.25 driver.  Called by the device init code */
-static void x25_asy_setup(struct net_device *dev)
-{
-	struct x25_asy *sl = netdev_priv(dev);
-
-	sl->magic  = X25_ASY_MAGIC;
-	sl->dev	   = dev;
-	spin_lock_init(&sl->lock);
-	set_bit(SLF_INUSE, &sl->flags);
-
-	/*
-	 *	Finish setting up the DEVICE info.
-	 */
-
-	dev->mtu		= SL_MTU;
-	dev->min_mtu		= 0;
-	dev->max_mtu		= 65534;
-	dev->netdev_ops		= &x25_asy_netdev_ops;
-	dev->watchdog_timeo	= HZ*20;
-	dev->hard_header_len	= 0;
-	dev->addr_len		= 0;
-	dev->type		= ARPHRD_X25;
-	dev->tx_queue_len	= 10;
-
-	/* When transmitting data:
-	 * first this driver removes a pseudo header of 1 byte,
-	 * then the lapb module prepends an LAPB header of at most 3 bytes.
-	 */
-	dev->needed_headroom	= 3 - 1;
-
-	/* New-style flags. */
-	dev->flags		= IFF_NOARP;
-}
-
-static struct tty_ldisc_ops x25_ldisc = {
-	.owner		= THIS_MODULE,
-	.magic		= TTY_LDISC_MAGIC,
-	.name		= "X.25",
-	.open		= x25_asy_open_tty,
-	.close		= x25_asy_close_tty,
-	.ioctl		= x25_asy_ioctl,
-	.receive_buf	= x25_asy_receive_buf,
-	.write_wakeup	= x25_asy_write_wakeup,
-};
-
-static int __init init_x25_asy(void)
-{
-	if (x25_asy_maxdev < 4)
-		x25_asy_maxdev = 4; /* Sanity */
-
-	pr_info("X.25 async: version 0.00 ALPHA (dynamic channels, max=%d)\n",
-		x25_asy_maxdev);
-
-	x25_asy_devs = kcalloc(x25_asy_maxdev, sizeof(struct net_device *),
-				GFP_KERNEL);
-	if (!x25_asy_devs)
-		return -ENOMEM;
-
-	return tty_register_ldisc(N_X25, &x25_ldisc);
-}
-
-
-static void __exit exit_x25_asy(void)
-{
-	struct net_device *dev;
-	int i;
-
-	for (i = 0; i < x25_asy_maxdev; i++) {
-		dev = x25_asy_devs[i];
-		if (dev) {
-			struct x25_asy *sl = netdev_priv(dev);
-
-			spin_lock_bh(&sl->lock);
-			if (sl->tty)
-				tty_hangup(sl->tty);
-
-			spin_unlock_bh(&sl->lock);
-			/*
-			 * VSV = if dev->start==0, then device
-			 * unregistered while close proc.
-			 */
-			unregister_netdev(dev);
-			free_netdev(dev);
-		}
-	}
-
-	kfree(x25_asy_devs);
-	tty_unregister_ldisc(N_X25);
-}
-
-module_init(init_x25_asy);
-module_exit(exit_x25_asy);
diff --git a/drivers/net/wan/x25_asy.h b/drivers/net/wan/x25_asy.h
deleted file mode 100644
index 87798287c9ca..000000000000
--- a/drivers/net/wan/x25_asy.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_X25_ASY_H
-#define _LINUX_X25_ASY_H
-
-/* X.25 asy configuration. */
-#define SL_NRUNIT	256		/* MAX number of X.25 channels;
-					   This can be overridden with
-					   insmod -ox25_asy_maxdev=nnn	*/
-#define SL_MTU		256	
-
-/* X25 async protocol characters. */
-#define X25_END         0x7E		/* indicates end of frame	*/
-#define X25_ESC         0x7D		/* indicates byte stuffing	*/
-#define X25_ESCAPE(x)	((x)^0x20)
-#define X25_UNESCAPE(x)	((x)^0x20)
-
-
-struct x25_asy {
-  int			magic;
-
-  /* Various fields. */
-  spinlock_t		lock;
-  struct tty_struct	*tty;		/* ptr to TTY structure		*/
-  struct net_device	*dev;		/* easy for intr handling	*/
-
-  /* These are pointers to the malloc()ed frame buffers. */
-  unsigned char		*rbuff;		/* receiver buffer		*/
-  int                   rcount;         /* received chars counter       */
-  unsigned char		*xbuff;		/* transmitter buffer		*/
-  unsigned char         *xhead;         /* pointer to next byte to XMIT */
-  int                   xleft;          /* bytes left in XMIT queue     */
-  int                   buffsize;       /* Max buffers sizes            */
-
-  unsigned long		flags;		/* Flag values/ mode etc	*/
-#define SLF_INUSE	0		/* Channel in use               */
-#define SLF_ESCAPE	1               /* ESC received                 */
-#define SLF_ERROR	2               /* Parity, etc. error           */
-};
-
-
-
-#define X25_ASY_MAGIC 0x5303
-
-int x25_asy_init(struct net_device *dev);
-
-#endif	/* _LINUX_X25_ASY.H */
-- 
2.27.0

