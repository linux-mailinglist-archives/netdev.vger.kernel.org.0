Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C171BE862
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgD2USI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgD2URT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4C7C03C1AE;
        Wed, 29 Apr 2020 13:17:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x18so4129346wrq.2;
        Wed, 29 Apr 2020 13:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A1BsZHOKV23AL354M93nmEs0vyNnhe/u13UcIzUzcp0=;
        b=OZKi475hcnUACJSmFsmYlgbAF4kGxaIWFbXq4bXdnUMWgxqXrCCMO8VHh4fjWGT7ya
         wM8HUL3n4GtqtUDeKu4tu6Ufrzga6+fSjbp3wkQPiU1W07zrTVEbnaDaChkws8GiVGI7
         XTFRPP0MS7u8E5RK6b+pa8kFbNRshT6Gig162/kYaBPHZqBc3cBDBNaV00pJnT88Fhsr
         hIY237tXOk56Y9kc3bYCfsdW2vu1yeuqYe3ia9DfvqcPBX96k/+wtVpsxvM9V2WLcKmX
         GvbADmNIeqPhXa1AwbE21ogk9EOsGTwS1JgrSiwNj0x6N2mF8W4u0tm16V5Izzn4igfF
         pFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A1BsZHOKV23AL354M93nmEs0vyNnhe/u13UcIzUzcp0=;
        b=dKqcVhyc4BQNOX2fOIIH2mZWS/XzcByOxyvTgiqsrfM1XNyNB1wDU7bZz/h1JLiUMU
         P6MMMqQcHqSpF/MWbs3OxcO2wztMIPIsGesYqXnmj6W5b6ds+F3tqzhWf2W04EDrrYr8
         rc6BibE7QC16WL5aF+zCwPPRxngg1Vllo1/1Xz3zYXvned4pZd1IImLIycddS/aI4dWd
         DBGTI9Rtz9QEn5vQUV65bSLLNGnpBM2BzlZ3OqW2V8P8m5O1knohpHwlh/p7Aw2ziycP
         XPJiMcrSc9fI/SJQlSolVacUbYrRIJqNxOg5HMXMUqvOYcPKr9KTUWXAoPBznxXKtIOM
         yI8g==
X-Gm-Message-State: AGi0Pua0hkq8HoqZvlA/xxk9B2a3m4CbKD6BF7qyxPUOrSacwmGpI4kj
        QfFjrPRqYBx8A2NDvmAu3YM=
X-Google-Smtp-Source: APiQypIThLRu5RnVmx97RtJ9EtKrENrzlVIOefrkcoCLnfZRVkGPPMuiLNkwIg2h6iEwqtnhdU3xgw==
X-Received: by 2002:a5d:404a:: with SMTP id w10mr40207406wrp.397.1588191437227;
        Wed, 29 Apr 2020 13:17:17 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:15 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 04/11] net: stmmac: dwmac-meson8b: Move the documentation for the TX delay
Date:   Wed, 29 Apr 2020 22:16:37 +0200
Message-Id: <20200429201644.1144546-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the documentation for the TX delay above the PRG_ETH0_TXDLY_MASK
definition. Future commits will add more registers also with
documentation above their register bit definitions. Move the existing
comment so it will be consistent with the upcoming changes.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c9ec0cb68082..1d7526ee09dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -33,6 +33,10 @@
 #define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
+/* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where 8ns are exactly one
+ * cycle of the 125MHz RGMII TX clock):
+ * 0ns = 0x0, 2ns = 0x1, 4ns = 0x2, 6ns = 0x3
+ */
 #define PRG_ETH0_TXDLY_MASK		GENMASK(6, 5)
 
 /* divider for the result of m250_sel */
@@ -248,10 +252,6 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 	switch (dwmac->phy_mode) {
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		/* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where
-		 * 8ns are exactly one cycle of the 125MHz RGMII TX clock):
-		 * 0ns = 0x0, 2ns = 0x1, 4ns = 0x2, 6ns = 0x3
-		 */
 		tx_dly_val = dwmac->tx_delay_ns >> 1;
 		/* fall through */
 
-- 
2.26.2

