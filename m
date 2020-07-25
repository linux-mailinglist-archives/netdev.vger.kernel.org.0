Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6D22D9B7
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 21:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgGYT4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 15:56:15 -0400
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:35978 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728031AbgGYT4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 15:56:14 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 52D601802926E;
        Sat, 25 Jul 2020 19:56:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:4:41:69:355:379:541:800:960:968:973:988:989:1260:1311:1314:1345:1359:1437:1515:1605:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2895:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:6117:6261:7974:8603:8829:8957:9036:9040:10004:10848:10954:11026:11473:11657:11658:11914:12043:12294:12296:12297:12438:12555:12663:12679:12895:12986:13894:13972:14394:21080:21324:21451:21524:21627:21990:30025:30045:30054:30070:30079,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: crate12_2b11bdc26f52
X-Filterd-Recvd-Size: 19662
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:56:10 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] rtlwifi: Better spacing around rtl_dbg uses
Date:   Sat, 25 Jul 2020 12:55:05 -0700
Message-Id: <bb23cb0dacca0f8ebf582dc1ed67c9f8f44a2722.1595706420.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a more typical kernel style for rtl_dbg uses.

Miscellanea:

o Remove unnecessary braces and unindent a case statement
o Realign or'd values and add parentheses

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c     |  4 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.c   | 36 +++++++--------
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.c  | 10 ++---
 .../rtlwifi/rtl8723ae/hal_bt_coexist.c        |  6 ++-
 .../realtek/rtlwifi/rtl8723ae/hal_btc.c       |  6 ++-
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 44 +++++++++----------
 10 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 949fe8278cae..38442a36f599 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -901,7 +901,7 @@ void rtl_p2p_ps_cmd(struct ieee80211_hw *hw , u8 p2p_ps_state)
 	struct rtl_ps_ctl *rtlps = rtl_psc(rtl_priv(hw));
 	struct rtl_p2p_ps_info  *p2pinfo = &(rtlpriv->psc.p2p_ps_info);
 
-	rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, " p2p state %x\n" , p2p_ps_state);
+	rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, " p2p state %x\n", p2p_ps_state);
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
 		p2pinfo->p2p_ps_state = p2p_ps_state;
@@ -955,7 +955,7 @@ void rtl_p2p_ps_cmd(struct ieee80211_hw *hw , u8 p2p_ps_state)
 	}
 	rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD,
 		"ctwindow %x oppps %x\n",
-		p2pinfo->ctwindow , p2pinfo->opp_ps);
+		p2pinfo->ctwindow, p2pinfo->opp_ps);
 	rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD,
 		"count %x duration %x index %x interval %x start time %x noa num %x\n",
 		p2pinfo->noa_count_type[0],
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 8433b54159ff..2a751801e35f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1561,7 +1561,7 @@ static void read_power_value_fromprom(struct ieee80211_hw *hw,
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
 		"hal_ReadPowerValueFromPROM88E():PROMContent[0x%x]=0x%x\n",
-		(eeaddr+1), hwinfo[eeaddr+1]);
+		eeaddr + 1, hwinfo[eeaddr + 1]);
 	if (0xFF == hwinfo[eeaddr+1])  /*YJ,add,120316*/
 		autoload_fail = true;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index f2a9cbbc31ed..ff88c09be601 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1438,7 +1438,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, REG_TCR, value32);
 	value32 |= TSFRST;
 	rtl_write_dword(rtlpriv, REG_TCR, value32);
