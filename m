Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864E73D0010
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhGTQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:40:22 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:44007 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhGTQj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 12:39:57 -0400
Received: by mail-io1-f41.google.com with SMTP id k16so24799147ios.10;
        Tue, 20 Jul 2021 10:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZCWzCoOjnnivOP/tW4N96gAT57yQaBguSTWngPhSSA=;
        b=rcxvUoLilMNQJumcruOrIEAK0BlL6Q7VHU7BMOYnr1/bjjshrtXGHBccCal4yWD0QS
         t1uCCjjvPzjAfi+XuvaiC/GLXCWDrAujaE78IpclVmWCljnk1spjikP9dd2etoLz4bRk
         kVJAV+n0Aibq8ZQ83T+CNZcTjVaggvj7ZEMpjC7+2UlhGOTAstqO2EICtgRiVXpkz7VB
         16jmWBWml/h//VNUTaPCP3Esq1MScoRHR7rvsw5ufROkEe7j468sEXF5G5eqymlKPmWO
         fKH3LZuoKwzrWsUUlTmsuwXRkxBwiiIEPd33vVLeY9uociji9k9Wj9FvezKsvSoV/+zu
         YnZg==
X-Gm-Message-State: AOAM530kUSkY8ok9Oq4kxEXF0DhAK3iMTwbN8EtprMQPl6shN8Jx7U/R
        O7Nggc2Ipl54i9xtUh4pd5KK+Xh73Q==
X-Google-Smtp-Source: ABdhPJzGje2nd6sE/0UPZUrGBStEseIV0OZhbpDmd4OUkAnlTHhxiF23sjM3zraSvFfjHrqFhDok8Q==
X-Received: by 2002:a05:6638:3796:: with SMTP id w22mr10932111jal.34.1626801631799;
        Tue, 20 Jul 2021 10:20:31 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.248])
        by smtp.googlemail.com with ESMTPSA id c7sm11528483ilj.86.2021.07.20.10.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 10:20:31 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ramesh Shanmugasundaram <rashanmu@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Dilip Kota <eswara.kota@linux.intel.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] dt-bindings: Remove "status" from schema examples
Date:   Tue, 20 Jul 2021 11:20:25 -0600
Message-Id: <20210720172025.363238-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no reason to have "status" properties in examples. "okay" is the
default, and "disabled" turns off some schema checks ('required'
specifically).

Enabling qca,ar71xx causes a warning, so let's fix the node names:

Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: phy@3: '#phy-cells' is a required property
        From schema: schemas/phy/phy-provider.yaml

Cc: Maxime Ripard <mripard@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rui Miguel Silva <rmfrfs@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Robert Marko <robert.marko@sartura.hr>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ramesh Shanmugasundaram <rashanmu@gmail.com>
Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: ChiYuan Huang <cy_huang@richtek.com>
Cc: Wei Xu <xuwei5@hisilicon.com>
Cc: Dilip Kota <eswara.kota@linux.intel.com>
Cc: Karol Gugala <kgugala@antmicro.com>
Cc: Mateusz Holenko <mholenko@antmicro.com>
Cc: Olivier Moysan <olivier.moysan@st.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-rtc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../display/allwinner,sun8i-a83t-dw-hdmi.yaml |  2 --
 .../display/panel/boe,tv101wum-nl6.yaml       |  1 -
 .../bindings/media/nxp,imx7-mipi-csi2.yaml    |  2 --
 .../bindings/media/renesas,drif.yaml          |  1 -
 .../bindings/net/intel,dwmac-plat.yaml        |  2 --
 .../bindings/net/intel,ixp4xx-ethernet.yaml   |  2 --
 .../bindings/net/nfc/samsung,s3fwrn5.yaml     |  3 ---
 .../devicetree/bindings/net/qca,ar71xx.yaml   | 25 ++++---------------
 .../regulator/richtek,rt6245-regulator.yaml   |  1 -
 .../regulator/vqmmc-ipq4019-regulator.yaml    |  1 -
 .../reset/hisilicon,hi3660-reset.yaml         |  1 -
 .../bindings/reset/intel,rcu-gw.yaml          |  1 -
 .../bindings/rtc/microcrystal,rv3032.yaml     |  1 -
 .../soc/litex/litex,soc-controller.yaml       |  1 -
 .../bindings/sound/st,stm32-sai.yaml          |  2 --
 .../bindings/sound/ti,j721e-cpb-audio.yaml    |  2 --
 .../sound/ti,j721e-cpb-ivi-audio.yaml         |  2 --
 17 files changed, 5 insertions(+), 45 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
