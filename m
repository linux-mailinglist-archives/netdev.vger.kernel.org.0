Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7988145180
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgAVJdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:33:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36079 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgAVJdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 04:33:49 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuCOK-0003Me-Dh; Wed, 22 Jan 2020 09:33:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: btcoex: fix spelling mistake "initilized" -> "initialized"
Date:   Wed, 22 Jan 2020 09:33:40 +0000
Message-Id: <20200122093340.2800226-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in one of the fields in the btc_coexist struct,
fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 2 +-
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c   | 2 +-
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 3c96c320236c..658ff425c256 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -862,7 +862,7 @@ static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 		/* Resume RF Rx LPF corner
 		 * After initialized, we can use coex_dm->btRf0x1eBackup
 		 */
-		if (btcoexist->initilized) {
+		if (btcoexist->initialized) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Resume RF Rx LPF corner!!\n");
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 191dafd03189..a4940a3842de 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1461,7 +1461,7 @@ void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
 			ex_btc8192e2ant_init_coex_dm(btcoexist);
 	}
 
-	btcoexist->initilized = true;
+	btcoexist->initialized = true;
 }
 
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 8c0a7fdbf200..a96a995dd850 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -679,7 +679,7 @@ struct btc_coexist {
 	bool auto_report_2ant;
 	bool dbg_mode_1ant;
 	bool dbg_mode_2ant;
-	bool initilized;
+	bool initialized;
 	bool stop_coex_dm;
 	bool manual_control;
 	struct btc_statistics statistics;
-- 
2.24.0

