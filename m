Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD6401F5A
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 19:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244293AbhIFRzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 13:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243962AbhIFRzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 13:55:09 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5C5C061575;
        Mon,  6 Sep 2021 10:54:04 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r21so5957994qtw.11;
        Mon, 06 Sep 2021 10:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2hKItWeebPyvylBL8MhOaSAfJQALDyW9ilZEFB/W+xU=;
        b=q49etGc0sY6hVWq+frNdVFnnhMfy3dfgeL2hd+rPW/xwRIjIYUWflnD5JQvB2NZrrA
         dWqhfbIWLCpfEc1vo1R10y4XAm7Ch0Y487YUf9YDDA75xGx6A9wvKkgN8ZA8oO5RtUlW
         sF0n4g4iMTbUd7j8q88evnGxNHKVMnF6BD4GOUuzwzYMO3+UAnieusBgtVDoCREK+GIz
         nqyGhm+6VEEB4Q4nYDSV8cCrsPzkg8SmjCyQOs589DU98NuyVfo7GYcjp1cNfPdglgm3
         WbDOOzcOxihwREFZAN8++zpCbG5+H558JRwoI0EG8I0+Wox9qjQAe08kMWa7/ihiXzWw
         YqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2hKItWeebPyvylBL8MhOaSAfJQALDyW9ilZEFB/W+xU=;
        b=S6o5+Lqf3Nzc9OJ7t93m2YxHAFlHamP0l+xoGQl3MG0liIR91pWX3XnKYm0jdmygqu
         vdur1t2a379GBiGgthlZVobR1nhlKBufX37xlGyQgVPYZUGHIhF9/nYKJZt+XY0l66je
         I8LyzCCiOOL8ALMm4tfYKKwngHh/fLbeekOYBGyOupztLmEB3v7eAL8Uvl1E0Kj1z4g5
         GssV8XH7ZYQwU71AFEm5Xk1DUfkEonNiyGtHVAb7LwjY+ANeWc6ULxN4Ys9Tm+Tq0X0H
         3hzsHsN2RLEyj46Ug36b2fN7aXgdlkvptEr8le9lyIpTwv1NQ9UjHX+0bltf4jOIVy/b
         2gsQ==
X-Gm-Message-State: AOAM5330obb69lCHAOWebb4oii6IpqB4Mw6WgnhxAJ6kDKtvTHAmIdKk
        R5avNrNVNbAp6cK4yHBAVmtsgzrZvIsRTw==
X-Google-Smtp-Source: ABdhPJyutF8z/b8rARNpr+SxAa87pGv0GFPPUcjFp7NQXb+ji1iejLqZcD2tDSzhuvZ2RrxV4Os09Q==
X-Received: by 2002:a05:622a:2c3:: with SMTP id a3mr11618554qtx.41.1630950843296;
        Mon, 06 Sep 2021 10:54:03 -0700 (PDT)
Received: from localhost.localdomain ([177.89.177.169])
        by smtp.gmail.com with ESMTPSA id w19sm6834735qki.21.2021.09.06.10.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 10:54:02 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: enable 6GHz channels
Date:   Mon,  6 Sep 2021 14:53:50 -0300
Message-Id: <20210906175350.13461-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds 6 GHz capabilities and reject HT/VHT

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 150 +++++++++++++++++++++++---
 1 file changed, 137 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ffa894f73..d36770db1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2988,6 +2988,118 @@ static const struct ieee80211_sband_iftype_data he_capa_5ghz[] = {
 #endif
 };
 
