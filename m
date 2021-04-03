Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFDC3531FD
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 03:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbhDCBgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 21:36:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15472 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhDCBgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 21:36:41 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBzx15hR5zyNj7;
        Sat,  3 Apr 2021 09:34:29 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.74.55) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 3 Apr 2021 09:36:27 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH net 1/2] net: hns3: Remove the left over redundant check & assignment
Date:   Sat, 3 Apr 2021 02:35:19 +0100
Message-ID: <20210403013520.22108-2-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
In-Reply-To: <20210403013520.22108-1-salil.mehta@huawei.com>
References: <20210403013520.22108-1-salil.mehta@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.74.55]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the left over check and assignment which is no longer used
anywhere in the function and should have been removed as part of the
below mentioned patch.

Fixes: 012fcb52f67c ("net: hns3: activate reset timer when calling reset_event")
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e3f81c7e0ce7..7ad0722383f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3976,8 +3976,6 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 	 * want to make sure we throttle the reset request. Therefore, we will
 	 * not allow it again before 3*HZ times.
 	 */
-	if (!handle)
-		handle = &hdev->vport[0].nic;
 
 	if (time_before(jiffies, (hdev->last_reset_time +
 				  HCLGE_RESET_INTERVAL))) {
-- 
2.17.1

