Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4713C3886BB
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345536AbhESFjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:39:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4672 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242767AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlM1f31Ywz1BP5P;
        Wed, 19 May 2021 13:31:50 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:35 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>
Subject: [PATCH 07/20] net: dec: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:40 +0800
Message-ID: <1621402253-27200-8-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 drivers/net/ethernet/dec/tulip/de2104x.c     |  4 ++--
 drivers/net/ethernet/dec/tulip/de4x5.c       |  6 +++---
 drivers/net/ethernet/dec/tulip/dmfe.c        | 18 +++++++++---------
 drivers/net/ethernet/dec/tulip/pnic2.c       |  4 ++--
 drivers/net/ethernet/dec/tulip/uli526x.c     | 10 +++++-----
 drivers/net/ethernet/dec/tulip/winbond-840.c |  4 ++--
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index b018195..117c26f 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -832,8 +832,8 @@ static struct net_device_stats *de_get_stats(struct net_device *dev)
 
 	/* The chip only need report frame silently dropped. */
 	spin_lock_irq(&de->lock);
- 	if (netif_running(dev) && netif_device_present(dev))
- 		__de_get_stats(de);
+	if (netif_running(dev) && netif_device_present(dev))
+		__de_get_stats(de);
 	spin_unlock_irq(&de->lock);
 
 	return &dev->stats;
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 683e328..b125d7f 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -396,7 +396,7 @@
 			   <earl@exis.net>.
 			  Updated the PCI interface to conform with the latest
 			   version. I hope nothing is broken...
-          		  Add TX done interrupt modification from suggestion
+			  Add TX done interrupt modification from suggestion
 			   by <Austin.Donnelly@cl.cam.ac.uk>.
 			  Fix is_anc_capable() bug reported by
 			   <Austin.Donnelly@cl.cam.ac.uk>.
@@ -1499,7 +1499,7 @@ de4x5_queue_pkt(struct sk_buff *skb, struct net_device *dev)
 	    spin_lock_irqsave(&lp->lock, flags);
 	    netif_stop_queue(dev);
 	    load_packet(dev, skb->data, TD_IC | TD_LS | TD_FS | skb->len, skb);
- 	    lp->stats.tx_bytes += skb->len;
+	    lp->stats.tx_bytes += skb->len;
 	    outl(POLL_DEMAND, DE4X5_TPD);/* Start the TX */
 
 	    lp->tx_new = (lp->tx_new + 1) % lp->txRingSize;
@@ -1651,7 +1651,7 @@ de4x5_rx(struct net_device *dev)
 
 		    /* Update stats */
 		    lp->stats.rx_packets++;
- 		    lp->stats.rx_bytes += pkt_len;
+		    lp->stats.rx_bytes += pkt_len;
 		}
 	    }
 
diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index 87a27fe..c763b69 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -518,7 +518,7 @@ static void dmfe_remove_one(struct pci_dev *pdev)
 
 	DMFE_DBUG(0, "dmfe_remove_one()", 0);
 
- 	if (dev) {
+	if (dev) {
 
 		unregister_netdev(dev);
 		pci_iounmap(db->pdev, db->ioaddr);
@@ -567,10 +567,10 @@ static int dmfe_open(struct net_device *dev)
 	/* CR6 operation mode decision */
 	if ( !chkmode || (db->chip_id == PCI_DM9132_ID) ||
 		(db->chip_revision >= 0x30) ) {
-    		db->cr6_data |= DMFE_TXTH_256;
+		db->cr6_data |= DMFE_TXTH_256;
 		db->cr0_data = CR0_DEFAULT;
 		db->dm910x_chk_mode=4;		/* Enter the normal mode */
- 	} else {
+	} else {
 		db->cr6_data |= CR6_SFT;	/* Store & Forward mode */
 		db->cr0_data = 0;
 		db->dm910x_chk_mode = 1;	/* Enter the check mode */
@@ -903,7 +903,7 @@ static void dmfe_free_tx_pkt(struct net_device *dev, struct dmfe_board_info *db)
 			}
 		}
 
-    		txptr = txptr->next_tx_desc;
+		txptr = txptr->next_tx_desc;
 	}/* End of while */
 
 	/* Update TX remove pointer to next */
@@ -1121,7 +1121,7 @@ static void dmfe_timer(struct timer_list *t)
 	void __iomem *ioaddr = db->ioaddr;
 	u32 tmp_cr8;
 	unsigned char tmp_cr12;
- 	unsigned long flags;
+	unsigned long flags;
 
 	int link_ok, link_ok_phy;
 
@@ -1217,7 +1217,7 @@ static void dmfe_timer(struct timer_list *t)
 	if (link_ok_phy != link_ok) {
 		DMFE_DBUG (0, "PHY and chip report different link status", 0);
 		link_ok = link_ok | link_ok_phy;
- 	}
+	}
 
 	if ( !link_ok && netif_carrier_ok(dev)) {
 		/* Link Failed */
@@ -1699,14 +1699,14 @@ static void dmfe_set_phyxcer(struct dmfe_board_info *db)
 		if (db->chip_id == PCI_DM9009_ID) phy_reg &= 0x61;
 	}
 
