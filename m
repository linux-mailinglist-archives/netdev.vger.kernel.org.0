Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47BA3596A3
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 09:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhDIHny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 03:43:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16430 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhDIHnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 03:43:53 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGqp65yCDzlWyN;
        Fri,  9 Apr 2021 15:41:50 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.76.230) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 15:43:31 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH net] net: hns3: Trivial spell fix in hns3 driver
Date:   Fri, 9 Apr 2021 08:42:23 +0100
Message-ID: <20210409074223.32480-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.76.230]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some trivial spelling mistakes which caught my eye during the
review of the code.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2dd2af269b46..b0dbe6dcaa7b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11210,7 +11210,7 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 	if (ret)
 		return ret;
 
-	/* RSS indirection table has been configuared by user */
+	/* RSS indirection table has been configured by user */
 	if (rxfh_configured)
 		goto out;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 700e068764c8..4c5ec5e38cea 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2193,7 +2193,7 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 
 	if (test_and_clear_bit(HCLGEVF_RESET_PENDING,
 			       &hdev->reset_state)) {
-		/* PF has initmated that it is about to reset the hardware.
+		/* PF has intimated that it is about to reset the hardware.
 		 * We now have to poll & check if hardware has actually
 		 * completed the reset sequence. On hardware reset completion,
 		 * VF needs to reset the client and ae device.
@@ -3497,7 +3497,7 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 	if (ret)
 		return ret;
 
-	/* RSS indirection table has been configuared by user */
+	/* RSS indirection table has been configured by user */
 	if (rxfh_configured)
 		goto out;
 
-- 
2.17.1

