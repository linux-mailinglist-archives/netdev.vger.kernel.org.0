Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BE74EC795
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347634AbiC3O7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343640AbiC3O7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:59:30 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F991015;
        Wed, 30 Mar 2022 07:57:44 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id t21so17417236oie.11;
        Wed, 30 Mar 2022 07:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSfEQO0bCh0nDyQ9qhTmTRZQ1X0//dQhKQ3Dpna4X7w=;
        b=apgefiBLZueeB+TeXoh1goNUq1RZFdl5UjdIR6wqBEzihXfTowz3xkafZxlaAoBsOD
         9S2Wcu+lMHllbyJ30iPlgmkZmSBWQSYlL7dNzG4xX4xn74swzT2SIJoVS8opxzM/IIby
         d/mvWkpet3TH57VHcoVD+mQkdu8i+ZfyXCkHBsWaAnVN9PdKiwkfUoyJXQgeaz5m/3bs
         DfcFah2Apu+VlGIfi0AiszaL0gGJKg+UXm3/n/T/BgUjFbk1T2ciNpI0AKzQZU1O8eS+
         r8klJs07i7tnv8c/l4DwKAypTBhAWp2kgqnWxA1Cc+HfhmYIYQ4Bh7qlJQcwO5JpWNPV
         S9Tw==
X-Gm-Message-State: AOAM530FGAiNhuQ5GytfhgLsh1ungLQW4vMl2O4LXahW6cG43cwp6L8k
        FTYNlgFG8x5oo9XJJzNDWw==
X-Google-Smtp-Source: ABdhPJyO9caym3ecNNjX3Xmni63Dn2eyM3izo3ssn+B5dwefmSlxCHWIHvCvO0bc2Q7tk5DfdVMbqg==
X-Received: by 2002:aca:d04:0:b0:2ef:8b45:d235 with SMTP id 4-20020aca0d04000000b002ef8b45d235mr2040850oin.253.1648652263839;
        Wed, 30 Mar 2022 07:57:43 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id 1-20020a056870128100b000db2a59f643sm9910278oal.42.2022.03.30.07.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:57:42 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Dmitry Osipenko <digetx@gmail.com>, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: [PATCH] dt-bindings: Fix incomplete if/then/else schemas
Date:   Wed, 30 Mar 2022 09:57:41 -0500
Message-Id: <20220330145741.3044896-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent review highlighted that the json-schema meta-schema allows any
combination of if/then/else schema keywords even though if, then or else
by themselves makes little sense. With an added meta-schema to only
allow valid combinations, there's a handful of schemas found which need
fixing in a variety of ways. Incorrect indentation is the most common
issue.

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michael Hennerich <Michael.Hennerich@analog.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Olivier Moysan <olivier.moysan@foss.st.com>
Cc: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: linux-iio@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-phy@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/iio/adc/adi,ad7476.yaml          |  1 +
 .../bindings/iio/adc/st,stm32-dfsdm-adc.yaml  |  8 +-
 .../bindings/iio/dac/adi,ad5360.yaml          |  6 +-
 .../bindings/interconnect/qcom,rpm.yaml       | 84 +++++++++----------
 .../bindings/mmc/nvidia,tegra20-sdhci.yaml    |  2 +
 .../bindings/net/ti,davinci-mdio.yaml         |  1 +
 .../bindings/phy/nvidia,tegra20-usb-phy.yaml  | 20 ++---
 .../bindings/phy/qcom,usb-hs-phy.yaml         | 36 ++++----
 .../bindings/regulator/fixed-regulator.yaml   | 34 ++++----
 .../bindings/sound/st,stm32-sai.yaml          |  6 +-
 .../devicetree/bindings/sram/sram.yaml        | 16 ++--
 11 files changed, 108 insertions(+), 106 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7476.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7476.yaml
index cf711082ad7d..666414a9c0de 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7476.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7476.yaml
@@ -98,6 +98,7 @@ allOf:
               - ti,adc121s
               - ti,ads7866
               - ti,ads7868
+    then:
       required:
         - vcc-supply
   # Devices with a vref
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
index 7c260f209687..912372706280 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
@@ -174,7 +174,7 @@ patternProperties:
               contains:
                 const: st,stm32-dfsdm-adc
 
-      - then:
+        then:
           properties:
             st,adc-channels:
               minItems: 1
@@ -206,7 +206,7 @@ patternProperties:
               contains:
                 const: st,stm32-dfsdm-dmic
 
-      - then:
+        then:
           properties:
             st,adc-channels:
               maxItems: 1
@@ -254,7 +254,7 @@ allOf:
           contains:
             const: st,stm32h7-dfsdm
 
-  - then:
+    then:
       patternProperties:
         "^filter@[0-9]+$":
           properties:
@@ -269,7 +269,7 @@ allOf:
           contains:
             const: st,stm32mp1-dfsdm
 
-  - then:
+    then:
       patternProperties:
         "^filter@[0-9]+$":
           properties:
diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5360.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5360.yaml
index 0d8fb56f4b09..65f86f26947c 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5360.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5360.yaml
@@ -59,9 +59,9 @@ allOf:
           contains:
             enum:
               - adi,ad5371
-      then:
-        required:
-          - vref2-supply
+    then:
+      required:
+        - vref2-supply
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpm.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpm.yaml
index 89853b482513..8a676fef8c1d 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,rpm.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,rpm.yaml
@@ -93,48 +93,48 @@ allOf:
               - qcom,sdm660-gnoc
               - qcom,sdm660-snoc
 
