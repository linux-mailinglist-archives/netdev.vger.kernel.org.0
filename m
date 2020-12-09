Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682272D4361
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbgLINhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:37:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9568 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732125AbgLINhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:37:01 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrdN56dVJzM1kk;
        Wed,  9 Dec 2020 21:35:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:36:06 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] hisilicon/hns3: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:36:30 +0800
Message-ID: <20201209133630.1230-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1f026408ad38..ed2a3c88aab1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4976,7 +4976,7 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 	}
 
 	key_cfg = &hdev->fd_cfg.key_cfg[HCLGE_FD_STAGE_1];
-	key_cfg->key_sel = HCLGE_FD_KEY_BASE_ON_TUPLE,
+	key_cfg->key_sel = HCLGE_FD_KEY_BASE_ON_TUPLE;
 	key_cfg->inner_sipv6_word_en = LOW_2_WORDS;
 	key_cfg->inner_dipv6_word_en = LOW_2_WORDS;
 	key_cfg->outer_sipv6_word_en = 0;
-- 
2.22.0

