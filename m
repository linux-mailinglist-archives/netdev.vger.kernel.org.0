Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0438863F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 06:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbhESE75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 00:59:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4740 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhESE74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 00:59:56 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlLCF0KDwzpdt1;
        Wed, 19 May 2021 12:55:05 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 12:58:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 12:58:33 +0800
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
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Lee Jones <lee.jones@linaro.org>,
        "Joe Perches" <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yixing Liu <liuyixing1@huawei.com>,
        "Weihang Li" <liweihang@huawei.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Kerr <jk@ozlabs.org>, Moritz Fischer <mdf@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Edward Cree <ecree@solarflare.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Colin Ian King <colin.king@canonical.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Wang Hai <wanghai38@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>, Chao Yu <chao@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        "Gaurav Singh" <gaurav1086@gmail.com>, <linux-acenic@sunsite.dk>,
        <linux-parisc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 04/20] net: apple: remove leading spaces before tabs
Date:   Wed, 19 May 2021 12:45:29 +0800
Message-ID: <1621399671-15517-5-git-send-email-tanghui20@huawei.com>
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
 drivers/net/ethernet/apple/bmac.c | 30 +++++++++++++++---------------
 drivers/net/ethernet/apple/mace.c |  8 ++++----
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index 1e4e402..a989d2d 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -477,26 +477,26 @@ static int bmac_suspend(struct macio_dev *mdev, pm_message_t state)
 		config = bmread(dev, RXCFG);
 		bmwrite(dev, RXCFG, (config & ~RxMACEnable));
 		config = bmread(dev, TXCFG);
-       		bmwrite(dev, TXCFG, (config & ~TxMACEnable));
+		bmwrite(dev, TXCFG, (config & ~TxMACEnable));
 		bmwrite(dev, INTDISABLE, DisableAll); /* disable all intrs */
-       		/* disable rx and tx dma */
+		/* disable rx and tx dma */
 		rd->control = cpu_to_le32(DBDMA_CLEAR(RUN|PAUSE|FLUSH|WAKE));	/* clear run bit */
 		td->control = cpu_to_le32(DBDMA_CLEAR(RUN|PAUSE|FLUSH|WAKE));	/* clear run bit */
-       		/* free some skb's */
-       		for (i=0; i<N_RX_RING; i++) {
-       			if (bp->rx_bufs[i] != NULL) {
-       				dev_kfree_skb(bp->rx_bufs[i]);
-       				bp->rx_bufs[i] = NULL;
-       			}
-       		}
-       		for (i = 0; i<N_TX_RING; i++) {
+		/* free some skb's */
+		for (i=0; i<N_RX_RING; i++) {
+			if (bp->rx_bufs[i] != NULL) {
+				dev_kfree_skb(bp->rx_bufs[i]);
+				bp->rx_bufs[i] = NULL;
+			}
+		}
+		for (i = 0; i<N_TX_RING; i++) {
 			if (bp->tx_bufs[i] != NULL) {
 		       		dev_kfree_skb(bp->tx_bufs[i]);
 	       			bp->tx_bufs[i] = NULL;
 		       	}
 		}
 	}
-       	pmac_call_feature(PMAC_FTR_BMAC_ENABLE, macio_get_of_node(bp->mdev), 0, 0);
+	pmac_call_feature(PMAC_FTR_BMAC_ENABLE, macio_get_of_node(bp->mdev), 0, 0);
 	return 0;
 }
 
@@ -510,9 +510,9 @@ static int bmac_resume(struct macio_dev *mdev)
 		bmac_reset_and_enable(dev);
 
 	enable_irq(dev->irq);
-       	enable_irq(bp->tx_dma_intr);
-       	enable_irq(bp->rx_dma_intr);
-       	netif_device_attach(dev);
+	enable_irq(bp->tx_dma_intr);
+	enable_irq(bp->rx_dma_intr);
+	netif_device_attach(dev);
 
 	return 0;
 }
@@ -1599,7 +1599,7 @@ static int bmac_remove(struct macio_dev *mdev)
 
 	unregister_netdev(dev);
 
-       	free_irq(dev->irq, dev);
+	free_irq(dev->irq, dev);
 	free_irq(bp->tx_dma_intr, dev);
 	free_irq(bp->rx_dma_intr, dev);
 
diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index 9e5006e..4b80e3a 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -364,9 +364,9 @@ static void mace_reset(struct net_device *dev)
 	out_8(&mb->iac, 0);
 
     if (mp->port_aaui)
-    	out_8(&mb->plscc, PORTSEL_AUI + ENPLSIO);
+	out_8(&mb->plscc, PORTSEL_AUI + ENPLSIO);
     else
-    	out_8(&mb->plscc, PORTSEL_GPSI + ENPLSIO);
+	out_8(&mb->plscc, PORTSEL_GPSI + ENPLSIO);
 }
 
 static void __mace_set_address(struct net_device *dev, void *addr)
@@ -378,9 +378,9 @@ static void __mace_set_address(struct net_device *dev, void *addr)
 
     /* load up the hardware address */
     if (mp->chipid == BROKEN_ADDRCHG_REV)
-    	out_8(&mb->iac, PHYADDR);
+	out_8(&mb->iac, PHYADDR);
     else {
-    	out_8(&mb->iac, ADDRCHG | PHYADDR);
+	out_8(&mb->iac, ADDRCHG | PHYADDR);
 	while ((in_8(&mb->iac) & ADDRCHG) != 0)
 	    ;
     }
-- 
2.8.1

