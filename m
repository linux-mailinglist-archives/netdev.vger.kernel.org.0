Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA7D38EA7F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhEXOz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:55:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3988 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhEXOvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:53 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fpg72504xzmZsw;
        Mon, 24 May 2021 22:47:58 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 06/10] net: wan: add some required spaces
Date:   Mon, 24 May 2021 22:47:13 +0800
Message-ID: <1621867637-2680-7-git-send-email-huangguangbin2@huawei.com>
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

Add space required after that close brace '}'.
Add space required before the open parenthesis '('.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/wanxl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 7e5bf207a142..7965c648f3eb 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -111,7 +111,7 @@ static inline void wanxl_cable_intr(struct port *port)
 	int valid = 1;
 	const char *cable, *pm, *dte = "", *dsr = "", *dcd = "";
 
-	switch(value & 0x7) {
+	switch (value & 0x7) {
 	case STATUS_CABLE_V35:
 		cable = "V.35";
 		break;
@@ -131,7 +131,7 @@ static inline void wanxl_cable_intr(struct port *port)
 		cable = "invalid";
 	}
 
-	switch((value >> STATUS_CABLE_PM_SHIFT) & 0x7) {
+	switch ((value >> STATUS_CABLE_PM_SHIFT) & 0x7) {
 	case STATUS_CABLE_V35:
 		pm = "V.35";
 		break;
@@ -484,7 +484,7 @@ static int wanxl_puts_command(struct card *card, u32 cmd)
 			return 0;
 
 		schedule();
-	}while (time_after(timeout, jiffies));
+	} while (time_after(timeout, jiffies));
 
 	return -1;
 }
@@ -654,7 +654,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 			return -ENODEV;
 		}
 
-		switch(stat & 0xC0) {
+		switch (stat & 0xC0) {
 		case 0x00:	/* hmm - PUTS completed with non-zero code? */
 		case 0x80:	/* PUTS still testing the hardware */
 			break;
@@ -733,7 +733,7 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 		if ((stat = readl(card->plx + PLX_MAILBOX_5)) != 0)
 			break;
 		schedule();
-	}while (time_after(timeout, jiffies));
+	} while (time_after(timeout, jiffies));
 
 	if (!stat) {
 		pr_warn("%s: timeout while initializing card firmware\n",
-- 
2.8.1

