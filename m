Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207A621152A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgGAVbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:31:50 -0400
Received: from mout.gmx.net ([212.227.17.21]:58787 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGAVbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 17:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1593639100;
        bh=WqgqzSIV/fXGJHgLX3nLN3Sa3NGd6pZtqisLvlwQj/Y=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=jDhi6ozaQiA/epSJ8SMSRyq5AKKwzdYFEEfwIaIdWhV+CNDUM0mTLjwt6SwMDjDvk
         9AswSElEO8VOwfy3GjBo/ZeF+NBcj3EOJOrt8GK2F5kXmKTv+4K+dyga5qGfpzetQO
         4QA4opXuG4rX7sjZB1sy3usUUgSX2/HvcuczEW70=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([79.242.178.121]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MkYbu-1j6BYj3nOo-00lzdW; Wed, 01
 Jul 2020 23:31:40 +0200
Date:   Wed, 1 Jul 2020 23:31:39 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 1/2 net-next] lib8390: Miscellaneous cleanups
Message-ID: <be2652b22a35d2b4b065b6837d17e5c041d1e95f.1593627376.git.W_Armin@gmx.de>
References: <cover.1593627376.git.W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1593627376.git.W_Armin@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:DzNsQcPr1Df4qmAjElvpSvc1tbm8JMByn4iZq9igM/lB4bdQyTs
 ZF3S+a2krMzPdfQn6qbacbyh6dM6G0DOuYmfh5H2uBV6XgQcRLKTncmoKucRdw719F7x4cJ
 uCJtthlGKRLhOnec8vLdz0vMwz/Ae/5omHybb74BmVkOwCow8dmkHNUiYxYMw4IXSUG8Fym
 /OoFWC0yNC6tTp0vpc70g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hP+OdVLW4N8=:agffceeVPdBwjk09OEACDb
 RnnQD7pe8mkHmuPCUZzcx9jGJhB211ydqsg1ADgqWevm6jRQGXenu2oNoJITRggtsyqHfY+wi
 j8uhm3fdMlSuxiJMQbCsfBLuTmPeqgzmppFHYL8hnNhBrLo32/DlbHeG6Uet1VZAeb5McIKP/
 PjdeyBq9VC2JJo2f3CIrT1sZvyM3IZxPxTfGHbMSdE1vV/4T6Y/hhHn0whlTau+/LnI0EkoPw
 RLyxILLS3y5pVNYsdh08ba83JkHCy+QM+ChEuplfaq1r2umawYsC6xToQMI1ZnP8ESR8P/RJY
 Ww0mvbY8GfzvOQYa7ORc0MUi4pQMbRNgVHcixRHcmqIaTqBKSOz9Qv/PWSyp9rkN5NgMDIcnT
 mEK5zklyXeaiDtHnhWh0P+yYL/hvE+kinwZ5UwpkIOui+xkH2KZOo06gWLMDh+cq0XxfMeE11
 OsFDELp97ayEu5suZY0ozaSlmVUXQ4w2yHI8N+WzKMGrpap3xEAljl3Zk6XcJF3plQoMpQY81
 RPc1QirbURYsnHVThQCCnxfGxCH9XzENAKpahb6nde4YiZ7MOVs6hGF478neoKjQWgx3C4RPt
 HTGFT0Os3Mw9L6lp0nQBHYMjCzZeaer6Iw+1Kg/Cu9RkvAcOxF3up6znWuiO/8vBC/cNGZ/RZ
 ePRXTcTu5UMDrpc5e86Aqmt0hLxj3Fvt/oRMA77tQsjy5+pXUuuWDEp9qD9b+iAKtMUIt/TE2
 aR1+cJdIbeKfZgH62F1/XykqtlInjfrBlo/ieYThzWai6MuesUuUp69YOzEZ/udnY73FYYHPu
 vHZLpnYSbvzRHBU+vrJBL6NppmIizjwN/zjS67hIKfXNMvSs2S49Tj/rSqT32avQlAvpAC7JF
 Mv/ebIj0by2b3TZTGEs22Mek5Zmlv2l4D9O3831ZhTYtAECa9TlpnHmslGisIqij8RZKZUhR1
 yPq4qr5hzYdtj7Sdm/V8OxrnSTILij9O8DDPgRrwoCPtgiDNv+nM89weBa0C6yZdsuEUQ050/
 QMsghOs7QZix7AvbKV0djNc0u0d/fHjVv+scj21Qd/xNfJAj5hJz4snZlTgJvb03u7MmaLkxq
 BIc9SWYRKHCio7pr87D/lfsX9Bvz1OJZhHIf4zuG6Hsc/kusV+ZVSfkefzahVgChrMkzpU0wH
 3nic0rRjpGgS97fVrFNJnfPLVdaVEfhZ+sssMZF6S1999hWs7IJRY5bq0y2bvBJralqAc=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bunch of checkpatch issues.

Rework alloc_ei_netdev() to be a wrapper for
alloc_etherdev().

Remove version printing and the module-param
for msg_enable to avoid conflicts with real
modules using this library.

Remove unnecessary librarys.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 585 +++++++++++++---------------
 1 file changed, 279 insertions(+), 306 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index babc92e2692e..763735795a25 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -1,71 +1,61 @@
-/* 8390.c: A general NS8390 ethernet driver core for linux. */
-/*
-	Written 1992-94 by Donald Becker.
-
-	Copyright 1993 United States Government as represented by the
-	Director, National Security Agency.
-
-	This software may be used and distributed according to the terms
-	of the GNU General Public License, incorporated herein by reference.
-
-	The author may be reached as becker@scyld.com, or C/O
-	Scyld Computing Corporation
-	410 Severn Ave., Suite 210
-	Annapolis MD 21403
-
-
-  This is the chip-specific code for many 8390-based ethernet adaptors.
-  This is not a complete driver, it must be combined with board-specific
-  code such as ne.c, wd.c, 3c503.c, etc.
-
-  Seeing how at least eight drivers use this code, (not counting the
-  PCMCIA ones either) it is easy to break some card by what seems like
-  a simple innocent change. Please contact me or Donald if you think
-  you have found something that needs changing. -- PG
-
-
-  Changelog:
-
-  Paul Gortmaker	: remove set_bit lock, other cleanups.
-  Paul Gortmaker	: add ei_get_8390_hdr() so we can pass skb's to
-			  ei_block_input() for eth_io_copy_and_sum().
-  Paul Gortmaker	: exchange static int ei_pingpong for a #define,
-			  also add better Tx error handling.
-  Paul Gortmaker	: rewrite Rx overrun handling as per NS specs.
-  Alexey Kuznetsov	: use the 8390's six bit hash multicast filter.
-  Paul Gortmaker	: tweak ANK's above multicast changes a bit.
-  Paul Gortmaker	: update packet statistics for v2.1.x
-  Alan Cox		: support arbitrary stupid port mappings on the
-			  68K Macintosh. Support >16bit I/O spaces
-  Paul Gortmaker	: add kmod support for auto-loading of the 8390
-			  module by all drivers that require it.
-  Alan Cox		: Spinlocking work, added 'BUG_83C690'
-  Paul Gortmaker	: Separate out Tx timeout code from Tx path.
-  Paul Gortmaker	: Remove old unused single Tx buffer code.
-  Hayato Fujiwara	: Add m32r support.
-  Paul Gortmaker	: use skb_padto() instead of stack scratch area
-
-  Sources:
-  The National Semiconductor LAN Databook, and the 3Com 3c503 databook.
-
-  */
-
-#include <linux/module.h>
+/* lib8390.c: A general NS8390 ethernet driver core for linux. */
+/* Written 1992-94 by Donald Becker.
+ *
+ * Copyright 1993 United States Government as represented by the
+ * Director, National Security Agency.
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ * The author may be reached as becker@scyld.com, or C/O
+ * Scyld Computing Corporation
+ * 410 Severn Ave., Suite 210
+ *Annapolis MD 21403
+ *
+ * This is the chip-specific code for many 8390-based ethernet adaptors.
+ * This is not a complete driver, it must be combined with board-specific
+ * code such as ne.c, wd.c, 3c503.c, etc.
+ *
+ * Seeing how at least eight drivers use this code, (not counting the
+ * PCMCIA ones either) it is easy to break some card by what seems like
+ * a simple innocent change. Please contact me or Donald if you think
+ * you have found something that needs changing. -- PG
+ */
+
+/* Changelog:
+ *
+ * Paul Gortmaker	: remove set_bit lock, other cleanups.
+ * Paul Gortmaker	: add ei_get_8390_hdr() so we can pass skb's to
+ *			  ei_block_input() for eth_io_copy_and_sum().
+ * Paul Gortmaker	: exchange static int ei_pingpong for a #define,
+ *			  also add better Tx error handling.
+ * Paul Gortmaker	: rewrite Rx overrun handling as per NS specs.
+ * Alexey Kuznetsov	: use the 8390's six bit hash multicast filter.
+ * Paul Gortmaker	: tweak ANK's above multicast changes a bit.
+ * Paul Gortmaker	: update packet statistics for v2.1.x
+ * Alan Cox		: support arbitrary stupid port mappings on the
+ *			  68K Macintosh. Support >16bit I/O spaces
+ * Paul Gortmaker	: add kmod support for auto-loading of the 8390
+ *			  module by all drivers that require it.
+ * Alan Cox		: Spinlocking work, added 'BUG_83C690'
+ * Paul Gortmaker	: Separate out Tx timeout code from Tx path.
+ * Paul Gortmaker	: Remove old unused single Tx buffer code.
+ * Hayato Fujiwara	: Add m32r support.
+ * Paul Gortmaker	: use skb_padto() instead of stack scratch area
+ *
+ * Sources:
+ * The National Semiconductor LAN Databook, and the 3Com 3c503 databook.
+ */
+
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
-#include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#include <linux/bitops.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/fcntl.h>
 #include <linux/in.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/crc32.h>

 #include <linux/netdevice.h>
@@ -77,23 +67,25 @@
 #define BUG_83C690

 /* These are the operational function interfaces to board-specific
-   routines.
-	void reset_8390(struct net_device *dev)
-		Resets the board associated with DEV, including a hardware reset of
-		the 8390.  This is only called when there is a transmit timeout, and
-		it is always followed by 8390_init().
-	void block_output(struct net_device *dev, int count, const unsigned char=
 *buf,
-					  int start_page)
-		Write the COUNT bytes of BUF to the packet buffer at START_PAGE.  The
-		"page" value uses the 8390's 256-byte pages.
-	void get_8390_hdr(struct net_device *dev, struct e8390_hdr *hdr, int rin=
g_page)
-		Read the 4 byte, page aligned 8390 header. *If* there is a
-		subsequent read, it will be of the rest of the packet.
-	void block_input(struct net_device *dev, int count, struct sk_buff *skb,=
 int ring_offset)
-		Read COUNT bytes from the packet buffer into the skb data area. Start
-		reading from RING_OFFSET, the address as the 8390 sees it.  This will a=
lways
-		follow the read of the 8390 header.
-*/
+ * routines.
+ *	void reset_8390(struct net_device *dev)
+ *		Resets the board associated with DEV, including a hardware reset
+ *		of the 8390.  This is only called when there is a transmit
+ *		timeout, and it is always followed by 8390_init().
+ *	void block_output(struct net_device *dev, int count,
+ *			const unsigned char *buf, int start_page)
+ *		Write the COUNT bytes of BUF to the packet buffer at START_PAGE.
+ *		The "page" value uses the 8390's 256-byte pages.
+ *	void get_8390_hdr(struct net_device *dev, struct e8390_hdr *hdr,
+ *			int ring_page)
+ *		Read the 4 byte, page aligned 8390 header. *If* there is a
+ *		subsequent read, it will be of the rest of the packet.
+ *	void block_input(struct net_device *dev, int count,
+ *			struct sk_buff *skb, int ring_offset)
+ *		Read COUNT bytes from the packet buffer into the skb data area.
+ *		Start reading from RING_OFFSET, the address as the 8390 sees it.
+ *		This will always follow the read of the 8390 header.
+ */
 #define ei_reset_8390 (ei_local->reset_8390)
 #define ei_block_output (ei_local->block_output)
 #define ei_block_input (ei_local->block_input)
@@ -111,87 +103,79 @@ static void NS8390_trigger_send(struct net_device *d=
ev, unsigned int length,
 static void do_set_multicast_list(struct net_device *dev);
 static void __NS8390_init(struct net_device *dev, int startp);

-static unsigned version_printed;
-static u32 msg_enable;
-module_param(msg_enable, uint, 0444);
-MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h =
for bitmap)");
-
-/*
- *	SMP and the 8390 setup.
+/* SMP and the 8390 setup.
  *
- *	The 8390 isn't exactly designed to be multithreaded on RX/TX. There is
- *	a page register that controls bank and packet buffer access. We guard
- *	this with ei_local->page_lock. Nobody should assume or set the page ot=
her
- *	than zero when the lock is not held. Lock holders must restore page 0
- *	before unlocking. Even pure readers must take the lock to protect in
- *	page 0.
+ * The 8390 isn't exactly designed to be multithreaded on RX/TX. There is
+ * a page register that controls bank and packet buffer access. We guard
+ * this with ei_local->page_lock. Nobody should assume or set the page ot=
her
+ * than zero when the lock is not held. Lock holders must restore page 0
+ * before unlocking. Even pure readers must take the lock to protect in
+ * page 0.
  *
- *	To make life difficult the chip can also be very slow. We therefore ca=
n't
- *	just use spinlocks. For the longer lockups we disable the irq the devi=
ce
- *	sits on and hold the lock. We must hold the lock because there is a du=
al
- *	processor case other than interrupts (get stats/set multicast list in
- *	parallel with each other and transmit).
+ * To make life difficult the chip can also be very slow. We therefore ca=
n't
+ * just use spinlocks. For the longer lockups we disable the irq the devi=
ce
+ * sits on and hold the lock. We must hold the lock because there is a du=
al
+ * processor case other than interrupts (get stats/set multicast list in
+ * parallel with each other and transmit).
  *
- *	Note: in theory we can just disable the irq on the card _but_ there is
- *	a latency on SMP irq delivery. So we can easily go "disable irq" "sync=
 irqs"
- *	enter lock, take the queued irq. So we waddle instead of flying.
+ * Note: in theory we can just disable the irq on the card _but_ there is
+ * a latency on SMP irq delivery. So we can easily go "disable irq" "sync=
 irqs"
+ * enter lock, take the queued irq. So we waddle instead of flying.
  *
- *	Finally by special arrangement for the purpose of being generally
- *	annoying the transmit function is called bh atomic. That places
- *	restrictions on the user context callers as disable_irq won't save
- *	them.
+ * Finally by special arrangement for the purpose of being generally
+ * annoying the transmit function is called bh atomic. That places
+ * restrictions on the user context callers as disable_irq won't save
+ * them.
  *
- *	Additional explanation of problems with locking by Alan Cox:
+ * Additional explanation of problems with locking by Alan Cox:
  *
- *	"The author (me) didn't use spin_lock_irqsave because the slowness of =
the
- *	card means that approach caused horrible problems like losing serial d=
ata
- *	at 38400 baud on some chips. Remember many 8390 nics on PCI were ISA
- *	chips with FPGA front ends.
+ * "The author (me) didn't use spin_lock_irqsave because the slowness of =
the
+ * card means that approach caused horrible problems like losing serial d=
ata
+ * at 38400 baud on some chips. Remember many 8390 nics on PCI were ISA
+ * chips with FPGA front ends.
  *
- *	Ok the logic behind the 8390 is very simple:
+ * Ok the logic behind the 8390 is very simple:
  *
- *	Things to know
- *		- IRQ delivery is asynchronous to the PCI bus
- *		- Blocking the local CPU IRQ via spin locks was too slow
- *		- The chip has register windows needing locking work
+ * Things to know
+ *	- IRQ delivery is asynchronous to the PCI bus
+ *	- Blocking the local CPU IRQ via spin locks was too slow
+ *	- The chip has register windows needing locking work
  *
- *	So the path was once (I say once as people appear to have changed it
- *	in the mean time and it now looks rather bogus if the changes to use
- *	disable_irq_nosync_irqsave are disabling the local IRQ)
+ * So the path was once (I say once as people appear to have changed it
+ * in the mean time and it now looks rather bogus if the changes to use
+ * disable_irq_nosync_irqsave are disabling the local IRQ)
  *
+ *	Take the page lock
+ *	Mask the IRQ on chip
+ *	Disable the IRQ (but not mask locally- someone seems to have
+ *	broken this with the lock validator stuff)
+ *	[This must be _nosync as the page lock may otherwise deadlock us]
  *
- *		Take the page lock
- *		Mask the IRQ on chip
- *		Disable the IRQ (but not mask locally- someone seems to have
- *			broken this with the lock validator stuff)
- *			[This must be _nosync as the page lock may otherwise
- *				deadlock us]
- *		Drop the page lock and turn IRQs back on
+ *	Drop the page lock and turn IRQs back on
  *
- *		At this point an existing IRQ may still be running but we can't
- *		get a new one
+ *	At this point an existing IRQ may still be running but we can't
+ *	get a new one
  *
- *		Take the lock (so we know the IRQ has terminated) but don't mask
+ *	Take the lock (so we know the IRQ has terminated) but don't mask
  *	the IRQs on the processor
- *		Set irqlock [for debug]
  *
- *		Transmit (slow as ****)
+ *	Set irqlock [for debug]
  *
- *		re-enable the IRQ
+ *	Transmit (slow as ****)
  *
+ *	re-enable the IRQ
  *
- *	We have to use disable_irq because otherwise you will get delayed
- *	interrupts on the APIC bus deadlocking the transmit path.
+ * We have to use disable_irq because otherwise you will get delayed
+ * interrupts on the APIC bus deadlocking the transmit path.
  *
- *	Quite hairy but the chip simply wasn't designed for SMP and you can't
- *	even ACK an interrupt without risking corrupting other parallel
- *	activities on the chip." [lkml, 25 Jul 2007]
+ * Quite hairy but the chip simply wasn't designed for SMP and you can't
+ * even ACK an interrupt without risking corrupting other parallel
+ * activities on the chip." [lkml, 25 Jul 2007]
  */



-/**
- * ei_open - Open/initialize the board.
+/* ei_open - Open/initialize the board.
  * @dev: network device to initialize
  *
  * This routine goes all-out, setting everything
@@ -206,23 +190,22 @@ static int __ei_open(struct net_device *dev)
 	if (dev->watchdog_timeo <=3D 0)
 		dev->watchdog_timeo =3D TX_TIMEOUT;

-	/*
-	 *	Grab the page lock so we own the register set, then call
-	 *	the init function.
+	/* Grab the page lock so we own the register set, then call
+	 * the init function.
 	 */

 	spin_lock_irqsave(&ei_local->page_lock, flags);
 	__NS8390_init(dev, 1);
 	/* Set the flag before we drop the lock, That way the IRQ arrives
-	   after its set and we get no silly warnings */
+	 * after its set and we get no silly warnings
+	 */
 	netif_start_queue(dev);
 	spin_unlock_irqrestore(&ei_local->page_lock, flags);
 	ei_local->irqlock =3D 0;
 	return 0;
 }

