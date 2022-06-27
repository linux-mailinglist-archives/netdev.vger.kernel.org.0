Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4809D55E0E3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiF0RjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiF0RjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E39BC11;
        Mon, 27 Jun 2022 10:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFC7BB81062;
        Mon, 27 Jun 2022 17:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520D6C3411D;
        Mon, 27 Jun 2022 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656351552;
        bh=Zn0Dfb4M02qxEfqvQzrDg8XHxtNPpoaNnFOSN6zyqcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XzH3tXT3H9L7KDQzTdC3I4DnJaB+mhExMuomvsSJVtjPdDWa53REixFOQ4tlRaRgB
         Dau6EcVZT097k2R5PlMlSrrircErH+zgXxRd58ebu2yILqYResOpDx/qkBJTybJBzC
         aDXOIeZZUz0J7nebzfXbkmrHNYk9fI5HGXWgwb5Xn+1I3ATXg/w1Zr1+1dAv0MqP7q
         WiGRgSQRZHKR8Gsh2phfFlHXTXRPqESdF1VSYROT2m6CwKL6V/eYcSBUpOLYaYlQbO
         HknfH8oBojGD2/28mzQuQqXBpLqdZk2/o5t6sdWVMqBh7o8TUMTIFcX3MnJ8pPjU9c
         hgu088FI8qugw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, geert+renesas@glider.be,
        magnus.damm@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next] Revert the ARM/dts changes for Renesas RZ/N1
Date:   Mon, 27 Jun 2022 10:39:00 -0700
Message-Id: <20220627173900.3136386-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on a request from Geert:

Revert "ARM: dts: r9a06g032-rzn1d400-db: add switch description"
This reverts commit 9aab31d66ec97d7047e42feacc356bc9c21a5bf5.

Revert "ARM: dts: r9a06g032: describe switch"
This reverts commit cf9695d8a7e927f7563ce6ea0a4e54b8214a12f1.

Revert "ARM: dts: r9a06g032: describe GMAC2"
This reverts commit 3f5261f1c2a8d7b178f9f65c6dda92523329486e.

Revert "ARM: dts: r9a06g032: describe MII converter"
This reverts commit 066c3bd358355185d9313358281fe03113c0a9ad.

to let these changes flow thru the platform and SoC trees.

Link: https://lore.kernel.org/r/CAMuHMdUvSLFU56gsp1a9isOiP9otdCJ2-BqhbrffcoHuA6JNig@mail.gmail.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: geert+renesas@glider.be
CC: magnus.damm@gmail.com
CC: robh+dt@kernel.org
CC: krzysztof.kozlowski+dt@linaro.org
CC: linux-renesas-soc@vger.kernel.org
CC: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts | 117 --------------------
 arch/arm/boot/dts/r9a06g032.dtsi            | 108 ------------------
 2 files changed, 225 deletions(-)

diff --git a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
index 4227aba70c30..3f8f3ce87e12 100644
--- a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
+++ b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
@@ -8,8 +8,6 @@
 
 /dts-v1/;
 
