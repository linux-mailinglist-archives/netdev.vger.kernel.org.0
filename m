Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057AE3A254B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFJHZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3821 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhFJHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0wLQ2gZ5zWtjb;
        Thu, 10 Jun 2021 15:18:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/8] net: ixp4xx_hss: fix the comments style issue
Date:   Thu, 10 Jun 2021 15:20:04 +0800
Message-ID: <1623309605-15671-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
References: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 30a6df4..319ae50 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -166,8 +166,7 @@
 #define CLK46X_SPEED_4096KHZ	((16 << 22) | (280 << 12) | 1023)
 #define CLK46X_SPEED_8192KHZ	((8 << 22) | (280 << 12) | 2047)
 
-/*
- * HSS_CONFIG_CLOCK_CR register consists of 3 parts:
+/* HSS_CONFIG_CLOCK_CR register consists of 3 parts:
  *     A (10 bits), B (10 bits) and C (12 bits).
  * IXP42x HSS clock generator operation (verified with an oscilloscope):
  * Each clock bit takes 7.5 ns (1 / 133.xx MHz).
@@ -217,7 +216,8 @@
 #define PORT_ERROR_READ			0x42
 
 /* triggers the NPE to reset internal status and enable the HssPacketized
-   operation for the flow specified by pPipe */
+ * operation for the flow specified by pPipe
+ */
 #define PKT_PIPE_FLOW_ENABLE		0x50
 #define PKT_PIPE_FLOW_DISABLE		0x51
 #define PKT_NUM_PIPES_WRITE		0x52
@@ -232,7 +232,8 @@
 #define ERR_HDLC_ALIGN		2 /* HDLC alignment error */
 #define ERR_HDLC_FCS		3 /* HDLC Frame Check Sum error */
 #define ERR_RXFREE_Q_EMPTY	4 /* RX-free queue became empty while receiving
-				     this packet (if buf_len < pkt_len) */
+				   * this packet (if buf_len < pkt_len)
+				   */
 #define ERR_HDLC_TOO_LONG	5 /* HDLC frame size too long */
 #define ERR_HDLC_ABORT		6 /* abort sequence received */
 #define ERR_DISCONNECTING	7 /* disconnect is in progress */
@@ -602,7 +603,8 @@ static inline void queue_put_desc(unsigned int queue, u32 phys,
 	BUG_ON(phys & 0x1F);
 	qmgr_put_entry(queue, phys);
 	/* Don't check for queue overflow here, we've allocated sufficient
-	   length and queues >= 32 don't support this check anyway. */
+	 * length and queues >= 32 don't support this check anyway.
+	 */
 }
 
 static inline void dma_unmap_tx(struct port *port, struct desc *desc)
-- 
2.8.1

