Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3036D1A66
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjCaIhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCaIgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:36:33 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA771D871
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:13 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j36-20020a05600c1c2400b003f04057c152so1207649wms.5
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251704;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DTkJHErpGDJ9v7s3ekjmHN8aO4NJsl7q6Q7QZM8QMbI=;
        b=UGr6jhzO3hUVTB6rY7/leRAeWl750ZHVMPEYAKeTT4X06mEnwpBCz4Phsf+P7ItSjw
         TIi62QAKl2i4gwbJZgnixjiWLnYymuWJtQlev/UOTE8L3tTaSoTPelFszUO9MlZAhEBb
         svJnNSmQ+fTYwJwHOfZ+BnzUQABhVZKyZM2IISk4TAN6KerdE9+u76JqT768MMwy0WrZ
         hHa30huv6N2SbwamrxfA5MxDt5MO3eFrL7KNDytCeuOyhCtNf98GhPdjDroQkxFbYiio
         9lM6zhXS3q9g9LP/PSzlqPbEENCEjOSZL6tjJxXO/fNDHiRHf4knVvhNWSfCrnbGAaBR
         r18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251704;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DTkJHErpGDJ9v7s3ekjmHN8aO4NJsl7q6Q7QZM8QMbI=;
        b=jYuE14fs8AhNURTlEKbmU+VoD62K6MlEqQAdkYQL5QU0HCWSUlnBk8c+sI+LveRqqi
         noLB4w28hQ29J/IUWyE09ktasmCArLSIeETKZQoOPYH03DMcKjqj3tkVIK/zAu7tQW3/
         ffRRfzQr57D+wliOPJea2Fm1MRStIhh0YV/yMl47itWssT7BZIXQhCj+8day2pa28mVG
         IICFAch+h/L/Moz2pXFpgCAu3iJuxe2kFACdvrU6Z6x+cG0kasoWl8Hl4xVXz786opoX
         qZVzKiOXOxSkxpLXrbE6YJPf0ojP+gtYqvtvR3NwJa42PUXFQNyfsCGYr+pGRxIAVBv/
         bO8g==
X-Gm-Message-State: AO0yUKVrrFmUWelxth4dvdT0J5FRuSBVIX1r/KR6iyMOLP+rDbyEBBfL
        s3B/wi8m0O6zc+EupWdmEWDqtg==
X-Google-Smtp-Source: AK7set+EJ3ur6/ee9yCfqdjB5MLNFawGDsn0ZJD+xQ08Aa57oAcgfY47mb3l6TfHxYQ73tsX3o+sPw==
X-Received: by 2002:a1c:7714:0:b0:3ee:3f7:35aa with SMTP id t20-20020a1c7714000000b003ee03f735aamr21641887wmi.19.1680251703765;
        Fri, 31 Mar 2023 01:35:03 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:35:03 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:52 +0200
Subject: [PATCH RFC 14/20] dt-bindings: pinctrl: oxnas,pinctrl: remove
 obsolete bindings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-14-5bd58fd1dd1f@linaro.org>
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
OX810 and OX820 pinctrl bindings.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/pinctrl/oxnas,pinctrl.txt  | 56 ----------------------
 1 file changed, 56 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/oxnas,pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/oxnas,pinctrl.txt
deleted file mode 100644
index b1159434f593..000000000000
--- a/Documentation/devicetree/bindings/pinctrl/oxnas,pinctrl.txt
+++ /dev/null
@@ -1,56 +0,0 @@
-* Oxford Semiconductor OXNAS SoC Family Pin Controller
-
-Please refer to pinctrl-bindings.txt, ../gpio/gpio.txt, and
-../interrupt-controller/interrupts.txt for generic information regarding
-pin controller, GPIO, and interrupt bindings.
-
-OXNAS 'pin configuration node' is a node of a group of pins which can be
-used for a specific device or function. This node represents configurations of
-pins, optional function, and optional mux related configuration.
-
-Required properties for pin controller node:
- - compatible: "oxsemi,ox810se-pinctrl" or "oxsemi,ox820-pinctrl"
- - oxsemi,sys-ctrl: a phandle to the system controller syscon node
-
-Required properties for pin configuration sub-nodes:
- - pins: List of pins to which the configuration applies.
-
-Optional properties for pin configuration sub-nodes:
-----------------------------------------------------
- - function: Mux function for the specified pins.
- - bias-pull-up: Enable weak pull-up.
-
-Example:
-
-pinctrl: pinctrl {
-	compatible = "oxsemi,ox810se-pinctrl";
-
-	/* Regmap for sys registers */
-	oxsemi,sys-ctrl = <&sys>;
-
-	pinctrl_uart2: pinctrl_uart2 {
-		uart2a {
-			pins = "gpio31";
-			function = "fct3";
-		};
-		uart2b {
-			pins = "gpio32";
-			function = "fct3";
-		};
-	};
-};
-
-uart2: serial@900000 {
-	compatible = "ns16550a";
-	reg = <0x900000 0x100000>;
-	clocks = <&sysclk>;
-	interrupts = <29>;
-	reg-shift = <0>;
-	fifo-size = <16>;
-	reg-io-width = <1>;
-	current-speed = <115200>;
-	no-loopback-test;
-	resets = <&reset 22>;
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart2>;
-};

-- 
2.34.1

