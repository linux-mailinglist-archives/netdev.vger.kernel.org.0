Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C57C2D3E6B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgLIJTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:19:07 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9405 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgLIJTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:19:07 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CrWfm25M0z79bB;
        Wed,  9 Dec 2020 17:17:52 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:18:17 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: marvell: octeontx2: simplify the return expression of rvu_npa_init()
Date:   Wed, 9 Dec 2020 17:18:44 +0800
Message-ID: <20201209091844.20151-1-zhengyongjun3@huawei.com>
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
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 67471cb2b129..24c2bfdfec4e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -497,18 +497,14 @@ static int npa_aq_init(struct rvu *rvu, struct rvu_block *block)
 int rvu_npa_init(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
-	int blkaddr, err;
+	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
 	if (blkaddr < 0)
 		return 0;
 
 	/* Initialize admin queue */
-	err = npa_aq_init(rvu, &hw->block[blkaddr]);
-	if (err)
-		return err;
-
-	return 0;
+	return npa_aq_init(rvu, &hw->block[blkaddr]);
 }
 
 void rvu_npa_freemem(struct rvu *rvu)
-- 
2.22.0

