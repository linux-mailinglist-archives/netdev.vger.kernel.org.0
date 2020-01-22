Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7F0145554
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAVNU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:20:56 -0500
Received: from inva020.nxp.com ([92.121.34.13]:41734 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgAVNUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:54 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D1D8E1A3D6C;
        Wed, 22 Jan 2020 14:20:52 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C4F751A294D;
        Wed, 22 Jan 2020 14:20:52 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 82EED205CD;
        Wed, 22 Jan 2020 14:20:52 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net 2/3] powerpc/fsl/dts: add fsl,erratum-a011043
Date:   Wed, 22 Jan 2020 15:20:28 +0200
Message-Id: <1579699229-5948-3-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fsl,erratum-a011043 to internal MDIO buses.
Software may get false read error when reading internal
PCS registers through MDIO. As a workaround, all internal
MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi              | 1 +
 18 files changed, 18 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index e1a961f05dcd..baa0c503e741 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -63,6 +63,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy0: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index c288f3c6c637..93095600e808 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -60,6 +60,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy6: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index 94f3e7175012..ff4bd38f0645 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -63,6 +63,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy1: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 94a76982d214..1fa38ed6f59e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -60,6 +60,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy7: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index b5ff5f71c6b8..a8cc9780c0c4 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy0: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index ee44182c6348..8b8bd70c9382 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy1: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index f05f0d775039..619c880b54d8 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe5000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy2: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index a9114ec51075..d7ebb73a400d 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe7000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy3: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index 44dd00ac7367..b151d696a069 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe9000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy4: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index 5b1b84b58602..adc0ae0013a3 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xeb000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy5: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 0e1daaef9e74..435047e0e250 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -60,6 +60,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy14: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index 68c5ef779266..c098657cca0a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -60,6 +60,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy15: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 605363cc1117..9d06824815f3 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy8: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 1955dfa13634..70e947730c4b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy9: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index 2c1476454ee0..ad96e6529595 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe5000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy10: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index b8b541ff5fb0..034bc4b71f7a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe7000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy11: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 4b2cfddd1b15..93ca23d82b39 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe9000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy12: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 0a52ddf7cc17..23b3117a2fd2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xeb000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy13: ethernet-phy@0 {
 			reg = <0x0>;
-- 
2.1.0

