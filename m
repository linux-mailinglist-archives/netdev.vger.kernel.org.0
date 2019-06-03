Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4E32673
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 04:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfFCCLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 22:11:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbfFCCLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 22:11:04 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E8FD9AB53D6D49F7B48C;
        Mon,  3 Jun 2019 10:11:00 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 3 Jun 2019 10:10:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 04/10] net: hns3: set the port shaper according to MAC speed
Date:   Mon, 3 Jun 2019 10:09:16 +0800
Message-ID: <1559527762-22931-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
References: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch sets the port shaper according to the MAC speed as
suggested by hardware user manual.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index a7bbb6d..fac5193 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -397,7 +397,7 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 	u8 ir_u, ir_b, ir_s;
 	int ret;
 
-	ret = hclge_shaper_para_calc(HCLGE_ETHER_MAX_RATE,
+	ret = hclge_shaper_para_calc(hdev->hw.mac.speed,
 				     HCLGE_SHAPER_LVL_PORT,
 				     &ir_b, &ir_u, &ir_s);
 	if (ret)
-- 
2.7.4

