Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BCC3AD949
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhFSKCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:02:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5053 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhFSKCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:02:01 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G6WNg46gmzXgZd;
        Sat, 19 Jun 2021 17:54:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:43 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/8] net: at91_can: fix the code style issue about macro
Date:   Sat, 19 Jun 2021 17:56:24 +0800
Message-ID: <1624096589-13452-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
References: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
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

Macros with complex values should be enclosed in parentheses

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/can/at91_can.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 058c18fac167..8ea638d04cc7 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -43,14 +43,14 @@ enum at91_reg {
 };
 
 /* Mailbox registers (0 <= i <= 15) */
-#define AT91_MMR(i)		(enum at91_reg)(0x200 + ((i) * 0x20))
-#define AT91_MAM(i)		(enum at91_reg)(0x204 + ((i) * 0x20))
-#define AT91_MID(i)		(enum at91_reg)(0x208 + ((i) * 0x20))
-#define AT91_MFID(i)		(enum at91_reg)(0x20C + ((i) * 0x20))
-#define AT91_MSR(i)		(enum at91_reg)(0x210 + ((i) * 0x20))
-#define AT91_MDL(i)		(enum at91_reg)(0x214 + ((i) * 0x20))
-#define AT91_MDH(i)		(enum at91_reg)(0x218 + ((i) * 0x20))
-#define AT91_MCR(i)		(enum at91_reg)(0x21C + ((i) * 0x20))
+#define AT91_MMR(i)		((enum at91_reg)(0x200 + ((i) * 0x20)))
+#define AT91_MAM(i)		((enum at91_reg)(0x204 + ((i) * 0x20)))
+#define AT91_MID(i)		((enum at91_reg)(0x208 + ((i) * 0x20)))
+#define AT91_MFID(i)		((enum at91_reg)(0x20C + ((i) * 0x20)))
+#define AT91_MSR(i)		((enum at91_reg)(0x210 + ((i) * 0x20)))
+#define AT91_MDL(i)		((enum at91_reg)(0x214 + ((i) * 0x20)))
+#define AT91_MDH(i)		((enum at91_reg)(0x218 + ((i) * 0x20)))
+#define AT91_MCR(i)		((enum at91_reg)(0x21C + ((i) * 0x20)))
 
 /* Register bits */
 #define AT91_MR_CANEN		BIT(0)
-- 
2.8.1

