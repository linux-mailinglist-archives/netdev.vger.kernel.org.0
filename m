Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559825516FA
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiFTLLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241539AbiFTLKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:10:44 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC8B15FEC;
        Mon, 20 Jun 2022 04:10:30 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 74B0E240005;
        Mon, 20 Jun 2022 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655723428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuP4gcOVQsn/2pRPVhdQXg999qyZbyIWmBlFl1Oa+3w=;
        b=YAxB1jnQGQz9ioXRx8s/D7C0cCVOZYCl0brYC2b+NmYljEbslaTQYe4S8V1kjzeMlb6bQa
        qJxnJNnz4O/IoPrVFySu0+OMU+yc75J3WeIWSexEn/UrlzriJTMhmmwuid0N6ek1aAEzIP
        YNj75eXFz3N4PCpj9Z4cr3gV+VUEzrB9awxQJ5bXiUE1C6bWZ4th+UwHq62tDSZElVTRZO
        +x9LHNy3IHo7sMoKt+Nbdoy4HHy2aPvuaMMivqq0rgIOartkV/xmf/8BjT4Sm9uUTr4lrR
        RcejNSwW0aDEKTtHXp9S/ENub2vP2nRIvccStXzxmbp3cSSMuOEdNvBPzW3C+g==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v8 15/16] ARM: dts: r9a06g032-rzn1d400-db: add switch description
Date:   Mon, 20 Jun 2022 13:08:45 +0200
Message-Id: <20220620110846.374787-16-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620110846.374787-1-clement.leger@bootlin.com>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description for the switch, GMAC2 and MII converter. With these
definitions, the switch port 0 and 1 (MII port 5 and 4) are working on
RZ/N1D-DB board.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts | 117 ++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
index 3f8f3ce87e12..36b898d9f115 100644
--- a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
+++ b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
@@ -8,6 +8,8 @@
 
 /dts-v1/;
 
+#include <dt-bindings/pinctrl/rzn1-pinctrl.h>
+#include <dt-bindings/net/pcs-rzn1-miic.h>
 #include "r9a06g032.dtsi"
 
 / {
@@ -31,3 +33,118 @@ &wdt0 {
 	timeout-sec = <60>;
 	status = "okay";
 };
+
+&gmac2 {
+	status = "okay";
+	phy-mode = "gmii";
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
+&switch {
+	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;
+
+	dsa,member = <0 0>;
+
+	mdio {
+		clock-frequency = <2500000>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		switch0phy4: ethernet-phy@4{
+			reg = <4>;
+			micrel,led-mode = <1>;
+		};
+
+		switch0phy5: ethernet-phy@5{
+			reg = <5>;
+			micrel,led-mode = <1>;
+		};
+	};
+};
+
+&switch_port0 {
+	label = "lan0";
+	phy-mode = "mii";
+	phy-handle = <&switch0phy5>;
+	status = "okay";
+};
+
+&switch_port1 {
+	label = "lan1";
+	phy-mode = "mii";
+	phy-handle = <&switch0phy4>;
+	status = "okay";
+};
+
+&switch_port4 {
+	status = "okay";
+};
+
+&eth_miic {
+	status = "okay";
+	renesas,miic-switch-portin = <MIIC_GMAC2_PORT>;
+};
+
+&mii_conv4 {
+	renesas,miic-input = <MIIC_SWITCH_PORTB>;
+	status = "okay";
+};
+
+&mii_conv5 {
+	renesas,miic-input = <MIIC_SWITCH_PORTA>;
+	status = "okay";
+};
+
+&pinctrl{
+	pins_mdio1: pins_mdio1 {
+		pinmux = <
+			RZN1_PINMUX(152, RZN1_FUNC_MDIO1_SWITCH)
+			RZN1_PINMUX(153, RZN1_FUNC_MDIO1_SWITCH)
+		>;
+	};
+	pins_eth3: pins_eth3 {
+		pinmux = <
+			RZN1_PINMUX(36, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(37, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(38, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(39, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(40, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(41, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(42, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(43, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(44, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(45, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(46, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(47, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+		>;
+		drive-strength = <6>;
+		bias-disable;
+	};
+	pins_eth4: pins_eth4 {
+		pinmux = <
+			RZN1_PINMUX(48, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(49, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(50, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(51, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(52, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(53, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(54, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(55, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(56, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(57, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(58, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+			RZN1_PINMUX(59, RZN1_FUNC_CLK_ETH_MII_RGMII_RMII)
+		>;
+		drive-strength = <6>;
+		bias-disable;
+	};
+};
-- 
2.36.1

