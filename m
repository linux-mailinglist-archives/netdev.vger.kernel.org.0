Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A490524301D
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHLUge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:36:34 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:47003 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgHLUgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:36:32 -0400
Received: by mail-io1-f51.google.com with SMTP id a5so4375468ioa.13;
        Wed, 12 Aug 2020 13:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fykZM2obKveMoYgfp65TERjQ9msFhQZhgm92y+l5i1k=;
        b=sxaKYTpkvlx13DRfkfuNH1d9o/d9c7ZnTuNjCbRFpc7HLuEDeiOfJ0F/T+JfUoYXMO
         3fgL7Fvp+U4h7qFqWe1qzqbC1rhD0tgWbDaWIhtCI8UCxEKSh5C6wy8ZmU19j7Mxb9fX
         M4cUEDSE+nCS0xD45+dZvWuJLAnIZ9iXIZsAm5KFBXj7xWpHUw7gfpp47jmWh0PZ4mzr
         0KCzeqZyxa+1uq6FgywrRJ4fX3drB7BIeuQL2p6KSHICt3MSj4QYlSq3/xTjsBmCS9hn
         TOpwFmBsyajWTm7HBmN6GOXEGIWnqm0r11xjTwXqWUgVX9FowMm/fDYjNIz/ZrlnUK39
         wkEg==
X-Gm-Message-State: AOAM533VOR6K9g94MZe9OgluqLOZODjv1FyaCylQaLXbzRE9ZdeXolzw
        6iXpmTEPIWGn11JFWrtRTFA/RzE=
X-Google-Smtp-Source: ABdhPJz4R511C9+BfbsUv72PgJAwv/Bg4J+CCXFvtwN6tXv/pjCWLCDmotWD2/FnuA8rGy+HadQZ2A==
X-Received: by 2002:a05:6638:e90:: with SMTP id p16mr1399602jas.26.1597264583301;
        Wed, 12 Aug 2020 13:36:23 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id 13sm1600936ilz.58.2020.08.12.13.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 13:36:22 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-spi@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Whitespace clean-ups in schema files
Date:   Wed, 12 Aug 2020 14:36:18 -0600
Message-Id: <20200812203618.2656699-1-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean-up incorrect indentation, extra spaces, long lines, and missing
EOF newline in schema files. Most of the clean-ups are for list
indentation which should always be 2 spaces more than the preceding
keyword.

Found with yamllint (which I plan to integrate into the checks).

Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-clk@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-spi@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-remoteproc@vger.kernel.org
Cc: linux-hwmon@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-iio@vger.kernel.org
Cc: linux-input@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/arm/arm,integrator.yaml          |  6 +-
 .../devicetree/bindings/arm/arm,realview.yaml | 66 ++++++-------
 .../bindings/arm/arm,vexpress-juno.yaml       | 12 +--
 .../bindings/arm/bcm/brcm,bcm11351.yaml       |  2 +-
 .../bindings/arm/bcm/brcm,bcm21664.yaml       |  2 +-
 .../bindings/arm/bcm/brcm,bcm23550.yaml       |  2 +-
 .../bindings/arm/bcm/brcm,cygnus.yaml         | 20 ++--
 .../devicetree/bindings/arm/bcm/brcm,hr2.yaml |  2 +-
 .../devicetree/bindings/arm/bcm/brcm,ns2.yaml |  4 +-
 .../devicetree/bindings/arm/bcm/brcm,nsp.yaml | 14 +--
 .../bindings/arm/bcm/brcm,stingray.yaml       |  6 +-
 .../bindings/arm/bcm/brcm,vulcan-soc.yaml     |  4 +-
 .../bindings/arm/coresight-cti.yaml           | 20 ++--
 .../devicetree/bindings/arm/cpus.yaml         |  4 +-
 .../devicetree/bindings/arm/fsl.yaml          | 13 ++-
 .../bindings/arm/intel,keembay.yaml           |  2 +-
 .../arm/mediatek/mediatek,pericfg.yaml        | 30 +++---
 .../bindings/bus/baikal,bt1-apb.yaml          |  2 +-
 .../bindings/bus/baikal,bt1-axi.yaml          |  2 +-
 .../bindings/clock/idt,versaclock5.yaml       |  8 +-
 .../bindings/clock/ingenic,cgu.yaml           | 16 ++--
 .../devicetree/bindings/clock/qcom,mmcc.yaml  |  2 +-
 .../bindings/clock/renesas,cpg-clocks.yaml    |  6 +-
 .../bindings/clock/sprd,sc9863a-clk.yaml      |  2 +-
 .../bindings/display/bridge/nwl-dsi.yaml      | 15 ++-
 .../bindings/display/bridge/renesas,lvds.yaml | 18 ++--
 .../display/bridge/simple-bridge.yaml         | 18 ++--
 .../bindings/display/dsi-controller.yaml      | 10 +-
 .../bindings/display/ilitek,ili9486.yaml      |  4 +-
 .../bindings/display/ingenic,ipu.yaml         |  8 +-
 .../bindings/display/ingenic,lcd.yaml         | 10 +-
 .../devicetree/bindings/display/msm/gmu.yaml  | 38 ++++----
 .../panel/asus,z00t-tm5p5-nt35596.yaml        |  4 +-
 .../display/panel/boe,tv101wum-nl6.yaml       | 12 +--
 .../display/panel/elida,kd35t133.yaml         |  4 +-
 .../display/panel/feixin,k101-im2ba02.yaml    |  6 +-
 .../display/panel/ilitek,ili9322.yaml         |  3 +-
 .../display/panel/ilitek,ili9881c.yaml        |  3 +-
 .../display/panel/leadtek,ltk050h3146w.yaml   |  4 +-
 .../display/panel/leadtek,ltk500hd1829.yaml   |  4 +-
 .../display/panel/novatek,nt35510.yaml        |  4 +-
 .../bindings/display/panel/panel-dsi-cm.yaml  |  8 +-
 .../bindings/display/panel/panel-timing.yaml  | 20 ++--
 .../display/panel/raydium,rm68200.yaml        |  4 +-
 .../panel/samsung,s6e88a0-ams452ef01.yaml     |  4 +-
 .../display/panel/visionox,rm69299.yaml       |  2 +-
 .../bindings/display/st,stm32-dsi.yaml        |  3 +-
 .../bindings/display/ti/ti,j721e-dss.yaml     |  2 +-
 .../devicetree/bindings/dsp/fsl,dsp.yaml      |  4 +-
 .../devicetree/bindings/example-schema.yaml   |  4 +-
 .../devicetree/bindings/fsi/ibm,fsi2spi.yaml  |  2 +-
 .../bindings/gpio/brcm,xgs-iproc-gpio.yaml    |  6 +-
 .../bindings/gpio/renesas,rcar-gpio.yaml      | 58 +++++------
 .../devicetree/bindings/gpu/vivante,gc.yaml   |  3 +-
 .../bindings/hwmon/adi,axi-fan-control.yaml   |  2 +-
 .../devicetree/bindings/i2c/i2c-imx.yaml      | 32 +++----
 .../devicetree/bindings/i2c/i2c-pxa.yaml      |  4 +-
 .../bindings/iio/adc/adi,ad7606.yaml          |  8 +-
 .../bindings/iio/adc/maxim,max1238.yaml       |  2 +-
 .../bindings/iio/adc/qcom,spmi-vadc.yaml      | 19 ++--
 .../bindings/iio/adc/rockchip-saradc.yaml     |  8 +-
 .../bindings/iio/amplifiers/adi,hmc425a.yaml  |  4 +-
 .../bindings/iio/chemical/atlas,sensor.yaml   |  4 +-
 .../bindings/iio/dac/adi,ad5770r.yaml         | 60 ++++++------
 .../bindings/iio/light/vishay,vcnl4000.yaml   | 22 ++---
 .../iio/magnetometer/asahi-kasei,ak8975.yaml  | 16 ++--
 .../iio/proximity/vishay,vcnl3020.yaml        |  4 +-
 .../bindings/iio/temperature/adi,ltc2983.yaml |  2 +-
 .../devicetree/bindings/input/imx-keypad.yaml | 26 ++---
 .../input/touchscreen/cypress,cy8ctma140.yaml |  2 +-
 .../input/touchscreen/edt-ft5x06.yaml         | 10 +-
 .../bindings/input/touchscreen/goodix.yaml    |  5 +-
 .../input/touchscreen/touchscreen.yaml        | 12 +--
 .../bindings/interconnect/fsl,imx8m-noc.yaml  | 20 ++--
 .../bindings/interconnect/qcom,sc7180.yaml    |  2 +-
 .../bindings/interconnect/qcom,sdm845.yaml    |  2 +-
 .../interrupt-controller/arm,gic.yaml         |  4 +-
 .../interrupt-controller/ingenic,intc.yaml    | 22 ++---
 .../bindings/leds/backlight/qcom-wled.yaml    |  3 +-
 .../devicetree/bindings/mailbox/fsl,mu.yaml   | 12 +--
 .../bindings/mailbox/qcom-ipcc.yaml           |  2 +-
 .../allwinner,sun8i-a83t-de2-rotate.yaml      |  4 +-
 .../media/allwinner,sun8i-h3-deinterlace.yaml |  4 +-
 .../bindings/media/i2c/adv7180.yaml           | 43 ++++-----
 .../bindings/media/i2c/imi,rdacm2x-gmsl.yaml  |  2 +-
 .../bindings/media/i2c/maxim,max9286.yaml     |  2 +-
 .../devicetree/bindings/media/i2c/ov8856.yaml |  3 +-
 .../bindings/media/renesas,csi2.yaml          | 18 ++--
 .../bindings/media/rockchip-vpu.yaml          |  4 +-
 .../bindings/media/xilinx/xlnx,csi2rxss.yaml  | 15 ++-
 .../bindings/memory-controllers/fsl/mmdc.yaml | 12 +--
 .../memory-controllers/ingenic,nemc.yaml      |  8 +-
 .../memory-controllers/renesas,rpc-if.yaml    |  8 +-
 .../bindings/mfd/cirrus,madera.yaml           | 34 +++----
 .../bindings/mfd/gateworks-gsc.yaml           |  4 +-
 .../devicetree/bindings/mfd/st,stpmic1.yaml   | 24 ++---
 .../mfd/ti,j721e-system-controller.yaml       | 11 +--
 .../devicetree/bindings/mfd/wlf,arizona.yaml  | 22 ++---
 .../bindings/mmc/amlogic,meson-mx-sdhc.yaml   |  6 +-
 .../devicetree/bindings/mmc/ingenic,mmc.yaml  | 14 +--
 .../devicetree/bindings/mmc/renesas,sdhi.yaml |  6 +-
 .../bindings/mtd/arasan,nand-controller.yaml  |  8 +-
 .../devicetree/bindings/mtd/gpmi-nand.yaml    |  2 +-
 .../devicetree/bindings/mtd/mxc-nand.yaml     |  2 +-
 .../bindings/mtd/st,stm32-fmc2-nand.yaml      |  2 +-
 .../devicetree/bindings/net/dsa/dsa.yaml      |  4 +-
 .../devicetree/bindings/net/qcom,ipa.yaml     | 12 +--
 .../bindings/net/socionext,uniphier-ave4.yaml | 12 +--
 .../devicetree/bindings/net/stm32-dwmac.yaml  | 12 +--
 .../bindings/net/ti,cpsw-switch.yaml          | 62 ++++++------
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 66 ++++++-------
 .../devicetree/bindings/nvmem/imx-ocotp.yaml  | 24 ++---
 .../bindings/nvmem/qcom,qfprom.yaml           |  4 +-
 .../phy/amlogic,meson-g12a-usb2-phy.yaml      |  6 +-
 .../bindings/phy/phy-rockchip-inno-usb2.yaml  |  6 +-
 .../devicetree/bindings/phy/qcom,qmp-phy.yaml | 13 ++-
 .../bindings/phy/qcom,qmp-usb3-dp-phy.yaml    |  9 +-
 .../bindings/phy/qcom,qusb2-phy.yaml          | 30 +++---
 .../phy/socionext,uniphier-pcie-phy.yaml      |  8 +-
 .../phy/socionext,uniphier-usb3hs-phy.yaml    | 10 +-
 .../phy/socionext,uniphier-usb3ss-phy.yaml    | 22 ++---
 .../bindings/phy/ti,phy-j721e-wiz.yaml        |  3 +-
 .../pinctrl/aspeed,ast2400-pinctrl.yaml       | 32 +++----
 .../pinctrl/aspeed,ast2500-pinctrl.yaml       | 36 +++----
 .../pinctrl/aspeed,ast2600-pinctrl.yaml       | 96 +++++++++----------
 .../bindings/pinctrl/ingenic,pinctrl.yaml     | 24 ++---
 .../pinctrl/qcom,ipq6018-pinctrl.yaml         | 54 +++++------
 .../bindings/pinctrl/qcom,sm8250-pinctrl.yaml | 32 +++----
 .../bindings/pinctrl/st,stm32-pinctrl.yaml    |  4 +-
 .../bindings/power/power-domain.yaml          | 14 +--
 .../bindings/power/supply/gpio-charger.yaml   |  4 +-
 .../regulator/qcom,smd-rpm-regulator.yaml     |  3 +-
 .../regulator/qcom-labibb-regulator.yaml      |  4 +-
 .../bindings/remoteproc/ti,k3-dsp-rproc.yaml  | 20 ++--
 .../bindings/reset/fsl,imx7-src.yaml          |  6 +-
 .../devicetree/bindings/rtc/ingenic,rtc.yaml  | 16 ++--
 .../bindings/serial/ingenic,uart.yaml         | 20 ++--
 .../soc/microchip/atmel,at91rm9200-tcb.yaml   | 12 +--
 .../bindings/soc/qcom/qcom,geni-se.yaml       | 30 +++---
 .../bindings/sound/amlogic,aiu.yaml           | 11 +--
 .../bindings/sound/amlogic,g12a-toacodec.yaml | 10 +-
 .../bindings/sound/cirrus,cs42l51.yaml        |  2 +-
 .../bindings/sound/ingenic,aic.yaml           | 12 +--
 .../bindings/sound/maxim,max98390.yaml        |  2 +-
 .../bindings/sound/rockchip-i2s.yaml          | 24 ++---
 .../bindings/sound/rockchip-spdif.yaml        |  4 +-
 .../devicetree/bindings/sound/tas2770.yaml    |  4 +-
 .../bindings/sound/tlv320adcx140.yaml         | 28 +++---
 .../bindings/spi/allwinner,sun6i-a31-spi.yaml |  8 +-
 .../devicetree/bindings/spi/fsl-imx-cspi.yaml | 26 ++---
 .../bindings/spi/mikrotik,rb4xx-spi.yaml      |  3 +-
 .../devicetree/bindings/spi/spi-mux.yaml      | 74 +++++++-------
 .../devicetree/bindings/spi/spi-rockchip.yaml | 14 +--
 .../thermal/thermal-cooling-devices.yaml      |  6 +-
 .../bindings/thermal/thermal-idle.yaml        | 45 +++++----
 .../devicetree/bindings/timer/fsl,imxgpt.yaml | 14 +--
 .../bindings/timer/ingenic,tcu.yaml           | 50 +++++-----
 .../bindings/timer/snps,dw-apb-timer.yaml     |  4 +-
 .../devicetree/bindings/trivial-devices.yaml  |  2 +-
 .../devicetree/bindings/usb/dwc2.yaml         | 31 +++---
 .../devicetree/bindings/usb/generic-ehci.yaml |  2 +-
 .../devicetree/bindings/usb/ingenic,musb.yaml |  8 +-
 .../bindings/usb/nvidia,tegra-xudc.yaml       | 10 +-
 .../devicetree/bindings/usb/ti,j721e-usb.yaml |  6 +-
 .../bindings/usb/ti,keystone-dwc3.yaml        |  4 +-
 .../devicetree/bindings/vendor-prefixes.yaml  |  3 +-
 166 files changed, 1103 insertions(+), 1113 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arm,integrator.yaml b/Documentation/devicetree/bindings/arm/arm,integrator.yaml
index 192ded470e32..f0daf990e077 100644
--- a/Documentation/devicetree/bindings/arm/arm,integrator.yaml
+++ b/Documentation/devicetree/bindings/arm/arm,integrator.yaml
@@ -67,9 +67,9 @@ patternProperties:
       compatible:
         items:
           - enum:
-            - arm,integrator-ap-syscon
-            - arm,integrator-cp-syscon
-            - arm,integrator-sp-syscon
+              - arm,integrator-ap-syscon
+              - arm,integrator-cp-syscon
+              - arm,integrator-sp-syscon
           - const: syscon
       reg:
         maxItems: 1
diff --git a/Documentation/devicetree/bindings/arm/arm,realview.yaml b/Documentation/devicetree/bindings/arm/arm,realview.yaml
index d6e85d198afe..1d0b4e2bc7d2 100644
--- a/Documentation/devicetree/bindings/arm/arm,realview.yaml
+++ b/Documentation/devicetree/bindings/arm/arm,realview.yaml
@@ -55,20 +55,20 @@ properties:
       compatible:
         oneOf:
           - items:
-            - const: arm,realview-eb-soc
-            - const: simple-bus
+              - const: arm,realview-eb-soc
+              - const: simple-bus
           - items:
-            - const: arm,realview-pb1176-soc
-            - const: simple-bus
+              - const: arm,realview-pb1176-soc
+              - const: simple-bus
           - items:
-            - const: arm,realview-pb11mp-soc
-            - const: simple-bus
+              - const: arm,realview-pb11mp-soc
+              - const: simple-bus
           - items:
-            - const: arm,realview-pba8-soc
-            - const: simple-bus
+              - const: arm,realview-pba8-soc
+              - const: simple-bus
           - items:
-            - const: arm,realview-pbx-soc
-            - const: simple-bus
+              - const: arm,realview-pbx-soc
+              - const: simple-bus
 
     patternProperties:
       "^.*syscon@[0-9a-f]+$":
@@ -79,35 +79,35 @@ properties:
           compatible:
             oneOf:
               - items:
-                - const: arm,realview-eb11mp-revb-syscon
-                - const: arm,realview-eb-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-eb11mp-revb-syscon
+                  - const: arm,realview-eb-syscon
+                  - const: syscon
+                  - const: simple-mfd
               - items:
-                - const: arm,realview-eb11mp-revc-syscon
-                - const: arm,realview-eb-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-eb11mp-revc-syscon
+                  - const: arm,realview-eb-syscon
+                  - const: syscon
+                  - const: simple-mfd
               - items:
-                - const: arm,realview-eb-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-eb-syscon
+                  - const: syscon
+                  - const: simple-mfd
               - items:
-                - const: arm,realview-pb1176-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-pb1176-syscon
+                  - const: syscon
+                  - const: simple-mfd
               - items:
-                - const: arm,realview-pb11mp-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-pb11mp-syscon
+                  - const: syscon
+                  - const: simple-mfd
               - items:
-                - const: arm,realview-pba8-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-pba8-syscon
+                  - const: syscon
+                  - const: simple-mfd
               - items:
-                - const: arm,realview-pbx-syscon
-                - const: syscon
-                - const: simple-mfd
+                  - const: arm,realview-pbx-syscon
+                  - const: syscon
+                  - const: simple-mfd
 
         required:
           - compatible
diff --git a/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml b/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml
index a3420c81cf35..26829a803fda 100644
--- a/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml
+++ b/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml
@@ -165,10 +165,10 @@ patternProperties:
       compatible:
         oneOf:
           - items:
-            - enum:
-              - arm,vexpress,v2m-p1
-              - arm,vexpress,v2p-p1
-            - const: simple-bus
+              - enum:
+                  - arm,vexpress,v2m-p1
+                  - arm,vexpress,v2p-p1
+              - const: simple-bus
           - const: simple-bus
       motherboard:
         type: object
@@ -186,8 +186,8 @@ patternProperties:
           compatible:
             items:
               - enum:
-                - arm,vexpress,v2m-p1
-                - arm,vexpress,v2p-p1
+                  - arm,vexpress,v2m-p1
+                  - arm,vexpress,v2p-p1
               - const: simple-bus
           arm,v2m-memory-map:
             description: This describes the memory map type.
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml
index b5ef2666e6b2..497600a2ffb9 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm11351.yaml
@@ -15,7 +15,7 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,bcm28155-ap
+          - brcm,bcm28155-ap
       - const: brcm,bcm11351
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml
index aafbd6a27708..e0ee931723dc 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm21664.yaml
@@ -15,7 +15,7 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,bcm21664-garnet
+          - brcm,bcm21664-garnet
       - const: brcm,bcm21664
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml
index c4b4efd28a55..40d12ea56e54 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,bcm23550.yaml
@@ -15,7 +15,7 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,bcm23550-sparrow
+          - brcm,bcm23550-sparrow
       - const: brcm,bcm23550
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml
index fe111e72dac3..9ba7b16e1fc4 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,cygnus.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Broadcom Cygnus device tree bindings
 
 maintainers:
-   - Ray Jui <rjui@broadcom.com>
-   - Scott Branden <sbranden@broadcom.com>
+  - Ray Jui <rjui@broadcom.com>
+  - Scott Branden <sbranden@broadcom.com>
 
 properties:
   $nodename:
@@ -16,14 +16,14 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,bcm11300
-        - brcm,bcm11320
-        - brcm,bcm11350
-        - brcm,bcm11360
-        - brcm,bcm58300
-        - brcm,bcm58302
-        - brcm,bcm58303
-        - brcm,bcm58305
+          - brcm,bcm11300
+          - brcm,bcm11320
+          - brcm,bcm11350
+          - brcm,bcm11360
+          - brcm,bcm58300
+          - brcm,bcm58302
+          - brcm,bcm58303
+          - brcm,bcm58305
       - const: brcm,cygnus
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml
index 1158f49b0b83..ae614b6722c2 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,hr2.yaml
@@ -21,7 +21,7 @@ properties:
   compatible:
     items:
       - enum:
