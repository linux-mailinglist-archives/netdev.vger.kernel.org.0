Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016FD3F6A5B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhHXUVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 16:21:03 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:41658 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHXUVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 16:21:02 -0400
Received: by mail-ot1-f43.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso34570762ota.8;
        Tue, 24 Aug 2021 13:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XGOKN6mGxhbzHX6KGLM07SrG99SjeiH8yw3t71J8Izs=;
        b=biM8640T7a8wqUrJzY+WI2/BQ9U8XlyImlRA5gHZtpN6K2AYQ/P729WabmoEB1CaK5
         rwE+BhZ1jcGdBcp7+hipwEzCQx/vpKBT9tllEi7AMjcHRHUgFMk+vppBKsRZT3TegXex
         XucL7BPg9xbIW3NBdAW5UI+SDimbOPUR7aPRPcZlaE3g/pvbvCDnU+SW8eYbvdLkC0fr
         ES9CRZ1lusN2e9L1sAzvOemVwhtB+M5BFOoeSh1CLVWFcTrUX6OzG7RCF8p/5FmzbTZk
         4iTGfz2XBsJ/nTcrhhlyNbEmdvLpKX4R7R0VeLEoFm4nACkhhP2iI5yUtVrqa5YsHoph
         0GGQ==
X-Gm-Message-State: AOAM53043bj3WkgtXznEoubri3kQ0rO7qJ0glV5VyHKGkzokkYNxDVLf
        MCfPnhBSd8oG264QkHEIY7j37n418Q==
X-Google-Smtp-Source: ABdhPJw3e++rFJpQspnKwHqFcPLi3Yo+Es3bmpPs1nlv0eJUlxfR2mBSgz2g8EfK28QcsnnNwzNS0w==
X-Received: by 2002:a05:6808:54f:: with SMTP id i15mr4278045oig.121.1629836416392;
        Tue, 24 Aug 2021 13:20:16 -0700 (PDT)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id h14sm4810168otm.5.2021.08.24.13.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 13:20:15 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Vignesh R <vigneshr@ti.com>, Marc Zyngier <maz@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-spi@vger.kernel.org
Subject: [PATCH] dt-bindings: Use 'enum' instead of 'oneOf' plus 'const' entries
Date:   Tue, 24 Aug 2021 15:20:14 -0500
Message-Id: <20210824202014.978922-1-robh@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'enum' is equivalent to 'oneOf' with a list of 'const' entries, but 'enum'
is more concise and yields better error messages.

Cc: Vinod Koul <vkoul@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Vignesh R <vigneshr@ti.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-phy@lists.infradead.org
Cc: linux-serial@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-spi@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/display/msm/dsi-phy-10nm.yaml           |  6 +++---
 .../bindings/display/msm/dsi-phy-14nm.yaml           |  6 +++---
 .../bindings/display/msm/dsi-phy-28nm.yaml           |  8 ++++----
 .../bindings/dma/allwinner,sun6i-a31-dma.yaml        | 12 ++++++------
 .../devicetree/bindings/firmware/arm,scpi.yaml       |  6 +++---
 .../devicetree/bindings/i2c/ti,omap4-i2c.yaml        | 10 +++++-----
 .../interrupt-controller/loongson,liointc.yaml       |  8 ++++----
 .../devicetree/bindings/media/i2c/mipi-ccs.yaml      |  8 ++++----
 .../devicetree/bindings/mfd/ti,lp87565-q1.yaml       |  6 +++---
 .../devicetree/bindings/net/realtek-bluetooth.yaml   |  8 ++++----
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml          |  8 ++++----
 .../devicetree/bindings/net/ti,k3-am654-cpts.yaml    |  6 +++---
 Documentation/devicetree/bindings/pci/loongson.yaml  |  8 ++++----
 .../devicetree/bindings/phy/intel,lgm-emmc-phy.yaml  |  6 +++---
 .../devicetree/bindings/serial/8250_omap.yaml        |  9 +++++----
 .../devicetree/bindings/sound/qcom,sm8250.yaml       |  6 +++---
 .../devicetree/bindings/sound/tlv320adcx140.yaml     |  8 ++++----
 .../devicetree/bindings/spi/realtek,rtl-spi.yaml     | 12 ++++++------
 .../devicetree/bindings/timer/arm,sp804.yaml         |  6 +++---
 19 files changed, 74 insertions(+), 73 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml b/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