-/**
- * ei_close - shut down network device
+/* ei_close - shut down network device
  * @dev: network device to close
  *
  * Opposite of ei_open(). Only used when "ifconfig <devname> down" is don=
e.
@@ -232,9 +215,7 @@ static int __ei_close(struct net_device *dev)
 	struct ei_device *ei_local =3D netdev_priv(dev);
 	unsigned long flags;

-	/*
-	 *	Hold the page lock during close
-	 */
+	/* Hold the page lock during close */

 	spin_lock_irqsave(&ei_local->page_lock, flags);
 	__NS8390_init(dev, 0);
@@ -243,8 +224,7 @@ static int __ei_close(struct net_device *dev)
 	return 0;
 }

-/**
- * ei_tx_timeout - handle transmit time out condition
+/* ei_tx_timeout - handle transmit time out condition
  * @dev: network device which has apparently fallen asleep
  *
  * Called by kernel when device never acknowledges a transmit has
@@ -289,8 +269,7 @@ static void __ei_tx_timeout(struct net_device *dev, un=
signed int txqueue)
 	netif_wake_queue(dev);
 }

-/**
- * ei_start_xmit - begin packet transmission
+/* ei_start_xmit - begin packet transmission
  * @skb: packet to be sent
  * @dev: network device to which packet is sent
  *
@@ -308,25 +287,25 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 	char *data =3D skb->data;

 	if (skb->len < ETH_ZLEN) {
-		memset(buf, 0, ETH_ZLEN);	/* more efficient than doing just the needed =
bits */
+		/* More efficient than doing just the needed bits */
+		memset(buf, 0, ETH_ZLEN);
 		memcpy(buf, data, skb->len);
 		send_length =3D ETH_ZLEN;
 		data =3D buf;
 	}

 	/* Mask interrupts from the ethercard.
-	   SMP: We have to grab the lock here otherwise the IRQ handler
-	   on another CPU can flip window and race the IRQ mask set. We end
-	   up trashing the mcast filter not disabling irqs if we don't lock */
+	 * SMP: We have to grab the lock here otherwise the IRQ handler
+	 * on another CPU can flip window and race the IRQ mask set. We end
+	 * up trashing the mcast filter not disabling irqs if we don't lock.
+	 */

 	spin_lock_irqsave(&ei_local->page_lock, flags);
 	ei_outb_p(0x00, e8390_base + EN0_IMR);
 	spin_unlock_irqrestore(&ei_local->page_lock, flags);


