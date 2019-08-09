Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69986F9F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405022AbfHICde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58874 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729418AbfHICdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0240CC3389DB528DC77B;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Guojia Liao <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: refine some macro definitions
Date:   Fri, 9 Aug 2019 10:31:18 +0800
Message-ID: <1565317878-31806-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Macro arguments should be enclosed in parentheses, in case of
expression argument, but parentheses of pure number in macro
definition should be removed for simplicity.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 43740ee..6c9fd58 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -58,10 +58,10 @@
 		BIT(HNAE3_DEV_SUPPORT_ROCE_B))
 
 #define hnae3_dev_roce_supported(hdev) \
-	hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B)
+	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B)
 
 #define hnae3_dev_dcb_supported(hdev) \
-	hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_DCB_B)
+	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_DCB_B)
 
 #define hnae3_dev_fd_supported(hdev) \
 	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 4ccf107..bdde3af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -125,7 +125,7 @@
 #define HCLGEVF_S_IP_BIT		BIT(3)
 #define HCLGEVF_V_TAG_BIT		BIT(4)
 
-#define HCLGEVF_STATS_TIMER_INTERVAL	(36)
+#define HCLGEVF_STATS_TIMER_INTERVAL	36U
 
 enum hclgevf_evt_cause {
 	HCLGEVF_VECTOR0_EVENT_RST,
-- 
2.7.4

