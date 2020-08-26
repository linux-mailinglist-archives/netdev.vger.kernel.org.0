Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D689252A86
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgHZJkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbgHZJeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:13 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94313C061798
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x5so1083312wmi.2
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2KGeJSrcx/f0sl9IxgJehFn4dP40Mv7ju8hYZZhmHM=;
        b=S2CmOO6zGDkBWEgPuXFWOPordeJwDLVLAI2n79heI2Imt9csW1njAXNoAue6rqjwy6
         3B2Ga34gD1kBdIoilsSvQE1uNW9hpBIvnQa30YdZvWD1wA1Wol3EMxqHRzFi1XrjfbAD
         9WasQOTM7WFO9pw6uS7+qnQCab9TM1l8uINNZGoU9U92tzbyf4tVP/g0QOes2eYcLrzJ
         imy9PQ4I9pRiteBOeJenYCVcAdYk8U/HZZjCNjCYJZa/j6UYKxJUQ6BtTvGYBaKjpQQC
         CHZeTzzgOOlQUS7S+R4x3shf5wCwqEHqZ907ws845F8Qda63OvpToJPtyUWKm1/ajuVt
         wkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2KGeJSrcx/f0sl9IxgJehFn4dP40Mv7ju8hYZZhmHM=;
        b=bl2sq+hoqDBN6D4x1QyS7PycfkfkX0u/MVocNauXzoGhSjd07h1RI0R2rb0wM0or8G
         bacLKRpDBw8j50w8j8GDpfcVo8tljhtFIwCqOV98WyDpEY0TLslIbazbYMXmKr4pGg3G
         h6ZjW/Aj/yHU01Xn+zDCm//VnPa7IfpCsWY9/Y5xkdIL8DnOo+I0QnS/w8k7YO+fwofW
         tfdjKMVuAhm/rZ1FbxxHdDCQFCGy2hzWej7NXKHajlDodY/putRxxkiH82MgACNhdjOU
         E/fxiyJrdZ8iLrn6AeTYLe5b2vb6zNVfleer1dLW2LfMj0nY4QuB5aGjfpllM7EyRuXE
         tdEw==
X-Gm-Message-State: AOAM533A7XU3pygdaSSOiq7nA6x/d9B29OHiTpL5P5CF2Szu1W/c924I
        NgmQ7XwLeD9sVpw+u2vLOJm48A==
X-Google-Smtp-Source: ABdhPJwlIijd7UrnKwjo8KchXhpkB+tbjfjKJ4VU3DJLPxvkUuccn08hqCsuw1MbWZrE0uZPel7smg==
X-Received: by 2002:a1c:5a87:: with SMTP id o129mr3115105wmb.145.1598434447276;
        Wed, 26 Aug 2020 02:34:07 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:06 -0700 (PDT)
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
Subject: [PATCH 02/30] wireless: broadcom: brcmsmac: ampdu: Remove a couple set but unused variables
Date:   Wed, 26 Aug 2020 10:33:33 +0100
Message-Id: <20200826093401.1458456-3-lee.jones@linaro.org>
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

 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c:18:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c: In function ‘brcms_c_ampdu_dotxstatus_complete’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c:850:7: warning: variable ‘update_rate’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c: In function ‘brcms_c_ampdu_dotxstatus’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c:1027:20: warning: variable ‘scb_ampdu’ set but not used [-Wunused-but-set-variable]

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index cbad1a11673ae..c9fb4b0cffaf5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -847,7 +847,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	bool ba_recd = false, ack_recd = false;
 	u8 suc_mpdu = 0, tot_mpdu = 0;
 	uint supr_status;
-	bool update_rate = true, retry = true;
+	bool retry = true;
 	u16 mimoantsel = 0;
 	u8 retry_limit;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(p);
@@ -867,9 +867,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 
 	if (txs->status & TX_STATUS_ACK_RCV) {
-		if (TX_STATUS_SUPR_UF == supr_status)
-			update_rate = false;
-
 		WARN_ON(!(txs->status & TX_STATUS_INTERMEDIATE));
 		start_seq = txs->sequence >> SEQNUM_SHIFT;
 		bitmap[0] = (txs->status & TX_STATUS_BA_BMAP03_MASK) >>
@@ -893,7 +890,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		ba_recd = true;
 	} else {
 		if (supr_status) {
-			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
 				brcms_dbg_ht(wlc->hw->d11core,
 					  "%s: Pkt tx suppressed, illegal channel possibly %d\n",
@@ -921,7 +917,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				brcms_c_ffpld_check_txfunfl(wlc, queue);
 			}
 		} else if (txs->phyerr) {
-			update_rate = false;
 			brcms_dbg_ht(wlc->hw->d11core,
 				     "%s: ampdu tx phy error (0x%x)\n",
 				     __func__, txs->phyerr);
@@ -1024,7 +1019,6 @@ void
 brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		     struct sk_buff *p, struct tx_status *txs)
 {
-	struct scb_ampdu *scb_ampdu;
 	struct brcms_c_info *wlc = ampdu->wlc;
 	u32 s1 = 0, s2 = 0;
 
@@ -1050,7 +1044,6 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	}
 
 	if (scb) {
-		scb_ampdu = &scb->scb_ampdu;
 		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
 	} else {
 		/* loop through all pkts and free */
-- 
2.25.1

