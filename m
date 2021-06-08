Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A1139F098
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhFHISJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:09 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8083 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhFHIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzjfR2dLTzYrxT;
        Tue,  8 Jun 2021 16:13:03 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 11/16] net: farsync: remove redundant braces {}
Date:   Tue, 8 Jun 2021 16:12:37 +0800
Message-ID: <1623139962-34847-12-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes redundant braces {}, to fix the
checkpatch.pl warning:
"braces {} are not necessary for single statement blocks".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 86 +++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 8f39be4..8b96f35 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -739,11 +739,10 @@ fst_clear_intr(struct fst_card_info *card)
 static inline void
 fst_enable_intr(struct fst_card_info *card)
 {
-	if (card->family == FST_FAMILY_TXU) {
+	if (card->family == FST_FAMILY_TXU)
 		outl(0x0f0c0900, card->pci_conf + INTCSR_9054);
-	} else {
+	else
 		outw(0x0543, card->pci_conf + INTCSR_9052);
-	}
 }
 
 /*      Disable card interrupts
@@ -751,11 +750,10 @@ fst_enable_intr(struct fst_card_info *card)
 static inline void
 fst_disable_intr(struct fst_card_info *card)
 {
-	if (card->family == FST_FAMILY_TXU) {
+	if (card->family == FST_FAMILY_TXU)
 		outl(0x00000000, card->pci_conf + INTCSR_9054);
-	} else {
+	else
 		outw(0x0000, card->pci_conf + INTCSR_9052);
-	}
 }
 
 /*      Process the result of trying to pass a received frame up the stack
@@ -863,9 +861,8 @@ fst_rx_dma(struct fst_card_info *card, dma_addr_t dma, u32 mem, int len)
 	 */
 
 	dbg(DBG_RX, "In fst_rx_dma %x %x %d\n", (u32)dma, mem, len);
-	if (card->dmarx_in_progress) {
+	if (card->dmarx_in_progress)
 		dbg(DBG_ASS, "In fst_rx_dma while dma in progress\n");
-	}
 
 	outl(dma, card->pci_conf + DMAPADR0);	/* Copy to here */
 	outl(mem, card->pci_conf + DMALADR0);	/* from here */
@@ -887,9 +884,8 @@ fst_tx_dma(struct fst_card_info *card, dma_addr_t dma, u32 mem, int len)
 	 */
 
 	dbg(DBG_TX, "In fst_tx_dma %x %x %d\n", (u32)dma, mem, len);
-	if (card->dmatx_in_progress) {
+	if (card->dmatx_in_progress)
 		dbg(DBG_ASS, "In fst_tx_dma while dma in progress\n");
-	}
 
 	outl(dma, card->pci_conf + DMAPADR1);	/* Copy from here */
 	outl(mem, card->pci_conf + DMALADR1);	/* to here */
@@ -932,12 +928,11 @@ fst_issue_cmd(struct fst_port_info *port, unsigned short cmd)
 
 		mbval = FST_RDW(card, portMailbox[port->index][0]);
 	}
-	if (safety > 0) {
+	if (safety > 0)
 		dbg(DBG_CMD, "Mailbox clear after %d jiffies\n", safety);
-	}
-	if (mbval == NAK) {
+
+	if (mbval == NAK)
 		dbg(DBG_CMD, "issue_cmd: previous command was NAK'd\n");
-	}
 
 	FST_WRW(card, portMailbox[port->index][0], cmd);
 
@@ -1186,9 +1181,8 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		    pi, rxp);
 		return;
 	}
-	if (card->dmarx_in_progress) {
+	if (card->dmarx_in_progress)
 		return;
-	}
 
 	/* Get buffer length */
 	len = FST_RDW(card, rxDescrRing[pi][rxp].mcnt);
@@ -1323,9 +1317,9 @@ do_bottom_half_tx(struct fst_card_info *card)
 				spin_lock_irqsave(&card->card_lock, flags);
 				skb = port->txq[port->txqs];
 				port->txqs++;
-				if (port->txqs == FST_TXQ_DEPTH) {
+				if (port->txqs == FST_TXQ_DEPTH)
 					port->txqs = 0;
-				}
+
 				spin_unlock_irqrestore(&card->card_lock, flags);
 				/* copy the data and set the required indicators on the
 				 * card.
@@ -1489,9 +1483,8 @@ fst_intr(int dummy, void *dev_id)
 		FST_WRL(card, interruptRetryCount, 0);
 	}
 
-	if (!do_card_interrupt) {
+	if (!do_card_interrupt)
 		return IRQ_HANDLED;
-	}
 
 	/* Scehdule the bottom half of the ISR */
 	fst_q_work_item(&fst_work_intq, card->card_no);
@@ -1691,9 +1684,8 @@ set_conf_from_info(struct fst_card_info *card, struct fst_port_info *port,
 #endif
 	}
 #if FST_DEBUG
-	if (info->valid & FSTVAL_DEBUG) {
+	if (info->valid & FSTVAL_DEBUG)
 		fst_debug_mask = info->debug;
-	}
 #endif
 
 	return err;
