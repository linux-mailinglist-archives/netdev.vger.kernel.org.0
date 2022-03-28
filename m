Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA1D4EA275
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 23:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiC1Vf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 17:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiC1Vf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 17:35:57 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515F8175864;
        Mon, 28 Mar 2022 14:33:53 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 384A2FBBA4; Mon, 28 Mar 2022 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648502963; bh=ToZ6brGGLvbP5LoOA3w0ui5rR7aJZ5TWE/SGK7H0qsA=;
        h=From:To:Cc:Subject:Date:From;
        b=KartjoFwrmAC1BHVF7PYSKQnx8rPgCn96EjULALP7Fnri4bAM9gbbfspxvndVA0p4
         5ALdjx7aT1LmixBXrL2VTK0LOsHt0zYgEBWBAMvdF6LCnvur7/qnBUfudc+CLdaEHt
         Q+bWfdpcpPDZDiaXd5Fm+8An4zQfOIt5VubqDGjlkgzqUrfoRL/vRoYjyxc4luI70l
         Sdp38aG7LH2i2fkPdAr9tSNtg7Gy7mhdkuBGQNRiJWiVdMDTplO506VutHa7sDcrXP
         rorMUCfV5cqv1KEAvG8Z9n9xpKnh4a+awV/FyBS+QAtEbJb2stdTiSSZgvWhv7nWqD
         6fYFdhN8AKkeQ==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 933E7FB638;
        Mon, 28 Mar 2022 21:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648502960; bh=ToZ6brGGLvbP5LoOA3w0ui5rR7aJZ5TWE/SGK7H0qsA=;
        h=From:To:Cc:Subject:Date:From;
        b=wivsb7uRSdbeZ0o6zy5Y8yCdnXguKIVrn/+UTA7Bi3U4cvTCgsbgE3GGQxnWzUuOA
         fiFwUAYCSPqozekMkiEGJ0T2hzmU1GXHKk+mQUWmOuSI12TcB0KomZjZKDkthko32E
         qMVVuR/uc//9csiozql9LkC7/UI8Ffap5OcxaZL7tUAoFKL0ONfDZji2rv1BePXf/f
         HTktnBJOm+73k7ocmP/YwW0sFzQ/XztysRAoa9Ux8OBG40dHOSEAeAjSguRbPfDbej
         smxFunZZcqJz/1JqPUqVSuhjrOOWskUfvaF0Pc0xQiIRU4Znz6w8Pjco3cO1kw/oem
         kdKTKW6lDvAFg==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     loic.poulain@linaro.org
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH v3] wcn36xx: Improve readability of wcn36xx_caps_name
Date:   Mon, 28 Mar 2022 23:29:12 +0200
Message-Id: <20220328212912.283393-1-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use macros to force strict ordering of the elements.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 126 ++++++++++++------------
 1 file changed, 65 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 95ea7d040d8c..ac9465dfae64 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -192,70 +192,74 @@ static inline u8 get_sta_index(struct ieee80211_vif *vif,
 	       sta_priv->sta_index;
 }
 