-      then:
-        properties:
-          clock-names:
-            items:
-              - const: bus
-              - const: bus_a
-
-          clocks:
-            items:
-              - description: Bus Clock
-              - description: Bus A Clock
-
-        # Child node's properties
-        patternProperties:
-          '^interconnect-[a-z0-9]+$':
-            type: object
-            description:
-              snoc-mm is a child of snoc, sharing snoc's register address space.
-
-            properties:
-              compatible:
-                enum:
-                  - qcom,msm8939-snoc-mm
-
-              '#interconnect-cells':
-                const: 1
-
-              clock-names:
-                items:
-                  - const: bus
-                  - const: bus_a
-
-              clocks:
-                items:
-                  - description: Bus Clock
-                  - description: Bus A Clock
-
-            required:
-              - compatible
-              - '#interconnect-cells'
-              - clock-names
-              - clocks
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: bus
+            - const: bus_a
+
+        clocks:
+          items:
+            - description: Bus Clock
+            - description: Bus A Clock
+
+      # Child node's properties
+      patternProperties:
+        '^interconnect-[a-z0-9]+$':
+          type: object
+          description:
+            snoc-mm is a child of snoc, sharing snoc's register address space.
+
+          properties:
+            compatible:
+              enum:
+                - qcom,msm8939-snoc-mm
+
+            '#interconnect-cells':
+              const: 1
+
+            clock-names:
+              items:
+                - const: bus
+                - const: bus_a
+
+            clocks:
+              items:
+                - description: Bus Clock
+                - description: Bus A Clock
+
+          required:
+            - compatible
+            - '#interconnect-cells'
+            - clock-names
+            - clocks
 
   - if:
       properties:
diff --git a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml
index ce64b3498378..f3f4d5b02744 100644
--- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.yaml
@@ -197,6 +197,8 @@ allOf:
               - nvidia,tegra30-sdhci
               - nvidia,tegra114-sdhci
               - nvidia,tegra124-sdhci
+    then:
+      properties:
         clocks:
           items:
             - description: module clock
diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
index dbfca5ee9139..6f44f9516c36 100644
--- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
@@ -56,6 +56,7 @@ if:
     compatible:
       contains:
         const: ti,davinci_mdio
+then:
   required:
     - bus_freq
 
diff --git a/Documentation/devicetree/bindings/phy/nvidia,tegra20-usb-phy.yaml b/Documentation/devicetree/bindings/phy/nvidia,tegra20-usb-phy.yaml
index dfde0eaf66e1..d61585c96e31 100644
--- a/Documentation/devicetree/bindings/phy/nvidia,tegra20-usb-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/nvidia,tegra20-usb-phy.yaml
@@ -275,17 +275,17 @@ allOf:
           - nvidia,hssquelch-level
           - nvidia,hsdiscon-level
 
-        else:
-          properties:
-            clocks:
-              maxItems: 4
+      else:
+        properties:
+          clocks:
+            maxItems: 4
 
-            clock-names:
-              items:
-                - const: reg
-                - const: pll_u
-                - const: timer
-                - const: utmi-pads
+          clock-names:
+            items:
+              - const: reg
+              - const: pll_u
+              - const: timer
+              - const: utmi-pads
 
   - if:
       properties:
diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml
index e23e5590eaa3..49f4aff93d62 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml
@@ -14,24 +14,24 @@ if:
     compatible:
       contains:
         const: qcom,usb-hs-phy-apq8064
-  then:
-    properties:
-      resets:
-        maxItems: 1
-
-      reset-names:
-        const: por
-
-  else:
-    properties:
-      resets:
-        minItems: 2
-        maxItems: 2
-
-      reset-names:
-        items:
-          - const: phy
-          - const: por
+then:
+  properties:
+    resets:
+      maxItems: 1
+
+    reset-names:
+      const: por
+
+else:
+  properties:
+    resets:
+      minItems: 2
+      maxItems: 2
+
+    reset-names:
+      items:
+        - const: phy
+        - const: por
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml b/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
index 9b131c6facbc..84eeaef179a5 100644
--- a/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
@@ -18,23 +18,23 @@ description:
 
 allOf:
   - $ref: "regulator.yaml#"
-
-if:
-  properties:
-    compatible:
-      contains:
-        const: regulator-fixed-clock
-  required:
-    - clocks
-else:
-  if:
-    properties:
-      compatible:
-        contains:
-          const: regulator-fixed-domain
-    required:
-      - power-domains
-      - required-opps
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: regulator-fixed-clock
+    then:
+      required:
+        - clocks
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: regulator-fixed-domain
+    then:
+      required:
+        - power-domains
+        - required-opps
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index b3dbcba33e41..fe2e15504ebc 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -136,8 +136,7 @@ allOf:
         compatible:
           contains:
             const: st,stm32f4-sai
-
-  - then:
+    then:
       properties:
         clocks:
           items:
@@ -148,8 +147,7 @@ allOf:
           items:
             - const: x8k
             - const: x11k
-
-  - else:
+    else:
       properties:
         clocks:
           items:
diff --git a/Documentation/devicetree/bindings/sram/sram.yaml b/Documentation/devicetree/bindings/sram/sram.yaml
index 668a9a41a775..993430be355b 100644
--- a/Documentation/devicetree/bindings/sram/sram.yaml
+++ b/Documentation/devicetree/bindings/sram/sram.yaml
@@ -136,14 +136,14 @@ required:
   - reg
 
 if:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - qcom,rpm-msg-ram
-          - rockchip,rk3288-pmu-sram
-
-else:
+  not:
+    properties:
+      compatible:
+        contains:
+          enum:
+            - qcom,rpm-msg-ram
+            - rockchip,rk3288-pmu-sram
+then:
   required:
     - "#address-cells"
     - "#size-cells"
-- 
2.32.0

