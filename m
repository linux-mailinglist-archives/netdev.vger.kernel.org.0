Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2FF22B5CB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgGWSgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:36:22 -0400
Received: from mout.gmx.net ([212.227.17.22]:35327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgGWSgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 14:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595529365;
        bh=++R6V4cYZTmvXQt535Gg06TQqicc05i/q5cW7iq76aA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=cvZRqIy3/rNnf2YfF0I2nE29VoDv8aPbNYFPR9XvTuF7yxeQWUlYYw1JVXQrzBvhN
         SnWq2yaF2FQyC/3zwTMGFo6LIMRN4/o2ZlTFEBp91/nRmbkxP49tYf1jyzK+g7/kfF
         pEN6GFZ/HXwLyObyGsa7kQNe8bgESXZ5OrXhvHpI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.208.104]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8ykg-1jvuuh1Z2M-0067md; Thu, 23
 Jul 2020 20:36:05 +0200
Date:   Thu, 23 Jul 2020 20:36:04 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] lib8390: Fix coding-style issues and remove
 verion printing
Message-ID: <20200723183604.GA6850@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:f/miQn8eyMzalbB7fXy5s1SX4Rgu1hzTp/GElkDO0CNh5dduNds
 l6unxBBnUQk29BkekfJS2s1vvaEJISxafTN/KHLMs/YHxdEEpxUsu/kuBJtk9PiLGjafxN7
 P/R1uOj8xkGK/wrPRXfRxnkzOOEvdkD/AsIL1p/R5GHmr3syXM/gGhi0PaPO04h2W/NKa1e
 GAD0+uyFj+16/4k+iLQQg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ToZx4tjTB+o=:aOWpW290Nqseb2eYpaE2kR
 mG6Cm6j715iqW51a1co0fChn+JQcPv9vTg0yOL3TsxL5yIUB++wUGplKi9CkZyePLY4MUgubD
 3FKpafTJZ5pnlf3ZB1of+av1mwDYCs5HvkZWpHzZYUXyo9/H2a4wnUvZKCBjOyAFdwT7owsnC
 dAdxxlN7vwBmY3wbsdkIFMiTcPxzsiGsBf6d9EtFerXOaXOjrXe8A0qRbIn/guCnoWdVTsatr
 UBsWv5R8bZDFfBmLPST6hlgHKdzDr/EdqJkFWj9HWTNxUnHZRNyObJ72/TGXnDTn7o/boa9ZY
 Kc5YLml8u7IWf8SiMQphn4tzl4w34W4iLGr85Vcr3676nuPXsHt3jvv8cqCsexTWo4HZuPveA
 T1AHMx62JUT+HfdutqtUZaVZS8MCl2xU4y+9Wz9d90Z1dRwZ19p/egt4mINEDTLF+9QR07r23
 P6MzIFzE2rYbLvFZdjQ6+J2fRcRMDF5K1mP0hfs3tojeMcuQFzPfWtalaaZJlcQ2OX8dFXtwc
 /KOmlyRPBeuQeE+wohYayEQjejItTwJ669e2mSgm0hI/MfNOHxqhI6HVy/xMXhwzdkQ46G3nI
 XG0TtdJ9/jo3iDwMlQRR154Swz+HkGAzOjL22+b+uagEbCRVSUR9hlyf3TkTZp6bv73OjmXPK
 Gbxxuyq6p5pOXqutPq5jrScD0JsTYX9EYJNBtS773tHes86nLRbdL1POek69rXKbonFd7m5Dw
 JPDGHe9MGBOzrzBYXX+mTnqqZn335IrNtxtpd5kO+rUY/MvEGBOHHZpmHkc18/cRgmCNGYaF2
 o77qR5lMrcqA9f0sdmlPjrq/Iw2c2yTXw7EKTpJyxO3k/V7n2yHl4BV8mEAzxD6Iu1E77v+gM
 4M1K7C8xkPGUcUXm9JzVT2/aKwxbDh6TnSnb1uc0EyvOWlmbHxf56L/AwAePl2YhKBfDvycRU
 iKnvNeoGUlHXyw59Ni/cnMczeXF6OaP3gaQ1cBHAxx/mGW7H0EpaoeBkOlXpybfHYF/P6wNCf
 BBju/jLhyYMIJGrvAj53xQfEhlGT6cTYOaHX1NexySrlIVEXnWfF1PaMIyQvLbO5GQiVgsQ+y
 QEu10QJmOA0dPIuTjDzBJPCAD6tSWWAuuJL0CNoYx7+eZOSUZ0YEjJmBvf17Ur3B8ajC2KeAp
 0YeqdtXkWVq1y17/Z1ov9YrM0ByRExFQhTPlx2PoJUXL5P5LEj54F4zjDFTKW4CSqG023HM3q
 zx2CSJquBrVKXFGhC
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix various checkpatch warnings.
Remove version printing so modules including lib8390 do not
have to provide a global version string for successful
compilation.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/lib8390.c | 639 ++++++++++++++--------------
 1 file changed, 312 insertions(+), 327 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index babc92e2692e..5d6ab76825e3 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -1,54 +1,51 @@
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

 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -77,23 +74,25 @@
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
@@ -106,92 +105,87 @@ static void ei_receive(struct net_device *dev);
 static void ei_rx_overrun(struct net_device *dev);

 /* Routines generic to NS8390-based boards. */
