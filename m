Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B996500D3F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242767AbiDNM2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243302AbiDNM1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:50 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FC32FFD9;
        Thu, 14 Apr 2022 05:25:01 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7530340016;
        Thu, 14 Apr 2022 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AVV9dorZosBq4Eyh1b2aaNZR5/BtAkbVcbEdxKlsk0U=;
        b=ZXZCFEZJZFOPGa3DQdbWkzZq1JfbrYDZrvBmdIbOvzc+GzBoh25nFw0FRAW/fgRxux76iR
        +HuXcfSuhHjOCJPhJ8T5Bt0nHCRmw8PG49EYPdGX1C1hYxo9B4D2WNEP6fnWJwOceuwujl
        vhkMjQ9SuruWqiX6CRrVl2JO4jPFcLtVhwO5y4teRCHr3o7V/P0B6CL4ImIzR6PJVRUeoT
        3tpc2xjgxsaLjeg3N/A6LhD5DoB9dh+18jnzSRotcLGSrBjY5dt0lib8HiRj6PRdkY2FGM
        zS+t6CyrzBwHSs8Kg/lN1R8fydMT7MQXe+IHwxCQwX9lFfpdnzrYm1ShMysM1Q==
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
Subject: [PATCH net-next 11/12] ARM: dts: r9a06g032: describe switch
Date:   Thu, 14 Apr 2022 14:22:49 +0200
Message-Id: <20220414122250.158113-12-clement.leger@bootlin.com>
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

Add description of the switch that is present on the RZ/N1 SoC.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 9be55957b8e5..c04b382a20f0 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -250,6 +250,17 @@ mii_conv4: mii-conv@4 {
 			};
 		};
 
+		switch: switch@44050000 {
+			compatible = "renesas,rzn1-a5psw";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x44050000 0x10000>;
+			clocks = <&sysctrl R9A06G032_HCLK_SWITCH>,
+				 <&sysctrl R9A06G032_CLK_SWITCH>;
+			clock-names = "hclk_switch", "clk_switch";
+			status = "disabled";
+		};
+
 		gic: interrupt-controller@44101000 {
 			compatible = "arm,gic-400", "arm,cortex-a7-gic";
 			interrupt-controller;
-- 
2.34.1

