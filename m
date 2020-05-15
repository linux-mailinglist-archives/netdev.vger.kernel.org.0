Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF1B1D5374
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgEOPKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:10:02 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:2033 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727981AbgEOPKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:10:00 -0400
X-IronPort-AV: E=Sophos;i="5.73,395,1583161200"; 
   d="scan'208";a="46974837"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 16 May 2020 00:09:58 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 3C486400D4CD;
        Sat, 16 May 2020 00:09:54 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 06/17] ARM: dts: r8a7742: Add SDHI nodes
Date:   Fri, 15 May 2020 16:08:46 +0100
Message-Id: <1589555337-5498-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the SDHI devices nodes to the R8A7742 device tree.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
---
 arch/arm/boot/dts/r8a7742.dtsi | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7742.dtsi b/arch/arm/boot/dts/r8a7742.dtsi
index f28c32d..0565472 100644
--- a/arch/arm/boot/dts/r8a7742.dtsi
+++ b/arch/arm/boot/dts/r8a7742.dtsi
@@ -717,6 +717,66 @@
 			status = "disabled";
 		};
 
+		sdhi0: sd@ee100000 {
+			compatible = "renesas,sdhi-r8a7742",
+				     "renesas,rcar-gen2-sdhi";
+			reg = <0 0xee100000 0 0x328>;
+			interrupts = <GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 314>;
+			dmas = <&dmac0 0xcd>, <&dmac0 0xce>,
+			       <&dmac1 0xcd>, <&dmac1 0xce>;
+			dma-names = "tx", "rx", "tx", "rx";
+			max-frequency = <195000000>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 314>;
+			status = "disabled";
+		};
+
+		sdhi1: sd@ee120000 {
+			compatible = "renesas,sdhi-r8a7742",
+				     "renesas,rcar-gen2-sdhi";
+			reg = <0 0xee120000 0 0x328>;
+			interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 313>;
+			dmas = <&dmac0 0xc9>, <&dmac0 0xca>,
+			       <&dmac1 0xc9>, <&dmac1 0xca>;
+			dma-names = "tx", "rx", "tx", "rx";
+			max-frequency = <195000000>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 313>;
+			status = "disabled";
+		};
+
+		sdhi2: sd@ee140000 {
+			compatible = "renesas,sdhi-r8a7742",
+				     "renesas,rcar-gen2-sdhi";
+			reg = <0 0xee140000 0 0x100>;
+			interrupts = <GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 312>;
+			dmas = <&dmac0 0xc1>, <&dmac0 0xc2>,
+			       <&dmac1 0xc1>, <&dmac1 0xc2>;
+			dma-names = "tx", "rx", "tx", "rx";
+			max-frequency = <97500000>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 312>;
+			status = "disabled";
+		};
+
+		sdhi3: sd@ee160000 {
+			compatible = "renesas,sdhi-r8a7742",
+				     "renesas,rcar-gen2-sdhi";
+			reg = <0 0xee160000 0 0x100>;
+			interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 311>;
+			dmas = <&dmac0 0xd3>, <&dmac0 0xd4>,
+			       <&dmac1 0xd3>, <&dmac1 0xd4>;
+			dma-names = "tx", "rx", "tx", "rx";
+			max-frequency = <97500000>;
+			power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
+			resets = <&cpg 311>;
+			status = "disabled";
+		};
+
 		mmcif1: mmc@ee220000 {
 			compatible = "renesas,mmcif-r8a7742",
 				     "renesas,sh-mmcif";
-- 
2.7.4