-static void NS8390_trigger_send(struct net_device *dev, unsigned int leng=
th,
-								int start_page);
+static void NS8390_trigger_send(struct net_device *dev,
+				unsigned int length, int start_page);
 static void do_set_multicast_list(struct net_device *dev);
 static void __NS8390_init(struct net_device *dev, int startp);

-static unsigned version_printed;
 static u32 msg_enable;
+
 module_param(msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h =
for bitmap)");

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

-
-
-/**
- * ei_open - Open/initialize the board.
+/* ei_open - Open/initialize the board.
  * @dev: network device to initialize
  *
  * This routine goes all-out, setting everything
@@ -206,23 +200,22 @@ static int __ei_open(struct net_device *dev)
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
@@ -232,9 +225,7 @@ static int __ei_close(struct net_device *dev)
 	struct ei_device *ei_local =3D netdev_priv(dev);
 	unsigned long flags;

-	/*
-	 *	Hold the page lock during close
-	 */
+	/* Hold the page lock during close */

 	spin_lock_irqsave(&ei_local->page_lock, flags);
 	__NS8390_init(dev, 0);
@@ -243,8 +234,7 @@ static int __ei_close(struct net_device *dev)
 	return 0;
 }

-/**
- * ei_tx_timeout - handle transmit time out condition
+/* ei_tx_timeout - handle transmit time out condition
  * @dev: network device which has apparently fallen asleep
  *
  * Called by kernel when device never acknowledges a transmit has
@@ -261,8 +251,8 @@ static void __ei_tx_timeout(struct net_device *dev, un=
signed int txqueue)
 	dev->stats.tx_errors++;

 	spin_lock_irqsave(&ei_local->page_lock, flags);
-	txsr =3D ei_inb(e8390_base+EN0_TSR);
-	isr =3D ei_inb(e8390_base+EN0_ISR);
+	txsr =3D ei_inb(e8390_base + EN0_TSR);
+	isr =3D ei_inb(e8390_base + EN0_ISR);
 	spin_unlock_irqrestore(&ei_local->page_lock, flags);

 	netdev_dbg(dev, "Tx timed out, %s TSR=3D%#2x, ISR=3D%#2x, t=3D%d\n",
@@ -289,8 +279,7 @@ static void __ei_tx_timeout(struct net_device *dev, un=
signed int txqueue)
 	netif_wake_queue(dev);
 }

-/**
- * ei_start_xmit - begin packet transmission
+/* ei_start_xmit - begin packet transmission
  * @skb: packet to be sent
  * @dev: network device to which packet is sent
  *
@@ -308,25 +297,24 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
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

-
-	/*
-	 *	Slow phase with lock held.
-	 */
+	/* Slow phase with lock held. */

 	disable_irq_nosync_lockdep_irqsave(dev->irq, &flags);