-	/*
-	 *	Slow phase with lock held.
-	 */
+	/* Slow phase with lock held. */

 	disable_irq_nosync_lockdep_irqsave(dev->irq, &flags);

@@ -334,8 +313,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,

 	ei_local->irqlock =3D 1;

-	/*
-	 * We have two Tx slots available for use. Find the first free
+	/* We have two Tx slots available for use. Find the first free
 	 * slot, and then perform some sanity checks. With two Tx bufs,
 	 * you get very close to transmitting back-to-back packets. With
 	 * only one Tx buf, the transmitter sits idle while you reload the
@@ -348,17 +326,19 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 		if ((netif_msg_tx_queued(ei_local)) &&
 		    ei_local->tx2 > 0)
 			netdev_dbg(dev,
-				   "idle transmitter tx2=3D%d, lasttx=3D%d, txing=3D%d\n",
-				   ei_local->tx2, ei_local->lasttx, ei_local->txing);
+				"idle transmitter tx2=3D%d, lasttx=3D%d, txing=3D%d\n",
+				ei_local->tx2, ei_local->lasttx,
+				ei_local->txing);
 	} else if (ei_local->tx2 =3D=3D 0) {
 		output_page =3D ei_local->tx_start_page + TX_PAGES/2;
 		ei_local->tx2 =3D send_length;
 		if ((netif_msg_tx_queued(ei_local)) &&
 		    ei_local->tx1 > 0)
 			netdev_dbg(dev,
-				   "idle transmitter, tx1=3D%d, lasttx=3D%d, txing=3D%d\n",
-				   ei_local->tx1, ei_local->lasttx, ei_local->txing);
-	} else {			/* We should never get here. */
+				"idle transmitter, tx1=3D%d, lasttx=3D%d, txing=3D%d\n",
+				ei_local->tx1, ei_local->lasttx,
+				ei_local->txing);
+	} else {		/* We should never get here. */
 		netif_dbg(ei_local, tx_err, dev,
 			  "No Tx buffers free! tx1=3D%d tx2=3D%d last=3D%d\n",
 			  ei_local->tx1, ei_local->tx2, ei_local->lasttx);
@@ -371,8 +351,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 		return NETDEV_TX_BUSY;
 	}

