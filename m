Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477131B8B0A
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 04:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgDZCPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 22:15:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2899 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbgDZCPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 22:15:10 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0C3A84DEB3B4422145E9;
        Sun, 26 Apr 2020 10:15:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 10:15:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 3/9] net: hns3: replace num_req_vfs with num_alloc_vport in hclge_reset_umv_space()
Date:   Sun, 26 Apr 2020 10:13:42 +0800
Message-ID: <1587867228-9955-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
References: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
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

