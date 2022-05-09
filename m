Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E43751FE10
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiEINZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbiEINY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:24:59 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54C245BC;
        Mon,  9 May 2022 06:20:48 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2BA2324000A;
        Mon,  9 May 2022 13:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652102447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vmYYSGJabTpkUpcffwQ9sSbz8edOLY8zY8B9KyRjxVk=;
        b=NKDQdp6kO32r+eFcA2wRxFCxvmyskcyfnwSCWIaR+6skZCdVR8mhdUkzv6zUD4yBWm5BqC
        P41EpDwFgx5Hr1NujolhwWtwX7Rh4gmlT3nsjG/RxOCqGRa36YdaqWXUKfpqePyZ2mjCQI
        hFY/9Y2jR1rtGdGNtRcoKTZDCqEAbTWR0C5MIkwEJXjhfXhj2NUOiZmniYb2KKaL/zLnJN
        r6yUdffCZuKGQZcK/RsNnUicyafplZCWfpJPoIPEv5aNcbL8djt41V2dNfbI85L5ti8ISl
        Tt5qflrQW1yLGEqHHFkez4Si3NQpSqT/3RQMEu06ts/cOguhY8gT8w5TRT2/zQ==
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
Subject: [PATCH net-next v4 11/12] ARM: dts: r9a06g032: describe switch
Date:   Mon,  9 May 2022 15:18:59 +0200
Message-Id: <20220509131900.7840-12-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220509131900.7840-1-clement.leger@bootlin.com>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
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

Add description of the switch that is present on the RZ/N1 SoC.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 21246a48a66b..ce13b29f5c10 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -256,6 +256,15 @@ mii_conv5: mii-conv@5 {
 			};
 		};
 
+		switch: switch@44050000 {
+			compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
+			reg = <0x44050000 0x10000>;
+			clocks = <&sysctrl R9A06G032_HCLK_SWITCH>,
+				 <&sysctrl R9A06G032_CLK_SWITCH>;
+			clock-names = "hclk", "clk";
+			status = "disabled";
+		};
+
 		gic: interrupt-controller@44101000 {
 			compatible = "arm,gic-400", "arm,cortex-a7-gic";
 			interrupt-controller;
-- 
2.36.0

