Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0CE39F095
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFHISF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3790 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhFHIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fzjc53MpkzWsmJ;
        Tue,  8 Jun 2021 16:11:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 10/16] net: farsync: add some required spaces
Date:   Tue, 8 Jun 2021 16:12:36 +0800
Message-ID: <1623139962-34847-11-git-send-email-huangguangbin2@huawei.com>
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

Add spaces required around that '=' and '*'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index f2cd832..8f39be4 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -63,7 +63,7 @@ MODULE_LICENSE("GPL");
 #define FST_MAX_MTU             8000	/* Huge but possible */
 #define FST_DEF_MTU             1500	/* Common sane value */
 
-#define FST_TX_TIMEOUT          (2*HZ)
+#define FST_TX_TIMEOUT          (2 * HZ)
 
 #ifdef ARPHRD_RAWHDLC
 #define ARPHRD_MYTYPE   ARPHRD_RAWHDLC	/* Raw frames */
@@ -1144,7 +1144,7 @@ fst_recover_rx_error(struct fst_card_info *card, struct fst_port_info *port,
 	i = 0;
 	while ((dmabits & (DMA_OWN | RX_STP)) == 0) {
 		FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
-		rxp = (rxp+1) % NUM_RX_BUFFER;
+		rxp = (rxp + 1) % NUM_RX_BUFFER;
 		if (++i > NUM_RX_BUFFER) {
 			dbg(DBG_ASS, "intr_rx: Discarding more bufs"
 			    " than we have\n");
@@ -1158,7 +1158,7 @@ fst_recover_rx_error(struct fst_card_info *card, struct fst_port_info *port,
 	/* Discard the terminal buffer */
 	if (!(dmabits & DMA_OWN)) {
 		FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
-		rxp = (rxp+1) % NUM_RX_BUFFER;
+		rxp = (rxp + 1) % NUM_RX_BUFFER;
 	}
 	port->rxpos = rxp;
 	return;
@@ -1203,7 +1203,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		/* Return descriptor to card */
 		FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
 
-		rxp = (rxp+1) % NUM_RX_BUFFER;
+		rxp = (rxp + 1) % NUM_RX_BUFFER;
 		port->rxpos = rxp;
 		return;
 	}
@@ -1229,7 +1229,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		/* Return descriptor to card */
 		FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
 
-		rxp = (rxp+1) % NUM_RX_BUFFER;
+		rxp = (rxp + 1) % NUM_RX_BUFFER;
 		port->rxpos = rxp;
 		return;
 	}
@@ -1273,7 +1273,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		dbg(DBG_ASS, "About to increment rxpos by more than 1\n");
 		dbg(DBG_ASS, "rxp = %d rxpos = %d\n", rxp, port->rxpos);
 	}
-	rxp = (rxp+1) % NUM_RX_BUFFER;
+	rxp = (rxp + 1) % NUM_RX_BUFFER;
 	port->rxpos = rxp;
 }
 
-- 
2.8.1

