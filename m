Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C6C2A4F5
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 16:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfEYOtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 10:49:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfEYOtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 10:49:24 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 82491CEF65B7FE08E911;
        Sat, 25 May 2019 22:49:00 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 25 May 2019
 22:48:50 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtlwifi: btcoex: remove unused function exhalbtc_stack_operation_notify
Date:   Sat, 25 May 2019 22:48:44 +0800
Message-ID: <20190525144844.16976-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no callers in tree, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 24 -------------------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h  |  1 -
 2 files changed, 25 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 041326e6dd2f..152242ac0aa5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1741,30 +1741,6 @@ void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
-{
-	u8 stack_op_type;
-
-	if (!halbtc_is_bt_coexist_available(btcoexist))
-		return;
-	btcoexist->statistics.cnt_stack_operation_notify++;
-	if (btcoexist->manual_control)
-		return;
-
-	if ((type == HCI_BT_OP_INQUIRY_START) ||
-	    (type == HCI_BT_OP_PAGING_START) ||
-	    (type == HCI_BT_OP_PAIRING_START)) {
-		stack_op_type = BTC_STACK_OP_INQ_PAGE_PAIR_START;
-	} else if ((type == HCI_BT_OP_INQUIRY_FINISH) ||
-		   (type == HCI_BT_OP_PAGING_SUCCESS) ||
-		   (type == HCI_BT_OP_PAGING_UNSUCCESS) ||
-		   (type == HCI_BT_OP_PAIRING_FINISH)) {
-		stack_op_type = BTC_STACK_OP_INQ_PAGE_PAIR_FINISH;
-	} else {
-		stack_op_type = BTC_STACK_OP_NONE;
-	}
-}
-
 void exhalbtc_halt_notify(struct btc_coexist *btcoexist)
 {
 	if (!halbtc_is_bt_coexist_available(btcoexist))
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index ee9aeddf1ebc..8c0a7fdbf200 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -764,7 +764,6 @@ void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type);
 void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist, u8 *tmp_buf,
 			     u8 length);
 void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type);
-void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_halt_notify(struct btc_coexist *btcoexist);
 void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
 void exhalbtc_coex_dm_switch(struct btc_coexist *btcoexist);
-- 
2.17.1