@@ -334,8 +322,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,

 	ei_local->irqlock =3D 1;

-	/*
-	 * We have two Tx slots available for use. Find the first free
+	/* We have two Tx slots available for use. Find the first free
 	 * slot, and then perform some sanity checks. With two Tx bufs,
 	 * you get very close to transmitting back-to-back packets. With
 	 * only one Tx buf, the transmitter sits idle while you reload the
@@ -347,18 +334,18 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *s=
kb,
 		ei_local->tx1 =3D send_length;
 		if ((netif_msg_tx_queued(ei_local)) &&
 		    ei_local->tx2 > 0)
-			netdev_dbg(dev,
-				   "idle transmitter tx2=3D%d, lasttx=3D%d, txing=3D%d\n",
-				   ei_local->tx2, ei_local->lasttx, ei_local->txing);
+			netdev_dbg(dev, "idle transmitter tx2=3D%d, lasttx=3D%d, txing=3D%d\n"=
,
+				   ei_local->tx2, ei_local->lasttx,
+				   ei_local->txing);
 	} else if (ei_local->tx2 =3D=3D 0) {
-		output_page =3D ei_local->tx_start_page + TX_PAGES/2;
+		output_page =3D ei_local->tx_start_page + TX_PAGES / 2;
 		ei_local->tx2 =3D send_length;
 		if ((netif_msg_tx_queued(ei_local)) &&
 		    ei_local->tx1 > 0)
-			netdev_dbg(dev,
-				   "idle transmitter, tx1=3D%d, lasttx=3D%d, txing=3D%d\n",
-				   ei_local->tx1, ei_local->lasttx, ei_local->txing);
-	} else {			/* We should never get here. */
+			netdev_dbg(dev, "idle transmitter, tx1=3D%d, lasttx=3D%d, txing=3D%d\n=
",
+				   ei_local->tx1, ei_local->lasttx,
+				   ei_local->txing);
+	} else {		/* We should never get here. */
 		netif_dbg(ei_local, tx_err, dev,
 			  "No Tx buffers free! tx1=3D%d tx2=3D%d last=3D%d\n",
 			  ei_local->tx1, ei_local->tx2, ei_local->lasttx);
@@ -371,8 +358,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 		return NETDEV_TX_BUSY;
 	}

-	/*
-	 * Okay, now upload the packet and trigger a send if the transmitter
+	/* Okay, now upload the packet and trigger a send if the transmitter
 	 * isn't already sending. If it is busy, the interrupt handler will
 	 * trigger the send later, upon receiving a Tx done interrupt.
 	 */
@@ -389,8 +375,9 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 			ei_local->tx2 =3D -1;
 			ei_local->lasttx =3D -2;
 		}
-	} else
+	} else {
 		ei_local->txqueue++;
+	}

 	if (ei_local->tx1 && ei_local->tx2)
 		netif_stop_queue(dev);
@@ -410,8 +397,7 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb=
,
 	return NETDEV_TX_OK;
 }

-/**
- * ei_interrupt - handle the interrupts from an 8390
+/* ei_interrupt - handle the interrupts from an 8390
  * @irq: interrupt number
  * @dev_id: a pointer to the net_device
  *
@@ -429,15 +415,12 @@ static irqreturn_t __ei_interrupt(int irq, void *dev=
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
@@ -448,7 +431,7 @@ static irqreturn_t __ei_interrupt(int irq, void *dev_i=
d)
 	}

 	/* Change to page 0 and read the intr status reg. */
-	ei_outb_p(E8390_NODMA+E8390_PAGE0, e8390_base + E8390_CMD);
+	ei_outb_p(E8390_NODMA + E8390_PAGE0, e8390_base + E8390_CMD);
 	netif_dbg(ei_local, intr, dev, "interrupt(isr=3D%#2.2x)\n",
 		  ei_inb_p(e8390_base + EN0_ISR));

