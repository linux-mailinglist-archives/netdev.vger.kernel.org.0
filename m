Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546E82724F1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgIUNMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:12:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727334AbgIUNKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B32B53BE298BE1521656;
        Mon, 21 Sep 2020 21:10:27 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:19 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] net: hns3: simplify the return expression of hclgevf_client_start()
Date:   Mon, 21 Sep 2020 21:10:43 +0800
Message-ID: <20200921131043.92385-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 20dd50dd7..8eb9af49b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2554,13 +2554,7 @@ static int hclgevf_set_alive(struct hnae3_handle *handle, bool alive)
 
 static int hclgevf_client_start(struct hnae3_handle *handle)
 {
-	int ret;
-
-	ret = hclgevf_set_alive(handle, true);
-	if (ret)
-		return ret;
-
-	return 0;
+	return hclgevf_set_alive(handle, true);
 }
 
 static void hclgevf_client_stop(struct hnae3_handle *handle)
-- 
2.23.0