-	rtl_dbg(rtlpriv, COMP_INIT|COMP_BEACON, DBG_LOUD,
+	rtl_dbg(rtlpriv, COMP_INIT | COMP_BEACON, DBG_LOUD,
 		"SetBeaconRelatedRegisters8192CUsb(): Set TCR(%x)\n",
 		value32);
 	/* TODO: Modify later (Find the right parameters)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 31677e563b03..88b7a715f4c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -36,7 +36,7 @@ static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 	u32 pagenums, remainsize;
 	u32 page, offset;
 
-	rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD , "FW size is %d bytes,\n", size);
+	rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, "FW size is %d bytes,\n", size);
 
 	rtl_fill_dummy(bufferptr, &size);
 
@@ -119,7 +119,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	pfwdata = (u8 *)rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 	rtl_dbg(rtlpriv, COMP_FW, DBG_DMESG,
-		"normal Firmware SIZE %d\n" , fwsize);
+		"normal Firmware SIZE %d\n", fwsize);
 
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		rtl_dbg(rtlpriv, COMP_FW, DBG_DMESG,
@@ -180,12 +180,12 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 
 	if (ppsc->dot11_psmode != EACTIVE ||
 	    ppsc->inactive_pwrstate == ERFOFF) {
-		rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+		rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 			"FillH2CCommand8192E(): Return because RF is off!!!\n");
 		return;
 	}
 
-	rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD , "come in\n");
+	rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD, "come in\n");
 
 	/* 1. Prevent race condition in setting H2C cmd.
 	 * (copy from MgntActSet_RF_State().)
@@ -193,7 +193,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 	while (true) {
 		spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
 		if (rtlhal->h2c_setinprogress) {
-			rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+			rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 				"H2C set in progress! Wait to set..element_id(%d).\n",
 				element_id);
 
@@ -201,7 +201,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 				spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock,
 						       flag);
 				h2c_waitcounter++;
-				rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+				rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 					"Wait 100 us (%d times)...\n",
 					h2c_waitcounter);
 				udelay(100);
@@ -263,7 +263,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 			while (!isfw_read) {
 				wait_h2c_limmit--;
 				if (wait_h2c_limmit == 0) {
-					rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+					rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 						"Waiting too long for FW read clear HMEBox(%d)!!!\n",
 						boxnum);
 					break;
@@ -272,7 +272,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 				isfw_read =
 				  _rtl92ee_check_fw_read_last_h2c(hw, boxnum);
 				u1b_tmp = rtl_read_byte(rtlpriv, 0x130);
-				rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+				rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 					"Waiting for FW read clear HMEBox(%d)!!! 0x130 = %2x\n",
 					boxnum, u1b_tmp);
 			}
@@ -282,7 +282,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		 * H2C cmd, break and give up this H2C.
 		 */
 		if (!isfw_read) {
-			rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+			rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 				"Write H2C reg BOX[%d] fail,Fw don't read.\n",
 				boxnum);
 			break;
@@ -291,7 +291,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		memset(boxcontent, 0, sizeof(boxcontent));
 		memset(boxextcontent, 0, sizeof(boxextcontent));
 		boxcontent[0] = element_id;
-		rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+		rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 			"Write element_id box_reg(%4x) = %2x\n",
 			box_reg, element_id);
 
@@ -340,7 +340,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 		if (rtlhal->last_hmeboxnum == 4)
 			rtlhal->last_hmeboxnum = 0;
 
-		rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD ,
+		rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD,
 			"pHalData->last_hmeboxnum  = %d\n",
 			rtlhal->last_hmeboxnum);
 	}
@@ -349,7 +349,7 @@ static void _rtl92ee_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 	rtlhal->h2c_setinprogress = false;
 	spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
 
-	rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD , "go out\n");
+	rtl_dbg(rtlpriv, COMP_CMD, DBG_LOUD, "go out\n");
 }
 
 void rtl92ee_fill_h2c_cmd(struct ieee80211_hw *hw,
@@ -388,7 +388,7 @@ void rtl92ee_firmware_selfreset(struct ieee80211_hw *hw)
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, (u1b_tmp | BIT(2)));
 
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD ,
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
 		"  _8051Reset92E(): 8051 reset success .\n");
 }
 
@@ -750,7 +750,7 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		b_dlok = true;
 
 	if (b_dlok) {
-		rtl_dbg(rtlpriv, COMP_POWER, DBG_LOUD ,
+		rtl_dbg(rtlpriv, COMP_POWER, DBG_LOUD,
 			"Set RSVD page location to Fw.\n");
 		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD ,
 			      "H2C_RSVDPAGE:\n", u1rsvdpageloc, 3);
@@ -783,11 +783,11 @@ void rtl92ee_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
-		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD , "P2P_PS_DISABLE\n");
+		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_DISABLE\n");
 		memset(p2p_ps_offload, 0, sizeof(*p2p_ps_offload));
 		break;
 	case P2P_PS_ENABLE:
-		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD , "P2P_PS_ENABLE\n");
+		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_ENABLE\n");
 		/* update CTWindow value. */
 		if (p2pinfo->ctwindow > 0) {
 			p2p_ps_offload->ctwindow_en = 1;
@@ -838,11 +838,11 @@ void rtl92ee_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state)
 		}
 		break;
 	case P2P_PS_SCAN:
-		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD , "P2P_PS_SCAN\n");
+		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_SCAN\n");
 		p2p_ps_offload->discovery = 1;
 		break;
 	case P2P_PS_SCAN_DONE:
-		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD , "P2P_PS_SCAN_DONE\n");
+		rtl_dbg(rtlpriv, COMP_FW, DBG_LOUD, "P2P_PS_SCAN_DONE\n");
 		p2p_ps_offload->discovery = 0;
 		p2pinfo->p2p_ps_state = P2P_PS_ENABLE;
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index e1b4755a7ea9..469dbdba57ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -663,7 +663,7 @@ static bool _rtl92ee_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	arraylength = RTL8192EE_MAC_ARRAY_LEN;
 	ptrarray = RTL8192EE_MAC_ARRAY;
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"Img:RTL8192EE_MAC_ARRAY LEN %d\n" , arraylength);
+		"Img:RTL8192EE_MAC_ARRAY LEN %d\n", arraylength);
 	for (i = 0; i < arraylength; i = i + 2)
 		rtl_write_byte(rtlpriv, ptrarray[i], (u8)ptrarray[i + 1]);
 	return true;
@@ -915,7 +915,7 @@ bool rtl92ee_phy_config_rf_with_headerfile(struct ieee80211_hw  *hw,
 		len = RTL8192EE_RADIOA_ARRAY_LEN;
 		array = RTL8192EE_RADIOA_ARRAY;
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-			"Radio_A:RTL8192EE_RADIOA_ARRAY %d\n" , len);
+			"Radio_A:RTL8192EE_RADIOA_ARRAY %d\n", len);
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
 		for (i = 0; i < len; i = i + 2) {
 			v1 = array[i];
@@ -962,7 +962,7 @@ bool rtl92ee_phy_config_rf_with_headerfile(struct ieee80211_hw  *hw,
 		len = RTL8192EE_RADIOB_ARRAY_LEN;
 		array = RTL8192EE_RADIOB_ARRAY;
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-			"Radio_A:RTL8192EE_RADIOB_ARRAY %d\n" , len);
+			"Radio_A:RTL8192EE_RADIOB_ARRAY %d\n", len);
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "Radio No %x\n", rfpath);
 		for (i = 0; i < len; i = i + 2) {
 			v1 = array[i];
@@ -2724,7 +2724,7 @@ static void _rtl92ee_phy_set_rfpath_switch(struct ieee80211_hw *hw,
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
-	rtl_dbg(rtlpriv, COMP_INIT , DBG_LOUD , "\n");
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "\n");
 
 	if (is_hal_stop(rtlhal)) {
 		u8 u1btmp;
@@ -2998,7 +2998,7 @@ static void rtl92ee_phy_set_io(struct ieee80211_hw *hw)
 	case IO_CMD_RESUME_DM_BY_SCAN:
 		rtl92ee_dm_write_dig(hw, rtlphy->initgain_backup.xaagccore1);
 		rtl92ee_dm_write_cck_cca_thres(hw, rtlphy->initgain_backup.cca);
-		rtl_dbg(rtlpriv, COMP_CMD, DBG_TRACE , "no set txpower\n");
+		rtl_dbg(rtlpriv, COMP_CMD, DBG_TRACE, "no set txpower\n");
 		rtl92ee_phy_set_txpower_level(hw, rtlphy->current_channel);
 		break;
 	case IO_CMD_PAUSE_BAND0_DM_BY_SCAN:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
index 4459c7f82f06..bfa736138034 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
@@ -369,8 +369,10 @@ void rtl8723e_dm_bt_balance(struct ieee80211_hw *hw,
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
 		"[DM][BT], Balance=[%s:%dms:%dms], write 0xc=0x%x\n",
-		balance_on ? "ON" : "OFF", ms0, ms1, h2c_parameter[0]<<16 |
-		h2c_parameter[1]<<8 | h2c_parameter[2]);
+		balance_on ? "ON" : "OFF", ms0, ms1,
+		(h2c_parameter[0] << 16 |
+		 h2c_parameter[1] << 8 |
+		 h2c_parameter[2]));
 
 	rtl8723e_fill_h2c_cmd(hw, 0xc, 3, h2c_parameter);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index 3cc9dd29eac5..879fbe6ed4c3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -70,7 +70,9 @@ void rtl_8723e_bt_wifi_media_status_notify(struct ieee80211_hw *hw,
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
 		"[BTCoex], FW write 0x19=0x%x\n",
-		h2c_parameter[0]<<16|h2c_parameter[1]<<8|h2c_parameter[2]);
+		(h2c_parameter[0] << 16 |
+		 h2c_parameter[1] << 8 |
+		 h2c_parameter[2]));
 
 	rtl8723e_fill_h2c_cmd(hw, 0x19, 3, h2c_parameter);
 }