@@ -462,9 +445,9 @@ static irqreturn_t __ei_interrupt(int irq, void *dev_i=
d)
 			interrupts =3D 0;
 			break;
 		}
-		if (interrupts & ENISR_OVER)
+		if (interrupts & ENISR_OVER) {
 			ei_rx_overrun(dev);
-		else if (interrupts & (ENISR_RX+ENISR_RX_ERR)) {
+		} else if (interrupts & (ENISR_RX + ENISR_RX_ERR)) {
 			/* Got a good (?) packet. */
 			ei_receive(dev);
 		}
@@ -475,30 +458,39 @@ static irqreturn_t __ei_interrupt(int irq, void *dev=
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
@@ -514,8 +506,7 @@ static void __ei_poll(struct net_device *dev)
 }
 #endif

-/**
- * ei_tx_err - handle transmitter error
+/* ei_tx_err - handle transmitter error
  * @dev: network device which threw the exception
  *
  * A transmitter error has happened. Most likely excess collisions (which
@@ -532,30 +523,22 @@ static void ei_tx_err(struct net_device *dev)
 {
 	unsigned long e8390_base =3D dev->base_addr;
 	/* ei_local is used on some platforms via the EI_SHIFT macro */
-	struct ei_device *ei_local __maybe_unused =3D netdev_priv(dev);
-	unsigned char txsr =3D ei_inb_p(e8390_base+EN0_TSR);
-	unsigned char tx_was_aborted =3D txsr & (ENTSR_ABT+ENTSR_FU);
-
-#ifdef VERBOSE_ERROR_DUMP
-	netdev_dbg(dev, "transmitter error (%#2x):", txsr);
-	if (txsr & ENTSR_ABT)
-		pr_cont(" excess-collisions ");
-	if (txsr & ENTSR_ND)
-		pr_cont(" non-deferral ");
-	if (txsr & ENTSR_CRS)
-		pr_cont(" lost-carrier ");
-	if (txsr & ENTSR_FU)
-		pr_cont(" FIFO-underrun ");
-	if (txsr & ENTSR_CDH)
-		pr_cont(" lost-heartbeat ");
-	pr_cont("\n");
-#endif
-
+	struct ei_device *ei_local =3D netdev_priv(dev);
+	unsigned char txsr =3D ei_inb_p(e8390_base + EN0_TSR);
+	unsigned char tx_was_aborted =3D txsr & (ENTSR_ABT + ENTSR_FU);
+
+	if (netif_msg_tx_err(ei_local)) {
+		netdev_err(dev, "Transmitter error (%#2x): %s %s %s %s %s", txsr,
+			   (txsr & ENTSR_ABT) ? "excess-collisions" : "",
+			   (txsr & ENTSR_ND) ? "non-deferral" : "",
+			   (txsr & ENTSR_CRS) ? "lost-carrier" : "",
+			   (txsr & ENTSR_FU) ? "FIFO-underrun" : "",
+			   (txsr & ENTSR_CDH) ? "lost-heartbeat" : "");
+	}
 	ei_outb_p(ENISR_TX_ERR, e8390_base + EN0_ISR); /* Ack intr. */
-
-	if (tx_was_aborted)
+	if (tx_was_aborted) {
 		ei_tx_intr(dev);
-	else {
+	} else {
 		dev->stats.tx_errors++;
 		if (txsr & ENTSR_CRS)
 			dev->stats.tx_carrier_errors++;
@@ -566,8 +549,7 @@ static void ei_tx_err(struct net_device *dev)
 	}
 }

-/**
- * ei_tx_intr - transmit interrupt handler
+/* ei_tx_intr - transmit interrupt handler
  * @dev: network device for which tx intr is handled
  *
  * We have finished a transmit: check for errors and then trigger the nex=
t
@@ -582,8 +564,7 @@ static void ei_tx_intr(struct net_device *dev)

 	ei_outb_p(ENISR_TX, e8390_base + EN0_ISR); /* Ack intr. */

-	/*
-	 * There are two Tx buffers, see which one finished, and trigger
+	/* There are two Tx buffers, see which one finished, and trigger
 	 * the send of another one if it exists.
 	 */
 	ei_local->txqueue--;
@@ -595,12 +576,14 @@ static void ei_tx_intr(struct net_device *dev)
 		ei_local->tx1 =3D 0;
 		if (ei_local->tx2 > 0) {
 			ei_local->txing =3D 1;
-			NS8390_trigger_send(dev, ei_local->tx2, ei_local->tx_start_page + 6);
+			NS8390_trigger_send(dev, ei_local->tx2,
+					    ei_local->tx_start_page + 6);
 			netif_trans_update(dev);
 			ei_local->tx2 =3D -1,
 			ei_local->lasttx =3D 2;
-		} else
+		} else {
 			ei_local->lasttx =3D 20, ei_local->txing =3D 0;
+		}
 	} else if (ei_local->tx2 < 0) {
 		if (ei_local->lasttx !=3D 2  &&  ei_local->lasttx !=3D -2)
 			pr_err("%s: bogus last_tx_buffer %d, tx2=3D%d\n",
@@ -608,23 +591,27 @@ static void ei_tx_intr(struct net_device *dev)
 		ei_local->tx2 =3D 0;
 		if (ei_local->tx1 > 0) {
 			ei_local->txing =3D 1;
-			NS8390_trigger_send(dev, ei_local->tx1, ei_local->tx_start_page);
+			NS8390_trigger_send(dev, ei_local->tx1,
+					    ei_local->tx_start_page);
 			netif_trans_update(dev);
 			ei_local->tx1 =3D -1;
 			ei_local->lasttx =3D 1;
-		} else
+		} else {
 			ei_local->lasttx =3D 10, ei_local->txing =3D 0;
-	} /* else
-		netdev_warn(dev, "unexpected TX-done interrupt, lasttx=3D%d\n",
-			    ei_local->lasttx);
-*/
+		}
+	}
+	/* else {
+	 *	netdev_warn(dev, "unexpected TX-done interrupt, lasttx=3D%d\n",
+	 *		    ei_local->lasttx);
+	 * }
+	 */

 	/* Minimize Tx latency: update the statistics after we restart TXing. */
 	if (status & ENTSR_COL)
 		dev->stats.collisions++;
