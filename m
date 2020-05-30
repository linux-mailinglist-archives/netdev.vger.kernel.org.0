Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A7A1E8CB6
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 03:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgE3BKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 21:10:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49986 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgE3BKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 21:10:08 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 64FA73EABB71F99F71C8;
        Sat, 30 May 2020 09:10:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 30 May 2020 09:09:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/6] net: hns3: remove two unused macros in hclgevf_cmd.c
Date:   Sat, 30 May 2020 09:08:29 +0800
Message-ID: <1590800912-52467-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590800912-52467-1-git-send-email-tanhuazhong@huawei.com>
References: <1590800912-52467-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Macro hclgevf_ring_to_dma_dir and hclgevf_is_csq defined in
hclgevf_cmd.c, but not used, so remove them.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index f38d236..fec65239 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -11,9 +11,6 @@
 #include "hclgevf_main.h"
 #include "hnae3.h"
 
-#define hclgevf_is_csq(ring) ((ring)->flag & HCLGEVF_TYPE_CSQ)
-#define hclgevf_ring_to_dma_dir(ring) (hclgevf_is_csq(ring) ? \
-					DMA_TO_DEVICE : DMA_FROM_DEVICE)
 #define cmq_ring_to_dev(ring)   (&(ring)->dev->pdev->dev)
 
 static int hclgevf_ring_space(struct hclgevf_cmq_ring *ring)
-- 
2.7.4

