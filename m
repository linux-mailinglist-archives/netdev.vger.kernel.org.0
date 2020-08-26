Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E336252A28
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgHZJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgHZJfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F40C0617A1
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so1081837wrt.12
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rUAO3RuW/3xrjV/jLQoBhZg+qrtryFN4uR4f5U2383M=;
        b=As6cWuop/UitBN8qYzmoyyS8vCPET7V+08ebuq6oQcV6utLW7d2Wq3FC6+itt/QdM6
         vJWvBjw4LqqhgSlcfR1SELi/4siTNwvRB6Jm2f3cik6e6/b7x2u4BDO47TPxwO1L4R06
         d9SF74TQV6b21kHyDGr+r/5Sh1/eAZ6zYtppbV1UA55rXGMppf4Vplbb/bDgaRpAWLUr
         EwMvE7zOItgvt5lcKzz6GBg/x7iSpWuPIPW3rdoADPuZNeFe5UKcu6EkPg/iFw9LVAKR
         1ZHYlNVyF5FsBso5UfAsFt825rivgBwDix2VBBQxYxYMcMoiOs8n98V25qtafhCAAVV1
         H2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rUAO3RuW/3xrjV/jLQoBhZg+qrtryFN4uR4f5U2383M=;
        b=W4klB0O/A3R0VMxM85+z/9E1A5VS6PUUFqoGWar/rtocDh0w7u5fMVby34IPbVT0a4
         SEnoddIO9enoq/95qSwDXd+SGQHBDjdYXcquJUYMFEs/+YSLDqc9IGyq2v92AnxuClxt
         /1LopMJrYOpDQ38har7gq2NRTjB890oEXwTkKbmJR3o66GlKAdCqGsZrWAD2Novql8z5
         pTuvc/vDf4PpCo1g1Xnb6SxacChhEBoNm2fjaXkpzYN3tPfVW2bkxEqPkFHh94/AumWc
         3nq6uUAJxxFZYeP1xN0X9cTefRqy+PLMl5ynNl+NVlVOQTKNTWS6xblsBGtZzQ9ow9oc
         OXvw==
X-Gm-Message-State: AOAM532K1mI3x1PxYCn2A1I+0Axy92f79o5Ql23c99NCHRW1ZSxTB8iu
        U89RTtU9OqeF56i+pILz0iazuQ==
X-Google-Smtp-Source: ABdhPJziN1RDbNaC2S+YMAoUkGKn2f+KngJEz1+d5F2GY3qWG0qGkU38nN0FtIz1QZ2HPMATScxOyg==
X-Received: by 2002:a5d:43ca:: with SMTP id v10mr14464632wrr.299.1598434478379;
        Wed, 26 Aug 2020 02:34:38 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 27/30] wireless: broadcom: brcm80211: phy_lcn: Remove a bunch of unused variables
Date:   Wed, 26 Aug 2020 10:33:58 +0100
Message-Id: <20200826093401.1458456-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:11:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_rx_iq_cal’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1366:29: warning: variable ‘RFOverride0_old’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_radio_2064_channel_tune_4313’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1667:21: warning: variable ‘qFvco’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1667:14: warning: variable ‘qFref’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1667:6: warning: variable ‘qFxtal’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_idle_tssi_est’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2856:6: warning: variable ‘idleTssi’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_tx_iqlo_soft_cal_full’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:53: warning: variable ‘locc4’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:46: warning: variable ‘locc3’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:39: warning: variable ‘locc2’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3861:32: warning: variable ‘iqcc0’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_lcnphy_periodic_cal’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4196:6: warning: variable ‘rx_iqcomp_sz’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4195:33: warning: variable ‘rx_iqcomp’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4194:16: warning: variable ‘full_cal’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c: In function ‘wlc_phy_txpwr_srom_read_lcnphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4919:7: warning: variable ‘opo’ set but not used [-Wunused-but-set-variable]

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 40 +++++--------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index 7ef36234a25dc..b8193c99e8642 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1363,7 +1363,7 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 	u16 tx_pwr_ctrl;
 	u8 tx_gain_index_old = 0;
 	bool result = false, tx_gain_override_old = false;
-	u16 i, Core1TxControl_old, RFOverride0_old,
+	u16 i, Core1TxControl_old,
 	    RFOverrideVal0_old, rfoverride2_old, rfoverride2val_old,
 	    rfoverride3_old, rfoverride3val_old, rfoverride4_old,
 	    rfoverride4val_old, afectrlovr_old, afectrlovrval_old;
@@ -1404,7 +1404,7 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 
 	or_phy_reg(pi, 0x631, 0x0015);
 
-	RFOverride0_old = read_phy_reg(pi, 0x44c);
+	read_phy_reg(pi, 0x44c); /* RFOverride0_old */
 	RFOverrideVal0_old = read_phy_reg(pi, 0x44d);
 	rfoverride2_old = read_phy_reg(pi, 0x4b0);
 	rfoverride2val_old = read_phy_reg(pi, 0x4b1);
@@ -1664,7 +1664,7 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 	const struct chan_info_2064_lcnphy *ci;
 	u8 rfpll_doubler = 0;
 	u8 pll_pwrup, pll_pwrup_ovr;
