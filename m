Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25ED72D3E8E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgLIJXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:23:08 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8969 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgLIJXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:23:08 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CrWlY0kRdzhpj8;
        Wed,  9 Dec 2020 17:22:01 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:22:14 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: hinic: simplify the return hinic_configure_max_qnum()
Date:   Wed, 9 Dec 2020 17:22:41 +0800
Message-ID: <20201209092241.20361-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 350225bbe0be..9a9b09401d01 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -313,13 +313,7 @@ static void free_rxqs(struct hinic_dev *nic_dev)
 
 static int hinic_configure_max_qnum(struct hinic_dev *nic_dev)
 {
-	int err;
-
-	err = hinic_set_max_qnum(nic_dev, nic_dev->hwdev->nic_cap.max_qps);
-	if (err)
-		return err;
-
-	return 0;
+	return hinic_set_max_qnum(nic_dev, nic_dev->hwdev->nic_cap.max_qps);
 }
 
 static int hinic_rss_init(struct hinic_dev *nic_dev)
-- 
2.22.0

