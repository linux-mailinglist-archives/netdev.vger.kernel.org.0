Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E651B500D33
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243240AbiDNM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243280AbiDNM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:47 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4E82ED6D;
        Thu, 14 Apr 2022 05:24:58 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 37F4A40012;
        Thu, 14 Apr 2022 12:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LvyGZlJTusHjC+6cCCIqRpU/42tp9G7ZAYkwBVky9go=;
        b=GfGFZlgr9FzycVFAky/ByRitXjy+YGeUNyCd/YSu5hXmaHr5V2ZF3InpXsS/tz9tf1C6OB
        JtAv0ERemUIuRnsUUr3+FTalOdHvShv76MxPYxKvgi6GDcg6QqtMF7dJD5FFD63jSSekJ8
        zL1MK+hd3FUp8M7N0phYiYsK98YSiQqGakuqmF9acJDj7x/VRsxxPtDyY2boAKRIzi3SsZ
        kP3RNmtjhOyOlbW0vUfFlYI0SzPEtQBYtkwZmiTm08kRK0rBoW1NtIiaExMCypjs/AGJYM
        AZkhyXGzRacRH3Z7D+AEMMKXknqgY1KwPSDk1k9iTSb9voF6ogwTwMtJDJE8Uw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII converter
Date:   Thu, 14 Apr 2022 14:22:47 +0200
Message-Id: <20220414122250.158113-10-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
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
 arch/arm/boot/dts/r9a06g032.dtsi | 33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 636a6ab31c58..fd174df268e8 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -200,6 +200,39 @@ nand_controller: nand-controller@40102000 {
 			status = "disabled";
 		};
 
+		eth_miic: eth-miic@44030000 {
+			compatible = "renesas,rzn1-miic";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x44030000 0x10000>;
+			clocks = <&sysctrl R9A06G032_CLK_MII_REF>,
+				 <&sysctrl R9A06G032_CLK_RGMII_REF>,
+				 <&sysctrl R9A06G032_CLK_RMII_REF>,
+				 <&sysctrl R9A06G032_HCLK_SWITCH_RG>;
+			clock-names = "mii_ref", "rgmii_ref", "rmii_ref", "hclk_switch_rg";
+			status = "disabled";
+
+			mii_conv0: mii-conv@0 {
+				reg = <0>;
+			};
+
+			mii_conv1: mii-conv@1 {
+				reg = <1>;
+			};
+
+			mii_conv2: mii-conv@2 {
+				reg = <2>;
+			};
+
+			mii_conv3: mii-conv@3 {
+				reg = <3>;
+			};
+
+			mii_conv4: mii-conv@4 {
+				reg = <4>;
+			};
+		};
+
 		gic: interrupt-controller@44101000 {
 			compatible = "arm,gic-400", "arm,cortex-a7-gic";
 			interrupt-controller;
-- 
2.34.1

