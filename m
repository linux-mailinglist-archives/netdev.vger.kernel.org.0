Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B988D3FA420
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhH1HAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9380 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhH1HAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GxS564pDNz8vxl;
        Sat, 28 Aug 2021 14:55:06 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: remove unnecessary "static" of local variables in function
Date:   Sat, 28 Aug 2021 14:55:20 +0800
Message-ID: <1630133721-9260-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
References: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Some local variable declarations are no need to add "static", so remove it.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c       | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 3e8ba7b62d1d..481179ac932f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -867,7 +867,7 @@ static void
 hns3_dbg_dev_caps(struct hnae3_handle *h, char *buf, int len, int *pos)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
-	static const char * const str[] = {"no", "yes"};
+	const char * const str[] = {"no", "yes"};
 	unsigned long *caps = ae_dev->caps;
 	u32 i, state;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 3c2600315f97..59772b0e9531 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -71,7 +71,7 @@ static bool hclgevf_cmd_csq_done(struct hclgevf_hw *hw)
 
 static bool hclgevf_is_special_opcode(u16 opcode)
 {
-	static const u16 spec_opcode[] = {0x30, 0x31, 0x32};
+	const u16 spec_opcode[] = {0x30, 0x31, 0x32};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++) {
-- 
2.8.1

