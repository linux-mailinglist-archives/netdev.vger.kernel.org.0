Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12F8277CE4
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgIYA3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14231 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgIYA3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:05 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DFA714041E40CE3FF44E;
        Fri, 25 Sep 2020 08:29:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/6] net: hns3: rename macro of pci device id of vf
Date:   Fri, 25 Sep 2020 08:26:18 +0800
Message-ID: <1600993578-41008-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

VF devices do not have speed division, its speed is depended on its PF.
So macro name of PCI device id of VF is incorrent to have 100G info, it
should be renamed by removing 100G info.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 8 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 56c8969..ad7257e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -43,8 +43,8 @@
 #define HNAE3_DEV_ID_50GE_RDMA_MACSEC		0xA225
 #define HNAE3_DEV_ID_100G_RDMA_MACSEC		0xA226
 #define HNAE3_DEV_ID_200G_RDMA			0xA228
-#define HNAE3_DEV_ID_100G_VF			0xA22E
-#define HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF	0xA22F
+#define HNAE3_DEV_ID_VF				0xA22E
+#define HNAE3_DEV_ID_RDMA_DCB_PFC_VF		0xA22F
 
 #define HNAE3_CLASS_NAME_SIZE 16
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5126ad8..00e4002 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -83,8 +83,8 @@ static const struct pci_device_id hns3_pci_tbl[] = {
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_200G_RDMA),
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
-	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_VF), 0},
-	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF),
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_VF), 0},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_RDMA_DCB_PFC_VF),
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
 	/* required last entry */
 	{0, }
@@ -2048,8 +2048,8 @@ bool hns3_is_phys_func(struct pci_dev *pdev)
 	case HNAE3_DEV_ID_100G_RDMA_MACSEC:
 	case HNAE3_DEV_ID_200G_RDMA:
 		return true;
-	case HNAE3_DEV_ID_100G_VF:
-	case HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF:
+	case HNAE3_DEV_ID_VF:
+	case HNAE3_DEV_ID_RDMA_DCB_PFC_VF:
 		return false;
 	default:
 		dev_warn(&pdev->dev, "un-recognized pci device-id %u",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index f9f8312..307b18c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -19,8 +19,9 @@ static struct hnae3_ae_algo ae_algovf;
 static struct workqueue_struct *hclgevf_wq;
 
 static const struct pci_device_id ae_algovf_pci_tbl[] = {
-	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_VF), 0},
-	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF), 0},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_VF), 0},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_RDMA_DCB_PFC_VF),
+	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
 	/* required last entry */
 	{0, }
 };
-- 
2.7.4

