Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7488C2D4354
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbgLINeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:34:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9408 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbgLINec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:34:32 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CrdKQ4kKNz7Blw;
        Wed,  9 Dec 2020 21:33:14 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:33:35 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: micrel: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:34:02 +0800
Message-ID: <20201209133402.1057-1-zhengyongjun3@huawei.com>
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
 drivers/net/ethernet/micrel/ks8851_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index d65872172229..6fc7483aea03 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1112,7 +1112,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 
 	/* setup mii state */
 	ks->mii.dev		= netdev;
-	ks->mii.phy_id		= 1,
+	ks->mii.phy_id		= 1;
 	ks->mii.phy_id_mask	= 1;
 	ks->mii.reg_num_mask	= 0xf;
 	ks->mii.mdio_read	= ks8851_phy_read;
-- 
2.22.0

