Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DED382607
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhEQIAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3568 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbhEQIAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:12 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkBK64sYLzmVYk;
        Mon, 17 May 2021 15:56:10 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Tristram Ha <Tristram.Ha@micrel.com>
Subject: [PATCH v2 13/24] net: micrel: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:24 +0800
Message-ID: <20210517044535.21473-14-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
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
index 9ed264ed7070..3532bfe936f6 100644
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
2.17.1

