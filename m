Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB296D1A4E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCaIge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjCaIgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:36:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78771D876
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:01 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r29so21552724wra.13
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251701;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e2XVUgcXhhuEI3xNnuwh8AFlDinLYyU1iswACd61bmI=;
        b=kGHKFCRY2/20Z1rCTqcYJVgU3cd0wi3wDJXSMUyFVmZc5j+V1KaiZPKiBhBCNWiEmk
         YTJR/O1xNUVyGTEJU7oVvd4EgpSvsIeWc4G/vW2FHJAqvr1kgXR0guIzHaF0b/f40umh
         vl0zURjjjrylWlJemjFV4xwD8kY/633aitJ0VVNsQRTNDNLcU4QFEFBQI5Tugl9mdmvg
         udtFPfIzb33L0bIbMKt5hHXVZJ/EmVQBNEEcbXpC9ggPMZBn5+Hkia/GFYA4U/4x+oy3
         mXHaaqPyZzupgnB9Wh3WgukGpxphE0upGxLInLzuYg3CiYPeQuCGDmHn/E7to5cUt0TD
         JMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251701;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2XVUgcXhhuEI3xNnuwh8AFlDinLYyU1iswACd61bmI=;
        b=mNRn8U7X6aMQaGU2Q7J5bL2g4yCktpJvp9PuLxudLDLuXabWdTJlIpLohqaZsg+NqF
         /j8B600I/EGtpwZTWi6+r4TF5/2Z6HexOvnFyIbWH2L9pcbwpfkKklVXKR7LKY8uq8Fr
         bMQgHH7RDd3jVJVgXZtmO3hWW1qSRH1FAJYw+yxwCzH1stnon1Q7IKuQLdK+mgGPRhbH
         tb8kggTam1ZCmIoBxxjXRQ1A4MIH9MksqgrepDqamSGKRepnSqoLFsQntwOp97X5pUmL
         scA0UQMSI+KPTsOej3aMcDl7EPN+vzja0mTdymyj6W4N0JBNVl9FuPYt1K8RUXNLl3tS
         yqhA==
X-Gm-Message-State: AAQBX9eggztyiYx/mxy2iq4J6+2Yc+V3sVD5VnkLqfd/vSbhpUGZQRYF
        1TZbXM+qFYjiz4jMF3MLrfw5Rw==
X-Google-Smtp-Source: AKy350aNpaM25UKb9HFn6P6W9+ACITvL4WD6p7Ljzn1vIWq606qr2KNRuWDoLeB1DkeoT9ecCJBieQ==
X-Received: by 2002:a5d:6e54:0:b0:2da:45f4:c053 with SMTP id j20-20020a5d6e54000000b002da45f4c053mr18574691wrz.52.1680251700946;
        Fri, 31 Mar 2023 01:35:00 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:35:00 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:50 +0200
Subject: [PATCH RFC 12/20] dt-bindings: net: oxnas-dwmac: remove obsolete
 bindings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-12-5bd58fd1dd1f@linaro.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to lack of maintainance and stall of development for a few years now,
and since no new features will ever be added upstream, remove the
OX810 and OX820 dwmac glue.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/net/oxnas-dwmac.txt        | 41 ----------------------
 1 file changed, 41 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/oxnas-dwmac.txt b/Documentation/devicetree/bindings/net/oxnas-dwmac.txt
deleted file mode 100644
index 27db496f1ce8..000000000000
--- a/Documentation/devicetree/bindings/net/oxnas-dwmac.txt
+++ /dev/null
@@ -1,41 +0,0 @@
-* Oxford Semiconductor OXNAS DWMAC Ethernet controller
-
-The device inherits all the properties of the dwmac/stmmac devices
-described in the file stmmac.txt in the current directory with the
-following changes.
-
-Required properties on all platforms:
-
-- compatible:	For the OX820 SoC, it should be :
-		- "oxsemi,ox820-dwmac" to select glue
-		- "snps,dwmac-3.512" to select IP version.
-		For the OX810SE SoC, it should be :
-		- "oxsemi,ox810se-dwmac" to select glue
-		- "snps,dwmac-3.512" to select IP version.
-
-- clocks: Should contain phandles to the following clocks
-- clock-names:	Should contain the following:
-		- "stmmaceth" for the host clock - see stmmac.txt
-		- "gmac" for the peripheral gate clock
-
-- oxsemi,sys-ctrl: a phandle to the system controller syscon node
-
-Example :
-
-etha: ethernet@40400000 {
-	compatible = "oxsemi,ox820-dwmac", "snps,dwmac-3.512";
-	reg = <0x40400000 0x2000>;
-	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-		     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq", "eth_wake_irq";
-	mac-address = [000000000000]; /* Filled in by U-Boot */
-	phy-mode = "rgmii";
-
-	clocks = <&stdclk CLK_820_ETHA>, <&gmacclk>;
-	clock-names = "gmac", "stmmaceth";
-	resets = <&reset RESET_MAC>;
-
-	/* Regmap for sys registers */
-	oxsemi,sys-ctrl = <&sys>;
-
-};

-- 
2.34.1

