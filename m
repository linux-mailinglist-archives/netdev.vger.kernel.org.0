Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E010B6D1A00
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjCaIex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCaIev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:34:51 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7272686
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:48 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l27so21596868wrb.2
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251687;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aHrUnZC9rbzLW/5UuslNdsLyDWCrAVuJNyAo7I4AMWQ=;
        b=VSeZX4dc6a1VHevFk6wYWuUx52Fu1aDq9jL8sgwwVCVS6BBHwfpIjUAHhDS6/7LhrO
         qvPhrOnqjIRoN4IHis7BjDY2Gz5jG7IM2GPdWI3rFajdqF7lzgAzv423Du3Wy8UctYbP
         RX5ePrSTKYkxKduq+ZOk3zHJjVM4OGrWJjXnW+nw2mO1udYxTN/dH9hwLlB/JY/WSnKQ
         GBmPPmXKlPgQnSP2t0s76UrTT0OUXFoxmgtq6rFkjckZjvcS6zS0j0T98sHnYNTqIeWz
         bFvRuWLo1dCLgQbsHfW0sAeXXwRWuDZjWfRtk8nyIgSD3JAb+5jv0Qg5Qj5gCgiUly/P
         +UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251687;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHrUnZC9rbzLW/5UuslNdsLyDWCrAVuJNyAo7I4AMWQ=;
        b=5OUx4IDjqOy+9BUpltw9AeUqOHhfLII+pX1pOnQGjMS0qUko9azt7ZLIpqL7iDW/c7
         3GwbkS0nx2ry3y1Y5pUu5iXxIN/y3V3PO6GTiQMR/BDh8TBTf9up/QHUMfseMsZT+GZl
         5GD8Yb03wmxnKPhBt8yFTcg6csZ6JHwVJIRJmLQ6AlonJZUVsNRk6u7QBlhKICRQtcDu
         5mpvBbAke6zgdDSzPfNd4dQZe/Ooss/iHowSodMdAlRycL33ggYS22q69a/ihP5dJlmc
         KmTRsO4V1h8nb+qLFiHunX7wEXF/DCLLO5JCn3uzoVYUSD3loZ4lUJ/KwawPxe4kPpB+
         +NqA==
X-Gm-Message-State: AAQBX9c1+L4Cz/xQ87eaLoGS36qEgdZigwpuf7PBsjZI92TU7r3FiumD
        rYMkOgKPd/cU7loh19AbOdbyXw==
X-Google-Smtp-Source: AKy350bTtpPmDWoxvdz6mCtcYISz/1Ys9qi/+iO21shv0+wBfNCQorzQUaMEiY+swVm6wHSWmwrb0w==
X-Received: by 2002:adf:ff89:0:b0:2cf:e957:644b with SMTP id j9-20020adfff89000000b002cfe957644bmr6630729wrr.27.1680251686957;
        Fri, 31 Mar 2023 01:34:46 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:46 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:40 +0200
Subject: [PATCH RFC 02/20] ARM: oxnas: remove OXNAS support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-2-5bd58fd1dd1f@linaro.org>
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
and since no new features will ever be added upstream, remove support
for OX810 and OX820 ARM support.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 arch/arm/Makefile            |  1 -
 arch/arm/mach-oxnas/Kconfig  | 34 ----------------------------------
 arch/arm/mach-oxnas/Makefile |  1 -
 3 files changed, 36 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 485a439e22ca..547e5856eaa0 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -203,7 +203,6 @@ machine-$(CONFIG_ARCH_MSTARV7)		+= mstar
 machine-$(CONFIG_ARCH_NOMADIK)		+= nomadik
 machine-$(CONFIG_ARCH_NPCM)		+= npcm
 machine-$(CONFIG_ARCH_NSPIRE)		+= nspire
-machine-$(CONFIG_ARCH_OXNAS)		+= oxnas
 machine-$(CONFIG_ARCH_OMAP1)		+= omap1
 machine-$(CONFIG_ARCH_OMAP2PLUS)	+= omap2
 machine-$(CONFIG_ARCH_ORION5X)		+= orion5x
diff --git a/arch/arm/mach-oxnas/Kconfig b/arch/arm/mach-oxnas/Kconfig
deleted file mode 100644
index a054235c3d6c..000000000000
--- a/arch/arm/mach-oxnas/Kconfig
+++ /dev/null
@@ -1,34 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-menuconfig ARCH_OXNAS
-	bool "Oxford Semiconductor OXNAS Family SoCs"
-	depends on (ARCH_MULTI_V5 && CPU_LITTLE_ENDIAN) || ARCH_MULTI_V6
-	select ARCH_HAS_RESET_CONTROLLER
-	select COMMON_CLK_OXNAS
-	select GPIOLIB
-	select MFD_SYSCON
-	select OXNAS_RPS_TIMER
-	select PINCTRL_OXNAS
-	select RESET_CONTROLLER
-	select RESET_OXNAS
-	select VERSATILE_FPGA_IRQ
-	select PINCTRL
-	help
-	  Support for OxNas SoC family developed by Oxford Semiconductor.
-
-if ARCH_OXNAS
-
-config MACH_OX810SE
-	bool "Support OX810SE Based Products"
-	depends on ARCH_MULTI_V5
-	select CPU_ARM926T
-	help
-	  Include Support for the Oxford Semiconductor OX810SE SoC Based Products.
-
-config MACH_OX820
-	bool "Support OX820 Based Products"
-	depends on ARCH_MULTI_V6
-	select ARM_GIC
-	help
-	  Include Support for the Oxford Semiconductor OX820 SoC Based Products.
-
-endif
diff --git a/arch/arm/mach-oxnas/Makefile b/arch/arm/mach-oxnas/Makefile
deleted file mode 100644
index a4e40e534e6a..000000000000
--- a/arch/arm/mach-oxnas/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only

-- 
2.34.1

