Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD8F3886C2
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbhESFji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:39:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3416 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242739AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlM1d3hLKzCt74;
        Wed, 19 May 2021 13:31:49 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:35 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH 06/20] net: chelsio: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:39 +0800
Message-ID: <1621402253-27200-7-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index cec7308..11d3b62 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -3371,7 +3371,7 @@ void t3_sge_prep(struct adapter *adap, struct sge_params *p)
 		q->coalesce_usecs = 5;
 		q->rspq_size = 1024;
 		q->fl_size = 1024;
- 		q->jumbo_size = 512;
+		q->jumbo_size = 512;
 		q->txq_size[TXQ_ETH] = 1024;
 		q->txq_size[TXQ_OFLD] = 1024;
 		q->txq_size[TXQ_CTRL] = 256;
-- 
2.8.1

