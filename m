Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E3D21E25B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgGMVfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:35:42 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:22929 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgGMVfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:35:41 -0400
X-IronPort-AV: E=Sophos;i="5.75,348,1589209200"; 
   d="scan'208";a="52015992"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 14 Jul 2020 06:35:38 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id E110440F7FE5;
        Tue, 14 Jul 2020 06:35:34 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/9] arm64: dts: renesas: r8a774e1: Add IPMMU device nodes
Date:   Mon, 13 Jul 2020 22:35:14 +0100
Message-Id: <1594676120-5862-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Add RZ/G2H (R8A774E1) IPMMU nodes.

Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi | 121 ++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index 7484ad530068..0fc0d9ff5bc5 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -408,6 +408,127 @@
 			/* placeholder */
 		};
 
+		ipmmu_ds0: iommu@e6740000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xe6740000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 0>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_ds1: iommu@e7740000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xe7740000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 1>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_hc: iommu@e6570000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xe6570000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 2>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_mm: iommu@e67b0000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xe67b0000 0 0x1000>;
+			interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_mp0: iommu@ec670000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xec670000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 4>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_pv0: iommu@fd800000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfd800000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 6>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_pv1: iommu@fd950000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfd950000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 7>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_pv2: iommu@fd960000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfd960000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 8>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_pv3: iommu@fd970000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfd970000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 9>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_vc0: iommu@fe6b0000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfe6b0000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 12>;
+			power-domains = <&sysc R8A774E1_PD_A3VC>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_vc1: iommu@fe6f0000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfe6f0000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 13>;
+			power-domains = <&sysc R8A774E1_PD_A3VC>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_vi0: iommu@febd0000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfebd0000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 14>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_vi1: iommu@febe0000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfebe0000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 15>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_vp0: iommu@fe990000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfe990000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 16>;
+			power-domains = <&sysc R8A774E1_PD_A3VP>;
+			#iommu-cells = <1>;
+		};
+
+		ipmmu_vp1: iommu@fe980000 {
+			compatible = "renesas,ipmmu-r8a774e1";
+			reg = <0 0xfe980000 0 0x1000>;
+			renesas,ipmmu-main = <&ipmmu_mm 17>;
+			power-domains = <&sysc R8A774E1_PD_A3VP>;
+			#iommu-cells = <1>;
+		};
+
 		avb: ethernet@e6800000 {
 			reg = <0 0xe6800000 0 0x800>;
 			#address-cells = <1>;
-- 
2.17.1