index 4a26bef19360..4399715953e1 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml
@@ -14,9 +14,9 @@ allOf:
 
 properties:
   compatible:
-    oneOf:
-      - const: qcom,dsi-phy-10nm
-      - const: qcom,dsi-phy-10nm-8998
+    enum:
+      - qcom,dsi-phy-10nm
+      - qcom,dsi-phy-10nm-8998
 
   reg:
     items:
diff --git a/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml b/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
index 72a00cce0147..064df50e21a5 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml
@@ -14,9 +14,9 @@ allOf:
 
 properties:
   compatible:
-    oneOf:
-      - const: qcom,dsi-phy-14nm
-      - const: qcom,dsi-phy-14nm-660
+    enum:
+      - qcom,dsi-phy-14nm
+      - qcom,dsi-phy-14nm-660
 
   reg:
     items:
diff --git a/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml b/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
index b106007116b4..69eecaa64b18 100644
--- a/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml
@@ -14,10 +14,10 @@ allOf:
 
 properties:
   compatible:
-    oneOf:
-      - const: qcom,dsi-phy-28nm-hpm
-      - const: qcom,dsi-phy-28nm-lp
-      - const: qcom,dsi-phy-28nm-8960
+    enum:
+      - qcom,dsi-phy-28nm-hpm
+      - qcom,dsi-phy-28nm-lp
+      - qcom,dsi-phy-28nm-8960
 
   reg:
     items:
diff --git a/Documentation/devicetree/bindings/dma/allwinner,sun6i-a31-dma.yaml b/Documentation/devicetree/bindings/dma/allwinner,sun6i-a31-dma.yaml
index c1676b96daac..a6df6f8b54db 100644
--- a/Documentation/devicetree/bindings/dma/allwinner,sun6i-a31-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/allwinner,sun6i-a31-dma.yaml
@@ -19,12 +19,12 @@ properties:
     description: The cell is the request line number.
 
   compatible:
-    oneOf:
-      - const: allwinner,sun6i-a31-dma
-      - const: allwinner,sun8i-a23-dma
-      - const: allwinner,sun8i-a83t-dma
-      - const: allwinner,sun8i-h3-dma
-      - const: allwinner,sun8i-v3s-dma
+    enum:
+      - allwinner,sun6i-a31-dma
+      - allwinner,sun8i-a23-dma
+      - allwinner,sun8i-a83t-dma
+      - allwinner,sun8i-h3-dma
+      - allwinner,sun8i-v3s-dma
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/firmware/arm,scpi.yaml b/Documentation/devicetree/bindings/firmware/arm,scpi.yaml
index d7113b06454b..23b346bd1252 100644
--- a/Documentation/devicetree/bindings/firmware/arm,scpi.yaml
+++ b/Documentation/devicetree/bindings/firmware/arm,scpi.yaml
@@ -131,9 +131,9 @@ properties:
 
         properties:
           compatible:
-            oneOf:
-              - const: arm,scpi-dvfs-clocks
-              - const: arm,scpi-variable-clocks
+            enum:
+              - arm,scpi-dvfs-clocks
+              - arm,scpi-variable-clocks
 
           '#clock-cells':
             const: 1
diff --git a/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml b/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml
index ff165ad1bee8..db0843be91c5 100644
--- a/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/ti,omap4-i2c.yaml
@@ -72,11 +72,11 @@ additionalProperties: false
 if:
   properties:
     compatible:
