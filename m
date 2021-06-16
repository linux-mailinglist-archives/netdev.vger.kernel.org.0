Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAC3A965E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhFPJje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:39:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10101 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhFPJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:39:17 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4g4Q6WzyzZf6p;
        Wed, 16 Jun 2021 17:34:14 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/8] net: hdlc_ppp: fix the comments style issue
Date:   Wed, 16 Jun 2021 17:33:54 +0800
Message-ID: <1623836037-26812-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/wan/hdlc_ppp.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index fb5102c..9bda2c5 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -257,27 +257,25 @@ static void ppp_tx_cp(struct net_device *dev, u16 pid, u8 code,
 }
 
 /* State transition table (compare STD-51)
-   Events                                   Actions
-   TO+  = Timeout with counter > 0          irc = Initialize-Restart-Count
-   TO-  = Timeout with counter expired      zrc = Zero-Restart-Count
-
-   RCR+ = Receive-Configure-Request (Good)  scr = Send-Configure-Request
-   RCR- = Receive-Configure-Request (Bad)
-   RCA  = Receive-Configure-Ack             sca = Send-Configure-Ack
-   RCN  = Receive-Configure-Nak/Rej         scn = Send-Configure-Nak/Rej
-
-   RTR  = Receive-Terminate-Request         str = Send-Terminate-Request
-   RTA  = Receive-Terminate-Ack             sta = Send-Terminate-Ack
-
-   RUC  = Receive-Unknown-Code              scj = Send-Code-Reject
-   RXJ+ = Receive-Code-Reject (permitted)
-       or Receive-Protocol-Reject
-   RXJ- = Receive-Code-Reject (catastrophic)
-       or Receive-Protocol-Reject
-*/
+ * Events                                   Actions
+ * TO+  = Timeout with counter > 0          irc = Initialize-Restart-Count
+ * TO-  = Timeout with counter expired      zrc = Zero-Restart-Count
+ * RCR+ = Receive-Configure-Request (Good)  scr = Send-Configure-Request
+ * RCR- = Receive-Configure-Request (Bad)
+ * RCA  = Receive-Configure-Ack             sca = Send-Configure-Ack
+ * RCN  = Receive-Configure-Nak/Rej         scn = Send-Configure-Nak/Rej
+ * RTR  = Receive-Terminate-Request         str = Send-Terminate-Request
+ * RTA  = Receive-Terminate-Ack             sta = Send-Terminate-Ack
+ * RUC  = Receive-Unknown-Code              scj = Send-Code-Reject
+ * RXJ+ = Receive-Code-Reject (permitted)
+ *     or Receive-Protocol-Reject
+ * RXJ- = Receive-Code-Reject (catastrophic)
+ *     or Receive-Protocol-Reject
+ */
 static int cp_table[EVENTS][STATES] = {
 	/* CLOSED     STOPPED STOPPING REQ_SENT ACK_RECV ACK_SENT OPENED
-	     0           1         2       3       4      5          6    */
+	 *   0           1         2       3       4      5          6
+	 */
 	{IRC|SCR|3,     INV     , INV ,   INV   , INV ,  INV    ,   INV   }, /* START */
 	{   INV   ,      0      ,  0  ,    0    ,  0  ,   0     ,    0    }, /* STOP */
 	{   INV   ,     INV     ,STR|2,  SCR|3  ,SCR|3,  SCR|5  ,   INV   }, /* TO+ */
@@ -294,9 +292,10 @@ static int cp_table[EVENTS][STATES] = {
 };
 
 /* SCA: RCR+ must supply id, len and data
-   SCN: RCR- must supply code, id, len and data
-   STA: RTR must supply id
-   SCJ: RUC must supply CP packet len and data */
+ * SCN: RCR- must supply code, id, len and data
+ * STA: RTR must supply id
+ * SCJ: RUC must supply CP packet len and data
+ */
 static void ppp_cp_event(struct net_device *dev, u16 pid, u16 event, u8 code,
 			 u8 id, unsigned int len, const void *data)
 {
-- 
2.8.1