-	/*
-	 * Okay, now upload the packet and trigger a send if the transmitter
+	/* Okay, now upload the packet and trigger a send if the transmitter
 	 * isn't already sending. If it is busy, the interrupt handler will
 	 * trigger the send later, upon receiving a Tx done interrupt.
 	 */
@@ -410,8 +389,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 	return NETDEV_TX_OK;
 }

-/**
- * ei_interrupt - handle the interrupts from an 8390
+/* ei_interrupt - handle the interrupts from an 8390
  * @irq: interrupt number
  * @dev_id: a pointer to the net_device
  *
@@ -429,15 +407,12 @@ static irqreturn_t __ei_interrupt(int irq, void *dev=
_id)
 	int interrupts, nr_serviced =3D 0;
 	struct ei_device *ei_local =3D netdev_priv(dev);

-	/*
-	 *	Protect the irq test too.
-	 */
+	/* Protect the irq test too. */

 	spin_lock(&ei_local->page_lock);

 	if (ei_local->irqlock) {
-		/*
-		 * This might just be an interrupt for a PCI device sharing
+		/* This might just be an interrupt for a PCI device sharing
 		 * this line
 		 */
 		netdev_err(dev, "Interrupted while interrupts are masked! isr=3D%#2x im=
r=3D%#2x\n",
@@ -475,30 +450,39 @@ static irqreturn_t __ei_interrupt(int irq, void *dev=
_id)
 			ei_tx_err(dev);

 		if (interrupts & ENISR_COUNTERS) {
-			dev->stats.rx_frame_errors +=3D ei_inb_p(e8390_base + EN0_COUNTER0);
-			dev->stats.rx_crc_errors   +=3D ei_inb_p(e8390_base + EN0_COUNTER1);
-			dev->stats.rx_missed_errors +=3D ei_inb_p(e8390_base + EN0_COUNTER2);
-			ei_outb_p(ENISR_COUNTERS, e8390_base + EN0_ISR); /* Ack intr. */
+			dev->stats.rx_frame_errors +=3D
+				ei_inb_p(e8390_base + EN0_COUNTER0);
+			dev->stats.rx_crc_errors   +=3D
+				ei_inb_p(e8390_base + EN0_COUNTER1);
+			dev->stats.rx_missed_errors +=3D
+				ei_inb_p(e8390_base + EN0_COUNTER2);
+			/* Ack intr. */
+			ei_outb_p(ENISR_COUNTERS, e8390_base + EN0_ISR);
 		}

 		/* Ignore any RDC interrupts that make it back to here. */
 		if (interrupts & ENISR_RDC)
 			ei_outb_p(ENISR_RDC, e8390_base + EN0_ISR);

-		ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_START, e8390_base + E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START,
+			  e8390_base + E8390_CMD);
 	}

 	if (interrupts && (netif_msg_intr(ei_local))) {
-		ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_START, e8390_base + E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START,
+			  e8390_base + E8390_CMD);
 		if (nr_serviced >=3D MAX_SERVICE) {
 			/* 0xFF is valid for a card removal */
 			if (interrupts !=3D 0xFF)
 				netdev_warn(dev, "Too much work at interrupt, status %#2.2x\n",
 					    interrupts);
-			ei_outb_p(ENISR_ALL, e8390_base + EN0_ISR); /* Ack. most intrs. */
+			/* Ack. most intrs. */
+			ei_outb_p(ENISR_ALL, e8390_base + EN0_ISR);
 		} else {
-			netdev_warn(dev, "unknown interrupt %#2x\n", interrupts);
-			ei_outb_p(0xff, e8390_base + EN0_ISR); /* Ack. all intrs. */
+			netdev_warn(dev, "unknown interrupt %#2x\n",
+				    interrupts);
+			/* Ack. all intrs. */
+			ei_outb_p(0xff, e8390_base + EN0_ISR);
 		}
 	}
 	spin_unlock(&ei_local->page_lock);
