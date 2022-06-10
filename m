Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699605463EB
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346635AbiFJKdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 06:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346996AbiFJKcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 06:32:36 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73D0443FD;
        Fri, 10 Jun 2022 03:31:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B59CD100005;
        Fri, 10 Jun 2022 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654857062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ixn6VxPpYWukGE/3LzOK+/iTGwm5gXngXVmL8kCC5iA=;
        b=lZqkcrC3k7geFzp6ip+EgxxPVLhnRO4wUZ8wRnK8mCWlhTc1gaipFRF3zoHFZFBiBUGTF2
        R/69nV92DWolEFJuxBwdYJC+whplE7RI9GGUfgesnRqNfpdhPzYNxQa4o2IcI/eA19Q4v+
        8ufF06L/VsD73HYXh/w/T1go/dVnjCKCoCKGtKNzQoKSrrIk39zm5ChBeOcsvUeFWUwCoV
        HrqKoFwFAWWFzqeqaKo4e+IF1OIa/XdXYKvf5nADtdU0aB1gtcYRTtrMXX5A/hQcMauKlY
        jdHzw1tIKFr7YPFlM0lrjI7dnvXY9N/AbLlqlfU/SIJC5TJ+nfT6Wmv1zQoF3w==
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
Subject: [PATCH net-next v7 14/16] ARM: dts: r9a06g032: describe switch
Date:   Fri, 10 Jun 2022 12:28:31 +0200
Message-Id: <20220610102833.541098-15-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610102833.541098-1-clement.leger@bootlin.com>
References: <20220610102833.541098-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description of the switch that is present on the RZ/N1 SoC. This
description includes ethernet-ports description for all the ports that
are present on the switch along with their connection to the MII
converter ports and to the GMAC for the CPU port.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032.dtsi | 51 ++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 42ce02e51e8d..5b97fa85474f 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -361,6 +361,57 @@ mii_conv5: mii-conv@5 {
 			};
 		};
 
+		switch: switch@44050000 {
+			compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
+			reg = <0x44050000 0x10000>;
+			clocks = <&sysctrl R9A06G032_HCLK_SWITCH>,
+				 <&sysctrl R9A06G032_CLK_SWITCH>;
+			clock-names = "hclk", "clk";
+			power-domains = <&sysctrl>;
+			status = "disabled";
+
+			ethernet-ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				switch_port0: port@0 {
+					reg = <0>;
+					pcs-handle = <&mii_conv5>;
+					status = "disabled";
+				};
+
+				switch_port1: port@1 {
+					reg = <1>;
+					pcs-handle = <&mii_conv4>;
+					status = "disabled";
+				};
+
+				switch_port2: port@2 {
+					reg = <2>;
+					pcs-handle = <&mii_conv3>;
+					status = "disabled";
+				};
+
+				switch_port3: port@3 {
+					reg = <3>;
+					pcs-handle = <&mii_conv2>;
+					status = "disabled";
+				};
+
+				switch_port4: port@4 {
+					reg = <4>;
+					ethernet = <&gmac2>;
+					label = "cpu";
+					phy-mode = "internal";
+					status = "disabled";
+					fixed-link {
+						speed = <1000>;
+						full-duplex;
+					};
+				};
+			};
+		};
+
 		gic: interrupt-controller@44101000 {
 			compatible = "arm,gic-400", "arm,cortex-a7-gic";
 			interrupt-controller;
-- 
2.36.1

