Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB16862F78B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbiKROe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242425AbiKROdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:33:49 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497152790E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:33:38 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 5so3758499wmo.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8lUWDOeXjkH9UHmo38dtGs19w/rqs9Sy4VJSCBQlaI=;
        b=oDWz/pVsf+cFAzOAOBv41AAAHEW5ljeCUEwzki0jVdZ1JNRLYDVZqUUxfbHny9q643
         fO4ZpGeaHPCMjmBzrPADNC+gBiHTXx7m6eypZMNLgI27Ozc/hPzmnJKtuj7jyGu1effk
         3H0eauS3fMm/TYNuSxfmDQ/DLUGxByrvAB1couqbfCMQOA39ujMBvf5e3W7Yxtz6qzj9
         E1Qf3Ff9AT8I7Mr1E7zseEaF7WH75RqoMCMFUMCw2Tx5tKaSpOMneq3yhCrb/0OpRw/2
         A1lhamyhxw/X19HDLcgQgqS27L4V3Cf+8/wuOdhrHgn6+txxa2lcydl91VSTbLk5Ip1r
         3+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8lUWDOeXjkH9UHmo38dtGs19w/rqs9Sy4VJSCBQlaI=;
        b=SKF6iktQGomHtIaUqp/c1LD+MVT1mXu+9SYnNhgzbf6vxnnMXCEzKoj0LRKpyvo59A
         1bJLBWxolgFLFgCWV5FK9h5+T8P4W5MuLQ97bCzt3JQYDObt0VK8absXCKHH/VweaB4D
         sEEyOLk9OnaxHQyoltET5tLuqbyD3zOd4I+Rjx2JOGRCbsQoEivBkj78vcCbs4nNtn2Z
         +j/onaZ6uFRhEsiHUfThfzIrExHCeQh8tWnV1Qrp6Cf0ysUlFBYJJeepVvnzW9bwJF3j
         MXaa/ZnGdvdgi/jAP2a13GVs3+pB1jTxQa1KyzqmY91VDYcIxr1TEVGF+0gsTVWZ2cW/
         XyDw==
X-Gm-Message-State: ANoB5pmu+KIYX6UuPFvK8HQ45S1pHwH9SWcqZCr6miniihbi/80BnZjl
        iv+gTqg9NT9dV/+7dWuaYiY8GA==
X-Google-Smtp-Source: AA0mqf58oHI/7To3+CZoBl7djIZXtAy//xIgmpt08lgvBcuLlZjN5W390xyBDOKkHM9CY2J0U3XElg==
X-Received: by 2002:a7b:cd85:0:b0:3cf:931c:3cfa with SMTP id y5-20020a7bcd85000000b003cf931c3cfamr5085059wmj.203.1668782016660;
        Fri, 18 Nov 2022 06:33:36 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id j21-20020a05600c1c1500b003cfb7c02542sm5436726wms.11.2022.11.18.06.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 06:33:36 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 18 Nov 2022 15:33:30 +0100
Subject: [PATCH 04/12] dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        devicetree@vger.kernel.org
X-Mailer: b4 0.10.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Amlogic Meson6 SoCs Watchdog timer bindings to dt-schema.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../bindings/watchdog/amlogic,meson6-wdt.yaml      | 39 ++++++++++++++++++++++
 .../devicetree/bindings/watchdog/meson-wdt.txt     | 21 ------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/watchdog/amlogic,meson6-wdt.yaml b/Documentation/devicetree/bindings/watchdog/amlogic,meson6-wdt.yaml
new file mode 100644
index 000000000000..4e33a5a9c23c
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/amlogic,meson6-wdt.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/watchdog/amlogic,meson6-wdt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Amlogic Meson6 SoCs Watchdog timer
+
+maintainers:
+  - Neil Armstrong <neil.armstrong@linaro.org>
+  - Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+
+allOf:
+  - $ref: watchdog.yaml#
+
+properties:
+  compatible:
+    enum:
+      - amlogic,meson6-wdt
+      - amlogic,meson8-wdt
+      - amlogic,meson8b-wdt
+      - amlogic,meson8m2-wdt
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    wdt: watchdog@c1109900 {
+        compatible = "amlogic,meson6-wdt";
+        reg = <0xc1109900 0x8>;
+        timeout-sec = <10>;
+    };
diff --git a/Documentation/devicetree/bindings/watchdog/meson-wdt.txt b/Documentation/devicetree/bindings/watchdog/meson-wdt.txt
deleted file mode 100644
index 7588cc3971bf..000000000000
--- a/Documentation/devicetree/bindings/watchdog/meson-wdt.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-Meson SoCs Watchdog timer
-
-Required properties:
-
-- compatible : depending on the SoC this should be one of:
-	"amlogic,meson6-wdt" on Meson6 SoCs
-	"amlogic,meson8-wdt" and "amlogic,meson6-wdt" on Meson8 SoCs
-	"amlogic,meson8b-wdt" on Meson8b SoCs
-	"amlogic,meson8m2-wdt" and "amlogic,meson8b-wdt" on Meson8m2 SoCs
-- reg : Specifies base physical address and size of the registers.
-
-Optional properties:
-- timeout-sec: contains the watchdog timeout in seconds.
-
-Example:
-
-wdt: watchdog@c1109900 {
-	compatible = "amlogic,meson6-wdt";
-	reg = <0xc1109900 0x8>;
-	timeout-sec = <10>;
-};

-- 
b4 0.10.1