+static const struct ieee80211_sband_iftype_data he_capa_6ghz[] = {
+	{
+		/* TODO: should we support other types, e.g., P2P?*/
+		.types_mask = BIT(NL80211_IFTYPE_STATION) |
+			      BIT(NL80211_IFTYPE_AP),
+		.he_6ghz_capa = {
+			.capa = IEEE80211_HE_6GHZ_CAP_MIN_MPDU_START |
+			        IEEE80211_HE_6GHZ_CAP_MAX_AMPDU_LEN_EXP |
+			        IEEE80211_HE_6GHZ_CAP_MAX_MPDU_LEN |
+			        IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
+			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS,
+		},
+		.he_cap = {
+			.has_he = true,
+			.he_cap_elem = {
+				.mac_cap_info[0] =
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
+				.mac_cap_info[1] =
+					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
+					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
+				.mac_cap_info[2] =
+					IEEE80211_HE_MAC_CAP2_BSR |
+					IEEE80211_HE_MAC_CAP2_MU_CASCADING |
+					IEEE80211_HE_MAC_CAP2_ACK_EN,
+				.mac_cap_info[3] =
+					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
+					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_EXT_3,
+				.mac_cap_info[4] = IEEE80211_HE_MAC_CAP4_AMSDU_IN_AMPDU,
+				.phy_cap_info[0] =
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G,
+				.phy_cap_info[1] =
+					IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
+					IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
+					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
+					IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
+				.phy_cap_info[2] =
+					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
+					IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
+					IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ |
+					IEEE80211_HE_PHY_CAP2_UL_MU_FULL_MU_MIMO |
+					IEEE80211_HE_PHY_CAP2_UL_MU_PARTIAL_MU_MIMO,
+
+				/* Leave all the other PHY capability bytes
+				 * unset, as DCM, beam forming, RU and PPE
+				 * threshold information are not supported
+				 */
+			},
+			.he_mcs_nss_supp = {
+				.rx_mcs_80 = cpu_to_le16(0xfffa),
+				.tx_mcs_80 = cpu_to_le16(0xfffa),
+				.rx_mcs_160 = cpu_to_le16(0xfffa),
+				.tx_mcs_160 = cpu_to_le16(0xfffa),
+				.rx_mcs_80p80 = cpu_to_le16(0xfffa),
+				.tx_mcs_80p80 = cpu_to_le16(0xfffa),
+			},
+		},
+	},
+#ifdef CONFIG_MAC80211_MESH
+	{
+		/* TODO: should we support other types, e.g., IBSS?*/
+		.types_mask = BIT(NL80211_IFTYPE_MESH_POINT),
+		.he_6ghz_capa = {
+			.capa = IEEE80211_HE_6GHZ_CAP_MIN_MPDU_START |
+			        IEEE80211_HE_6GHZ_CAP_MAX_AMPDU_LEN_EXP |
+			        IEEE80211_HE_6GHZ_CAP_MAX_MPDU_LEN |
+			        IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
+			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS,
+		},
+		.he_cap = {
+			.has_he = true,
+			.he_cap_elem = {
+				.mac_cap_info[0] =
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
+				.mac_cap_info[1] =
+					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
+				.mac_cap_info[2] =
+					IEEE80211_HE_MAC_CAP2_ACK_EN,
+				.mac_cap_info[3] =
+					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
+					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_EXT_3,
+				.mac_cap_info[4] = IEEE80211_HE_MAC_CAP4_AMSDU_IN_AMPDU,
+				.phy_cap_info[0] =
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G,
+				.phy_cap_info[1] =
+					IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
+					IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
+					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
+					IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
+				.phy_cap_info[2] = 0,
+
+				/* Leave all the other PHY capability bytes
+				 * unset, as DCM, beam forming, RU and PPE
+				 * threshold information are not supported
+				 */
+			},
+			.he_mcs_nss_supp = {
+				.rx_mcs_80 = cpu_to_le16(0xfffa),
+				.tx_mcs_80 = cpu_to_le16(0xfffa),
+				.rx_mcs_160 = cpu_to_le16(0xfffa),
+				.tx_mcs_160 = cpu_to_le16(0xfffa),
+				.rx_mcs_80p80 = cpu_to_le16(0xfffa),
+				.tx_mcs_80p80 = cpu_to_le16(0xfffa),
+			},
+		},
+	},
+#endif
+};
+
 static void mac80211_hwsim_he_capab(struct ieee80211_supported_band *sband)
 {
 	u16 n_iftype_data;
@@ -3000,6 +3112,10 @@ static void mac80211_hwsim_he_capab(struct ieee80211_supported_band *sband)
 		n_iftype_data = ARRAY_SIZE(he_capa_5ghz);
 		sband->iftype_data =
 			(struct ieee80211_sband_iftype_data *)he_capa_5ghz;
+	} else if (sband->band == NL80211_BAND_6GHZ) {
+		n_iftype_data = ARRAY_SIZE(he_capa_6ghz);
+		sband->iftype_data =
+			(struct ieee80211_sband_iftype_data *)he_capa_6ghz;
 	} else {
 		return;
 	}
@@ -3290,6 +3406,12 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			sband->vht_cap.vht_mcs.tx_mcs_map =
 				sband->vht_cap.vht_mcs.rx_mcs_map;
 			break;
+		case NL80211_BAND_6GHZ:
+			sband->channels = data->channels_6ghz;
+			sband->n_channels = ARRAY_SIZE(hwsim_channels_6ghz);
+			sband->bitrates = data->rates + 4;
+			sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
+			break;
 		case NL80211_BAND_S1GHZ:
 			memcpy(&sband->s1g_cap, &hwsim_s1g_cap,
 			       sizeof(sband->s1g_cap));
@@ -3300,19 +3422,21 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			continue;
 		}
 
-		sband->ht_cap.ht_supported = true;
-		sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-				    IEEE80211_HT_CAP_GRN_FLD |
-				    IEEE80211_HT_CAP_SGI_20 |
-				    IEEE80211_HT_CAP_SGI_40 |
-				    IEEE80211_HT_CAP_DSSSCCK40;
-		sband->ht_cap.ampdu_factor = 0x3;
-		sband->ht_cap.ampdu_density = 0x6;
-		memset(&sband->ht_cap.mcs, 0,
-		       sizeof(sband->ht_cap.mcs));
-		sband->ht_cap.mcs.rx_mask[0] = 0xff;
-		sband->ht_cap.mcs.rx_mask[1] = 0xff;
-		sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+		if (band != NL80211_BAND_6GHZ){
+			sband->ht_cap.ht_supported = true;
+			sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+					    IEEE80211_HT_CAP_GRN_FLD |
+					    IEEE80211_HT_CAP_SGI_20 |
+					    IEEE80211_HT_CAP_SGI_40 |
+					    IEEE80211_HT_CAP_DSSSCCK40;
+			sband->ht_cap.ampdu_factor = 0x3;
+			sband->ht_cap.ampdu_density = 0x6;
+			memset(&sband->ht_cap.mcs, 0,
+			       sizeof(sband->ht_cap.mcs));
+			sband->ht_cap.mcs.rx_mask[0] = 0xff;
+			sband->ht_cap.mcs.rx_mask[1] = 0xff;
+			sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+		}
 
 		mac80211_hwsim_he_capab(sband);
 
-- 
2.25.1

