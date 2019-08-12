Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D748A161
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfHLOmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:42:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38610 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbfHLOmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:42:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 01C853840F2FEFA9693C;
        Mon, 12 Aug 2019 22:42:09 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 12 Aug 2019
 22:42:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: hns3: Make hclge_func_reset_sync_vf static
Date:   Mon, 12 Aug 2019 22:41:56 +0800
Message-ID: <20190812144156.70020-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:3190:5:
 warning: symbol 'hclge_func_reset_sync_vf' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d207dac..a3ca0e6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3187,7 +3187,7 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 	return 0;
 }
 
-int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
+static int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 {
 	struct hclge_pf_rst_sync_cmd *req;
 	struct hclge_desc desc;
-- 
2.7.4


