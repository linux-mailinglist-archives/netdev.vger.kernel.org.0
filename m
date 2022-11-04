Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F98C6199EC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiKDOaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiKDO3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:29:51 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC605317E6;
        Fri,  4 Nov 2022 07:28:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3B0CF240008;
        Fri,  4 Nov 2022 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667572086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N4H9heDGWlyybibpeQVan2sHfk653swA/LCvVtdBxVE=;
        b=RE2XDDxBtp/NvYYadbfvp1yz/fdy6gDteYOCHBLfJTzvrE32UNrHWXUfHlHdldaL73R2LR
        vZnRBog4uesBXX1U3YCMgMr6Hj/g3bWSePWao1ZVtDdEolO9+6Spg2kGwyQmFZL8C67tIh
        HZZVdYr1kimNBN6FpzwjCwiw+r9vlVZcVCaccCQHXMlbO33SZIgNEzkeOc4W0EOKZNZ2cW
        HkTi6R2S8Z1mgexJ48Ou5tNjH50A567qkYf4vtTT5Rg/7D8dmvar2DaTVmcfBhxJVus2cj
        5RaJomUAkDnfIEfdUUl5pMXMBuWAiN50JIfld1TGsYcX1vhed2E97Y888bHuJg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet controller
Date:   Fri,  4 Nov 2022 15:27:46 +0100
Message-Id: <20221104142746.350468-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
V6->V7:
 - No Changes
V5->V6:
 - Removed extra blank lines
 - Put the status property last
V4->V5:
 - Reword the commit log
V3->V4:
 - No Changes
V2->V3:
 - No Changes
V1->V2:
 - Added clock and resets

 arch/arm/boot/dts/qcom-ipq4019.dtsi | 44 +++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index b23591110bd2..5fa1af147df9 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -38,6 +38,7 @@ aliases {
 		spi1 = &blsp1_spi2;
 		i2c0 = &blsp1_i2c3;
 		i2c1 = &blsp1_i2c4;
+		ethernet0 = &gmac;
 	};
 
 	cpus {
@@ -591,6 +592,49 @@ wifi1: wifi@a800000 {
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
+			phy-mode = "internal";
+			status = "disabled";
+		};
+
 		mdio: mdio@90000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.37.3

