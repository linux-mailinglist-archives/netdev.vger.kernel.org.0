Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B7B2448F6
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgHNLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbgHNLk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:28 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8E6C06134C
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p20so8089929wrf.0
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ERDbFfgstNgY8ZqH90cxmPjJzuqGvYyLAnf6eRHoBY4=;
        b=nHwifoMpu5zgZPbaWXSh4Q+iAF49QG4RKveJ1/wvYfR/pX2b+hIMQYlTGhmgwHNwGf
         pdRYfLJgNDqaz+aQLzDTaZBE4JVhtsq0nhvOsKcz5w9UTo1maRGmjP4VeyXyNhPwPffb
         B6amufXKHd7z1H0uwjrDGYTAFT3I800ydCljxLAasN5LV1JNXyeO/OnFslgaLkZuy0ts
         VUSwPkYv2uW0yeK33IURmPYK4lchSmb5c16V5V6ErNW3oX78Vo1xQqocwUCMZOsKwgV+
         Cm2hdfKjE6TIXNXGLsCIPj4ZxWBqTy6j1xETu0pfH6bkN6n9FL0Sj/pZti7luKy/WblI
         Vs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ERDbFfgstNgY8ZqH90cxmPjJzuqGvYyLAnf6eRHoBY4=;
        b=bkcVakPdhItYZT8L8ROmozSKR0m6vB0HT4yiRKXkHsIynr7kpi0TibZwCDp6LZN3vu
         EnGcv3mZwafaA3ttMsRds8z5gOHr1/f7Oqkhug4jNfhv4uSXMvEjtBDCI4cPyLQ5X57v
         ngD7RIA1RSn8RG0vzo8ujwD+D7otWCP9KiPL9EPGIJJ4XybKPCUBuvyy6acGk6Tq4ax/
         BtEqvTlfaTTM2XehAELNHOei/PLOGeQByCaklJYPx8wFBNGafPri0VUpBQNOM0s8r8Ok
         ajwBrqCMIjNajxRZWZcbnXUvEsS6O3is7czQ0b07pBGNycMhySUHa17SXqZhahnnjCy4
         LTBA==
X-Gm-Message-State: AOAM533yFST/iXbnbCSaHJ0XNZbW8V+LYvuItyLnYFfb2Hmz/FaSlH62
        sZ2UzVoTmN8LEdjH2cPJ4ZBL6Q==
X-Google-Smtp-Source: ABdhPJyA4Z4Ev0xX+XGgbzZghIa2dEQk7CN3RanlMbTixLJqmXt/FpFJfP8uMAuRCdGfdERbFxOyLw==
X-Received: by 2002:a5d:4b11:: with SMTP id v17mr2343478wrq.224.1597405226411;
        Fri, 14 Aug 2020 04:40:26 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 30/30] net: wireless: broadcom: b43: phy_n: Add empty braces around empty statements
Date:   Fri, 14 Aug 2020 12:39:33 +0100
Message-Id: <20200814113933.1903438-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/b43/phy_n.c: In function ‘b43_nphy_workarounds_rev3plus’:
 drivers/net/wireless/broadcom/b43/phy_n.c:3346:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
 drivers/net/wireless/broadcom/b43/phy_n.c: In function ‘b43_nphy_spur_workaround’:
 drivers/net/wireless/broadcom/b43/phy_n.c:4608:4: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 drivers/net/wireless/broadcom/b43/phy_n.c:4641:4: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 drivers/net/wireless/broadcom/b43/phy_n.c: In function ‘b43_phy_initn’:
 drivers/net/wireless/broadcom/b43/phy_n.c:6170:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
 drivers/net/wireless/broadcom/b43/phy_n.c:6215:5: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index ca2018da97538..9e4d61e64adf5 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -3342,8 +3342,9 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_ED_CRS20UDEASSERTTHRESH0, 0x0381);
 	b43_phy_write(dev, B43_NPHY_ED_CRS20UDEASSERTTHRESH1, 0x0381);
 
-	if (dev->phy.rev >= 6 && sprom->boardflags2_lo & B43_BFL2_SINGLEANT_CCK)
+	if (dev->phy.rev >= 6 && sprom->boardflags2_lo & B43_BFL2_SINGLEANT_CCK) {
 		; /* TODO: 0x0080000000000000 HF */
+	}
 }
 
 static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
@@ -4602,10 +4603,11 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 
 	if (nphy->gband_spurwar_en) {
 		/* TODO: N PHY Adjust Analog Pfbw (7) */
-		if (channel == 11 && b43_is_40mhz(dev))
+		if (channel == 11 && b43_is_40mhz(dev)) {
 			; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
-		else
+		} else {
 			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
+		}
 		/* TODO: N PHY Adjust CRS Min Power (0x1E) */
 	}
 
@@ -4635,10 +4637,11 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 			noise[0] = 0;
 		}
 
-		if (!tone[0] && !noise[0])
+		if (!tone[0] && !noise[0]) {
 			; /* TODO: N PHY Adjust Min Noise Var(1, tone, noise)*/
-		else
+		} else {
 			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
+		}
 	}
 
 	if (nphy->hang_avoid)
@@ -6166,8 +6169,9 @@ static int b43_phy_initn(struct b43_wldev *dev)
 
 	if (nphy->phyrxchain != 3)
 		b43_nphy_set_rx_core_state(dev, nphy->phyrxchain);
-	if (nphy->mphase_cal_phase_id > 0)
+	if (nphy->mphase_cal_phase_id > 0) {
 		;/* TODO PHY Periodic Calibration Multi-Phase Restart */
+	}
 
 	do_rssi_cal = false;
 	if (phy->rev >= 3) {
@@ -6211,8 +6215,9 @@ static int b43_phy_initn(struct b43_wldev *dev)
 				if (!b43_nphy_cal_tx_iq_lo(dev, target, true, false))
 					if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
 						b43_nphy_save_cal(dev);
-			} else if (nphy->mphase_cal_phase_id == 0)
+			} else if (nphy->mphase_cal_phase_id == 0) {
 				;/* N PHY Periodic Calibration with arg 3 */
+			}
 		} else {
 			b43_nphy_restore_cal(dev);
 		}
-- 
2.25.1