@@ -514,8 +498,7 @@ static void __ei_poll(struct net_device *dev)
 }
 #endif

-/**
- * ei_tx_err - handle transmitter error
+/* ei_tx_err - handle transmitter error
  * @dev: network device which threw the exception
  *
  * A transmitter error has happened. Most likely excess collisions (which
@@ -537,18 +520,25 @@ static void ei_tx_err(struct net_device *dev)
 	unsigned char tx_was_aborted =3D txsr & (ENTSR_ABT+ENTSR_FU);

 #ifdef VERBOSE_ERROR_DUMP
-	netdev_dbg(dev, "transmitter error (%#2x):", txsr);
+#define DEBUG_8390_SIZE 75 /* Without NULL-Termination */
+	char printk_buf[DEBUG_8390_SIZE + 1] =3D ":";
+
 	if (txsr & ENTSR_ABT)
-		pr_cont(" excess-collisions ");
+		strncat(printk_buf, " excess-collisions",
+			DEBUG_8390_SIZE - strlen(printk_buf));
 	if (txsr & ENTSR_ND)
-		pr_cont(" non-deferral ");
+		strncat(printk_buf, " non-deferral",
+			DEBUG_8390_SIZE - strlen(printk_buf));
 	if (txsr & ENTSR_CRS)
-		pr_cont(" lost-carrier ");
+		strncat(printk_buf, " lost-carrier",
+			DEBUG_8390_SIZE - strlen(printk_buf));
 	if (txsr & ENTSR_FU)
-		pr_cont(" FIFO-underrun ");
+		strncat(printk_buf, " FIFO-underrun",
+			DEBUG_8390_SIZE - strlen(printk_buf));
 	if (txsr & ENTSR_CDH)
-		pr_cont(" lost-heartbeat ");
-	pr_cont("\n");
+		strncat(printk_buf, " lost-heartbeat",
+			DEBUG_8390_SIZE - strlen(printk_buf));
+	netdev_dbg(dev, "Transmitter error (%#2x)%s", txsr, printk_buf);
 #endif

 	ei_outb_p(ENISR_TX_ERR, e8390_base + EN0_ISR); /* Ack intr. */
@@ -566,8 +556,7 @@ static void ei_tx_err(struct net_device *dev)
 	}
 }

-/**
- * ei_tx_intr - transmit interrupt handler
+/* ei_tx_intr - transmit interrupt handler
  * @dev: network device for which tx intr is handled
  *
  * We have finished a transmit: check for errors and then trigger the nex=
t
@@ -582,8 +571,7 @@ static void ei_tx_intr(struct net_device *dev)

 	ei_outb_p(ENISR_TX, e8390_base + EN0_ISR); /* Ack intr. */

-	/*
-	 * There are two Tx buffers, see which one finished, and trigger
+	/* There are two Tx buffers, see which one finished, and trigger
 	 * the send of another one if it exists.
 	 */
 	ei_local->txqueue--;
@@ -595,7 +583,8 @@ static void ei_tx_intr(struct net_device *dev)
 		ei_local->tx1 =3D 0;
 		if (ei_local->tx2 > 0) {
 			ei_local->txing =3D 1;
-			NS8390_trigger_send(dev, ei_local->tx2, ei_local->tx_start_page + 6);
+			NS8390_trigger_send(dev, ei_local->tx2,
+					    ei_local->tx_start_page + 6);
 			netif_trans_update(dev);
 			ei_local->tx2 =3D -1,
 			ei_local->lasttx =3D 2;
@@ -608,16 +597,19 @@ static void ei_tx_intr(struct net_device *dev)
 		ei_local->tx2 =3D 0;
 		if (ei_local->tx1 > 0) {
 			ei_local->txing =3D 1;
-			NS8390_trigger_send(dev, ei_local->tx1, ei_local->tx_start_page);
+			NS8390_trigger_send(dev, ei_local->tx1,
+					    ei_local->tx_start_page);
 			netif_trans_update(dev);
 			ei_local->tx1 =3D -1;
 			ei_local->lasttx =3D 1;
 		} else
 			ei_local->lasttx =3D 10, ei_local->txing =3D 0;
-	} /* else
-		netdev_warn(dev, "unexpected TX-done interrupt, lasttx=3D%d\n",
-			    ei_local->lasttx);
-*/
+	}
+	/* else {
+	 *	netdev_warn(dev, "unexpected TX-done interrupt, lasttx=3D%d\n",
+	 *		    ei_local->lasttx);
+	 * }
+	 */

 	/* Minimize Tx latency: update the statistics after we restart TXing. */
 	if (status & ENTSR_COL)