-      oneOf:
-        - const: ti,omap2420-i2c
-        - const: ti,omap2430-i2c
-        - const: ti,omap3-i2c
-        - const: ti,omap4-i2c
+      enum:
+        - ti,omap2420-i2c
+        - ti,omap2430-i2c
+        - ti,omap3-i2c
+        - ti,omap4-i2c
 
 then:
   properties:
diff --git a/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml b/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml
index edf26452dc72..750cc44628e9 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/loongson,liointc.yaml
@@ -19,10 +19,10 @@ allOf:
 
 properties:
   compatible:
-    oneOf:
-      - const: loongson,liointc-1.0
-      - const: loongson,liointc-1.0a
-      - const: loongson,liointc-2.0
+    enum:
+      - loongson,liointc-1.0
+      - loongson,liointc-1.0a
+      - loongson,liointc-2.0
 
   reg:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml b/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml
index 701f4e0d138f..39395ea8c318 100644
--- a/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/mipi-ccs.yaml
@@ -83,10 +83,10 @@ properties:
           link-frequencies: true
           data-lanes: true
           bus-type:
-            oneOf:
-              - const: 1 # CSI-2 C-PHY
-              - const: 3 # CCP2
-              - const: 4 # CSI-2 D-PHY
+            enum:
+              - 1 # CSI-2 C-PHY
+              - 3 # CCP2
+              - 4 # CSI-2 D-PHY
 
         required:
           - link-frequencies
diff --git a/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml b/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml
index 48d4d53c25f9..012d25111054 100644
--- a/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml
+++ b/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml
@@ -11,9 +11,9 @@ maintainers:
 
 properties:
   compatible:
-    oneOf:
-      - const: ti,lp87565
-      - const: ti,lp87565-q1
+    enum:
+      - ti,lp87565
+      - ti,lp87565-q1
 
   reg:
     description: I2C slave address
diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 4f485df69ac3..0634e69dd9a6 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -17,10 +17,10 @@ description:
 
 properties:
   compatible:
-    oneOf:
-      - const: "realtek,rtl8723bs-bt"
-      - const: "realtek,rtl8723cs-bt"
-      - const: "realtek,rtl8822cs-bt"
+    enum:
+      - realtek,rtl8723bs-bt
+      - realtek,rtl8723cs-bt
+      - realtek,rtl8822cs-bt
 
   device-wake-gpios:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 783b9e32cf66..4b97a0f1175b 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -53,10 +53,10 @@ properties:
   "#size-cells": true
 
   compatible:
-    oneOf:
-      - const: ti,am654-cpsw-nuss
-      - const: ti,j721e-cpsw-nuss
-      - const: ti,am642-cpsw-nuss
+    enum:
+      - ti,am654-cpsw-nuss
+      - ti,j721e-cpsw-nuss
+      - ti,am642-cpsw-nuss
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index 4317eba503ca..1a81bf70c88c 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -45,9 +45,9 @@ properties:
     pattern: "^cpts@[0-9a-f]+$"
 
   compatible:
-    oneOf:
-      - const: ti,am65-cpts
-      - const: ti,j721e-cpts
+    enum:
+      - ti,am65-cpts
+      - ti,j721e-cpts
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/pci/loongson.yaml b/Documentation/devicetree/bindings/pci/loongson.yaml
index 82bc6c486ca3..a8324a9bd002 100644
--- a/Documentation/devicetree/bindings/pci/loongson.yaml
+++ b/Documentation/devicetree/bindings/pci/loongson.yaml
@@ -17,10 +17,10 @@ allOf:
 
 properties:
   compatible:
-    oneOf:
-      - const: loongson,ls2k-pci
-      - const: loongson,ls7a-pci
-      - const: loongson,rs780e-pci
+    enum:
+      - loongson,ls2k-pci
+      - loongson,ls7a-pci
+      - loongson,rs780e-pci
 
   reg:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml b/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