-        - ubnt,unifi-switch8
+          - ubnt,unifi-switch8
       - const: brcm,bcm53342
       - const: brcm,hr2
 
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml
index 2451704f87f0..0749adf94c28 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,ns2.yaml
@@ -16,8 +16,8 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,ns2-svk
-        - brcm,ns2-xmc
+          - brcm,ns2-svk
+          - brcm,ns2-xmc
       - const: brcm,ns2
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml
index fe364cebf57f..8c2cacb2bb4f 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,nsp.yaml
@@ -24,13 +24,13 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,bcm58522
-        - brcm,bcm58525
-        - brcm,bcm58535
-        - brcm,bcm58622
-        - brcm,bcm58623
-        - brcm,bcm58625
-        - brcm,bcm88312
+          - brcm,bcm58522
+          - brcm,bcm58525
+          - brcm,bcm58535
+          - brcm,bcm58622
+          - brcm,bcm58623
+          - brcm,bcm58625
+          - brcm,bcm88312
       - const: brcm,nsp
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml
index 4ad2b2124ab4..c13cb96545a2 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,stingray.yaml
@@ -16,9 +16,9 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,bcm958742k
-        - brcm,bcm958742t
-        - brcm,bcm958802a802x
+          - brcm,bcm958742k
+          - brcm,bcm958742t
+          - brcm,bcm958802a802x
       - const: brcm,stingray
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml b/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml
index c5b6f31c20b9..ccdf9f99cb2b 100644
--- a/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/brcm,vulcan-soc.yaml
@@ -15,8 +15,8 @@ properties:
   compatible:
     items:
       - enum:
-        - brcm,vulcan-eval
-        - cavium,thunderx2-cn9900
+          - brcm,vulcan-eval
+          - cavium,thunderx2-cn9900
       - const: brcm,vulcan-soc
 
 ...
diff --git a/Documentation/devicetree/bindings/arm/coresight-cti.yaml b/Documentation/devicetree/bindings/arm/coresight-cti.yaml
index 17df5cd12d8d..e42ff69d8bfb 100644
--- a/Documentation/devicetree/bindings/arm/coresight-cti.yaml
+++ b/Documentation/devicetree/bindings/arm/coresight-cti.yaml
@@ -82,12 +82,12 @@ properties:
   compatible:
     oneOf:
       - items:
-        - const: arm,coresight-cti
-        - const: arm,primecell
+          - const: arm,coresight-cti
+          - const: arm,primecell
       - items:
-        - const: arm,coresight-cti-v8-arch
-        - const: arm,coresight-cti
-        - const: arm,primecell
+          - const: arm,coresight-cti-v8-arch
+          - const: arm,coresight-cti
+          - const: arm,primecell
 
   reg:
     maxItems: 1
@@ -191,16 +191,16 @@ patternProperties:
 
     anyOf:
       - required:
-        - arm,trig-in-sigs
+          - arm,trig-in-sigs
       - required:
-        - arm,trig-out-sigs
+          - arm,trig-out-sigs
     oneOf:
       - required:
-        - arm,trig-conn-name
+          - arm,trig-conn-name
       - required:
-        - cpu
+          - cpu
       - required:
-        - arm,cs-dev-assoc
+          - arm,cs-dev-assoc
     required:
       - reg
 
diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
index 40f692c846f0..1222bf1831fa 100644
--- a/Documentation/devicetree/bindings/arm/cpus.yaml
+++ b/Documentation/devicetree/bindings/arm/cpus.yaml
@@ -330,8 +330,8 @@ if:
     - enable-method
 
 then:
-   required:
-     - secondary-boot-reg
+  required:
+    - secondary-boot-reg
 
 required:
   - device_type
diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index f63895c8ce2d..88814a2a14a5 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -273,8 +273,8 @@ properties:
               - fsl,imx6ull-14x14-evk     # i.MX6 UltraLiteLite 14x14 EVK Board
               - kontron,imx6ull-n6411-som # Kontron N6411 SOM
               - myir,imx6ull-mys-6ulx-eval # MYiR Tech iMX6ULL Evaluation Board
-              - toradex,colibri-imx6ull-eval            # Colibri iMX6ULL Module on Colibri Evaluation Board
-              - toradex,colibri-imx6ull-wifi-eval       # Colibri iMX6ULL Wi-Fi / Bluetooth Module on Colibri Evaluation Board
+              - toradex,colibri-imx6ull-eval      # Colibri iMX6ULL Module on Colibri Eval Board
+              - toradex,colibri-imx6ull-wifi-eval # Colibri iMX6ULL Wi-Fi / BT Module on Colibri Eval Board
           - const: fsl,imx6ull
 
       - description: Kontron N6411 S Board
@@ -312,9 +312,12 @@ properties:
               - toradex,colibri-imx7d                   # Colibri iMX7 Dual Module
               - toradex,colibri-imx7d-aster             # Colibri iMX7 Dual Module on Aster Carrier Board
               - toradex,colibri-imx7d-emmc              # Colibri iMX7 Dual 1GB (eMMC) Module
-              - toradex,colibri-imx7d-emmc-aster        # Colibri iMX7 Dual 1GB (eMMC) Module on Aster Carrier Board
-              - toradex,colibri-imx7d-emmc-eval-v3      # Colibri iMX7 Dual 1GB (eMMC) Module on Colibri Evaluation Board V3
-              - toradex,colibri-imx7d-eval-v3           # Colibri iMX7 Dual Module on Colibri Evaluation Board V3
+              - toradex,colibri-imx7d-emmc-aster        # Colibri iMX7 Dual 1GB (eMMC) Module on 
+                                                        #  Aster Carrier Board
+              - toradex,colibri-imx7d-emmc-eval-v3      # Colibri iMX7 Dual 1GB (eMMC) Module on 
+                                                        #  Colibri Evaluation Board V3
+              - toradex,colibri-imx7d-eval-v3           # Colibri iMX7 Dual Module on 
+                                                        #  Colibri Evaluation Board V3
               - tq,imx7d-mba7             # i.MX7D TQ MBa7 with TQMa7D SoM
               - zii,imx7d-rmu2            # ZII RMU2 Board
               - zii,imx7d-rpu2            # ZII RPU2 Board
diff --git a/Documentation/devicetree/bindings/arm/intel,keembay.yaml b/Documentation/devicetree/bindings/arm/intel,keembay.yaml
index 4d925785f504..06a7b05f435f 100644
--- a/Documentation/devicetree/bindings/arm/intel,keembay.yaml
+++ b/Documentation/devicetree/bindings/arm/intel,keembay.yaml
@@ -14,6 +14,6 @@ properties:
   compatible:
     items:
       - enum:
-        - intel,keembay-evm
+          - intel,keembay-evm
       - const: intel,keembay
 ...
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
index e271c4682ebc..1af30174b2d0 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
@@ -17,22 +17,22 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - mediatek,mt2701-pericfg
-          - mediatek,mt2712-pericfg
-          - mediatek,mt6765-pericfg
-          - mediatek,mt7622-pericfg
-          - mediatek,mt7629-pericfg
-          - mediatek,mt8135-pericfg
-          - mediatek,mt8173-pericfg
-          - mediatek,mt8183-pericfg
-          - mediatek,mt8516-pericfg
-        - const: syscon
+          - enum:
+              - mediatek,mt2701-pericfg
+              - mediatek,mt2712-pericfg
+              - mediatek,mt6765-pericfg
+              - mediatek,mt7622-pericfg
+              - mediatek,mt7629-pericfg
+              - mediatek,mt8135-pericfg
+              - mediatek,mt8173-pericfg
+              - mediatek,mt8183-pericfg
+              - mediatek,mt8516-pericfg
+          - const: syscon
       - items:
-        # Special case for mt7623 for backward compatibility
-        - const: mediatek,mt7623-pericfg
-        - const: mediatek,mt2701-pericfg
-        - const: syscon
+          # Special case for mt7623 for backward compatibility
+          - const: mediatek,mt7623-pericfg
+          - const: mediatek,mt2701-pericfg
+          - const: syscon
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml b/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml
index 68b0131a31d0..37ba3337f944 100644
--- a/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml
+++ b/Documentation/devicetree/bindings/bus/baikal,bt1-apb.yaml
@@ -19,7 +19,7 @@ description: |
   reported to the APB terminator (APB Errors Handler Block).
 
 allOf:
- - $ref: /schemas/simple-bus.yaml#
+  - $ref: /schemas/simple-bus.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml b/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
index 29e1aaea132b..0bee4694578a 100644
--- a/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
+++ b/Documentation/devicetree/bindings/bus/baikal,bt1-axi.yaml
@@ -23,7 +23,7 @@ description: |
   accessible by means of the Baikal-T1 System Controller.
 
 allOf:
- - $ref: /schemas/simple-bus.yaml#
+  - $ref: /schemas/simple-bus.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
index 3d4e1685cc55..28c6461b9a9a 100644
--- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
+++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
@@ -95,10 +95,10 @@ allOf:
       # Devices without builtin crystal
       properties:
         clock-names:
-            minItems: 1
-            maxItems: 2
-            items:
-              enum: [ xin, clkin ]
+          minItems: 1
+          maxItems: 2
+          items:
+            enum: [ xin, clkin ]
         clocks:
           minItems: 1
           maxItems: 2
diff --git a/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml b/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
index a952d5811823..5dd7ea8a78e4 100644
--- a/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
+++ b/Documentation/devicetree/bindings/clock/ingenic,cgu.yaml
@@ -47,12 +47,12 @@ properties:
   compatible:
     items:
       - enum:
-        - ingenic,jz4740-cgu
-        - ingenic,jz4725b-cgu
-        - ingenic,jz4770-cgu
-        - ingenic,jz4780-cgu
-        - ingenic,x1000-cgu
-        - ingenic,x1830-cgu
+          - ingenic,jz4740-cgu
+          - ingenic,jz4725b-cgu
+          - ingenic,jz4770-cgu
+          - ingenic,jz4780-cgu
+          - ingenic,x1000-cgu
+          - ingenic,x1830-cgu
       - const: simple-mfd
     minItems: 1
 
@@ -68,8 +68,8 @@ properties:
     items:
       - const: ext
       - enum:
-        - rtc
-        - osc32k # Different name, same clock
+          - rtc
+          - osc32k # Different name, same clock
 
   assigned-clocks:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
index 1b16a863b355..af32dee14fc6 100644
--- a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
@@ -65,7 +65,7 @@ properties:
 
   protected-clocks:
     description:
-       Protected clock specifier list as per common clock binding
+      Protected clock specifier list as per common clock binding
 
   vdd-gfx-supply:
     description:
diff --git a/Documentation/devicetree/bindings/clock/renesas,cpg-clocks.yaml b/Documentation/devicetree/bindings/clock/renesas,cpg-clocks.yaml
index b83f4138f2f8..f110f9729aba 100644
--- a/Documentation/devicetree/bindings/clock/renesas,cpg-clocks.yaml
+++ b/Documentation/devicetree/bindings/clock/renesas,cpg-clocks.yaml
@@ -24,9 +24,9 @@ properties:
       - const: renesas,r8a7778-cpg-clocks # R-Car M1
       - const: renesas,r8a7779-cpg-clocks # R-Car H1
       - items:
-        - enum:
-            - renesas,r7s72100-cpg-clocks # RZ/A1H
-        - const: renesas,rz-cpg-clocks    # RZ/A1
+          - enum:
+              - renesas,r7s72100-cpg-clocks # RZ/A1H
+          - const: renesas,rz-cpg-clocks    # RZ/A1
       - const: renesas,sh73a0-cpg-clocks  # SH-Mobile AG5
 
   reg:
diff --git a/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml b/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
index 29813873cfbc..c6d091518650 100644
--- a/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/sprd,sc9863a-clk.yaml
@@ -16,7 +16,7 @@ properties:
   "#clock-cells":
     const: 1
 
-  compatible :
+  compatible:
     enum:
       - sprd,sc9863a-ap-clk
       - sprd,sc9863a-aon-clk
diff --git a/Documentation/devicetree/bindings/display/bridge/nwl-dsi.yaml b/Documentation/devicetree/bindings/display/bridge/nwl-dsi.yaml
index 2c4c34e3bc29..04099f5bea3f 100644
--- a/Documentation/devicetree/bindings/display/bridge/nwl-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/nwl-dsi.yaml
@@ -162,14 +162,13 @@ required:
 additionalProperties: false
 
 examples:
- - |
+  - |
+    #include <dt-bindings/clock/imx8mq-clock.h>
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/imx8mq-reset.h>
 
-   #include <dt-bindings/clock/imx8mq-clock.h>
-   #include <dt-bindings/gpio/gpio.h>
-   #include <dt-bindings/interrupt-controller/arm-gic.h>
-   #include <dt-bindings/reset/imx8mq-reset.h>
-
-   mipi_dsi: mipi_dsi@30a00000 {
+    mipi_dsi: mipi_dsi@30a00000 {
               #address-cells = <1>;
               #size-cells = <0>;
               compatible = "fsl,imx8mq-nwl-dsi";
@@ -224,4 +223,4 @@ examples:
                            };
                     };
               };
-      };
+    };
diff --git a/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml b/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml
index 98c7330a9485..baaf2a2a6fed 100644
--- a/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/renesas,lvds.yaml
@@ -119,17 +119,17 @@ then:
         # The LVDS encoder can use the EXTAL or DU_DOTCLKINx clocks.
         # These clocks are optional.
         - enum:
-          - extal
-          - dclkin.0
-          - dclkin.1
+            - extal
+            - dclkin.0
+            - dclkin.1
         - enum:
-          - extal
-          - dclkin.0
-          - dclkin.1
+            - extal
+            - dclkin.0
+            - dclkin.1
         - enum:
-          - extal
-          - dclkin.0
-          - dclkin.1
+            - extal
+            - dclkin.0
+            - dclkin.1
 
   required:
     - clock-names
diff --git a/Documentation/devicetree/bindings/display/bridge/simple-bridge.yaml b/Documentation/devicetree/bindings/display/bridge/simple-bridge.yaml
index 0880cbf217d5..3ddb35fcf0a2 100644
--- a/Documentation/devicetree/bindings/display/bridge/simple-bridge.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/simple-bridge.yaml
@@ -18,16 +18,16 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - ti,ths8134a
-          - ti,ths8134b
-        - const: ti,ths8134
+          - enum:
+              - ti,ths8134a
+              - ti,ths8134b
+          - const: ti,ths8134
       - enum:
-        - adi,adv7123
-        - dumb-vga-dac
-        - ti,opa362
-        - ti,ths8134
-        - ti,ths8135
+          - adi,adv7123
+          - dumb-vga-dac
+          - ti,opa362
+          - ti,ths8134
+          - ti,ths8135
 
   ports:
     type: object
diff --git a/Documentation/devicetree/bindings/display/dsi-controller.yaml b/Documentation/devicetree/bindings/display/dsi-controller.yaml
index 85b71b1fd28a..a02039e3aca0 100644
--- a/Documentation/devicetree/bindings/display/dsi-controller.yaml
+++ b/Documentation/devicetree/bindings/display/dsi-controller.yaml
@@ -55,11 +55,11 @@ patternProperties:
       clock-master:
         type: boolean
         description:
-           Should be enabled if the host is being used in conjunction with
-           another DSI host to drive the same peripheral. Hardware supporting
-           such a configuration generally requires the data on both the busses
-           to be driven by the same clock. Only the DSI host instance
-           controlling this clock should contain this property.
+          Should be enabled if the host is being used in conjunction with
+          another DSI host to drive the same peripheral. Hardware supporting
+          such a configuration generally requires the data on both the busses
+          to be driven by the same clock. Only the DSI host instance
+          controlling this clock should contain this property.
 
       enforce-video-mode:
         type: boolean
diff --git a/Documentation/devicetree/bindings/display/ilitek,ili9486.yaml b/Documentation/devicetree/bindings/display/ilitek,ili9486.yaml
index 66e93e563653..aecff34f505d 100644
--- a/Documentation/devicetree/bindings/display/ilitek,ili9486.yaml
+++ b/Documentation/devicetree/bindings/display/ilitek,ili9486.yaml
@@ -21,9 +21,9 @@ properties:
     items:
       - enum:
           # Waveshare 3.5" 320x480 Color TFT LCD
-        - waveshare,rpi-lcd-35
+          - waveshare,rpi-lcd-35
           # Ozzmaker 3.5" 320x480 Color TFT LCD
-        - ozzmaker,piscreen
+          - ozzmaker,piscreen
       - const: ilitek,ili9486
 
   spi-max-frequency:
diff --git a/Documentation/devicetree/bindings/display/ingenic,ipu.yaml b/Documentation/devicetree/bindings/display/ingenic,ipu.yaml
index 5bfc33eb32c9..12064a8e7a92 100644
--- a/Documentation/devicetree/bindings/display/ingenic,ipu.yaml
+++ b/Documentation/devicetree/bindings/display/ingenic,ipu.yaml
@@ -13,11 +13,11 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4725b-ipu
-        - ingenic,jz4760-ipu
+          - ingenic,jz4725b-ipu
+          - ingenic,jz4760-ipu
       - items:
-        - const: ingenic,jz4770-ipu
-        - const: ingenic,jz4760-ipu
+          - const: ingenic,jz4770-ipu
+          - const: ingenic,jz4760-ipu
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/ingenic,lcd.yaml b/Documentation/devicetree/bindings/display/ingenic,lcd.yaml
index d56db1802fad..768050f30dba 100644
--- a/Documentation/devicetree/bindings/display/ingenic,lcd.yaml
+++ b/Documentation/devicetree/bindings/display/ingenic,lcd.yaml
@@ -58,11 +58,11 @@ properties:
       - port@0
 
 required:
-    - compatible
-    - reg
-    - interrupts
-    - clocks
-    - clock-names
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
 
 if:
   properties:
diff --git a/Documentation/devicetree/bindings/display/msm/gmu.yaml b/Documentation/devicetree/bindings/display/msm/gmu.yaml
index 0b8736a9384e..53056dd02597 100644
--- a/Documentation/devicetree/bindings/display/msm/gmu.yaml
+++ b/Documentation/devicetree/bindings/display/msm/gmu.yaml
@@ -38,10 +38,10 @@ properties:
 
   clocks:
     items:
-     - description: GMU clock
-     - description: GPU CX clock
-     - description: GPU AXI clock
-     - description: GPU MEMNOC clock
+      - description: GMU clock
+      - description: GPU CX clock
+      - description: GPU AXI clock
+      - description: GPU MEMNOC clock
 
   clock-names:
     items:
@@ -52,8 +52,8 @@ properties:
 
   interrupts:
     items:
-     - description: GMU HFI interrupt
-     - description: GMU interrupt
+      - description: GMU HFI interrupt
+      - description: GMU interrupt
 
 
   interrupt-names:
@@ -62,14 +62,14 @@ properties:
       - const: gmu
 
   power-domains:
-     items:
-       - description: CX power domain
-       - description: GX power domain
+    items:
+      - description: CX power domain
+      - description: GX power domain
 
   power-domain-names:
-     items:
-       - const: cx
-       - const: gx
+    items:
+      - const: cx
+      - const: gx
 
   iommus:
     maxItems: 1
@@ -90,13 +90,13 @@ required:
   - operating-points-v2
 
 examples:
- - |
-   #include <dt-bindings/clock/qcom,gpucc-sdm845.h>
-   #include <dt-bindings/clock/qcom,gcc-sdm845.h>
-   #include <dt-bindings/interrupt-controller/irq.h>
-   #include <dt-bindings/interrupt-controller/arm-gic.h>
+  - |
+    #include <dt-bindings/clock/qcom,gpucc-sdm845.h>
+    #include <dt-bindings/clock/qcom,gcc-sdm845.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-   gmu: gmu@506a000 {
+    gmu: gmu@506a000 {
         compatible="qcom,adreno-gmu-630.2", "qcom,adreno-gmu";
 
         reg = <0x506a000 0x30000>,
@@ -120,4 +120,4 @@ examples:
 
         iommus = <&adreno_smmu 5>;
         operating-points-v2 = <&gmu_opp_table>;
-   };
+    };
diff --git a/Documentation/devicetree/bindings/display/panel/asus,z00t-tm5p5-nt35596.yaml b/Documentation/devicetree/bindings/display/panel/asus,z00t-tm5p5-nt35596.yaml
index 083d2b9d0c69..75a09df68ba0 100644
--- a/Documentation/devicetree/bindings/display/panel/asus,z00t-tm5p5-nt35596.yaml
+++ b/Documentation/devicetree/bindings/display/panel/asus,z00t-tm5p5-nt35596.yaml
@@ -24,9 +24,9 @@ properties:
   reg: true
   reset-gpios: true
   vdd-supply:
-     description: core voltage supply
+    description: core voltage supply
   vddio-supply:
-     description: vddio supply
+    description: vddio supply
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml b/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml
index 7f5df5851017..38bc1d1b511e 100644
--- a/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml
+++ b/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml
@@ -48,12 +48,12 @@ properties:
   port: true
 
 required:
- - compatible
- - reg
- - enable-gpios
- - pp1800-supply
- - avdd-supply
- - avee-supply
+  - compatible
+  - reg
+  - enable-gpios
+  - pp1800-supply
+  - avdd-supply
+  - avee-supply
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/display/panel/elida,kd35t133.yaml b/Documentation/devicetree/bindings/display/panel/elida,kd35t133.yaml
index aa761f697b7a..7adb83e2e8d9 100644
--- a/Documentation/devicetree/bindings/display/panel/elida,kd35t133.yaml
+++ b/Documentation/devicetree/bindings/display/panel/elida,kd35t133.yaml
@@ -19,9 +19,9 @@ properties:
   backlight: true
   reset-gpios: true
   iovcc-supply:
-     description: regulator that supplies the iovcc voltage
+    description: regulator that supplies the iovcc voltage
   vdd-supply:
-     description: regulator that supplies the vdd voltage
+    description: regulator that supplies the vdd voltage
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/panel/feixin,k101-im2ba02.yaml b/Documentation/devicetree/bindings/display/panel/feixin,k101-im2ba02.yaml
index 927f1eea18d2..81adb82f061d 100644
--- a/Documentation/devicetree/bindings/display/panel/feixin,k101-im2ba02.yaml
+++ b/Documentation/devicetree/bindings/display/panel/feixin,k101-im2ba02.yaml
@@ -19,11 +19,11 @@ properties:
   backlight: true
   reset-gpios: true
   avdd-supply:
-     description: regulator that supplies the AVDD voltage
+    description: regulator that supplies the AVDD voltage
   dvdd-supply:
-     description: regulator that supplies the DVDD voltage
+    description: regulator that supplies the DVDD voltage
   cvdd-supply:
