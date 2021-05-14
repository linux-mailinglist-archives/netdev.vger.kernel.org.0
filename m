Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D4A38127D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhENVDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhENVCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:02:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0862EC061357;
        Fri, 14 May 2021 14:00:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v5so48004edc.8;
        Fri, 14 May 2021 14:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjF+h6zVM9Quo5sRZfrPUJDPQbdHpzTgaoj5QFEqGYQ=;
        b=ctUjoEzmZrQ6LluKBwR00PSA7msL/RNmdO14y6jBH47EqbAZYGvajj7mdIxvqu1mvs
         uCG0OYTqBkwpdrYmcv4AmIzBhtX5QUyFlsxbPv0jnA0VHfT04UF20KTr98HXKuQhV1sf
         ytWUMtYzNViLMwwMrO4Vy25qsrePWkRInrBuSfjzmGpcz84XWiz0xmw7WDtFYE+7XPXD
         DDxkL1yLPCbLmBIXahzEAS/C6O44BTeMpxv88vJ4vSJcYUv/32SNLI3PfFh3Zc7eytuu
         fZAZzkLekkDeUNmsc0WqTfrN2su7ESIenUw1AZ4ak/6+Y53+wUle9cc3GFYRjVwg3D7P
         CpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjF+h6zVM9Quo5sRZfrPUJDPQbdHpzTgaoj5QFEqGYQ=;
        b=lnNTfVaF6THnp96z8Y629sNBQRMOo6xp+bbPGo3cYWhTw2O1cczL4rE6sS4iTaE+OS
         v5X1NiCNr3MHP8VW9Chf13ohnXH23jWXj8+rRqdgGNWFUZs7RjRNtYizXqE4SsbXxz7y
         KT+U5twgZ60tx8540Xu1wgqfrtlD6AyH5SRUj30/TN6epqZkrcH8TfDrtMHhHR6ZLKx3
         5Sn8EgN4Nyd6eF59BGmBpVBnL9ifWvcN5TMQHywxsDLUI0v3SM0z+cblBIZwJSh2mecl
         zLSm67PbMAwfCqnCZqhCvyYqBsrQ4NHcEWeIWQDXYkX0rr7ADWkhAiAzlqzxQwTXHuT+
         fgpA==
X-Gm-Message-State: AOAM533FHzkbOD5RHzo+6UBKS0myAGwrt0BREguoWrlu3CPZIwo90VSE
        VopcDKZlGLnPaMKJlLD52sE=
X-Google-Smtp-Source: ABdhPJznuFR8ZXqVGgLGpV4BpENJzPiB2Om/uHCmHLbV9aeD1STz9upgvHmqnPCHh6KvuGkREiN+MQ==
X-Received: by 2002:a05:6402:1046:: with SMTP id e6mr9238478edu.218.1621026040694;
        Fri, 14 May 2021 14:00:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:40 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 24/25] net: phy: at803x: clean whitespace errors
Date:   Fri, 14 May 2021 23:00:14 +0200
Message-Id: <20210514210015.18142-25-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean any whitespace errors and fix not aligned define.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 32af52dd5aed..d2378a73de6f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -83,8 +83,8 @@
 #define AT803X_MODE_CFG_MASK			0x0F
 #define AT803X_MODE_CFG_SGMII			0x01
 
-#define AT803X_PSSR			0x11	/*PHY-Specific Status Register*/
-#define AT803X_PSSR_MR_AN_COMPLETE	0x0200
+#define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
+#define AT803X_PSSR_MR_AN_COMPLETE		0x0200
 
 #define AT803X_DEBUG_REG_0			0x00
 #define AT803X_DEBUG_RX_CLK_DLY_EN		BIT(15)
@@ -128,24 +128,28 @@
 #define AT803X_CLK_OUT_STRENGTH_HALF		1
 #define AT803X_CLK_OUT_STRENGTH_QUARTER		2
 
-#define AT803X_DEFAULT_DOWNSHIFT 5
-#define AT803X_MIN_DOWNSHIFT 2
-#define AT803X_MAX_DOWNSHIFT 9
+#define AT803X_DEFAULT_DOWNSHIFT		5
+#define AT803X_MIN_DOWNSHIFT			2
+#define AT803X_MAX_DOWNSHIFT			9
 
 #define AT803X_MMD3_SMARTEEE_CTL1		0x805b
 #define AT803X_MMD3_SMARTEEE_CTL2		0x805c
 #define AT803X_MMD3_SMARTEEE_CTL3		0x805d
 #define AT803X_MMD3_SMARTEEE_CTL3_LPI_EN	BIT(8)
 
-#define ATH9331_PHY_ID 0x004dd041
-#define ATH8030_PHY_ID 0x004dd076
-#define ATH8031_PHY_ID 0x004dd074
-#define ATH8032_PHY_ID 0x004dd023
-#define ATH8035_PHY_ID 0x004dd072
+#define ATH9331_PHY_ID				0x004dd041
+#define ATH8030_PHY_ID				0x004dd076
+#define ATH8031_PHY_ID				0x004dd074
+#define ATH8032_PHY_ID				0x004dd023
+#define ATH8035_PHY_ID				0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
-#define AT803X_PAGE_FIBER		0
-#define AT803X_PAGE_COPPER		1
+#define AT803X_PAGE_FIBER			0
+#define AT803X_PAGE_COPPER			1
+
+/* don't turn off internal PLL */
+#define AT803X_KEEP_PLL_ENABLED			BIT(0)
+#define AT803X_DISABLE_SMARTEEE			BIT(1)
 
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
@@ -153,8 +157,6 @@ MODULE_LICENSE("GPL");
 
 struct at803x_priv {
 	int flags;
-#define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
-#define AT803X_DISABLE_SMARTEEE	BIT(1)
 	u16 clk_25m_reg;
 	u16 clk_25m_mask;
 	u8 smarteee_lpi_tw_1g;
-- 
2.30.2