index edd9d70a672a..954e67571dfd 100644
--- a/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
@@ -23,9 +23,9 @@ description: |+
 
 properties:
   compatible:
-    oneOf:
-      - const: intel,lgm-emmc-phy
-      - const: intel,keembay-emmc-phy
+    enum:
+      - intel,lgm-emmc-phy
+      - intel,keembay-emmc-phy
 
   "#phy-cells":
     const: 0
diff --git a/Documentation/devicetree/bindings/serial/8250_omap.yaml b/Documentation/devicetree/bindings/serial/8250_omap.yaml
index 1c826fcf5828..c987fb648c3c 100644
--- a/Documentation/devicetree/bindings/serial/8250_omap.yaml
+++ b/Documentation/devicetree/bindings/serial/8250_omap.yaml
@@ -90,10 +90,11 @@ additionalProperties: false
 if:
   properties:
     compatible:
-      oneOf:
-        - const: ti,omap2-uart
-        - const: ti,omap3-uart
-        - const: ti,omap4-uart
+      contains:
+        enum:
+          - ti,omap2-uart
+          - ti,omap3-uart
+          - ti,omap4-uart
 
 then:
   properties:
diff --git a/Documentation/devicetree/bindings/sound/qcom,sm8250.yaml b/Documentation/devicetree/bindings/sound/qcom,sm8250.yaml
index 72ad9ab91832..7d57eb91657a 100644
--- a/Documentation/devicetree/bindings/sound/qcom,sm8250.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,sm8250.yaml
@@ -15,9 +15,9 @@ description:
 
 properties:
   compatible:
-    oneOf:
-      - const: qcom,sm8250-sndcard
-      - const: qcom,qrb5165-rb5-sndcard
+    enum:
+      - qcom,sm8250-sndcard
+      - qcom,qrb5165-rb5-sndcard
 
   audio-routing:
     $ref: /schemas/types.yaml#/definitions/non-unique-string-array
diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
index 54d64785aad2..d77c8283526d 100644
--- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
+++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
@@ -24,10 +24,10 @@ description: |
 
 properties:
   compatible:
-    oneOf:
-      - const: ti,tlv320adc3140
-      - const: ti,tlv320adc5140
-      - const: ti,tlv320adc6140
+    enum:
+      - ti,tlv320adc3140
+      - ti,tlv320adc5140
+      - ti,tlv320adc6140
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/spi/realtek,rtl-spi.yaml b/Documentation/devicetree/bindings/spi/realtek,rtl-spi.yaml
index 30a62a211984..2f938c293f70 100644
--- a/Documentation/devicetree/bindings/spi/realtek,rtl-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/realtek,rtl-spi.yaml
@@ -15,12 +15,12 @@ allOf:
 
 properties:
   compatible:
-    oneOf:
-      - const: realtek,rtl8380-spi
-      - const: realtek,rtl8382-spi
-      - const: realtek,rtl8391-spi
-      - const: realtek,rtl8392-spi
-      - const: realtek,rtl8393-spi
+    enum:
+      - realtek,rtl8380-spi
+      - realtek,rtl8382-spi
+      - realtek,rtl8391-spi
+      - realtek,rtl8392-spi
+      - realtek,rtl8393-spi
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/timer/arm,sp804.yaml b/Documentation/devicetree/bindings/timer/arm,sp804.yaml
index 960e2bd66a97..41be7cdab2ec 100644
--- a/Documentation/devicetree/bindings/timer/arm,sp804.yaml
+++ b/Documentation/devicetree/bindings/timer/arm,sp804.yaml
@@ -23,9 +23,9 @@ select:
   properties:
     compatible:
       contains:
-        oneOf:
-          - const: arm,sp804
-          - const: hisilicon,sp804
+        enum:
+          - arm,sp804
+          - hisilicon,sp804
   required:
     - compatible
 
-- 
2.30.2

