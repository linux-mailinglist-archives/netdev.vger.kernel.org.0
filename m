Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41462546441
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 12:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348505AbiFJKoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 06:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348637AbiFJKn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 06:43:27 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8119B65436;
        Fri, 10 Jun 2022 03:39:31 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8653424000F;
        Fri, 10 Jun 2022 10:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654857570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CJKYeXeqtq67ArnABaZR/HqqUKKpqyl12ANAPvsb920=;
        b=Vh99Of3LScIDWGhaVtTdCncLzXvzUIc7VvosffVOF3UCAR+P1IgMPs5As7BeXkPUmw5RnQ
        yEzoFTsDi7Nui5XJVjL/B8zoEjwuJIiahSDV+elCuEk6H7mwj7Pbuc8Op0xZbm0N4RwIxs
        nHpJ9sp6Dn04wMhuybIxjcL4S59bRoGS+LYxvGl0O5U0ShuJcfAvkwMqD3BS5YovZ3GdPi
        7BV7IwggcQGukhYW6tgcqiMY+vX9U+Pb5L+L8SyzwAbZEIv6Uxgs9bYywyyjTl67vXPM+m
        Wx7v6WobKo4vy3z1JpU2BP97BI6C9Q45VdyoQ8qboVgbb2wwYwoOLBldQ7cLhg==
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
Subject: [PATCH RESEND net-next v7 12/16] ARM: dts: r9a06g032: describe MII converter
Date:   Fri, 10 Jun 2022 12:37:08 +0200
Message-Id: <20220610103712.550644-13-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610103712.550644-1-clement.leger@bootlin.com>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the MII converter node which describes the MII converter that is
present on the RZ/N1 SoC.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032.dtsi | 39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index d3665910958b..f6241af33112 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -304,6 +304,45 @@ dma1: dma-controller@40105000 {
 			data-width = <8>;
 		};
 
+		eth_miic: eth-miic@44030000 {
+			compatible = "renesas,r9a06g032-miic", "renesas,rzn1-miic";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x44030000 0x10000>;
+			clocks = <&sysctrl R9A06G032_CLK_MII_REF>,
+				 <&sysctrl R9A06G032_CLK_RGMII_REF>,
+				 <&sysctrl R9A06G032_CLK_RMII_REF>,
+				 <&sysctrl R9A06G032_HCLK_SWITCH_RG>;
+			clock-names = "mii_ref", "rgmii_ref", "rmii_ref", "hclk";
+			power-domains = <&sysctrl>;
+			status = "disabled";
+
+			mii_conv1: mii-conv@1 {
+				reg = <1>;
+				status = "disabled";
+			};
+
+			mii_conv2: mii-conv@2 {
+				reg = <2>;
+				status = "disabled";
+			};
+
+			mii_conv3: mii-conv@3 {
+				reg = <3>;
+				status = "disabled";
+			};
+
+			mii_conv4: mii-conv@4 {
+				reg = <4>;
+				status = "disabled";
+			};
+
+			mii_conv5: mii-conv@5 {
+				reg = <5>;
+				status = "disabled";
+			};
+		};
+
 		gic: interrupt-controller@44101000 {
 			compatible = "arm,gic-400", "arm,cortex-a7-gic";
 			interrupt-controller;
-- 
2.36.1