-     description: regulator that supplies the CVDD voltage
+    description: regulator that supplies the CVDD voltage
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml b/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml
index 177d48c5bd97..e89c1ea62ffa 100644
--- a/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml
+++ b/Documentation/devicetree/bindings/display/panel/ilitek,ili9322.yaml
@@ -25,8 +25,7 @@ properties:
   compatible:
     items:
       - enum:
-        - dlink,dir-685-panel
-
+          - dlink,dir-685-panel
       - const: ilitek,ili9322
 
   reset-gpios: true
diff --git a/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml b/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml
index a39332276bab..76a9068a85dd 100644
--- a/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml
+++ b/Documentation/devicetree/bindings/display/panel/ilitek,ili9881c.yaml
@@ -13,8 +13,7 @@ properties:
   compatible:
     items:
       - enum:
-        - bananapi,lhr050h41
-
+          - bananapi,lhr050h41
       - const: ilitek,ili9881c
 
   backlight: true
diff --git a/Documentation/devicetree/bindings/display/panel/leadtek,ltk050h3146w.yaml b/Documentation/devicetree/bindings/display/panel/leadtek,ltk050h3146w.yaml
index a372bdc5bde1..3715882b63b6 100644
--- a/Documentation/devicetree/bindings/display/panel/leadtek,ltk050h3146w.yaml
+++ b/Documentation/devicetree/bindings/display/panel/leadtek,ltk050h3146w.yaml
@@ -21,9 +21,9 @@ properties:
   backlight: true
   reset-gpios: true
   iovcc-supply:
-     description: regulator that supplies the iovcc voltage
+    description: regulator that supplies the iovcc voltage
   vci-supply:
-     description: regulator that supplies the vci voltage
+    description: regulator that supplies the vci voltage
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/panel/leadtek,ltk500hd1829.yaml b/Documentation/devicetree/bindings/display/panel/leadtek,ltk500hd1829.yaml
index b900973b5f7b..c5944b4d636c 100644
--- a/Documentation/devicetree/bindings/display/panel/leadtek,ltk500hd1829.yaml
+++ b/Documentation/devicetree/bindings/display/panel/leadtek,ltk500hd1829.yaml
@@ -19,9 +19,9 @@ properties:
   backlight: true
   reset-gpios: true
   iovcc-supply:
-     description: regulator that supplies the iovcc voltage
+    description: regulator that supplies the iovcc voltage
   vcc-supply:
-     description: regulator that supplies the vcc voltage
+    description: regulator that supplies the vcc voltage
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/panel/novatek,nt35510.yaml b/Documentation/devicetree/bindings/display/panel/novatek,nt35510.yaml
index 73d2ff3baaff..bc92928c805b 100644
--- a/Documentation/devicetree/bindings/display/panel/novatek,nt35510.yaml
+++ b/Documentation/devicetree/bindings/display/panel/novatek,nt35510.yaml
@@ -25,9 +25,9 @@ properties:
   reg: true
   reset-gpios: true
   vdd-supply:
-     description: regulator that supplies the vdd voltage
+    description: regulator that supplies the vdd voltage
   vddi-supply:
-     description: regulator that supplies the vddi voltage
+    description: regulator that supplies the vddi voltage
   backlight: true
 
 required:
diff --git a/Documentation/devicetree/bindings/display/panel/panel-dsi-cm.yaml b/Documentation/devicetree/bindings/display/panel/panel-dsi-cm.yaml
index d766c949c622..4a36aa64c716 100644
--- a/Documentation/devicetree/bindings/display/panel/panel-dsi-cm.yaml
+++ b/Documentation/devicetree/bindings/display/panel/panel-dsi-cm.yaml
@@ -27,10 +27,10 @@ properties:
   compatible:
     items:
       - enum:
-        - motorola,droid4-panel        # Panel from Motorola Droid4 phone
-        - nokia,himalaya               # Panel from Nokia N950 phone
-        - tpo,taal                     # Panel from OMAP4 SDP board
-      - const: panel-dsi-cm            # Generic DSI command mode panel compatible fallback
+          - motorola,droid4-panel        # Panel from Motorola Droid4 phone
+          - nokia,himalaya               # Panel from Nokia N950 phone
+          - tpo,taal                     # Panel from OMAP4 SDP board
+      - const: panel-dsi-cm              # Generic DSI command mode panel compatible fallback
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
index 182c19cb7fdd..9bf592dc3033 100644
--- a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
+++ b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
@@ -59,7 +59,7 @@ description: |
 properties:
 
   clock-frequency:
-   description: Panel clock in Hz
+    description: Panel clock in Hz
 
   hactive:
     $ref: /schemas/types.yaml#/definitions/uint32
@@ -200,15 +200,15 @@ properties:
     description: Enable double clock mode
 
 required:
- - clock-frequency
- - hactive
- - vactive
- - hfront-porch
- - hback-porch
- - hsync-len
- - vfront-porch
- - vback-porch
- - vsync-len
+  - clock-frequency
+  - hactive
+  - vactive
+  - hfront-porch
+  - hback-porch
+  - hsync-len
+  - vfront-porch
+  - vback-porch
+  - vsync-len
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml b/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml
index a35ba16fc000..39477793d289 100644
--- a/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml
+++ b/Documentation/devicetree/bindings/display/panel/raydium,rm68200.yaml
@@ -10,8 +10,8 @@ maintainers:
   - Philippe CORNU <philippe.cornu@st.com>
 
 description: |
-             The Raydium Semiconductor Corporation RM68200 is a 5.5" 720x1280 TFT LCD
-             panel connected using a MIPI-DSI video interface.
+  The Raydium Semiconductor Corporation RM68200 is a 5.5" 720x1280 TFT LCD
+  panel connected using a MIPI-DSI video interface.
 
 allOf:
   - $ref: panel-common.yaml#
diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6e88a0-ams452ef01.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6e88a0-ams452ef01.yaml
index 7a685d0428b3..44ce98f68705 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,s6e88a0-ams452ef01.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e88a0-ams452ef01.yaml
@@ -18,9 +18,9 @@ properties:
   reg: true
   reset-gpios: true
   vdd3-supply:
-     description: core voltage supply
+    description: core voltage supply
   vci-supply:
-     description: voltage supply for analog circuits
+    description: voltage supply for analog circuits
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml b/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml
index b36f39f6b233..076b057b4af5 100644
--- a/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml
+++ b/Documentation/devicetree/bindings/display/panel/visionox,rm69299.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Visionox model RM69299 Panels Device Tree Bindings.
 
 maintainers:
- - Harigovindan P <harigovi@codeaurora.org>
+  - Harigovindan P <harigovi@codeaurora.org>
 
 description: |
   This binding is for display panels using a Visionox RM692999 panel.
diff --git a/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml b/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
index 3be76d15bf6c..69cc7e8bf15a 100644
--- a/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/st,stm32-dsi.yaml
@@ -45,7 +45,7 @@ properties:
 
   phy-dsi-supply:
     description:
-        Phandle of the regulator that provides the supply voltage.
+      Phandle of the regulator that provides the supply voltage.
 
   ports:
     type: object
@@ -147,4 +147,3 @@ examples:
 
 ...
 
-
diff --git a/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml b/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
index bbd76591c180..173730d56334 100644
--- a/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
+++ b/Documentation/devicetree/bindings/display/ti/ti,j721e-dss.yaml
@@ -78,7 +78,7 @@ properties:
       - const: vp4
 
   interrupts:
-     items:
+    items:
       - description: common_m DSS Master common
       - description: common_s0 DSS Shared common 0
       - description: common_s1 DSS Shared common 1
diff --git a/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml b/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
index 3bbe9521c0bc..4cc011230153 100644
--- a/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
+++ b/Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
@@ -56,8 +56,8 @@ properties:
 
   memory-region:
     description:
-       phandle to a node describing reserved memory (System RAM memory)
-       used by DSP (see bindings/reserved-memory/reserved-memory.txt)
+      phandle to a node describing reserved memory (System RAM memory)
+      used by DSP (see bindings/reserved-memory/reserved-memory.txt)
     maxItems: 1
 
 required:
diff --git a/Documentation/devicetree/bindings/example-schema.yaml b/Documentation/devicetree/bindings/example-schema.yaml
index c9534d2164a2..822975dbeafa 100644
--- a/Documentation/devicetree/bindings/example-schema.yaml
+++ b/Documentation/devicetree/bindings/example-schema.yaml
@@ -177,10 +177,10 @@ properties:
 dependencies:
   # 'vendor,bool-property' is only allowed when 'vendor,string-array-property'
   # is present
-  vendor,bool-property: [ vendor,string-array-property ]
+  vendor,bool-property: [ 'vendor,string-array-property' ]
   # Expressing 2 properties in both orders means all of the set of properties
   # must be present or none of them.
-  vendor,string-array-property: [ vendor,bool-property ]
+  vendor,string-array-property: [ 'vendor,bool-property' ]
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml b/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
index 893d81e54caa..b26d4b4be743 100644
--- a/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
+++ b/Documentation/devicetree/bindings/fsi/ibm,fsi2spi.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: IBM FSI-attached SPI controllers
 
 maintainers:
- - Eddie James <eajames@linux.ibm.com>
+  - Eddie James <eajames@linux.ibm.com>
 
 description: |
   This binding describes an FSI CFAM engine called the FSI2SPI. Therefore this
diff --git a/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml b/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
index 4f2cbd8307a7..c213cb9ddb9f 100644
--- a/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
@@ -19,10 +19,8 @@ properties:
 
   reg:
     items:
-      - description: the I/O address containing the GPIO controller
-                     registers.
-      - description: the I/O address containing the Chip Common A interrupt
-                     registers.
+      - description: the I/O address containing the GPIO controller registers.
+      - description: the I/O address containing the Chip Common A interrupt registers.
 
   gpio-controller: true
 
diff --git a/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml b/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml
index 397d9383d15a..3ad229307bd5 100644
--- a/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml
@@ -13,39 +13,39 @@ properties:
   compatible:
     oneOf:
       - items:
-         - enum:
-             - renesas,gpio-r8a7778      # R-Car M1
-             - renesas,gpio-r8a7779      # R-Car H1
-         - const: renesas,rcar-gen1-gpio # R-Car Gen1
+          - enum:
+              - renesas,gpio-r8a7778      # R-Car M1
+              - renesas,gpio-r8a7779      # R-Car H1
+          - const: renesas,rcar-gen1-gpio # R-Car Gen1
 
       - items:
-         - enum:
-             - renesas,gpio-r8a7742      # RZ/G1H
-             - renesas,gpio-r8a7743      # RZ/G1M
-             - renesas,gpio-r8a7744      # RZ/G1N
-             - renesas,gpio-r8a7745      # RZ/G1E
-             - renesas,gpio-r8a77470     # RZ/G1C
-             - renesas,gpio-r8a7790      # R-Car H2
-             - renesas,gpio-r8a7791      # R-Car M2-W
-             - renesas,gpio-r8a7792      # R-Car V2H
-             - renesas,gpio-r8a7793      # R-Car M2-N
-             - renesas,gpio-r8a7794      # R-Car E2
-         - const: renesas,rcar-gen2-gpio # R-Car Gen2 or RZ/G1
+          - enum:
+              - renesas,gpio-r8a7742      # RZ/G1H
+              - renesas,gpio-r8a7743      # RZ/G1M
+              - renesas,gpio-r8a7744      # RZ/G1N
+              - renesas,gpio-r8a7745      # RZ/G1E
+              - renesas,gpio-r8a77470     # RZ/G1C
+              - renesas,gpio-r8a7790      # R-Car H2
+              - renesas,gpio-r8a7791      # R-Car M2-W
+              - renesas,gpio-r8a7792      # R-Car V2H
+              - renesas,gpio-r8a7793      # R-Car M2-N
+              - renesas,gpio-r8a7794      # R-Car E2
+          - const: renesas,rcar-gen2-gpio # R-Car Gen2 or RZ/G1
 
       - items:
-         - enum:
-             - renesas,gpio-r8a774a1     # RZ/G2M
-             - renesas,gpio-r8a774b1     # RZ/G2N
-             - renesas,gpio-r8a774c0     # RZ/G2E
-             - renesas,gpio-r8a7795      # R-Car H3
-             - renesas,gpio-r8a7796      # R-Car M3-W
-             - renesas,gpio-r8a77961     # R-Car M3-W+
-             - renesas,gpio-r8a77965     # R-Car M3-N
-             - renesas,gpio-r8a77970     # R-Car V3M
-             - renesas,gpio-r8a77980     # R-Car V3H
-             - renesas,gpio-r8a77990     # R-Car E3
-             - renesas,gpio-r8a77995     # R-Car D3
-         - const: renesas,rcar-gen3-gpio # R-Car Gen3 or RZ/G2
+          - enum:
+              - renesas,gpio-r8a774a1     # RZ/G2M
+              - renesas,gpio-r8a774b1     # RZ/G2N
+              - renesas,gpio-r8a774c0     # RZ/G2E
+              - renesas,gpio-r8a7795      # R-Car H3
+              - renesas,gpio-r8a7796      # R-Car M3-W
+              - renesas,gpio-r8a77961     # R-Car M3-W+
+              - renesas,gpio-r8a77965     # R-Car M3-N
+              - renesas,gpio-r8a77970     # R-Car V3M
+              - renesas,gpio-r8a77980     # R-Car V3H
+              - renesas,gpio-r8a77990     # R-Car E3
+              - renesas,gpio-r8a77995     # R-Car D3
+          - const: renesas,rcar-gen3-gpio # R-Car Gen3 or RZ/G2
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
index e1ac6ff5a230..4843df1ddbb6 100644
--- a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
+++ b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
@@ -26,7 +26,8 @@ properties:
       - description: AXI/master interface clock
       - description: GPU core clock
       - description: Shader clock (only required if GPU has feature PIPE_3D)
-      - description: AHB/slave interface clock (only required if GPU can gate slave interface independently)
+      - description: AHB/slave interface clock (only required if GPU can gate 
+          slave interface independently)
     minItems: 1
     maxItems: 4
 
diff --git a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
index af35b77053df..7898b9dba5a5 100644
--- a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
+++ b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
@@ -19,7 +19,7 @@ description: |+
 properties:
   compatible:
     enum:
-        - adi,axi-fan-control-1.00.a
+      - adi,axi-fan-control-1.00.a
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/i2c/i2c-imx.yaml b/Documentation/devicetree/bindings/i2c/i2c-imx.yaml
index 869f2ae3d5b3..810536953177 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-imx.yaml
+++ b/Documentation/devicetree/bindings/i2c/i2c-imx.yaml
@@ -20,22 +20,22 @@ properties:
           - const: fsl,imx1-i2c
       - items:
           - enum:
-            - fsl,imx25-i2c
-            - fsl,imx27-i2c
-            - fsl,imx31-i2c
-            - fsl,imx50-i2c
-            - fsl,imx51-i2c
-            - fsl,imx53-i2c
-            - fsl,imx6q-i2c
-            - fsl,imx6sl-i2c
-            - fsl,imx6sx-i2c
-            - fsl,imx6sll-i2c
-            - fsl,imx6ul-i2c
-            - fsl,imx7s-i2c
-            - fsl,imx8mq-i2c
-            - fsl,imx8mm-i2c
-            - fsl,imx8mn-i2c
-            - fsl,imx8mp-i2c
+              - fsl,imx25-i2c
+              - fsl,imx27-i2c
+              - fsl,imx31-i2c
+              - fsl,imx50-i2c
+              - fsl,imx51-i2c
+              - fsl,imx53-i2c
+              - fsl,imx6q-i2c
+              - fsl,imx6sl-i2c
+              - fsl,imx6sx-i2c
+              - fsl,imx6sll-i2c
+              - fsl,imx6ul-i2c
+              - fsl,imx7s-i2c
+              - fsl,imx8mq-i2c
+              - fsl,imx8mm-i2c
+              - fsl,imx8mn-i2c
+              - fsl,imx8mp-i2c
           - const: fsl,imx21-i2c
 
   reg:
diff --git a/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml b/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml
index da6e8bdc4037..015885dd02d3 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml
+++ b/Documentation/devicetree/bindings/i2c/i2c-pxa.yaml
@@ -16,8 +16,8 @@ allOf:
         required:
           - mrvl,i2c-polling
     then:
-        required:
-          - interrupts
+      required:
+        - interrupts
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
index 5117ad68a584..cbb8819d7069 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
@@ -53,10 +53,10 @@ properties:
 
   standby-gpios:
     description:
-       Must be the device tree identifier of the STBY pin. This pin is used
-       to place the AD7606 into one of two power-down modes, Standby mode or
-       Shutdown mode. As the line is active low, it should be marked
-       GPIO_ACTIVE_LOW.
+      Must be the device tree identifier of the STBY pin. This pin is used
+      to place the AD7606 into one of two power-down modes, Standby mode or
+      Shutdown mode. As the line is active low, it should be marked
+      GPIO_ACTIVE_LOW.
     maxItems: 1
 
   adi,first-data-gpios:
diff --git a/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml b/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml
index a0ebb4680140..cccd3033a55b 100644
--- a/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/maxim,max1238.yaml
@@ -10,7 +10,7 @@ maintainers:
   - Jonathan Cameron <jic23@kernel.org>
 
 description: |
-   Family of simple ADCs with i2c inteface and internal references.
+  Family of simple ADCs with i2c inteface and internal references.
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
index e6263b617941..a6ac289d98da 100644
--- a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.yaml
@@ -24,11 +24,11 @@ properties:
           - const: qcom,spmi-adc-rev2
 
       - items:
-        - enum:
-          - qcom,spmi-vadc
-          - qcom,spmi-adc5
-          - qcom,spmi-adc-rev2
-          - qcom,spmi-adc7
+          - enum:
+              - qcom,spmi-vadc
+              - qcom,spmi-adc5
+              - qcom,spmi-adc-rev2
+              - qcom,spmi-adc7
 
   reg:
     description: VADC base address in the SPMI PMIC register map
@@ -101,12 +101,11 @@ patternProperties:
           - $ref: /schemas/types.yaml#/definitions/uint32-array
         oneOf:
           - items:
-            - const: 1
-            - enum: [ 1, 3, 4, 6, 20, 8, 10 ]
-
+              - const: 1
+              - enum: [ 1, 3, 4, 6, 20, 8, 10 ]
           - items:
-            - const: 10
-            - const: 81
+              - const: 10
+              - const: 81
 
       qcom,ratiometric:
         description: |
diff --git a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.yaml b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.yaml
index bcff82a423bc..1bb76197787b 100644
--- a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.yaml
@@ -17,10 +17,10 @@ properties:
       - const: rockchip,rk3399-saradc
       - items:
           - enum:
-            - rockchip,px30-saradc
-            - rockchip,rk3308-saradc
-            - rockchip,rk3328-saradc
-            - rockchip,rv1108-saradc
+              - rockchip,px30-saradc
+              - rockchip,rk3308-saradc
+              - rockchip,rk3328-saradc
+              - rockchip,rv1108-saradc
           - const: rockchip,rk3399-saradc
 
   reg:
diff --git a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
index 1c6d49685e9f..5342360e96b1 100644
--- a/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
+++ b/Documentation/devicetree/bindings/iio/amplifiers/adi,hmc425a.yaml
@@ -7,8 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: HMC425A 6-bit Digital Step Attenuator
 
 maintainers:
-- Michael Hennerich <michael.hennerich@analog.com>
-- Beniamin Bia <beniamin.bia@analog.com>
+  - Michael Hennerich <michael.hennerich@analog.com>
+  - Beniamin Bia <beniamin.bia@analog.com>
 
 description: |
   Digital Step Attenuator IIO device with gpio interface.
diff --git a/Documentation/devicetree/bindings/iio/chemical/atlas,sensor.yaml b/Documentation/devicetree/bindings/iio/chemical/atlas,sensor.yaml
index 69e8931e0ae8..9a89b34bdd8f 100644
--- a/Documentation/devicetree/bindings/iio/chemical/atlas,sensor.yaml
+++ b/Documentation/devicetree/bindings/iio/chemical/atlas,sensor.yaml
@@ -31,10 +31,10 @@ properties:
       - atlas,co2-ezo
 
   reg:
-     maxItems: 1
+    maxItems: 1
 
   interrupts:
-     maxItems: 1
+    maxItems: 1
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5770r.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5770r.yaml
index 58d81ca43460..82424e06be27 100644
--- a/Documentation/devicetree/bindings/iio/dac/adi,ad5770r.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5770r.yaml
@@ -61,17 +61,17 @@ properties:
         const: 0
 
       adi,range-microamp:
-          description: Output range of the channel.
-          oneOf:
-            - items:
-                - const: 0
-                - const: 300000
-            - items:
-                - const: -60000
-                - const: 0
-            - items:
-                - const: -60000
-                - const: 300000
+        description: Output range of the channel.
+        oneOf:
+          - items:
+              - const: 0
+              - const: 300000
+          - items:
+              - const: -60000
+              - const: 0
+          - items:
+              - const: -60000
+              - const: 300000
 
   channel@1:
     description: Represents an external channel which are
@@ -84,10 +84,10 @@ properties:
         const: 1
 
       adi,range-microamp:
-          description: Output range of the channel.
-          items:
-            - const: 0
-            - enum: [ 140000, 250000 ]
+        description: Output range of the channel.
+        items:
+          - const: 0
+          - enum: [140000, 250000]
 
   channel@2:
     description: Represents an external channel which are
@@ -100,10 +100,10 @@ properties:
         const: 2
 
       adi,range-microamp:
-          description: Output range of the channel.
-          items:
-            - const: 0
-            - enum: [ 55000, 150000 ]
+        description: Output range of the channel.
+        items:
+          - const: 0
+          - enum: [55000, 150000]
 
 patternProperties:
   "^channel@([3-5])$":
@@ -116,19 +116,19 @@ patternProperties:
         maximum: 5
 
       adi,range-microamp:
-          description: Output range of the channel.
-          items:
-            - const: 0
-            - enum: [ 45000, 100000 ]
+        description: Output range of the channel.
+        items:
+          - const: 0
+          - enum: [45000, 100000]
 
 required:
-- reg
-- channel@0
-- channel@1
-- channel@2
-- channel@3
-- channel@4
-- channel@5
+  - reg
+  - channel@0
+  - channel@1
+  - channel@2
+  - channel@3
+  - channel@4
+  - channel@5
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/iio/light/vishay,vcnl4000.yaml b/Documentation/devicetree/bindings/iio/light/vishay,vcnl4000.yaml
index da8f2e872535..58887a4f9c15 100644
--- a/Documentation/devicetree/bindings/iio/light/vishay,vcnl4000.yaml
+++ b/Documentation/devicetree/bindings/iio/light/vishay,vcnl4000.yaml
@@ -36,15 +36,15 @@ required:
 additionalProperties: false
 
 examples:
-- |
-  i2c {
-      #address-cells = <1>;
-      #size-cells = <0>;
-
-      light-sensor@51 {
-              compatible = "vishay,vcnl4200";
-              reg = <0x51>;
-              proximity-near-level = <220>;
-      };
-  };
+  - |
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        light-sensor@51 {
+            compatible = "vishay,vcnl4200";
+            reg = <0x51>;
+            proximity-near-level = <220>;
+        };
+    };
 ...
diff --git a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
index f4393bfbf355..f0b336ac39c9 100644
--- a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
+++ b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
@@ -13,15 +13,15 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - asahi-kasei,ak8975
-        - asahi-kasei,ak8963
-        - asahi-kasei,ak09911
-        - asahi-kasei,ak09912
+          - asahi-kasei,ak8975
+          - asahi-kasei,ak8963
+          - asahi-kasei,ak09911
+          - asahi-kasei,ak09912
       - enum:
-        - ak8975
-        - ak8963
-        - ak09911
-        - ak09912
+          - ak8975
+          - ak8963
+          - ak09911
+          - ak09912
         deprecated: true
 
   reg:
diff --git a/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml b/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml
index 4190253336ec..51dba64037f6 100644
--- a/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml
+++ b/Documentation/devicetree/bindings/iio/proximity/vishay,vcnl3020.yaml
@@ -39,8 +39,8 @@ properties:
     description:
       The driver current for the LED used in proximity sensing.
     enum: [0, 10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000,
-          100000, 110000, 120000, 130000, 140000, 150000, 160000, 170000,
-          180000, 190000, 200000]
+           100000, 110000, 120000, 130000, 140000, 150000, 160000, 170000,
+           180000, 190000, 200000]
     default: 20000
 
 required:
diff --git a/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
index 40ccbe7b5c13..0f79d9a01c49 100644
--- a/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
+++ b/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml
@@ -307,7 +307,7 @@ patternProperties:
           mode.
         $ref: /schemas/types.yaml#/definitions/uint32
         enum: [0, 250, 500, 1000, 5000, 10000, 25000, 50000, 100000, 250000,
-          500000, 1000000]
+               500000, 1000000]
 
       adi,custom-thermistor:
         description:
diff --git a/Documentation/devicetree/bindings/input/imx-keypad.yaml b/Documentation/devicetree/bindings/input/imx-keypad.yaml
index 7432c6e8cf3a..f21db81206b4 100644
--- a/Documentation/devicetree/bindings/input/imx-keypad.yaml
+++ b/Documentation/devicetree/bindings/input/imx-keypad.yaml
@@ -24,19 +24,19 @@ properties:
       - const: fsl,imx21-kpp
       - items:
           - enum:
-            - fsl,imx25-kpp
-            - fsl,imx27-kpp
-            - fsl,imx31-kpp
-            - fsl,imx35-kpp
-            - fsl,imx51-kpp
-            - fsl,imx53-kpp
-            - fsl,imx50-kpp
-            - fsl,imx6q-kpp
-            - fsl,imx6sx-kpp
-            - fsl,imx6sl-kpp
-            - fsl,imx6sll-kpp
-            - fsl,imx6ul-kpp
-            - fsl,imx7d-kpp
+              - fsl,imx25-kpp
+              - fsl,imx27-kpp
+              - fsl,imx31-kpp
+              - fsl,imx35-kpp
+              - fsl,imx51-kpp
+              - fsl,imx53-kpp
+              - fsl,imx50-kpp
+              - fsl,imx6q-kpp
+              - fsl,imx6sx-kpp
+              - fsl,imx6sl-kpp
+              - fsl,imx6sll-kpp
+              - fsl,imx6ul-kpp
+              - fsl,imx7d-kpp
           - const: fsl,imx21-kpp
 
   reg:
diff --git a/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml b/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml
index 8c73e5264312..3225c8d1fdaf 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/cypress,cy8ctma140.yaml
@@ -51,7 +51,7 @@ required:
   - touchscreen-max-pressure
 
 examples:
-- |
+  - |
     #include <dt-bindings/interrupt-controller/irq.h>
     i2c {
       #address-cells = <1>;
diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml
index 024b262a2ef7..4ce109476a0e 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.yaml
@@ -20,11 +20,11 @@ maintainers:
 allOf:
   - $ref: touchscreen.yaml#
   - if:
-     properties:
-       compatible:
-         contains:
-           enum:
-             - evervision,ev-ft5726
+      properties:
+        compatible:
+          contains:
+            enum:
+              - evervision,ev-ft5726
 
     then:
       properties:
diff --git a/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml b/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
index e81cfa56f25a..da5b0d87e16d 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
@@ -35,9 +35,8 @@ properties:
     maxItems: 1
 
   irq-gpios:
-    description: GPIO pin used for IRQ.
-                 The driver uses the interrupt gpio pin as
-                 output to reset the device.
+    description: GPIO pin used for IRQ. The driver uses the interrupt gpio pin
+      as output to reset the device.
     maxItems: 1
 
   reset-gpios:
diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
index d7dac16a3960..36dc7b56a453 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
@@ -33,8 +33,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/uint32
 
   touchscreen-min-pressure:
-    description: minimum pressure on the touchscreen to be achieved in order for the
-                 touchscreen driver to report a touch event.
+    description: minimum pressure on the touchscreen to be achieved in order
+      for the touchscreen driver to report a touch event.
     $ref: /schemas/types.yaml#/definitions/uint32
 
   touchscreen-fuzz-x:
@@ -46,13 +46,13 @@ properties:
     $ref: /schemas/types.yaml#/definitions/uint32
 
   touchscreen-fuzz-pressure:
-    description: pressure noise value of the absolute input device (arbitrary range
-                 dependent on the controller)
+    description: pressure noise value of the absolute input device (arbitrary
+      range dependent on the controller)
     $ref: /schemas/types.yaml#/definitions/uint32
 
   touchscreen-average-samples:
-    description: Number of data samples which are averaged for each read (valid values
-                 dependent on the controller)
+    description: Number of data samples which are averaged for each read (valid
+      values dependent on the controller)
     $ref: /schemas/types.yaml#/definitions/uint32
 
   touchscreen-inverted-x:
diff --git a/Documentation/devicetree/bindings/interconnect/fsl,imx8m-noc.yaml b/Documentation/devicetree/bindings/interconnect/fsl,imx8m-noc.yaml
index ff09550ad959..a8873739d61a 100644
--- a/Documentation/devicetree/bindings/interconnect/fsl,imx8m-noc.yaml
+++ b/Documentation/devicetree/bindings/interconnect/fsl,imx8m-noc.yaml
@@ -25,17 +25,17 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - fsl,imx8mn-nic
-          - fsl,imx8mm-nic
-          - fsl,imx8mq-nic
-        - const: fsl,imx8m-nic
+          - enum:
+              - fsl,imx8mn-nic
+              - fsl,imx8mm-nic
+              - fsl,imx8mq-nic
+          - const: fsl,imx8m-nic
       - items:
-        - enum:
-          - fsl,imx8mn-noc
-          - fsl,imx8mm-noc
-          - fsl,imx8mq-noc
-        - const: fsl,imx8m-noc
+          - enum:
+              - fsl,imx8mn-noc
+              - fsl,imx8mm-noc
+              - fsl,imx8mq-noc
+          - const: fsl,imx8m-noc
       - const: fsl,imx8m-nic
 
   reg:
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,sc7180.yaml b/Documentation/devicetree/bindings/interconnect/qcom,sc7180.yaml
index d01bac80d416..8659048f92a7 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,sc7180.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,sc7180.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/interconnect/qcom,sc7180.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title:  Qualcomm SC7180 Network-On-Chip Interconnect
+title: Qualcomm SC7180 Network-On-Chip Interconnect
 
 maintainers:
   - Odelu Kukatla <okukatla@codeaurora.org>
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,sdm845.yaml b/Documentation/devicetree/bindings/interconnect/qcom,sdm845.yaml
index 74536747b51d..dab17c0716ce 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,sdm845.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,sdm845.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/interconnect/qcom,sdm845.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title:  Qualcomm SDM845 Network-On-Chip Interconnect
+title: Qualcomm SDM845 Network-On-Chip Interconnect
 
 maintainers:
   - Georgi Djakov <georgi.djakov@linaro.org>
diff --git a/Documentation/devicetree/bindings/interrupt-controller/arm,gic.yaml b/Documentation/devicetree/bindings/interrupt-controller/arm,gic.yaml
index 96f8803ff4e6..06889963dfb7 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/arm,gic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/arm,gic.yaml
@@ -42,8 +42,8 @@ properties:
       - items:
           - const: arm,gic-400
           - enum:
-             - arm,cortex-a15-gic
-             - arm,cortex-a7-gic
+              - arm,cortex-a15-gic
+              - arm,cortex-a7-gic
 
       - items:
           - const: arm,arm1176jzf-devchip-gic
diff --git a/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml b/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
index 28b27e1a6e9d..02a3cf470518 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/ingenic,intc.yaml
@@ -16,20 +16,20 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-intc
-        - ingenic,jz4760-intc
-        - ingenic,jz4780-intc
+          - ingenic,jz4740-intc
+          - ingenic,jz4760-intc
+          - ingenic,jz4780-intc
       - items:
-        - enum:
-          - ingenic,jz4775-intc
-          - ingenic,jz4770-intc
-        - const: ingenic,jz4760-intc
+          - enum:
+              - ingenic,jz4775-intc
+              - ingenic,jz4770-intc
+          - const: ingenic,jz4760-intc
       - items:
-        - const: ingenic,x1000-intc
-        - const: ingenic,jz4780-intc
+          - const: ingenic,x1000-intc
+          - const: ingenic,jz4780-intc
       - items:
-        - const: ingenic,jz4725b-intc
-        - const: ingenic,jz4740-intc
+          - const: ingenic,jz4725b-intc
+          - const: ingenic,jz4740-intc
 
   "#interrupt-cells":
     const: 1
diff --git a/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml b/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
index 32e0896c6bc1..47938e372987 100644
--- a/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/qcom-wled.yaml
@@ -79,7 +79,8 @@ properties:
     description: |
       kHz; switching frequency.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [ 600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371, 1600, 1920, 2400, 3200, 4800, 9600 ]
+    enum: [ 600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371, 1600, 1920, 
+            2400, 3200, 4800, 9600 ]
 
   qcom,ovp:
     description: |
diff --git a/Documentation/devicetree/bindings/mailbox/fsl,mu.yaml b/Documentation/devicetree/bindings/mailbox/fsl,mu.yaml
index 3b35eb5ac3f9..8a3470b64d06 100644
--- a/Documentation/devicetree/bindings/mailbox/fsl,mu.yaml
+++ b/Documentation/devicetree/bindings/mailbox/fsl,mu.yaml
@@ -29,12 +29,12 @@ properties:
       - const: fsl,imx8-mu-scu
       - items:
           - enum:
-            - fsl,imx7s-mu
-            - fsl,imx8mq-mu
-            - fsl,imx8mm-mu
-            - fsl,imx8mn-mu
-            - fsl,imx8mp-mu
-            - fsl,imx8qxp-mu
+              - fsl,imx7s-mu
+              - fsl,imx8mq-mu
+              - fsl,imx8mm-mu
+              - fsl,imx8mn-mu
+              - fsl,imx8mp-mu
+              - fsl,imx8qxp-mu
           - const: fsl,imx6sx-mu
       - description: To communicate with i.MX8 SCU with fast IPC
         items:
diff --git a/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
index 4ac2123d9193..168beeb7e9f7 100644
--- a/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
+++ b/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
@@ -24,7 +24,7 @@ properties:
   compatible:
     items:
       - enum:
-        - qcom,sm8250-ipcc
+          - qcom,sm8250-ipcc
       - const: qcom,ipcc
 
   reg:
diff --git a/Documentation/devicetree/bindings/media/allwinner,sun8i-a83t-de2-rotate.yaml b/Documentation/devicetree/bindings/media/allwinner,sun8i-a83t-de2-rotate.yaml
index 75196d11da58..a258832d520c 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun8i-a83t-de2-rotate.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun8i-a83t-de2-rotate.yaml
@@ -20,8 +20,8 @@ properties:
     oneOf:
       - const: allwinner,sun8i-a83t-de2-rotate
       - items:
-        - const: allwinner,sun50i-a64-de2-rotate
-        - const: allwinner,sun8i-a83t-de2-rotate
+          - const: allwinner,sun50i-a64-de2-rotate
+          - const: allwinner,sun8i-a83t-de2-rotate
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/media/allwinner,sun8i-h3-deinterlace.yaml b/Documentation/devicetree/bindings/media/allwinner,sun8i-h3-deinterlace.yaml
index 8707df613f6c..6a56214c6cfd 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun8i-h3-deinterlace.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun8i-h3-deinterlace.yaml
@@ -20,8 +20,8 @@ properties:
     oneOf:
       - const: allwinner,sun8i-h3-deinterlace
       - items:
-        - const: allwinner,sun50i-a64-deinterlace
-        - const: allwinner,sun8i-h3-deinterlace
+          - const: allwinner,sun50i-a64-deinterlace
+          - const: allwinner,sun8i-h3-deinterlace
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.yaml b/Documentation/devicetree/bindings/media/i2c/adv7180.yaml
index e0084b272b25..d8c54f9d9506 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7180.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/adv7180.yaml
@@ -17,17 +17,17 @@ properties:
   compatible:
     items:
       - enum:
-        - adi,adv7180
-        - adi,adv7180cp
-        - adi,adv7180st
-        - adi,adv7182
-        - adi,adv7280
-        - adi,adv7280-m
-        - adi,adv7281
-        - adi,adv7281-m
-        - adi,adv7281-ma
-        - adi,adv7282
-        - adi,adv7282-m
+          - adi,adv7180
+          - adi,adv7180cp
+          - adi,adv7180st
+          - adi,adv7182
+          - adi,adv7280
+          - adi,adv7280-m
+          - adi,adv7281
+          - adi,adv7281-m
+          - adi,adv7281-ma
+          - adi,adv7282
+          - adi,adv7282-m
 
   reg:
     maxItems: 1
@@ -58,17 +58,16 @@ allOf:
   - if:
       properties:
         compatible:
-          items:
-            - enum:
-              - adi,adv7180
-              - adi,adv7182
-              - adi,adv7280
-              - adi,adv7280-m
-              - adi,adv7281
-              - adi,adv7281-m
-              - adi,adv7281-ma
-              - adi,adv7282
-              - adi,adv7282-m
+          enum:
+            - adi,adv7180
+            - adi,adv7182
+            - adi,adv7280
+            - adi,adv7280-m
+            - adi,adv7281
+            - adi,adv7281-m
+            - adi,adv7281-ma
+            - adi,adv7282
+            - adi,adv7282-m
     then:
       required:
         - port
diff --git a/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml b/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml
index 5ad4b8c356cf..107c862a7fc7 100644
--- a/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/imi,rdacm2x-gmsl.yaml
@@ -5,7 +5,7 @@
 $id: http://devicetree.org/schemas/media/i2c/imi,rdacm2x-gmsl.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title:  IMI D&D RDACM20 and RDACM21 Automotive Camera Platforms
+title: IMI D&D RDACM20 and RDACM21 Automotive Camera Platforms
 
 maintainers:
   - Jacopo Mondi <jacopo+renesas@jmondi.org>
diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.yaml b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.yaml
index e7b543159d15..9ea827092fdd 100644
--- a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.yaml
@@ -49,7 +49,7 @@ properties:
   gpio-controller: true
 
   '#gpio-cells':
-      const: 2
+    const: 2
 
   ports:
     type: object
diff --git a/Documentation/devicetree/bindings/media/i2c/ov8856.yaml b/Documentation/devicetree/bindings/media/i2c/ov8856.yaml
index 1956b2a32bf4..cde85553fd01 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov8856.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ov8856.yaml
@@ -138,4 +138,5 @@ examples:
             };
         };
     };
-...
\ No newline at end of file
+...
+
diff --git a/Documentation/devicetree/bindings/media/renesas,csi2.yaml b/Documentation/devicetree/bindings/media/renesas,csi2.yaml
index c9e068231d4b..6d282585d0b9 100644
--- a/Documentation/devicetree/bindings/media/renesas,csi2.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,csi2.yaml
@@ -19,15 +19,15 @@ properties:
   compatible:
     items:
       - enum:
-        - renesas,r8a774a1-csi2 # RZ/G2M
-        - renesas,r8a774b1-csi2 # RZ/G2N
-        - renesas,r8a774c0-csi2 # RZ/G2E
-        - renesas,r8a7795-csi2  # R-Car H3
-        - renesas,r8a7796-csi2  # R-Car M3-W
-        - renesas,r8a77965-csi2 # R-Car M3-N
-        - renesas,r8a77970-csi2 # R-Car V3M
-        - renesas,r8a77980-csi2 # R-Car V3H
-        - renesas,r8a77990-csi2 # R-Car E3
+          - renesas,r8a774a1-csi2 # RZ/G2M
+          - renesas,r8a774b1-csi2 # RZ/G2N
+          - renesas,r8a774c0-csi2 # RZ/G2E
+          - renesas,r8a7795-csi2  # R-Car H3
+          - renesas,r8a7796-csi2  # R-Car M3-W
+          - renesas,r8a77965-csi2 # R-Car M3-N
+          - renesas,r8a77970-csi2 # R-Car V3M
+          - renesas,r8a77980-csi2 # R-Car V3H
+          - renesas,r8a77990-csi2 # R-Car E3
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/media/rockchip-vpu.yaml b/Documentation/devicetree/bindings/media/rockchip-vpu.yaml
index 2b629456d75f..c81dbc3e8960 100644
--- a/Documentation/devicetree/bindings/media/rockchip-vpu.yaml
+++ b/Documentation/devicetree/bindings/media/rockchip-vpu.yaml
@@ -31,8 +31,8 @@ properties:
     oneOf:
       - const: vdpu
       - items:
-        - const: vepu
-        - const: vdpu
+          - const: vepu
+          - const: vdpu
 
   clocks:
     maxItems: 2
diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.yaml b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.yaml
index 7b9407c0520e..2961a5b6872f 100644
--- a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.yaml
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.yaml
@@ -25,7 +25,7 @@ properties:
   compatible:
     items:
       - enum:
-        - xlnx,mipi-csi2-rx-subsystem-5.0
+          - xlnx,mipi-csi2-rx-subsystem-5.0
 
   reg:
     maxItems: 1
@@ -65,13 +65,12 @@ properties:
       0x2d - RAW14
       0x2e - RAW16
       0x2f - RAW20
-    allOf:
-      - $ref: /schemas/types.yaml#/definitions/uint32
-      - anyOf:
-        - minimum: 0x1e
-        - maximum: 0x24
-        - minimum: 0x28
-        - maximum: 0x2f
+    $ref: /schemas/types.yaml#/definitions/uint32
+    oneOf:
+      - minimum: 0x1e
+        maximum: 0x24
+      - minimum: 0x28
+        maximum: 0x2f
 
   xlnx,vfb:
     type: boolean
diff --git a/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml b/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml
index dee5131c0361..68484136a510 100644
--- a/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/fsl/mmdc.yaml
@@ -15,12 +15,12 @@ properties:
       - const: fsl,imx6q-mmdc
       - items:
           - enum:
-            - fsl,imx6qp-mmdc
-            - fsl,imx6sl-mmdc
-            - fsl,imx6sll-mmdc
-            - fsl,imx6sx-mmdc
-            - fsl,imx6ul-mmdc
-            - fsl,imx7ulp-mmdc
+              - fsl,imx6qp-mmdc
+              - fsl,imx6sl-mmdc
+              - fsl,imx6sll-mmdc
+              - fsl,imx6sx-mmdc
+              - fsl,imx6ul-mmdc
+              - fsl,imx7ulp-mmdc
           - const: fsl,imx6q-mmdc
 
   reg:
diff --git a/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml b/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml
index 17ba45a6c260..fe0ce191a851 100644
--- a/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/ingenic,nemc.yaml
@@ -16,11 +16,11 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-nemc
-        - ingenic,jz4780-nemc
+          - ingenic,jz4740-nemc
+          - ingenic,jz4780-nemc
       - items:
-        - const: ingenic,jz4725b-nemc
-        - const: ingenic,jz4740-nemc
+          - const: ingenic,jz4725b-nemc
+          - const: ingenic,jz4740-nemc
 
   "#address-cells":
     const: 2
diff --git a/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml b/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml
index 660005601a7f..7bfe120e14c3 100644
--- a/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/renesas,rpc-if.yaml
@@ -26,10 +26,10 @@ properties:
   compatible:
     items:
       - enum:
-        - renesas,r8a77970-rpc-if       # R-Car V3M
-        - renesas,r8a77980-rpc-if       # R-Car V3H
-        - renesas,r8a77995-rpc-if       # R-Car D3
-      - const: renesas,rcar-gen3-rpc-if # a generic R-Car gen3 device
+          - renesas,r8a77970-rpc-if       # R-Car V3M
+          - renesas,r8a77980-rpc-if       # R-Car V3H
+          - renesas,r8a77995-rpc-if       # R-Car D3
+      - const: renesas,rcar-gen3-rpc-if   # a generic R-Car gen3 device
 
   reg:
     items:
diff --git a/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml b/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
index a5531f6caf12..499c62c04daa 100644
--- a/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
+++ b/Documentation/devicetree/bindings/mfd/cirrus,madera.yaml
@@ -98,11 +98,11 @@ allOf:
           description:
             Databus power supply.
   - if:
-     properties:
-       compatible:
-         contains:
-           enum:
-             - cirrus,cs47l15
+      properties:
+        compatible:
+          contains:
+            enum:
+              - cirrus,cs47l15
     then:
       required:
         - MICVDD-supply