@@ -1704,7 +1706,7 @@ void rtl_8723e_c2h_command_handle(struct ieee80211_hw *hw)
 	c2h_event.cmd_seq = rtl_read_byte(rtlpriv, REG_C2HEVT_MSG_NORMAL + 1);
 	rtl_dbg(rtlpriv, COMP_FW, DBG_DMESG,
 		"cmd_id: %d, cmd_len: %d, cmd_seq: %d\n",
-		c2h_event.cmd_id , c2h_event.cmd_len, c2h_event.cmd_seq);
+		c2h_event.cmd_id, c2h_event.cmd_len, c2h_event.cmd_seq);
 	u1b_tmp = rtl_read_byte(rtlpriv, 0x01AF);
 	if (u1b_tmp == C2H_EVT_HOST_CLOSE) {
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 7351fd41366d..9f4a9f3c0f60 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -1651,7 +1651,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 				"[Path-%c] PowerIndexOffset(%d) =DeltaPowerIndex(%d) -DeltaPowerIndexLast(%d)\n",
 				(p == RF90_PATH_A ? 'A' : 'B'),
 				rtldm->power_index_offset[p],
-				rtldm->delta_power_index[p] ,
+				rtldm->delta_power_index[p],
 				rtldm->delta_power_index_last[p]);
 
 			rtldm->ofdm_index[p] =
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index ff20d84daced..55f3e0f3b8f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -761,7 +761,7 @@ void rtl8821ae_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		u32	us_nav_upper = *(u32 *)val;
 
 		if (us_nav_upper > HAL_92C_NAV_UPPER_UNIT * 0xFF) {
-			rtl_dbg(rtlpriv, COMP_INIT , DBG_WARNING,
+			rtl_dbg(rtlpriv, COMP_INIT, DBG_WARNING,
 				"The setting value (0x%08X us) of NAV_UPPER is larger than (%d * 0xFF)!!!\n",
 				us_nav_upper, HAL_92C_NAV_UPPER_UNIT);
 			break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 0aaf532375cd..1c6988d6d597 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -3722,7 +3722,7 @@ static void _rtl8821ae_iqk_rx_fill_iqc(struct ieee80211_hw *hw,
 		rtl_set_bbreg(hw, 0xc10, 0x03ff0000, rx_y>>1);
 		rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
 			"rx_x = %x;;rx_y = %x ====>fill to IQC\n",
-			rx_x>>1, rx_y>>1);
+			rx_x >> 1, rx_y >> 1);
 		rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
 			"0xc10 = %x ====>fill to IQC\n",
 			rtl_read_dword(rtlpriv, 0xc10));
