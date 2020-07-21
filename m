Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21CD227C88
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgGUKHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:07:12 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5896 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGUKHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595326031; x=1626862031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/xQWcdSlHsWygAH/DfFJrDsm8/BKa5avthMl6a1HWjg=;
  b=h0gfmq+HgCYwi812uCv5TIbRoBMlBeV6APOdwpXmRHiApLNhQaFq5Cbp
   Z9ZOoSu5OpL2EgoqVKPg4v780gIeUlaB8Km+P/5ONCYm+mthjBrla4Rj/
   cAvmaNvepUG9Kc6JopbGofK4JOQsSCOkdGACpvQMIrpQ58pX/XY8AXJb7
   DeRpLID9TP7tAS0raZq4oCaEaUMTakO3yx2bf/tUOeWpc41sb5nPt0FoA
   Ze3qaL7cTd4pnEHmKBN6aN9Jc6QxPWOblE5aWN5DxRQXCGtUdp3/q3sOa
   pgbYzOhoMguJCsD/3lRB62q4fYR4Rb0tTjcHQY9/dnfrVJEo8sQ0l0WCB
   Q==;
IronPort-SDR: ICNgzqqeu9rUrNsgQ8lG0EgtR+5CUIT2rWm3noJC47ST2YO59lg5kd8CSamv9JzekXwZNfI7YN
 CccsGY0wvoTfACjMos9glVJG5bead1RbROewdcyfcYLGhzW7MlZs39BFx94181tsGSK9+h6yUP
 ItNZI1ShkByqqk2t0UaaA+JC5Tma0ZLl4waMV0FvdO0FmLAbC7HZOTXlAJOdD9IXjaUA0O5W7v
 xoOZm6zLoTpCSXqC4ZjXkruXROb99NxMSU70Uw9esi/cYXtK+U62Us5lQxKeOHB0RN569Lz+Z0
 Ge8=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="84749239"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:07:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:07:08 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:05:56 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 6/7] ARM: dts: at91: sama5d4: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 13:02:33 +0300
Message-ID: <20200721100234.1302910-7-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new macb bindings and add an mdio sub-node to contain all the
phy nodes.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 arch/arm/boot/dts/at91-sama5d4_xplained.dts | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index 924d9491780d..62598d06aead 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -59,10 +59,14 @@ macb0: ethernet@f8020000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb0_rmii &pinctrl_macb0_phy_irq>;
 
-				phy0: ethernet-phy@1 {
-					interrupt-parent = <&pioE>;
-					interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
-					reg = <1>;
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					phy0: ethernet-phy@1 {
+						interrupt-parent = <&pioE>;
+						interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
+						reg = <1>;
+					};
 				};
 			};
 
-- 
2.25.1

