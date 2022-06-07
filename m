Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797A353F6AF
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbiFGG5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiFGG5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:57:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FDEE15F4;
        Mon,  6 Jun 2022 23:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1654585022; x=1686121022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+1xGChpqZuNDz0197+AGmRutrzG/VT3GEtYD/psoI14=;
  b=0linqtrBWmCQcHMdkYHfKOkx5Phj7/1mU59sKRohlTwL5s53kJZHlEfb
   G3XVSPsGRpliwc7dThRqErU4jFsY1bezaDQEkaW7h/OZQw6BPy2bCaUbE
   FcPmgV+tzayrG7mqSFVnaRHaVnh4DKjlRk0Fo+Lgc19EfEPTrytGEDqib
   ZoXfJ1pNkvVAzB3TdH6ug7lKxo4KmYY/EwHStB1dneEOiS94o2UPHt/Qn
   8f3YT8ySY+oMVxf8mafRDxXwIV9YaJPsqE7H1SEP6tZlDLslzvjdl7jPJ
   ga0bMOWc3rSEDFjb0dZWCi21IX+d2Dw9dUFBEBMpFTNdAHrEnaGQGnip3
   A==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="98872876"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2022 23:57:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 6 Jun 2022 23:57:00 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 6 Jun 2022 23:56:57 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
CC:     Conor Dooley <conor.dooley@microchip.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: [PATCH net-next 2/2] riscv: dts: microchip: add mpfs's can controllers
Date:   Tue, 7 Jun 2022 07:55:00 +0100
Message-ID: <20220607065459.2035746-3-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607065459.2035746-1-conor.dooley@microchip.com>
References: <20220607065459.2035746-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PolarFire SoC has a pair of can controllers, but as they were
undocumented there were omitted from the device tree. Add them.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 .../boot/dts/microchip/microchip-mpfs.dtsi     | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index cf2f55e1dcb6..059a671314bf 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -326,6 +326,24 @@ i2c1: i2c@2010b000 {
 			status = "disabled";
 		};
 
+		can0: can@2010c000 {
+			compatible = "microchip,mpfs-can";
+			reg = <0x0 0x2010c000 0x0 0x1000>;
+			clocks = <&clkcfg CLK_CAN0>;
+			interrupt-parent = <&plic>;
+			interrupts = <56>;
+			status = "disabled";
+		};
+
+		can1: can@2010d000 {
+			compatible = "microchip,mpfs-can";
+			reg = <0x0 0x2010d000 0x0 0x1000>;
+			clocks = <&clkcfg CLK_CAN1>;
+			interrupt-parent = <&plic>;
+			interrupts = <57>;
+			status = "disabled";
+		};
+
 		mac0: ethernet@20110000 {
 			compatible = "cdns,macb";
 			reg = <0x0 0x20110000 0x0 0x2000>;
-- 
2.36.1

