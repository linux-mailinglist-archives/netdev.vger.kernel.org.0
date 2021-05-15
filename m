Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AB53817CC
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhEOKz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:55:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2603 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhEOKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:45 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh3MTqzsR7d;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:24 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Tristram Ha <Tristram.Ha@micrel.com>
Subject: [PATCH 13/34] net: micrel: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:38 +0800
Message-ID: <1621076039-53986-14-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/micrel/ksz884x.c:2163: warning: expecting prototype for sw_get_board_storm(). Prototype was for sw_get_broad_storm() instead
 drivers/net/ethernet/micrel/ksz884x.c:2985: warning: expecting prototype for port_w_phy(). Prototype was for hw_w_phy() instead
 drivers/net/ethernet/micrel/ksz884x.c:4792: warning: expecting prototype for transmit_done(). Prototype was for tx_done() instead

Cc: Tristram Ha <Tristram.Ha@micrel.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 9ed264e..3532bfe 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -2153,7 +2153,7 @@ static void sw_cfg_broad_storm(struct ksz_hw *hw, u8 percent)
 }
 
 /**
- * sw_get_board_storm - get broadcast storm threshold
+ * sw_get_broad_storm - get broadcast storm threshold
  * @hw: 	The hardware instance.
  * @percent:	Buffer to store the broadcast storm threshold percentage.
  *
@@ -2973,7 +2973,7 @@ static void hw_r_phy(struct ksz_hw *hw, int port, u16 reg, u16 *val)
 }
 
 /**
- * port_w_phy - write data to PHY register
+ * hw_w_phy - write data to PHY register
  * @hw: 	The hardware instance.
  * @port:	Port to write.
  * @reg:	PHY register to write.
@@ -4782,7 +4782,7 @@ static void transmit_cleanup(struct dev_info *hw_priv, int normal)
 }
 
 /**
- * transmit_done - transmit done processing
+ * tx_done - transmit done processing
  * @hw_priv:	Network device.
  *
  * This routine is called when the transmit interrupt is triggered, indicating
-- 
2.7.4

