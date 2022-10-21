Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F5E60773C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJUMqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJUMqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:46:15 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89430262DE2;
        Fri, 21 Oct 2022 05:46:10 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9576360015;
        Fri, 21 Oct 2022 12:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666356368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPwF2UjPl7y7IX+Y6gImoAKgcTPqVNQNiaKw7TX3r9Y=;
        b=TfaArumbxEPSY0Qw9NyxCw2g2/FYgtpNZRDflJa7HtsUGcxM8h7F00UwNr9YEJ7Vh7r5Rl
        cnT5yHDfAo/JoWYff4mfi4TGm/blNVJRtTCfiC36cOg887vRO1yaOu1PrZtXuE2O4xCbZk
        EVZfPJzM40CcMXyWK09rRta2QX8rAdGJUTBW6JEDtYq8PcjQpOOhkhqh92aNR0uBsZbxig
        eqpmKwy2nOwNhT9gAjfUrZiZMFR5YHmsmeuLGc4q30nx//jKKSnhpxxwmWuvV2KLPIDcb3
        zEnMlOEP4Q5tPhI2ymWbiI/r/uFvIo/yrPdY+4NwnnIKAL6XAQDg+f+ikkrdqQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v5 5/5] ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet controller
Date:   Fri, 21 Oct 2022 14:45:56 +0200
Message-Id: <20221021124556.100445-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Qualcomm IPQ4019 includes an internal 5 ports switch, which is
connected to the CPU through the internal IPQESS Ethernet controller.

Add support for this internal interface, which is internally connected to a
modified version of the QCA8K Ethernet switch.

This Ethernet controller only support a specific internal interface mode
for connection to the switch.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
V4->V5:
 - Reword the commit log
V3->V4:
 - No Changes
V2->V3:
 - No Changes
V1->V2:
 - Added clock and resets
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 46 +++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index b23591110bd2..0092a881dbf4 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -38,6 +38,7 @@ aliases {
 		spi1 = &blsp1_spi2;
 		i2c0 = &blsp1_i2c3;
 		i2c1 = &blsp1_i2c4;
+		ethernet0 = &gmac;
 	};
 
 	cpus {
@@ -591,6 +592,51 @@ wifi1: wifi@a800000 {
 			status = "disabled";
 		};
 
+		gmac: ethernet@c080000 {
+			compatible = "qcom,ipq4019-ess-edma";
+			reg = <0xc080000 0x8000>;
+			resets = <&gcc ESS_RESET>;
+			reset-names = "ess";
+			clocks = <&gcc GCC_ESS_CLK>;
+			clock-names = "ess";
+			interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
+
+			status = "disabled";
+
+			phy-mode = "internal";
+		};
+
 		mdio: mdio@90000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.37.3