@@ -174,24 +174,24 @@ properties:
         "mclk3" For the clock supplied on MCLK3.
     oneOf:
       - items:
-        - const: mclk1
+          - const: mclk1
       - items:
-        - const: mclk2
+          - const: mclk2
       - items:
-        - const: mclk3
+          - const: mclk3
       - items:
-        - const: mclk1
-        - const: mclk2
+          - const: mclk1
+          - const: mclk2
       - items:
-        - const: mclk1
-        - const: mclk3
+          - const: mclk1
+          - const: mclk3
       - items:
-        - const: mclk2
-        - const: mclk3
+          - const: mclk2
+          - const: mclk3
       - items:
-        - const: mclk1
-        - const: mclk2
-        - const: mclk3
+          - const: mclk1
+          - const: mclk2
+          - const: mclk3
 
   AVDD-supply:
     description:
diff --git a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
index 487a8445722e..7fd232699f16 100644
--- a/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
+++ b/Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml
@@ -89,8 +89,8 @@ properties:
             description: Values of resistors for divider on raw ADC input
             maxItems: 2
             items:
-             minimum: 1000
-             maximum: 1000000
+              minimum: 1000
+              maximum: 1000000
 
           gw,voltage-offset-microvolt:
             description: |
diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
index dd995d7dc1a6..305123e74a58 100644
--- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
@@ -113,8 +113,8 @@ properties:
             maxItems: 1
 
           st,mask-reset:
-            description: mask reset for this regulator,
-                         the regulator configuration is maintained during pmic reset.
+            description: mask reset for this regulator, the regulator configuration
+              is maintained during pmic reset.
             $ref: /schemas/types.yaml#/definitions/flag
 
           regulator-name: true
@@ -135,8 +135,8 @@ properties:
             maxItems: 1
 
           st,mask-reset:
-            description: mask reset for this regulator,
-                         the regulator configuration is maintained during pmic reset.
+            description: mask reset for this regulator, the regulator configuration
+              is maintained during pmic reset.
             $ref: /schemas/types.yaml#/definitions/flag
 
           regulator-name: true
@@ -154,8 +154,8 @@ properties:
             maxItems: 1
 
           st,mask-reset:
-            description: mask reset for this regulator,
-                         the regulator configuration is maintained during pmic reset.
+            description: mask reset for this regulator, the regulator configuration
+              is maintained during pmic reset.
             $ref: /schemas/types.yaml#/definitions/flag
 
           regulator-name: true
@@ -172,8 +172,8 @@ properties:
             maxItems: 1
 
           st,mask-reset:
-            description: mask reset for this regulator,
-                         the regulator configuration is maintained during pmic reset.
+            description: mask reset for this regulator, the regulator configuration
+              is maintained during pmic reset.
             $ref: /schemas/types.yaml#/definitions/flag
 
           regulator-name: true
@@ -198,8 +198,8 @@ properties:
             maxItems: 1
 
           st,mask-reset:
-            description: mask reset for this regulator,
-                         the regulator configuration is maintained during pmic reset.
+            description: mask reset for this regulator, the regulator configuration
+              is maintained during pmic reset.
             $ref: /schemas/types.yaml#/definitions/flag
 
           regulator-name: true
@@ -220,8 +220,8 @@ properties:
             maxItems: 1
 
           st,mask-reset:
-            description: mask reset for this regulator,
-                         the regulator configuration is maintained during pmic reset.
+            description: mask reset for this regulator, the regulator configuration
+              is maintained during pmic reset.
             $ref: /schemas/types.yaml#/definitions/flag
 
           regulator-name: true
diff --git a/Documentation/devicetree/bindings/mfd/ti,j721e-system-controller.yaml b/Documentation/devicetree/bindings/mfd/ti,j721e-system-controller.yaml
index 03d0a232c75e..c8fd5d3e3071 100644
--- a/Documentation/devicetree/bindings/mfd/ti,j721e-system-controller.yaml
+++ b/Documentation/devicetree/bindings/mfd/ti,j721e-system-controller.yaml
@@ -24,12 +24,11 @@ maintainers:
 
 properties:
   compatible:
-    anyOf:
-      - items:
-        - enum:
-           - ti,j721e-system-controller
-        - const: syscon
-        - const: simple-mfd
+    items:
+      - enum:
+          - ti,j721e-system-controller
+      - const: syscon
+      - const: simple-mfd
 
   "#address-cells":
     const: 1
diff --git a/Documentation/devicetree/bindings/mfd/wlf,arizona.yaml b/Documentation/devicetree/bindings/mfd/wlf,arizona.yaml
index 4c0106cea36d..9e762d474218 100644
--- a/Documentation/devicetree/bindings/mfd/wlf,arizona.yaml
+++ b/Documentation/devicetree/bindings/mfd/wlf,arizona.yaml
@@ -73,13 +73,13 @@ allOf:
       required:
         - DBVDD3-supply
   - if:
-     properties:
-       compatible:
-         contains:
-           enum:
-             - cirrus,cs47l24
-             - wlf,wm1831
-             - wlf,wm8997
+      properties:
+        compatible:
+          contains:
+            enum:
+              - cirrus,cs47l24
+              - wlf,wm1831
+              - wlf,wm8997
     then:
       properties:
         SPKVDD-supply:
@@ -183,12 +183,12 @@ properties:
       clock supplied on MCLK2, recommended to be an always on 32k clock.
     oneOf:
       - items:
-        - const: mclk1
+          - const: mclk1
       - items:
-        - const: mclk2
+          - const: mclk2
       - items:
-        - const: mclk1
-        - const: mclk2
+          - const: mclk1
+          - const: mclk2
 
   reset-gpios:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/mmc/amlogic,meson-mx-sdhc.yaml b/Documentation/devicetree/bindings/mmc/amlogic,meson-mx-sdhc.yaml
index 7a386a5b8fcb..0cd74c3116f8 100644
--- a/Documentation/devicetree/bindings/mmc/amlogic,meson-mx-sdhc.yaml
+++ b/Documentation/devicetree/bindings/mmc/amlogic,meson-mx-sdhc.yaml
@@ -21,9 +21,9 @@ properties:
   compatible:
     items:
       - enum:
-        - amlogic,meson8-sdhc
-        - amlogic,meson8b-sdhc
-        - amlogic,meson8m2-sdhc
+          - amlogic,meson8-sdhc
+          - amlogic,meson8b-sdhc
+          - amlogic,meson8m2-sdhc
       - const: amlogic,meson-mx-sdhc
 
   reg:
diff --git a/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml b/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml
index e60bfe980ab3..9b63df1c22fb 100644
--- a/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml
+++ b/Documentation/devicetree/bindings/mmc/ingenic,mmc.yaml
@@ -16,14 +16,14 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-mmc
-        - ingenic,jz4725b-mmc
-        - ingenic,jz4760-mmc
-        - ingenic,jz4780-mmc
-        - ingenic,x1000-mmc
+          - ingenic,jz4740-mmc
+          - ingenic,jz4725b-mmc
+          - ingenic,jz4760-mmc
+          - ingenic,jz4780-mmc
+          - ingenic,x1000-mmc
       - items:
-        - const: ingenic,jz4770-mmc
-        - const: ingenic,jz4760-mmc
+          - const: ingenic,jz4770-mmc
+          - const: ingenic,jz4760-mmc
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml b/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml
index e5dbc20456e5..b4c3fd40caeb 100644
--- a/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml
+++ b/Documentation/devicetree/bindings/mmc/renesas,sdhi.yaml
@@ -130,9 +130,9 @@ then:
   required:
     - clock-names
   description:
-     The internal card detection logic that exists in these controllers is
-     sectioned off to be run by a separate second clock source to allow
-     the main core clock to be turned off to save power.
+    The internal card detection logic that exists in these controllers is
+    sectioned off to be run by a separate second clock source to allow
+    the main core clock to be turned off to save power.
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml b/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml
index cb9794edff24..b32876933269 100644
--- a/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/arasan,nand-controller.yaml
@@ -14,12 +14,10 @@ maintainers:
 
 properties:
   compatible:
-    oneOf:
-      - items:
-        - enum:
+    items:
+      - enum:
           - xlnx,zynqmp-nand-controller
-        - enum:
-          - arasan,nfc-v3p10
+      - const: arasan,nfc-v3p10
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml b/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
index 354cb63feea3..3201372b7f85 100644
--- a/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/gpmi-nand.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/gpmi-nand.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title:  Freescale General-Purpose Media Interface (GPMI) binding
+title: Freescale General-Purpose Media Interface (GPMI) binding
 
 maintainers:
   - Han Xu <han.xu@nxp.com>
diff --git a/Documentation/devicetree/bindings/mtd/mxc-nand.yaml b/Documentation/devicetree/bindings/mtd/mxc-nand.yaml
index ee4d1d026fd8..73b86f2226c7 100644
--- a/Documentation/devicetree/bindings/mtd/mxc-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/mxc-nand.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/mtd/mxc-nand.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title:  Freescale's mxc_nand binding
+title: Freescale's mxc_nand binding
 
 maintainers:
   - Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml b/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
index 6ae7de15d172..28a08ff407db 100644
--- a/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/st,stm32-fmc2-nand.yaml
@@ -42,7 +42,7 @@ patternProperties:
         const: 512
 
       nand-ecc-strength:
-        enum: [1, 4 ,8 ]
+        enum: [1, 4, 8]
 
 allOf:
   - $ref: "nand-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index faea214339ca..6a1ec50ad4fd 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -85,8 +85,8 @@ patternProperties:
 
 oneOf:
   - required:
-    - ports
+      - ports
   - required:
-    - ethernet-ports
+      - ethernet-ports
 
 ...
diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index a3561276e609..8594f114f016 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -43,7 +43,7 @@ description:
 
 properties:
   compatible:
-      const: "qcom,sdm845-ipa"
+    const: "qcom,sdm845-ipa"
 
   reg:
     items:
@@ -64,7 +64,7 @@ properties:
     maxItems: 1
 
   clock-names:
-      const: core
+    const: core
 
   interrupts:
     items:
@@ -96,8 +96,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     description: State bits used in by the AP to signal the modem.
     items:
-    - description: Whether the "ipa-clock-enabled" state bit is valid
-    - description: Whether the IPA clock is enabled (if valid)
+      - description: Whether the "ipa-clock-enabled" state bit is valid
+      - description: Whether the IPA clock is enabled (if valid)
 
   qcom,smem-state-names:
     $ref: /schemas/types.yaml#/definitions/string-array
@@ -140,9 +140,9 @@ required:
 
 oneOf:
   - required:
-    - modem-init
+      - modem-init
   - required:
-    - memory-region
+      - memory-region
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
index 7d84a863b9b9..cbacc04fc9e6 100644
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
@@ -46,10 +46,10 @@ properties:
   clock-names:
     oneOf:
       - items:          # for Pro4
-        - const: gio
-        - const: ether
-        - const: ether-gb
-        - const: ether-phy
+          - const: gio
+          - const: ether
+          - const: ether-gb
+          - const: ether-phy
       - const: ether    # for others
 
   resets:
@@ -59,8 +59,8 @@ properties:
   reset-names:
     oneOf:
       - items:          # for Pro4
-        - const: gio
-        - const: ether
+          - const: gio
+          - const: ether
       - const: ether    # for others
 
   socionext,syscon-phy-mode:
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index fafa34cebdb1..e5dff66df481 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -48,11 +48,11 @@ properties:
     minItems: 3
     maxItems: 5
     items:
-        - description: GMAC main clock
-        - description: MAC TX clock
-        - description: MAC RX clock
-        - description: For MPU family, used for power mode
-        - description: For MPU family, used for PHY without quartz
+      - description: GMAC main clock
+      - description: MAC TX clock
+      - description: MAC RX clock
+      - description: For MPU family, used for power mode
+      - description: For MPU family, used for PHY without quartz
 
   clock-names:
     minItems: 3
@@ -89,7 +89,7 @@ required:
   - st,syscon
 
 examples:
- - |
+  - |
     #include <dt-bindings/interrupt-controller/arm-gic.h>
     #include <dt-bindings/clock/stm32mp1-clks.h>
     #include <dt-bindings/reset/stm32mp1-resets.h>
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index 3ea0e1290dbb..dadeb8f811c0 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -35,7 +35,7 @@ properties:
   reg:
     maxItems: 1
     description:
-       The physical base address and size of full the CPSW module IO range
+      The physical base address and size of full the CPSW module IO range
 
   '#address-cells':
     const: 1
@@ -85,36 +85,36 @@ properties:
 
     patternProperties:
       "^port@[0-9]+$":
-          type: object
-          description: CPSW external ports
-
-          allOf:
-            - $ref: ethernet-controller.yaml#
-
-          properties:
-            reg:
-              items:
-                - enum: [1, 2]
-              description: CPSW port number
-
-            phys:
-              maxItems: 1
-              description:  phandle on phy-gmii-sel PHY
-
-            label:
-              description: label associated with this port
-
-            ti,dual-emac-pvid:
-              $ref: /schemas/types.yaml#/definitions/uint32
-              minimum: 1
-              maximum: 1024
-              description:
-                Specifies default PORT VID to be used to segregate
-                ports. Default value - CPSW port number.
-
-          required:
-            - reg
-            - phys
+        type: object
+        description: CPSW external ports
+
+        allOf:
+          - $ref: ethernet-controller.yaml#
+
+        properties:
+          reg:
+            items:
+              - enum: [1, 2]
+            description: CPSW port number
+
+          phys:
+            maxItems: 1
+            description: phandle on phy-gmii-sel PHY
+
+          label:
+            description: label associated with this port
+
+          ti,dual-emac-pvid:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            minimum: 1
+            maximum: 1024
+            description:
+              Specifies default PORT VID to be used to segregate
+              ports. Default value - CPSW port number.
+
+        required:
+          - reg
+          - phys
 
   cpts:
     type: object
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 174579370a22..227270cbf892 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -55,7 +55,7 @@ properties:
   reg:
     maxItems: 1
     description:
-       The physical base address and size of full the CPSW2G NUSS IO range
+      The physical base address and size of full the CPSW2G NUSS IO range
 
   reg-names:
     items:
@@ -100,38 +100,38 @@ properties:
 
     patternProperties:
       port@1:
-       type: object
-       description: CPSW2G NUSS external ports
-
-       $ref: ethernet-controller.yaml#
-
-       properties:
-         reg:
-           items:
-             - const: 1
-           description: CPSW port number
-
-         phys:
-           maxItems: 1
-           description:  phandle on phy-gmii-sel PHY
-
-         label:
-           description: label associated with this port
-
-         ti,mac-only:
-           $ref: /schemas/types.yaml#definitions/flag
-           description:
-             Specifies the port works in mac-only mode.
-
-         ti,syscon-efuse:
-           $ref: /schemas/types.yaml#definitions/phandle-array
-           description:
-             Phandle to the system control device node which provides access
-             to efuse IO range with MAC addresses
-
-       required:
-         - reg
-         - phys
+        type: object
+        description: CPSW2G NUSS external ports
+
+        $ref: ethernet-controller.yaml#
+
+        properties:
+          reg:
+            items:
+              - const: 1
+            description: CPSW port number
+
+          phys:
+            maxItems: 1
+            description: phandle on phy-gmii-sel PHY
+
+          label:
+            description: label associated with this port
+
+          ti,mac-only:
+            $ref: /schemas/types.yaml#definitions/flag
+            description:
+              Specifies the port works in mac-only mode.
+
+          ti,syscon-efuse:
+            $ref: /schemas/types.yaml#definitions/phandle-array
+            description:
+              Phandle to the system control device node which provides access
+              to efuse IO range with MAC addresses
+
+        required:
+          - reg
+          - phys
 
     additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/nvmem/imx-ocotp.yaml b/Documentation/devicetree/bindings/nvmem/imx-ocotp.yaml
index fe9c7df78ea1..1c9d7f05f173 100644
--- a/Documentation/devicetree/bindings/nvmem/imx-ocotp.yaml
+++ b/Documentation/devicetree/bindings/nvmem/imx-ocotp.yaml
@@ -21,18 +21,18 @@ properties:
   compatible:
     items:
       - enum:
-        - fsl,imx6q-ocotp
-        - fsl,imx6sl-ocotp
-        - fsl,imx6sx-ocotp
-        - fsl,imx6ul-ocotp
-        - fsl,imx6ull-ocotp
-        - fsl,imx7d-ocotp
-        - fsl,imx6sll-ocotp
-        - fsl,imx7ulp-ocotp
-        - fsl,imx8mq-ocotp
-        - fsl,imx8mm-ocotp
-        - fsl,imx8mn-ocotp
-        - fsl,imx8mp-ocotp
+          - fsl,imx6q-ocotp
+          - fsl,imx6sl-ocotp
+          - fsl,imx6sx-ocotp
+          - fsl,imx6ul-ocotp
+          - fsl,imx6ull-ocotp
+          - fsl,imx7d-ocotp
+          - fsl,imx6sll-ocotp
+          - fsl,imx7ulp-ocotp
+          - fsl,imx8mq-ocotp
+          - fsl,imx8mm-ocotp
+          - fsl,imx8mn-ocotp
+          - fsl,imx8mp-ocotp
       - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml b/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml
index d10a0cf91ba7..59aca6d22ff9 100644
--- a/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml
+++ b/Documentation/devicetree/bindings/nvmem/qcom,qfprom.yaml
@@ -46,8 +46,8 @@ properties:
     const: 1
 
 required:
-   - compatible
-   - reg
+  - compatible
+  - reg
 
 examples:
   - |
diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
index 9e32cb43fb21..0d2557bb0bcc 100644
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
@@ -37,9 +37,9 @@ properties:
     const: 0
 
   phy-supply:
-     description:
-       Phandle to a regulator that provides power to the PHY. This
-       regulator will be managed during the PHY power on/off sequence.
+    description:
+      Phandle to a regulator that provides power to the PHY. This
+      regulator will be managed during the PHY power on/off sequence.
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/phy/phy-rockchip-inno-usb2.yaml b/Documentation/devicetree/bindings/phy/phy-rockchip-inno-usb2.yaml
index cb71561a21b4..fb29ad807b68 100644
--- a/Documentation/devicetree/bindings/phy/phy-rockchip-inno-usb2.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-rockchip-inno-usb2.yaml
@@ -100,9 +100,9 @@ properties:
           - const: linestate
           - const: otg-mux
           - items:
-            - const: otg-bvalid
-            - const: otg-id
-            - const: linestate
+              - const: otg-bvalid
+              - const: otg-id
+              - const: linestate
 
       phy-supply:
         description:
diff --git a/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
index e4cd4a1deae9..185cdea9cf81 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qmp-phy.yaml
@@ -37,7 +37,7 @@ properties:
       - description: Address and length of PHY's common serdes block.
 
   "#clock-cells":
-     enum: [ 1, 2 ]
+    enum: [ 1, 2 ]
 
   "#address-cells":
     enum: [ 1, 2 ]
@@ -65,16 +65,15 @@ properties:
 
   vdda-phy-supply:
     description:
-        Phandle to a regulator supply to PHY core block.
+      Phandle to a regulator supply to PHY core block.
 
   vdda-pll-supply:
     description:
-        Phandle to 1.8V regulator supply to PHY refclk pll block.
+      Phandle to 1.8V regulator supply to PHY refclk pll block.
 
   vddp-ref-clk-supply:
     description:
-        Phandle to a regulator supply to any specific refclk
-        pll block.
+      Phandle to a regulator supply to any specific refclk pll block.
 
 #Required nodes:
 patternProperties:
@@ -184,8 +183,8 @@ allOf:
             - description: phy common block reset.
         reset-names:
           items:
-             - const: phy
-             - const: common
+            - const: phy
+            - const: common
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
index 6e2487501457..ef8ae9f73092 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml
@@ -26,7 +26,7 @@ properties:
       - const: dp_com
 
   "#clock-cells":
-     enum: [ 1, 2 ]
+    enum: [ 1, 2 ]
 
   "#address-cells":
     enum: [ 1, 2 ]
@@ -62,16 +62,15 @@ properties:
 
   vdda-phy-supply:
     description:
-        Phandle to a regulator supply to PHY core block.
+      Phandle to a regulator supply to PHY core block.
 
   vdda-pll-supply:
     description:
-        Phandle to 1.8V regulator supply to PHY refclk pll block.
+      Phandle to 1.8V regulator supply to PHY refclk pll block.
 
   vddp-ref-clk-supply:
     description:
-        Phandle to a regulator supply to any specific refclk
-        pll block.
+      Phandle to a regulator supply to any specific refclk pll block.
 
 #Required nodes:
 patternProperties:
diff --git a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
index 9ba62dcb1e5d..ccda92859eca 100644
--- a/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
@@ -17,15 +17,15 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - qcom,ipq8074-qusb2-phy
-          - qcom,msm8996-qusb2-phy
-          - qcom,msm8998-qusb2-phy
+          - enum:
+              - qcom,ipq8074-qusb2-phy
+              - qcom,msm8996-qusb2-phy
+              - qcom,msm8998-qusb2-phy
       - items:
-        - enum:
-          - qcom,sc7180-qusb2-phy
-          - qcom,sdm845-qusb2-phy
-        - const: qcom,qusb2-v2-phy
+          - enum:
+              - qcom,sc7180-qusb2-phy
+              - qcom,sdm845-qusb2-phy
+          - const: qcom,qusb2-v2-phy
   reg:
     maxItems: 1
 
@@ -49,12 +49,12 @@ properties:
       - const: iface
 
   vdda-pll-supply:
-     description:
-       Phandle to 1.8V regulator supply to PHY refclk pll block.
+    description:
+      Phandle to 1.8V regulator supply to PHY refclk pll block.
 
   vdda-phy-dpdm-supply:
-     description:
-       Phandle to 3.1V regulator supply to Dp/Dm port signals.
+    description:
+      Phandle to 3.1V regulator supply to Dp/Dm port signals.
 
   resets:
     maxItems: 1
@@ -64,12 +64,12 @@ properties:
   nvmem-cells:
     maxItems: 1
     description:
-        Phandle to nvmem cell that contains 'HS Tx trim'
-        tuning parameter value for qusb2 phy.
+      Phandle to nvmem cell that contains 'HS Tx trim'
+      tuning parameter value for qusb2 phy.
 
   qcom,tcsr-syscon:
     description:
-        Phandle to TCSR syscon register region.
+      Phandle to TCSR syscon register region.
     $ref: /schemas/types.yaml#/definitions/phandle
 
 if:
diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml
index 86f49093b65f..a06831fd64b9 100644
--- a/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-pcie-phy.yaml
@@ -33,8 +33,8 @@ properties:
   clock-names:
     oneOf:
       - items:            # for Pro5
-        - const: gio
-        - const: link
+          - const: gio
+          - const: link
       - const: link       # for others
 
   resets:
@@ -44,8 +44,8 @@ properties:
   reset-names:
     oneOf:
       - items:            # for Pro5
-        - const: gio
-        - const: link
+          - const: gio
+          - const: link
       - const: link       # for others
 
   socionext,syscon:
diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml
index c871d462c952..6fa5caab1487 100644
--- a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3hs-phy.yaml
@@ -37,12 +37,12 @@ properties:
     oneOf:
       - const: link          # for PXs2
       - items:               # for PXs3 with phy-ext
-        - const: link
-        - const: phy
-        - const: phy-ext
+          - const: link
+          - const: phy
+          - const: phy-ext
       - items:               # for others
-        - const: link
-        - const: phy
+          - const: link
+          - const: phy
 
   resets:
     maxItems: 2
diff --git a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml
index edff2c95c9ae..9d46715ed036 100644
--- a/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/socionext,uniphier-usb3ss-phy.yaml
@@ -37,15 +37,15 @@ properties:
   clock-names:
     oneOf:
       - items:             # for Pro4, Pro5
-        - const: gio
-        - const: link
+          - const: gio
+          - const: link
       - items:             # for PXs3 with phy-ext
-        - const: link
-        - const: phy
-        - const: phy-ext
+          - const: link
+          - const: phy
+          - const: phy-ext
       - items:             # for others
-        - const: link
-        - const: phy
+          - const: link
+          - const: phy
 
   resets:
     maxItems: 2
@@ -53,11 +53,11 @@ properties:
   reset-names:
     oneOf:
       - items:              # for Pro4,Pro5
-        - const: gio
-        - const: link
+          - const: gio
+          - const: link
       - items:              # for others
-        - const: link
-        - const: phy
+          - const: link
+          - const: phy
 
   vbus-supply:
     description: A phandle to the regulator for USB VBUS
diff --git a/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml b/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml
index 3f913d6d1c3d..5ffc95c62909 100644
--- a/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml
+++ b/Documentation/devicetree/bindings/phy/ti,phy-j721e-wiz.yaml
@@ -203,7 +203,8 @@ examples:
            };
 
            refclk-dig {
-                  clocks = <&k3_clks 292 11>, <&k3_clks 292 0>, <&dummy_cmn_refclk>, <&dummy_cmn_refclk1>;
+                  clocks = <&k3_clks 292 11>, <&k3_clks 292 0>, 
+                          <&dummy_cmn_refclk>, <&dummy_cmn_refclk1>;
                   #clock-cells = <0>;
                   assigned-clocks = <&wiz0_refclk_dig>;
                   assigned-clock-parents = <&k3_clks 292 11>;
diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
index 017d9593573b..54631dc1adb0 100644
--- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2400-pinctrl.yaml
@@ -34,22 +34,22 @@ patternProperties:
       patternProperties:
         "^function|groups$":
           $ref: "/schemas/types.yaml#/definitions/string"
-          enum: [ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
-            ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, DDCCLK, DDCDAT,
-            EXTRST, FLACK, FLBUSY, FLWP, GPID, GPID0, GPID2, GPID4, GPID6, GPIE0,
-            GPIE2, GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13, I2C14, I2C3, I2C4,
-            I2C5, I2C6, I2C7, I2C8, I2C9, LPCPD, LPCPME, LPCRST, LPCSMI, MAC1LINK,
-            MAC2LINK, MDIO1, MDIO2, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2,
-            NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4,
-            NDTS4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, OSCCLK, PWM0,
-            PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1,
-            RMII2, ROM16, ROM8, ROMCS1, ROMCS2, ROMCS3, ROMCS4, RXD1, RXD2, RXD3,
-            RXD4, SALT1, SALT2, SALT3, SALT4, SD1, SD2, SGPMCK, SGPMI, SGPMLD,
-            SGPMO, SGPSCK, SGPSI0, SGPSI1, SGPSLD, SIOONCTRL, SIOPBI, SIOPBO,
-            SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1DEBUG, SPI1PASSTHRU,
-            SPICS1, TIMER3, TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1, TXD2,
-            TXD3, TXD4, UART6, USB11D1, USB11H2, USB2D1, USB2H1, USBCKI, VGABIOS_ROM,
-            VGAHS, VGAVS, VPI18, VPI24, VPI30, VPO12, VPO24, WDTRST1, WDTRST2]
+          enum: [ ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
+                  ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, DDCCLK, DDCDAT,
+                  EXTRST, FLACK, FLBUSY, FLWP, GPID, GPID0, GPID2, GPID4, GPID6, GPIE0,
+                  GPIE2, GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13, I2C14, I2C3, I2C4,
+                  I2C5, I2C6, I2C7, I2C8, I2C9, LPCPD, LPCPME, LPCRST, LPCSMI, MAC1LINK,
+                  MAC2LINK, MDIO1, MDIO2, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2,
+                  NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4,
+                  NDTS4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, OSCCLK, PWM0,
+                  PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1,
+                  RMII2, ROM16, ROM8, ROMCS1, ROMCS2, ROMCS3, ROMCS4, RXD1, RXD2, RXD3,
+                  RXD4, SALT1, SALT2, SALT3, SALT4, SD1, SD2, SGPMCK, SGPMI, SGPMLD,
+                  SGPMO, SGPSCK, SGPSI0, SGPSI1, SGPSLD, SIOONCTRL, SIOPBI, SIOPBO,
+                  SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1DEBUG, SPI1PASSTHRU,
+                  SPICS1, TIMER3, TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1, TXD2,
+                  TXD3, TXD4, UART6, USB11D1, USB11H2, USB2D1, USB2H1, USBCKI, VGABIOS_ROM,
+                  VGAHS, VGAVS, VPI18, VPI24, VPI30, VPO12, VPO24, WDTRST1, WDTRST2]
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
index c643d6d44415..a90c0fe0495f 100644
--- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2500-pinctrl.yaml
@@ -43,24 +43,24 @@ patternProperties:
       patternProperties:
         "^function|groups$":
           $ref: "/schemas/types.yaml#/definitions/string"
-          enum: [ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
-            ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, DDCCLK, DDCDAT,
-            ESPI, FWSPICS1, FWSPICS2, GPID0, GPID2, GPID4, GPID6, GPIE0, GPIE2,
-            GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13, I2C14, I2C3, I2C4, I2C5,
-            I2C6, I2C7, I2C8, I2C9, LAD0, LAD1, LAD2, LAD3, LCLK, LFRAME, LPCHC,
-            LPCPD, LPCPLUS, LPCPME, LPCRST, LPCSMI, LSIRQ, MAC1LINK, MAC2LINK,
-            MDIO1, MDIO2, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4,
-            NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2,
-            NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PNOR, PWM0,
-            PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1,
-            RMII2, RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13,
-            SALT14, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8, SALT9, SCL1,
-            SCL2, SD1, SD2, SDA1, SDA2, SGPS1, SGPS2, SIOONCTRL, SIOPBI, SIOPBO,
-            SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1CS1, SPI1DEBUG,
-            SPI1PASSTHRU, SPI2CK, SPI2CS0, SPI2CS1, SPI2MISO, SPI2MOSI, TIMER3,
-            TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1, TXD2, TXD3, TXD4, UART6,
-            USB11BHID, USB2AD, USB2AH, USB2BD, USB2BH, USBCKI, VGABIOSROM, VGAHS,
-            VGAVS, VPI24, VPO, WDTRST1, WDTRST2]
+          enum: [ ACPI, ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15,
+                  ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, DDCCLK, DDCDAT,
+                  ESPI, FWSPICS1, FWSPICS2, GPID0, GPID2, GPID4, GPID6, GPIE0, GPIE2,
+                  GPIE4, GPIE6, I2C10, I2C11, I2C12, I2C13, I2C14, I2C3, I2C4, I2C5,
+                  I2C6, I2C7, I2C8, I2C9, LAD0, LAD1, LAD2, LAD3, LCLK, LFRAME, LPCHC,
+                  LPCPD, LPCPLUS, LPCPME, LPCRST, LPCSMI, LSIRQ, MAC1LINK, MAC2LINK,
+                  MDIO1, MDIO2, NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4,
+                  NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2,
+                  NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PNOR, PWM0,
+                  PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, RGMII1, RGMII2, RMII1,
+                  RMII2, RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13,
+                  SALT14, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8, SALT9, SCL1,
+                  SCL2, SD1, SD2, SDA1, SDA2, SGPS1, SGPS2, SIOONCTRL, SIOPBI, SIOPBO,
+                  SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1CS1, SPI1DEBUG,
+                  SPI1PASSTHRU, SPI2CK, SPI2CS0, SPI2CS1, SPI2MISO, SPI2MOSI, TIMER3,
+                  TIMER4, TIMER5, TIMER6, TIMER7, TIMER8, TXD1, TXD2, TXD3, TXD4, UART6,
+                  USB11BHID, USB2AD, USB2AH, USB2BD, USB2BH, USBCKI, VGABIOSROM, VGAHS,
+                  VGAVS, VPI24, VPO, WDTRST1, WDTRST2]
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
index 1506726c7fea..c78ab7e2eee7 100644
--- a/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml
@@ -31,57 +31,57 @@ patternProperties:
       properties:
         function:
           $ref: "/schemas/types.yaml#/definitions/string"
-          enum: [ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
-            ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMC, ESPI, ESPIALT,
-            FSI1, FSI2, FWSPIABR, FWSPID, FWSPIWP, GPIT0, GPIT1, GPIT2, GPIT3,
-            GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1, GPIU2, GPIU3, GPIU4, GPIU5,
-            GPIU6, GPIU7, I2C1, I2C10, I2C11, I2C12, I2C13, I2C14, I2C15, I2C16,
-            I2C2, I2C3, I2C4, I2C5, I2C6, I2C7, I2C8, I2C9, I3C3, I3C4, I3C5,
-            I3C6, JTAGM, LHPD, LHSIRQ, LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ,
-            MACLINK1, MACLINK2, MACLINK3, MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4,
-            NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2,
-            NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4,
-            NRTS1, NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PWM0, PWM1, PWM10, PWM11,
-            PWM12, PWM13, PWM14, PWM15, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, PWM8,
-            PWM9, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3, RMII4,
-            RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13, SALT14,
-            SALT15, SALT16, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8,
-            SALT9, SD1, SD2, SGPM1, SGPS1, SIOONCTRL, SIOPBI, SIOPBO, SIOPWREQ,
-            SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1ABR, SPI1CS1, SPI1WP, SPI2,
-            SPI2CS1, SPI2CS2, TACH0, TACH1, TACH10, TACH11, TACH12, TACH13, TACH14,
-            TACH15, TACH2, TACH3, TACH4, TACH5, TACH6, TACH7, TACH8, TACH9, THRU0,
-            THRU1, THRU2, THRU3, TXD1, TXD2, TXD3, TXD4, UART10, UART11, UART12,
-            UART13, UART6, UART7, UART8, UART9, USBAD, USBADP, USB2AH, USB2AHP,
-            USB2BD, USB2BH, VB, VGAHS, VGAVS, WDTRST1, WDTRST2, WDTRST3, WDTRST4]
+          enum: [ ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
+                  ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMC, ESPI, ESPIALT,
+                  FSI1, FSI2, FWSPIABR, FWSPID, FWSPIWP, GPIT0, GPIT1, GPIT2, GPIT3,
+                  GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1, GPIU2, GPIU3, GPIU4, GPIU5,
+                  GPIU6, GPIU7, I2C1, I2C10, I2C11, I2C12, I2C13, I2C14, I2C15, I2C16,
+                  I2C2, I2C3, I2C4, I2C5, I2C6, I2C7, I2C8, I2C9, I3C3, I3C4, I3C5,
+                  I3C6, JTAGM, LHPD, LHSIRQ, LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ,
+                  MACLINK1, MACLINK2, MACLINK3, MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4,
+                  NCTS1, NCTS2, NCTS3, NCTS4, NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2,
+                  NDSR3, NDSR4, NDTR1, NDTR2, NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4,
+                  NRTS1, NRTS2, NRTS3, NRTS4, OSCCLK, PEWAKE, PWM0, PWM1, PWM10, PWM11,
+                  PWM12, PWM13, PWM14, PWM15, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7, PWM8,
+                  PWM9, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3, RMII4,
+                  RXD1, RXD2, RXD3, RXD4, SALT1, SALT10, SALT11, SALT12, SALT13, SALT14,
+                  SALT15, SALT16, SALT2, SALT3, SALT4, SALT5, SALT6, SALT7, SALT8,
+                  SALT9, SD1, SD2, SGPM1, SGPS1, SIOONCTRL, SIOPBI, SIOPBO, SIOPWREQ,
+                  SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1ABR, SPI1CS1, SPI1WP, SPI2,
+                  SPI2CS1, SPI2CS2, TACH0, TACH1, TACH10, TACH11, TACH12, TACH13, TACH14,
+                  TACH15, TACH2, TACH3, TACH4, TACH5, TACH6, TACH7, TACH8, TACH9, THRU0,
+                  THRU1, THRU2, THRU3, TXD1, TXD2, TXD3, TXD4, UART10, UART11, UART12,
+                  UART13, UART6, UART7, UART8, UART9, USBAD, USBADP, USB2AH, USB2AHP,
+                  USB2BD, USB2BH, VB, VGAHS, VGAVS, WDTRST1, WDTRST2, WDTRST3, WDTRST4 ]
 
         groups:
           $ref: "/schemas/types.yaml#/definitions/string"
-          enum: [ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
-            ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMCG1, EMMCG4,
-            EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWQSPID, FWSPIWP,
-            GPIT0, GPIT1, GPIT2, GPIT3, GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1,
-            GPIU2, GPIU3, GPIU4, GPIU5, GPIU6, GPIU7, HVI3C3, HVI3C4, I2C1, I2C10,
-            I2C11, I2C12, I2C13, I2C14, I2C15, I2C16, I2C2, I2C3, I2C4, I2C5,
-            I2C6, I2C7, I2C8, I2C9, I3C3, I3C4, I3C5, I3C6, JTAGM, LHPD, LHSIRQ,
-            LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ, MACLINK1, MACLINK2, MACLINK3,
-            MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4, NCTS1, NCTS2, NCTS3, NCTS4,
-            NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2,
-            NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4,
-            OSCCLK, PEWAKE, PWM0, PWM1, PWM10G0, PWM10G1, PWM11G0, PWM11G1, PWM12G0,
-            PWM12G1, PWM13G0, PWM13G1, PWM14G0, PWM14G1, PWM15G0, PWM15G1, PWM2,
-            PWM3, PWM4, PWM5, PWM6, PWM7, PWM8G0, PWM8G1, PWM9G0, PWM9G1, QSPI1,
-            QSPI2, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3, RMII4,
-            RXD1, RXD2, RXD3, RXD4, SALT1, SALT10G0, SALT10G1, SALT11G0, SALT11G1,
-            SALT12G0, SALT12G1, SALT13G0, SALT13G1, SALT14G0, SALT14G1, SALT15G0,
-            SALT15G1, SALT16G0, SALT16G1, SALT2, SALT3, SALT4, SALT5, SALT6,
-            SALT7, SALT8, SALT9G0, SALT9G1, SD1, SD2, SD3, SGPM1, SGPS1, SIOONCTRL,
-            SIOPBI, SIOPBO, SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1ABR,
-            SPI1CS1, SPI1WP, SPI2, SPI2CS1, SPI2CS2, TACH0, TACH1, TACH10, TACH11,
-            TACH12, TACH13, TACH14, TACH15, TACH2, TACH3, TACH4, TACH5, TACH6,
-            TACH7, TACH8, TACH9, THRU0, THRU1, THRU2, THRU3, TXD1, TXD2, TXD3,
-            TXD4, UART10, UART11, UART12G0, UART12G1, UART13G0, UART13G1, UART6,
-            UART7, UART8, UART9, USBA, USBB, VB, VGAHS, VGAVS, WDTRST1, WDTRST2,
-            WDTRST3, WDTRST4]
+          enum: [ ADC0, ADC1, ADC10, ADC11, ADC12, ADC13, ADC14, ADC15, ADC2,
+                  ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, BMCINT, EMMCG1, EMMCG4,
+                  EMMCG8, ESPI, ESPIALT, FSI1, FSI2, FWSPIABR, FWSPID, FWQSPID, FWSPIWP,
+                  GPIT0, GPIT1, GPIT2, GPIT3, GPIT4, GPIT5, GPIT6, GPIT7, GPIU0, GPIU1,
+                  GPIU2, GPIU3, GPIU4, GPIU5, GPIU6, GPIU7, HVI3C3, HVI3C4, I2C1, I2C10,
+                  I2C11, I2C12, I2C13, I2C14, I2C15, I2C16, I2C2, I2C3, I2C4, I2C5,
+                  I2C6, I2C7, I2C8, I2C9, I3C3, I3C4, I3C5, I3C6, JTAGM, LHPD, LHSIRQ,
+                  LPC, LPCHC, LPCPD, LPCPME, LPCSMI, LSIRQ, MACLINK1, MACLINK2, MACLINK3,
+                  MACLINK4, MDIO1, MDIO2, MDIO3, MDIO4, NCTS1, NCTS2, NCTS3, NCTS4,
+                  NDCD1, NDCD2, NDCD3, NDCD4, NDSR1, NDSR2, NDSR3, NDSR4, NDTR1, NDTR2,
+                  NDTR3, NDTR4, NRI1, NRI2, NRI3, NRI4, NRTS1, NRTS2, NRTS3, NRTS4,
+                  OSCCLK, PEWAKE, PWM0, PWM1, PWM10G0, PWM10G1, PWM11G0, PWM11G1, PWM12G0,
+                  PWM12G1, PWM13G0, PWM13G1, PWM14G0, PWM14G1, PWM15G0, PWM15G1, PWM2,
+                  PWM3, PWM4, PWM5, PWM6, PWM7, PWM8G0, PWM8G1, PWM9G0, PWM9G1, QSPI1,
+                  QSPI2, RGMII1, RGMII2, RGMII3, RGMII4, RMII1, RMII2, RMII3, RMII4,
+                  RXD1, RXD2, RXD3, RXD4, SALT1, SALT10G0, SALT10G1, SALT11G0, SALT11G1,
+                  SALT12G0, SALT12G1, SALT13G0, SALT13G1, SALT14G0, SALT14G1, SALT15G0,
+                  SALT15G1, SALT16G0, SALT16G1, SALT2, SALT3, SALT4, SALT5, SALT6,
+                  SALT7, SALT8, SALT9G0, SALT9G1, SD1, SD2, SD3, SGPM1, SGPS1, SIOONCTRL,
+                  SIOPBI, SIOPBO, SIOPWREQ, SIOPWRGD, SIOS3, SIOS5, SIOSCI, SPI1, SPI1ABR,
+                  SPI1CS1, SPI1WP, SPI2, SPI2CS1, SPI2CS2, TACH0, TACH1, TACH10, TACH11,
+                  TACH12, TACH13, TACH14, TACH15, TACH2, TACH3, TACH4, TACH5, TACH6,
+                  TACH7, TACH8, TACH9, THRU0, THRU1, THRU2, THRU3, TXD1, TXD2, TXD3,
+                  TXD4, UART10, UART11, UART12G0, UART12G1, UART13G0, UART13G1, UART6,
+                  UART7, UART8, UART9, USBA, USBB, VB, VGAHS, VGAVS, WDTRST1, WDTRST2,
+                  WDTRST3, WDTRST4]
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml
index 18163fb69ce7..44c04d11ae4c 100644
--- a/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/ingenic,pinctrl.yaml
@@ -32,20 +32,20 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-pinctrl
-        - ingenic,jz4725b-pinctrl
-        - ingenic,jz4760-pinctrl
-        - ingenic,jz4770-pinctrl
-        - ingenic,jz4780-pinctrl
-        - ingenic,x1000-pinctrl
-        - ingenic,x1500-pinctrl
-        - ingenic,x1830-pinctrl
+          - ingenic,jz4740-pinctrl
+          - ingenic,jz4725b-pinctrl
+          - ingenic,jz4760-pinctrl
+          - ingenic,jz4770-pinctrl
+          - ingenic,jz4780-pinctrl
+          - ingenic,x1000-pinctrl
+          - ingenic,x1500-pinctrl
+          - ingenic,x1830-pinctrl
       - items:
-        - const: ingenic,jz4760b-pinctrl
-        - const: ingenic,jz4760-pinctrl
+          - const: ingenic,jz4760b-pinctrl
+          - const: ingenic,jz4760-pinctrl
       - items:
-        - const: ingenic,x1000e-pinctrl
-        - const: ingenic,x1000-pinctrl
+          - const: ingenic,x1000e-pinctrl
+          - const: ingenic,x1000-pinctrl
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,ipq6018-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,ipq6018-pinctrl.yaml
index b2de3992d484..c64c93206817 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,ipq6018-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,ipq6018-pinctrl.yaml
@@ -60,8 +60,8 @@ patternProperties:
           oneOf:
             - pattern: "^gpio([1-9]|[1-7][0-9]|80)$"
             - enum: [ sdc1_clk, sdc1_cmd, sdc1_data, sdc2_clk, sdc2_cmd,
-              sdc2_data, qdsd_cmd, qdsd_data0, qdsd_data1, qdsd_data2,
-              qdsd_data3 ]
+                      sdc2_data, qdsd_cmd, qdsd_data0, qdsd_data1, qdsd_data2,
+                      qdsd_data3 ]
         minItems: 1
         maxItems: 4
 
