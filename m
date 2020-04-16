Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2DE1AB50F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 02:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405822AbgDPA4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 20:56:22 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34783 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405193AbgDPA4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 20:56:00 -0400
Received: by mail-oi1-f195.google.com with SMTP id x10so5820023oie.1;
        Wed, 15 Apr 2020 17:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eClXGZSWzJvd/DoV8OQnLad2ik2PHMQB1UFXcLxOlyI=;
        b=a2x9dSgmdXQR6cKsQquTIZjfL9wl4qscHwQBfQ3ONbHGRol4qFIr2rYCPOgw57I2Bv
         ewxdMKJ+67k3I7gSQrF0QI1zCGT78gDTKHvzBaxnRvobTpFx197sJcsYBE2PsPDatiM3
         yNFeE82Ms+khOscQa8wt5bmlPIhSfx2e9ZU+wnXwhWLNqWdwN849NRVvVaVrJWnJyuwS
         JUDYt66IJY5JlAVljZFGXlZ0GQMP/qeneZ2XKHa324fNRZdedT1Q9l6zD3AyNi9tr4C6
         xhUeRHRK1Gl41DCf/reW+5Xr20N0AROaevIZARkC8C4M6q8ZSzfJdMqE3J3e1Wy5kymS
         DSsA==
X-Gm-Message-State: AGi0Pua9K7u3s0lW/uWQo1Wts//gfuFgkm2/+TZxVEdu+sMTlf/sapVv
        sHFVhXOjK/ewaFHvberEmRg67cI=
X-Google-Smtp-Source: APiQypJcmhkLoxiza+Hcqr+q/TETJrB0u/CR0IpN7QMM7LB3ELKlyz7AeJlLvikTUJNxY1wOGLGAkA==
X-Received: by 2002:aca:6243:: with SMTP id w64mr1452526oib.28.1586998553596;
        Wed, 15 Apr 2020 17:55:53 -0700 (PDT)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id s13sm7380326oov.28.2020.04.15.17.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 17:55:52 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: Clean-up schema indentation formatting
Date:   Wed, 15 Apr 2020 19:55:48 -0500
Message-Id: <20200416005549.9683-1-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix various inconsistencies in schema indentation. Most of these are
list indentation which should be 2 spaces more than the start of the
enclosing keyword. This doesn't matter functionally, but affects running
scripts which do transforms on the schema files.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/arm/altera.yaml       |  6 +-
 .../amlogic/amlogic,meson-gx-ao-secure.yaml   |  2 +-
 .../devicetree/bindings/arm/bitmain.yaml      |  2 +-
 .../devicetree/bindings/arm/nxp/lpc32xx.yaml  |  9 ++-
 .../bindings/arm/socionext/uniphier.yaml      | 26 ++++----
 .../bindings/arm/stm32/st,mlahb.yaml          |  2 +-
 .../bindings/arm/stm32/st,stm32-syscon.yaml   |  6 +-
 .../bindings/ata/faraday,ftide010.yaml        |  4 +-
 .../bindings/bus/allwinner,sun8i-a23-rsb.yaml |  4 +-
 .../clock/allwinner,sun4i-a10-gates-clk.yaml  |  8 +--
 .../devicetree/bindings/clock/fsl,plldig.yaml | 17 +++--
 .../devicetree/bindings/clock/qcom,mmcc.yaml  | 16 ++---
 .../bindings/connector/usb-connector.yaml     |  6 +-
 .../crypto/allwinner,sun4i-a10-crypto.yaml    | 14 ++--
 .../bindings/crypto/allwinner,sun8i-ce.yaml   | 16 ++---
 .../bindings/crypto/amlogic,gxl-crypto.yaml   |  2 +-
 .../display/allwinner,sun4i-a10-hdmi.yaml     | 40 ++++++------
 .../display/allwinner,sun4i-a10-tcon.yaml     | 58 ++++++++---------
 .../display/allwinner,sun6i-a31-mipi-dsi.yaml | 28 ++++----
 .../display/allwinner,sun8i-a83t-dw-hdmi.yaml | 10 +--
 .../bindings/display/bridge/lvds-codec.yaml   | 18 +++---
 .../display/panel/sony,acx424akp.yaml         |  2 +-
 .../display/panel/xinpeng,xpp055c272.yaml     |  4 +-
 .../bindings/display/renesas,cmm.yaml         | 16 ++---
 .../devicetree/bindings/dma/ti/k3-udma.yaml   |  8 +--
 .../bindings/gpio/brcm,xgs-iproc-gpio.yaml    |  2 +-
 .../bindings/gpu/arm,mali-midgard.yaml        | 18 +++---
 .../devicetree/bindings/gpu/vivante,gc.yaml   |  2 +-
 .../devicetree/bindings/i2c/i2c-rk3x.yaml     | 10 +--
 .../bindings/iio/adc/adi,ad7124.yaml          |  4 +-
 .../bindings/iio/adc/lltc,ltc2496.yaml        |  6 +-
 .../input/allwinner,sun4i-a10-lradc-keys.yaml |  4 +-
 .../bindings/input/touchscreen/goodix.yaml    |  2 +-
 .../bindings/interconnect/qcom,msm8916.yaml   |  4 +-
 .../bindings/interconnect/qcom,msm8974.yaml   |  4 +-
 .../bindings/interconnect/qcom,qcs404.yaml    |  4 +-
 .../allwinner,sun7i-a20-sc-nmi.yaml           | 12 ++--
 .../intel,ixp4xx-interrupt.yaml               |  8 +--
 .../interrupt-controller/st,stm32-exti.yaml   | 12 ++--
 .../bindings/iommu/samsung,sysmmu.yaml        | 10 +--
 .../bindings/mailbox/st,stm32-ipcc.yaml       |  2 +-
 .../media/allwinner,sun4i-a10-csi.yaml        | 28 ++++----
 .../bindings/media/amlogic,gx-vdec.yaml       | 14 ++--
 .../bindings/media/renesas,ceu.yaml           | 28 ++++----
 .../bindings/media/renesas,vin.yaml           |  8 +--
 .../devicetree/bindings/media/ti,vpe.yaml     |  2 +-
 .../memory-controllers/fsl/imx8m-ddrc.yaml    |  6 +-
 .../bindings/mfd/st,stm32-lptimer.yaml        |  4 +-
 .../bindings/mfd/st,stm32-timers.yaml         |  4 +-
 .../devicetree/bindings/mfd/syscon.yaml       | 12 ++--
 .../devicetree/bindings/mmc/cdns,sdhci.yaml   |  2 +-
 .../bindings/mmc/rockchip-dw-mshc.yaml        | 16 ++---
 .../bindings/mmc/socionext,uniphier-sd.yaml   | 14 ++--
 .../devicetree/bindings/mtd/denali,nand.yaml  |  4 +-
 .../net/allwinner,sun8i-a83t-emac.yaml        |  4 +-
 .../bindings/net/can/bosch,m_can.yaml         | 52 +++++++--------
 .../bindings/net/renesas,ether.yaml           |  4 +-
 .../bindings/net/ti,cpsw-switch.yaml          | 12 ++--
 .../bindings/net/ti,davinci-mdio.yaml         | 27 ++++----
 .../bindings/phy/intel,lgm-emmc-phy.yaml      |  2 +-
 .../devicetree/bindings/pwm/pwm-samsung.yaml  | 16 ++---
 .../bindings/remoteproc/st,stm32-rproc.yaml   |  2 +-
 .../reset/brcm,bcm7216-pcie-sata-rescal.yaml  |  4 +-
 .../devicetree/bindings/rtc/st,stm32-rtc.yaml | 38 +++++------
 .../bindings/serial/amlogic,meson-uart.yaml   | 16 ++---
 .../devicetree/bindings/serial/rs485.yaml     | 17 ++---
 .../bindings/soc/amlogic/amlogic,canvas.yaml  | 10 +--
 .../bindings/sound/renesas,fsi.yaml           | 16 ++---
 .../bindings/spi/qcom,spi-qcom-qspi.yaml      | 10 +--
 .../devicetree/bindings/spi/renesas,hspi.yaml |  4 +-
 .../devicetree/bindings/spi/spi-pl022.yaml    |  2 +-
 .../bindings/spi/st,stm32-qspi.yaml           |  4 +-
 .../allwinner,sun4i-a10-system-control.yaml   | 64 +++++++++----------
 .../bindings/thermal/amlogic,thermal.yaml     | 10 +--
 .../bindings/timer/arm,arch_timer.yaml        |  4 +-
 .../bindings/timer/arm,arch_timer_mmio.yaml   |  4 +-
 .../devicetree/bindings/usb/dwc2.yaml         |  8 +--
 77 files changed, 450 insertions(+), 450 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/altera.yaml b/Documentation/devicetree/bindings/arm/altera.yaml
index 49e0362ddc11..b388c5aa7984 100644
--- a/Documentation/devicetree/bindings/arm/altera.yaml
+++ b/Documentation/devicetree/bindings/arm/altera.yaml
@@ -13,8 +13,8 @@ properties:
   compatible:
     items:
       - enum:
-        - altr,socfpga-cyclone5
-        - altr,socfpga-arria5
-        - altr,socfpga-arria10
+          - altr,socfpga-cyclone5
+          - altr,socfpga-arria5
+          - altr,socfpga-arria10
       - const: altr,socfpga
 ...
diff --git a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
index 66213bd95e6e..6cc74523ebfd 100644
--- a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
+++ b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
@@ -25,7 +25,7 @@ select:

 properties:
   compatible:
-   items:
+    items:
       - const: amlogic,meson-gx-ao-secure
       - const: syscon

diff --git a/Documentation/devicetree/bindings/arm/bitmain.yaml b/Documentation/devicetree/bindings/arm/bitmain.yaml
index 0efdb4ac028e..5cd5b36cff2d 100644
--- a/Documentation/devicetree/bindings/arm/bitmain.yaml
+++ b/Documentation/devicetree/bindings/arm/bitmain.yaml
@@ -13,6 +13,6 @@ properties:
   compatible:
     items:
       - enum:
-        - bitmain,sophon-edge
+          - bitmain,sophon-edge
       - const: bitmain,bm1880
 ...
diff --git a/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml b/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
index 07f39d3eee7e..f7f024910e71 100644
--- a/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
+++ b/Documentation/devicetree/bindings/arm/nxp/lpc32xx.yaml
@@ -17,9 +17,8 @@ properties:
           - nxp,lpc3230
           - nxp,lpc3240
       - items:
-        - enum:
-            - ea,ea3250
-            - phytec,phy3250
-        - const: nxp,lpc3250
-
+          - enum:
+              - ea,ea3250
+              - phytec,phy3250
+          - const: nxp,lpc3250
 ...
diff --git a/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml b/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml
index 65ad6d8a3c99..113f93b9ae55 100644
--- a/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml
+++ b/Documentation/devicetree/bindings/arm/socionext/uniphier.yaml
@@ -17,45 +17,45 @@ properties:
       - description: LD4 SoC boards
         items:
           - enum:
-            - socionext,uniphier-ld4-ref
+              - socionext,uniphier-ld4-ref
           - const: socionext,uniphier-ld4
       - description: Pro4 SoC boards
         items:
           - enum:
-            - socionext,uniphier-pro4-ace
-            - socionext,uniphier-pro4-ref
-            - socionext,uniphier-pro4-sanji
+              - socionext,uniphier-pro4-ace
+              - socionext,uniphier-pro4-ref
+              - socionext,uniphier-pro4-sanji
           - const: socionext,uniphier-pro4
       - description: sLD8 SoC boards
         items:
           - enum:
-            - socionext,uniphier-sld8-ref
+              - socionext,uniphier-sld8-ref
           - const: socionext,uniphier-sld8
       - description: PXs2 SoC boards
         items:
           - enum:
-            - socionext,uniphier-pxs2-gentil
-            - socionext,uniphier-pxs2-vodka
+              - socionext,uniphier-pxs2-gentil
+              - socionext,uniphier-pxs2-vodka
           - const: socionext,uniphier-pxs2
       - description: LD6b SoC boards
         items:
           - enum:
-            - socionext,uniphier-ld6b-ref
+              - socionext,uniphier-ld6b-ref
           - const: socionext,uniphier-ld6b
       - description: LD11 SoC boards
         items:
           - enum:
-            - socionext,uniphier-ld11-global
-            - socionext,uniphier-ld11-ref
+              - socionext,uniphier-ld11-global
+              - socionext,uniphier-ld11-ref
           - const: socionext,uniphier-ld11
       - description: LD20 SoC boards
         items:
           - enum:
-            - socionext,uniphier-ld20-global
-            - socionext,uniphier-ld20-ref
+              - socionext,uniphier-ld20-global
+              - socionext,uniphier-ld20-ref
           - const: socionext,uniphier-ld20
       - description: PXs3 SoC boards
         items:
           - enum:
-            - socionext,uniphier-pxs3-ref
+              - socionext,uniphier-pxs3-ref
           - const: socionext,uniphier-pxs3
diff --git a/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml b/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
index 55f7938c4826..9f276bc9efa0 100644
--- a/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/st,mlahb.yaml
@@ -20,7 +20,7 @@ description: |
   [2]: https://wiki.st.com/stm32mpu/wiki/STM32MP15_RAM_mapping

 allOf:
- - $ref: /schemas/simple-bus.yaml#
+  - $ref: /schemas/simple-bus.yaml#

 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
index baff80197d5a..cf5db5e273f3 100644
--- a/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
+++ b/Documentation/devicetree/bindings/arm/stm32/st,stm32-syscon.yaml
@@ -14,9 +14,9 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - st,stm32mp157-syscfg
-        - const: syscon
+          - enum:
+              - st,stm32mp157-syscfg
+          - const: syscon

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/ata/faraday,ftide010.yaml b/Documentation/devicetree/bindings/ata/faraday,ftide010.yaml
index bfc6357476fd..6451928dd2ce 100644
--- a/Documentation/devicetree/bindings/ata/faraday,ftide010.yaml
+++ b/Documentation/devicetree/bindings/ata/faraday,ftide010.yaml
@@ -26,8 +26,8 @@ properties:
     oneOf:
       - const: faraday,ftide010
       - items:
-        - const: cortina,gemini-pata
-        - const: faraday,ftide010
+          - const: cortina,gemini-pata
+          - const: faraday,ftide010

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/bus/allwinner,sun8i-a23-rsb.yaml b/Documentation/devicetree/bindings/bus/allwinner,sun8i-a23-rsb.yaml
index 80973619342d..32d33b983d66 100644
--- a/Documentation/devicetree/bindings/bus/allwinner,sun8i-a23-rsb.yaml
+++ b/Documentation/devicetree/bindings/bus/allwinner,sun8i-a23-rsb.yaml
@@ -21,8 +21,8 @@ properties:
     oneOf:
       - const: allwinner,sun8i-a23-rsb
       - items:
-        - const: allwinner,sun8i-a83t-rsb
-        - const: allwinner,sun8i-a23-rsb
+          - const: allwinner,sun8i-a83t-rsb
+          - const: allwinner,sun8i-a23-rsb

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-gates-clk.yaml b/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-gates-clk.yaml
index ed1b2126a81b..9a37a357cb4e 100644
--- a/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-gates-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/allwinner,sun4i-a10-gates-clk.yaml
@@ -52,12 +52,12 @@ properties:
       - const: allwinner,sun4i-a10-dram-gates-clk

       - items:
-        - const: allwinner,sun5i-a13-dram-gates-clk
-        - const: allwinner,sun4i-a10-gates-clk
+          - const: allwinner,sun5i-a13-dram-gates-clk
+          - const: allwinner,sun4i-a10-gates-clk

       - items:
-        - const: allwinner,sun8i-h3-apb0-gates-clk
-        - const: allwinner,sun4i-a10-gates-clk
+          - const: allwinner,sun8i-h3-apb0-gates-clk
+          - const: allwinner,sun4i-a10-gates-clk

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
index a203d5d498db..8141f22410dd 100644
--- a/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
+++ b/Documentation/devicetree/bindings/clock/fsl,plldig.yaml
@@ -28,15 +28,14 @@ properties:
     const: 0

   fsl,vco-hz:
-     description: Optional for VCO frequency of the PLL in Hertz.
-        The VCO frequency of this PLL cannot be changed during runtime
-        only at startup. Therefore, the output frequencies are very
-        limited and might not even closely match the requested frequency.
-        To work around this restriction the user may specify its own
-        desired VCO frequency for the PLL.
-     minimum: 650000000
-     maximum: 1300000000
-     default: 1188000000
+    description: Optional for VCO frequency of the PLL in Hertz. The VCO frequency
+      of this PLL cannot be changed during runtime only at startup. Therefore,
+      the output frequencies are very limited and might not even closely match
+      the requested frequency. To work around this restriction the user may specify
+      its own desired VCO frequency for the PLL.
+    minimum: 650000000
+    maximum: 1300000000
+    default: 1188000000

 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
index f684fe67db84..acc31b3991bd 100644
--- a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
@@ -15,15 +15,15 @@ description: |
   power domains.

 properties:
-  compatible :
+  compatible:
     enum:
-       - qcom,mmcc-apq8064
-       - qcom,mmcc-apq8084
-       - qcom,mmcc-msm8660
-       - qcom,mmcc-msm8960
-       - qcom,mmcc-msm8974
-       - qcom,mmcc-msm8996
-       - qcom,mmcc-msm8998
+      - qcom,mmcc-apq8064
+      - qcom,mmcc-apq8084
+      - qcom,mmcc-msm8660
+      - qcom,mmcc-msm8960
+      - qcom,mmcc-msm8974
+      - qcom,mmcc-msm8996
+      - qcom,mmcc-msm8998

   clocks:
     items:
diff --git a/Documentation/devicetree/bindings/connector/usb-connector.yaml b/Documentation/devicetree/bindings/connector/usb-connector.yaml
index 4638d7adb806..369c58e22a06 100644
--- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
+++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
@@ -144,7 +144,7 @@ required:

 examples:
   # Micro-USB connector with HS lines routed via controller (MUIC).