+#define DEFINE(s) [s] = #s
+
 static const char * const wcn36xx_caps_names[] = {
-	"MCC",				/* 0 */
-	"P2P",				/* 1 */
-	"DOT11AC",			/* 2 */
-	"SLM_SESSIONIZATION",		/* 3 */
-	"DOT11AC_OPMODE",		/* 4 */
-	"SAP32STA",			/* 5 */
-	"TDLS",				/* 6 */
-	"P2P_GO_NOA_DECOUPLE_INIT_SCAN",/* 7 */
-	"WLANACTIVE_OFFLOAD",		/* 8 */
-	"BEACON_OFFLOAD",		/* 9 */
-	"SCAN_OFFLOAD",			/* 10 */
-	"ROAM_OFFLOAD",			/* 11 */
-	"BCN_MISS_OFFLOAD",		/* 12 */
-	"STA_POWERSAVE",		/* 13 */
-	"STA_ADVANCED_PWRSAVE",		/* 14 */
-	"AP_UAPSD",			/* 15 */
-	"AP_DFS",			/* 16 */
-	"BLOCKACK",			/* 17 */
-	"PHY_ERR",			/* 18 */
-	"BCN_FILTER",			/* 19 */
-	"RTT",				/* 20 */
-	"RATECTRL",			/* 21 */
-	"WOW",				/* 22 */
-	"WLAN_ROAM_SCAN_OFFLOAD",	/* 23 */
-	"SPECULATIVE_PS_POLL",		/* 24 */
-	"SCAN_SCH",			/* 25 */
-	"IBSS_HEARTBEAT_OFFLOAD",	/* 26 */
-	"WLAN_SCAN_OFFLOAD",		/* 27 */
-	"WLAN_PERIODIC_TX_PTRN",	/* 28 */
-	"ADVANCE_TDLS",			/* 29 */
-	"BATCH_SCAN",			/* 30 */
-	"FW_IN_TX_PATH",		/* 31 */
-	"EXTENDED_NSOFFLOAD_SLOT",	/* 32 */
-	"CH_SWITCH_V1",			/* 33 */
-	"HT40_OBSS_SCAN",		/* 34 */
-	"UPDATE_CHANNEL_LIST",		/* 35 */
-	"WLAN_MCADDR_FLT",		/* 36 */
-	"WLAN_CH144",			/* 37 */
-	"NAN",				/* 38 */
-	"TDLS_SCAN_COEXISTENCE",	/* 39 */
-	"LINK_LAYER_STATS_MEAS",	/* 40 */
-	"MU_MIMO",			/* 41 */
-	"EXTENDED_SCAN",		/* 42 */
-	"DYNAMIC_WMM_PS",		/* 43 */
-	"MAC_SPOOFED_SCAN",		/* 44 */
-	"BMU_ERROR_GENERIC_RECOVERY",	/* 45 */
-	"DISA",				/* 46 */
-	"FW_STATS",			/* 47 */
-	"WPS_PRBRSP_TMPL",		/* 48 */
-	"BCN_IE_FLT_DELTA",		/* 49 */
-	"TDLS_OFF_CHANNEL",		/* 51 */
-	"RTT3",				/* 52 */
-	"MGMT_FRAME_LOGGING",		/* 53 */
-	"ENHANCED_TXBD_COMPLETION",	/* 54 */
-	"LOGGING_ENHANCEMENT",		/* 55 */
-	"EXT_SCAN_ENHANCED",		/* 56 */
-	"MEMORY_DUMP_SUPPORTED",	/* 57 */
-	"PER_PKT_STATS_SUPPORTED",	/* 58 */
-	"EXT_LL_STAT",			/* 60 */
-	"WIFI_CONFIG",			/* 61 */
-	"ANTENNA_DIVERSITY_SELECTION",	/* 62 */
+	DEFINE(MCC),
+	DEFINE(P2P),
+	DEFINE(DOT11AC),
+	DEFINE(SLM_SESSIONIZATION),
+	DEFINE(DOT11AC_OPMODE),
+	DEFINE(SAP32STA),
+	DEFINE(TDLS),
+	DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
+	DEFINE(WLANACTIVE_OFFLOAD),
+	DEFINE(BEACON_OFFLOAD),
+	DEFINE(SCAN_OFFLOAD),
+	DEFINE(ROAM_OFFLOAD),
+	DEFINE(BCN_MISS_OFFLOAD),
+	DEFINE(STA_POWERSAVE),
+	DEFINE(STA_ADVANCED_PWRSAVE),
+	DEFINE(AP_UAPSD),
+	DEFINE(AP_DFS),
+	DEFINE(BLOCKACK),
+	DEFINE(PHY_ERR),
+	DEFINE(BCN_FILTER),
+	DEFINE(RTT),
+	DEFINE(RATECTRL),
+	DEFINE(WOW),
+	DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
+	DEFINE(SPECULATIVE_PS_POLL),
+	DEFINE(SCAN_SCH),
+	DEFINE(IBSS_HEARTBEAT_OFFLOAD),
+	DEFINE(WLAN_SCAN_OFFLOAD),
+	DEFINE(WLAN_PERIODIC_TX_PTRN),
+	DEFINE(ADVANCE_TDLS),
+	DEFINE(BATCH_SCAN),
+	DEFINE(FW_IN_TX_PATH),
+	DEFINE(EXTENDED_NSOFFLOAD_SLOT),
+	DEFINE(CH_SWITCH_V1),
+	DEFINE(HT40_OBSS_SCAN),
+	DEFINE(UPDATE_CHANNEL_LIST),
+	DEFINE(WLAN_MCADDR_FLT),
+	DEFINE(WLAN_CH144),
+	DEFINE(NAN),
+	DEFINE(TDLS_SCAN_COEXISTENCE),
+	DEFINE(LINK_LAYER_STATS_MEAS),
+	DEFINE(MU_MIMO),
+	DEFINE(EXTENDED_SCAN),
+	DEFINE(DYNAMIC_WMM_PS),
+	DEFINE(MAC_SPOOFED_SCAN),
+	DEFINE(BMU_ERROR_GENERIC_RECOVERY),
+	DEFINE(DISA),
+	DEFINE(FW_STATS),
+	DEFINE(WPS_PRBRSP_TMPL),
+	DEFINE(BCN_IE_FLT_DELTA),
+	DEFINE(TDLS_OFF_CHANNEL),
+	DEFINE(RTT3),
+	DEFINE(MGMT_FRAME_LOGGING),
+	DEFINE(ENHANCED_TXBD_COMPLETION),
+	DEFINE(LOGGING_ENHANCEMENT),
+	DEFINE(EXT_SCAN_ENHANCED),
+	DEFINE(MEMORY_DUMP_SUPPORTED),
+	DEFINE(PER_PKT_STATS_SUPPORTED),
+	DEFINE(EXT_LL_STAT),
+	DEFINE(WIFI_CONFIG),
+	DEFINE(ANTENNA_DIVERSITY_SELECTION),
 };
 
+#undef DEFINE
+
 static const char *wcn36xx_get_cap_name(enum place_holder_in_cap_bitmap x)
 {
 	if (x >= ARRAY_SIZE(wcn36xx_caps_names))
-- 
2.35.1

