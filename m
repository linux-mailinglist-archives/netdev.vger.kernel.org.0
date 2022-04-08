Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE8D4F925C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiDHKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiDHKA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 06:00:29 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F954166E0E;
        Fri,  8 Apr 2022 02:58:10 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c199so2668568qkg.4;
        Fri, 08 Apr 2022 02:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JC7HU5myZPsK6jCheQ0Ef5hbofKUPdurtc8JhOElAAQ=;
        b=fFwI1tAZfzk4mtfW+9OkFWvX+Gps+rQl7W4wAAMXrL3dHXRcvD9iIfy7yQjHJG09pM
         KT20oE9yu1IP7EIfWMdZTLjQ2l1gU0YgwscCL3G/aQ7yCFsBQA65WePb336YqYpIdotq
         k0lenE9fKEVWysRpTwQULrpTZZ+xwNcheyh1haJA2YeHbmWYsh4hyOPimusJUtCPGXHt
         wOkHk47mdHRTflnfamhXXbLSG93/2W3Em3/DBNyxR6kK3iHVPnyH78SpXG1bVazSWtp3
         fskvDqN7UKUk5QuWxXMh5MsHPcYVn356VNlQZz4CaBNP4hYBW2D9AQcfXdcBrCbBs7os
         HRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JC7HU5myZPsK6jCheQ0Ef5hbofKUPdurtc8JhOElAAQ=;
        b=3zXwpkclBse3GAbrtHJNCuDeT7FjgwPfAPqAreU81SFDSVN8ZR/jq2pk0MmajU3wqI
         13OGScfx3kqLpKsR2rpdZM5ajhUYRoz2WpGMGzWOw9Dx0pa+rZcGHQpFCy9f6coaWp9D
         F0jhzD97zMCDzILJt/NBi+KE4/KVTNM+27Ric1qQLKnzOjdbe7vILCQz6O7DBB/rGYcl
         y6mlSCCIdZBQ8VDiX54cwAx8sbmm6FPqXIcO0X+mF/glfpwhKS82WjYTnJrzMoTln/60
         0tqXrPYzExtL6VHu+CRjLZka3oR/EmITBWT4uyUrwa74CGyQYTOr0CNXtS8VA7Ix1SQX
         xVAA==
X-Gm-Message-State: AOAM531x9rh8aLSuyyCoNON4KPXWMO4MoexHC3pfqlMCyXWvwvfMKM4I
        By2SPnJEzFYlt8DkdFhsEqw=
X-Google-Smtp-Source: ABdhPJwe223nBc4xK4K5r+bfTbqUb6Z76o29Fv7hbVg9W9wM3i3H8RR81ki0Mom2JkeajPh/Z/kfBQ==
X-Received: by 2002:a05:620a:298c:b0:680:9f2a:c213 with SMTP id r12-20020a05620a298c00b006809f2ac213mr12250765qkp.11.1649411889809;
        Fri, 08 Apr 2022 02:58:09 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id az17-20020a05620a171100b00680af0db559sm14131025qkb.127.2022.04.08.02.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 02:58:09 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, lv.ruyi@zte.com.cn,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] realtek: rtlwifi: Fix spelling mistake "cacluated" -> "calculated"
Date:   Fri,  8 Apr 2022 09:58:03 +0000
Message-Id: <20220408095803.2495336-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

There are some spelling mistakes in the comments. Fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index c948dafa0c80..171c7b16e048 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -58,7 +58,7 @@ static void _rtl88ee_query_rxphystatus(struct ieee80211_hw *hw,
 		cck_agc_rpt = cck_buf->cck_agc_rpt;
 
 		/* (1)Hardware does not provide RSSI for CCK
-		 * (2)PWDB, Average PWDB cacluated by
+		 * (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		if (ppsc->rfpwr_state == ERFON)
@@ -187,7 +187,7 @@ static void _rtl88ee_query_rxphystatus(struct ieee80211_hw *hw,
 				pstatus->rx_mimo_signalstrength[i] = (u8)rssi;
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 4165175cf5c0..65ebdd2e5f05 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -166,7 +166,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index eef7a041e80d..66845724b6cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -55,7 +55,7 @@ static void _rtl92ee_query_rxphystatus(struct ieee80211_hw *hw,
 		cck_agc_rpt = p_phystrpt->cck_agc_rpt_ofdm_cfosho_a;
 
 		/* (1)Hardware does not provide RSSI for CCK
-		 * (2)PWDB, Average PWDB cacluated by
+		 * (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		cck_highpwr = (u8)rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2,
@@ -153,7 +153,7 @@ static void _rtl92ee_query_rxphystatus(struct ieee80211_hw *hw,
 			pstatus->rx_mimo_signalstrength[i] = (u8)rssi;
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_phystrpt->cck_sig_qual_ofdm_pwdb_all >> 1)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 340b3d68a54e..8054e92e6774 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -52,7 +52,7 @@ static void _rtl8723e_query_rxphystatus(struct ieee80211_hw *hw,
 		cck_buf = (struct phy_sts_cck_8723e_t *)p_drvinfo;
 
 		/* (1)Hardware does not provide RSSI for CCK */
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		if (ppsc->rfpwr_state == ERFON)
@@ -170,7 +170,7 @@ static void _rtl8723e_query_rxphystatus(struct ieee80211_hw *hw,
 				pstatus->rx_mimo_signalstrength[i] = (u8)rssi;
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index 5a7cd270575a..c73074d8a537 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -55,7 +55,7 @@ static void _rtl8723be_query_rxphystatus(struct ieee80211_hw *hw,
 		cck_agc_rpt = p_phystrpt->cck_agc_rpt_ofdm_cfosho_a;
 
 		/* (1)Hardware does not provide RSSI for CCK */
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, BIT(9));
@@ -126,7 +126,7 @@ static void _rtl8723be_query_rxphystatus(struct ieee80211_hw *hw,
 			pstatus->rx_mimo_signalstrength[i] = (u8)rssi;
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_phystrpt->cck_sig_qual_ofdm_pwdb_all >> 1) &
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 9d6f8dcbf2d6..537d4cb3c6a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -86,7 +86,7 @@ static void query_rxphystatus(struct ieee80211_hw *hw,
 		cck_agc_rpt = p_phystrpt->cfosho[0];
 
 		/* (1)Hardware does not provide RSSI for CCK
-		 * (2)PWDB, Average PWDB cacluated by
+		 * (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		cck_highpwr = (u8)rtlphy->cck_high_power;
@@ -215,7 +215,7 @@ static void query_rxphystatus(struct ieee80211_hw *hw,
 			pstatus->rx_mimo_signalstrength[i] = (u8)rssi;
 		}
 
-		/* (2)PWDB, Average PWDB cacluated by
+		/* (2)PWDB, Average PWDB calculated by
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
-- 
2.25.1


