Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2124D6D1A41
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjCaIgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjCaIfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:35:32 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FCA1D86F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t4so16349617wra.7
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251698;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OMp6WwOFyR6l2kpiboY0lzHLUJ9UsEpV8wMZ9XLNzc=;
        b=zpVKLNXIXAV4SUprLr3FH6VaLCVrQs08gq3PR6QBskuLieXpL9pEl0DVkVsySGg93E
         yLNJD1djIn/X5/LvUUqSRHXYEJVk7SAUsDK/K0+6UH1nscr58z0a2+WLSgpgFixAZ5s+
         XVlKqZi48mQZvF/zFCrX7vIRbb+FdULZG6d/Qp1a/u+lntuoZ8GZOg6zXBoOtlqkQjTl
         +3lMm0xkV7O4U1IG/ndjeBtRyTZWsdGzqvysaQJmpBAgxoXrpXG9j7WxvA4juS55aJJJ
         PrCK1zS9C4rMDksDfoq6YqSeSBN+2DD8GmU/GVEytLphbHRPoR6o2ael1PZWW4gdS9Sx
         DYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251698;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OMp6WwOFyR6l2kpiboY0lzHLUJ9UsEpV8wMZ9XLNzc=;
        b=C9k7jKTfbynM77J6ro1pSqX3qeoWaXytuEb/uP45vmdoKwq/P6GpyzqnvhzFu47WG+
         PGGbvg2z5F5urMpwoqcymbJli/4s3jiIGXoxNBHPvTAnXH1nE1GpThoPXe8sHTn7zFL4
         0zzzgXmBHfba/odUy6ds6cmJsflmfEgUuHoCHvhdxg9HrB5HDEB+7FczBNaKCBhv8Nc8
         zmVFZcy8glQD9VmqX/OFE6fnA1GbGnDj5jT2mo05qwmlfipTiWJPx6L0NPe4YRfDis7w
         6HsK2YUz7CqJOhTAwJFCqBa1YwVFdIHQ6N0gfrO0bVVABSMZT0AS+8CSq+U24ErsMf15
         1RUA==
X-Gm-Message-State: AAQBX9drgvXtYYRecVPPbb6N3d+umiv3U/UjwgR7FK3KbVWwyN+ag8pm
        Nj/7kjNG3sxSGDbHAzIfX9NoNw==
X-Google-Smtp-Source: AKy350ZEexxOqisnl/kxib2n7RjdcPxl4zAGraKXrJ/xa8HdVJ2bLN4RGB9qBmKUKQcdJQx9dqXdRg==
X-Received: by 2002:a5d:5342:0:b0:2ca:2794:87e8 with SMTP id t2-20020a5d5342000000b002ca279487e8mr19274846wrv.21.1680251698016;
        Fri, 31 Mar 2023 01:34:58 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:57 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:48 +0200
Subject: [PATCH RFC 10/20] dt-bindings: mtd: oxnas-nand: remove obsolete
 bindings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-10-5bd58fd1dd1f@linaro.org>
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
for OX810 and OX820 nand bindings.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/mtd/oxnas-nand.txt         | 41 ----------------------
 1 file changed, 41 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/oxnas-nand.txt b/Documentation/devicetree/bindings/mtd/oxnas-nand.txt
deleted file mode 100644
index 2ba07fc8b79c..000000000000
--- a/Documentation/devicetree/bindings/mtd/oxnas-nand.txt
+++ /dev/null
@@ -1,41 +0,0 @@
-* Oxford Semiconductor OXNAS NAND Controller
-
-Please refer to nand-controller.yaml for generic information regarding MTD NAND bindings.
-
-Required properties:
- - compatible: "oxsemi,ox820-nand"
- - reg: Base address and length for NAND mapped memory.
-
-Optional Properties:
- - clocks: phandle to the NAND gate clock if needed.
- - resets: phandle to the NAND reset control if needed.
-
-Example:
-
-nandc: nand-controller@41000000 {
-	compatible = "oxsemi,ox820-nand";
-	reg = <0x41000000 0x100000>;
-	clocks = <&stdclk CLK_820_NAND>;
-	resets = <&reset RESET_NAND>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	nand@0 {
-		reg = <0>;
-		#address-cells = <1>;
-		#size-cells = <1>;
-		nand-ecc-mode = "soft";
-		nand-ecc-algo = "hamming";
-
-		partition@0 {
-			label = "boot";
-			reg = <0x00000000 0x00e00000>;
-			read-only;
-		};
-
-		partition@e00000 {
-			label = "ubi";
-			reg = <0x00e00000 0x07200000>;
-		};
-	};
-};

-- 
2.34.1

