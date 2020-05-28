Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE681E62C5
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390655AbgE1NvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:51:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5373 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390504AbgE1NvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:51:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3158975C121EB11C6843;
        Thu, 28 May 2020 21:50:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 21:50:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: remove some unused fields in struct hclge_dev
Date:   Thu, 28 May 2020 21:48:18 +0800
Message-ID: <1590673699-63819-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
References: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some fields in struct hclge_dev which have not been used.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 913c4f6..46e6e0f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -771,12 +771,6 @@ struct hclge_dev {
 	u16 num_roce_msi;	/* Num of roce vectors for this PF */
 	int roce_base_vector;
 
-	u16 pending_udp_bitmap;
-
-	u16 rx_itr_default;
-	u16 tx_itr_default;
-
-	u16 adminq_work_limit; /* Num of admin receive queue desc to process */
 	unsigned long service_timer_period;
 	unsigned long service_timer_previous;
 	struct timer_list reset_timer;
-- 
2.7.4