-	if (status & ENTSR_PTX)
+	if (status & ENTSR_PTX) {
 		dev->stats.tx_packets++;
-	else {
+	} else {
 		dev->stats.tx_errors++;
 		if (status & ENTSR_ABT) {
 			dev->stats.tx_aborted_errors++;
@@ -642,8 +629,7 @@ static void ei_tx_intr(struct net_device *dev)
 	netif_wake_queue(dev);
 }

-/**
- * ei_receive - receive some packets
+/* ei_receive - receive some packets
  * @dev: network device with which receive will be run
  *
  * We have a good packet(s), get it/them out of the buffers.
@@ -658,26 +644,29 @@ static void ei_receive(struct net_device *dev)
 	unsigned short current_offset;
 	int rx_pkt_count =3D 0;
 	struct e8390_pkt_hdr rx_frame;
-	int num_rx_pages =3D ei_local->stop_page-ei_local->rx_start_page;
+	int num_rx_pages =3D ei_local->stop_page - ei_local->rx_start_page;

 	while (++rx_pkt_count < 10) {
 		int pkt_len, pkt_stat;

 		/* Get the rx page (incoming packet pointer). */
-		ei_outb_p(E8390_NODMA+E8390_PAGE1, e8390_base + E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE1, e8390_base + E8390_CMD);
 		rxing_page =3D ei_inb_p(e8390_base + EN1_CURPAG);
-		ei_outb_p(E8390_NODMA+E8390_PAGE0, e8390_base + E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE0, e8390_base + E8390_CMD);

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
@@ -695,17 +684,19 @@ static void ei_receive(struct net_device *dev)
 		pkt_len =3D rx_frame.count - sizeof(struct e8390_pkt_hdr);
 		pkt_stat =3D rx_frame.status;

-		next_frame =3D this_frame + 1 + ((pkt_len+4)>>8);
+		next_frame =3D this_frame + 1 + ((pkt_len + 4) >> 8);

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
@@ -721,24 +712,22 @@ static void ei_receive(struct net_device *dev)
 			struct sk_buff *skb;

 			skb =3D netdev_alloc_skb(dev, pkt_len + 2);
-			if (skb =3D=3D NULL) {
-				netif_err(ei_local, rx_err, dev,
-					  "Couldn't allocate a sk_buff of size %d\n",
-					  pkt_len);
+			if (!skb) {
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
@@ -751,23 +740,25 @@ static void ei_receive(struct net_device *dev)
 		}
 		next_frame =3D rx_frame.next;

-		/* This _should_ never happen: it's here for avoiding bad clones. */
+		/* This _should_ never happen:
+		 * it's here for avoiding bad clones.
+		 */
 		if (next_frame >=3D ei_local->stop_page) {
 			netdev_notice(dev, "next frame inconsistency, %#2x\n",
 				      next_frame);
 			next_frame =3D ei_local->rx_start_page;
 		}
 		ei_local->current_page =3D next_frame;
-		ei_outb_p(next_frame-1, e8390_base+EN0_BOUNDARY);
+		ei_outb_p(next_frame - 1, e8390_base + EN0_BOUNDARY);
 	}

 	/* We used to also ack ENISR_OVER here, but that would sometimes mask
-	   a real overrun, leaving the 8390 in a stopped state with rec'vr off. =
*/
-	ei_outb_p(ENISR_RX+ENISR_RX_ERR, e8390_base+EN0_ISR);
+	 * a real overrun, leaving the 8390 in a stopped state with rec'vr off.
+	 */
+	ei_outb_p(ENISR_RX + ENISR_RX_ERR, e8390_base + EN0_ISR);
 }

-/**
- * ei_rx_overrun - handle receiver overrun
+/* ei_rx_overrun - handle receiver overrun
  * @dev: network device which threw exception
  *
  * We have a receiver overrun: we have to kick the 8390 to get it started
@@ -786,18 +777,16 @@ static void ei_rx_overrun(struct net_device *dev)
 	/* ei_local is used on some platforms via the EI_SHIFT macro */
 	struct ei_device *ei_local __maybe_unused =3D netdev_priv(dev);

-	/*
-	 * Record whether a Tx was in progress and then issue the
+	/* Record whether a Tx was in progress and then issue the
 	 * stop command.
 	 */
-	was_txing =3D ei_inb_p(e8390_base+E8390_CMD) & E8390_TRANS;
-	ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_STOP, e8390_base+E8390_CMD);
+	was_txing =3D ei_inb_p(e8390_base + E8390_CMD) & E8390_TRANS;
+	ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_STOP, e8390_base + E8390_CMD=
);

 	netif_dbg(ei_local, rx_err, dev, "Receiver overrun\n");
 	dev->stats.rx_over_errors++;

