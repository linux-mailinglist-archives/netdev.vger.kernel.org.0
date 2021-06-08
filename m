Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03939F093
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFHISD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3468 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhFHIRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:45 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fzjf906pGz6vvL;
        Tue,  8 Jun 2021 16:12:49 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 08/16] net: farsync: code indent use tabs where possible
Date:   Tue, 8 Jun 2021 16:12:34 +0800
Message-ID: <1623139962-34847-9-git-send-email-huangguangbin2@huawei.com>
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

Code indent should use tabs where possible.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 7653ff0..075f50d 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -422,7 +422,7 @@ struct buf_window {
 /*      Per port (line or channel) information
  */
 struct fst_port_info {
-        struct net_device *dev; /* Device struct - must be first */
+	struct net_device *dev; /* Device struct - must be first */
 	struct fst_card_info *card;	/* Card we're associated with */
 	int index;		/* Port index on the card */
 	int hwif;		/* Line hardware (lineInterface copy) */
@@ -786,7 +786,7 @@ fst_init_dma(struct fst_card_info *card)
 	/* This is only required for the PLX 9054
 	 */
 	if (card->family == FST_FAMILY_TXU) {
-	        pci_set_master(card->device);
+		pci_set_master(card->device);
 		outl(0x00020441, card->pci_conf + DMAMODE0);
 		outl(0x00020441, card->pci_conf + DMAMODE1);
 		outl(0x0, card->pci_conf + DMATHR);
@@ -1561,7 +1561,7 @@ fst_intr(int dummy, void *dev_id)
 			rdidx = 0;
 	}
 	FST_WRB(card, interruptEvent.rdindex, rdidx);
-        return IRQ_HANDLED;
+	return IRQ_HANDLED;
 }
 
 /*      Check that the shared memory configuration is one that we can handle
@@ -2129,7 +2129,7 @@ fst_open(struct net_device *dev)
 
 	port = dev_to_port(dev);
 	if (!try_module_get(THIS_MODULE))
-          return -EBUSY;
+		return -EBUSY;
 
 	if (port->mode != FST_RAW) {
 		err = hdlc_open(dev);
@@ -2421,9 +2421,9 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				(ent->driver_data == FST_TYPE_T2U)) ? 2 : 4;
 
 	card->state = FST_UNINIT;
-        spin_lock_init ( &card->card_lock );
+	spin_lock_init(&card->card_lock);
 
-        for ( i = 0 ; i < card->nports ; i++ ) {
+	for (i = 0; i < card->nports; i++) {
 		struct net_device *dev = alloc_hdlcdev(&card->ports[i]);
 		hdlc_device *hdlc;
 
@@ -2435,29 +2435,29 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			goto hdlcdev_fail;
 		}
 		card->ports[i].dev    = dev;
-                card->ports[i].card   = card;
-                card->ports[i].index  = i;
-                card->ports[i].run    = 0;
+		card->ports[i].card   = card;
+		card->ports[i].index  = i;
+		card->ports[i].run    = 0;
 
 		hdlc = dev_to_hdlc(dev);
 
-                /* Fill in the net device info */
+		/* Fill in the net device info */
 		/* Since this is a PCI setup this is purely
 		 * informational. Give them the buffer addresses
 		 * and basic card I/O.
 		 */
-                dev->mem_start   = card->phys_mem
-                                 + BUF_OFFSET ( txBuffer[i][0][0]);
-                dev->mem_end     = card->phys_mem
-                                 + BUF_OFFSET ( txBuffer[i][NUM_TX_BUFFER - 1][LEN_RX_BUFFER - 1]);
-                dev->base_addr   = card->pci_conf;
-                dev->irq         = card->irq;
+		dev->mem_start   = card->phys_mem
+				+ BUF_OFFSET(txBuffer[i][0][0]);
+		dev->mem_end     = card->phys_mem
+				+ BUF_OFFSET(txBuffer[i][NUM_TX_BUFFER - 1][LEN_RX_BUFFER - 1]);
+		dev->base_addr   = card->pci_conf;
+		dev->irq         = card->irq;
 
 		dev->netdev_ops = &fst_ops;
 		dev->tx_queue_len = FST_TX_QUEUE_LEN;
 		dev->watchdog_timeo = FST_TX_TIMEOUT;
-                hdlc->attach = fst_attach;
-                hdlc->xmit   = fst_start_xmit;
+		hdlc->attach = fst_attach;
+		hdlc->xmit   = fst_start_xmit;
 	}
 
 	card->device = pdev;
-- 
2.8.1

