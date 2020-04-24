Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CDE1B6B4E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDXCZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:25:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2886 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbgDXCY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6A379E67C8B4A24D602;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/8] net: hns3: replace num_req_vfs with num_alloc_vport in hclge_reset_umv_space()
Date:   Fri, 24 Apr 2020 10:23:08 +0800
Message-ID: <1587694993-25183-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Like the calculation elsewhere, replaces num_req_vfs with
num_alloc_vport in hclge_reset_umv_space().

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fe6e60a..a268004 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7254,7 +7254,7 @@ static void hclge_reset_umv_space(struct hclge_dev *hdev)
 
 	mutex_lock(&hdev->umv_mutex);
 	hdev->share_umv_size = hdev->priv_umv_size +
-			hdev->max_umv_size % (hdev->num_req_vfs + 2);
+			hdev->max_umv_size % (hdev->num_alloc_vport + 1);
 	mutex_unlock(&hdev->umv_mutex);
 }
 
-- 
2.7.4

