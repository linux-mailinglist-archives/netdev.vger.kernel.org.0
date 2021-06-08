Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9725039F0A0
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFHISY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:24 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4398 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFHIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:46 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FzjdF69FKz6vY7;
        Tue,  8 Jun 2021 16:12:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [PATCH net-next 12/16] net: farsync: remove redundant spaces
Date:   Tue, 8 Jun 2021 16:12:38 +0800
Message-ID: <1623139962-34847-13-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl,
space prohibited between function name and open parenthesis '(',
no space is necessary after a cast.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 8b96f35..bbe87d9 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -708,7 +708,7 @@ fst_cpurelease(struct fst_card_info *card)
 	if (card->family == FST_FAMILY_TXU) {
 		/* Force posted writes to complete
 		 */
-		(void) readb(card->mem);
+		(void)readb(card->mem);
 
 		/* Release LRESET DO = 1
 		 * Then release Local Hold, DO = 1
@@ -716,7 +716,7 @@ fst_cpurelease(struct fst_card_info *card)
 		outw(0x040e, card->pci_conf + CNTRL_9054 + 2);
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
 	} else {
-		(void) readb(card->ctlmem);
+		(void)readb(card->ctlmem);
 	}
 }
 
@@ -726,7 +726,7 @@ static inline void
 fst_clear_intr(struct fst_card_info *card)
 {
 	if (card->family == FST_FAMILY_TXU) {
-		(void) readb(card->ctlmem);
+		(void)readb(card->ctlmem);
 	} else {
 		/* Poke the appropriate PLX chip register (same as enabling interrupts)
 		 */
@@ -984,8 +984,8 @@ fst_rx_config(struct fst_port_info *port)
 	for (i = 0; i < NUM_RX_BUFFER; i++) {
 		offset = BUF_OFFSET(rxBuffer[pi][i][0]);
 
-		FST_WRW(card, rxDescrRing[pi][i].ladr, (u16) offset);
-		FST_WRB(card, rxDescrRing[pi][i].hadr, (u8) (offset >> 16));
+		FST_WRW(card, rxDescrRing[pi][i].ladr, (u16)offset);
+		FST_WRB(card, rxDescrRing[pi][i].hadr, (u8)(offset >> 16));
 		FST_WRW(card, rxDescrRing[pi][i].bcnt, cnv_bcnt(LEN_RX_BUFFER));
 		FST_WRW(card, rxDescrRing[pi][i].mcnt, LEN_RX_BUFFER);
 		FST_WRB(card, rxDescrRing[pi][i].bits, DMA_OWN);
@@ -1011,8 +1011,8 @@ fst_tx_config(struct fst_port_info *port)
 	for (i = 0; i < NUM_TX_BUFFER; i++) {
 		offset = BUF_OFFSET(txBuffer[pi][i][0]);
 
-		FST_WRW(card, txDescrRing[pi][i].ladr, (u16) offset);
-		FST_WRB(card, txDescrRing[pi][i].hadr, (u8) (offset >> 16));
+		FST_WRW(card, txDescrRing[pi][i].ladr, (u16)offset);
+		FST_WRB(card, txDescrRing[pi][i].hadr, (u8)(offset >> 16));
 		FST_WRW(card, txDescrRing[pi][i].bcnt, 0);
 		FST_WRB(card, txDescrRing[pi][i].bits, 0);
 	}
@@ -1697,7 +1697,7 @@ gather_conf_info(struct fst_card_info *card, struct fst_port_info *port,
 {
 	int i;
 
-	memset(info, 0, sizeof (struct fstioc_info));
+	memset(info, 0, sizeof(struct fstioc_info));
 
 	i = port->index;
 	info->kernelVersion = LINUX_VERSION_CODE;
@@ -1905,7 +1905,7 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 	if (copy_to_user(ifr->ifr_settings.ifs_ifsu.sync, &sync, sizeof(sync)))
 		return -EFAULT;
 
-	ifr->ifr_settings.size = sizeof (sync);
+	ifr->ifr_settings.size = sizeof(sync);
 	return 0;
 }
 
-- 
2.8.1