@@ -1798,14 +1790,12 @@ fst_set_iface(struct fst_card_info *card, struct fst_port_info *port,
 	sync_serial_settings sync;
 	int i;
 
-	if (ifr->ifr_settings.size != sizeof (sync)) {
+	if (ifr->ifr_settings.size != sizeof(sync))
 		return -ENOMEM;
-	}
 
 	if (copy_from_user
-	    (&sync, ifr->ifr_settings.ifs_ifsu.sync, sizeof (sync))) {
+	    (&sync, ifr->ifr_settings.ifs_ifsu.sync, sizeof(sync)))
 		return -EFAULT;
-	}
 
 	if (sync.loopback)
 		return -EINVAL;
@@ -1898,12 +1888,11 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 		ifr->ifr_settings.type = IF_IFACE_X21;
 		break;
 	}
-	if (ifr->ifr_settings.size == 0) {
+	if (ifr->ifr_settings.size == 0)
 		return 0;	/* only type requested */
-	}
-	if (ifr->ifr_settings.size < sizeof (sync)) {
+
+	if (ifr->ifr_settings.size < sizeof(sync))
 		return -ENOMEM;
-	}
 
 	i = port->index;
 	memset(&sync, 0, sizeof(sync));
@@ -1913,9 +1902,8 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 	    INTCLK ? CLOCK_INT : CLOCK_EXT;
 	sync.loopback = 0;
 
-	if (copy_to_user(ifr->ifr_settings.ifs_ifsu.sync, &sync, sizeof (sync))) {
+	if (copy_to_user(ifr->ifr_settings.ifs_ifsu.sync, &sync, sizeof(sync)))
 		return -EFAULT;
-	}
 
 	ifr->ifr_settings.size = sizeof (sync);
 	return 0;
@@ -1955,21 +1943,19 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		/* First copy in the header with the length and offset of data
 		 * to write
 		 */
-		if (ifr->ifr_data == NULL) {
+		if (!ifr->ifr_data)
 			return -EINVAL;
-		}
+
 		if (copy_from_user(&wrthdr, ifr->ifr_data,
-				   sizeof (struct fstioc_write))) {
+				   sizeof(struct fstioc_write)))
 			return -EFAULT;
-		}
 
 		/* Sanity check the parameters. We don't support partial writes
 		 * when going over the top
 		 */
 		if (wrthdr.size > FST_MEMSIZE || wrthdr.offset > FST_MEMSIZE ||
-		    wrthdr.size + wrthdr.offset > FST_MEMSIZE) {
+		    wrthdr.size + wrthdr.offset > FST_MEMSIZE)
 			return -ENXIO;
-		}
 
 		/* Now copy the data to the card. */
 
@@ -1984,9 +1970,9 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		/* Writes to the memory of a card in the reset state constitute
 		 * a download
 		 */
-		if (card->state == FST_RESET) {
+		if (card->state == FST_RESET)
 			card->state = FST_DOWNLOAD;
-		}
+
 		return 0;
 
 	case FSTGETCONF:
@@ -2006,15 +1992,14 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		if (ifr->ifr_data == NULL) {
+		if (!ifr->ifr_data)
 			return -EINVAL;
-		}
 
 		gather_conf_info(card, port, &info);
 
-		if (copy_to_user(ifr->ifr_data, &info, sizeof (info))) {
+		if (copy_to_user(ifr->ifr_data, &info, sizeof(info)))
 			return -EFAULT;
-		}
+
 		return 0;
 
 	case FSTSETCONF:
@@ -2027,9 +2012,8 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			       card->card_no, card->state);
 			return -EIO;
 		}
-		if (copy_from_user(&info, ifr->ifr_data, sizeof (info))) {
+		if (copy_from_user(&info, ifr->ifr_data, sizeof(info)))
 			return -EFAULT;
-		}
 
 		return set_conf_from_info(card, port, &info);
 
@@ -2164,9 +2148,9 @@ fst_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	fst_closeport(dev_to_port(dev));
-	if (port->mode != FST_RAW) {
+	if (port->mode != FST_RAW)
 		hdlc_close(dev);
-	}
+
 	module_put(THIS_MODULE);
 	return 0;
 }
@@ -2366,7 +2350,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Allocate driver private data */
 	card = kzalloc(sizeof(struct fst_card_info), GFP_KERNEL);
-	if (card == NULL)
+	if (!card)
 		return -ENOMEM;
 
 	/* Try to enable the device */
@@ -2494,7 +2478,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		card->rx_dma_handle_host =
 		    dma_alloc_coherent(&card->device->dev, FST_MAX_MTU,
 				       &card->rx_dma_handle_card, GFP_KERNEL);
-		if (card->rx_dma_handle_host == NULL) {
+		if (!card->rx_dma_handle_host) {
 			pr_err("Could not allocate rx dma buffer\n");
 			err = -ENOMEM;
 			goto rx_dma_fail;
@@ -2502,7 +2486,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		card->tx_dma_handle_host =
 		    dma_alloc_coherent(&card->device->dev, FST_MAX_MTU,
 				       &card->tx_dma_handle_card, GFP_KERNEL);
-		if (card->tx_dma_handle_host == NULL) {
+		if (!card->tx_dma_handle_host) {
 			pr_err("Could not allocate tx dma buffer\n");
 			err = -ENOMEM;
 			goto tx_dma_fail;
-- 
2.8.1

