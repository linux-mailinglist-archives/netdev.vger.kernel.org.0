Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A4185B86
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 10:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgCOJfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 05:35:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgCOJfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 05:35:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 81F86ABD7;
        Sun, 15 Mar 2020 09:35:07 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2 1/6] net: caif: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:34:58 +0100
Message-Id: <20200315093503.8558-2-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315093503.8558-1-tiwai@suse.de>
References: <20200315093503.8558-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Align the remaining lines to the open parenthesis

 drivers/net/caif/caif_spi.c | 72 ++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index 8e81bdf98ac6..63f2548f5b1b 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -141,29 +141,29 @@ static ssize_t dbgfs_state(struct file *file, char __user *user_buf,
 		return 0;
 
 	/* Print out debug information. */
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"CAIF SPI debug information:\n");
-
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len), FLAVOR);
-
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"STATE: %d\n", cfspi->dbg_state);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Previous CMD: 0x%x\n", cfspi->pcmd);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Current CMD: 0x%x\n", cfspi->cmd);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Previous TX len: %d\n", cfspi->tx_ppck_len);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Previous RX len: %d\n", cfspi->rx_ppck_len);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Current TX len: %d\n", cfspi->tx_cpck_len);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Current RX len: %d\n", cfspi->rx_cpck_len);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Next TX len: %d\n", cfspi->tx_npck_len);
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Next RX len: %d\n", cfspi->rx_npck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "CAIF SPI debug information:\n");
+
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len), FLAVOR);
+
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "STATE: %d\n", cfspi->dbg_state);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Previous CMD: 0x%x\n", cfspi->pcmd);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Current CMD: 0x%x\n", cfspi->cmd);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Previous TX len: %d\n", cfspi->tx_ppck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Previous RX len: %d\n", cfspi->rx_ppck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Current TX len: %d\n", cfspi->tx_cpck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Current RX len: %d\n", cfspi->rx_cpck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Next TX len: %d\n", cfspi->tx_npck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Next RX len: %d\n", cfspi->rx_npck_len);
 
 	if (len > DEBUGFS_BUF_SIZE)
 		len = DEBUGFS_BUF_SIZE;
@@ -180,23 +180,23 @@ static ssize_t print_frame(char *buf, size_t size, char *frm,
 	int len = 0;
 	int i;
 	for (i = 0; i < count; i++) {
-		len += snprintf((buf + len), (size - len),
+		len += scnprintf((buf + len), (size - len),
 					"[0x" BYTE_HEX_FMT "]",
 					frm[i]);
 		if ((i == cut) && (count > (cut * 2))) {
 			/* Fast forward. */
 			i = count - cut;
-			len += snprintf((buf + len), (size - len),
-					"--- %zu bytes skipped ---\n",
-					count - (cut * 2));
+			len += scnprintf((buf + len), (size - len),
+					 "--- %zu bytes skipped ---\n",
+					 count - (cut * 2));
 		}
 
 		if ((!(i % 10)) && i) {
-			len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-					"\n");
+			len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+					 "\n");
 		}
 	}
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len), "\n");
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len), "\n");
 	return len;
 }
 
@@ -214,18 +214,18 @@ static ssize_t dbgfs_frame(struct file *file, char __user *user_buf,
 		return 0;
 
 	/* Print out debug information. */
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Current frame:\n");
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Current frame:\n");
 
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Tx data (Len: %d):\n", cfspi->tx_cpck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Tx data (Len: %d):\n", cfspi->tx_cpck_len);
 
 	len += print_frame((buf + len), (DEBUGFS_BUF_SIZE - len),
 			   cfspi->xfer.va_tx[0],
 			   (cfspi->tx_cpck_len + SPI_CMD_SZ), 100);
 
-	len += snprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
-			"Rx data (Len: %d):\n", cfspi->rx_cpck_len);
+	len += scnprintf((buf + len), (DEBUGFS_BUF_SIZE - len),
+			 "Rx data (Len: %d):\n", cfspi->rx_cpck_len);
 
 	len += print_frame((buf + len), (DEBUGFS_BUF_SIZE - len),
 			   cfspi->xfer.va_rx,
-- 
2.16.4

