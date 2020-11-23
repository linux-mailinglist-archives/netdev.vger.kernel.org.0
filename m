Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376552C0364
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgKWKfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:35:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40126 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbgKWKe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:34:59 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kh9BN-000356-1A; Mon, 23 Nov 2020 10:34:53 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: fix spelling mistake "memroy" -> "memory"
Date:   Mon, 23 Nov 2020 10:34:52 +0000
Message-Id: <20201123103452.197708-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in two dev_err messages. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 500cc19225f3..ca668a47121e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9924,7 +9924,7 @@ static int hclge_dev_mem_map(struct hclge_dev *hdev)
 				       pci_resource_start(pdev, HCLGE_MEM_BAR),
 				       pci_resource_len(pdev, HCLGE_MEM_BAR));
 	if (!hw->mem_base) {
-		dev_err(&pdev->dev, "failed to map device memroy\n");
+		dev_err(&pdev->dev, "failed to map device memory\n");
 		return -EFAULT;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5d6b419b8a78..5b2f9a56f1d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2904,7 +2904,7 @@ static int hclgevf_dev_mem_map(struct hclgevf_dev *hdev)
 							  HCLGEVF_MEM_BAR),
 				       pci_resource_len(pdev, HCLGEVF_MEM_BAR));
 	if (!hw->mem_base) {
-		dev_err(&pdev->dev, "failed to map device memroy\n");
+		dev_err(&pdev->dev, "failed to map device memory\n");
 		return -EFAULT;
 	}
 
-- 
2.28.0