-	/*
-	 * Wait a full Tx time (1.2ms) + some guard time, NS says 1.6ms total.
+	/* Wait a full Tx time (1.2ms) + some guard time, NS says 1.6ms total.
 	 * Early datasheets said to poll the reset bit, but now they say that
 	 * it "is not a reliable indicator and subsequently should be ignored."
 	 * We wait at least 10ms.
@@ -805,47 +794,44 @@ static void ei_rx_overrun(struct net_device *dev)

 	mdelay(10);

-	/*
-	 * Reset RBCR[01] back to zero as per magic incantation.
-	 */
-	ei_outb_p(0x00, e8390_base+EN0_RCNTLO);
-	ei_outb_p(0x00, e8390_base+EN0_RCNTHI);
+	/* Reset RBCR[01] back to zero as per magic incantation. */
+	ei_outb_p(0x00, e8390_base + EN0_RCNTLO);
+	ei_outb_p(0x00, e8390_base + EN0_RCNTHI);

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
-	ei_outb_p(ENISR_OVER, e8390_base+EN0_ISR);
+	ei_outb_p(ENISR_OVER, e8390_base + EN0_ISR);
+
+	/* Leave loopback mode, and resend any packet that got stopped */

-	/*
-	 * Leave loopback mode, and resend any packet that got stopped.
-	 */
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
@@ -867,8 +853,7 @@ static struct net_device_stats *__ei_get_stats(struct =
net_device *dev)
 	return &dev->stats;
 }