-#include <dt-bindings/pinctrl/rzn1-pinctrl.h>
-#include <dt-bindings/net/pcs-rzn1-miic.h>
 #include "r9a06g032.dtsi"
 
 / {
@@ -33,118 +31,3 @@ &wdt0 {
 	timeout-sec = <60>;
 	status = "okay";
 };
-
-&gmac2 {
-	status = "okay";
-	phy-mode = "gmii";
-	fixed-link {
-		speed = <1000>;
-		full-duplex;
-	};
-};
-
-&switch {
-	status = "okay";
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	pinctrl-names = "default";
-	pinctrl-0 = <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;
-
-	dsa,member = <0 0>;
-
-	mdio {
-		clock-frequency = <2500000>;
-
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		switch0phy4: ethernet-phy@4 {
-			reg = <4>;
-			micrel,led-mode = <1>;
-		};
-
-		switch0phy5: ethernet-phy@5 {
-			reg = <5>;
-			micrel,led-mode = <1>;
-		};
-	};
-};
-
-&switch_port0 {
-	label = "lan0";
-	phy-mode = "mii";
-	phy-handle = <&switch0phy5>;
-	status = "okay";
-};
-
-&switch_port1 {
-	label = "lan1";
-	phy-mode = "mii";
-	phy-handle = <&switch0phy4>;
-	status = "okay";
-};
-
-&switch_port4 {
-	status = "okay";
-};
-
-&eth_miic {
-	status = "okay";
-	renesas,miic-switch-portin = <MIIC_GMAC2_PORT>;
-};
-
-&mii_conv4 {
-	renesas,miic-input = <MIIC_SWITCH_PORTB>;
-	status = "okay";
-};
-
-&mii_conv5 {
-	renesas,miic-input = <MIIC_SWITCH_PORTA>;
-	status = "okay";
-};
-
-&pinctrl{
-	pins_mdio1: pins_mdio1 {
-		pinmux = <
-			RZN1_PINMUX(152, RZN1_FUNC_MDIO1_SWITCH)
-			RZN1_PINMUX(153, RZN1_FUNC_MDIO1_SWITCH)
-		>;
-	};
-	pins_eth3: pins_eth3 {
-		pinmux = <
-			RZN1_PINMUX(36, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(37, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(38, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(39, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(40, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(41, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(42, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(43, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(44, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(45, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(46, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(47, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-		>;
-		drive-strength = <6>;
-		bias-disable;
-	};
-	pins_eth4: pins_eth4 {
-		pinmux = <
-			RZN1_PINMUX(48, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(49, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(50, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(51, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(52, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(53, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(54, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(55, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(56, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(57, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(58, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-			RZN1_PINMUX(59, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
-		>;
-		drive-strength = <6>;
-		bias-disable;
-	};
-};
diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 5b97fa85474f..d3665910958b 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -304,114 +304,6 @@ dma1: dma-controller@40105000 {
 			data-width = <8>;
 		};
 
-		gmac2: ethernet@44002000 {
-			compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";
-			reg = <0x44002000 0x2000>;
-			interrupt-parent = <&gic>;
-			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
-			clocks = <&sysctrl R9A06G032_HCLK_GMAC1>;
-			clock-names = "stmmaceth";
-			power-domains = <&sysctrl>;
-			snps,multicast-filter-bins = <256>;
-			snps,perfect-filter-entries = <128>;
-			tx-fifo-depth = <2048>;
-			rx-fifo-depth = <4096>;
-			status = "disabled";
-		};
-
-		eth_miic: eth-miic@44030000 {
-			compatible = "renesas,r9a06g032-miic", "renesas,rzn1-miic";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <0x44030000 0x10000>;
-			clocks = <&sysctrl R9A06G032_CLK_MII_REF>,
-				 <&sysctrl R9A06G032_CLK_RGMII_REF>,
-				 <&sysctrl R9A06G032_CLK_RMII_REF>,
-				 <&sysctrl R9A06G032_HCLK_SWITCH_RG>;
-			clock-names = "mii_ref", "rgmii_ref", "rmii_ref", "hclk";
-			power-domains = <&sysctrl>;
-			status = "disabled";
-
-			mii_conv1: mii-conv@1 {
-				reg = <1>;
-				status = "disabled";
-			};
-
-			mii_conv2: mii-conv@2 {
-				reg = <2>;
-				status = "disabled";
-			};
-
-			mii_conv3: mii-conv@3 {
-				reg = <3>;
-				status = "disabled";
-			};
-
-			mii_conv4: mii-conv@4 {
-				reg = <4>;
-				status = "disabled";
-			};
-
-			mii_conv5: mii-conv@5 {
-				reg = <5>;
-				status = "disabled";
-			};
-		};
-
-		switch: switch@44050000 {
-			compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
-			reg = <0x44050000 0x10000>;
-			clocks = <&sysctrl R9A06G032_HCLK_SWITCH>,
-				 <&sysctrl R9A06G032_CLK_SWITCH>;
-			clock-names = "hclk", "clk";
-			power-domains = <&sysctrl>;
-			status = "disabled";
-
-			ethernet-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				switch_port0: port@0 {
-					reg = <0>;
-					pcs-handle = <&mii_conv5>;
-					status = "disabled";
-				};
-
-				switch_port1: port@1 {
-					reg = <1>;
-					pcs-handle = <&mii_conv4>;
-					status = "disabled";
-				};
-
-				switch_port2: port@2 {
-					reg = <2>;
-					pcs-handle = <&mii_conv3>;
-					status = "disabled";
-				};
-
-				switch_port3: port@3 {
-					reg = <3>;
-					pcs-handle = <&mii_conv2>;
-					status = "disabled";
-				};
-
-				switch_port4: port@4 {
-					reg = <4>;
-					ethernet = <&gmac2>;
-					label = "cpu";
-					phy-mode = "internal";
-					status = "disabled";
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-				};
-			};
-		};
-
 		gic: interrupt-controller@44101000 {
 			compatible = "arm,gic-400", "arm,cortex-a7-gic";
 			interrupt-controller;
-- 
2.36.1

