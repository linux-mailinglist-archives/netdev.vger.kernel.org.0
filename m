Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9943C1D0055
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbgELVLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728275AbgELVLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:11:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4203C061A0C;
        Tue, 12 May 2020 14:11:21 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w19so10768827wmc.1;
        Tue, 12 May 2020 14:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QCz00tmEMOWf1BfX6wm6Ux86AFt3zQvcnwyO0soJUcY=;
        b=EQtUaySOiER3DZmqgJUZlvsEXfJQvIODFcA0vQdu43vOD4gOXWk5qpBubi8TfBg1cf
         ppcyXlTMr9NvEYgcZoRg4JZwZzDoHNhIk6pGygdUUgaQRNt2TOikOQD45CgNEtMlPrzm
         /A1gs9ZmHnK8vmkSo7dPUREqq93sMcJNpiT5GbYYnkTFfI3dGq+oeY/KNB87+SlvBaK3
         kmV9bqKwxmaNocUDjf3XDmCBz6mlK4PgSxnmdGcIFHGHeKt83Uhlzn7p51vejpJmXvaT
         aE3dmGINyBFgD2HngZ1zI1z3JNM1Xrv1aVoUSwjRANzsoWq2cTjvMYPURsSWSwHW/kQI
         eIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QCz00tmEMOWf1BfX6wm6Ux86AFt3zQvcnwyO0soJUcY=;
        b=CY+T9KMcXllHjuylR0arq1ThsU6Y2dRpJGI+mbugbSecK+4AX6RjouIVovsfM48lac
         SufTbsiDgYYmd8wVV/Gs9/1clhN+bbuhZPsp59hpcctBtH14FZVUkemHBh0FPyTsInvP
         T25i7FQn9HUMg6S2eW0WOAqCBiyVKltLAkkA7T1EB89u0OgK0BViDqBQ8PnixtiUcksm
         6zQi7BQHNw6MqSwm7Eb1amFn6/tZYPglhVFZMvPA3itF7NcwqoxUZW3+yUPD+7Ge/psb
         ZSnE4NgWIOhLorRwb428ekF3Gj77WUWhok0o4lYtLl6b0xayLxTFhPjBjs0PTHa1hmdX
         gp6g==
X-Gm-Message-State: AGi0PuZGJtx+zor+SX1PR6P5SBzuMxyZJIBvRAzr+0ZLpqQEz2fhTeaD
        oCYbwzxQd5jpwHGJsgu2+Js=
X-Google-Smtp-Source: APiQypIwG6YlDqv9Ym1mV9sH/sUllSp3MG0tyRa6e+gg0yIgvWrhNsgaj8VAtpPtWCH8XSAGGhc1aA==
X-Received: by 2002:a05:600c:2046:: with SMTP id p6mr39502551wmg.177.1589317880711;
        Tue, 12 May 2020 14:11:20 -0700 (PDT)
Received: from localhost.localdomain (p200300F137132E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3713:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id r3sm9724228wmh.48.2020.05.12.14.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 14:11:20 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 4/8] net: stmmac: dwmac-meson8b: Move the documentation for the TX delay
Date:   Tue, 12 May 2020 23:10:59 +0200
Message-Id: <20200512211103.530674-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
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

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

