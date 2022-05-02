Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6DE5175ED
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386699AbiEBRhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386701AbiEBRhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:37:34 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D186386
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 10:34:02 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:cd2b:85eb:bdf:a9c3])
        by laurent.telenet-ops.be with bizsmtp
        id RtZv2700M3SeZYW01tZvkJ; Mon, 02 May 2022 19:34:00 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nlZvm-002nnK-Sp; Mon, 02 May 2022 19:33:54 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nlZvm-0038dH-Ef; Mon, 02 May 2022 19:33:54 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] arm64: dts: renesas: Add interrupt-names to CANFD nodes
Date:   Mon,  2 May 2022 19:33:52 +0200
Message-Id: <10eef1e20372af4a156b06df8e5124666ec7c6b6.1651512451.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651512451.git.geert+renesas@glider.be>
References: <cover.1651512451.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Renesas R-Car CAN FD Controller on R-Car Gen3 and RZ/G2 SoCs has two
interrupts.  Add interrupt-names properties to all CAN-FD device nodes
to identify the individual interrupts, so we can make this property a
required property in the DT bindings.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77951.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77960.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77961.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77965.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77970.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77980.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 1 +
 arch/arm64/boot/dts/renesas/r8a77995.dtsi | 1 +
 12 files changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index faf5bbbb3710ebe8..a31ded74b02e8e95 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1179,6 +1179,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 				 <&cpg CPG_CORE R8A774A1_CLK_CANFD>,
 				 <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index be998bc4041283ec..7ecb7e553e3c9d95 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -1052,6 +1052,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 				 <&cpg CPG_CORE R8A774B1_CLK_CANFD>,
 				 <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 4f69f90d88cbbc1e..459da7091723710c 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -1009,6 +1009,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 				 <&cpg CPG_CORE R8A774C0_CLK_CANFD>,
 				 <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index 989c1c00dcdcb393..34530881f9e3f782 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -1280,6 +1280,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 				 <&cpg CPG_CORE R8A774E1_CLK_CANFD>,
 				 <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77951.dtsi b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
index 884210544ba01a4c..5eed142147d14fe7 100644
--- a/arch/arm64/boot/dts/renesas/r8a77951.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
@@ -1368,6 +1368,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 			       <&cpg CPG_CORE R8A7795_CLK_CANFD>,
 			       <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index 0d96b5bb958489ff..57d990e1c132d0c7 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -1240,6 +1240,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 			       <&cpg CPG_CORE R8A7796_CLK_CANFD>,
 			       <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77961.dtsi b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
index 58e161e5dae0e4cd..9f5cd45664083b12 100644
--- a/arch/arm64/boot/dts/renesas/r8a77961.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
@@ -1229,6 +1229,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 			       <&cpg CPG_CORE R8A77961_CLK_CANFD>,
 			       <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index ecca9582edf6a739..951bbcef6ff845e9 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -1103,6 +1103,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 			       <&cpg CPG_CORE R8A77965_CLK_CANFD>,
 			       <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77970.dtsi b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
index 79718234d85fe50d..ac78c41c66f80874 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
@@ -557,6 +557,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 				 <&cpg CPG_CORE R8A77970_CLK_CANFD>,
 				 <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index 148983130adf3113..e4163bde7c436fb9 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -609,6 +609,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 				 <&cpg CPG_CORE R8A77980_CLK_CANFD>,
 				 <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 5d41e46d06f566e2..5d877d7bb2edf8b9 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -1052,6 +1052,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 			       <&cpg CPG_CORE R8A77990_CLK_CANFD>,
 			       <&can_clk>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77995.dtsi b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
index 0eccf81db3747eae..55b3d1b2adf5a8a4 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
@@ -557,6 +557,7 @@ canfd: can@e66c0000 {
 			reg = <0 0xe66c0000 0 0x8000>;
 			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
 				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ch_int", "g_int";
 			clocks = <&cpg CPG_MOD 914>,
 			       <&cpg CPG_CORE R8A77995_CLK_CANFD>,
 			       <&can_clk>;
-- 
2.25.1