-	s32 qFxtal, qFref, qFvco, qFcal;
+	s32 qFcal;
 	u8 d15, d16, f16, e44, e45;
 	u32 div_int, div_frac, fvco3, fpfd, fref3, fcal_div;
 	u16 loop_bw, d30, setCount;
@@ -1738,10 +1738,7 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 	fvco3 = (ci->freq * 3);
 	fref3 = 2 * fpfd;
 
-	qFxtal = wlc_lcnphy_qdiv_roundup(pi->xtalfreq, PLL_2064_MHZ, 16);
-	qFref = wlc_lcnphy_qdiv_roundup(fpfd, PLL_2064_MHZ, 16);
 	qFcal = pi->xtalfreq * fcal_div / PLL_2064_MHZ;
-	qFvco = wlc_lcnphy_qdiv_roundup(fvco3, 2, 16);
 
 	write_radio_reg(pi, RADIO_2064_REG04F, 0x02);
 
@@ -2853,7 +2850,7 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	bool suspend, tx_gain_override_old;
 	struct lcnphy_txgains old_gains;
 	struct brcms_phy *pi = container_of(ppi, struct brcms_phy, pubpi_ro);
-	u16 idleTssi, idleTssi0_2C, idleTssi0_OB, idleTssi0_regvalue_OB,
+	u16 idleTssi0_2C, idleTssi0_OB, idleTssi0_regvalue_OB,
 	    idleTssi0_regvalue_2C;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	u16 SAVE_lpfgain = read_radio_reg(pi, RADIO_2064_REG112);
@@ -2863,7 +2860,7 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
 	u8 SAVE_bbmult = wlc_lcnphy_get_bbmult(pi);
 
-	idleTssi = read_phy_reg(pi, 0x4ab);
+	read_phy_reg(pi, 0x4ab); /* idleTssi */
 	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
 			 MCTL_EN_MAC));
 	if (!suspend)
@@ -2887,8 +2884,7 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	wlc_lcnphy_set_bbmult(pi, 0x0);
 
 	wlc_phy_do_dummy_tx(pi, true, OFF);
-	idleTssi = ((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
-		    >> 0);
+	read_phy_reg(pi, 0x4ab); /* idleTssi */
 
 	idleTssi0_2C = ((read_phy_reg(pi, 0x63e) & (0x1ff << 0))
 			>> 0);
@@ -3858,8 +3854,6 @@ void wlc_lcnphy_get_tx_iqcc(struct brcms_phy *pi, u16 *a, u16 *b)
 
 static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi)
 {
-	struct lcnphy_unsign16_struct iqcc0, locc2, locc3, locc4;
-
 	wlc_lcnphy_set_cc(pi, 0, 0, 0);
 	wlc_lcnphy_set_cc(pi, 2, 0, 0);
 	wlc_lcnphy_set_cc(pi, 3, 0, 0);
@@ -3872,10 +3866,10 @@ static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi)
 	wlc_lcnphy_a1(pi, 2, 2, 1);
 	wlc_lcnphy_a1(pi, 0, 4, 3);
 
-	iqcc0 = wlc_lcnphy_get_cc(pi, 0);
-	locc2 = wlc_lcnphy_get_cc(pi, 2);
-	locc3 = wlc_lcnphy_get_cc(pi, 3);
-	locc4 = wlc_lcnphy_get_cc(pi, 4);
+	wlc_lcnphy_get_cc(pi, 0);
+	wlc_lcnphy_get_cc(pi, 2);
+	wlc_lcnphy_get_cc(pi, 3);
+	wlc_lcnphy_get_cc(pi, 4);
 }
 
 u16 wlc_lcnphy_get_tx_locc(struct brcms_phy *pi)
@@ -4191,9 +4185,7 @@ static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
 
 static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 {
-	bool suspend, full_cal;
-	const struct lcnphy_rx_iqcomp *rx_iqcomp;
-	int rx_iqcomp_sz;
+	bool suspend;
 	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	s8 index;
 	struct phytbl_info tab;
@@ -4203,9 +4195,6 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 
 	pi->phy_lastcal = pi->sh->now;
 	pi->phy_forcecal = false;
-	full_cal =
-		(pi_lcn->lcnphy_full_cal_channel !=
-		 CHSPEC_CHANNEL(pi->radio_chanspec));
 	pi_lcn->lcnphy_full_cal_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 	index = pi_lcn->lcnphy_current_index;
 
@@ -4220,9 +4209,6 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 
 	wlc_lcnphy_txpwrtbl_iqlo_cal(pi);
 
-	rx_iqcomp = lcnphy_rx_iqcomp_table_rev0;
-	rx_iqcomp_sz = ARRAY_SIZE(lcnphy_rx_iqcomp_table_rev0);
-
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
 		wlc_lcnphy_rx_iq_cal(pi, NULL, 0, true, false, 1, 40);
 	else
@@ -4916,10 +4902,6 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 				offset_ofdm >>= 4;
 			}
 		} else {
-			u8 opo = 0;
-
-			opo = sprom->opo;
-
 			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++)
 				pi->tx_srom_max_rate_2g[i] = txpwr;
 
-- 
2.25.1

