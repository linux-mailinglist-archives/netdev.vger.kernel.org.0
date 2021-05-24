Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C326938EA81
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhEXO4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:56:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5687 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbhEXOvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:53 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpg6R2MS3z1BRBw;
        Mon, 24 May 2021 22:47:27 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 02/10] net: wan: fix an code style issue about "foo* bar"
Date:   Mon, 24 May 2021 22:47:09 +0800
Message-ID: <1621867637-2680-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
References: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
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

Fix the checkpatch error as "foo* bar" and should be "foo *bar",
and "(foo*)" should be "(foo *)".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/wanxl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 676dd813d36d..afca54cf3e82 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -32,7 +32,7 @@
 
 #include "wanxl.h"
 
-static const char* version = "wanXL serial card driver version: 0.48";
+static const char *version = "wanXL serial card driver version: 0.48";
 
 #define PLX_CTL_RESET   0x40000000 /* adapter reset */
 
@@ -227,7 +227,7 @@ static inline void wanxl_rx_intr(struct card *card)
 	}
 }
 
-static irqreturn_t wanxl_intr(int irq, void* dev_id)
+static irqreturn_t wanxl_intr(int irq, void *dev_id)
 {
 	struct card *card = dev_id;
         int i;
@@ -677,7 +677,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	}
 
 	for (i = 0; i < sizeof(firmware); i += 4)
-		writel(ntohl(*(__be32*)(firmware + i)), mem + PDM_OFFSET + i);
+		writel(ntohl(*(__be32 *)(firmware + i)), mem + PDM_OFFSET + i);
 
 	for (i = 0; i < ports; i++)
 		writel(card->status_address +
-- 
2.8.1

