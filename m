Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34568354135
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhDEKko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:40:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15545 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhDEKkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:40:43 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FDRv40C7czPnnS;
        Mon,  5 Apr 2021 18:37:52 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 5 Apr 2021 18:40:27 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] net: nfc: Fix spelling errors in net/nfc module
Date:   Mon, 5 Apr 2021 18:54:35 +0800
Message-ID: <20210405105435.15747-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fix a series of spelling errors in net/nfc module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/nfc/digital_dep.c | 2 +-
 net/nfc/nci/core.c    | 2 +-
 net/nfc/nci/uart.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index 5971fb6f51cc..1150731126e2 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -1217,7 +1217,7 @@ static void digital_tg_recv_dep_req(struct nfc_digital_dev *ddev, void *arg,
 
 		/* ACK */
 		if (ddev->atn_count) {
-			/* The target has previously recevied one or more ATN
+			/* The target has previously received one or more ATN
 			 * PDUs.
 			 */
 			ddev->atn_count = 0;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 59257400697d..9a585332ea84 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1507,7 +1507,7 @@ static void nci_rx_work(struct work_struct *work)
 		}
 	}
 
-	/* check if a data exchange timout has occurred */
+	/* check if a data exchange timeout has occurred */
 	if (test_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags)) {
 		/* complete the data exchange transaction, if exists */
 		if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 1204c438e87d..6af5752cde09 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -234,7 +234,7 @@ static void nci_uart_tty_wakeup(struct tty_struct *tty)
  *     Called by tty low level driver when receive data is
  *     available.
  *
- * Arguments:  tty          pointer to tty isntance data
+ * Arguments:  tty          pointer to tty instance data
  *             data         pointer to received data
  *             flags        pointer to flags for data
  *             count        count of received data in bytes
@@ -374,7 +374,7 @@ static int nci_uart_default_recv_buf(struct nci_uart *nu, const u8 *data,
 		data += chunk_len;
 		count -= chunk_len;
 
-		/* Chcek if packet is fully received */
+		/* Check if packet is fully received */
 		if (nu->rx_packet_len == nu->rx_skb->len) {
 			/* Pass RX packet to driver */
 			if (nu->ops.recv(nu, nu->rx_skb) != 0)
-- 
2.25.1

