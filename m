Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C065493283
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 02:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350772AbiASBuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 20:50:51 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:40810 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243963AbiASBuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 20:50:44 -0500
Received: by mail-ot1-f50.google.com with SMTP id x31-20020a056830245f00b00599111c8b20so1010135otr.7;
        Tue, 18 Jan 2022 17:50:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XkUm5PnMuf0ElHUYe3H4Dy1W7Mm/I8Mk+B4qsZ7WCgs=;
        b=jccw7cWVilAD4zVi/zp8748A3geHKKwTLFTxvLng0OAgDF7AYTGdr5hniwpsDCHAB3
         Sj3P2KFmYzDSUlPYtAo8rfhRviWyfFA6HjTNc/PGJXSSX9KFG+PXNvVHqb1W7oy34Ych
         J4kPX6PXAIuX4p0P7jokgkHDuxJpSSmVJsSOYcP+ESSSB5zaqI/auyYkKRZYOUjPGIZ5
         DjUHwmDuaWKUst+griorh/9eFFgL37JeDJkkQfvbM1o0e334f0qGsU3EBkXwWWcqcTZk
         QjbxS0ucK+0Xcwvzrn4eS8MQR7uH0+Jp8SNXiRml1KuhLPCQVV9CI2Iff7Ui9JsDMw4t
         yWxQ==
X-Gm-Message-State: AOAM531WeLI+tmlf3Q+tJO0j/GNiSQggi4Eo2uutVDBb4y94/s7T6jzL
        fXUEUMPMeX+l5dOLB6YN6ESWeJnUEQ==
X-Google-Smtp-Source: ABdhPJyxdzVTHS2N8w9JrwO/YyaZ5aOl47SHRnODsxgvNkGDhTPHJzTxq14P4vVfArlitQ1rPfBvwA==
X-Received: by 2002:a9d:2206:: with SMTP id o6mr22937098ota.148.1642557042353;
        Tue, 18 Jan 2022 17:50:42 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id r25sm6875844ota.59.2022.01.18.17.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 17:50:41 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dmaengine@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Improve phandle-array schemas
Date:   Tue, 18 Jan 2022 19:50:38 -0600
Message-Id: <20220119015038.2433585-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'phandle-array' type is a bit ambiguous. It can be either just an
array of phandles or an array of phandles plus args. Many schemas for
phandle-array properties aren't clear in the schema which case applies
though the description usually describes it.

The array of phandles case boils down to needing:

items:
  maxItems: 1

The phandle plus args cases should typically take this form:

items:
  - items:
      - description: A phandle
      - description: 1st arg cell
      - description: 2nd arg cell

With this change, some examples need updating so that the bracketing of
property values matches the schema.

Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jingoo Han <jingoohan1@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Viresh Kumar <vireshk@kernel.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-ide@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: dmaengine@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: iommu@lists.linux-foundation.org
Cc: linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-can@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: linux-phy@lists.infradead.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-remoteproc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/arm/cpus.yaml         |  2 +
 .../devicetree/bindings/arm/idle-states.yaml  | 80 +++++++++----------
 .../devicetree/bindings/arm/pmu.yaml          |  2 +
 .../bindings/ata/sata_highbank.yaml           |  3 +
 .../bus/allwinner,sun50i-a64-de2.yaml         |  5 +-
 .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 15 +++-
 .../allwinner,sun4i-a10-display-engine.yaml   |  2 +
 .../display/mediatek/mediatek,hdmi.yaml       |  5 +-
 .../devicetree/bindings/display/msm/gpu.yaml  |  2 +
 .../bindings/display/renesas,du.yaml          | 10 ++-
 .../display/rockchip/rockchip-drm.yaml        |  2 +
 .../display/sprd/sprd,display-subsystem.yaml  |  2 +
 .../bindings/display/ti/ti,am65x-dss.yaml     |  3 +-
 .../devicetree/bindings/dma/dma-router.yaml   |  2 +
 .../bindings/dma/st,stm32-dmamux.yaml         |  2 +-
 .../bindings/dvfs/performance-domain.yaml     |  1 -
 .../bindings/interconnect/qcom,rpmh.yaml      |  2 +
 .../interrupt-controller/arm,gic-v3.yaml      |  6 +-
 .../interrupt-controller/ti,sci-inta.yaml     |  2 +
 .../bindings/iommu/mediatek,iommu.yaml        |  6 +-
 .../bindings/iommu/renesas,ipmmu-vmsa.yaml    |  6 ++
 .../leds/backlight/led-backlight.yaml         |  2 +
 .../allwinner,sun4i-a10-video-engine.yaml     |  4 +
 .../bindings/media/nxp,imx8mq-mipi-csi2.yaml  | 10 +--
 .../devicetree/bindings/media/ti,cal.yaml     |  4 +
 .../memory-controllers/mediatek,smi-larb.yaml |  2 +-
 .../samsung,exynos5422-dmc.yaml               |  2 +
 .../net/allwinner,sun4i-a10-emac.yaml         |  4 +
 .../bindings/net/can/bosch,c_can.yaml         |  8 +-
 .../bindings/net/can/fsl,flexcan.yaml         | 12 +--
 .../devicetree/bindings/net/dsa/dsa-port.yaml |  2 +
 .../devicetree/bindings/net/fsl,fec.yaml      |  8 +-
 .../bindings/net/intel,ixp4xx-ethernet.yaml   | 15 +++-
 .../bindings/net/intel,ixp4xx-hss.yaml        | 33 ++++++--
 .../bindings/net/nxp,dwmac-imx.yaml           |  4 +
 .../bindings/net/socionext,uniphier-ave4.yaml |  4 +
 .../devicetree/bindings/net/stm32-dwmac.yaml  |  4 +
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  5 ++
 .../bindings/net/wireless/mediatek,mt76.yaml  |  4 +
 .../devicetree/bindings/opp/opp-v2-base.yaml  |  2 +
 .../devicetree/bindings/perf/arm,dsu-pmu.yaml |  2 +
 .../bindings/phy/intel,combo-phy.yaml         |  8 ++
 .../devicetree/bindings/phy/ti,omap-usb2.yaml |  4 +
 .../pinctrl/aspeed,ast2500-pinctrl.yaml       |  2 +
 .../bindings/pinctrl/canaan,k210-fpioa.yaml   |  4 +
 .../pinctrl/mediatek,mt65xx-pinctrl.yaml      |  2 +
 .../bindings/pinctrl/st,stm32-pinctrl.yaml    | 10 ++-
 .../bindings/power/power-domain.yaml          |  4 +
 .../bindings/power/renesas,apmu.yaml          |  2 +
 .../power/rockchip,power-controller.yaml      |  2 +
 .../bindings/power/supply/cw2015_battery.yaml |  6 +-
 .../bindings/power/supply/power-supply.yaml   |  2 +
 .../bindings/regulator/regulator.yaml         |  2 +
 .../bindings/regulator/st,stm32-booster.yaml  |  2 +-
 .../bindings/remoteproc/qcom,adsp.yaml        |  6 ++
 .../bindings/remoteproc/st,stm32-rproc.yaml   | 33 ++++++--
 .../bindings/remoteproc/ti,k3-dsp-rproc.yaml  |  2 +
 .../bindings/remoteproc/ti,k3-r5f-rproc.yaml  |  2 +
 .../remoteproc/ti,omap-remoteproc.yaml        | 19 +++--
 .../bindings/soc/samsung/exynos-usi.yaml      |  4 +
 .../bindings/sound/samsung,aries-wm8994.yaml  |  2 +
 .../bindings/sound/samsung,midas-audio.yaml   |  3 +-
 .../bindings/sound/st,stm32-sai.yaml          |  8 +-
 .../thermal/thermal-cooling-devices.yaml      |  6 +-
 .../bindings/thermal/thermal-idle.yaml        |  8 +-
 .../bindings/usb/nvidia,tegra-xudc.yaml       |  2 +-
 66 files changed, 317 insertions(+), 119 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
