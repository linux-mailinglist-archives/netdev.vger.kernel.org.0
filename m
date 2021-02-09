Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968AF31469C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhBICoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:44:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11707 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhBICnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:43:40 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZRwT18rbzlHtV;
        Tue,  9 Feb 2021 10:41:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 10:42:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 09/11] net: hns3: remove an unused parameter in hclge_vf_rate_param_check()
Date:   Tue, 9 Feb 2021 10:41:59 +0800
Message-ID: <1612838521-59915-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
References: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parameter vf in hclge_vf_rate_param_check() is unused now,
so remove it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5f3e844..64a80a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10831,7 +10831,7 @@ static void hclge_reset_vf_rate(struct hclge_dev *hdev)
 	}
 }
 
-static int hclge_vf_rate_param_check(struct hclge_dev *hdev, int vf,
+static int hclge_vf_rate_param_check(struct hclge_dev *hdev,
 				     int min_tx_rate, int max_tx_rate)
 {
 	if (min_tx_rate != 0 ||
@@ -10852,7 +10852,7 @@ static int hclge_set_vf_rate(struct hnae3_handle *handle, int vf,
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
-	ret = hclge_vf_rate_param_check(hdev, vf, min_tx_rate, max_tx_rate);
+	ret = hclge_vf_rate_param_check(hdev, min_tx_rate, max_tx_rate);
 	if (ret)
 		return ret;
 
-- 
2.7.4