@@ -642,8 +634,7 @@ static void ei_tx_intr(struct net_device *dev)
 	netif_wake_queue(dev);
 }

-/**
- * ei_receive - receive some packets
+/* ei_receive - receive some packets
  * @dev: network device with which receive will be run
  *
  * We have a good packet(s), get it/them out of the buffers.
@@ -668,16 +659,19 @@ static void ei_receive(struct net_device *dev)
 		rxing_page =3D ei_inb_p(e8390_base + EN1_CURPAG);
 		ei_outb_p(E8390_NODMA+E8390_PAGE0, e8390_base + E8390_CMD);

-		/* Remove one frame from the ring.  Boundary is always a page behind. *=
/
+		/* Remove one frame from the ring.
+		 * Boundary is always a page behind.
+		 */
 		this_frame =3D ei_inb_p(e8390_base + EN0_BOUNDARY) + 1;
 		if (this_frame >=3D ei_local->stop_page)
 			this_frame =3D ei_local->rx_start_page;

-		/* Someday we'll omit the previous, iff we never get this message.
-		   (There is at least one clone claimed to have a problem.)
-
-		   Keep quiet if it looks like a card removal. One problem here
-		   is that some clones crash in roughly the same way.
+		/* Someday we'll omit the previous, if we never get
+		 * this message. (There is at least one clone claimed
+		 * to have a problem.)
+		 *
+		 * Keep quiet if it looks like a card removal. One problem
+		 * here is that some clones crash in roughly the same way.
 		 */
 		if ((netif_msg_rx_status(ei_local)) &&
 		    this_frame !=3D ei_local->current_page &&
@@ -697,15 +691,17 @@ static void ei_receive(struct net_device *dev)

 		next_frame =3D this_frame + 1 + ((pkt_len+4)>>8);

-		/* Check for bogosity warned by 3c503 book: the status byte is never
-		   written.  This happened a lot during testing! This code should be
-		   cleaned up someday. */
+		/* Check for bogosity warned by 3c503 book: the status byte is
+		 * never written. This happened a lot during testing! This code
+		 * should be cleaned up someday.
+		 */
 		if (rx_frame.next !=3D next_frame &&
 		    rx_frame.next !=3D next_frame + 1 &&
 		    rx_frame.next !=3D next_frame - num_rx_pages &&
 		    rx_frame.next !=3D next_frame + 1 - num_rx_pages) {
 			ei_local->current_page =3D rxing_page;
-			ei_outb(ei_local->current_page-1, e8390_base+EN0_BOUNDARY);
+			ei_outb(ei_local->current_page - 1,
+				e8390_base + EN0_BOUNDARY);
 			dev->stats.rx_errors++;
 			continue;
 		}
@@ -722,23 +718,21 @@ static void ei_receive(struct net_device *dev)

 			skb =3D netdev_alloc_skb(dev, pkt_len + 2);
 			if (skb =3D=3D NULL) {
-				netif_err(ei_local, rx_err, dev,
-					  "Couldn't allocate a sk_buff of size %d\n",
-					  pkt_len);
 				dev->stats.rx_dropped++;
 				break;
-			} else {
-				skb_reserve(skb, 2);	/* IP headers on 16 byte boundaries */
-				skb_put(skb, pkt_len);	/* Make room */
-				ei_block_input(dev, pkt_len, skb, current_offset + sizeof(rx_frame));
-				skb->protocol =3D eth_type_trans(skb, dev);
-				if (!skb_defer_rx_timestamp(skb))
-					netif_rx(skb);
-				dev->stats.rx_packets++;
-				dev->stats.rx_bytes +=3D pkt_len;
-				if (pkt_stat & ENRSR_PHY)
-					dev->stats.multicast++;
 			}
+			/* IP headers on 16 byte boundaries */
+			skb_reserve(skb, 2);
+			skb_put(skb, pkt_len);	/* Make room */
+			ei_block_input(dev, pkt_len, skb,
+				       current_offset + sizeof(rx_frame));
+			skb->protocol =3D eth_type_trans(skb, dev);
+			if (!skb_defer_rx_timestamp(skb))
+				netif_rx(skb);
+			dev->stats.rx_packets++;
+			dev->stats.rx_bytes +=3D pkt_len;
+			if (pkt_stat & ENRSR_PHY)
+				dev->stats.multicast++;
 		} else {
 			netif_err(ei_local, rx_err, dev,
 				  "bogus packet: status=3D%#2x nxpg=3D%#2x size=3D%d\n",
@@ -751,7 +745,9 @@ static void ei_receive(struct net_device *dev)
 		}
 		next_frame =3D rx_frame.next;

-		/* This _should_ never happen: it's here for avoiding bad clones. */
+		/* This _should_ never happen:
+		 * it's here for avoiding bad clones.
+		 */
 		if (next_frame >=3D ei_local->stop_page) {
 			netdev_notice(dev, "next frame inconsistency, %#2x\n",
 				      next_frame);
@@ -762,12 +758,12 @@ static void ei_receive(struct net_device *dev)
 	}

 	/* We used to also ack ENISR_OVER here, but that would sometimes mask
-	   a real overrun, leaving the 8390 in a stopped state with rec'vr off. =
*/
+	 * a real overrun, leaving the 8390 in a stopped state with rec'vr off.
+	 */
 	ei_outb_p(ENISR_RX+ENISR_RX_ERR, e8390_base+EN0_ISR);
 }

-/**
- * ei_rx_overrun - handle receiver overrun
+/* ei_rx_overrun - handle receiver overrun
  * @dev: network device which threw exception
  *
  * We have a receiver overrun: we have to kick the 8390 to get it started
@@ -786,8 +782,7 @@ static void ei_rx_overrun(struct net_device *dev)
 	/* ei_local is used on some platforms via the EI_SHIFT macro */
 	struct ei_device *ei_local __maybe_unused =3D netdev_priv(dev);

