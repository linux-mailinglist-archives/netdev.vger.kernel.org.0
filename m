Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3D134160D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 07:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhCSGk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 02:40:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14381 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbhCSGk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 02:40:29 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F1vNm2v9rz90R0;
        Fri, 19 Mar 2021 14:38:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 14:40:21 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/4] net: hinic: remove the repeat word "the" in comment.
Date:   Fri, 19 Mar 2021 14:36:24 +0800
Message-ID: <1616135785-122085-4-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
References: <1616135785-122085-1-git-send-email-huangdaode@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a duplicate "the" in the comment, so delete it.

Signed-off-by: Daode Huang <huangdaode@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index efbaed3..cab38ff 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -334,7 +334,7 @@ static void set_dma_attr(struct hinic_hwif *hwif, u32 entry_idx,
 }
 
 /**
- * dma_attr_table_init - initialize the the default dma attributes
+ * dma_attr_table_init - initialize the default dma attributes
  * @hwif: the HW interface of a pci function device
  **/
 static void dma_attr_init(struct hinic_hwif *hwif)
-- 
2.8.1

