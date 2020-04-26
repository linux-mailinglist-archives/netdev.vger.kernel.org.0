Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D564F1B8B02
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 04:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgDZCPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 22:15:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50422 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbgDZCPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 22:15:14 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4E55B79F431BDBD024F4;
        Sun, 26 Apr 2020 10:15:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 10:15:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 9/9] net: hns3: remove an unnecessary check in hclge_set_umv_space()
Date:   Sun, 26 Apr 2020 10:13:48 +0800
Message-ID: <1587867228-9955-10-git-send-email-tanhuazhong@huawei.com>
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

Since hclge_set_umv_space() is only called by hclge_init_umv_space(),
parameter 'allocated_size' will not be NULL.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c74990a..e2fec83 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7227,8 +7227,7 @@ static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 		return ret;
 	}
 
-	if (allocated_size)
-		*allocated_size = le32_to_cpu(desc.data[1]);
+	*allocated_size = le32_to_cpu(desc.data[1]);
 
 	return 0;
 }
-- 
2.7.4

