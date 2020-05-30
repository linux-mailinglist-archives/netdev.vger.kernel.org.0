Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23051E8CC3
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 03:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgE3BKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 21:10:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50026 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728625AbgE3BKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 21:10:08 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C2CCBED27CA5CF58C2ED;
        Sat, 30 May 2020 09:10:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 30 May 2020 09:09:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/6] net: hns3: fix an incorrect comment for num_tqps in struct hclgevf_dev
Date:   Sat, 30 May 2020 09:08:30 +0800
Message-ID: <1590800912-52467-5-git-send-email-tanhuazhong@huawei.com>
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

struct hclgevf_dev stands for VF device, its field num_tqps
indicates the number of VF's task queue pairs, so the comment
is incorrect, replace 'PF' with 'VF'.

Reported-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 738de12..c1fac89 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -278,7 +278,7 @@ struct hclgevf_dev {
 	struct semaphore reset_sem;	/* protect reset process */
 
 	u32 fw_version;
-	u16 num_tqps;		/* num task queue pairs of this PF */
+	u16 num_tqps;		/* num task queue pairs of this VF */
 
 	u16 alloc_rss_size;	/* allocated RSS task queue */
 	u16 rss_size_max;	/* HW defined max RSS task queue */
-- 
2.7.4

