Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3A959983
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfF1Lw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8231 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726931AbfF1LwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:15 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3BA4EAE7289F2E695B14;
        Fri, 28 Jun 2019 19:52:11 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:52:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: remove unused linkmode definition
Date:   Fri, 28 Jun 2019 19:50:16 +0800
Message-ID: <1561722618-12168-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patch removes unused linkmode definition.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 3ac1411..dd00640 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -446,25 +446,6 @@ enum hns3_flow_level_range {
 	HNS3_FLOW_ULTRA = 3,
 };
 
-enum hns3_link_mode_bits {
-	HNS3_LM_FIBRE_BIT = BIT(0),
-	HNS3_LM_AUTONEG_BIT = BIT(1),
-	HNS3_LM_TP_BIT = BIT(2),
-	HNS3_LM_PAUSE_BIT = BIT(3),
-	HNS3_LM_BACKPLANE_BIT = BIT(4),
-	HNS3_LM_10BASET_HALF_BIT = BIT(5),
-	HNS3_LM_10BASET_FULL_BIT = BIT(6),
-	HNS3_LM_100BASET_HALF_BIT = BIT(7),
-	HNS3_LM_100BASET_FULL_BIT = BIT(8),
-	HNS3_LM_1000BASET_FULL_BIT = BIT(9),
-	HNS3_LM_10000BASEKR_FULL_BIT = BIT(10),
-	HNS3_LM_25000BASEKR_FULL_BIT = BIT(11),
-	HNS3_LM_40000BASELR4_FULL_BIT = BIT(12),
-	HNS3_LM_50000BASEKR2_FULL_BIT = BIT(13),
-	HNS3_LM_100000BASEKR4_FULL_BIT = BIT(14),
-	HNS3_LM_COUNT = 15
-};
-
 #define HNS3_INT_GL_MAX			0x1FE0
 #define HNS3_INT_GL_50K			0x0014
 #define HNS3_INT_GL_20K			0x0032
-- 
2.7.4

