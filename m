Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C174AA48B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfIENeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:34:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55916 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbfIENeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 09:34:16 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C310ED5F5F231C711E42;
        Thu,  5 Sep 2019 21:34:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 21:34:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 5/7] net: hns3: remove explicit conversion to bool
Date:   Thu, 5 Sep 2019 21:31:40 +0800
Message-ID: <1567690302-16648-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567690302-16648-1-git-send-email-tanhuazhong@huawei.com>
References: <1567690302-16648-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Relational and logical operators evaluate to bool,
explicit conversion is overly verbose and unnecessary.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 76e1c84..dde752f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6174,7 +6174,7 @@ static void hclge_enable_fd(struct hnae3_handle *handle, bool enable)
 	bool clear;
 
 	hdev->fd_en = enable;
-	clear = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE ? true : false;
+	clear = hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE;
 	if (!enable)
 		hclge_del_all_fd_entries(handle, clear);
 	else
-- 
2.7.4

