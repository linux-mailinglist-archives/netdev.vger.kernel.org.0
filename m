Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE41C4F7A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgEEHq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:46:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEHq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:46:26 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 229104EBF276A91F6063;
        Tue,  5 May 2020 15:46:24 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:46:16 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <kpsingh@chromium.org>, <skalluru@marvell.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: qede: Use true for bool variable in qede_init_fp()
Date:   Tue, 5 May 2020 15:45:39 +0800
Message-ID: <20200505074539.22161-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/qlogic/qede/qede_main.c:1717:5-19: WARNING:
Assignment of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9b456198cb50..256506024b88 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1714,7 +1714,7 @@ static void qede_init_fp(struct qede_dev *edev)
 				txq->ndev_txq_id = ndev_tx_id;
 
 				if (edev->dev_info.is_legacy)
-					txq->is_legacy = 1;
+					txq->is_legacy = true;
 				txq->dev = &edev->pdev->dev;
 			}
 
-- 
2.21.1