@@ -4028,21 +4028,21 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 						}
 						break;
 					case 2:
-						{
-							rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
-								"VDF_Y[1] = %x;;;VDF_Y[0] = %x\n",
-								vdf_y[1]>>21 & 0x00007ff, vdf_y[0]>>21 & 0x00007ff);
-							rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
-								"VDF_X[1] = %x;;;VDF_X[0] = %x\n",
-								vdf_x[1]>>21 & 0x00007ff, vdf_x[0]>>21 & 0x00007ff);
-							rx_dt[cal] = (vdf_y[1]>>20)-(vdf_y[0]>>20);
-							rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD, "Rx_dt = %d\n", rx_dt[cal]);
-							rx_dt[cal] = ((16*rx_dt[cal])*10000/13823);
-							rx_dt[cal] = (rx_dt[cal] >> 1)+(rx_dt[cal] & BIT(0));
-							rtl_write_dword(rtlpriv, 0xc80, 0x18008c20);/* TX_TONE_idx[9:0], TxK_Mask[29] TX_Tone = 16 */
-							rtl_write_dword(rtlpriv, 0xc84, 0x38008c20);/* RX_TONE_idx[9:0], RxK_Mask[29] */
-							rtl_set_bbreg(hw, 0xce8, 0x00003fff, rx_dt[cal] & 0x00003fff);
-						}
+						rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
+							"VDF_Y[1] = %x;;;VDF_Y[0] = %x\n",
+							vdf_y[1] >> 21 & 0x00007ff,
+							vdf_y[0] >> 21 & 0x00007ff);
+						rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
+							"VDF_X[1] = %x;;;VDF_X[0] = %x\n",
+							vdf_x[1] >> 21 & 0x00007ff,
+							vdf_x[0] >> 21 & 0x00007ff);
+						rx_dt[cal] = (vdf_y[1] >> 20) - (vdf_y[0] >> 20);
+						rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD, "Rx_dt = %d\n", rx_dt[cal]);
+						rx_dt[cal] = ((16 * rx_dt[cal]) * 10000 / 13823);
+						rx_dt[cal] = (rx_dt[cal] >> 1) + (rx_dt[cal] & BIT(0));
+						rtl_write_dword(rtlpriv, 0xc80, 0x18008c20);/* TX_TONE_idx[9:0], TxK_Mask[29] TX_Tone = 16 */
+						rtl_write_dword(rtlpriv, 0xc84, 0x38008c20);/* RX_TONE_idx[9:0], RxK_Mask[29] */
+						rtl_set_bbreg(hw, 0xce8, 0x00003fff, rx_dt[cal] & 0x00003fff);
 						break;
 					default:
 						break;
@@ -4359,13 +4359,13 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 
 		for (i = 0; i < tx_average; i++) {
 			rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
-				"TX_X0_RXK[%d] = %x ;; TX_Y0_RXK[%d] = %x\n", i,
-				(tx_x0_rxk[i])>>21&0x000007ff, i,
-				(tx_y0_rxk[i])>>21&0x000007ff);
+				"TX_X0_RXK[%d] = %x ;; TX_Y0_RXK[%d] = %x\n",
+				i, (tx_x0_rxk[i]) >> 21 & 0x000007ff,
+				i, (tx_y0_rxk[i]) >> 21 & 0x000007ff);
 			rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD,
-				"TX_X0[%d] = %x ;; TX_Y0[%d] = %x\n", i,
-				(tx_x0[i])>>21&0x000007ff, i,
-				(tx_y0[i])>>21&0x000007ff);
+				"TX_X0[%d] = %x ;; TX_Y0[%d] = %x\n",
+				i, (tx_x0[i]) >> 21 & 0x000007ff,
+				i, (tx_y0[i]) >> 21 & 0x000007ff);
 		}
 		for (i = 0; i < tx_average; i++) {
 			for (ii = i+1; ii < tx_average; ii++) {
-- 
2.26.0

