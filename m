Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BF3388639
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 06:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbhESE6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 00:58:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4667 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhESE6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 00:58:11 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlLB270Flz1BP1l;
        Wed, 19 May 2021 12:54:02 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 12:56:48 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 12:56:48 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Steffen Klassert <klassert@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "Rasesh Mody" <rmody@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniele Venzano <venza@brownhat.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Shannon Nelson <snelson@pensando.io>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "Joe Perches" <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Weihang Li <liweihang@huawei.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeremy Kerr <jk@ozlabs.org>, Moritz Fischer <mdf@kernel.org>,
        Lucy Yan <lucyyan@google.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Edward Cree <ecree@solarflare.com>,
        "Zheng Yongjun" <zhengyongjun3@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Allen Pais <apais@linux.microsoft.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Wang Hai <wanghai38@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Qiushi Wu <wu000273@umn.edu>,
        Kees Cook <keescook@chromium.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Gaurav Singh <gaurav1086@gmail.com>, <linux-acenic@sunsite.dk>,
        <linux-parisc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 03/20] net: amd: remove leading spaces before tabs
Date:   Wed, 19 May 2021 12:45:28 +0800
Message-ID: <1621399671-15517-4-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
References: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/amd/amd8111e.c   |  4 ++--
 drivers/net/ethernet/amd/amd8111e.h   |  6 +++---
 drivers/net/ethernet/amd/atarilance.c |  2 +-
 drivers/net/ethernet/amd/declance.c   |  2 +-
 drivers/net/ethernet/amd/lance.c      |  4 ++--
 drivers/net/ethernet/amd/ni65.c       | 12 ++++++------
 drivers/net/ethernet/amd/nmclan_cs.c  | 12 ++++++------
 drivers/net/ethernet/amd/sun3lance.c  | 12 ++++++------
 8 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 4a1220c..9cac5aa 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -19,14 +19,14 @@ Module Name:
 
 Abstract:
 
- 	 AMD8111 based 10/100 Ethernet Controller Driver.
+	 AMD8111 based 10/100 Ethernet Controller Driver.
 
 Environment:
 
 	Kernel Mode
 
 Revision History:
- 	3.0.0
+	3.0.0
 	   Initial Revision.
 	3.0.1
 	 1. Dynamic interrupt coalescing.
diff --git a/drivers/net/ethernet/amd/amd8111e.h b/drivers/net/ethernet/amd/amd8111e.h
index 493f154..37da79d 100644
--- a/drivers/net/ethernet/amd/amd8111e.h
+++ b/drivers/net/ethernet/amd/amd8111e.h
@@ -10,14 +10,14 @@ Module Name:
 
 Abstract:
 
- 	 AMD8111 based 10/100 Ethernet Controller driver definitions.
+	 AMD8111 based 10/100 Ethernet Controller driver definitions.
 
 Environment:
 
 	Kernel Mode
 
 Revision History:
- 	3.0.0
+	3.0.0
 	   Initial Revision.
 	3.0.1
 */
@@ -692,7 +692,7 @@ enum coal_type{
 };
 
 enum coal_mode{
-       	RX_INTR_COAL,
+	RX_INTR_COAL,
 	TX_INTR_COAL,
 	DISABLE_COAL,
 	ENABLE_COAL,
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index c1eab91..36f54d13 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -706,7 +706,7 @@ static void lance_init_ring( struct net_device *dev )
 		CHECK_OFFSET(offset);
 		MEM->tx_head[i].base = offset;
 		MEM->tx_head[i].flag = TMD1_OWN_HOST;
- 		MEM->tx_head[i].base_hi = 0;
+		MEM->tx_head[i].base_hi = 0;
 		MEM->tx_head[i].length = 0;
 		MEM->tx_head[i].misc = 0;
 		offset += PKT_BUF_SZ;
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 7282ce5..493b0ce 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -937,7 +937,7 @@ static netdev_tx_t lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dev_kfree_skb(skb);
 
- 	return NETDEV_TX_OK;
+	return NETDEV_TX_OK;
 }
 
 static void lance_load_multicast(struct net_device *dev)
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index aff4424..2178e6b 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -780,7 +780,7 @@ lance_open(struct net_device *dev)
 		outw(0x0002, ioaddr+LANCE_ADDR);
 		/* Only touch autoselect bit. */
 		outw(inw(ioaddr+LANCE_BUS_IF) | 0x0002, ioaddr+LANCE_BUS_IF);