-  - |+
+  - |
     muic-max77843 {
       usb_con1: connector {
         compatible = "usb-b-connector";
@@ -156,7 +156,7 @@ examples:
   # USB-C connector attached to CC controller (s2mm005), HS lines routed
   # to companion PMIC (max77865), SS lines to USB3 PHY and SBU to DisplayPort.
   # DisplayPort video lines are routed to the connector via SS mux in USB3 PHY.
-  - |+
+  - |
     ccic: s2mm005 {
       usb_con2: connector {
         compatible = "usb-c-connector";
@@ -190,7 +190,7 @@ examples:

   # USB-C connector attached to a typec port controller(ptn5110), which has
   # power delivery support and enables drp.
-  - |+
+  - |
     #include <dt-bindings/usb/pd.h>
     typec: ptn5110 {
       usb_con3: connector {
diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index 8b9a8f337f16..fc823572bcff 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -15,16 +15,16 @@ properties:
     oneOf:
       - const: allwinner,sun4i-a10-crypto
       - items:
-        - const: allwinner,sun5i-a13-crypto
-        - const: allwinner,sun4i-a10-crypto
+          - const: allwinner,sun5i-a13-crypto
+          - const: allwinner,sun4i-a10-crypto
       - items:
-        - const: allwinner,sun6i-a31-crypto
-        - const: allwinner,sun4i-a10-crypto
+          - const: allwinner,sun6i-a31-crypto
+          - const: allwinner,sun4i-a10-crypto
       - items:
-        - const: allwinner,sun7i-a20-crypto
-        - const: allwinner,sun4i-a10-crypto
+          - const: allwinner,sun7i-a20-crypto
+          - const: allwinner,sun4i-a10-crypto
       - items:
-        - const: allwinner,sun8i-a33-crypto
+          - const: allwinner,sun8i-a33-crypto

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
index 2c459b8c76ff..7a60d84289cc 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
@@ -50,16 +50,16 @@ if:
         const: allwinner,sun50i-h6-crypto
 then:
   properties:
-      clocks:
-        minItems: 3
-      clock-names:
-        minItems: 3
+    clocks:
+      minItems: 3
+    clock-names:
+      minItems: 3
 else:
   properties:
-      clocks:
-        maxItems: 2
-      clock-names:
-        maxItems: 2
+    clocks:
+      maxItems: 2
+    clock-names:
+      maxItems: 2

 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index 5becc60a0e28..385b23d255c3 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -12,7 +12,7 @@ maintainers:
 properties:
   compatible:
     items:
-    - const: amlogic,gxl-crypto
+      - const: amlogic,gxl-crypto

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-hdmi.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-hdmi.yaml
index 5d4915aed1e2..75e6479397a5 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-hdmi.yaml
@@ -21,8 +21,8 @@ properties:
       - const: allwinner,sun5i-a10s-hdmi
       - const: allwinner,sun6i-a31-hdmi
       - items:
-        - const: allwinner,sun7i-a20-hdmi
-        - const: allwinner,sun5i-a10s-hdmi
+          - const: allwinner,sun7i-a20-hdmi
+          - const: allwinner,sun5i-a10s-hdmi

   reg:
     maxItems: 1
@@ -33,32 +33,32 @@ properties:
   clocks:
     oneOf:
       - items:
-        - description: The HDMI interface clock
-        - description: The HDMI module clock
-        - description: The first video PLL
-        - description: The second video PLL
+          - description: The HDMI interface clock
+          - description: The HDMI module clock
+          - description: The first video PLL
+          - description: The second video PLL

       - items:
-        - description: The HDMI interface clock
-        - description: The HDMI module clock
-        - description: The HDMI DDC clock
-        - description: The first video PLL
-        - description: The second video PLL
+          - description: The HDMI interface clock
+          - description: The HDMI module clock
+          - description: The HDMI DDC clock
+          - description: The first video PLL
+          - description: The second video PLL

   clock-names:
     oneOf:
       - items:
-        - const: ahb
-        - const: mod
-        - const: pll-0
-        - const: pll-1
+          - const: ahb
+          - const: mod
+          - const: pll-0
+          - const: pll-1

       - items:
-        - const: ahb
-        - const: mod
-        - const: ddc
-        - const: pll-0
-        - const: pll-1
+          - const: ahb
+          - const: mod
+          - const: ddc
+          - const: pll-0
+          - const: pll-1

   resets:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
index e5344c4ae226..87cb77b32ee3 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
@@ -35,26 +35,26 @@ properties:
       - const: allwinner,sun9i-a80-tcon-tv

       - items:
-        - enum:
-          - allwinner,sun7i-a20-tcon0
-          - allwinner,sun7i-a20-tcon1
-        - const: allwinner,sun7i-a20-tcon
+          - enum:
+              - allwinner,sun7i-a20-tcon0
+              - allwinner,sun7i-a20-tcon1
+          - const: allwinner,sun7i-a20-tcon

       - items:
-        - enum:
-            - allwinner,sun50i-a64-tcon-lcd
-        - const: allwinner,sun8i-a83t-tcon-lcd
+          - enum:
+              - allwinner,sun50i-a64-tcon-lcd
+          - const: allwinner,sun8i-a83t-tcon-lcd

       - items:
-        - enum:
-          - allwinner,sun8i-h3-tcon-tv
-          - allwinner,sun50i-a64-tcon-tv
-        - const: allwinner,sun8i-a83t-tcon-tv
+          - enum:
+              - allwinner,sun8i-h3-tcon-tv
+              - allwinner,sun50i-a64-tcon-tv
+          - const: allwinner,sun8i-a83t-tcon-tv

       - items:
-        - enum:
-          - allwinner,sun50i-h6-tcon-tv
-        - const: allwinner,sun8i-r40-tcon-tv
+          - enum:
+              - allwinner,sun50i-h6-tcon-tv
+          - const: allwinner,sun8i-r40-tcon-tv

   reg:
     maxItems: 1
@@ -83,37 +83,37 @@ properties:
   resets:
     anyOf:
       - items:
-        - description: TCON Reset Line
+          - description: TCON Reset Line

       - items:
-        - description: TCON Reset Line
-        - description: TCON LVDS Reset Line
+          - description: TCON Reset Line
+          - description: TCON LVDS Reset Line

       - items:
-        - description: TCON Reset Line
-        - description: TCON eDP Reset Line
+          - description: TCON Reset Line
+          - description: TCON eDP Reset Line

       - items:
-        - description: TCON Reset Line
-        - description: TCON eDP Reset Line
-        - description: TCON LVDS Reset Line
+          - description: TCON Reset Line
+          - description: TCON eDP Reset Line
+          - description: TCON LVDS Reset Line

   reset-names:
     oneOf:
       - const: lcd

       - items:
-        - const: lcd
-        - const: lvds
+          - const: lcd
+          - const: lvds

       - items:
-        - const: lcd
-        - const: edp
+          - const: lcd
+          - const: edp

       - items:
-        - const: lcd
-        - const: edp
-        - const: lvds
+          - const: lcd
+          - const: edp
+          - const: lvds

   ports:
     type: object
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml b/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml
index 9e90c2b00960..eed05b26cdf3 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun6i-a31-mipi-dsi.yaml
@@ -76,28 +76,28 @@ required:
 allOf:
   - if:
       properties:
-         compatible:
-           contains:
-             const: allwinner,sun6i-a31-mipi-dsi
+        compatible:
+          contains:
+            const: allwinner,sun6i-a31-mipi-dsi

     then:
-        properties:
-          clocks:
-            minItems: 2
+      properties:
+        clocks:
+          minItems: 2

-        required:
-          - clock-names
+      required:
+        - clock-names

   - if:
       properties:
-         compatible:
-           contains:
-             const: allwinner,sun50i-a64-mipi-dsi
+        compatible:
+          contains:
+            const: allwinner,sun50i-a64-mipi-dsi

     then:
-        properties:
-          clocks:
-            minItems: 1
+      properties:
+        clocks:
+          minItems: 1

 additionalProperties: false

diff --git a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
index 4d6795690ac3..fa4769a0b26e 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
@@ -29,11 +29,11 @@ properties:
       - const: allwinner,sun50i-h6-dw-hdmi

       - items:
-        - enum:
-          - allwinner,sun8i-h3-dw-hdmi
-          - allwinner,sun8i-r40-dw-hdmi
-          - allwinner,sun50i-a64-dw-hdmi
-        - const: allwinner,sun8i-a83t-dw-hdmi
+          - enum:
+              - allwinner,sun8i-h3-dw-hdmi
+              - allwinner,sun8i-r40-dw-hdmi
+              - allwinner,sun50i-a64-dw-hdmi
+          - const: allwinner,sun8i-a83t-dw-hdmi

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml b/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml
index 8f373029f5d2..e737951f5873 100644
--- a/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/lvds-codec.yaml
@@ -32,17 +32,17 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - ti,ds90c185       # For the TI DS90C185 FPD-Link Serializer
-          - ti,ds90c187       # For the TI DS90C187 FPD-Link Serializer
-          - ti,sn75lvds83     # For the TI SN75LVDS83 FlatLink transmitter
-        - const: lvds-encoder # Generic LVDS encoder compatible fallback
+          - enum:
+              - ti,ds90c185   # For the TI DS90C185 FPD-Link Serializer
+              - ti,ds90c187   # For the TI DS90C187 FPD-Link Serializer
+              - ti,sn75lvds83 # For the TI SN75LVDS83 FlatLink transmitter
+          - const: lvds-encoder # Generic LVDS encoder compatible fallback
       - items:
-        - enum:
-          - ti,ds90cf384a     # For the DS90CF384A FPD-Link LVDS Receiver
-        - const: lvds-decoder # Generic LVDS decoders compatible fallback
+          - enum:
+              - ti,ds90cf384a # For the DS90CF384A FPD-Link LVDS Receiver
+          - const: lvds-decoder # Generic LVDS decoders compatible fallback
       - enum:
-        - thine,thc63lvdm83d  # For the THC63LVDM83D LVDS serializer
+          - thine,thc63lvdm83d # For the THC63LVDM83D LVDS serializer

   ports:
     type: object
diff --git a/Documentation/devicetree/bindings/display/panel/sony,acx424akp.yaml b/Documentation/devicetree/bindings/display/panel/sony,acx424akp.yaml
index 185dcc8fd1f9..78d060097052 100644
--- a/Documentation/devicetree/bindings/display/panel/sony,acx424akp.yaml
+++ b/Documentation/devicetree/bindings/display/panel/sony,acx424akp.yaml
@@ -18,7 +18,7 @@ properties:
   reg: true
   reset-gpios: true
   vddi-supply:
-     description: regulator that supplies the vddi voltage
+    description: regulator that supplies the vddi voltage
   enforce-video-mode: true

 required:
diff --git a/Documentation/devicetree/bindings/display/panel/xinpeng,xpp055c272.yaml b/Documentation/devicetree/bindings/display/panel/xinpeng,xpp055c272.yaml
index d9fdb58e06b4..891de2256d22 100644
--- a/Documentation/devicetree/bindings/display/panel/xinpeng,xpp055c272.yaml
+++ b/Documentation/devicetree/bindings/display/panel/xinpeng,xpp055c272.yaml
@@ -19,9 +19,9 @@ properties:
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
diff --git a/Documentation/devicetree/bindings/display/renesas,cmm.yaml b/Documentation/devicetree/bindings/display/renesas,cmm.yaml
index a57037b9e9ba..005406c89507 100644
--- a/Documentation/devicetree/bindings/display/renesas,cmm.yaml
+++ b/Documentation/devicetree/bindings/display/renesas,cmm.yaml
@@ -21,15 +21,15 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - renesas,r8a7795-cmm
-          - renesas,r8a7796-cmm
-          - renesas,r8a77965-cmm
-          - renesas,r8a77990-cmm
-          - renesas,r8a77995-cmm
-        - const: renesas,rcar-gen3-cmm
+          - enum:
+              - renesas,r8a7795-cmm
+              - renesas,r8a7796-cmm
+              - renesas,r8a77965-cmm
+              - renesas,r8a77990-cmm
+              - renesas,r8a77995-cmm
+          - const: renesas,rcar-gen3-cmm
       - items:
-        - const: renesas,rcar-gen2-cmm
+          - const: renesas,rcar-gen2-cmm

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml b/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
index 39ea05e6e5ff..85056982a242 100644
--- a/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
+++ b/Documentation/devicetree/bindings/dma/ti/k3-udma.yaml
@@ -69,10 +69,10 @@ properties:
     maxItems: 3

   reg-names:
-   items:
-     - const: gcfg
-     - const: rchanrt
-     - const: tchanrt
+    items:
+      - const: gcfg
+      - const: rchanrt
+      - const: tchanrt

   msi-parent: true

diff --git a/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml b/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
index 5f1ed20e43ee..4f2cbd8307a7 100644
--- a/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/brcm,xgs-iproc-gpio.yaml
@@ -27,7 +27,7 @@ properties:
   gpio-controller: true

   '#gpio-cells':
-      const: 2
+    const: 2

   ngpios:
     minimum: 0
diff --git a/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml b/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
index 0407e45eb8c4..a7a67e0a42e5 100644
--- a/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
+++ b/Documentation/devicetree/bindings/gpu/arm,mali-midgard.yaml
@@ -16,33 +16,33 @@ properties:
     oneOf:
       - items:
           - enum:
-             - samsung,exynos5250-mali
+              - samsung,exynos5250-mali
           - const: arm,mali-t604
       - items:
           - enum:
-             - samsung,exynos5420-mali
+              - samsung,exynos5420-mali
           - const: arm,mali-t628
       - items:
           - enum:
-             - allwinner,sun50i-h6-mali
+              - allwinner,sun50i-h6-mali
           - const: arm,mali-t720
       - items:
           - enum:
-             - amlogic,meson-gxm-mali
-             - realtek,rtd1295-mali
+              - amlogic,meson-gxm-mali
+              - realtek,rtd1295-mali
           - const: arm,mali-t820
       - items:
           - enum:
-             - arm,juno-mali
+              - arm,juno-mali
           - const: arm,mali-t624
       - items:
           - enum:
-             - rockchip,rk3288-mali
-             - samsung,exynos5433-mali
+              - rockchip,rk3288-mali
+              - samsung,exynos5433-mali
           - const: arm,mali-t760
       - items:
           - enum:
-             - rockchip,rk3399-mali
+              - rockchip,rk3399-mali
           - const: arm,mali-t860

           # "arm,mali-t830"
diff --git a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
index 0bc4b38d5cbb..e1ac6ff5a230 100644
--- a/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
+++ b/Documentation/devicetree/bindings/gpu/vivante,gc.yaml
@@ -9,7 +9,7 @@ title: Vivante GPU Bindings
 description: Vivante GPU core devices

 maintainers:
-  -  Lucas Stach <l.stach@pengutronix.de>
+  - Lucas Stach <l.stach@pengutronix.de>

 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.yaml b/Documentation/devicetree/bindings/i2c/i2c-rk3x.yaml
index 61eac76c84c4..790aa7218ee0 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-rk3x.yaml
+++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.yaml
@@ -28,14 +28,14 @@ properties:
       - const: rockchip,rk3399-i2c
       - items:
           - enum:
-            - rockchip,rk3036-i2c
-            - rockchip,rk3368-i2c
+              - rockchip,rk3036-i2c
+              - rockchip,rk3368-i2c
           - const: rockchip,rk3288-i2c
       - items:
           - enum:
-            - rockchip,px30-i2c
-            - rockchip,rk3308-i2c
-            - rockchip,rk3328-i2c
+              - rockchip,px30-i2c
+              - rockchip,rk3308-i2c
+              - rockchip,rk3328-i2c
           - const: rockchip,rk3399-i2c

   reg:
diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
index f0934b295edc..97087a45ce54 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7124.yaml
@@ -72,8 +72,8 @@ patternProperties:
           The channel number. It can have up to 8 channels on ad7124-4
           and 16 channels on ad7124-8, numbered from 0 to 15.
         items:
-         minimum: 0
-         maximum: 15
+          minimum: 0
+          maximum: 15

       adi,reference-select:
         description: |
diff --git a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
index 118809a03279..97f521d654ea 100644
--- a/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/lltc,ltc2496.yaml
@@ -7,9 +7,9 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Linear Technology / Analog Devices LTC2496 ADC

 maintainers:
- - Lars-Peter Clausen <lars@metafoo.de>
- - Michael Hennerich <Michael.Hennerich@analog.com>
- - Stefan Popa <stefan.popa@analog.com>
+  - Lars-Peter Clausen <lars@metafoo.de>
+  - Michael Hennerich <Michael.Hennerich@analog.com>
+  - Stefan Popa <stefan.popa@analog.com>

 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml b/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml
index 5b3b71c9c018..512a6af5aa42 100644
--- a/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml
+++ b/Documentation/devicetree/bindings/input/allwinner,sun4i-a10-lradc-keys.yaml
@@ -16,8 +16,8 @@ properties:
       - const: allwinner,sun4i-a10-lradc-keys
       - const: allwinner,sun8i-a83t-r-lradc
       - items:
-        - const: allwinner,sun50i-a64-lradc
-        - const: allwinner,sun8i-a83t-r-lradc
+          - const: allwinner,sun50i-a64-lradc
+          - const: allwinner,sun8i-a83t-r-lradc

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml b/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
index c8ea9434c9cc..e81cfa56f25a 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
+++ b/Documentation/devicetree/bindings/input/touchscreen/goodix.yaml
@@ -63,7 +63,7 @@ required:
   - interrupts

 examples:
-- |
+  - |
     i2c {
       #address-cells = <1>;
       #size-cells = <0>;
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,msm8916.yaml b/Documentation/devicetree/bindings/interconnect/qcom,msm8916.yaml
index 4107e60cab12..e1009ae4e8f7 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,msm8916.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,msm8916.yaml
@@ -10,8 +10,8 @@ maintainers:
   - Georgi Djakov <georgi.djakov@linaro.org>

 description: |
-   The Qualcomm MSM8916 interconnect providers support adjusting the
-   bandwidth requirements between the various NoC fabrics.
+  The Qualcomm MSM8916 interconnect providers support adjusting the
+  bandwidth requirements between the various NoC fabrics.

 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,msm8974.yaml b/Documentation/devicetree/bindings/interconnect/qcom,msm8974.yaml
index 9af3c6e59cff..8004c4baf397 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,msm8974.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,msm8974.yaml
@@ -10,8 +10,8 @@ maintainers:
   - Brian Masney <masneyb@onstation.org>

 description: |
-   The Qualcomm MSM8974 interconnect providers support setting system
-   bandwidth requirements between various network-on-chip fabrics.
+  The Qualcomm MSM8974 interconnect providers support setting system
+  bandwidth requirements between various network-on-chip fabrics.

 properties:
   reg:
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,qcs404.yaml b/Documentation/devicetree/bindings/interconnect/qcom,qcs404.yaml
index 8d65c5f80679..3fbb8785fbc9 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,qcs404.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,qcs404.yaml
@@ -10,8 +10,8 @@ maintainers:
   - Georgi Djakov <georgi.djakov@linaro.org>

 description: |
-   The Qualcomm QCS404 interconnect providers support adjusting the
-   bandwidth requirements between the various NoC fabrics.
+  The Qualcomm QCS404 interconnect providers support adjusting the
+  bandwidth requirements between the various NoC fabrics.

 properties:
   reg:
diff --git a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun7i-a20-sc-nmi.yaml b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun7i-a20-sc-nmi.yaml
index cf09055da78b..7cd6b8bacfa0 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun7i-a20-sc-nmi.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun7i-a20-sc-nmi.yaml
@@ -27,15 +27,15 @@ properties:
         deprecated: true
       - const: allwinner,sun7i-a20-sc-nmi
       - items:
-        - const: allwinner,sun8i-a83t-r-intc
-        - const: allwinner,sun6i-a31-r-intc
+          - const: allwinner,sun8i-a83t-r-intc
+          - const: allwinner,sun6i-a31-r-intc
       - const: allwinner,sun9i-a80-sc-nmi
       - items:
-        - const: allwinner,sun50i-a64-r-intc
-        - const: allwinner,sun6i-a31-r-intc
+          - const: allwinner,sun50i-a64-r-intc
+          - const: allwinner,sun6i-a31-r-intc
       - items:
-        - const: allwinner,sun50i-h6-r-intc
-        - const: allwinner,sun6i-a31-r-intc
+          - const: allwinner,sun50i-h6-r-intc
+          - const: allwinner,sun6i-a31-r-intc

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx-interrupt.yaml b/Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx-interrupt.yaml
index ccc507f384d2..14dced11877b 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx-interrupt.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/intel,ixp4xx-interrupt.yaml
@@ -25,10 +25,10 @@ properties:
   compatible:
     items:
       - enum:
-        - intel,ixp42x-interrupt
-        - intel,ixp43x-interrupt
-        - intel,ixp45x-interrupt
-        - intel,ixp46x-interrupt
+          - intel,ixp42x-interrupt
+          - intel,ixp43x-interrupt
+          - intel,ixp45x-interrupt
+          - intel,ixp46x-interrupt

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml b/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
index 9e5c6608b4e3..2a5b29567926 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/st,stm32-exti.yaml
@@ -14,13 +14,13 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - st,stm32-exti
-          - st,stm32h7-exti
+          - enum:
+              - st,stm32-exti
+              - st,stm32h7-exti
       - items:
-        - enum:
-          - st,stm32mp1-exti
-        - const: syscon
+          - enum:
+              - st,stm32mp1-exti
+          - const: syscon

   "#interrupt-cells":
     const: 2
diff --git a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml
index 0e33cd9e010e..af51b91c893e 100644
--- a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml
+++ b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.yaml
@@ -54,13 +54,13 @@ properties:
   clock-names:
     oneOf:
       - items:
-        - const: sysmmu
+          - const: sysmmu
       - items:
-        - const: sysmmu
-        - const: master
+          - const: sysmmu
+          - const: master
       - items:
-        - const: aclk
-        - const: pclk
+          - const: aclk
+          - const: pclk

   "#iommu-cells":
     const: 0
diff --git a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
index 5b13d6672996..db851541d619 100644
--- a/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
+++ b/Documentation/devicetree/bindings/mailbox/st,stm32-ipcc.yaml
@@ -24,7 +24,7 @@ properties:
     maxItems: 1

   clocks:
-     maxItems: 1
+    maxItems: 1

   interrupts:
     items:
diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
index 8453ee340b9f..09318830db47 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
@@ -20,11 +20,11 @@ properties:
       - const: allwinner,sun4i-a10-csi1
       - const: allwinner,sun7i-a20-csi0
       - items:
-        - const: allwinner,sun7i-a20-csi1
-        - const: allwinner,sun4i-a10-csi1
+          - const: allwinner,sun7i-a20-csi1
+          - const: allwinner,sun4i-a10-csi1
       - items:
-        - const: allwinner,sun8i-r40-csi0
-        - const: allwinner,sun7i-a20-csi0
+          - const: allwinner,sun8i-r40-csi0
+          - const: allwinner,sun7i-a20-csi0

   reg:
     maxItems: 1
@@ -35,24 +35,24 @@ properties:
   clocks:
     oneOf:
       - items:
-        - description: The CSI interface clock
-        - description: The CSI DRAM clock
+          - description: The CSI interface clock
+          - description: The CSI DRAM clock

       - items:
-        - description: The CSI interface clock
-        - description: The CSI ISP clock
-        - description: The CSI DRAM clock
+          - description: The CSI interface clock
+          - description: The CSI ISP clock
+          - description: The CSI DRAM clock

   clock-names:
     oneOf:
       - items:
-        - const: bus
-        - const: ram
+          - const: bus
+          - const: ram

       - items:
-        - const: bus
-        - const: isp
-        - const: ram
+          - const: bus
+          - const: isp
+          - const: ram

   resets:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
index 37d77e065491..5a1da4029c37 100644
--- a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
+++ b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
@@ -29,14 +29,14 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - amlogic,gxbb-vdec # GXBB (S905)
-          - amlogic,gxl-vdec # GXL (S905X, S905D)
-          - amlogic,gxm-vdec # GXM (S912)
-        - const: amlogic,gx-vdec
+          - enum:
+              - amlogic,gxbb-vdec # GXBB (S905)
+              - amlogic,gxl-vdec # GXL (S905X, S905D)
+              - amlogic,gxm-vdec # GXM (S912)
+          - const: amlogic,gx-vdec
       - enum:
-        - amlogic,g12a-vdec # G12A (S905X2, S905D2)
-        - amlogic,sm1-vdec # SM1 (S905X3, S905D3)
+          - amlogic,g12a-vdec # G12A (S905X2, S905D2)
+          - amlogic,sm1-vdec # SM1 (S905X3, S905D3)

   interrupts:
     minItems: 2
diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.yaml b/Documentation/devicetree/bindings/media/renesas,ceu.yaml
index fcb5f13704a5..f2393458814e 100644
--- a/Documentation/devicetree/bindings/media/renesas,ceu.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.yaml
@@ -32,23 +32,23 @@ properties:
     additionalProperties: false

     properties:
-       endpoint:
-         type: object
-         additionalProperties: false
+      endpoint:
+        type: object
+        additionalProperties: false

          # Properties described in
          # Documentation/devicetree/bindings/media/video-interfaces.txt
-         properties:
-           remote-endpoint: true
-           hsync-active: true
-           vsync-active: true
-           field-even-active: false
-           bus-width:
-             enum: [8, 16]
-             default: 8
-
-         required:
-           - remote-endpoint
+        properties:
+          remote-endpoint: true
+          hsync-active: true
+          vsync-active: true
+          field-even-active: false
+          bus-width:
+            enum: [8, 16]
+            default: 8
+
+        required:
+          - remote-endpoint

     required:
       - endpoint
diff --git a/Documentation/devicetree/bindings/media/renesas,vin.yaml b/Documentation/devicetree/bindings/media/renesas,vin.yaml
index 1ec947b4781f..ecc09f1124d4 100644
--- a/Documentation/devicetree/bindings/media/renesas,vin.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,vin.yaml
@@ -261,13 +261,13 @@ properties:

         anyOf:
           - required:
-            - endpoint@0
+              - endpoint@0
           - required:
-            - endpoint@1
+              - endpoint@1
           - required:
-            - endpoint@2
+              - endpoint@2
           - required:
-            - endpoint@3
+              - endpoint@3

         additionalProperties: false

diff --git a/Documentation/devicetree/bindings/media/ti,vpe.yaml b/Documentation/devicetree/bindings/media/ti,vpe.yaml
index f3a8a350e85f..ef473f287399 100644
--- a/Documentation/devicetree/bindings/media/ti,vpe.yaml
+++ b/Documentation/devicetree/bindings/media/ti,vpe.yaml
@@ -17,7 +17,7 @@ description: |-

 properties:
   compatible:
-      const: ti,dra7-vpe
+    const: ti,dra7-vpe

   reg:
     items:
diff --git a/Documentation/devicetree/bindings/memory-controllers/fsl/imx8m-ddrc.yaml b/Documentation/devicetree/bindings/memory-controllers/fsl/imx8m-ddrc.yaml
index c9e6c22cb5be..445e46feda69 100644
--- a/Documentation/devicetree/bindings/memory-controllers/fsl/imx8m-ddrc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/fsl/imx8m-ddrc.yaml
@@ -25,9 +25,9 @@ properties:
   compatible:
     items:
       - enum:
-        - fsl,imx8mn-ddrc
-        - fsl,imx8mm-ddrc
-        - fsl,imx8mq-ddrc
+          - fsl,imx8mn-ddrc
+          - fsl,imx8mm-ddrc
+          - fsl,imx8mq-ddrc
       - const: fsl,imx8m-ddrc

   reg:
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
index ddf190cb800b..e675611f80d0 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
@@ -66,8 +66,8 @@ patternProperties:
       reg:
         description: Identify trigger hardware block.
         items:
-         minimum: 0
-         maximum: 2
+          minimum: 0
+          maximum: 2

     required:
       - compatible
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
index 590849ee9f32..4acda7ce3b44 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
@@ -102,8 +102,8 @@ patternProperties:
       reg:
         description: Identify trigger hardware block.
         items:
-         minimum: 0
-         maximum: 16
+          minimum: 0
+          maximum: 16

     required:
       - compatible
diff --git a/Documentation/devicetree/bindings/mfd/syscon.yaml b/Documentation/devicetree/bindings/mfd/syscon.yaml
index 39375e4313d2..7a39486b215a 100644
--- a/Documentation/devicetree/bindings/mfd/syscon.yaml
+++ b/Documentation/devicetree/bindings/mfd/syscon.yaml
@@ -33,13 +33,13 @@ properties:
   compatible:
     anyOf:
       - items:
-        - enum:
-          - allwinner,sun8i-a83t-system-controller
-          - allwinner,sun8i-h3-system-controller
-          - allwinner,sun8i-v3s-system-controller
-          - allwinner,sun50i-a64-system-controller
+          - enum:
+              - allwinner,sun8i-a83t-system-controller
+              - allwinner,sun8i-h3-system-controller
+              - allwinner,sun8i-v3s-system-controller
+              - allwinner,sun50i-a64-system-controller

-        - const: syscon
+          - const: syscon

       - contains:
           const: syscon
diff --git a/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml b/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml
index 2f45dd0d04db..d43a0c557a44 100644
--- a/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/cdns,sdhci.yaml
@@ -17,7 +17,7 @@ properties:
   compatible:
     items:
       - enum:
-         - socionext,uniphier-sd4hc
+          - socionext,uniphier-sd4hc
       - const: cdns,sd4hc

   reg:
diff --git a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml
index 89c3edd6a728..4ee3ed6efab4 100644
--- a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml
+++ b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml
@@ -30,21 +30,21 @@ properties:
       - items:
           - enum:
             # for Rockchip PX30
-            - rockchip,px30-dw-mshc
+              - rockchip,px30-dw-mshc
             # for Rockchip RK3036
-            - rockchip,rk3036-dw-mshc
+              - rockchip,rk3036-dw-mshc
             # for Rockchip RK322x
-            - rockchip,rk3228-dw-mshc
+              - rockchip,rk3228-dw-mshc
             # for Rockchip RK3308
-            - rockchip,rk3308-dw-mshc
+              - rockchip,rk3308-dw-mshc
             # for Rockchip RK3328
-            - rockchip,rk3328-dw-mshc
+              - rockchip,rk3328-dw-mshc
             # for Rockchip RK3368
-            - rockchip,rk3368-dw-mshc
+              - rockchip,rk3368-dw-mshc
             # for Rockchip RK3399
-            - rockchip,rk3399-dw-mshc
+              - rockchip,rk3399-dw-mshc
             # for Rockchip RV1108
-            - rockchip,rv1108-dw-mshc
+              - rockchip,rv1108-dw-mshc
           - const: rockchip,rk3288-dw-mshc

   reg:
diff --git a/Documentation/devicetree/bindings/mmc/socionext,uniphier-sd.yaml b/Documentation/devicetree/bindings/mmc/socionext,uniphier-sd.yaml
index cdfac9b4411b..8d6413f48823 100644
--- a/Documentation/devicetree/bindings/mmc/socionext,uniphier-sd.yaml
+++ b/Documentation/devicetree/bindings/mmc/socionext,uniphier-sd.yaml
@@ -35,15 +35,15 @@ properties:
     oneOf:
       - const: host
       - items:
-        - const: host
-        - const: bridge
+          - const: host
+          - const: bridge
       - items:
-        - const: host
-        - const: hw
+          - const: host
+          - const: hw
       - items:
-        - const: host
-        - const: bridge
-        - const: hw
+          - const: host
+          - const: bridge
+          - const: hw

   resets:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/mtd/denali,nand.yaml b/Documentation/devicetree/bindings/mtd/denali,nand.yaml
index 46e6b6726bc0..c07b91592cbd 100644
--- a/Documentation/devicetree/bindings/mtd/denali,nand.yaml
+++ b/Documentation/devicetree/bindings/mtd/denali,nand.yaml
@@ -54,8 +54,8 @@ properties:
         reg:  register reset
     oneOf:
       - items:
-        - const: nand
-        - const: reg
+          - const: nand
+          - const: reg
       - const: nand
       - const: reg

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index db36b4d86484..c7c9ad4e3f9f 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -19,8 +19,8 @@ properties:
       - const: allwinner,sun8i-v3s-emac
       - const: allwinner,sun50i-a64-emac
       - items:
-        - const: allwinner,sun50i-h6-emac
-        - const: allwinner,sun50i-a64-emac
+          - const: allwinner,sun50i-h6-emac
+          - const: allwinner,sun50i-a64-emac

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index cccf8202c8f7..7a784dc4e513 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -9,7 +9,7 @@ title: Bosch MCAN controller Bindings
 description: Bosch MCAN controller for CAN bus

 maintainers:
-  -  Sriram Dash <sriram.dash@samsung.com>
+  - Sriram Dash <sriram.dash@samsung.com>

 properties:
   compatible:
@@ -51,31 +51,31 @@ properties:

   bosch,mram-cfg:
     description: |
-                 Message RAM configuration data.
-                 Multiple M_CAN instances can share the same Message RAM
-                 and each element(e.g Rx FIFO or Tx Buffer and etc) number
-                 in Message RAM is also configurable, so this property is
-                 telling driver how the shared or private Message RAM are
-                 used by this M_CAN controller.
-
-                 The format should be as follows:
-                 <offset sidf_elems xidf_elems rxf0_elems rxf1_elems rxb_elems txe_elems txb_elems>
-                 The 'offset' is an address offset of the Message RAM where
-                 the following elements start from. This is usually set to
-                 0x0 if you're using a private Message RAM. The remain cells
-                 are used to specify how many elements are used for each FIFO/Buffer.
-
-                 M_CAN includes the following elements according to user manual:
-                 11-bit Filter	0-128 elements / 0-128 words
-                 29-bit Filter	0-64 elements / 0-128 words
-                 Rx FIFO 0	0-64 elements / 0-1152 words
-                 Rx FIFO 1	0-64 elements / 0-1152 words
-                 Rx Buffers	0-64 elements / 0-1152 words
-                 Tx Event FIFO	0-32 elements / 0-64 words
-                 Tx Buffers	0-32 elements / 0-576 words
-
-                 Please refer to 2.4.1 Message RAM Configuration in Bosch
-                 M_CAN user manual for details.
+      Message RAM configuration data.
+      Multiple M_CAN instances can share the same Message RAM
+      and each element(e.g Rx FIFO or Tx Buffer and etc) number
+      in Message RAM is also configurable, so this property is
+      telling driver how the shared or private Message RAM are
+      used by this M_CAN controller.
+
+      The format should be as follows:
+      <offset sidf_elems xidf_elems rxf0_elems rxf1_elems rxb_elems txe_elems txb_elems>
+      The 'offset' is an address offset of the Message RAM where
+      the following elements start from. This is usually set to
+      0x0 if you're using a private Message RAM. The remain cells
+      are used to specify how many elements are used for each FIFO/Buffer.
+
+      M_CAN includes the following elements according to user manual:
+      11-bit Filter	0-128 elements / 0-128 words
+      29-bit Filter	0-64 elements / 0-128 words
+      Rx FIFO 0	0-64 elements / 0-1152 words
+      Rx FIFO 1	0-64 elements / 0-1152 words
+      Rx Buffers	0-64 elements / 0-1152 words
+      Tx Event FIFO	0-32 elements / 0-64 words
+      Tx Buffers	0-32 elements / 0-576 words
+
+      Please refer to 2.4.1 Message RAM Configuration in Bosch
+      M_CAN user manual for details.
     allOf:
       - $ref: /schemas/types.yaml#/definitions/int32-array
       - items:
diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
index 7f84df9790e2..2eaa8799e002 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -40,8 +40,8 @@ properties:

   reg:
     items:
-       - description: E-DMAC/feLic registers
-       - description: TSU registers
+      - description: E-DMAC/feLic registers
+      - description: TSU registers
     minItems: 1

   interrupts:
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index 976f139bb66e..8fc8d3be303b 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -23,14 +23,14 @@ properties:
     oneOf:
       - const: ti,cpsw-switch
       - items:
-         - const: ti,am335x-cpsw-switch
-         - const: ti,cpsw-switch
+          - const: ti,am335x-cpsw-switch
+          - const: ti,cpsw-switch
       - items:
-        - const: ti,am4372-cpsw-switch
-        - const: ti,cpsw-switch
+          - const: ti,am4372-cpsw-switch
+          - const: ti,cpsw-switch
       - items:
-        - const: ti,dra7-cpsw-switch
-        - const: ti,cpsw-switch
+          - const: ti,dra7-cpsw-switch
+          - const: ti,cpsw-switch

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
index 242ac4935a4b..2ea14ab29254 100644
--- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
@@ -18,25 +18,24 @@ allOf:
 properties:
   compatible:
     oneOf:
-       - const: ti,davinci_mdio
-       - items:
-         - const: ti,keystone_mdio
-         - const: ti,davinci_mdio
-       - items:
-         - const: ti,cpsw-mdio
-         - const: ti,davinci_mdio
-       - items:
-         - const: ti,am4372-mdio
-         - const: ti,cpsw-mdio
-         - const: ti,davinci_mdio
+      - const: ti,davinci_mdio
+      - items:
+          - const: ti,keystone_mdio
+          - const: ti,davinci_mdio
+      - items:
+          - const: ti,cpsw-mdio
+          - const: ti,davinci_mdio
+      - items:
+          - const: ti,am4372-mdio
+          - const: ti,cpsw-mdio
+          - const: ti,davinci_mdio

   reg:
     maxItems: 1

   bus_freq:
-      maximum: 2500000
-      description:
-        MDIO Bus frequency
+    maximum: 2500000
+    description: MDIO Bus frequency

   ti,hwmods:
     description: TI hwmod name
diff --git a/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml b/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
index 9a346d6290d9..77bb5309918e 100644
--- a/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/intel,lgm-emmc-phy.yaml
@@ -23,7 +23,7 @@ description: |+

 properties:
   compatible:
-      const: intel,lgm-emmc-phy
+    const: intel,lgm-emmc-phy

   "#phy-cells":
     const: 0
diff --git a/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml b/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml
index ea7f32905172..4fe64f4dd594 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml
+++ b/Documentation/devicetree/bindings/pwm/pwm-samsung.yaml
@@ -49,17 +49,17 @@ properties:
       are available.
     oneOf:
       - items:
-        - const: timers
+          - const: timers
       - items:
-        - const: timers
-        - const: pwm-tclk0
+          - const: timers
+          - const: pwm-tclk0
       - items:
-        - const: timers
-        - const: pwm-tclk1
+          - const: timers
+          - const: pwm-tclk1
       - items:
-        - const: timers
-        - const: pwm-tclk0
-        - const: pwm-tclk1
+          - const: timers
+          - const: pwm-tclk0
+          - const: pwm-tclk1

   interrupts:
     description:
diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
index c0d83865e933..4ff4d3df0a06 100644
--- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
@@ -25,7 +25,7 @@ properties:
     maxItems: 3

   resets:
-     maxItems: 1
+    maxItems: 1

   st,syscfg-holdboot:
     allOf:
diff --git a/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sata-rescal.yaml b/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sata-rescal.yaml
index 512a33bdb208..dfce6738b033 100644
--- a/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sata-rescal.yaml
+++ b/Documentation/devicetree/bindings/reset/brcm,bcm7216-pcie-sata-rescal.yaml
@@ -7,7 +7,9 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"

 title: BCM7216 RESCAL reset controller

-description: This document describes the BCM7216 RESCAL reset controller which is responsible for controlling the reset of the SATA and PCIe0/1 instances on BCM7216.
+description: This document describes the BCM7216 RESCAL reset controller
+  which is responsible for controlling the reset of the SATA and PCIe0/1
+  instances on BCM7216.

 maintainers:
   - Florian Fainelli <f.fainelli@gmail.com>
diff --git a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
index 48c6cafca90c..57b087574aa1 100644
--- a/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/st,stm32-rtc.yaml
@@ -38,10 +38,10 @@ properties:
           minItems: 3
           maxItems: 3
     description: |
-       Phandle/offset/mask triplet. The phandle to pwrcfg used to
-       access control register at offset, and change the dbp (Disable Backup
-       Protection) bit represented by the mask, mandatory to disable/enable backup
-       domain (RTC registers) write protection.
+      Phandle/offset/mask triplet. The phandle to pwrcfg used to
+      access control register at offset, and change the dbp (Disable Backup
+      Protection) bit represented by the mask, mandatory to disable/enable backup
+      domain (RTC registers) write protection.

   assigned-clocks:
     description: |
@@ -78,14 +78,14 @@ allOf:
             const: st,stm32h7-rtc

     then:
-       properties:
-         clocks:
-           minItems: 2
-           maxItems: 2
+      properties:
+        clocks:
+          minItems: 2
+          maxItems: 2

-       required:
-         - clock-names
-         - st,syscfg
+      required:
+        - clock-names
+        - st,syscfg

   - if:
       properties:
@@ -94,16 +94,16 @@ allOf:
             const: st,stm32mp1-rtc

     then:
-       properties:
-         clocks:
-           minItems: 2
-           maxItems: 2
+      properties:
+        clocks:
+          minItems: 2
+          maxItems: 2

-         assigned-clocks: false
-         assigned-clock-parents: false
+        assigned-clocks: false
+        assigned-clock-parents: false

-       required:
-         - clock-names
+      required:
+        - clock-names

 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml b/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
index d4178ab0d675..75ebc9952a99 100644
--- a/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
@@ -24,18 +24,18 @@ properties:
     oneOf:
       - description: Always-on power domain UART controller
         items:
-        - enum:
+          - enum:
+              - amlogic,meson6-uart
+              - amlogic,meson8-uart
+              - amlogic,meson8b-uart
+              - amlogic,meson-gx-uart
+          - const: amlogic,meson-ao-uart
+      - description: Everything-Else power domain UART controller
+        enum:
           - amlogic,meson6-uart
           - amlogic,meson8-uart
           - amlogic,meson8b-uart
           - amlogic,meson-gx-uart
-        - const: amlogic,meson-ao-uart
-      - description: Everything-Else power domain UART controller
-        enum:
-        - amlogic,meson6-uart
-        - amlogic,meson8-uart
-        - amlogic,meson8b-uart
-        - amlogic,meson-gx-uart

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/serial/rs485.yaml b/Documentation/devicetree/bindings/serial/rs485.yaml
index d4beaf11222d..2b8261ea6d9c 100644
--- a/Documentation/devicetree/bindings/serial/rs485.yaml
+++ b/Documentation/devicetree/bindings/serial/rs485.yaml
@@ -6,13 +6,12 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#

 title: RS485 serial communications Bindings

-description: The RTS signal is capable of automatically controlling
-             line direction for the built-in half-duplex mode.
-             The properties described hereafter shall be given to a
-             half-duplex capable UART node.
+description: The RTS signal is capable of automatically controlling line
+  direction for the built-in half-duplex mode. The properties described
+  hereafter shall be given to a half-duplex capable UART node.

 maintainers:
-  -  Rob Herring <robh@kernel.org>
+  - Rob Herring <robh@kernel.org>

 properties:
   rs485-rts-delay:
@@ -37,9 +36,11 @@ properties:
     $ref: /schemas/types.yaml#/definitions/flag

   linux,rs485-enabled-at-boot-time:
-    description: enables the rs485 feature at boot time. It can be disabled later with proper ioctl.
+    description: enables the rs485 feature at boot time. It can be disabled
+      later with proper ioctl.
     $ref: /schemas/types.yaml#/definitions/flag

   rs485-rx-during-tx:
-   description: enables the receiving of data even while sending data.
-   $ref: /schemas/types.yaml#/definitions/flag
+    description: enables the receiving of data even while sending data.
+    $ref: /schemas/types.yaml#/definitions/flag
+...
diff --git a/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml b/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
index cb008fd188d8..02b2d5ba01d6 100644
--- a/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
+++ b/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
@@ -26,11 +26,11 @@ properties:
   compatible:
     oneOf:
       - items:
-        - enum:
-          - amlogic,meson8-canvas
-          - amlogic,meson8b-canvas
-          - amlogic,meson8m2-canvas
-        - const: amlogic,canvas
+          - enum:
+              - amlogic,meson8-canvas
+              - amlogic,meson8b-canvas
+              - amlogic,meson8m2-canvas
+          - const: amlogic,canvas
       - const: amlogic,canvas # GXBB and newer SoCs

   reg:
diff --git a/Documentation/devicetree/bindings/sound/renesas,fsi.yaml b/Documentation/devicetree/bindings/sound/renesas,fsi.yaml
index d1b65554e681..91cf4176abd5 100644
--- a/Documentation/devicetree/bindings/sound/renesas,fsi.yaml
+++ b/Documentation/devicetree/bindings/sound/renesas,fsi.yaml
@@ -17,16 +17,16 @@ properties:
     oneOf:
       # for FSI2 SoC
       - items:
-        - enum:
-          - renesas,fsi2-sh73a0
-          - renesas,fsi2-r8a7740
-        - enum:
-          - renesas,sh_fsi2
+          - enum:
+              - renesas,fsi2-sh73a0
+              - renesas,fsi2-r8a7740
+          - enum:
+              - renesas,sh_fsi2
       # for Generic
       - items:
-        - enum:
-          - renesas,sh_fsi
-          - renesas,sh_fsi2
+          - enum:
+              - renesas,sh_fsi
+              - renesas,sh_fsi2

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
index 0cf470eaf2a0..406286149a6b 100644
--- a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
@@ -8,12 +8,12 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Qualcomm Quad Serial Peripheral Interface (QSPI)

 maintainers:
- - Mukesh Savaliya <msavaliy@codeaurora.org>
- - Akash Asthana <akashast@codeaurora.org>
+  - Mukesh Savaliya <msavaliy@codeaurora.org>
+  - Akash Asthana <akashast@codeaurora.org>

-description:
- The QSPI controller allows SPI protocol communication in single, dual, or quad
- wire transmission modes for read/write access to slaves such as NOR flash.
+description: The QSPI controller allows SPI protocol communication in single,
+  dual, or quad wire transmission modes for read/write access to slaves such
+  as NOR flash.

 allOf:
   - $ref: /spi/spi-controller.yaml#
diff --git a/Documentation/devicetree/bindings/spi/renesas,hspi.yaml b/Documentation/devicetree/bindings/spi/renesas,hspi.yaml
index c429cf4bea5b..f492cb9fea12 100644
--- a/Documentation/devicetree/bindings/spi/renesas,hspi.yaml
+++ b/Documentation/devicetree/bindings/spi/renesas,hspi.yaml
@@ -16,8 +16,8 @@ properties:
   compatible:
     items:
       - enum:
-        - renesas,hspi-r8a7778 # R-Car M1A
-        - renesas,hspi-r8a7779 # R-Car H1
+          - renesas,hspi-r8a7778 # R-Car M1A
+          - renesas,hspi-r8a7779 # R-Car H1
       - const: renesas,hspi

   reg:
diff --git a/Documentation/devicetree/bindings/spi/spi-pl022.yaml b/Documentation/devicetree/bindings/spi/spi-pl022.yaml
index dfb697c69341..22ba4e90655b 100644
--- a/Documentation/devicetree/bindings/spi/spi-pl022.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-pl022.yaml
@@ -51,7 +51,7 @@ properties:

   pl022,rt:
     description: indicates the controller should run the message pump with realtime
-               priority to minimise the transfer latency on the bus (boolean)
+      priority to minimise the transfer latency on the bus (boolean)
     type: boolean

   dmas:
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
index 3665a5fe6b7f..1a342ce1f798 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
@@ -24,8 +24,8 @@ properties:

   reg-names:
     items:
-     - const: qspi
-     - const: qspi_mm
+      - const: qspi
+      - const: qspi_mm

   clocks:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/sram/allwinner,sun4i-a10-system-control.yaml b/Documentation/devicetree/bindings/sram/allwinner,sun4i-a10-system-control.yaml
index 4b5509436588..f5825935fd22 100644
--- a/Documentation/devicetree/bindings/sram/allwinner,sun4i-a10-system-control.yaml
+++ b/Documentation/devicetree/bindings/sram/allwinner,sun4i-a10-system-control.yaml
@@ -29,8 +29,8 @@ properties:
       - const: allwinner,sun4i-a10-system-control
       - const: allwinner,sun5i-a13-system-control
       - items:
-        - const: allwinner,sun7i-a20-system-control
-        - const: allwinner,sun4i-a10-system-control
+          - const: allwinner,sun7i-a20-system-control
+          - const: allwinner,sun4i-a10-system-control
       - const: allwinner,sun8i-a23-system-control
       - const: allwinner,sun8i-h3-system-control
       - const: allwinner,sun50i-a64-sram-controller
@@ -38,11 +38,11 @@ properties:
       - const: allwinner,sun50i-a64-system-control
       - const: allwinner,sun50i-h5-system-control
       - items:
-        - const: allwinner,sun50i-h6-system-control
-        - const: allwinner,sun50i-a64-system-control
+          - const: allwinner,sun50i-h6-system-control
+          - const: allwinner,sun50i-a64-system-control
       - items:
-        - const: allwinner,suniv-f1c100s-system-control
-        - const: allwinner,sun4i-a10-system-control
+          - const: allwinner,suniv-f1c100s-system-control
+          - const: allwinner,sun4i-a10-system-control

   reg:
     maxItems: 1
@@ -69,44 +69,44 @@ patternProperties:
               - const: allwinner,sun4i-a10-sram-d
               - const: allwinner,sun50i-a64-sram-c
               - items:
-                - const: allwinner,sun5i-a13-sram-a3-a4
-                - const: allwinner,sun4i-a10-sram-a3-a4
+                  - const: allwinner,sun5i-a13-sram-a3-a4
+                  - const: allwinner,sun4i-a10-sram-a3-a4
               - items:
-                - const: allwinner,sun7i-a20-sram-a3-a4
-                - const: allwinner,sun4i-a10-sram-a3-a4
+                  - const: allwinner,sun7i-a20-sram-a3-a4
+                  - const: allwinner,sun4i-a10-sram-a3-a4
               - items:
-                - const: allwinner,sun5i-a13-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun5i-a13-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun7i-a20-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun7i-a20-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun8i-a23-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun8i-a23-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun8i-h3-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun8i-h3-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun50i-a64-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun50i-a64-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun50i-h5-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun50i-h5-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun50i-h6-sram-c1
-                - const: allwinner,sun4i-a10-sram-c1
+                  - const: allwinner,sun50i-h6-sram-c1
+                  - const: allwinner,sun4i-a10-sram-c1
               - items:
-                - const: allwinner,sun5i-a13-sram-d
-                - const: allwinner,sun4i-a10-sram-d
+                  - const: allwinner,sun5i-a13-sram-d
+                  - const: allwinner,sun4i-a10-sram-d
               - items:
-                - const: allwinner,sun7i-a20-sram-d
-                - const: allwinner,sun4i-a10-sram-d
+                  - const: allwinner,sun7i-a20-sram-d
+                  - const: allwinner,sun4i-a10-sram-d
               - items:
-                - const: allwinner,suniv-f1c100s-sram-d
-                - const: allwinner,sun4i-a10-sram-d
+                  - const: allwinner,suniv-f1c100s-sram-d
+                  - const: allwinner,sun4i-a10-sram-d
               - items:
-                - const: allwinner,sun50i-h6-sram-c
-                - const: allwinner,sun50i-a64-sram-c
+                  - const: allwinner,sun50i-h6-sram-c
+                  - const: allwinner,sun50i-a64-sram-c

 required:
   - "#address-cells"
diff --git a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
index e43ec50bda37..999c6b365f1d 100644
--- a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
@@ -13,11 +13,11 @@ description: Binding for Amlogic Thermal

 properties:
   compatible:
-      items:
-        - enum:
-            - amlogic,g12a-cpu-thermal
-            - amlogic,g12a-ddr-thermal
-        - const: amlogic,g12a-thermal
+    items:
+      - enum:
+          - amlogic,g12a-cpu-thermal
+          - amlogic,g12a-ddr-thermal
+      - const: amlogic,g12a-thermal

   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
index fa255672e8e5..135186f83925 100644
--- a/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
+++ b/Documentation/devicetree/bindings/timer/arm,arch_timer.yaml
@@ -28,10 +28,10 @@ properties:
               - arm,armv7-timer
       - items:
           - enum:
-            - arm,armv7-timer
+              - arm,armv7-timer
       - items:
           - enum:
-            - arm,armv8-timer
+              - arm,armv8-timer

   interrupts:
     items:
diff --git a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
index 582bbef62b95..6ff718ede184 100644
--- a/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
+++ b/Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
@@ -20,7 +20,7 @@ properties:
   compatible:
     items:
       - enum:
-        - arm,armv7-timer-mem
+          - arm,armv7-timer-mem

   reg:
     maxItems: 1
@@ -77,7 +77,7 @@ patternProperties:
           - description: physical timer irq
           - description: virtual timer irq

-      reg :
+      reg:
         minItems: 1
         maxItems: 2
         items:
diff --git a/Documentation/devicetree/bindings/usb/dwc2.yaml b/Documentation/devicetree/bindings/usb/dwc2.yaml
index 0d6d850a7f17..fb2f62aef5fa 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.yaml
+++ b/Documentation/devicetree/bindings/usb/dwc2.yaml
@@ -62,14 +62,14 @@ properties:

   resets:
     items:
-     - description: common reset
-     - description: ecc reset
+      - description: common reset
+      - description: ecc reset
     minItems: 1

   reset-names:
     items:
-     - const: dwc2
-     - const: dwc2-ecc
+      - const: dwc2
+      - const: dwc2-ecc
     minItems: 1

   phys:
--
2.20.1
