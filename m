Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A47281D64
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgJBVIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:08:46 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46988 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgJBVIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:08:45 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F6D42001D0;
        Fri,  2 Oct 2020 23:08:43 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5EF6B200178;
        Fri,  2 Oct 2020 23:08:43 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E3993202AC;
        Fri,  2 Oct 2020 23:08:42 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 09/10] arm64: dts: lx2160a: add PCS MDIO and PCS PHY nodes
Date:   Sat,  3 Oct 2020 00:07:36 +0300
Message-Id: <20201002210737.27645-10-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002210737.27645-1-ioana.ciornei@nxp.com>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PCS MDIO nodes for the internal MDIO buses on the LX2160A, along
with their internal PCS PHYs, which will be used when the DPMAC is
in TYPE_PHY mode.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 252 ++++++++++++++++++
 1 file changed, 252 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index d247e4228d60..a7f808a96dc4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1305,6 +1305,240 @@ emdio2: mdio@8b97000 {
 			status = "disabled";
 		};
 
+		pcs_mdio1: mdio@8c07000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c07000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs1: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio2: mdio@8c0b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0b000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs2: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio3: mdio@8c0f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c0f000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs3: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio4: mdio@8c13000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c13000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs4: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio5: mdio@8c17000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c17000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs5: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio6: mdio@8c1b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1b000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs6: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio7: mdio@8c1f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c1f000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs7: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio8: mdio@8c23000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c23000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs8: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio9: mdio@8c27000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c27000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs9: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio10: mdio@8c2b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c2b000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs10: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio11: mdio@8c2f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c2f000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs11: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio12: mdio@8c33000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c33000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs12: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio13: mdio@8c37000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c37000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs13: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio14: mdio@8c3b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c3b000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs14: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio15: mdio@8c3f000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c3f000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs15: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio16: mdio@8c43000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c43000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs16: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio17: mdio@8c47000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c47000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs17: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
+		pcs_mdio18: mdio@8c4b000 {
+			compatible = "fsl,fman-memac-mdio";
+			reg = <0x0 0x8c4b000 0x0 0x1000>;
+			little-endian;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			pcs18: pcs-phy@0 {
+				reg = <0>;
+			};
+		};
+
 		fsl_mc: fsl-mc@80c000000 {
 			compatible = "fsl,qoriq-mc";
 			reg = <0x00000008 0x0c000000 0 0x40>,
@@ -1333,91 +1567,109 @@ dpmacs {
 				dpmac1: dpmac@1 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x1>;
+					pcs-handle = <&pcs1>;
 				};
 
 				dpmac2: dpmac@2 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x2>;
+					pcs-handle = <&pcs2>;
 				};
 
 				dpmac3: dpmac@3 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x3>;
+					pcs-handle = <&pcs3>;
 				};
 
 				dpmac4: dpmac@4 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x4>;
+					pcs-handle = <&pcs4>;
 				};
 
 				dpmac5: dpmac@5 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x5>;
+					pcs-handle = <&pcs5>;
 				};
 
 				dpmac6: dpmac@6 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x6>;
+					pcs-handle = <&pcs6>;
 				};
 
 				dpmac7: dpmac@7 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x7>;
+					pcs-handle = <&pcs7>;
 				};
 
 				dpmac8: dpmac@8 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x8>;
+					pcs-handle = <&pcs8>;
 				};
 
 				dpmac9: dpmac@9 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x9>;
+					pcs-handle = <&pcs9>;
 				};
 
 				dpmac10: dpmac@a {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xa>;
+					pcs-handle = <&pcs10>;
 				};
 
 				dpmac11: dpmac@b {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xb>;
+					pcs-handle = <&pcs11>;
 				};
 
 				dpmac12: dpmac@c {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xc>;
+					pcs-handle = <&pcs12>;
 				};
 
 				dpmac13: dpmac@d {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xd>;
+					pcs-handle = <&pcs13>;
 				};
 
 				dpmac14: dpmac@e {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xe>;
+					pcs-handle = <&pcs14>;
 				};
 
 				dpmac15: dpmac@f {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0xf>;
+					pcs-handle = <&pcs15>;
 				};
 
 				dpmac16: dpmac@10 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x10>;
+					pcs-handle = <&pcs16>;
 				};
 
 				dpmac17: dpmac@11 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x11>;
+					pcs-handle = <&pcs17>;
 				};
 
 				dpmac18: dpmac@12 {
 					compatible = "fsl,qoriq-mc-dpmac";
 					reg = <0x12>;
+					pcs-handle = <&pcs18>;
 				};
 			};
 		};
-- 
2.28.0