- 	}
+	}
 
 	if (lance_debug > 1)
 		printk("%s: lance_open() irq %d dma %d tx/rx rings %#x/%#x init %#x.\n",
@@ -812,7 +812,7 @@ lance_open(struct net_device *dev)
 	 * We used to clear the InitDone bit, 0x0100, here but Mark Stockton
 	 * reports that doing so triggers a bug in the '974.
 	 */
- 	outw(0x0042, ioaddr+LANCE_DATA);
+	outw(0x0042, ioaddr+LANCE_DATA);
 
 	if (lance_debug > 2)
 		printk("%s: LANCE open after %d ticks, init block %#x csr0 %4.4x.\n",
diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index c38edf6..5c1cfb0 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -193,7 +193,7 @@ static struct card {
 		.vendor_id   = ni_vendor,
 		.cardname    = "ni6510",
 		.config	     = 0x1,
-       	},
+	},
 	{
 		.id0	     = NI65_EB_ID0,
 		.id1	     = NI65_EB_ID1,
@@ -204,7 +204,7 @@ static struct card {
 		.vendor_id   = ni_vendor,
 		.cardname    = "ni6510 EtherBlaster",
 		.config	     = 0x2,
-       	},
+	},
 	{
 		.id0	     = NE2100_ID0,
 		.id1	     = NE2100_ID1,
@@ -1232,15 +1232,15 @@ MODULE_PARM_DESC(dma, "ni6510 ISA DMA channel (ignored for some cards)");
 
 int __init init_module(void)
 {
- 	dev_ni65 = ni65_probe(-1);
+	dev_ni65 = ni65_probe(-1);
 	return PTR_ERR_OR_ZERO(dev_ni65);
 }
 
 void __exit cleanup_module(void)
 {
- 	unregister_netdev(dev_ni65);
- 	cleanup_card(dev_ni65);
- 	free_netdev(dev_ni65);
+	unregister_netdev(dev_ni65);
+	cleanup_card(dev_ni65);
+	free_netdev(dev_ni65);
 }
 #endif /* MODULE */
 
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 11c0b13..4019cab 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -541,7 +541,7 @@ static int mace_init(mace_private *lp, unsigned int ioaddr, char *enet_addr)
     if(++ct > 500)
     {
 	pr_err("reset failed, card removed?\n");
-    	return -1;
+	return -1;
     }
     udelay(1);
   }
@@ -585,11 +585,11 @@ static int mace_init(mace_private *lp, unsigned int ioaddr, char *enet_addr)
   ct = 0;
   while (mace_read(lp, ioaddr, MACE_IAC) & MACE_IAC_ADDRCHG)
   {
-  	if(++ ct > 500)
-  	{
+	if(++ ct > 500)
+	{
 		pr_err("ADDRCHG timeout, card removed?\n");
-  		return -1;
-  	}
+		return -1;
+	}
   }
   /* Set PADR register */
   for (i = 0; i < ETH_ALEN; i++)
@@ -655,7 +655,7 @@ static int nmclan_config(struct pcmcia_device *link)
   }
 
   if(mace_init(lp, ioaddr, dev->dev_addr) == -1)
-  	goto failed;
+	goto failed;
 
   /* The if_port symbol can be set when the module is loaded */
   if (if_port <= 2)
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 00ae108..f8d7a93 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -150,7 +150,7 @@ struct lance_memory {
 struct lance_private {
 	volatile unsigned short	*iobase;
 	struct lance_memory	*mem;
-     	int new_rx, new_tx;	/* The next free ring entry */
+	int new_rx, new_tx;	/* The next free ring entry */
 	int old_tx, old_rx;     /* ring entry to be processed */
 /* These two must be longs for set_bit() */
 	long	    tx_full;
@@ -465,7 +465,7 @@ static void lance_init_ring( struct net_device *dev )
 	for( i = 0; i < TX_RING_SIZE; i++ ) {
 		MEM->tx_head[i].base = dvma_vtob(MEM->tx_data[i]);
 		MEM->tx_head[i].flag = 0;
- 		MEM->tx_head[i].base_hi =
+		MEM->tx_head[i].base_hi =
 			(dvma_vtob(MEM->tx_data[i])) >>16;
 		MEM->tx_head[i].length = 0;
 		MEM->tx_head[i].misc = 0;
@@ -581,8 +581,8 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	AREG = CSR0;
-  	DPRINTK( 2, ( "%s: lance_start_xmit() called, csr0 %4.4x.\n",
-  				  dev->name, DREG ));
+	DPRINTK( 2, ( "%s: lance_start_xmit() called, csr0 %4.4x.\n",
+				  dev->name, DREG ));
 
 #ifdef CONFIG_SUN3X
 	/* this weirdness doesn't appear on sun3... */
@@ -636,8 +636,8 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Trigger an immediate send poll. */
 	REGA(CSR0) = CSR0_INEA | CSR0_TDMD | CSR0_STRT;
 	AREG = CSR0;
-  	DPRINTK( 2, ( "%s: lance_start_xmit() exiting, csr0 %4.4x.\n",
-  				  dev->name, DREG ));
+	DPRINTK( 2, ( "%s: lance_start_xmit() exiting, csr0 %4.4x.\n",
+				  dev->name, DREG ));
 	dev_kfree_skb(skb);
 
 	lp->lock = 0;
-- 
2.8.1

