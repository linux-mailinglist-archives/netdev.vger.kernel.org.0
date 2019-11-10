Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442B0F698D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 16:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKJPNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 10:13:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33959 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfKJPNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 10:13:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id e6so12018294wrw.1
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 07:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LuAAPkGfKMuTrIuldymcw9Ta+Mtz30KKf5K7n/jHUBE=;
        b=jLxdLiwMyf4l7lfsVGGZlANJjosdidUdtUFp9nZdf4X1g6zB/mZJDrfLo8f1nY/Y22
         nTwiMIEuFWg8oFbaUiae7Z43sWjLq/gurF1qWAqIiB3lx1VWzbw9iQWyHHyjH5O779jK
         1WqDw83/T/6LWE85n8FGD4/QTyytpVLBlHo1lNZMzWFNi2uTnOu2ei2z9/ChJ95HWee5
         cMBoTwHTqNeQO+OSu5kEJvR0epfbKd/qhMI/NiLGHqINHfwqPUsaTUXboTxMcVNbQHiP
         usnNaVn30ME38q1MFL86HJvrpLZID8vig9pIKjUdProPAwINDw+rGxri9FUXUmsZgzYk
         y0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LuAAPkGfKMuTrIuldymcw9Ta+Mtz30KKf5K7n/jHUBE=;
        b=QL06fZmZUQppPym3VwbYRBfz2bqf8SWWhs//+PK+CwbPeTIiG5nR97Y8EavIJ+p9z5
         9IhnOBGZjsmiAF1mpHRK+nk99rIQBOUFVTt1qZ2UZ0IFa7oamu3UeJUMR5mQRHaD4/Lk
         YjOmcKtvbvtHbaU0vRWdBQuZ3ht8fiZ/V7j/b+JUBwWwPbDghXP94o2dZOcZyqHLKjcB
         yhiMvB4dOuzgme/pVmKr7L1/w1WXStbAukwecSzi5Y69iXjJVYC4VxSHLy/mFfzu4fEb
         B0lXnSPD9+y5YnqI6ATEowOTl2RX4mWjnWbLAZ/bi83SrK58/YUfCMMI1BTuqkEMlYTl
         vf+Q==
X-Gm-Message-State: APjAAAVfNCYwpn8+LKtCocY7TXEPE7briZGAYzeKlE0G8LLHTWNUYEol
        I6udaqVtNUwViLwVFjHFF5gnFSAO
X-Google-Smtp-Source: APXvYqwG5Pswuskxkyz5DMYQROrwFoLhqbvki2hgUGiCyoFWuA2VCg4JgX2x8oXoZY48YRx56VbfSQ==
X-Received: by 2002:a5d:5391:: with SMTP id d17mr18400817wrv.382.1573398821425;
        Sun, 10 Nov 2019 07:13:41 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:514f:9425:2755:f94a? (p200300EA8F4DA200514F94252755F94A.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:514f:9425:2755:f94a])
        by smtp.googlemail.com with ESMTPSA id t185sm17942290wmf.45.2019.11.10.07.13.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Nov 2019 07:13:40 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: add support for RTL8117
Message-ID: <7f4f2791-dbe4-efda-e430-a61795e1375e@gmail.com>
Date:   Sun, 10 Nov 2019 16:13:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for chip version RTL8117. Settings have been copied from
Realtek's r8168 driver, there however chip ID 54a belongs to a chip
version called RTL8168FP. It was confirmed that RTL8117 works with
Realtek's driver, so both chip versions seem to be the same or at
least compatible.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 135 +++++++++++++++++++---
 1 file changed, 120 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 249b68d00..c177837b9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -135,6 +135,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_49,
 	RTL_GIGA_MAC_VER_50,
 	RTL_GIGA_MAC_VER_51,
+	RTL_GIGA_MAC_VER_52,
 	RTL_GIGA_MAC_VER_60,
 	RTL_GIGA_MAC_VER_61,
 	RTL_GIGA_MAC_NONE
@@ -202,6 +203,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
+	[RTL_GIGA_MAC_VER_52] = {"RTL8117"				},
 	[RTL_GIGA_MAC_VER_60] = {"RTL8125"				},
 	[RTL_GIGA_MAC_VER_61] = {"RTL8125",		FIRMWARE_8125A_3},
 };
@@ -751,7 +753,7 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
 	       tp->mac_version != RTL_GIGA_MAC_VER_39 &&
-	       tp->mac_version <= RTL_GIGA_MAC_VER_51;
+	       tp->mac_version <= RTL_GIGA_MAC_VER_52;
 }
 
 static bool rtl_supports_eee(struct rtl8169_private *tp)