-	/*
-	 * Record whether a Tx was in progress and then issue the
+	/* Record whether a Tx was in progress and then issue the
 	 * stop command.
 	 */
 	was_txing =3D ei_inb_p(e8390_base+E8390_CMD) & E8390_TRANS;
@@ -796,8 +791,7 @@ static void ei_rx_overrun(struct net_device *dev)
 	netif_dbg(ei_local, rx_err, dev, "Receiver overrun\n");
 	dev->stats.rx_over_errors++;

-	/*
-	 * Wait a full Tx time (1.2ms) + some guard time, NS says 1.6ms total.
+	/* Wait a full Tx time (1.2ms) + some guard time, NS says 1.6ms total.
 	 * Early datasheets said to poll the reset bit, but now they say that
 	 * it "is not a reliable indicator and subsequently should be ignored."
 	 * We wait at least 10ms.
@@ -805,47 +799,44 @@ static void ei_rx_overrun(struct net_device *dev)

 	mdelay(10);

-	/*
-	 * Reset RBCR[01] back to zero as per magic incantation.
-	 */
+	/* Reset RBCR[01] back to zero as per magic incantation. */
 	ei_outb_p(0x00, e8390_base+EN0_RCNTLO);
 	ei_outb_p(0x00, e8390_base+EN0_RCNTHI);

-	/*
-	 * See if any Tx was interrupted or not. According to NS, this
+	/* See if any Tx was interrupted or not. According to NS, this
 	 * step is vital, and skipping it will cause no end of havoc.
 	 */

 	if (was_txing) {
-		unsigned char tx_completed =3D ei_inb_p(e8390_base+EN0_ISR) & (ENISR_TX=
+ENISR_TX_ERR);
+		unsigned char tx_completed =3D ei_inb_p(e8390_base + EN0_ISR) &
+				(ENISR_TX + ENISR_TX_ERR);
+
 		if (!tx_completed)
 			must_resend =3D 1;
 	}

-	/*
-	 * Have to enter loopback mode and then restart the NIC before
+	/* Have to enter loopback mode and then restart the NIC before
 	 * you are allowed to slurp packets up off the ring.
 	 */
+
 	ei_outb_p(E8390_TXOFF, e8390_base + EN0_TXCR);
-	ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START, e8390_base + E8390_CM=
D);
+	ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START,
+		  e8390_base + E8390_CMD);
+
+	/* Clear the Rx ring of all the debris, and ack the interrupt. */

-	/*
-	 * Clear the Rx ring of all the debris, and ack the interrupt.
-	 */
 	ei_receive(dev);
 	ei_outb_p(ENISR_OVER, e8390_base+EN0_ISR);

-	/*
-	 * Leave loopback mode, and resend any packet that got stopped.
-	 */
+	/* Leave loopback mode, and resend any packet that got stopped */
+
 	ei_outb_p(E8390_TXCONFIG, e8390_base + EN0_TXCR);
 	if (must_resend)
-		ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START + E8390_TRANS, e8390_=
base + E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START + E8390_TRANS,
+			  e8390_base + E8390_CMD);
 }

-/*
- *	Collect the stats. This is called unlocked and from several contexts.
- */
+/* Collect the stats. This is called unlocked and from several contexts. =
*/

 static struct net_device_stats *__ei_get_stats(struct net_device *dev)
 {
@@ -867,8 +858,7 @@ static struct net_device_stats *__ei_get_stats(struct =
net_device *dev)
 	return &dev->stats;
 }

-/*
- * Form the 64 bit 8390 multicast table from the linked list of addresses
+/* Form the 64 bit 8390 multicast table from the linked list of addresses
  * associated with this dev structure.
  */

@@ -878,16 +868,14 @@ static inline void make_mc_bits(u8 *bits, struct net=
_device *dev)

 	netdev_for_each_mc_addr(ha, dev) {
 		u32 crc =3D ether_crc(ETH_ALEN, ha->addr);
-		/*
-		 * The 8390 uses the 6 most significant bits of the
+		/* The 8390 uses the 6 most significant bits of the
 		 * CRC to index the multicast table.
 		 */
 		bits[crc>>29] |=3D (1<<((crc>>26)&7));
 	}
 }

-/**
- * do_set_multicast_list - set/clear multicast filter
+/* do_set_multicast_list - set/clear multicast filter
  * @dev: net device for which multicast filter is adjusted
  *
  *	Set or clear the multicast filter for this adaptor. May be called
@@ -905,10 +893,10 @@ static void do_set_multicast_list(struct net_device =
*dev)
 		if (!netdev_mc_empty(dev))
 			make_mc_bits(ei_local->mcfilter, dev);
 	} else
-		memset(ei_local->mcfilter, 0xFF, 8);	/* mcast set to accept-all */
+		/* mcast set to accept-all */
+		memset(ei_local->mcfilter, 0xFF, 8);

-	/*
-	 * DP8390 manuals don't specify any magic sequence for altering
+	/* DP8390 manuals don't specify any magic sequence for altering
 	 * the multicast regs on an already running card. To be safe, we
 	 * ensure multicast mode is off prior to loading up the new hash
 	 * table. If this proves to be not enough, we can always resort
@@ -924,11 +912,12 @@ static void do_set_multicast_list(struct net_device =
*dev)
 		ei_outb_p(E8390_RXCONFIG, e8390_base + EN0_RXCR);
 	ei_outb_p(E8390_NODMA + E8390_PAGE1, e8390_base + E8390_CMD);
 	for (i =3D 0; i < 8; i++) {
-		ei_outb_p(ei_local->mcfilter[i], e8390_base + EN1_MULT_SHIFT(i));
+		ei_outb_p(ei_local->mcfilter[i],
+			  e8390_base + EN1_MULT_SHIFT(i));
 #ifndef BUG_83C690
-		if (ei_inb_p(e8390_base + EN1_MULT_SHIFT(i)) !=3D ei_local->mcfilter[i]=
)
-			netdev_err(dev, "Multicast filter read/write mismap %d\n",
-				   i);
+		if (ei_inb_p(e8390_base + EN1_MULT_SHIFT(i)) !=3D
+				ei_local->mcfilter[i])
+			netdev_err(dev, "Multicast filter read/write mismap %d\n", i);
 #endif
 	}
 	ei_outb_p(E8390_NODMA + E8390_PAGE0, e8390_base + E8390_CMD);
@@ -941,10 +930,9 @@ static void do_set_multicast_list(struct net_device *=
dev)
 		ei_outb_p(E8390_RXCONFIG, e8390_base + EN0_RXCR);
 }

-/*
- *	Called without lock held. This is invoked from user context and may
- *	be parallel to just about everything else. Its also fairly quick and
- *	not called too often. Must protect against both bh and irq users
+/* Called without lock held. This is invoked from user context and may
+ * be parallel to just about everything else. Its also fairly quick and
+ * not called too often. Must protect against both bh and irq users
  */

 static void __ei_set_multicast_list(struct net_device *dev)
