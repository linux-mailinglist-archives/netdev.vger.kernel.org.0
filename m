Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6662724A4
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgIUNJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:09:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42056 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726417AbgIUNJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:09:51 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0226ED0F3774B90C5040;
        Mon, 21 Sep 2020 21:09:49 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:09:41 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Vishal Kulkarni <vishal@chelsio.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] chelsio: simplify the return expression of t3_ael2020_phy_prep()
Date:   Mon, 21 Sep 2020 21:10:05 +0800
Message-ID: <20200921131005.91054-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/ael1002.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/ael1002.c b/drivers/net/ethernet/chelsio/cxgb3/ael1002.c
index dadf11e3d..9d591f0dd 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/ael1002.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/ael1002.c
@@ -815,17 +815,12 @@ static const struct cphy_ops ael2020_ops = {
 int t3_ael2020_phy_prep(struct cphy *phy, struct adapter *adapter, int phy_addr,
 			const struct mdio_ops *mdio_ops)
 {
-	int err;
-
 	cphy_init(phy, adapter, phy_addr, &ael2020_ops, mdio_ops,
 		  SUPPORTED_10000baseT_Full | SUPPORTED_AUI | SUPPORTED_FIBRE |
 		  SUPPORTED_IRQ, "10GBASE-R");
 	msleep(125);
 
-	err = set_phy_regs(phy, ael2020_reset_regs);
-	if (err)
-		return err;
-	return 0;
+	return set_phy_regs(phy, ael2020_reset_regs);
 }
 
 /*
-- 
2.23.0

