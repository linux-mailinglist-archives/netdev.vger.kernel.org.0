Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34FF38EA50
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhEXOyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:54:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5762 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhEXOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:54 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpg5b0V5nzmkcm;
        Mon, 24 May 2021 22:46:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:18 +0800
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
Subject: [PATCH net-next 05/10] net: wan: fix the code style issue about trailing statements
Date:   Mon, 24 May 2021 22:47:12 +0800
Message-ID: <1621867637-2680-6-git-send-email-huangguangbin2@huawei.com>
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

Trailing statements should be on next line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/wanxl.c | 59 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 0bcb21ddcc62..7e5bf207a142 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -112,21 +112,45 @@ static inline void wanxl_cable_intr(struct port *port)
 	const char *cable, *pm, *dte = "", *dsr = "", *dcd = "";
 
 	switch(value & 0x7) {
-	case STATUS_CABLE_V35: cable = "V.35"; break;
-	case STATUS_CABLE_X21: cable = "X.21"; break;
-	case STATUS_CABLE_V24: cable = "V.24"; break;
-	case STATUS_CABLE_EIA530: cable = "EIA530"; break;
-	case STATUS_CABLE_NONE: cable = "no"; break;
-	default: cable = "invalid";
+	case STATUS_CABLE_V35:
+		cable = "V.35";
+		break;
+	case STATUS_CABLE_X21:
+		cable = "X.21";
+		break;
+	case STATUS_CABLE_V24:
+		cable = "V.24";
+		break;
+	case STATUS_CABLE_EIA530:
+		cable = "EIA530";
+		break;
+	case STATUS_CABLE_NONE:
+		cable = "no";
+		break;
+	default:
+		cable = "invalid";
 	}
 
 	switch((value >> STATUS_CABLE_PM_SHIFT) & 0x7) {
-	case STATUS_CABLE_V35: pm = "V.35"; break;
-	case STATUS_CABLE_X21: pm = "X.21"; break;
-	case STATUS_CABLE_V24: pm = "V.24"; break;
-	case STATUS_CABLE_EIA530: pm = "EIA530"; break;
-	case STATUS_CABLE_NONE: pm = "no personality"; valid = 0; break;
-	default: pm = "invalid personality"; valid = 0;
+	case STATUS_CABLE_V35:
+		pm = "V.35";
+		break;
+	case STATUS_CABLE_X21:
+		pm = "X.21";
+		break;
+	case STATUS_CABLE_V24:
+		pm = "V.24";
+		break;
+	case STATUS_CABLE_EIA530:
+		pm = "EIA530";
+		break;
+	case STATUS_CABLE_NONE:
+		pm = "no personality";
+		valid = 0;
+		break;
+	default:
+		pm = "invalid personality";
+		valid = 0;
 	}
 
 	if (valid) {
@@ -563,9 +587,14 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	}
 
 	switch (pdev->device) {
-	case PCI_DEVICE_ID_SBE_WANXL100: ports = 1; break;
-	case PCI_DEVICE_ID_SBE_WANXL200: ports = 2; break;
-	default: ports = 4;
+	case PCI_DEVICE_ID_SBE_WANXL100:
+		ports = 1;
+		break;
+	case PCI_DEVICE_ID_SBE_WANXL200:
+		ports = 2;
+		break;
+	default:
+		ports = 4;
 	}
 
 	card = kzalloc(struct_size(card, ports, ports), GFP_KERNEL);
-- 
2.8.1

