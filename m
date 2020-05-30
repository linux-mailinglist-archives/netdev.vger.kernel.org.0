Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43671E8CC4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 03:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgE3BKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 21:10:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49928 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728623AbgE3BKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 21:10:09 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5B567D68AFEBCFC7D1BF;
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
Subject: [PATCH net-next 5/6] net: hns3: fix two coding style issues in hclgevf_main.c
Date:   Sat, 30 May 2020 09:08:31 +0800
Message-ID: <1590800912-52467-6-git-send-email-tanhuazhong@huawei.com>
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

Remove a redundant blank line in hclgevf_cmd_set_promisc_mode(),
and fix a reverse xmas tree coding style issue in
hclgevf_set_rss_tc_mode().

Reported-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index a8c0e79..1b9578d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -669,8 +669,8 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 	u16 tc_size[HCLGEVF_MAX_TC_NUM];
 	struct hclgevf_desc desc;
 	u16 roundup_size;
-	int status;
 	unsigned int i;
+	int status;
 
 	req = (struct hclgevf_rss_tc_mode_cmd *)desc.data;
 
@@ -1143,7 +1143,6 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
 	send_msg.en_mc = en_mc_pmc ? 1 : 0;
 
 	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
-
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"Set promisc mode fail, status is %d.\n", ret);
-- 
2.7.4