-/*
- * Form the 64 bit 8390 multicast table from the linked list of addresses
+/* Form the 64 bit 8390 multicast table from the linked list of addresses
  * associated with this dev structure.
  */

@@ -878,16 +863,14 @@ static inline void make_mc_bits(u8 *bits, struct net=
_device *dev)

 	netdev_for_each_mc_addr(ha, dev) {
 		u32 crc =3D ether_crc(ETH_ALEN, ha->addr);
-		/*
-		 * The 8390 uses the 6 most significant bits of the
+		/* The 8390 uses the 6 most significant bits of the
 		 * CRC to index the multicast table.
 		 */
-		bits[crc>>29] |=3D (1<<((crc>>26)&7));
+		bits[crc >> 29] |=3D (1 << ((crc >> 26) & 7));
 	}
 }

-/**
- * do_set_multicast_list - set/clear multicast filter
+/* do_set_multicast_list - set/clear multicast filter
  * @dev: net device for which multicast filter is adjusted
  *
  *	Set or clear the multicast filter for this adaptor. May be called
@@ -900,15 +883,16 @@ static void do_set_multicast_list(struct net_device =
*dev)
 	int i;
 	struct ei_device *ei_local =3D netdev_priv(dev);

-	if (!(dev->flags&(IFF_PROMISC|IFF_ALLMULTI))) {
+	if (!(dev->flags & (IFF_PROMISC | IFF_ALLMULTI))) {
 		memset(ei_local->mcfilter, 0, 8);
 		if (!netdev_mc_empty(dev))
 			make_mc_bits(ei_local->mcfilter, dev);
-	} else
-		memset(ei_local->mcfilter, 0xFF, 8);	/* mcast set to accept-all */
+	} else {
+		/* mcast set to accept-all */
+		memset(ei_local->mcfilter, 0xFF, 8);
+	}

-	/*
-	 * DP8390 manuals don't specify any magic sequence for altering
+	/* DP8390 manuals don't specify any magic sequence for altering
 	 * the multicast regs on an already running card. To be safe, we
 	 * ensure multicast mode is off prior to loading up the new hash
 	 * table. If this proves to be not enough, we can always resort
@@ -924,16 +908,17 @@ static void do_set_multicast_list(struct net_device =
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

-	if (dev->flags&IFF_PROMISC)
+	if (dev->flags & IFF_PROMISC)
 		ei_outb_p(E8390_RXCONFIG | 0x18, e8390_base + EN0_RXCR);
 	else if (dev->flags & IFF_ALLMULTI || !netdev_mc_empty(dev))
 		ei_outb_p(E8390_RXCONFIG | 0x08, e8390_base + EN0_RXCR);
@@ -941,10 +926,9 @@ static void do_set_multicast_list(struct net_device *=
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
@@ -969,9 +953,6 @@ static void ethdev_setup(struct net_device *dev)
 {
 	struct ei_device *ei_local =3D netdev_priv(dev);

-	if ((msg_enable & NETIF_MSG_DRV) && (version_printed++ =3D=3D 0))
-		pr_info("%s", version);
-
 	ether_setup(dev);

 	spin_lock_init(&ei_local->page_lock);
@@ -991,14 +972,10 @@ static struct net_device *____alloc_ei_netdev(int si=
ze)
 			    NET_NAME_UNKNOWN, ethdev_setup);
 }

-
-
-
 /* This page of functions should be 8390 generic */
 /* Follow National Semi's recommendations for initializing the "NIC". */

