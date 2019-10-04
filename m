Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1131ECB67E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbfJDIg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:36:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729311AbfJDIg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 08B065F4E0EB77701CD2;
        Fri,  4 Oct 2019 16:36:53 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:45 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 4/8] rtlwifi: rtl8188ee: Remove set but not used variables 'v3','rtstatus','reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
Date:   Fri, 4 Oct 2019 16:43:51 +0800
Message-ID: <1570178635-57582-5-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
References: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function phy_config_bb_with_pghdr:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:652:22: warning: variable v3 set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function rtl88e_phy_config_rf_with_headerfile:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:772:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function rtl88e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1945:6: warning: variable reg_ecc set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function rtl88e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1944:61: warning: variable reg_ec4 set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function rtl88e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1944:34: warning: variable reg_eac set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c: In function rtl88e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1943:19: warning: variable b_pathb_ok set but not used [-Wunused-but-set-variable]

They are not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c    | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 96d8f25..978e6a16 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -649,7 +649,7 @@ static bool phy_config_bb_with_pghdr(struct ieee80211_hw *hw, u8 configtype)
 	int i;
 	u32 *phy_reg_page;
 	u16 phy_reg_page_len;
-	u32 v1 = 0, v2 = 0, v3 = 0;
+	u32 v1 = 0, v2 = 0;

 	phy_reg_page_len = RTL8188EEPHY_REG_ARRAY_PGLEN;
 	phy_reg_page = RTL8188EEPHY_REG_ARRAY_PG;
@@ -658,7 +658,6 @@ static bool phy_config_bb_with_pghdr(struct ieee80211_hw *hw, u8 configtype)
 		for (i = 0; i < phy_reg_page_len; i = i + 3) {
 			v1 = phy_reg_page[i];
 			v2 = phy_reg_page[i+1];
-			v3 = phy_reg_page[i+2];

 			if (v1 < 0xcdcdcdcd) {
 				if (phy_reg_page[i] == 0xfe)
@@ -689,13 +688,11 @@ static bool phy_config_bb_with_pghdr(struct ieee80211_hw *hw, u8 configtype)

 				    v1 = phy_reg_page[i];
 				    v2 = phy_reg_page[i+1];
-				    v3 = phy_reg_page[i+2];
 				    while (v2 != 0xDEAD &&
 					   i < phy_reg_page_len - 5) {
 					i += 3;
 					v1 = phy_reg_page[i];
 					v2 = phy_reg_page[i+1];
-					v3 = phy_reg_page[i+2];
 				    }
 				}
 			}
@@ -769,7 +766,6 @@ bool rtl88e_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	bool rtstatus = true;
 	u32 *radioa_array_table;
 	u16 radioa_arraylen;

@@ -778,7 +774,6 @@ bool rtl88e_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "Radio_A:RTL8188EE_RADIOA_1TARRAY %d\n", radioa_arraylen);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
-	rtstatus = true;
 	switch (rfpath) {
 	case RF90_PATH_A:
 		process_path_a(hw, radioa_arraylen, radioa_array_table);
@@ -1940,9 +1935,9 @@ void rtl88e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	long result[4][8];
 	u8 i, final_candidate;
-	bool b_patha_ok, b_pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4,
-	    reg_ecc, reg_tmp = 0;
+	bool b_patha_ok;
+	long reg_e94, reg_e9c, reg_ea4, reg_eb4, reg_ebc,
+	    reg_tmp = 0;
 	bool is12simular, is13simular, is23simular;
 	u32 iqk_bb_reg[9] = {
 		ROFDM0_XARXIQIMBALANCE,
@@ -1971,7 +1966,6 @@ void rtl88e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	}
 	final_candidate = 0xff;
 	b_patha_ok = false;
-	b_pathb_ok = false;
 	is12simular = false;
 	is23simular = false;
 	is13simular = false;
@@ -2014,27 +2008,20 @@ void rtl88e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 		reg_e94 = result[i][0];
 		reg_e9c = result[i][1];
 		reg_ea4 = result[i][2];
-		reg_eac = result[i][3];
 		reg_eb4 = result[i][4];
 		reg_ebc = result[i][5];
-		reg_ec4 = result[i][6];
-		reg_ecc = result[i][7];
 	}
 	if (final_candidate != 0xff) {
 		reg_e94 = result[final_candidate][0];
 		reg_e9c = result[final_candidate][1];
 		reg_ea4 = result[final_candidate][2];
-		reg_eac = result[final_candidate][3];
 		reg_eb4 = result[final_candidate][4];
 		reg_ebc = result[final_candidate][5];
-		reg_ec4 = result[final_candidate][6];
-		reg_ecc = result[final_candidate][7];
 		rtlphy->reg_eb4 = reg_eb4;
 		rtlphy->reg_ebc = reg_ebc;
 		rtlphy->reg_e94 = reg_e94;
 		rtlphy->reg_e9c = reg_e9c;
 		b_patha_ok = true;
-		b_pathb_ok = true;
 	} else {
 		rtlphy->reg_e94 = 0x100;
 		rtlphy->reg_eb4 = 0x100;
--
2.7.4