@@ -957,48 +945,27 @@ static void __ei_set_multicast_list(struct net_devic=
e *dev)
 	spin_unlock_irqrestore(&ei_local->page_lock, flags);
 }

-/**
- * ethdev_setup - init rest of 8390 device struct
- * @dev: network device structure to init
- *
- * Initialize the rest of the 8390 device structure.  Do NOT __init
- * this, as it is used by 8390 based modular drivers too.
- */
-
-static void ethdev_setup(struct net_device *dev)
-{
-	struct ei_device *ei_local =3D netdev_priv(dev);
-
-	if ((msg_enable & NETIF_MSG_DRV) && (version_printed++ =3D=3D 0))
-		pr_info("%s", version);
-
-	ether_setup(dev);
-
-	spin_lock_init(&ei_local->page_lock);
-
-	ei_local->msg_enable =3D msg_enable;
-}
-
-/**
- * alloc_ei_netdev - alloc_etherdev counterpart for 8390
+/* alloc_ei_netdev - alloc_etherdev wrapper for 8390
  * @size: extra bytes to allocate
  *
  * Allocate 8390-specific net_device.
  */
 static struct net_device *____alloc_ei_netdev(int size)
 {
-	return alloc_netdev(sizeof(struct ei_device) + size, "eth%d",
-			    NET_NAME_UNKNOWN, ethdev_setup);
-}
-
+	struct net_device *dev =3D alloc_etherdev(sizeof(struct ei_device) + siz=
e);

+	if (dev) {
+		struct ei_device *ei_local =3D netdev_priv(dev);

+		spin_lock_init(&ei_local->page_lock);
+	}
+	return dev;
+}

 /* This page of functions should be 8390 generic */
 /* Follow National Semi's recommendations for initializing the "NIC". */

-/**
- * NS8390_init - initialize 8390 hardware
+/* NS8390_init - initialize 8390 hardware
  * @dev: network device to initialize
  * @startp: boolean.  non-zero value to initiate chip processing
  *
@@ -1017,7 +984,8 @@ static void __NS8390_init(struct net_device *dev, int=
 startp)
 	if (sizeof(struct e8390_pkt_hdr) !=3D 4)
 		panic("8390.c: header struct mispacked\n");
 	/* Follow National Semi's recommendations for initing the DP83902. */
-	ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_STOP, e8390_base+E8390_CMD); /* =
0x21 */
+	ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_STOP,
+		  e8390_base + E8390_CMD); /* 0x21 */
 	ei_outb_p(endcfg, e8390_base + EN0_DCFG);	/* 0x48 or 0x49 */
 	/* Clear the remote byte count registers. */
 	ei_outb_p(0x00,  e8390_base + EN0_RCNTLO);
@@ -1029,8 +997,10 @@ static void __NS8390_init(struct net_device *dev, in=
t startp)
 	ei_outb_p(ei_local->tx_start_page, e8390_base + EN0_TPSR);
 	ei_local->tx1 =3D ei_local->tx2 =3D 0;
 	ei_outb_p(ei_local->rx_start_page, e8390_base + EN0_STARTPG);
-	ei_outb_p(ei_local->stop_page-1, e8390_base + EN0_BOUNDARY);	/* 3c503 sa=
ys 0x3f,NS0x26*/
-	ei_local->current_page =3D ei_local->rx_start_page;		/* assert boundary+=
1 */
+	/* 3c503 says 0x3f,NS0x26*/
+	ei_outb_p(ei_local->stop_page - 1, e8390_base + EN0_BOUNDARY);
+	/* assert boundary+1 */
+	ei_local->current_page =3D ei_local->rx_start_page;
 	ei_outb_p(ei_local->stop_page, e8390_base + EN0_STOPPG);
 	/* Clear the pending interrupts and mask. */
 	ei_outb_p(0xFF, e8390_base + EN0_ISR);
@@ -1038,11 +1008,12 @@ static void __NS8390_init(struct net_device *dev, =
int startp)

 	/* Copy the station address into the DS8390 registers. */

-	ei_outb_p(E8390_NODMA + E8390_PAGE1 + E8390_STOP, e8390_base+E8390_CMD);=
 /* 0x61 */
+	ei_outb_p(E8390_NODMA + E8390_PAGE1 + E8390_STOP,
+		  e8390_base + E8390_CMD); /* 0x61 */
 	for (i =3D 0; i < 6; i++) {
 		ei_outb_p(dev->dev_addr[i], e8390_base + EN1_PHYS_SHIFT(i));
-		if ((netif_msg_probe(ei_local)) &&
-		    ei_inb_p(e8390_base + EN1_PHYS_SHIFT(i)) !=3D dev->dev_addr[i])
+		if ((netif_msg_probe(ei_local)) && ei_inb_p(e8390_base +
+					EN1_PHYS_SHIFT(i)) !=3D dev->dev_addr[i])
 			netdev_err(dev,
 				   "Hw. address read/write mismap %d\n", i);
 	}
@@ -1056,7 +1027,8 @@ static void __NS8390_init(struct net_device *dev, in=
t startp)
 	if (startp) {
 		ei_outb_p(0xff,  e8390_base + EN0_ISR);
 		ei_outb_p(ENISR_ALL,  e8390_base + EN0_IMR);
-		ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_START, e8390_base+E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START,
+			  e8390_base + E8390_CMD);
 		ei_outb_p(E8390_TXCONFIG, e8390_base + EN0_TXCR); /* xmit on. */
 		/* 3c503 TechMan says rxconfig only after the NIC is started. */
 		ei_outb_p(E8390_RXCONFIG, e8390_base + EN0_RXCR); /* rx on,  */
@@ -1065,7 +1037,8 @@ static void __NS8390_init(struct net_device *dev, in=
t startp)
 }

 /* Trigger a transmit start, assuming the length is valid.
-   Always called with the page lock held */
+ * Always called with the page lock held.
+ */

 static void NS8390_trigger_send(struct net_device *dev, unsigned int leng=
th,
 								int start_page)
=2D-
2.20.1

