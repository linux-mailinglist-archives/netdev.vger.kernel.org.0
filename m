Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FC5A887A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbfIDOJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:09:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730552AbfIDOJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 10:09:15 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 97652283CA4C42E2D9E4;
        Wed,  4 Sep 2019 22:09:13 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 22:09:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: make hclge_dbg_get_m7_stats_info static
Date:   Wed, 4 Sep 2019 22:06:46 +0800
Message-ID: <1567606006-39598-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
References: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

hclge_dbg_get_m7_info is used only in the hclge_debugfs.c,
so it should be declared with static.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 1c6b501..6dcce48 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -949,7 +949,7 @@ static void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 		 hdev->rst_stats.reset_cnt);
 }
 
-void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
+static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 {
 	struct hclge_desc *desc_src, *desc_tmp;
 	struct hclge_get_m7_bd_cmd *req;
-- 
2.7.4

