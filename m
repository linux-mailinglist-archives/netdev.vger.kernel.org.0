Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2D6EA968
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjDULjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjDULjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:39:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF301024B;
        Fri, 21 Apr 2023 04:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682077149; x=1713613149;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N6OimIKQ3i6ehsTOK+r+zS/LiCq1sp3AESutKH+CGnc=;
  b=iNmgpNESzs7LRNQ0FHakpAAcGzsZzFYx5PMiyWWWKpSU8Lw/FKVFM0+M
   iUSJWCGfOsgcf26blbrTFCMtdE1rkB2SeITh/QSCbq1OgRW0AGbLYK5/K
   Ae0Z+DO7V7QP7oLfClSrAgM0wrFO7G5dV8/YQHcsJiajvEqYGUFaQ7KP5
   t/0Kf1Mov73fhCaDIMJSOJNFwMBWQsN3DeTAUiaPWWnjlE+86jSU/nt48
   zz5udh92FrRzSAO3r1LyVyZdSAwuDSJE5n21SN942aZvMpHEWKwQDFaxe
   /qygijKfzShrkvjhQcE7JYQtR+Hj2DEFqC1CHPpcb+Fn7W12+d7lm+kL6
   g==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="210581661"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 04:38:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 04:38:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 21 Apr 2023 04:38:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <richardcochran@gmail.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH] ARM: dts: lan966x: Add support for SMA connectors
Date:   Fri, 21 Apr 2023 13:37:58 +0200
Message-ID: <20230421113758.3465678-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pcb8309 has 2 SMA connectors which are connected to the lan966x
chip. The lan966x can generate 1PPS output on one of them and it can
receive 1PPS input on the other one.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 arch/arm/boot/dts/lan966x-pcb8309.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/lan966x-pcb8309.dts b/arch/arm/boot/dts/lan966x-pcb8309.dts
index c436cd20d4b4c..0cb505f79ba1a 100644
--- a/arch/arm/boot/dts/lan966x-pcb8309.dts
+++ b/arch/arm/boot/dts/lan966x-pcb8309.dts
@@ -144,6 +144,18 @@ fc4_b_pins: fc4-b-pins {
 		function = "fc4_b";
 	};
 
+	pps_out_pins: pps-out-pins {
+		/* 1pps output */
+		pins = "GPIO_38";
+		function = "ptpsync_3";
+	};
+
+	ptp_ext_pins: ptp-ext-pins {
+		/* 1pps input */
+		pins = "GPIO_39";
+		function = "ptpsync_4";
+	};
+
 	sgpio_a_pins: sgpio-a-pins {
 		/* SCK, D0, D1, LD */
 		pins = "GPIO_32", "GPIO_33", "GPIO_34", "GPIO_35";
@@ -212,5 +224,7 @@ gpio@1 {
 };
 
 &switch {
+	pinctrl-0 = <&pps_out_pins>, <&ptp_ext_pins>;
+	pinctrl-names = "default";
 	status = "okay";
 };
-- 
2.38.0

