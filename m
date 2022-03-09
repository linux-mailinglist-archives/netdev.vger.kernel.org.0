Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CD04D35E1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiCIQhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiCIQd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:33:56 -0500
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39706986FF;
        Wed,  9 Mar 2022 08:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646843174;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=BS9rivvrM1jXQljri4Q7sB7RJlmANPC4JfSlgqLdLLE=;
    b=oxcgg6jGmzuWyDbsRkr48avo0C9PaUkgyeslGyTTQtSt+2xhCee/8xPASxyxrXAovW
    GA2qHitQkoXO4H1LPFI/WV8qbsuEFW8kgZzmvIZS6892Rw2TKh4opszCme7RmbmOAv/x
    2pGe8k90t0gYHclvPbJIEsKBtZ3FRgA4J6LgGZI9JnFsNE+wa8Duutp8FIqYbNJRRf1v
    kWHkUVxZu5Hx53SGk7I+T7YeZ4hYRMyEK9qVZSs/6A7yAb12IKu2HcfLM3Mzly0smt24
    hBEZHZZay4rxRrGijBoOA1fqykeaveToq6DBPyqmQn/N5oVDD/wE0lRKAmyLWID7trrO
    VRig==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82Fcd2Ywjw=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.40.1 DYNA|AUTH)
    with ESMTPSA id 646b0ey29GQEJWD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Mar 2022 17:26:14 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com, horms@verge.net.au,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 2/4] arm64: dts: renesas: r8a779a0: Add CANFD device node
Date:   Wed,  9 Mar 2022 17:26:07 +0100
Message-Id: <20220309162609.3726306-3-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309162609.3726306-1-uli+renesas@fpond.eu>
References: <20220309162609.3726306-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a CANFD device node for r8a779a0.

Based on patch by Kazuya Mizuguchi.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 56 +++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index c4be288b1912..c80f4584035e 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -24,6 +24,13 @@ aliases {
 		i2c6 = &i2c6;
 	};
 
+	/* External CAN clock - to be overridden by boards that provide it */
+	can_clk: can {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -596,6 +603,55 @@ hscif3: serial@e66a0000 {
 			status = "disabled";
 		};
 
+		canfd: can@e6660000 {
+			compatible = "renesas,r8a779a0-canfd";
+			reg = <0 0xe6660000 0 0x8000>;
+			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
+			clocks = <&cpg CPG_MOD 328>,
+				 <&cpg CPG_CORE R8A779A0_CLK_CANFD>,
+				 <&can_clk>;
+			clock-names = "fck", "canfd", "can_clk";
+			assigned-clocks = <&cpg CPG_CORE R8A779A0_CLK_CANFD>;
+			assigned-clock-rates = <80000000>;
+			power-domains = <&sysc R8A779A0_PD_ALWAYS_ON>;
+			resets = <&cpg 328>;
+			status = "disabled";
+
+			channel0 {
+				status = "disabled";
+			};
+
+			channel1 {
+				status = "disabled";
+			};
+
+			channel2 {
+				status = "disabled";
+			};
+
+			channel3 {
+				status = "disabled";
+			};
+
+			channel4 {
+				status = "disabled";
+			};
+
+			channel5 {
+				status = "disabled";
+			};
+
+			channel6 {
+				status = "disabled";
+			};
+
+			channel7 {
+				status = "disabled";
+			};
+		};
+
 		avb0: ethernet@e6800000 {
 			compatible = "renesas,etheravb-r8a779a0",
 				     "renesas,etheravb-rcar-gen3";
-- 
2.30.2