index 0dcebc48ea22..916a5aebefff 100644
--- a/Documentation/devicetree/bindings/arm/cpus.yaml
+++ b/Documentation/devicetree/bindings/arm/cpus.yaml
@@ -243,6 +243,8 @@ properties:
 
   cpu-idle-states:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    items:
+      maxItems: 1
     description: |
       List of phandles to idle state nodes supported
       by this cpu (see ./idle-states.yaml).
diff --git a/Documentation/devicetree/bindings/arm/idle-states.yaml b/Documentation/devicetree/bindings/arm/idle-states.yaml
index 52bce5dbb11f..4d381fa1ee57 100644
--- a/Documentation/devicetree/bindings/arm/idle-states.yaml
+++ b/Documentation/devicetree/bindings/arm/idle-states.yaml
@@ -337,8 +337,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x0>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@1 {
@@ -346,8 +346,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x1>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@100 {
@@ -355,8 +355,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x100>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@101 {
@@ -364,8 +364,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x101>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@10000 {
@@ -373,8 +373,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x10000>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@10001 {
@@ -382,8 +382,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x10001>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@10100 {
@@ -391,8 +391,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x10100>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@10101 {
@@ -400,8 +400,8 @@ examples:
             compatible = "arm,cortex-a57";
             reg = <0x0 0x10101>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_0_0 &CPU_SLEEP_0_0
-                   &CLUSTER_RETENTION_0 &CLUSTER_SLEEP_0>;
+            cpu-idle-states = <&CPU_RETENTION_0_0>, <&CPU_SLEEP_0_0>,
+                    <&CLUSTER_RETENTION_0>, <&CLUSTER_SLEEP_0>;
         };
 
         cpu@100000000 {
@@ -409,8 +409,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x0>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100000001 {
@@ -418,8 +418,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x1>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100000100 {
@@ -427,8 +427,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x100>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100000101 {
@@ -436,8 +436,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x101>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100010000 {
@@ -445,8 +445,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x10000>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100010001 {
@@ -454,8 +454,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x10001>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100010100 {
@@ -463,8 +463,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x10100>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         cpu@100010101 {
@@ -472,8 +472,8 @@ examples:
             compatible = "arm,cortex-a53";
             reg = <0x1 0x10101>;
             enable-method = "psci";
-            cpu-idle-states = <&CPU_RETENTION_1_0 &CPU_SLEEP_1_0
-                   &CLUSTER_RETENTION_1 &CLUSTER_SLEEP_1>;
+            cpu-idle-states = <&CPU_RETENTION_1_0>, <&CPU_SLEEP_1_0>,
+                    <&CLUSTER_RETENTION_1>, <&CLUSTER_SLEEP_1>;
         };
 
         idle-states {
@@ -567,56 +567,56 @@ examples:
             device_type = "cpu";
             compatible = "arm,cortex-a15";
             reg = <0x0>;
-            cpu-idle-states = <&cpu_sleep_0_0 &cluster_sleep_0>;
+            cpu-idle-states = <&cpu_sleep_0_0>, <&cluster_sleep_0>;
         };
 
         cpu@1 {
             device_type = "cpu";
             compatible = "arm,cortex-a15";
             reg = <0x1>;
-            cpu-idle-states = <&cpu_sleep_0_0 &cluster_sleep_0>;
+            cpu-idle-states = <&cpu_sleep_0_0>, <&cluster_sleep_0>;
         };
 
         cpu@2 {
             device_type = "cpu";
             compatible = "arm,cortex-a15";
             reg = <0x2>;
-            cpu-idle-states = <&cpu_sleep_0_0 &cluster_sleep_0>;
+            cpu-idle-states = <&cpu_sleep_0_0>, <&cluster_sleep_0>;
         };
 
         cpu@3 {
             device_type = "cpu";
             compatible = "arm,cortex-a15";
             reg = <0x3>;
-            cpu-idle-states = <&cpu_sleep_0_0 &cluster_sleep_0>;
+            cpu-idle-states = <&cpu_sleep_0_0>, <&cluster_sleep_0>;
         };
 
         cpu@100 {
             device_type = "cpu";
             compatible = "arm,cortex-a7";
             reg = <0x100>;
-            cpu-idle-states = <&cpu_sleep_1_0 &cluster_sleep_1>;
+            cpu-idle-states = <&cpu_sleep_1_0>, <&cluster_sleep_1>;
         };
 
         cpu@101 {
             device_type = "cpu";
             compatible = "arm,cortex-a7";
             reg = <0x101>;
-            cpu-idle-states = <&cpu_sleep_1_0 &cluster_sleep_1>;
+            cpu-idle-states = <&cpu_sleep_1_0>, <&cluster_sleep_1>;
         };
 
         cpu@102 {
             device_type = "cpu";
             compatible = "arm,cortex-a7";
             reg = <0x102>;
-            cpu-idle-states = <&cpu_sleep_1_0 &cluster_sleep_1>;
+            cpu-idle-states = <&cpu_sleep_1_0>, <&cluster_sleep_1>;
         };
 
         cpu@103 {
             device_type = "cpu";
             compatible = "arm,cortex-a7";
             reg = <0x103>;
-            cpu-idle-states = <&cpu_sleep_1_0 &cluster_sleep_1>;
+            cpu-idle-states = <&cpu_sleep_1_0>, <&cluster_sleep_1>;
         };
 
         idle-states {
diff --git a/Documentation/devicetree/bindings/arm/pmu.yaml b/Documentation/devicetree/bindings/arm/pmu.yaml
index 981bac451698..2e2308d73408 100644
--- a/Documentation/devicetree/bindings/arm/pmu.yaml
+++ b/Documentation/devicetree/bindings/arm/pmu.yaml
@@ -66,6 +66,8 @@ properties:
 
   interrupt-affinity:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       When using SPIs, specifies a list of phandles to CPU
       nodes corresponding directly to the affinity of
diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.yaml b/Documentation/devicetree/bindings/ata/sata_highbank.yaml
index ce75d77e9289..49679b58041c 100644
--- a/Documentation/devicetree/bindings/ata/sata_highbank.yaml
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.yaml
@@ -51,6 +51,9 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 8
+    items:
+      minItems: 2
+      maxItems: 2
 
   calxeda,tx-atten:
     description: |
diff --git a/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml b/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
index 863a287ebc7e..ad313ccaaaef 100644
--- a/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
+++ b/Documentation/devicetree/bindings/bus/allwinner,sun50i-a64-de2.yaml
@@ -35,7 +35,10 @@ properties:
       The SRAM that needs to be claimed to access the display engine
       bus.
     $ref: /schemas/types.yaml#/definitions/phandle-array
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to SRAM
+          - description: register value for device
 
   ranges: true
 
diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
index 9c53c27bd20a..e0fe63957888 100644
--- a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
@@ -22,19 +22,28 @@ properties:
 
   intel,npe-handle:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the NPE this crypto engine
+          - description: the NPE instance number
     description: phandle to the NPE this crypto engine is using, the cell
       describing the NPE instance to be used.
 
   queue-rx:
     $ref: /schemas/types.yaml#/definitions/phandle-array
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the RX queue on the NPE
+          - description: the queue instance number
     description: phandle to the RX queue on the NPE, the cell describing
       the queue instance to be used.
 
   queue-txready:
     $ref: /schemas/types.yaml#/definitions/phandle-array
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the TX READY queue on the NPE
+          - description: the queue instance number
     description: phandle to the TX READY queue on the NPE, the cell describing
       the queue instance to be used.
 
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml
index e77523b02fad..d4412aea7b73 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-display-engine.yaml
@@ -69,6 +69,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 2
+    items:
+      maxItems: 1
     description: |
       Available display engine frontends (DE 1.0) or mixers (DE
       2.0/3.0) available.
diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml
index 111967efa999..bdaf0b51e68c 100644
--- a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.yaml
@@ -51,7 +51,10 @@ properties:
 
   mediatek,syscon-hdmi:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to system configuration registers
+          - description: register offset in the system configuration registers
     description: |
       phandle link and register offset to the system configuration registers.
 
diff --git a/Documentation/devicetree/bindings/display/msm/gpu.yaml b/Documentation/devicetree/bindings/display/msm/gpu.yaml
index 99a1ba3ada56..3397bc31d087 100644
--- a/Documentation/devicetree/bindings/display/msm/gpu.yaml
+++ b/Documentation/devicetree/bindings/display/msm/gpu.yaml
@@ -64,6 +64,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 4
+    items:
+      maxItems: 1
     description: |
       phandles to one or more reserved on-chip SRAM regions.
       phandle to the On Chip Memory (OCMEM) that's present on some a3xx and
diff --git a/Documentation/devicetree/bindings/display/renesas,du.yaml b/Documentation/devicetree/bindings/display/renesas,du.yaml
index 13efea574584..56cedcd6d576 100644
--- a/Documentation/devicetree/bindings/display/renesas,du.yaml
+++ b/Documentation/devicetree/bindings/display/renesas,du.yaml
@@ -76,17 +76,21 @@ properties:
 
   renesas,cmms:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    items:
+      maxItems: 1
     description:
       A list of phandles to the CMM instances present in the SoC, one for each
       available DU channel.
 
   renesas,vsps:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    items:
+      items:
+        - description: phandle to VSP instance that serves the DU channel
+        - description: Channel index identifying the LIF instance in that VSP
     description:
       A list of phandle and channel index tuples to the VSPs that handle the
-      memory interfaces for the DU channels. The phandle identifies the VSP
-      instance that serves the DU channel, and the channel index identifies
-      the LIF instance in that VSP.
+      memory interfaces for the DU channels.
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/rockchip/rockchip-drm.yaml b/Documentation/devicetree/bindings/display/rockchip/rockchip-drm.yaml
index 7204da5eb4c5..a8d18a37cb23 100644
--- a/Documentation/devicetree/bindings/display/rockchip/rockchip-drm.yaml
+++ b/Documentation/devicetree/bindings/display/rockchip/rockchip-drm.yaml
@@ -21,6 +21,8 @@ properties:
 
   ports:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description: |
       Should contain a list of phandles pointing to display interface port
       of vop devices. vop definitions as defined in
diff --git a/Documentation/devicetree/bindings/display/sprd/sprd,display-subsystem.yaml b/Documentation/devicetree/bindings/display/sprd/sprd,display-subsystem.yaml
index 3d107e9434be..d0a5592bd89d 100644
--- a/Documentation/devicetree/bindings/display/sprd/sprd,display-subsystem.yaml
+++ b/Documentation/devicetree/bindings/display/sprd/sprd,display-subsystem.yaml
@@ -45,6 +45,8 @@ properties:
 
   ports:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       Should contain a list of phandles pointing to display interface port
       of DPU devices.
diff --git a/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
index 781c1868b0b8..5c7d2cbc4aac 100644
--- a/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
+++ b/Documentation/devicetree/bindings/display/ti/ti,am65x-dss.yaml
@@ -88,8 +88,7 @@ properties:
           The DSS DPI output port node from video port 2
 
   ti,am65x-oldi-io-ctrl:
-    $ref: "/schemas/types.yaml#/definitions/phandle-array"
-    maxItems: 1
+    $ref: "/schemas/types.yaml#/definitions/phandle"
     description:
       phandle to syscon device node mapping OLDI IO_CTRL registers.
       The mapped range should point to OLDI_DAT0_IO_CTRL, map it and
diff --git a/Documentation/devicetree/bindings/dma/dma-router.yaml b/Documentation/devicetree/bindings/dma/dma-router.yaml
index e72748496fd9..4b817f5dc30e 100644
--- a/Documentation/devicetree/bindings/dma/dma-router.yaml
+++ b/Documentation/devicetree/bindings/dma/dma-router.yaml
@@ -24,6 +24,8 @@ properties:
 
   dma-masters:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       Array of phandles to the DMA controllers the router can direct
       the signal to.
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
index f751796531c9..7b1833d6caa2 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
@@ -46,7 +46,7 @@ examples:
       #dma-cells = <3>;
       dma-requests = <128>;
       dma-channels = <16>;
-      dma-masters = <&dma1 &dma2>;
+      dma-masters = <&dma1>, <&dma2>;
       clocks = <&timer_clk>;
     };
 
diff --git a/Documentation/devicetree/bindings/dvfs/performance-domain.yaml b/Documentation/devicetree/bindings/dvfs/performance-domain.yaml
index c8b91207f34d..7959d40ded5a 100644
--- a/Documentation/devicetree/bindings/dvfs/performance-domain.yaml
+++ b/Documentation/devicetree/bindings/dvfs/performance-domain.yaml
@@ -43,7 +43,6 @@ properties:
 
   performance-domains:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
     description:
       A phandle and performance domain specifier as defined by bindings of the
       performance controller/provider specified by phandle.
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
index cbb24f9bb609..5a911be0c2ea 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
@@ -121,6 +121,8 @@ properties:
 
   qcom,bcm-voters:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description: |
       List of phandles to qcom,bcm-voter nodes that are required by
       this interconnect to send RPMh commands.
diff --git a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
index cfb3ec27bd2b..b7197f78e158 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
@@ -138,6 +138,8 @@ properties:
         properties:
           affinity:
             $ref: /schemas/types.yaml#/definitions/phandle-array
+            items:
+              maxItems: 1
             description:
               Should be a list of phandles to CPU nodes (as described in
               Documentation/devicetree/bindings/arm/cpus.yaml).
@@ -273,11 +275,11 @@ examples:
 
       ppi-partitions {
         part0: interrupt-partition-0 {
-          affinity = <&cpu0 &cpu2>;
+          affinity = <&cpu0>, <&cpu2>;
         };
 
         part1: interrupt-partition-1 {
-          affinity = <&cpu1 &cpu3>;
+          affinity = <&cpu1>, <&cpu3>;
         };
       };
     };
diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml b/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
index 3d89668573e8..88c46e61732e 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
@@ -77,6 +77,8 @@ properties:
 
   ti,unmapped-event-sources:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       Array of phandles to DMA controllers where the unmapped events originate.
 
diff --git a/Documentation/devicetree/bindings/iommu/mediatek,iommu.yaml b/Documentation/devicetree/bindings/iommu/mediatek,iommu.yaml
index 0f26fe14c8e2..97e8c471a5e8 100644
--- a/Documentation/devicetree/bindings/iommu/mediatek,iommu.yaml
+++ b/Documentation/devicetree/bindings/iommu/mediatek,iommu.yaml
@@ -101,6 +101,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 32
+    items:
+      maxItems: 1
     description: |
       List of phandle to the local arbiters in the current Socs.
       Refer to bindings/memory-controllers/mediatek,smi-larb.yaml. It must sort
@@ -167,8 +169,8 @@ examples:
             interrupts = <GIC_SPI 139 IRQ_TYPE_LEVEL_LOW>;
             clocks = <&infracfg CLK_INFRA_M4U>;
             clock-names = "bclk";
-            mediatek,larbs = <&larb0 &larb1 &larb2
-                              &larb3 &larb4 &larb5>;
+            mediatek,larbs = <&larb0>, <&larb1>, <&larb2>,
+                             <&larb3>, <&larb4>, <&larb5>;
             #iommu-cells = <1>;
     };
 
diff --git a/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml b/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
index ce0c715205c6..507853fcc746 100644
--- a/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
+++ b/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
@@ -66,6 +66,12 @@ properties:
 
   renesas,ipmmu-main:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to main IPMMU
+          - description: the interrupt bit number associated with the particular 
+              cache IPMMU device. The interrupt bit number needs to match the main 
+              IPMMU IMSSTR register. Only used by cache IPMMU instances.
     description:
       Reference to the main IPMMU phandle plus 1 cell. The cell is
       the interrupt bit number associated with the particular cache IPMMU
diff --git a/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml b/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml
index 625082bf3892..f5822f4ea667 100644
--- a/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/led-backlight.yaml
@@ -23,6 +23,8 @@ properties:
   leds:
     description: A list of LED nodes
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
 
   brightness-levels:
     description:
diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
index c3de96d10396..ee7fc3515d89 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
@@ -48,6 +48,10 @@ properties:
 
   allwinner,sram:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to SRAM
+          - description: register value for device
     description: Phandle to the device SRAM
 
   iommus:
diff --git a/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml b/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml
index 9c04fa85ee5c..d13c9233a7c8 100644
--- a/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx8mq-mipi-csi2.yaml
@@ -58,11 +58,11 @@ properties:
       req_gpr is the gpr register offset of RX_ENABLE for the mipi phy.
     $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
-      items:
-        - description: The 'gpr' is the phandle to general purpose register node.
-        - description: The 'req_gpr' is the gpr register offset containing
-                       CSI2_1_RX_ENABLE or CSI2_2_RX_ENABLE respectively.
-          maximum: 0xff
+      - items:
+          - description: The 'gpr' is the phandle to general purpose register node.
+          - description: The 'req_gpr' is the gpr register offset containing
+                        CSI2_1_RX_ENABLE or CSI2_2_RX_ENABLE respectively.
+            maximum: 0xff
 
   interconnects:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/media/ti,cal.yaml b/Documentation/devicetree/bindings/media/ti,cal.yaml
index 66c5d392fa75..7e078424ca4d 100644
--- a/Documentation/devicetree/bindings/media/ti,cal.yaml
+++ b/Documentation/devicetree/bindings/media/ti,cal.yaml
@@ -48,6 +48,10 @@ properties:
 
   ti,camerrx-control:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    items:
+      - items:
+          - description: phandle to device control module
+          - description: offset to the control_camerarx_core register
     description:
       phandle to the device control module and offset to the
       control_camerarx_core register
diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
index eaeff1ada7f8..822ade9e9bab 100644
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
@@ -52,7 +52,7 @@ properties:
     maxItems: 1
 
   mediatek,smi:
-    $ref: /schemas/types.yaml#/definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle
     description: a phandle to the smi_common node.
 
   mediatek,larb-id:
diff --git a/Documentation/devicetree/bindings/memory-controllers/samsung,exynos5422-dmc.yaml b/Documentation/devicetree/bindings/memory-controllers/samsung,exynos5422-dmc.yaml
index fe8639dcffab..895c3b5c9aaa 100644
--- a/Documentation/devicetree/bindings/memory-controllers/samsung,exynos5422-dmc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/samsung,exynos5422-dmc.yaml
@@ -45,6 +45,8 @@ properties:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
     minItems: 1
     maxItems: 16
+    items:
+      maxItems: 1
     description: phandles of the PPMU events used by the controller.
 
   device-handle:
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
index 8d8560a67abf..098b2bf7d976 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
@@ -29,6 +29,10 @@ properties:
   allwinner,sram:
     description: Phandle to the device SRAM
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to SRAM
+          - description: register value for device
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
index 2cd145a642f1..8bad328b184d 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
@@ -56,10 +56,10 @@ properties:
       offset).
     $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
-      items:
-        - description: The phandle to the system control region.
-        - description: The register offset.
-        - description: The CAN instance number.
+      - items:
+          - description: The phandle to the system control region.
+          - description: The register offset.
+          - description: The CAN instance number.
 
   resets:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 3f0ee17c1461..e52db841bb8c 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -84,12 +84,12 @@ properties:
       req_bit is the bit offset of CAN stop request.
     $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
-      items:
-        - description: The 'gpr' is the phandle to general purpose register node.
-        - description: The 'req_gpr' is the gpr register offset of CAN stop request.
-          maximum: 0xff
-        - description: The 'req_bit' is the bit offset of CAN stop request.
-          maximum: 0x1f
+      - items:
+          - description: The 'gpr' is the phandle to general purpose register node.
+          - description: The 'req_gpr' is the gpr register offset of CAN stop request.
+            maximum: 0xff
+          - description: The 'req_bit' is the bit offset of CAN stop request.
+            maximum: 0x1f
 
   fsl,clk-source:
     description: |
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 702df848a71d..c504feeec6db 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -34,6 +34,8 @@ properties:
       full routing information must be given, not just the one hop
       routes to neighbouring switches
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
 
   ethernet:
     description:
diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index fd8371e31867..daa2f79a294f 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -158,11 +158,13 @@ properties:
 
   fsl,stop-mode:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to general purpose register node
+          - description: the gpr register offset for ENET stop request
+          - description: the gpr bit offset for ENET stop request
     description:
       Register bits of stop mode control, the format is <&gpr req_gpr req_bit>.
-      gpr is the phandle to general purpose register node.
-      req_gpr is the gpr register offset for ENET stop request.
-      req_bit is the gpr bit offset for ENET stop request.
 
   mdio:
     $ref: mdio.yaml#
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
index 67eaf02dda80..4e1b79818aff 100644
--- a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -29,12 +29,18 @@ properties:
 
   queue-rx:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the RX queue node
+          - description: RX queue instance to use
     description: phandle to the RX queue on the NPE
 
   queue-txready:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the TX READY queue node
+          - description: TX READY queue instance to use
     description: phandle to the TX READY queue on the NPE
 
   phy-mode: true
@@ -43,7 +49,10 @@ properties:
 
   intel,npe-handle:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the NPE this ethernet instance is using
+          - description: the NPE instance to use
     description: phandle to the NPE this ethernet instance is using
       and the instance to use in the second cell
 
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
index 4dcd53c3e0b4..e6329febb60c 100644
--- a/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
@@ -25,39 +25,62 @@ properties:
 
   intel,npe-handle:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      items:
+        - description: phandle to the NPE this HSS instance is using
+        - description: the NPE instance number
     description: phandle to the NPE this HSS instance is using
       and the instance to use in the second cell
 
   intel,queue-chl-rxtrig:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the RX trigger queue on the NPE
+          - description: the queue instance number
     description: phandle to the RX trigger queue on the NPE
 
   intel,queue-chl-txready:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the TX ready queue on the NPE
+          - description: the queue instance number
     description: phandle to the TX ready queue on the NPE
 
   intel,queue-pkt-rx:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the RX queue on the NPE
+          - description: the queue instance number
     description: phandle to the packet RX queue on the NPE
 
   intel,queue-pkt-tx:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
     maxItems: 4
+    items:
+      items:
+        - description: phandle to the TX queue on the NPE
+        - description: the queue instance number
     description: phandle to the packet TX0, TX1, TX2 and TX3 queues on the NPE
 
   intel,queue-pkt-rxfree:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
     maxItems: 4
+    items:
+      items:
+        - description: phandle to the RXFREE queue on the NPE
+        - description: the queue instance number
     description: phandle to the packet RXFREE0, RXFREE1, RXFREE2 and
       RXFREE3 queues on the NPE
 
   intel,queue-pkt-txdone:
     $ref: '/schemas/types.yaml#/definitions/phandle-array'
-    maxItems: 1
+    items:
+      - items:
+          - description: phandle to the TXDONE queue on the NPE
+          - description: the queue instance number
     description: phandle to the packet TXDONE queue on the NPE
 
   cts-gpios:
diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index ee4afe361fac..011363166789 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -54,6 +54,10 @@ properties:
 
   intf_mode:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to the GPR syscon
+          - description: the offset of the GPR register
     description:
       Should be phandle/offset pair. The phandle to the syscon node which
       encompases the GPR register, and the offset of the GPR register.
diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
index aad5a9f3f962..1ab41cfdb865 100644
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
@@ -66,6 +66,10 @@ properties:
 
   socionext,syscon-phy-mode:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to syscon that configures phy mode
+          - description: ID of MAC instance 
     description:
       A phandle to syscon with one argument that configures phy mode.
       The argument is the ID of MAC instance.
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index 3d8a3b763ae6..89a858de68af 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -74,6 +74,10 @@ properties:
 
   st,syscon:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    items:
+      - items:
+          - description: phandle to the syscon node which encompases the glue register
+          - description: offset of the control register 
     description:
       Should be phandle/offset pair. The phandle to the syscon node which
       encompases the glue register, and the offset of the control register
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 4b97a0f1175b..c6596fad5b20 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -136,6 +136,11 @@ properties:
 
           ti,syscon-efuse:
             $ref: /schemas/types.yaml#/definitions/phandle-array
+            items:
+              - items:
+                  - description: Phandle to the system control device node which 
+                      provides access to efuse
+                  - description: offset to efuse registers??? 
             description:
               Phandle to the system control device node which provides access
               to efuse IO range with MAC addresses
diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 269cd63fb544..42e1f4dddca8 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -54,6 +54,10 @@ properties:
 
   mediatek,mtd-eeprom:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to MTD partition
+          - description: offset containing EEPROM data
     description:
       Phandle to a MTD partition + offset containing EEPROM data
 
diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
index 15a76bcd6d42..da0f09eedc0c 100644
--- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
+++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
@@ -177,6 +177,8 @@ patternProperties:
           for the functioning of the current device at the current OPP (where
           this property is present).
         $ref: /schemas/types.yaml#/definitions/phandle-array
+        items:
+          maxItems: 1
 
     patternProperties:
       '^opp-microvolt-':
diff --git a/Documentation/devicetree/bindings/perf/arm,dsu-pmu.yaml b/Documentation/devicetree/bindings/perf/arm,dsu-pmu.yaml
index aef63a542f34..c87821be158b 100644
--- a/Documentation/devicetree/bindings/perf/arm,dsu-pmu.yaml
+++ b/Documentation/devicetree/bindings/perf/arm,dsu-pmu.yaml
@@ -35,6 +35,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 12
+    items:
+      maxItems: 1
     description: List of phandles for the CPUs connected to this DSU instance.
 
 required:
diff --git a/Documentation/devicetree/bindings/phy/intel,combo-phy.yaml b/Documentation/devicetree/bindings/phy/intel,combo-phy.yaml
index 347d0cdfb80d..5d54b0a0e873 100644
--- a/Documentation/devicetree/bindings/phy/intel,combo-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/intel,combo-phy.yaml
@@ -47,10 +47,18 @@ properties:
 
   intel,syscfg:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to Chip configuration registers
+          - description: ComboPhy instance id
     description: Chip configuration registers handle and ComboPhy instance id
 
   intel,hsio:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to HSIO registers
+          - description: ComboPhy instance id
     description: HSIO registers handle and ComboPhy instance id on NOC
 
   intel,aggregation:
diff --git a/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml b/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml
index cbbf5e8b1197..51c8a36e61f0 100644
--- a/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml
+++ b/Documentation/devicetree/bindings/phy/ti,omap-usb2.yaml
@@ -45,6 +45,10 @@ properties:
 
   syscon-phy-power:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to the system control module
+          - description: register offset to power on/off the PHY
     description:
       phandle/offset pair. Phandle to the system control module and
       register offset to power on/off the PHY.
diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
index d316cc082107..acd60c85b4cc 100644
--- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
@@ -29,6 +29,8 @@ properties:
   aspeed,external-nodes:
     minItems: 2
     maxItems: 2
+    items:
+      maxItems: 1
     $ref: /schemas/types.yaml#/definitions/phandle-array
     description: |
       A cell of phandles to external controller nodes:
diff --git a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
index a44691d9c57d..53e963e090f2 100644
--- a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
@@ -39,6 +39,10 @@ properties:
 
   canaan,k210-sysctl-power:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle of the K210 system controller node
+          - description: offset of its power domain control register
     description: |
       phandle of the K210 system controller node and offset of its
       power domain control register.
diff --git a/Documentation/devicetree/bindings/pinctrl/mediatek,mt65xx-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/mediatek,mt65xx-pinctrl.yaml
index 6953c958ff7c..161088a8be33 100644
--- a/Documentation/devicetree/bindings/pinctrl/mediatek,mt65xx-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/mediatek,mt65xx-pinctrl.yaml
@@ -44,6 +44,8 @@ properties:
 
   mediatek,pctl-regmap:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     minItems: 1
     maxItems: 2
     description: |
diff --git a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
index 83a18d0331b1..335ffc1353b5 100644
--- a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
@@ -41,11 +41,13 @@ properties:
     maxItems: 1
 
   st,syscfg:
-    description: Should be phandle/offset/mask
-      - Phandle to the syscon node which includes IRQ mux selection.
-      - The offset of the IRQ mux selection register.
-      - The field mask of IRQ mux, needed if different of 0xf.
+    description: Phandle+args to the syscon node which includes IRQ mux selection.
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    items:
+      - items:
+          - description: syscon node which includes IRQ mux selection
+          - description: The offset of the IRQ mux selection register
+          - description: The field mask of IRQ mux, needed if different of 0xf
 
   st,package:
     description:
diff --git a/Documentation/devicetree/bindings/power/power-domain.yaml b/Documentation/devicetree/bindings/power/power-domain.yaml
index 3143ed9a3313..889091b9814f 100644
--- a/Documentation/devicetree/bindings/power/power-domain.yaml
+++ b/Documentation/devicetree/bindings/power/power-domain.yaml
@@ -29,6 +29,8 @@ properties:
 
   domain-idle-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description: |
       Phandles of idle states that defines the available states for the
       power-domain provider. The idle state definitions are compatible with the
@@ -42,6 +44,8 @@ properties:
 
   operating-points-v2:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       Phandles to the OPP tables of power domains provided by a power domain
       provider. If the provider provides a single power domain only or all
diff --git a/Documentation/devicetree/bindings/power/renesas,apmu.yaml b/Documentation/devicetree/bindings/power/renesas,apmu.yaml
index 391897d897f2..4d293b2b2f84 100644
--- a/Documentation/devicetree/bindings/power/renesas,apmu.yaml
+++ b/Documentation/devicetree/bindings/power/renesas,apmu.yaml
@@ -35,6 +35,8 @@ properties:
 
   cpus:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description: |
       Array of phandles pointing to CPU cores, which should match the order of
       CPU cores used by the WUPCR and PSTR registers in the Advanced Power
diff --git a/Documentation/devicetree/bindings/power/rockchip,power-controller.yaml b/Documentation/devicetree/bindings/power/rockchip,power-controller.yaml
index 9b9d71087466..3deb0fc8dfd3 100644
--- a/Documentation/devicetree/bindings/power/rockchip,power-controller.yaml
+++ b/Documentation/devicetree/bindings/power/rockchip,power-controller.yaml
@@ -129,6 +129,8 @@ $defs:
 
       pm_qos:
         $ref: /schemas/types.yaml#/definitions/phandle-array
+        items:
+          maxItems: 1
         description: |
           A number of phandles to qos blocks which need to be saved and restored
           while power domain switches state.
diff --git a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
index c73abb2ff513..2dda91587dc3 100644
--- a/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
+++ b/Documentation/devicetree/bindings/power/supply/cw2015_battery.yaml
@@ -14,6 +14,9 @@ description: |
   phandle in monitored-battery. If specified the driver uses the
   charge-full-design-microamp-hours property of the battery.
 
+allOf:
+  - $ref: power-supply.yaml#
+
 properties:
   compatible:
     const: cellwise,cw2015
@@ -37,9 +40,6 @@ properties:
     minimum: 250
 
   power-supplies:
-    description:
-      Specifies supplies used for charging the battery connected to this gauge
-    $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 8 # Should be enough
 
diff --git a/Documentation/devicetree/bindings/power/supply/power-supply.yaml b/Documentation/devicetree/bindings/power/supply/power-supply.yaml
index 259760167759..531b67225c74 100644
--- a/Documentation/devicetree/bindings/power/supply/power-supply.yaml
+++ b/Documentation/devicetree/bindings/power/supply/power-supply.yaml
@@ -12,6 +12,8 @@ maintainers:
 properties:
   power-supplies:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       This property is added to a supply in order to list the devices which
       supply it power, referenced by their phandles.
diff --git a/Documentation/devicetree/bindings/regulator/regulator.yaml b/Documentation/devicetree/bindings/regulator/regulator.yaml
index ed560ee8714e..a9b66ececccf 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/regulator.yaml
@@ -213,6 +213,8 @@ properties:
       is 2-way - all coupled regulators should be linked with each other.
       A regulator should not be coupled with its supplier.
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    items:
+      maxItems: 1
 
   regulator-coupled-max-spread:
     description: Array of maximum spread between voltages of coupled regulators
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
index df0191b1ceba..38bdaef4fa39 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32-booster.yaml
@@ -23,7 +23,7 @@ properties:
       - st,stm32mp1-booster
 
   st,syscfg:
-    $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    $ref: "/schemas/types.yaml#/definitions/phandle"
     description: phandle to system configuration controller.
 
   vdda-supply:
diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml
index c635c181d2c2..bcad8f4080d4 100644
--- a/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/qcom,adsp.yaml
@@ -115,6 +115,12 @@ properties:
 
   qcom,halt-regs:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: Phandle reference to a syscon representing TCSR
+          - description: offsets within syscon for q6 halt registers
+          - description: offsets within syscon for modem halt registers
+          - description: offsets within syscon for nc halt registers
     description:
       Phandle reference to a syscon representing TCSR followed by the
       three offsets within syscon for q6, modem and nc halt registers.
diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
index b587c97c282b..be3d9b0e876b 100644
--- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
@@ -29,17 +29,22 @@ properties:
 
   st,syscfg-holdboot:
     description: remote processor reset hold boot
-      - Phandle of syscon block.
-      - The offset of the hold boot setting register.
-      - The field mask of the hold boot.
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
-    maxItems: 1
+    items:
+      - items:
+          - description: Phandle of syscon block
+          - description: The offset of the hold boot setting register
+          - description: The field mask of the hold boot
 
   st,syscfg-tz:
     description:
       Reference to the system configuration which holds the RCC trust zone mode
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
-    maxItems: 1
+    items:
+      - items:
+          - description: Phandle of syscon block
+          - description: FIXME
+          - description: FIXME
 
   interrupts:
     description: Should contain the WWDG1 watchdog reset interrupt
@@ -93,20 +98,32 @@ properties:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
     description: |
       Reference to the system configuration which holds the remote
-    maxItems: 1
+    items:
+      - items:
+          - description: Phandle of syscon block
+          - description: FIXME
+          - description: FIXME
 
   st,syscfg-m4-state:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
     description: |
       Reference to the tamp register which exposes the Cortex-M4 state.
-    maxItems: 1
+    items:
+      - items:
+          - description: Phandle of syscon block with the tamp register
+          - description: FIXME
+          - description: FIXME
 
   st,syscfg-rsc-tbl:
     $ref: "/schemas/types.yaml#/definitions/phandle-array"
     description: |
       Reference to the tamp register which references the Cortex-M4
       resource table address.
-    maxItems: 1
+    items:
+      - items:
+          - description: Phandle of syscon block with the tamp register
+          - description: FIXME
+          - description: FIXME
 
   st,auto-boot:
     $ref: /schemas/types.yaml#/definitions/flag
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
index 7b56497eec4d..4323cefdf19b 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
@@ -79,6 +79,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     minItems: 1
     maxItems: 4
+    items:
+      maxItems: 1
     description: |
       phandles to one or more reserved on-chip SRAM regions. The regions
       should be defined as child nodes of the respective SRAM node, and
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml
index d9c7e8c2b268..0f2bb06cb7b4 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,k3-r5f-rproc.yaml
@@ -189,6 +189,8 @@ patternProperties:
         $ref: /schemas/types.yaml#/definitions/phandle-array
         minItems: 1
         maxItems: 4
+        items:
+          maxItems: 1
         description: |
           phandles to one or more reserved on-chip SRAM regions. The regions
           should be defined as child nodes of the respective SRAM node, and
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
index c6c12129d6b7..1fdc2741c36e 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
@@ -123,13 +123,14 @@ properties:
 
   ti,bootreg:
     $ref: /schemas/types.yaml#/definitions/phandle-array
-    description: |
-      Should be a triple of the phandle to the System Control
-      Configuration region that contains the boot address
-      register, the register offset of the boot address
-      register within the System Control module, and the bit
-      shift within the register. This property is required for
-      all the DSP instances on OMAP4, OMAP5 and DRA7xx SoCs.
+    items:
+      - items:
+          - description: phandle to the System Control Configuration region
+          - description: register offset of the boot address register
+          - description: the bit shift within the register
+    description:
+      This property is required for all the DSP instances on OMAP4, OMAP5
+      and DRA7xx SoCs.
 
   ti,autosuspend-delay-ms:
     description: |
@@ -140,6 +141,8 @@ properties:
 
   ti,timers:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description: |
       One or more phandles to OMAP DMTimer nodes, that serve
       as System/Tick timers for the OS running on the remote
@@ -156,6 +159,8 @@ properties:
 
   ti,watchdog-timers:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description: |
       One or more phandles to OMAP DMTimer nodes, used to
       serve as Watchdog timers for the processor cores. This
diff --git a/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml b/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml
index 273f2d95a043..58f2e9d8bb0e 100644
--- a/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml
+++ b/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml
@@ -48,6 +48,10 @@ properties:
 
   samsung,sysreg:
     $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      - items:
+          - description: phandle to System Register syscon node
+          - description: offset of SW_CONF register for this USI controller
     description:
       Should be phandle/offset pair. The phandle to System Register syscon node
       (for the same domain where this USI controller resides) and the offset
diff --git a/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml b/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml
index 5fff586dc802..eb487ed3ca3b 100644
--- a/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml
+++ b/Documentation/devicetree/bindings/sound/samsung,aries-wm8994.yaml
@@ -27,6 +27,8 @@ properties:
       sound-dai:
         minItems: 2
         maxItems: 2
+        items:
+          maxItems: 1
         $ref: /schemas/types.yaml#/definitions/phandle-array
         description: |
           phandles to the I2S controller and bluetooth codec,
diff --git a/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml b/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml
index 095775c598fa..3a4df2ce1728 100644
--- a/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml
+++ b/Documentation/devicetree/bindings/sound/samsung,midas-audio.yaml
@@ -21,8 +21,7 @@ properties:
     type: object
     properties:
       sound-dai:
-        $ref: /schemas/types.yaml#/definitions/phandle-array
-        maxItems: 1
+        $ref: /schemas/types.yaml#/definitions/phandle
         description: phandle to the I2S controller
     required:
       - sound-dai
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index 1538d11ce9a8..d4fc8fdcb72f 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -102,9 +102,11 @@ patternProperties:
           By default SAI sub-block is in asynchronous mode.
           Must contain the phandle and index of the SAI sub-block providing
           the synchronization.
-        allOf:
-          - $ref: /schemas/types.yaml#/definitions/phandle-array
-          - maxItems: 1
+        $ref: /schemas/types.yaml#/definitions/phandle-array
+        items:
+          - items:
+              - description: phandle of the SAI sub-block
+              - description: index of the SAI sub-block
 
       st,iec60958:
         description:
diff --git a/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml b/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
index f004779ba9b3..850a9841b110 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
@@ -66,9 +66,9 @@ examples:
                     compatible = "qcom,kryo385";
                     reg = <0x0 0x0>;
                     enable-method = "psci";
-                    cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-                                       &LITTLE_CPU_SLEEP_1
-                                       &CLUSTER_SLEEP_0>;
+                    cpu-idle-states = <&LITTLE_CPU_SLEEP_0>,
+                                      <&LITTLE_CPU_SLEEP_1>,
+                                      <&CLUSTER_SLEEP_0>;
                     capacity-dmips-mhz = <607>;
                     dynamic-power-coefficient = <100>;
                     qcom,freq-domain = <&cpufreq_hw 0>;
diff --git a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
index 6278ccf16f3f..cc938d7ad1f3 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
@@ -37,8 +37,8 @@ properties:
 
   exit-latency-us:
     description: |
-      The exit latency constraint in microsecond for the injected idle state 
-      for the device. It is the latency constraint to apply when selecting an 
+      The exit latency constraint in microsecond for the injected idle state
+      for the device. It is the latency constraint to apply when selecting an
       idle state from among all the present ones.
 
 required:
@@ -65,7 +65,7 @@ examples:
                          capacity-dmips-mhz = <1024>;
                          dynamic-power-coefficient = <436>;
                          #cooling-cells = <2>; /* min followed by max */
-                         cpu-idle-states = <&CPU_SLEEP &CLUSTER_SLEEP>;
+                         cpu-idle-states = <&CPU_SLEEP>, <&CLUSTER_SLEEP>;
                          thermal-idle {
                                  #cooling-cells = <2>;
                                  duration-us = <10000>;
@@ -81,7 +81,7 @@ examples:
                         capacity-dmips-mhz = <1024>;
                         dynamic-power-coefficient = <436>;
                         #cooling-cells = <2>; /* min followed by max */
-                        cpu-idle-states = <&CPU_SLEEP &CLUSTER_SLEEP>;
+                        cpu-idle-states = <&CPU_SLEEP>, <&CLUSTER_SLEEP>;
                         thermal-idle {
                                 #cooling-cells = <2>;
                                 duration-us = <10000>;
diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
index a39c76b89484..fd6e7c81426e 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
@@ -83,7 +83,7 @@ properties:
       - const: ss
 
   nvidia,xusb-padctl:
-    $ref: /schemas/types.yaml#/definitions/phandle-array
+    $ref: /schemas/types.yaml#/definitions/phandle
     description:
       phandle to the XUSB pad controller that is used to configure the USB pads
       used by the XUDC controller.
-- 
2.32.0