-/**
- * NS8390_init - initialize 8390 hardware
+/* NS8390_init - initialize 8390 hardware
  * @dev: network device to initialize
  * @startp: boolean.  non-zero value to initiate chip processing
  *
@@ -1017,7 +994,8 @@ static void __NS8390_init(struct net_device *dev, int=
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
@@ -1027,10 +1005,13 @@ static void __NS8390_init(struct net_device *dev, =
int startp)
 	ei_outb_p(E8390_TXOFF, e8390_base + EN0_TXCR); /* 0x02 */
 	/* Set the transmit page and receive ring. */
 	ei_outb_p(ei_local->tx_start_page, e8390_base + EN0_TPSR);
-	ei_local->tx1 =3D ei_local->tx2 =3D 0;
+	ei_local->tx1 =3D 0;
+	ei_local->tx2 =3D 0;
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
@@ -1038,25 +1019,28 @@ static void __NS8390_init(struct net_device *dev, =
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

 	ei_outb_p(ei_local->rx_start_page, e8390_base + EN1_CURPAG);
-	ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_STOP, e8390_base+E8390_CMD);
+	ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_STOP, e8390_base + E8390_CMD=
);

-	ei_local->tx1 =3D ei_local->tx2 =3D 0;
+	ei_local->tx1 =3D 0;
+	ei_local->tx2 =3D 0;
 	ei_local->txing =3D 0;

 	if (startp) {
 		ei_outb_p(0xff,  e8390_base + EN0_ISR);
 		ei_outb_p(ENISR_ALL,  e8390_base + EN0_IMR);
-		ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_START, e8390_base+E8390_CMD);
+		ei_outb_p(E8390_NODMA + E8390_PAGE0 + E8390_START,
+			  e8390_base + E8390_CMD);
 		ei_outb_p(E8390_TXCONFIG, e8390_base + EN0_TXCR); /* xmit on. */
 		/* 3c503 TechMan says rxconfig only after the NIC is started. */
 		ei_outb_p(E8390_RXCONFIG, e8390_base + EN0_RXCR); /* rx on,  */
@@ -1065,15 +1049,16 @@ static void __NS8390_init(struct net_device *dev, =
int startp)
 }

 /* Trigger a transmit start, assuming the length is valid.
-   Always called with the page lock held */
+ * Always called with the page lock held.
+ */

 static void NS8390_trigger_send(struct net_device *dev, unsigned int leng=
th,
-								int start_page)
+				int start_page)
 {
 	unsigned long e8390_base =3D dev->base_addr;
 	struct ei_device *ei_local __attribute((unused)) =3D netdev_priv(dev);

-	ei_outb_p(E8390_NODMA+E8390_PAGE0, e8390_base+E8390_CMD);
+	ei_outb_p(E8390_NODMA + E8390_PAGE0, e8390_base + E8390_CMD);

 	if (ei_inb_p(e8390_base + E8390_CMD) & E8390_TRANS) {
 		netdev_warn(dev, "trigger_send() called with the transmitter busy\n");
@@ -1082,5 +1067,5 @@ static void NS8390_trigger_send(struct net_device *d=
ev, unsigned int length,
 	ei_outb_p(length & 0xff, e8390_base + EN0_TCNTLO);
 	ei_outb_p(length >> 8, e8390_base + EN0_TCNTHI);
 	ei_outb_p(start_page, e8390_base + EN0_TPSR);
-	ei_outb_p(E8390_NODMA+E8390_TRANS+E8390_START, e8390_base+E8390_CMD);
+	ei_outb_p(E8390_NODMA + E8390_TRANS + E8390_START, e8390_base + E8390_CM=
D);
 }
=2D-
2.20.1

