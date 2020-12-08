Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CB42D2C71
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgLHN56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:57:58 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9133 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgLHN55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:57:57 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cr1ty5bwtz15YR2;
        Tue,  8 Dec 2020 21:56:42 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 21:57:03 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: atheros: simplify the return expression of atl2_phy_setup_autoneg_adv()
Date:   Tue, 8 Dec 2020 21:57:30 +0800
Message-ID: <20201208135730.11926-1-zhengyongjun3@huawei.com>
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
 drivers/net/ethernet/atheros/atlx/atl2.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 7b80d924632a..f016f2e12ee7 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -2549,7 +2549,6 @@ static s32 atl2_write_phy_reg(struct atl2_hw *hw, u32 reg_addr, u16 phy_data)
  */
 static s32 atl2_phy_setup_autoneg_adv(struct atl2_hw *hw)
 {
-	s32 ret_val;
 	s16 mii_autoneg_adv_reg;
 
 	/* Read the MII Auto-Neg Advertisement Register (Address 4). */
@@ -2605,12 +2604,7 @@ static s32 atl2_phy_setup_autoneg_adv(struct atl2_hw *hw)
 
 	hw->mii_autoneg_adv_reg = mii_autoneg_adv_reg;
 
-	ret_val = atl2_write_phy_reg(hw, MII_ADVERTISE, mii_autoneg_adv_reg);
-
-	if (ret_val)
-		return ret_val;
-
-	return 0;
+	return atl2_write_phy_reg(hw, MII_ADVERTISE, mii_autoneg_adv_reg);
 }
 
 /*
-- 
2.22.0

