Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B13A93C6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhFPH3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:14 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7329 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhFPH3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4c8v3B0xz6yD1;
        Wed, 16 Jun 2021 15:22:55 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 09/15] net: cosa: add necessary () to macro argument
Date:   Wed, 16 Jun 2021 15:23:35 +0800
Message-ID: <1623828221-48349-10-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Macro argument 'cosa' may be better as '(cosa)' to avoid
precedence issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 6125ca4..a6629dc 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -238,14 +238,14 @@ MODULE_LICENSE("GPL");
 #define cosa_inw  inw
 #endif
 
-#define is_8bit(cosa)		(!(cosa->datareg & 0x08))
-
-#define cosa_getstatus(cosa)	(cosa_inb(cosa->statusreg))
-#define cosa_putstatus(cosa, stat)	(cosa_outb(stat, cosa->statusreg))
-#define cosa_getdata16(cosa)	(cosa_inw(cosa->datareg))
-#define cosa_getdata8(cosa)	(cosa_inb(cosa->datareg))
-#define cosa_putdata16(cosa, dt)	(cosa_outw(dt, cosa->datareg))
-#define cosa_putdata8(cosa, dt)	(cosa_outb(dt, cosa->datareg))
+#define is_8bit(cosa)		(!((cosa)->datareg & 0x08))
+
+#define cosa_getstatus(cosa)	(cosa_inb((cosa)->statusreg))
+#define cosa_putstatus(cosa, stat)	(cosa_outb(stat, (cosa)->statusreg))
+#define cosa_getdata16(cosa)	(cosa_inw((cosa)->datareg))
+#define cosa_getdata8(cosa)	(cosa_inb((cosa)->datareg))
+#define cosa_putdata16(cosa, dt)	(cosa_outw(dt, (cosa)->datareg))
+#define cosa_putdata8(cosa, dt)	(cosa_outb(dt, (cosa)->datareg))
 
 /* Initialization stuff */
 static int cosa_probe(int ioaddr, int irq, int dma);
-- 
2.8.1

