Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A894D34B440
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 05:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhC0EdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 00:33:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14154 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhC0Eca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 00:32:30 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6m8b0LRDznc6C;
        Sat, 27 Mar 2021 12:29:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 12:32:17 +0800
From:   'Liu Jian <liujian56@huawei.com>
To:     <liujian56@huawei.com>, Yisen Zhuang <yisen.zhuang@huawei.com>,
        "Salil Mehta" <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Huazhong Tan" <tanhuazhong@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        GuoJia Liao <liaoguojia@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: hns3: no return statement in hclge_clear_arfs_rules
Date:   Sat, 27 Mar 2021 12:33:39 +0800
Message-ID: <20210327043339.148050-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c: In function 'hclge_clear_arfs_rules':
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:7173:1: error: no return statement in function returning non-void [-Werror=return-type]
 7173 | }
      | ^
cc1: some warnings being treated as errors
make[6]: *** [scripts/Makefile.build:273: drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.o] Error 1
make[5]: *** [scripts/Makefile.build:534: drivers/net/ethernet/hisilicon/hns3/hns3pf] Error 2
make[4]: *** [scripts/Makefile.build:534: drivers/net/ethernet/hisilicon/hns3] Error 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [scripts/Makefile.build:534: drivers/net/ethernet/hisilicon] Error 2
make[2]: *** [scripts/Makefile.build:534: drivers/net/ethernet] Error 2
make[1]: *** [scripts/Makefile.build:534: drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1980: drivers] Error 2


Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 058317ce579c..84c70974c80b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7168,8 +7168,8 @@ static int hclge_clear_arfs_rules(struct hclge_dev *hdev)
 	}
 	hclge_sync_fd_state(hdev);
 
-	return 0;
 #endif
+	return 0;
 }
 
 static void hclge_get_cls_key_basic(const struct flow_rule *flow,

