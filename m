Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5278B52D7B3
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiESPdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241075AbiESPdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:33:00 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3B162BE2;
        Thu, 19 May 2022 08:32:53 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8D105FF806;
        Thu, 19 May 2022 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652974372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oL5qawJmkUzS7o+kdJIgpH3uP+moAKieArFVw9WPNlU=;
        b=oG2qRw0GXw72svAMipta0NXey9MEtERPCAQUV8k3ByocdfoZ7zpog7XkkTKemEXNWXQxf6
        gZsndjgm8BKJ1yiKotVn63+ZnaKZylctmMZPNU/XzVAaUtOWjdPhXafruy9AbCY/khtVs6
        lWBzEfS3H5ZdTpZ1I1P2hwcrgrKV3KpOlvR9IdsO2QGQ4aZHU6Nc/geXGUM9ybqcAYWVUR
        YcVeJUdWT+leHKqffuiaHaGvKuqvrqxsmLN2RmV/+582M5QcIinwn2T6F8N/BWqRp7cyKF
        ECy4ZxP9Su+UgterehPbcIt2roS0aLeF/Ch1154XEfkYi+iAKD3XTD7UFmivmg==
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
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 11/13] ARM: dts: r9a06g032: describe GMAC2
Date:   Thu, 19 May 2022 17:31:05 +0200
Message-Id: <20220519153107.696864-12-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519153107.696864-1-clement.leger@bootlin.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm/boot/dts/r9a06g032.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 0051fe9f44fd..31c4b2e2950a 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -200,6 +200,23 @@ nand_controller: nand-controller@40102000 {
 			status = "disabled";
 		};
 
+		gmac2: ethernet@44002000 {
+			compatible = "snps,dwmac";
+			reg = <0x44002000 0x2000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+			clock-names = "stmmaceth";
+			clocks = <&sysctrl R9A06G032_HCLK_GMAC1>;
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
2.36.0

