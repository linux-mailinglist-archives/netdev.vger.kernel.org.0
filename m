Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CF5362E3B
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhDQHKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:10:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17007 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhDQHKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:10:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FMkdV1GqSzPr1r;
        Sat, 17 Apr 2021 15:06:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 15:09:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/3] net: hns3: cleanup inappropriate spaces in struct hlcgevf_tqp_stats
Date:   Sat, 17 Apr 2021 15:09:23 +0800
Message-ID: <1618643364-64872-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
References: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify some inappropriate spaces in comments of struct
hlcgevf_tqp_stats.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 956095b..265c9b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -177,9 +177,9 @@ struct hclgevf_hw {
 
 /* TQP stats */
 struct hlcgevf_tqp_stats {
-	/* query_tqp_tx_queue_statistics ,opcode id:  0x0B03 */
+	/* query_tqp_tx_queue_statistics, opcode id: 0x0B03 */
 	u64 rcb_tx_ring_pktnum_rcd; /* 32bit */
-	/* query_tqp_rx_queue_statistics ,opcode id:  0x0B13 */
+	/* query_tqp_rx_queue_statistics, opcode id: 0x0B13 */
 	u64 rcb_rx_ring_pktnum_rcd; /* 32bit */
 };
 
-- 
2.7.4

