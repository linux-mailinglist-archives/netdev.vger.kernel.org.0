Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB61A2D3E89
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgLIJVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:21:34 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8735 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbgLIJV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:21:29 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrWjL4HtmzknTP;
        Wed,  9 Dec 2020 17:20:06 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:20:39 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <madalin.bucur@nxp.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: freescale: dpaa: simplify the return dpaa_eth_refill_bpools()
Date:   Wed, 9 Dec 2020 17:21:07 +0800
Message-ID: <20201209092107.20306-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index cb7c028b1bf5..edc8222d96dc 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1599,17 +1599,13 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
 {
 	struct dpaa_bp *dpaa_bp;
 	int *countptr;
-	int res;
 
 	dpaa_bp = priv->dpaa_bp;
 	if (!dpaa_bp)
 		return -EINVAL;
 	countptr = this_cpu_ptr(dpaa_bp->percpu_count);
-	res  = dpaa_eth_refill_bpool(dpaa_bp, countptr);
-	if (res)
-		return res;
 
-	return 0;
+	return dpaa_eth_refill_bpool(dpaa_bp, countptr);
 }
 
 /* Cleanup function for outgoing frame descriptors that were built on Tx path,
-- 
2.22.0