@@ -1290,9 +1292,7 @@ static void rtl8168_driver_start(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_31:
 		rtl8168dp_driver_start(tp);
 		break;
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		rtl8168ep_driver_start(tp);
 		break;
 	default:
@@ -1324,9 +1324,7 @@ static void rtl8168_driver_stop(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_31:
 		rtl8168dp_driver_stop(tp);
 		break;
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		rtl8168ep_driver_stop(tp);
 		break;
 	default:
@@ -1354,9 +1352,7 @@ static bool r8168_check_dash(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_check_dash(tp);
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		return r8168ep_check_dash(tp);
 	default:
 		return false;
@@ -1531,7 +1527,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		break;
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_52:
 		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
 			options |= PME_SIGNAL;
@@ -2170,6 +2166,9 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 		{ 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
 		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
 
+		/* RTL8117 */
+		{ 0x7cf, 0x54a,	RTL_GIGA_MAC_VER_52 },
+
 		/* 8168EP family. */
 		{ 0x7cf, 0x502,	RTL_GIGA_MAC_VER_51 },
 		{ 0x7cf, 0x501,	RTL_GIGA_MAC_VER_50 },
@@ -3336,6 +3335,46 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_enable_eee(tp);
 }
 
+static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->phydev;
+
+	/* CHN EST parameters adjust - fnet */
+	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x4800);
+	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xcc00);
+	r8168g_phy_param(phydev, 0x8092, 0xff00, 0xb000);
+
+	r8168g_phy_param(phydev, 0x8088, 0xff00, 0x6000);
+	r8168g_phy_param(phydev, 0x808b, 0x3f00, 0x0b00);
+	r8168g_phy_param(phydev, 0x808d, 0x1f00, 0x0600);
+	r8168g_phy_param(phydev, 0x808c, 0xff00, 0xb000);
+	r8168g_phy_param(phydev, 0x80a0, 0xff00, 0x2800);
+	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x5000);
+	r8168g_phy_param(phydev, 0x809b, 0xf800, 0xb000);
+	r8168g_phy_param(phydev, 0x809a, 0xff00, 0x4b00);
+	r8168g_phy_param(phydev, 0x809d, 0x3f00, 0x0800);
+	r8168g_phy_param(phydev, 0x80a1, 0xff00, 0x7000);
+	r8168g_phy_param(phydev, 0x809f, 0x1f00, 0x0300);
+	r8168g_phy_param(phydev, 0x809e, 0xff00, 0x8800);
+	r8168g_phy_param(phydev, 0x80b2, 0xff00, 0x2200);
+	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x9800);
+	r8168g_phy_param(phydev, 0x80af, 0x3f00, 0x0800);
+	r8168g_phy_param(phydev, 0x80b3, 0xff00, 0x6f00);
+	r8168g_phy_param(phydev, 0x80b1, 0x1f00, 0x0300);
+	r8168g_phy_param(phydev, 0x80b0, 0xff00, 0x9300);
+
+	r8168g_phy_param(phydev, 0x8011, 0x0000, 0x0800);
+
+	/* enable GPHY 10M */
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
+
+	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
+
+	rtl8168g_disable_aldps(tp);
+	rtl8168h_config_eee_phy(tp);
+	rtl_enable_eee(tp);
+}
+
 static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
 {
 	static const struct phy_reg phy_reg_init[] = {
@@ -3564,6 +3603,7 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
 		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
 	};
@@ -3657,7 +3697,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_32:
 	case RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_52:
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
 		break;
@@ -3693,6 +3733,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_48:
 	case RTL_GIGA_MAC_VER_50:
 	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_52:
 	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
@@ -3724,6 +3765,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_48:
 	case RTL_GIGA_MAC_VER_50:
 	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_52:
 	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
@@ -3755,7 +3797,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_38:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
@@ -3941,7 +3983,7 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 		rtl_udelay_loop_wait_low(tp, &rtl_npq_cond, 20, 42*42);
 		break;
 	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
 		rtl_udelay_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
 		break;
@@ -4787,6 +4829,68 @@ static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
+static void rtl_hw_start_8117(struct rtl8169_private *tp)
+{
+	static const struct ephy_info e_info_8117[] = {
+		{ 0x19, 0x0040,	0x1100 },
+		{ 0x59, 0x0040,	0x1100 },
+	};
+	int rg_saw_cnt;
+
+	rtl8168ep_stop_cmac(tp);
+
+	/* disable aspm and clock request before access ephy */
+	rtl_hw_aspm_clkreq_enable(tp, false);
+	rtl_ephy_init(tp, e_info_8117);
+
+	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
+	rtl8168g_set_pause_thresholds(tp, 0x2f, 0x5f);
+
+	rtl_set_def_aspm_entry_latency(tp);
+
+	rtl_reset_packet_filter(tp);
+
+	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f90);
+
+	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
+
+	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+
+	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
+	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
+
+	rtl8168_config_eee_mac(tp);
+
+	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
+	RTL_W8(tp, MISC_1, RTL_R8(tp, MISC_1) & ~PFM_D3COLD_EN);
+
+	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~TX_10M_PS_EN);
+
+	rtl_eri_clear_bits(tp, 0x1b0, ERIAR_MASK_0011, BIT(12));
+
+	rtl_pcie_state_l2l3_disable(tp);
+
+	rg_saw_cnt = phy_read_paged(tp->phydev, 0x0c42, 0x13) & 0x3fff;
+	if (rg_saw_cnt > 0) {
+		u16 sw_cnt_1ms_ini;
+
+		sw_cnt_1ms_ini = (16000000 / rg_saw_cnt) & 0x0fff;
+		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
+	}
+
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_write(tp, 0xea80, 0x0003);
+	r8168_mac_ocp_modify(tp, 0xe052, 0x0000, 0x0009);
+	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
+
+	r8168_mac_ocp_write(tp, 0xe63e, 0x0001);
+	r8168_mac_ocp_write(tp, 0xe63e, 0x0000);
+	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
+	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
+
+	rtl_hw_aspm_clkreq_enable(tp, true);
+}
+
 static void rtl_hw_start_8102e_1(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8102e_1[] = {
@@ -5074,6 +5178,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_49] = rtl_hw_start_8168ep_1,
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
+		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
 		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125_1,
 		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125_2,
 	};
@@ -6620,7 +6725,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		rtl8168ep_stop_cmac(tp);
 		/* fall through */
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
-- 
2.24.0

