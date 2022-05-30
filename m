Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3E53781E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbiE3IwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbiE3IvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:51:15 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D325578EE4;
        Mon, 30 May 2022 01:51:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2501F6001D;
        Mon, 30 May 2022 08:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653900662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TY6mO5MGkPlLGNN2BwbTH+9HhZdCoIA9JNfsSiLUiTk=;
        b=lAcBi8+jNyyswKogLL+4PKDo3GXqWzQQp3f5ojEgJVqhwrakX1dYpO6UVRdahtw6OMewNR
        PxiuLX27BySxVEX/VFZD7zh1HGlc8KffXP9jS17p53WhPpkq3rVeFTayO4oRaN4c8Jbi0V
        6jxas/xpJUjVCwn9Y/MdGGzCps7N7xopU3m6X6bPpMtYMr1zg9QKn76ka8ZMToozLnu0A9
        CQMukVzy31kHHM0UcRtudUdY9p5JQoh69JfVZ30dGFq0i/p7TsfZX15xQNIfcnnbYAxNq7
        HeusnUWyqrn36BhVhtsW0QlN3cN5txFalQ0uuSt47cKoY/RbNQnXRKGUqRpUMQ==
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
Subject: [PATCH net-next v6 12/16] ARM: dts: r9a06g032: describe MII converter
Date:   Mon, 30 May 2022 10:49:13 +0200
Message-Id: <20220530084917.91130-13-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220530084917.91130-1-clement.leger@bootlin.com>
References: <20220530084917.91130-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 636a6ab31c58..981407f4c463 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -200,6 +200,45 @@ nand_controller: nand-controller@40102000 {
 			status = "disabled";
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
2.36.0