index 5d42d36608d9..4951b5ef5c6a 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun8i-a83t-dw-hdmi.yaml
@@ -174,7 +174,6 @@ examples:
         phy-names = "phy";
         pinctrl-names = "default";
         pinctrl-0 = <&hdmi_pins>;
-        status = "disabled";
 
         ports {
             #address-cells = <1>;
@@ -233,7 +232,6 @@ examples:
         phy-names = "phy";
         pinctrl-names = "default";
         pinctrl-0 = <&hdmi_pins>;
-        status = "disabled";
 
         ports {
             #address-cells = <1>;
diff --git a/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml b/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml
index 38bc1d1b511e..b87a2e28c866 100644
--- a/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml
+++ b/Documentation/devicetree/bindings/display/panel/boe,tv101wum-nl6.yaml
@@ -70,7 +70,6 @@ examples:
             avee-supply = <&ppvarp_lcd>;
             pp1800-supply = <&pp1800_lcd>;
             backlight = <&backlight_lcd0>;
-            status = "okay";
             port {
                 panel_in: endpoint {
                     remote-endpoint = <&dsi_out>;
diff --git a/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml b/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
index 7c09eec78ce5..877183cf4278 100644
--- a/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
@@ -200,8 +200,6 @@ examples:
         clock-names = "pclk", "wrap", "phy", "axi";
         power-domains = <&mipi_pd>;
 
-        status = "disabled";
-
         ports {
             #address-cells = <1>;
             #size-cells = <0>;
diff --git a/Documentation/devicetree/bindings/media/renesas,drif.yaml b/Documentation/devicetree/bindings/media/renesas,drif.yaml
index 2867d11fe156..9403b235e976 100644
--- a/Documentation/devicetree/bindings/media/renesas,drif.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,drif.yaml
@@ -242,7 +242,6 @@ examples:
                     power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
                     resets = <&cpg 513>;
                     renesas,bonding = <&drif11>;
-                    status = "disabled";
             };
 
             drif11: rif@e6f70000 {
diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
index c1948ce00081..79fa04f5e40d 100644
--- a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
+++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
@@ -116,8 +116,6 @@ examples:
         snps,mtl-rx-config = <&mtl_rx_setup>;
         snps,mtl-tx-config = <&mtl_tx_setup>;
         snps,tso;
-        status = "okay";
-
         mdio0 {
             #address-cells = <1>;
             #size-cells = <0>;
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
index f2e91d1bf7d7..378ed2d3b003 100644
--- a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -71,7 +71,6 @@ examples:
     ethernet@c8009000 {
       compatible = "intel,ixp4xx-ethernet";
       reg = <0xc8009000 0x1000>;
-      status = "disabled";
       queue-rx = <&qmgr 4>;
       queue-txready = <&qmgr 21>;
       intel,npe-handle = <&npe 1>;
@@ -82,7 +81,6 @@ examples:
     ethernet@c800c000 {
       compatible = "intel,ixp4xx-ethernet";
       reg = <0xc800c000 0x1000>;
-      status = "disabled";
       queue-rx = <&qmgr 3>;
       queue-txready = <&qmgr 20>;
       intel,npe-handle = <&npe 2>;
diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index 081742c2b726..64995cbb0f97 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -90,14 +90,11 @@ examples:
   # UART example on Raspberry Pi
   - |
     uart0 {
-        status = "okay";
-
         nfc {
             compatible = "samsung,s3fwrn82";
 
             en-gpios = <&gpio 20 GPIO_ACTIVE_HIGH>;
             wake-gpios = <&gpio 16 GPIO_ACTIVE_HIGH>;
 
-            status = "okay";
         };
     };
diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
index f0db22645d73..cf4d35edaa1b 100644
--- a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
@@ -101,8 +101,6 @@ examples:
 
         phy-mode = "gmii";
 
-        status = "disabled";
-
         fixed-link {
             speed = <1000>;
             full-duplex;
@@ -148,32 +146,24 @@ examples:
                         reg = <0x1>;
                         phy-handle = <&phy_port0>;
                         phy-mode = "internal";
-
-                        status = "disabled";
                     };
 
                     switch_port2: port@2 {
                         reg = <0x2>;
                         phy-handle = <&phy_port1>;
                         phy-mode = "internal";
-
-                        status = "disabled";
                     };
 
                     switch_port3: port@3 {
                         reg = <0x3>;
                         phy-handle = <&phy_port2>;
                         phy-mode = "internal";
-
-                        status = "disabled";
                     };
 
                     switch_port4: port@4 {
                         reg = <0x4>;
                         phy-handle = <&phy_port3>;
                         phy-mode = "internal";
-
-                        status = "disabled";
                     };
                 };
 
@@ -183,34 +173,29 @@ examples:
 
                     interrupt-parent = <&switch10>;
 
-                    phy_port0: phy@0 {
+                    phy_port0: ethernet-phy@0 {
                         reg = <0x0>;
                         interrupts = <0>;
-                        status = "disabled";
                     };
 
-                    phy_port1: phy@1 {
+                    phy_port1: ethernet-phy@1 {
                         reg = <0x1>;
                         interrupts = <0>;
-                        status = "disabled";
                     };
 
-                    phy_port2: phy@2 {
+                    phy_port2: ethernet-phy@2 {
                         reg = <0x2>;
                         interrupts = <0>;
-                        status = "disabled";
                     };
 
-                    phy_port3: phy@3 {
+                    phy_port3: ethernet-phy@3 {
                         reg = <0x3>;
                         interrupts = <0>;
-                        status = "disabled";
                     };
 
-                    phy_port4: phy@4 {
+                    phy_port4: ethernet-phy@4 {
                         reg = <0x4>;
                         interrupts = <0>;
-                        status = "disabled";
                     };
                 };
             };
diff --git a/Documentation/devicetree/bindings/regulator/richtek,rt6245-regulator.yaml b/Documentation/devicetree/bindings/regulator/richtek,rt6245-regulator.yaml
index 796ceac87445..e983d0e70c9b 100644
--- a/Documentation/devicetree/bindings/regulator/richtek,rt6245-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/richtek,rt6245-regulator.yaml
@@ -77,7 +77,6 @@ examples:
 
       rt6245@34 {
         compatible = "richtek,rt6245";
-        status = "okay";
         reg = <0x34>;
         enable-gpios = <&gpio26 2 0>;
 
diff --git a/Documentation/devicetree/bindings/regulator/vqmmc-ipq4019-regulator.yaml b/Documentation/devicetree/bindings/regulator/vqmmc-ipq4019-regulator.yaml
index 6f45582c914e..dd7a2f92634c 100644
--- a/Documentation/devicetree/bindings/regulator/vqmmc-ipq4019-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/vqmmc-ipq4019-regulator.yaml
@@ -39,6 +39,5 @@ examples:
       regulator-min-microvolt = <1500000>;
       regulator-max-microvolt = <3000000>;
       regulator-always-on;
-      status = "disabled";
     };
 ...
diff --git a/Documentation/devicetree/bindings/reset/hisilicon,hi3660-reset.yaml b/Documentation/devicetree/bindings/reset/hisilicon,hi3660-reset.yaml
index 9bf40952e5b7..b0c41ab1a746 100644
--- a/Documentation/devicetree/bindings/reset/hisilicon,hi3660-reset.yaml
+++ b/Documentation/devicetree/bindings/reset/hisilicon,hi3660-reset.yaml
@@ -72,6 +72,5 @@ examples:
         resets = <&iomcu_rst 0x20 3>;
         pinctrl-names = "default";
         pinctrl-0 = <&i2c0_pmx_func &i2c0_cfg_func>;
-        status = "disabled";
     };
 ...
diff --git a/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml b/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml
index 6b2d56cc3f38..13bf6bb3f097 100644
--- a/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml
+++ b/Documentation/devicetree/bindings/reset/intel,rcu-gw.yaml
@@ -57,7 +57,6 @@ examples:
     };
 
     pwm: pwm@e0d00000 {
-        status = "disabled";
         compatible = "intel,lgm-pwm";
         reg = <0xe0d00000 0x30>;
         clocks = <&cgu0 1>;
diff --git a/Documentation/devicetree/bindings/rtc/microcrystal,rv3032.yaml b/Documentation/devicetree/bindings/rtc/microcrystal,rv3032.yaml
index a2c55303810d..9593840a4a2b 100644
--- a/Documentation/devicetree/bindings/rtc/microcrystal,rv3032.yaml
+++ b/Documentation/devicetree/bindings/rtc/microcrystal,rv3032.yaml
@@ -53,7 +53,6 @@ examples:
         rtc@51 {
             compatible = "microcrystal,rv3032";
             reg = <0x51>;
-            status = "okay";
             pinctrl-0 = <&rtc_nint_pins>;
             interrupts-extended = <&gpio1 16 IRQ_TYPE_LEVEL_HIGH>;
             trickle-resistor-ohms = <7000>;
diff --git a/Documentation/devicetree/bindings/soc/litex/litex,soc-controller.yaml b/Documentation/devicetree/bindings/soc/litex/litex,soc-controller.yaml
index c8b57c7fd08c..ecae9fa8561b 100644
--- a/Documentation/devicetree/bindings/soc/litex/litex,soc-controller.yaml
+++ b/Documentation/devicetree/bindings/soc/litex/litex,soc-controller.yaml
@@ -35,7 +35,6 @@ examples:
     soc_ctrl0: soc-controller@f0000000 {
         compatible = "litex,soc-controller";
         reg = <0xf0000000 0xc>;
-        status = "okay";
     };
 
 ...
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index 06e83461705c..f97132400bb6 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -180,7 +180,6 @@ examples:
       pinctrl-names = "default", "sleep";
       pinctrl-0 = <&sai2a_pins_a>, <&sai2b_pins_b>;
       pinctrl-1 = <&sai2a_sleep_pins_a>, <&sai2b_sleep_pins_b>;
-      status = "okay";
 
       sai2a: audio-controller@4400b004 {
         #sound-dai-cells = <0>;
@@ -190,7 +189,6 @@ examples:
         dma-names = "tx";
         clocks = <&rcc SAI2_K>;
         clock-names = "sai_ck";
-        status = "okay";
       };
     };
 
diff --git a/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml b/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml
index ec06789b21df..6806f53a4aed 100644
--- a/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml
+++ b/Documentation/devicetree/bindings/sound/ti,j721e-cpb-audio.yaml
@@ -127,8 +127,6 @@ examples:
         compatible = "ti,j721e-cpb-audio";
         model = "j721e-cpb";
 
-        status = "okay";
-
         ti,cpb-mcasp = <&mcasp10>;
         ti,cpb-codec = <&pcm3168a_1>;
 
diff --git a/Documentation/devicetree/bindings/sound/ti,j721e-cpb-ivi-audio.yaml b/Documentation/devicetree/bindings/sound/ti,j721e-cpb-ivi-audio.yaml
index ee9f960de36b..859d369c71e2 100644
--- a/Documentation/devicetree/bindings/sound/ti,j721e-cpb-ivi-audio.yaml
+++ b/Documentation/devicetree/bindings/sound/ti,j721e-cpb-ivi-audio.yaml
@@ -119,8 +119,6 @@ examples:
         compatible = "ti,j721e-cpb-ivi-audio";
         model = "j721e-cpb-ivi";
 
-        status = "okay";
-
         ti,cpb-mcasp = <&mcasp10>;
         ti,cpb-codec = <&pcm3168a_1>;
 
-- 
2.27.0