-  	/* Write new capability to Phyxcer Reg4 */
+	/* Write new capability to Phyxcer Reg4 */
 	if ( !(phy_reg & 0x01e0)) {
 		phy_reg|=db->PHY_reg4;
 		db->media_mode|=DMFE_AUTO;
 	}
 	dmfe_phy_write(db->ioaddr, db->phy_addr, 4, phy_reg, db->chip_id);
 
- 	/* Restart Auto-Negotiation */
+	/* Restart Auto-Negotiation */
 	if ( db->chip_type && (db->chip_id == PCI_DM9102_ID) )
 		dmfe_phy_write(db->ioaddr, db->phy_addr, 0, 0x1800, db->chip_id);
 	if ( !db->chip_type )
@@ -1754,7 +1754,7 @@ static void dmfe_process_mode(struct dmfe_board_info *db)
 			}
 			dmfe_phy_write(db->ioaddr,
 				       db->phy_addr, 0, phy_reg, db->chip_id);
-       			if ( db->chip_type && (db->chip_id == PCI_DM9102_ID) )
+			if ( db->chip_type && (db->chip_id == PCI_DM9102_ID) )
 				mdelay(20);
 			dmfe_phy_write(db->ioaddr,
 				       db->phy_addr, 0, phy_reg, db->chip_id);
diff --git a/drivers/net/ethernet/dec/tulip/pnic2.c b/drivers/net/ethernet/dec/tulip/pnic2.c
index 412adaa..72a0915 100644
--- a/drivers/net/ethernet/dec/tulip/pnic2.c
+++ b/drivers/net/ethernet/dec/tulip/pnic2.c
@@ -351,7 +351,7 @@ void pnic2_lnk_change(struct net_device *dev, int csr5)
 			del_timer_sync(&tp->timer);
 			pnic2_start_nway(dev);
 			tp->timer.expires = RUN_AT(3*HZ);
-       			add_timer(&tp->timer);
+			add_timer(&tp->timer);
                 }
 
                 return;
@@ -375,7 +375,7 @@ void pnic2_lnk_change(struct net_device *dev, int csr5)
 			del_timer_sync(&tp->timer);
 			pnic2_start_nway(dev);
 			tp->timer.expires = RUN_AT(3*HZ);
-       			add_timer(&tp->timer);
+			add_timer(&tp->timer);
                 }
 
                 return;
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index 13e73ed..d67ef7d 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -780,7 +780,7 @@ static void uli526x_free_tx_pkt(struct net_device *dev,
 			}
 		}
 
-    		txptr = txptr->next_tx_desc;
+		txptr = txptr->next_tx_desc;
 	}/* End of while */
 
 	/* Update TX remove pointer to next */
@@ -1015,7 +1015,7 @@ static void uli526x_timer(struct timer_list *t)
 	struct net_device *dev = pci_get_drvdata(db->pdev);
 	struct uli_phy_ops *phy = &db->phy;
 	void __iomem *ioaddr = db->ioaddr;
- 	unsigned long flags;
+	unsigned long flags;
 	u8 tmp_cr12 = 0;
 	u32 tmp_cr8;
 
@@ -1535,14 +1535,14 @@ static void uli526x_set_phyxcer(struct uli526x_board_info *db)
 
 	}
 
-  	/* Write new capability to Phyxcer Reg4 */
+	/* Write new capability to Phyxcer Reg4 */
 	if ( !(phy_reg & 0x01e0)) {
 		phy_reg|=db->PHY_reg4;
 		db->media_mode|=ULI526X_AUTO;
 	}
 	phy->write(db, db->phy_addr, 4, phy_reg);
 
- 	/* Restart Auto-Negotiation */
+	/* Restart Auto-Negotiation */
 	phy->write(db, db->phy_addr, 0, 0x1200);
 	udelay(50);
 }
@@ -1550,7 +1550,7 @@ static void uli526x_set_phyxcer(struct uli526x_board_info *db)
 
 /*
  *	Process op-mode
- 	AUTO mode : PHY controller in Auto-negotiation Mode
+	AUTO mode : PHY controller in Auto-negotiation Mode
  *	Force mode: PHY controller in force mode with HUB
  *			N-way force capability with SWITCH
  */
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 514df17..f6ff1f7 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -36,7 +36,7 @@
 		power management.
 		support for big endian descriptors
 			Copyright (C) 2001 Manfred Spraul
-  	* ethtool support (jgarzik)
+	* ethtool support (jgarzik)
 	* Replace some MII-related magic numbers with constants (jgarzik)
 
 	TODO:
@@ -1479,7 +1479,7 @@ static int netdev_close(struct net_device *dev)
 			   np->cur_rx, np->dirty_rx);
 	}
 
- 	/* Stop the chip's Tx and Rx processes. */
+	/* Stop the chip's Tx and Rx processes. */
 	spin_lock_irq(&np->lock);
 	netif_device_detach(dev);
 	update_csr6(dev, 0);
-- 
2.8.1

