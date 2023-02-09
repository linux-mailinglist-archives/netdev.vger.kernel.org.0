Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AA2690CB0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjBIPPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjBIPPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:15:21 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20379643D1;
        Thu,  9 Feb 2023 07:14:51 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AA8FF10000D;
        Thu,  9 Feb 2023 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675955690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2K1Mbt7RBxJUSeZsp99AVJE/j6M83BKYvRqSEdsUyg=;
        b=TX80F+//HsPulsgl6DqW+yS2ORLQU1YgVgOl/e3yxGJDXEtTRoslNP9e+b4yQXUAvC4aT0
        xWgoT3e+fjt2RTaqpy9k9HV8pfSxinULNdxqfhainxZgqkIx5VO1d/+erfvBnNhkqowwWt
        AWMVLgMq2pbG+/m7HJJRoga9mYX8QbRy1ZzDLy2B35Tr7NXlVGBtL3VXxlwFwKtJ8/B85z
        j3IaYBpakuQjBwjTkBchTVvnCil9Hk6WdTMS/0M54DEElAOiJp3v+aT9vV1HOVkGeK4wcj
        uoBBXW94H3Sf8hCFlEmJVV0AmLzn4L4nxM+q+be65JwQwcztkmZAksHdBqa2mg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v3 6/6] ARM: dts: r9a06g032: describe GMAC1
Date:   Thu,  9 Feb 2023 16:16:32 +0100
Message-Id: <20230209151632.275883-7-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209151632.275883-1-clement.leger@bootlin.com>
References: <20230209151632.275883-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/N1 SoC includes two MAC named GMACx that are compatible with the
"snps,dwmac" driver. GMAC1 is connected directly to the MII converter
port 1. Since this MII converter is represented using a PCS driver, it
uses the renesas specific compatible driver which uses this PCS.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 arch/arm/boot/dts/r9a06g032.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 41e19c0986ce..ba32e4429b01 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -304,6 +304,24 @@ dma1: dma-controller@40105000 {
 			data-width = <8>;
 		};
 
+		gmac1: ethernet@44000000 {
+			compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";
+			reg = <0x44000000 0x2000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+			clock-names = "stmmaceth";
+			clocks = <&sysctrl R9A06G032_HCLK_GMAC0>;
+			snps,multicast-filter-bins = <256>;
+			snps,perfect-filter-entries = <128>;
+			tx-fifo-depth = <2048>;
+			rx-fifo-depth = <4096>;
+			pcs-handle = <&mii_conv1>;
+			status = "disabled";
+		};
+
 		gmac2: ethernet@44002000 {
 			compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";
 			reg = <0x44002000 0x2000>;
-- 
2.39.0

