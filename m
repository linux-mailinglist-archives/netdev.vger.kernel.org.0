Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ED65463DD
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 12:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348927AbiFJKdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 06:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348758AbiFJKbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 06:31:45 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC5343EFB;
        Fri, 10 Jun 2022 03:30:59 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DAA76100003;
        Fri, 10 Jun 2022 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654857058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kCft54/wbUztXKT2urhOKH33tJlwwROSYaG1fJeAUws=;
        b=Todfs8xIl83n8FNh1kh+u1ErHQxJFExbUpQwcvqo53eJR4bYI2+JGp0D5uvnrzMvp4830O
        jJCeTwZgmFIPQP/sNdmBQb7wUKOKkumtB9c44kbWcWoDN6ZMMFnVafSyA9urlMIiuiPAy0
        tgAzkGSGe8TnV/MJ9Olg8FWxMXMGLDqewNURjsMcOTbv/htXxrAYv+54nwPI8D/mEaLwk4
        vEwPBcpyqF65Q0441Ffr+Ok+gOT/TSaEHXjf/qVZpo7NUJBdWGSdniiQQVLDsWezTcubxd
        C2ze8wjBQokhZzRF0ZlES9c8+MS40gNOcaryW8aMsf7312qUQijGNcDf7hgmvw==
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
Subject: [PATCH net-next v7 13/16] ARM: dts: r9a06g032: describe GMAC2
Date:   Fri, 10 Jun 2022 12:28:30 +0200
Message-Id: <20220610102833.541098-14-clement.leger@bootlin.com>
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

RZ/N1 SoC includes two MAC named GMACx that are compatible with the
"snps,dwmac" driver. GMAC1 is connected directly to the MII converter
port 1. GMAC2 however can be used as the MAC for the switch CPU
management port or can be muxed to be connected directly to the MII
converter port 2. This commit add description for the GMAC2 which will
be used by the switch description.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index f6241af33112..42ce02e51e8d 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -304,6 +304,24 @@ dma1: dma-controller@40105000 {
 			data-width = <8>;
 		};
 
+		gmac2: ethernet@44002000 {
+			compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";
+			reg = <0x44002000 0x2000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+			clocks = <&sysctrl R9A06G032_HCLK_GMAC1>;
+			clock-names = "stmmaceth";
+			power-domains = <&sysctrl>;
+			snps,multicast-filter-bins = <256>;
+			snps,perfect-filter-entries = <128>;
+			tx-fifo-depth = <2048>;
+			rx-fifo-depth = <4096>;
+			status = "disabled";
+		};
+
 		eth_miic: eth-miic@44030000 {
 			compatible = "renesas,r9a06g032-miic", "renesas,rzn1-miic";
 			#address-cells = <1>;
-- 
2.36.1

