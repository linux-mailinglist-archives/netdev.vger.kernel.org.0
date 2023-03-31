Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D636D1A27
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjCaIfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjCaIe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:34:58 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C33A1C1FB
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i9so21596999wrp.3
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251692;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7wf9SwyOhQz7g6EiRpZy5Wi8C0ELh2QJL8BxOtMQjNQ=;
        b=KOfHL6QnQCbHbqPXUqo6ZvEG2z1yZ++Zi9D2AelVIxvkp3v4CBUgHj9Knl5oyIiOkB
         RrLOU3ZwudVZ4jmfljtYSayheSg0vohkiDofTFnTQhoEha1hc0cuTi9XKRouKDzXZhEr
         J9XyeJo0ntnzkjZsx99LRBmjqS5GHaMww2M2xDFwaAvJzpSGXfs/qmrNrcmQRbSAdJ9P
         xmGZEQokLL06b9oHiwSanHGu2Q5TyyUzNnrPVGdbyUw9MDXkSyki0njbE2Agt7SfqB0D
         D7v/KRdGjRtIvJ2ttztoo255ZEcYzA6ZAXEMdFTzwMRTu+yhrAtLfGcHK4n+pYDtPeRB
         Recg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251692;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7wf9SwyOhQz7g6EiRpZy5Wi8C0ELh2QJL8BxOtMQjNQ=;
        b=f4WE+vxl9EPMZf8mcwfdnZk3xNcbhk13F/DyUZ+CyGXhqR2Azb95bp/GqKWr1lrjjd
         wtgfjtQEH8O1fwhiud0Ppn1RPnUFDY2UWa8aKUU03/yT1A66shjblZraxzCxTIv3aNOf
         4zvxkPZ9qvQVePKZroWKIl9tDHYnFJ7kYZE0JO6cG3MqQ7cCrZivTogvOjAJ3kuNkFzz
         ZQNLZYJDjzmcsGjIElT98FoazkGTFhWZL9ED9g0SSec3ZXasDnlDJ7qu+d1eoBdgm6a4
         /jGDznMWZIuaoOfjtKBUn3D/p3Bi6+F7GwUTpkjA5BZRpAwX7Hxj4hV/uaHxd3ej4T9c
         Nx8w==
X-Gm-Message-State: AAQBX9efU43awrros1j3PatwBEHa4BeBEtJHWQI3MgLKPJDjHsl5ZtGG
        fM7C1M4KgVupRSr0+caDI1W9uQ==
X-Google-Smtp-Source: AKy350abqfIAr0v3P1V1HSk/CRdjBgvVisNOx4Kso+mcTsWdfBK5jYsqahojN5zQQJmGitx5MuUOFA==
X-Received: by 2002:adf:ff85:0:b0:2e4:aa42:787e with SMTP id j5-20020adfff85000000b002e4aa42787emr4054721wrr.51.1680251692431;
        Fri, 31 Mar 2023 01:34:52 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:52 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:44 +0200
Subject: [PATCH RFC 06/20] dt-bindings: clk: oxnas: remove obsolete
 bindings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-6-5bd58fd1dd1f@linaro.org>
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
OX810 and OX820 clock bindings.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/clock/oxnas,stdclk.txt     | 28 ----------------------
 1 file changed, 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/oxnas,stdclk.txt b/Documentation/devicetree/bindings/clock/oxnas,stdclk.txt
deleted file mode 100644
index b652f3fb7796..000000000000
--- a/Documentation/devicetree/bindings/clock/oxnas,stdclk.txt
+++ /dev/null
@@ -1,28 +0,0 @@
-Oxford Semiconductor OXNAS SoC Family Standard Clocks
-================================================
-
-Please also refer to clock-bindings.txt in this directory for common clock
-bindings usage.
-
-Required properties:
-- compatible: For OX810SE, should be "oxsemi,ox810se-stdclk"
-	      For OX820, should be "oxsemi,ox820-stdclk"
-- #clock-cells: 1, see below
-
-Parent node should have the following properties :
-- compatible: For OX810SE, should be
-		"oxsemi,ox810se-sys-ctrl", "syscon", "simple-mfd"
-	      For OX820, should be
-		"oxsemi,ox820-sys-ctrl", "syscon", "simple-mfd"
-
-example:
-
-sys: sys-ctrl@000000 {
-	compatible = "oxsemi,ox810se-sys-ctrl", "syscon", "simple-mfd";
-	reg = <0x000000 0x100000>;
-
-	stdclk: stdclk {
-		compatible = "oxsemi,ox810se-stdclk";
-		#clock-cells = <1>;
-	};
-};

-- 
2.34.1

