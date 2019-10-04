Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF83CB67B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbfJDIgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:36:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43546 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729311AbfJDIgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:55 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D34C4F2B6CD4AE77E543;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:44 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 1/8] rtlwifi: rtl8821ae: Remove set but not used variables 'rtstatus','bd'
Date:   Fri, 4 Oct 2019 16:43:48 +0800
Message-ID: <1570178635-57582-2-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function rtl8812ae_phy_config_rf_with_headerfile:
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2079:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function rtl8821ae_phy_config_rf_with_headerfile:
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2114:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function _rtl8812ae_phy_get_txpower_limit:
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2354:6: warning: variable bd set but not used [-Wunused-but-set-variable]

They are not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 979e434..c54b80d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -2076,7 +2076,6 @@ static bool _rtl8821ae_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					     enum radio_path rfpath)
 {
-	bool rtstatus = true;
 	u32 *radioa_array_table_a, *radioa_array_table_b;
 	u16 radioa_arraylen_a, radioa_arraylen_b;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -2088,7 +2087,6 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "Radio_A:RTL8821AE_RADIOA_ARRAY %d\n", radioa_arraylen_a);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
-	rtstatus = true;
 	switch (rfpath) {
 	case RF90_PATH_A:
 		return __rtl8821ae_phy_config_with_headerfile(hw,
@@ -2111,7 +2109,6 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 						enum radio_path rfpath)
 {
-	bool rtstatus = true;
 	u32 *radioa_array_table;
 	u16 radioa_arraylen;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -2121,7 +2118,6 @@ bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "Radio_A:RTL8821AE_RADIOA_ARRAY %d\n", radioa_arraylen);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
-	rtstatus = true;
 	switch (rfpath) {
 	case RF90_PATH_A:
 		return __rtl8821ae_phy_config_with_headerfile(hw,
@@ -2351,7 +2347,7 @@ static s8 _rtl8812ae_phy_get_txpower_limit(struct ieee80211_hw *hw,
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	short band_temp = -1, regulation = -1, bandwidth_temp = -1,
 		 rate_section = -1, channel_temp = -1;
-	u16 bd, regu, bdwidth, sec, chnl;
+	u16 regu, bdwidth, sec, chnl;
 	s8 power_limit = MAX_POWER_INDEX;

 	if (rtlefuse->eeprom_regulatory == 2)
@@ -2472,7 +2468,6 @@ static s8 _rtl8812ae_phy_get_txpower_limit(struct ieee80211_hw *hw,
 		return MAX_POWER_INDEX;
 	}

-	bd = band_temp;
 	regu = regulation;
 	bdwidth = bandwidth_temp;
 	sec = rate_section;
--
2.7.4

