Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A613A2550
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFJHZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9058 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFJHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:12 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0wNm5QWgzYs15;
        Thu, 10 Jun 2021 15:20:24 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/8] net: ixp4xx_hss: remove redundant spaces
Date:   Thu, 10 Jun 2021 15:20:03 +0800
Message-ID: <1623309605-15671-7-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl,
space prohibited after that open parenthesis '('.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index d8f1df9..30a6df4 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -150,21 +150,21 @@
 #define CCR_SECOND_HSS			0x01000000
 
 /* hss_config, clkCR: main:10, num:10, denom:12 */
-#define CLK42X_SPEED_EXP	((0x3FF << 22) | (  2 << 12) |   15) /*65 KHz*/
-
-#define CLK42X_SPEED_512KHZ	((  130 << 22) | (  2 << 12) |   15)
-#define CLK42X_SPEED_1536KHZ	((   43 << 22) | ( 18 << 12) |   47)
-#define CLK42X_SPEED_1544KHZ	((   43 << 22) | ( 33 << 12) |  192)
-#define CLK42X_SPEED_2048KHZ	((   32 << 22) | ( 34 << 12) |   63)
-#define CLK42X_SPEED_4096KHZ	((   16 << 22) | ( 34 << 12) |  127)
-#define CLK42X_SPEED_8192KHZ	((    8 << 22) | ( 34 << 12) |  255)
-
-#define CLK46X_SPEED_512KHZ	((  130 << 22) | ( 24 << 12) |  127)
-#define CLK46X_SPEED_1536KHZ	((   43 << 22) | (152 << 12) |  383)
-#define CLK46X_SPEED_1544KHZ	((   43 << 22) | ( 66 << 12) |  385)
-#define CLK46X_SPEED_2048KHZ	((   32 << 22) | (280 << 12) |  511)
-#define CLK46X_SPEED_4096KHZ	((   16 << 22) | (280 << 12) | 1023)
-#define CLK46X_SPEED_8192KHZ	((    8 << 22) | (280 << 12) | 2047)
+#define CLK42X_SPEED_EXP	((0x3FF << 22) | (2 << 12) |   15) /*65 KHz*/
+
+#define CLK42X_SPEED_512KHZ	((130 << 22) | (2 << 12) |   15)
+#define CLK42X_SPEED_1536KHZ	((43 << 22) | (18 << 12) |   47)
+#define CLK42X_SPEED_1544KHZ	((43 << 22) | (33 << 12) |  192)
+#define CLK42X_SPEED_2048KHZ	((32 << 22) | (34 << 12) |   63)
+#define CLK42X_SPEED_4096KHZ	((16 << 22) | (34 << 12) |  127)
+#define CLK42X_SPEED_8192KHZ	((8 << 22) | (34 << 12) |  255)
+
+#define CLK46X_SPEED_512KHZ	((130 << 22) | (24 << 12) |  127)
+#define CLK46X_SPEED_1536KHZ	((43 << 22) | (152 << 12) |  383)
+#define CLK46X_SPEED_1544KHZ	((43 << 22) | (66 << 12) |  385)
+#define CLK46X_SPEED_2048KHZ	((32 << 22) | (280 << 12) |  511)
+#define CLK46X_SPEED_4096KHZ	((16 << 22) | (280 << 12) | 1023)
+#define CLK46X_SPEED_8192KHZ	((8 << 22) | (280 << 12) | 2047)
 
 /*
  * HSS_CONFIG_CLOCK_CR register consists of 3 parts:
-- 
2.8.1

