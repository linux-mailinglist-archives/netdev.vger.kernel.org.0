Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD03106CA
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhBEIeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:34:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12431 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBEIeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:34:05 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DX7vR0VZ5zjHRN;
        Fri,  5 Feb 2021 16:32:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 16:33:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 5/6] net: hns3: debugfs add max tm rate specification print
Date:   Fri, 5 Feb 2021 16:32:48 +0800
Message-ID: <1612513969-9278-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
References: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

In order to add a method to check the specification of max tm rate
for debugging, function hns3_dbg_dev_specs() adds this value print.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 4f7922a..d88fc3c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -390,6 +390,7 @@ static void hns3_dbg_dev_specs(struct hnae3_handle *h)
 	dev_info(priv->dev, "MAX INT QL: %u\n", dev_specs->int_ql_max);
 	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
 	dev_info(priv->dev, "MAX frame size: %u\n", dev_specs->max_frm_size);
+	dev_info(priv->dev, "MAX TM RATE: %uMbps\n", dev_specs->max_tm_rate);
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
-- 
2.7.4

