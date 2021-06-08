Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B8839F091
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhFHISB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8081 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhFHIRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:45 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzjfQ73M1zYrtv;
        Tue,  8 Jun 2021 16:13:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 09/16] net: farsync: fix the code style issue about macros
Date:   Tue, 8 Jun 2021 16:12:35 +0800
Message-ID: <1623139962-34847-10-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Macros with complex values should be enclosed in parentheses.
space required after that ',' .

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 075f50d..f2cd832 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -489,13 +489,13 @@ struct fst_card_info {
  */
 #define WIN_OFFSET(X)   ((long)&(((struct fst_shared *)SMC_BASE)->X))
 
-#define FST_RDB(C,E)    readb ((C)->mem + WIN_OFFSET(E))
-#define FST_RDW(C,E)    readw ((C)->mem + WIN_OFFSET(E))
-#define FST_RDL(C,E)    readl ((C)->mem + WIN_OFFSET(E))
+#define FST_RDB(C, E)    (readb((C)->mem + WIN_OFFSET(E)))
+#define FST_RDW(C, E)    (readw((C)->mem + WIN_OFFSET(E)))
+#define FST_RDL(C, E)    (readl((C)->mem + WIN_OFFSET(E)))
 
-#define FST_WRB(C,E,B)  writeb ((B), (C)->mem + WIN_OFFSET(E))
-#define FST_WRW(C,E,W)  writew ((W), (C)->mem + WIN_OFFSET(E))
-#define FST_WRL(C,E,L)  writel ((L), (C)->mem + WIN_OFFSET(E))
+#define FST_WRB(C, E, B)  (writeb((B), (C)->mem + WIN_OFFSET(E)))
+#define FST_WRW(C, E, W)  (writew((W), (C)->mem + WIN_OFFSET(E)))
+#define FST_WRL(C, E, L)  (writel((L), (C)->mem + WIN_OFFSET(E)))
 
 /*      Debug support
  */
-- 
2.8.1

