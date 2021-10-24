Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84B343880C
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJXJsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:04 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26115 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HcY7P0pBcz1DGm9;
        Sun, 24 Oct 2021 17:43:45 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 7/8] net: hns3: add new ras error type for roce
Date:   Sun, 24 Oct 2021 17:41:14 +0800
Message-ID: <20211024094115.42158-8-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

This patch adds one ras error of bus related for roce, this error
including RRESP/BRESP and read poison error.

Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 5 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 93aa7f2bdc13..59df3c477c36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1321,7 +1321,10 @@ static const struct hclge_hw_type_id hclge_hw_type_id_st[] = {
 	}, {
 		.type_id = ROCEE_OVF_ERR,
 		.msg = "rocee_ovf_error"
-	}
+	}, {
+		.type_id = ROCEE_BUS_ERR,
+		.msg = "rocee_bus_error"
+	},
 };
 
 static void hclge_log_error(struct device *dev, char *reg,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index d811eeefe2c0..2f4f4c71a5ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -169,6 +169,7 @@ enum hclge_err_type_list {
 	/* add new ERROR TYPE for NIC here in order */
 	ROCEE_NORMAL_ERR	= 40,
 	ROCEE_OVF_ERR		= 41,
+	ROCEE_BUS_ERR		= 42,
 	/* add new ERROR TYPE for ROCEE here in order */
 };
 
-- 
2.33.0