@@ -70,31 +70,31 @@ patternProperties:
           Specify the alternative function to be configured for the specified
           pins.
         enum: [ adsp_ext, alsp_int, atest_bbrx0, atest_bbrx1, atest_char,
-          atest_char0, atest_char1, atest_char2, atest_char3, atest_combodac,
-          atest_gpsadc0, atest_gpsadc1, atest_tsens, atest_wlan0,
-          atest_wlan1, backlight_en, bimc_dte0, bimc_dte1, blsp1_i2c,
-          blsp2_i2c, blsp3_i2c, blsp4_i2c, blsp5_i2c, blsp6_i2c,  blsp1_spi,
-          blsp1_spi_cs1, blsp1_spi_cs2, blsp1_spi_cs3, blsp2_spi,
-          blsp2_spi_cs1, blsp2_spi_cs2, blsp2_spi_cs3, blsp3_spi,
-          blsp3_spi_cs1, blsp3_spi_cs2, blsp3_spi_cs3, blsp4_spi, blsp5_spi,
-          blsp6_spi, blsp1_uart, blsp2_uart, blsp1_uim, blsp2_uim, cam1_rst,
-          cam1_standby, cam_mclk0, cam_mclk1, cci_async, cci_i2c, cci_timer0,
-          cci_timer1, cci_timer2, cdc_pdm0, codec_mad, dbg_out, display_5v,
-          dmic0_clk, dmic0_data, dsi_rst, ebi0_wrcdc, euro_us, ext_lpass,
-          flash_strobe, gcc_gp1_clk_a, gcc_gp1_clk_b, gcc_gp2_clk_a,
-          gcc_gp2_clk_b, gcc_gp3_clk_a, gcc_gp3_clk_b, gpio, gsm0_tx0,
-          gsm0_tx1, gsm1_tx0, gsm1_tx1, gyro_accl, kpsns0, kpsns1, kpsns2,
-          ldo_en, ldo_update, mag_int, mdp_vsync, modem_tsync, m_voc,
-          nav_pps, nav_tsync, pa_indicator, pbs0, pbs1, pbs2, pri_mi2s,
-          pri_mi2s_ws, prng_rosc, pwr_crypto_enabled_a, pwr_crypto_enabled_b,
-          pwr_modem_enabled_a,  pwr_modem_enabled_b, pwr_nav_enabled_a,
-          pwr_nav_enabled_b, qdss_ctitrig_in_a0, qdss_ctitrig_in_a1,
-          qdss_ctitrig_in_b0, qdss_ctitrig_in_b1, qdss_ctitrig_out_a0,
-          qdss_ctitrig_out_a1, qdss_ctitrig_out_b0, qdss_ctitrig_out_b1,
-          qdss_traceclk_a, qdss_traceclk_b, qdss_tracectl_a, qdss_tracectl_b,
-          qdss_tracedata_a, qdss_tracedata_b, reset_n, sd_card, sd_write,
-          sec_mi2s, smb_int, ssbi_wtr0, ssbi_wtr1, uim1, uim2, uim3,
-          uim_batt, wcss_bt, wcss_fm, wcss_wlan, webcam1_rst ]
+                atest_char0, atest_char1, atest_char2, atest_char3, atest_combodac,
+                atest_gpsadc0, atest_gpsadc1, atest_tsens, atest_wlan0,
+                atest_wlan1, backlight_en, bimc_dte0, bimc_dte1, blsp1_i2c,
+                blsp2_i2c, blsp3_i2c, blsp4_i2c, blsp5_i2c, blsp6_i2c, blsp1_spi,
+                blsp1_spi_cs1, blsp1_spi_cs2, blsp1_spi_cs3, blsp2_spi,
+                blsp2_spi_cs1, blsp2_spi_cs2, blsp2_spi_cs3, blsp3_spi,
+                blsp3_spi_cs1, blsp3_spi_cs2, blsp3_spi_cs3, blsp4_spi, blsp5_spi,
+                blsp6_spi, blsp1_uart, blsp2_uart, blsp1_uim, blsp2_uim, cam1_rst,
+                cam1_standby, cam_mclk0, cam_mclk1, cci_async, cci_i2c, cci_timer0,
+                cci_timer1, cci_timer2, cdc_pdm0, codec_mad, dbg_out, display_5v,
+                dmic0_clk, dmic0_data, dsi_rst, ebi0_wrcdc, euro_us, ext_lpass,
+                flash_strobe, gcc_gp1_clk_a, gcc_gp1_clk_b, gcc_gp2_clk_a,
+                gcc_gp2_clk_b, gcc_gp3_clk_a, gcc_gp3_clk_b, gpio, gsm0_tx0,
+                gsm0_tx1, gsm1_tx0, gsm1_tx1, gyro_accl, kpsns0, kpsns1, kpsns2,
+                ldo_en, ldo_update, mag_int, mdp_vsync, modem_tsync, m_voc,
+                nav_pps, nav_tsync, pa_indicator, pbs0, pbs1, pbs2, pri_mi2s,
+                pri_mi2s_ws, prng_rosc, pwr_crypto_enabled_a, pwr_crypto_enabled_b,
+                pwr_modem_enabled_a, pwr_modem_enabled_b, pwr_nav_enabled_a,
+                pwr_nav_enabled_b, qdss_ctitrig_in_a0, qdss_ctitrig_in_a1,
+                qdss_ctitrig_in_b0, qdss_ctitrig_in_b1, qdss_ctitrig_out_a0,
+                qdss_ctitrig_out_a1, qdss_ctitrig_out_b0, qdss_ctitrig_out_b1,
+                qdss_traceclk_a, qdss_traceclk_b, qdss_tracectl_a, qdss_tracectl_b,
+                qdss_tracedata_a, qdss_tracedata_b, reset_n, sd_card, sd_write,
+                sec_mi2s, smb_int, ssbi_wtr0, ssbi_wtr1, uim1, uim2, uim3,
+                uim_batt, wcss_bt, wcss_fm, wcss_wlan, webcam1_rst ]
 
       drive-strength:
         enum: [2, 4, 6, 8, 10, 12, 14, 16]
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sm8250-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sm8250-pinctrl.yaml
index 6dc3b52f47cd..8508c57522fd 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,sm8250-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,sm8250-pinctrl.yaml
@@ -76,22 +76,22 @@ patternProperties:
             pins.
 
           enum: [ aoss_cti, atest, audio_ref, cam_mclk, cci_async, cci_i2c,
-            cci_timer0, cci_timer1, cci_timer2, cci_timer3, cci_timer4, cri_trng,
-            cri_trng0, cri_trng1, dbg_out, ddr_bist, ddr_pxi0, ddr_pxi1,
-            ddr_pxi2, ddr_pxi3, dp_hot, dp_lcd, gcc_gp1, gcc_gp2, gcc_gp3, gpio,
-            ibi_i3c, jitter_bist, lpass_slimbus, mdp_vsync, mdp_vsync0,
-            mdp_vsync1, mdp_vsync2, mdp_vsync3, mi2s0_data0, mi2s0_data1,
-            mi2s0_sck, mi2s0_ws, mi2s1_data0, mi2s1_data1, mi2s1_sck, mi2s1_ws,
-            mi2s2_data0, mi2s2_data1, mi2s2_sck, mi2s2_ws, pci_e0, pci_e1,
-            pci_e2, phase_flag, pll_bist, pll_bypassnl, pll_clk, pll_reset,
-            pri_mi2s, prng_rosc, qdss_cti, qdss_gpio, qspi0, qspi1, qspi2, qspi3,
-            qspi_clk, qspi_cs, qup0, qup1, qup10, qup11, qup12, qup13, qup14,
-            qup15, qup16, qup17, qup18, qup19, qup2, qup3, qup4, qup5, qup6,
-            qup7, qup8, qup9, qup_l4, qup_l5, qup_l6, sd_write, sdc40, sdc41,
-            sdc42, sdc43, sdc4_clk, sdc4_cmd, sec_mi2s, sp_cmu, tgu_ch0, tgu_ch1,
-            tgu_ch2, tgu_ch3, tsense_pwm1, tsense_pwm2, tsif0_clk, tsif0_data,
-            tsif0_en, tsif0_error, tsif0_sync, tsif1_clk, tsif1_data, tsif1_en,
-            tsif1_error, tsif1_sync, usb2phy_ac, usb_phy, vsense_trigger ]
+                  cci_timer0, cci_timer1, cci_timer2, cci_timer3, cci_timer4, cri_trng,
+                  cri_trng0, cri_trng1, dbg_out, ddr_bist, ddr_pxi0, ddr_pxi1,
+                  ddr_pxi2, ddr_pxi3, dp_hot, dp_lcd, gcc_gp1, gcc_gp2, gcc_gp3, gpio,
+                  ibi_i3c, jitter_bist, lpass_slimbus, mdp_vsync, mdp_vsync0,
+                  mdp_vsync1, mdp_vsync2, mdp_vsync3, mi2s0_data0, mi2s0_data1,
+                  mi2s0_sck, mi2s0_ws, mi2s1_data0, mi2s1_data1, mi2s1_sck, mi2s1_ws,
+                  mi2s2_data0, mi2s2_data1, mi2s2_sck, mi2s2_ws, pci_e0, pci_e1,
+                  pci_e2, phase_flag, pll_bist, pll_bypassnl, pll_clk, pll_reset,
+                  pri_mi2s, prng_rosc, qdss_cti, qdss_gpio, qspi0, qspi1, qspi2, qspi3,
+                  qspi_clk, qspi_cs, qup0, qup1, qup10, qup11, qup12, qup13, qup14,
+                  qup15, qup16, qup17, qup18, qup19, qup2, qup3, qup4, qup5, qup6,
+                  qup7, qup8, qup9, qup_l4, qup_l5, qup_l6, sd_write, sdc40, sdc41,
+                  sdc42, sdc43, sdc4_clk, sdc4_cmd, sec_mi2s, sp_cmu, tgu_ch0, tgu_ch1,
+                  tgu_ch2, tgu_ch3, tsense_pwm1, tsense_pwm2, tsif0_clk, tsif0_data,
+                  tsif0_en, tsif0_error, tsif0_sync, tsif1_clk, tsif1_data, tsif1_en,
+                  tsif1_error, tsif1_sync, usb2phy_ac, usb_phy, vsense_trigger ]
 
         drive-strength:
           enum: [2, 4, 6, 8, 10, 12, 14, 16]
diff --git a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
index 0857cbeeb43c..72877544ca78 100644
--- a/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/st,stm32-pinctrl.yaml
@@ -48,8 +48,8 @@ properties:
 
   st,package:
     description:
-     Indicates the SOC package used.
-     More details in include/dt-bindings/pinctrl/stm32-pinfunc.h
+      Indicates the SOC package used.
+      More details in include/dt-bindings/pinctrl/stm32-pinfunc.h
     $ref: /schemas/types.yaml#/definitions/uint32
     enum: [1, 2, 4, 8]
 
diff --git a/Documentation/devicetree/bindings/power/power-domain.yaml b/Documentation/devicetree/bindings/power/power-domain.yaml
index ff5936e4a215..dd564349aa53 100644
--- a/Documentation/devicetree/bindings/power/power-domain.yaml
+++ b/Documentation/devicetree/bindings/power/power-domain.yaml
@@ -58,13 +58,13 @@ properties:
 
   power-domains:
     description:
-       A phandle and PM domain specifier as defined by bindings of the power
-       controller specified by phandle. Some power domains might be powered
-       from another power domain (or have other hardware specific
-       dependencies). For representing such dependency a standard PM domain
-       consumer binding is used. When provided, all domains created
-       by the given provider should be subdomains of the domain specified
-       by this binding.
+      A phandle and PM domain specifier as defined by bindings of the power
+      controller specified by phandle. Some power domains might be powered
+      from another power domain (or have other hardware specific
+      dependencies). For representing such dependency a standard PM domain
+      consumer binding is used. When provided, all domains created
+      by the given provider should be subdomains of the domain specified
+      by this binding.
 
 required:
   - "#power-domain-cells"
diff --git a/Documentation/devicetree/bindings/power/supply/gpio-charger.yaml b/Documentation/devicetree/bindings/power/supply/gpio-charger.yaml
index 30eabbb14ef3..6244b8ee9402 100644
--- a/Documentation/devicetree/bindings/power/supply/gpio-charger.yaml
+++ b/Documentation/devicetree/bindings/power/supply/gpio-charger.yaml
@@ -44,9 +44,9 @@ required:
 
 anyOf:
   - required:
-    - gpios
+      - gpios
   - required:
-    - charge-status-gpios
+      - charge-status-gpios
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml b/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
index d2022206081f..c0d7700afee7 100644
--- a/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
@@ -76,8 +76,7 @@ patternProperties:
 
   "^((s|l|lvs|5vs)[0-9]*)|(boost-bypass)|(bob)$":
     description: List of regulators and its properties
-    allOf:
-     - $ref: regulator.yaml#
+    $ref: regulator.yaml#
 
 additionalProperties: false
 
diff --git a/Documentation/devicetree/bindings/regulator/qcom-labibb-regulator.yaml b/Documentation/devicetree/bindings/regulator/qcom-labibb-regulator.yaml
index 085cbd1ad8d0..fb111e2d5b99 100644
--- a/Documentation/devicetree/bindings/regulator/qcom-labibb-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/qcom-labibb-regulator.yaml
@@ -29,7 +29,7 @@ properties:
           Short-circuit interrupt for lab.
 
     required:
-    - interrupts
+      - interrupts
 
   ibb:
     type: object
@@ -42,7 +42,7 @@ properties:
           Short-circuit interrupt for lab.
 
     required:
-    - interrupts
+      - interrupts
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
index 24b0c50fa436..6070456a7b67 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,k3-dsp-rproc.yaml
@@ -118,16 +118,16 @@ else:
           - const: l1dram
 
 required:
- - compatible
- - reg
- - reg-names
- - ti,sci
- - ti,sci-dev-id
- - ti,sci-proc-ids
- - resets
- - firmware-name
- - mboxes
- - memory-region
+  - compatible
+  - reg
+  - reg-names
+  - ti,sci
+  - ti,sci-dev-id
+  - ti,sci-proc-ids
+  - resets
+  - firmware-name
+  - mboxes
+  - memory-region
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/reset/fsl,imx7-src.yaml b/Documentation/devicetree/bindings/reset/fsl,imx7-src.yaml
index b1a71c1bb05b..569cd3bd3a70 100644
--- a/Documentation/devicetree/bindings/reset/fsl,imx7-src.yaml
+++ b/Documentation/devicetree/bindings/reset/fsl,imx7-src.yaml
@@ -24,9 +24,9 @@ properties:
   compatible:
     items:
       - enum:
-        - fsl,imx7d-src
-        - fsl,imx8mq-src
-        - fsl,imx8mp-src
+          - fsl,imx7d-src
+          - fsl,imx8mq-src
+          - fsl,imx8mp-src
       - const: syscon
 
   reg:
diff --git a/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml b/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml
index 4206bf8a2469..bc2c7e53a28e 100644
--- a/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/ingenic,rtc.yaml
@@ -16,16 +16,16 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-rtc
-        - ingenic,jz4760-rtc
+          - ingenic,jz4740-rtc
+          - ingenic,jz4760-rtc
       - items:
-        - const: ingenic,jz4725b-rtc
-        - const: ingenic,jz4740-rtc
+          - const: ingenic,jz4725b-rtc
+          - const: ingenic,jz4740-rtc
       - items:
-        - enum:
-          - ingenic,jz4770-rtc
-          - ingenic,jz4780-rtc
-        - const: ingenic,jz4760-rtc
+          - enum:
+              - ingenic,jz4770-rtc
+              - ingenic,jz4780-rtc
+          - const: ingenic,jz4760-rtc
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/serial/ingenic,uart.yaml b/Documentation/devicetree/bindings/serial/ingenic,uart.yaml
index c023d650e9c1..dc8349322c83 100644
--- a/Documentation/devicetree/bindings/serial/ingenic,uart.yaml
+++ b/Documentation/devicetree/bindings/serial/ingenic,uart.yaml
@@ -16,18 +16,18 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-uart
-        - ingenic,jz4760-uart
-        - ingenic,jz4780-uart
-        - ingenic,x1000-uart
+          - ingenic,jz4740-uart
+          - ingenic,jz4760-uart
+          - ingenic,jz4780-uart
+          - ingenic,x1000-uart
       - items:
-        - enum:
-          - ingenic,jz4770-uart
-          - ingenic,jz4775-uart
-        - const: ingenic,jz4760-uart
+          - enum:
+              - ingenic,jz4770-uart
+              - ingenic,jz4775-uart
+          - const: ingenic,jz4760-uart
       - items:
-        - const: ingenic,jz4725b-uart
-        - const: ingenic,jz4740-uart
+          - const: ingenic,jz4725b-uart
+          - const: ingenic,jz4740-uart
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
index 3cd0b70cd6cf..55fffae05dcf 100644
--- a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
+++ b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
@@ -97,13 +97,13 @@ allOf:
         clock-names:
           oneOf:
             - items:
-              - const: t0_clk
-              - const: slow_clk
+                - const: t0_clk
+                - const: slow_clk
             - items:
-              - const: t0_clk
-              - const: t1_clk
-              - const: t2_clk
-              - const: slow_clk
+                - const: t0_clk
+                - const: t1_clk
+                - const: t2_clk
+                - const: slow_clk
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
index a2b29cc3e93b..bd04fdb57414 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,geni-se.yaml
@@ -7,8 +7,8 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: GENI Serial Engine QUP Wrapper Controller
 
 maintainers:
- - Mukesh Savaliya <msavaliy@codeaurora.org>
- - Akash Asthana <akashast@codeaurora.org>
+  - Mukesh Savaliya <msavaliy@codeaurora.org>
+  - Akash Asthana <akashast@codeaurora.org>
 
 description: |
  Generic Interface (GENI) based Qualcomm Universal Peripheral (QUP) wrapper
@@ -38,10 +38,10 @@ properties:
       - description: Slave AHB Clock
 
   "#address-cells":
-     const: 2
+    const: 2
 
   "#size-cells":
-     const: 2
+    const: 2
 
   ranges: true
 
@@ -79,15 +79,15 @@ patternProperties:
         maxItems: 1
 
       interconnects:
-         minItems: 2
-         maxItems: 3
+        minItems: 2
+        maxItems: 3
 
       interconnect-names:
-         minItems: 2
-         items:
-           - const: qup-core
-           - const: qup-config
-           - const: qup-memory
+        minItems: 2
+        items:
+          - const: qup-core
+          - const: qup-config
+          - const: qup-memory
 
     required:
       - reg
@@ -111,10 +111,10 @@ patternProperties:
         maxItems: 1
 
       "#address-cells":
-         const: 1
+        const: 1
 
       "#size-cells":
-         const: 0
+        const: 0
 
     required:
       - compatible
@@ -136,10 +136,10 @@ patternProperties:
         maxItems: 1
 
       "#address-cells":
-         const: 1
+        const: 1
 
       "#size-cells":
-         const: 0
+        const: 0
 
       clock-frequency:
         description: Desired I2C bus clock frequency in Hz.
diff --git a/Documentation/devicetree/bindings/sound/amlogic,aiu.yaml b/Documentation/devicetree/bindings/sound/amlogic,aiu.yaml
index f9344adaf6c2..7a7f28469624 100644
--- a/Documentation/devicetree/bindings/sound/amlogic,aiu.yaml
+++ b/Documentation/devicetree/bindings/sound/amlogic,aiu.yaml
@@ -19,12 +19,11 @@ properties:
   compatible:
     items:
       - enum:
-        - amlogic,aiu-gxbb
-        - amlogic,aiu-gxl
-        - amlogic,aiu-meson8
-        - amlogic,aiu-meson8b
-      - const:
-          amlogic,aiu
+          - amlogic,aiu-gxbb
+          - amlogic,aiu-gxl
+          - amlogic,aiu-meson8
+          - amlogic,aiu-meson8b
+      - const: amlogic,aiu
 
   clocks:
     items:
diff --git a/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml b/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml
index 51a0c30e10f9..b4b3828c40af 100644
--- a/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml
+++ b/Documentation/devicetree/bindings/sound/amlogic,g12a-toacodec.yaml
@@ -19,13 +19,11 @@ properties:
   compatible:
     oneOf:
       - items:
-        - const:
-            amlogic,g12a-toacodec
+          - const: amlogic,g12a-toacodec
       - items:
-        - enum:
-          - amlogic,sm1-toacodec
-        - const:
-            amlogic,g12a-toacodec
+          - enum:
+              - amlogic,sm1-toacodec
+          - const: amlogic,g12a-toacodec
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
index 83f44f07ac3f..5bcb643c288f 100644
--- a/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
+++ b/Documentation/devicetree/bindings/sound/cirrus,cs42l51.yaml
@@ -11,7 +11,7 @@ maintainers:
 
 properties:
   compatible:
-      const: cirrus,cs42l51
+    const: cirrus,cs42l51
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/sound/ingenic,aic.yaml b/Documentation/devicetree/bindings/sound/ingenic,aic.yaml
index 44f49bebb267..cdc0fdaab30a 100644
--- a/Documentation/devicetree/bindings/sound/ingenic,aic.yaml
+++ b/Documentation/devicetree/bindings/sound/ingenic,aic.yaml
@@ -16,13 +16,13 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4740-i2s
-        - ingenic,jz4760-i2s
-        - ingenic,jz4770-i2s
-        - ingenic,jz4780-i2s
+          - ingenic,jz4740-i2s
+          - ingenic,jz4760-i2s
+          - ingenic,jz4770-i2s
+          - ingenic,jz4780-i2s
       - items:
-        - const: ingenic,jz4725b-i2s
-        - const: ingenic,jz4740-i2s
+          - const: ingenic,jz4725b-i2s
+          - const: ingenic,jz4740-i2s
 
   '#sound-dai-cells':
     const: 0
diff --git a/Documentation/devicetree/bindings/sound/maxim,max98390.yaml b/Documentation/devicetree/bindings/sound/maxim,max98390.yaml
index e5ac35280da3..9c2e3effa0c0 100644
--- a/Documentation/devicetree/bindings/sound/maxim,max98390.yaml
+++ b/Documentation/devicetree/bindings/sound/maxim,max98390.yaml
@@ -11,7 +11,7 @@ maintainers:
 
 properties:
   compatible:
-      const: maxim,max98390
+    const: maxim,max98390
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.yaml b/Documentation/devicetree/bindings/sound/rockchip-i2s.yaml
index acb2b888dbfc..245895b58a2f 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-i2s.yaml
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.yaml
@@ -19,16 +19,16 @@ properties:
       - const: rockchip,rk3066-i2s
       - items:
           - enum:
-            - rockchip,px30-i2s
-            - rockchip,rk3036-i2s
-            - rockchip,rk3188-i2s
-            - rockchip,rk3228-i2s
-            - rockchip,rk3288-i2s
-            - rockchip,rk3308-i2s
-            - rockchip,rk3328-i2s
-            - rockchip,rk3366-i2s
-            - rockchip,rk3368-i2s
-            - rockchip,rk3399-i2s
+              - rockchip,px30-i2s
+              - rockchip,rk3036-i2s
+              - rockchip,rk3188-i2s
+              - rockchip,rk3228-i2s
+              - rockchip,rk3288-i2s
+              - rockchip,rk3308-i2s
+              - rockchip,rk3328-i2s
+              - rockchip,rk3366-i2s
+              - rockchip,rk3368-i2s
+              - rockchip,rk3399-i2s
           - const: rockchip,rk3066-i2s
 
   reg:
@@ -55,8 +55,8 @@ properties:
     oneOf:
       - const: rx
       - items:
-        - const: tx
-        - const: rx
+          - const: tx
+          - const: rx
 
   power-domains:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/sound/rockchip-spdif.yaml b/Documentation/devicetree/bindings/sound/rockchip-spdif.yaml
index c467152656f7..7bad6f16fe60 100644
--- a/Documentation/devicetree/bindings/sound/rockchip-spdif.yaml
+++ b/Documentation/devicetree/bindings/sound/rockchip-spdif.yaml
@@ -25,8 +25,8 @@ properties:
       - const: rockchip,rk3399-spdif
       - items:
           - enum:
-            - rockchip,rk3188-spdif
-            - rockchip,rk3288-spdif
+              - rockchip,rk3188-spdif
+              - rockchip,rk3288-spdif
           - const: rockchip,rk3066-spdif
 
   reg:
diff --git a/Documentation/devicetree/bindings/sound/tas2770.yaml b/Documentation/devicetree/bindings/sound/tas2770.yaml
index 8192450d72dc..33a90f829c80 100644
--- a/Documentation/devicetree/bindings/sound/tas2770.yaml
+++ b/Documentation/devicetree/bindings/sound/tas2770.yaml
@@ -44,8 +44,8 @@ properties:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: Sets TDM RX capture edge.
     enum:
-          - 0 # Rising edge
-          - 1 # Falling edge
+      - 0 # Rising edge
+      - 1 # Falling edge
 
   '#sound-dai-cells':
     const: 1
diff --git a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
index e84d4a20c633..f578f17f3e04 100644
--- a/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
+++ b/Documentation/devicetree/bindings/sound/tlv320adcx140.yaml
@@ -32,32 +32,32 @@ properties:
   reg:
     maxItems: 1
     description: |
-       I2C addresss of the device can be one of these 0x4c, 0x4d, 0x4e or 0x4f
+      I2C addresss of the device can be one of these 0x4c, 0x4d, 0x4e or 0x4f
 
   reset-gpios:
     description: |
-       GPIO used for hardware reset.
+      GPIO used for hardware reset.
 
   areg-supply:
-      description: |
-       Regulator with AVDD at 3.3V.  If not defined then the internal regulator
-       is enabled.
+    description: |
+      Regulator with AVDD at 3.3V.  If not defined then the internal regulator
+      is enabled.
 
   ti,mic-bias-source:
     description: |
-       Indicates the source for MIC Bias.
-       0 - Mic bias is set to VREF
-       1 - Mic bias is set to VREF × 1.096
-       6 - Mic bias is set to AVDD
+      Indicates the source for MIC Bias.
+      0 - Mic bias is set to VREF
+      1 - Mic bias is set to VREF × 1.096
+      6 - Mic bias is set to AVDD
     $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1, 6]
 
   ti,vref-source:
     description: |
-       Indicates the source for MIC Bias.
-       0 - Set VREF to 2.75V
-       1 - Set VREF to 2.5V
-       2 - Set VREF to 1.375V
+      Indicates the source for MIC Bias.
+      0 - Set VREF to 2.75V
+      1 - Set VREF to 2.5V
+      2 - Set VREF to 1.375V
     $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1, 2]
 
@@ -109,7 +109,7 @@ properties:
     default: [0, 0, 0, 0]
 
 patternProperties:
- '^ti,gpo-config-[1-4]$':
+  '^ti,gpo-config-[1-4]$':
     $ref: /schemas/types.yaml#/definitions/uint32-array
     description: |
        Defines the configuration and output driver for the general purpose
diff --git a/Documentation/devicetree/bindings/spi/allwinner,sun6i-a31-spi.yaml b/Documentation/devicetree/bindings/spi/allwinner,sun6i-a31-spi.yaml
index 243a6b1e66ea..7866a655d81c 100644
--- a/Documentation/devicetree/bindings/spi/allwinner,sun6i-a31-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/allwinner,sun6i-a31-spi.yaml
@@ -22,10 +22,10 @@ properties:
       - const: allwinner,sun6i-a31-spi
       - const: allwinner,sun8i-h3-spi
       - items:
-        - enum:
-          - allwinner,sun8i-r40-spi
-          - allwinner,sun50i-h6-spi
-        - const: allwinner,sun8i-h3-spi
+          - enum:
+              - allwinner,sun8i-r40-spi
+              - allwinner,sun50i-h6-spi
+          - const: allwinner,sun8i-h3-spi
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/spi/fsl-imx-cspi.yaml b/Documentation/devicetree/bindings/spi/fsl-imx-cspi.yaml
index 6e44c9c2aeba..1b50cedbfb3e 100644
--- a/Documentation/devicetree/bindings/spi/fsl-imx-cspi.yaml
+++ b/Documentation/devicetree/bindings/spi/fsl-imx-cspi.yaml
@@ -23,19 +23,19 @@ properties:
       - const: fsl,imx51-ecspi
       - const: fsl,imx53-ecspi
       - items:
-        - enum:
-          - fsl,imx50-ecspi
-          - fsl,imx6q-ecspi
-          - fsl,imx6sx-ecspi
-          - fsl,imx6sl-ecspi
-          - fsl,imx6sll-ecspi
-          - fsl,imx6ul-ecspi
-          - fsl,imx7d-ecspi
-          - fsl,imx8mq-ecspi
-          - fsl,imx8mm-ecspi
-          - fsl,imx8mn-ecspi
-          - fsl,imx8mp-ecspi
-        - const: fsl,imx51-ecspi
+          - enum:
+              - fsl,imx50-ecspi
+              - fsl,imx6q-ecspi
+              - fsl,imx6sx-ecspi
+              - fsl,imx6sl-ecspi
+              - fsl,imx6sll-ecspi
+              - fsl,imx6ul-ecspi
+              - fsl,imx7d-ecspi
+              - fsl,imx8mq-ecspi
+              - fsl,imx8mm-ecspi
+              - fsl,imx8mn-ecspi
+              - fsl,imx8mp-ecspi
+          - const: fsl,imx51-ecspi
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml b/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml
index 4ddb42a4ae05..9102feae90a2 100644
--- a/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/mikrotik,rb4xx-spi.yaml
@@ -33,4 +33,5 @@ examples:
         reg = <0x1f000000 0x10>;
     };
 
-...
\ No newline at end of file
+...
+
diff --git a/Documentation/devicetree/bindings/spi/spi-mux.yaml b/Documentation/devicetree/bindings/spi/spi-mux.yaml
index 0ae692dc28b5..3d3fed63409b 100644
--- a/Documentation/devicetree/bindings/spi/spi-mux.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-mux.yaml
@@ -43,47 +43,47 @@ properties:
     maxItems: 1
 
 required:
-   - compatible
-   - reg
-   - spi-max-frequency
-   - mux-controls
+  - compatible
+  - reg
+  - spi-max-frequency
+  - mux-controls
 
 examples:
-   - |
-     #include <dt-bindings/gpio/gpio.h>
-     mux: mux-controller {
-       compatible = "gpio-mux";
-       #mux-control-cells = <0>;
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    mux: mux-controller {
+        compatible = "gpio-mux";
+        #mux-control-cells = <0>;
 
-       mux-gpios = <&gpio0 3 GPIO_ACTIVE_HIGH>;
-     };
+        mux-gpios = <&gpio0 3 GPIO_ACTIVE_HIGH>;
+    };
 
-     spi {
-       #address-cells = <1>;
-       #size-cells = <0>;
-       spi@0 {
-         compatible = "spi-mux";
-         reg = <0>;
-         #address-cells = <1>;
-         #size-cells = <0>;
-         spi-max-frequency = <100000000>;
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        spi@0 {
+            compatible = "spi-mux";
+            reg = <0>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+            spi-max-frequency = <100000000>;
 
-         mux-controls = <&mux>;
+            mux-controls = <&mux>;
 
-         spi-flash@0 {
-           compatible = "jedec,spi-nor";
-           reg = <0>;
-           #address-cells = <1>;
-           #size-cells = <0>;
-           spi-max-frequency = <40000000>;
-         };
+            spi-flash@0 {
+                compatible = "jedec,spi-nor";
+                reg = <0>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+                spi-max-frequency = <40000000>;
+            };
 
-         spi-device@1 {
-           compatible = "lineartechnology,ltc2488";
-           reg = <1>;
-           #address-cells = <1>;
-           #size-cells = <0>;
-           spi-max-frequency = <10000000>;
-         };
-       };
-     };
+            spi-device@1 {
+                compatible = "lineartechnology,ltc2488";
+                reg = <1>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+                spi-max-frequency = <10000000>;
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/spi/spi-rockchip.yaml b/Documentation/devicetree/bindings/spi/spi-rockchip.yaml
index 81ad4b761502..74dc6185eced 100644
--- a/Documentation/devicetree/bindings/spi/spi-rockchip.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-rockchip.yaml
@@ -26,13 +26,13 @@ properties:
       - const: rockchip,rv1108-spi
       - items:
           - enum:
-            - rockchip,px30-spi
-            - rockchip,rk3188-spi
-            - rockchip,rk3288-spi
-            - rockchip,rk3308-spi
-            - rockchip,rk3328-spi
-            - rockchip,rk3368-spi
-            - rockchip,rk3399-spi
+              - rockchip,px30-spi
+              - rockchip,rk3188-spi
+              - rockchip,rk3288-spi
+              - rockchip,rk3308-spi
+              - rockchip,rk3328-spi
+              - rockchip,rk3368-spi
+              - rockchip,rk3399-spi
           - const: rockchip,rk3066-spi
 
   reg:
diff --git a/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml b/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
index 5145883d932e..ad4beaf02842 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-cooling-devices.yaml
@@ -44,9 +44,9 @@ select: true
 properties:
   "#cooling-cells":
     description:
-        Must be 2, in order to specify minimum and maximum cooling state used in
-        the cooling-maps reference. The first cell is the minimum cooling state
-        and the second cell is the maximum cooling state requested.
+      Must be 2, in order to specify minimum and maximum cooling state used in
+      the cooling-maps reference. The first cell is the minimum cooling state
+      and the second cell is the maximum cooling state requested.
     const: 2
 
 examples:
diff --git a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
index 7a922f540934..a832d427e9d5 100644
--- a/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-idle.yaml
@@ -18,29 +18,28 @@ description: |
   This binding describes the thermal idle node.
 
 properties:
-   $nodename:
-     const: thermal-idle
-     description: |
-        A thermal-idle node describes the idle cooling device properties to
-        cool down efficiently the attached thermal zone.
-
-   '#cooling-cells':
-      const: 2
-      description: |
-         Must be 2, in order to specify minimum and maximum cooling state used in
-         the cooling-maps reference. The first cell is the minimum cooling state
-         and the second cell is the maximum cooling state requested.
-
-   duration-us:
-      description: |
-         The idle duration in microsecond the device should cool down.
-
-   exit-latency-us:
-      description: |
-         The exit latency constraint in microsecond for the injected
-         idle state for the device. It is the latency constraint to
-         apply when selecting an idle state from among all the present
-         ones.
+  $nodename:
+    const: thermal-idle
+    description: |
+      A thermal-idle node describes the idle cooling device properties to
+      cool down efficiently the attached thermal zone.
+
+  '#cooling-cells':
+    const: 2
+    description: |
+      Must be 2, in order to specify minimum and maximum cooling state used in
+      the cooling-maps reference. The first cell is the minimum cooling state
+      and the second cell is the maximum cooling state requested.
+
+  duration-us:
+    description: |
+      The idle duration in microsecond the device should cool down.
+
+  exit-latency-us:
+    description: |
+      The exit latency constraint in microsecond for the injected idle state 
+      for the device. It is the latency constraint to apply when selecting an 
+      idle state from among all the present ones.
 
 required:
   - '#cooling-cells'
diff --git a/Documentation/devicetree/bindings/timer/fsl,imxgpt.yaml b/Documentation/devicetree/bindings/timer/fsl,imxgpt.yaml
index 883f7f46650b..a4f51f46b7a1 100644
--- a/Documentation/devicetree/bindings/timer/fsl,imxgpt.yaml
+++ b/Documentation/devicetree/bindings/timer/fsl,imxgpt.yaml
@@ -20,17 +20,17 @@ properties:
       - const: fsl,imx31-gpt
       - items:
           - enum:
-            - fsl,imx25-gpt
-            - fsl,imx50-gpt
-            - fsl,imx51-gpt
-            - fsl,imx53-gpt
-            - fsl,imx6q-gpt
+              - fsl,imx25-gpt
+              - fsl,imx50-gpt
+              - fsl,imx51-gpt
+              - fsl,imx53-gpt
+              - fsl,imx6q-gpt
           - const: fsl,imx31-gpt
       - const: fsl,imx6dl-gpt
       - items:
           - enum:
-            - fsl,imx6sl-gpt
-            - fsl,imx6sx-gpt
+              - fsl,imx6sl-gpt
+              - fsl,imx6sx-gpt
           - const: fsl,imx6dl-gpt
 
   reg:
diff --git a/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml b/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml
index 371fb02a4351..024bcad75101 100644
--- a/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml
+++ b/Documentation/devicetree/bindings/timer/ingenic,tcu.yaml
@@ -49,16 +49,16 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - ingenic,jz4740-tcu
-          - ingenic,jz4725b-tcu
-          - ingenic,jz4770-tcu
-          - ingenic,x1000-tcu
-        - const: simple-mfd
+          - enum:
+              - ingenic,jz4740-tcu
+              - ingenic,jz4725b-tcu
+              - ingenic,jz4770-tcu
+              - ingenic,x1000-tcu
+          - const: simple-mfd
       - items:
-        - const: ingenic,jz4780-tcu
-        - const: ingenic,jz4770-tcu
-        - const: simple-mfd
+          - const: ingenic,jz4780-tcu
+          - const: ingenic,jz4770-tcu
+          - const: simple-mfd
 
   reg:
     maxItems: 1
@@ -113,13 +113,13 @@ patternProperties:
       compatible:
         oneOf:
           - enum:
-            - ingenic,jz4740-watchdog
-            - ingenic,jz4780-watchdog
+              - ingenic,jz4740-watchdog
+              - ingenic,jz4780-watchdog
           - items:
-            - enum:
-              - ingenic,jz4770-watchdog
-              - ingenic,jz4725b-watchdog
-            - const: ingenic,jz4740-watchdog
+              - enum:
+                  - ingenic,jz4770-watchdog
+                  - ingenic,jz4725b-watchdog
+              - const: ingenic,jz4740-watchdog
 
       reg:
         maxItems: 1
@@ -143,13 +143,13 @@ patternProperties:
       compatible:
         oneOf:
           - enum:
-            - ingenic,jz4740-pwm
-            - ingenic,jz4725b-pwm
+              - ingenic,jz4740-pwm
+              - ingenic,jz4725b-pwm
           - items:
-            - enum:
-              - ingenic,jz4770-pwm
-              - ingenic,jz4780-pwm
-            - const: ingenic,jz4740-pwm
+              - enum:
+                  - ingenic,jz4770-pwm
+                  - ingenic,jz4780-pwm
+              - const: ingenic,jz4740-pwm
 
       reg:
         maxItems: 1
@@ -182,11 +182,11 @@ patternProperties:
       compatible:
         oneOf:
           - enum:
-            - ingenic,jz4725b-ost
-            - ingenic,jz4770-ost
+              - ingenic,jz4725b-ost
+              - ingenic,jz4770-ost
           - items:
-            - const: ingenic,jz4780-ost
-            - const: ingenic,jz4770-ost
+              - const: ingenic,jz4780-ost
+              - const: ingenic,jz4770-ost
 
       reg:
         maxItems: 1
diff --git a/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml b/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml
index 5d300efdf0ca..7b39e3204fb3 100644
--- a/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml
+++ b/Documentation/devicetree/bindings/timer/snps,dw-apb-timer.yaml
@@ -27,8 +27,8 @@ properties:
   clocks:
     minItems: 1
     items:
-       - description: Timer ticks reference clock source
-       - description: APB interface clock source
+      - description: Timer ticks reference clock source
+      - description: APB interface clock source
 
   clock-names:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index b7e94fe8643f..4ace8039840a 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -298,7 +298,7 @@ properties:
           - national,lm80
             # Temperature sensor with integrated fan control
           - national,lm85
-            # ±0.33°C Accurate, 12-Bit + Sign Temperature Sensor and Thermal Window Comparator with Two-Wire Interface
+            # I2C ±0.33°C Accurate, 12-Bit + Sign Temperature Sensor and Thermal Window Comparator
           - national,lm92
             # i2c trusted platform module (TPM)
           - nuvoton,npct501
diff --git a/Documentation/devicetree/bindings/usb/dwc2.yaml b/Documentation/devicetree/bindings/usb/dwc2.yaml
index 4ff632d82858..ffa157a0fce7 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.yaml
+++ b/Documentation/devicetree/bindings/usb/dwc2.yaml
@@ -19,24 +19,24 @@ properties:
           - const: snps,dwc2
       - items:
           - enum:
-            - rockchip,px30-usb
-            - rockchip,rk3036-usb
-            - rockchip,rk3188-usb
-            - rockchip,rk3228-usb
-            - rockchip,rk3288-usb
-            - rockchip,rk3328-usb
-            - rockchip,rk3368-usb
-            - rockchip,rv1108-usb
+              - rockchip,px30-usb
+              - rockchip,rk3036-usb
+              - rockchip,rk3188-usb
+              - rockchip,rk3228-usb
+              - rockchip,rk3288-usb
+              - rockchip,rk3328-usb
+              - rockchip,rk3368-usb
+              - rockchip,rv1108-usb
           - const: rockchip,rk3066-usb
           - const: snps,dwc2
       - const: lantiq,arx100-usb
       - const: lantiq,xrx200-usb
       - items:
           - enum:
-            - amlogic,meson8-usb
-            - amlogic,meson8b-usb
-            - amlogic,meson-gxbb-usb
-            - amlogic,meson-g12a-usb
+              - amlogic,meson8-usb
+              - amlogic,meson8b-usb
+              - amlogic,meson-gxbb-usb
+              - amlogic,meson-g12a-usb
           - const: snps,dwc2
       - const: amcc,dwc-otg
       - const: snps,dwc2
@@ -116,12 +116,13 @@ properties:
 
   snps,need-phy-for-wake:
     $ref: /schemas/types.yaml#/definitions/flag
-    description: If present indicates that the phy needs to be left on for remote wakeup during suspend.
+    description: If present indicates that the phy needs to be left on for 
+      remote wakeup during suspend.
 
   snps,reset-phy-on-wake:
     $ref: /schemas/types.yaml#/definitions/flag
-    description: If present indicates that we need to reset the PHY when we detect a wakeup.
-                 This is due to a hardware errata.
+    description: If present indicates that we need to reset the PHY when we 
+      detect a wakeup. This is due to a hardware errata.
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
index 69f3f26d1207..247ef00381ea 100644
--- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
@@ -80,7 +80,7 @@ properties:
   companion:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-     Phandle of a companion.
+      Phandle of a companion.
 
   phys:
     description: PHY specifier for the USB PHY
diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
index c334aea6b59d..678396eeeb78 100644
--- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
+++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
@@ -16,11 +16,11 @@ properties:
   compatible:
     oneOf:
       - enum:
-        - ingenic,jz4770-musb
-        - ingenic,jz4740-musb
+          - ingenic,jz4770-musb
+          - ingenic,jz4740-musb
       - items:
-        - const: ingenic,jz4725b-musb
-        - const: ingenic,jz4740-musb
+          - const: ingenic,jz4725b-musb
+          - const: ingenic,jz4740-musb
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
index 0073763a30d8..196589c93373 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra-xudc.yaml
@@ -57,11 +57,11 @@ properties:
     minItems: 4
     maxItems: 5
     items:
-     - const: dev
-     - const: ss
-     - const: ss_src
-     - const: fs_src
-     - const: hs_src
+      - const: dev
+      - const: ss
+      - const: ss_src
+      - const: fs_src
+      - const: hs_src
 
   power-domains:
     items:
diff --git a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
index 90750255792f..484fc1091d7c 100644
--- a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
@@ -19,9 +19,9 @@ properties:
 
   power-domains:
     description:
-       PM domain provider node and an args specifier containing
-       the USB device id value. See,
-       Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+      PM domain provider node and an args specifier containing
+      the USB device id value. See,
+      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
 
   clocks:
     description: Clock phandles to usb2_refclk and lpm_clk
diff --git a/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml b/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
index 804b9b4f6654..c1b19fc5d0a2 100644
--- a/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
@@ -13,8 +13,8 @@ properties:
   compatible:
     items:
       - enum:
-        - ti,keystone-dwc3
-        - ti,am654-dwc3
+          - ti,keystone-dwc3
+          - ti,am654-dwc3
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index f3d847832fdc..2baee2c817c1 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -993,7 +993,8 @@ patternProperties:
   "^sst,.*":
     description: Silicon Storage Technology, Inc.
   "^sstar,.*":
-    description: Xiamen Xingchen(SigmaStar) Technology Co., Ltd. (formerly part of MStar Semiconductor, Inc.)
+    description: Xiamen Xingchen(SigmaStar) Technology Co., Ltd. 
+      (formerly part of MStar Semiconductor, Inc.)
   "^st,.*":
     description: STMicroelectronics
   "^starry,.*":
-- 
2.25.1

