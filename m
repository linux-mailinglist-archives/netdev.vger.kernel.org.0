Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1C220AC8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 13:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgGOLJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 07:09:27 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:37974 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728871AbgGOLJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 07:09:24 -0400
X-IronPort-AV: E=Sophos;i="5.75,355,1589209200"; 
   d="scan'208";a="52194042"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 15 Jul 2020 20:09:22 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 6473A4006DF5;
        Wed, 15 Jul 2020 20:09:17 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 01/20] arm64: dts: renesas: r8a774e1: Add operating points
Date:   Wed, 15 Jul 2020 12:08:51 +0100
Message-Id: <1594811350-14066-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

The RZ/G2H (r8a774e1) comes with two clusters of processors, similarly to
the r8a774a1. The first cluster is made of A57s, the second cluster is made
of A53s.

The operating points for the cluster with the A57s are:

Frequency | Voltage
----------|---------
500 MHz   | 0.82V
1.0 GHz   | 0.82V
1.5 GHz   | 0.82V

The operating points for the cluster with the A53s are:

Frequency | Voltage
----------|---------
800 MHz   | 0.82V
1.0 GHz   | 0.82V
1.2 GHz   | 0.82V

This patch adds the definitions for the operating points to the SoC
specific DT.

Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi | 51 +++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index caca319aafcf..588de69734ef 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -34,6 +34,49 @@
 		clock-frequency = <0>;
 	};
 
+	cluster0_opp: opp_table0 {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-500000000 {
+			opp-hz = /bits/ 64 <500000000>;
+			opp-microvolt = <820000>;
+			clock-latency-ns = <300000>;
+		};
+		opp-1000000000 {
+			opp-hz = /bits/ 64 <1000000000>;
+			opp-microvolt = <820000>;
+			clock-latency-ns = <300000>;
+		};
+		opp-1500000000 {
+			opp-hz = /bits/ 64 <1500000000>;
+			opp-microvolt = <820000>;
+			clock-latency-ns = <300000>;
+			opp-suspend;
+		};
+	};
+
+	cluster1_opp: opp_table1 {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-800000000 {
+			opp-hz = /bits/ 64 <800000000>;
+			opp-microvolt = <820000>;
+			clock-latency-ns = <300000>;
+		};
+		opp-1000000000 {
+			opp-hz = /bits/ 64 <1000000000>;
+			opp-microvolt = <820000>;
+			clock-latency-ns = <300000>;
+		};
+		opp-1200000000 {
+			opp-hz = /bits/ 64 <1200000000>;
+			opp-microvolt = <820000>;
+			clock-latency-ns = <300000>;
+		};
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -79,6 +122,7 @@
 			enable-method = "psci";
 			dynamic-power-coefficient = <854>;
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z>;
+			operating-points-v2 = <&cluster0_opp>;
 			capacity-dmips-mhz = <1024>;
 			#cooling-cells = <2>;
 		};
@@ -91,6 +135,7 @@
 			next-level-cache = <&L2_CA57>;
 			enable-method = "psci";
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z>;
+			operating-points-v2 = <&cluster0_opp>;
 			capacity-dmips-mhz = <1024>;
 			#cooling-cells = <2>;
 		};
@@ -103,6 +148,7 @@
 			next-level-cache = <&L2_CA57>;
 			enable-method = "psci";
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z>;
+			operating-points-v2 = <&cluster0_opp>;
 			capacity-dmips-mhz = <1024>;
 			#cooling-cells = <2>;
 		};
@@ -115,6 +161,7 @@
 			next-level-cache = <&L2_CA57>;
 			enable-method = "psci";
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z>;
+			operating-points-v2 = <&cluster0_opp>;
 			capacity-dmips-mhz = <1024>;
 			#cooling-cells = <2>;
 		};
@@ -129,6 +176,7 @@
 			#cooling-cells = <2>;
 			dynamic-power-coefficient = <277>;
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z2>;
+			operating-points-v2 = <&cluster1_opp>;
 			capacity-dmips-mhz = <535>;
 		};
 
@@ -140,6 +188,7 @@
 			next-level-cache = <&L2_CA53>;
 			enable-method = "psci";
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z2>;
+			operating-points-v2 = <&cluster1_opp>;
 			capacity-dmips-mhz = <535>;
 		};
 
@@ -151,6 +200,7 @@
 			next-level-cache = <&L2_CA53>;
 			enable-method = "psci";
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z2>;
+			operating-points-v2 = <&cluster1_opp>;
 			capacity-dmips-mhz = <535>;
 		};
 
@@ -162,6 +212,7 @@
 			next-level-cache = <&L2_CA53>;
 			enable-method = "psci";
 			clocks = <&cpg CPG_CORE R8A774E1_CLK_Z2>;
+			operating-points-v2 = <&cluster1_opp>;
 			capacity-dmips-mhz = <535>;
 		};
 
-- 
2.17.1

