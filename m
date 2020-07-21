Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF0228732
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgGURVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:21:37 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:22497 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGURVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595352097; x=1626888097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xpBDjaVgmO6cXev+iZBKLimJYMZyRa+/vWRVja1qTmI=;
  b=QsIDq6LLIQvJZXacF7u8eVfsEMEo5n2gXQkLd/gFI/QNYw7pHa6ru6p1
   wn0542tiiECCCFcGYIPR1d6GTd8/0hJcUTxtea5BUCaFCXKyvIu+rfIfO
   X4prdc/r4IgA3NVSs4bO5mb74G1dIk8xuNSCKZ+gzHqW3JnSsMMnLaAVE
   2YGMnvYqMD48wdLqFvBLo0JaC1iEKbVfWZUgBRi9IOu6zsQ1O52WD+DUt
   q0M1utX/5D/2OjrHCYWYwsxO8hkZ56UukKFTP5H2EJlmErWwAQeYgOMLe
   II4izADZds3Lt10F88sQOHUkLJtF3MYD5ShMKbQK2rbNX1iGlnIlz6Vor
   A==;
IronPort-SDR: r527DnOdF9z7bAMIAzlYIkNKZfaJh0diURjS11l4Kx1fPpo05UywG4nxY8WIUkTyVZSB2Ls1aY
 w31VwzuiPqPbah9DUAOfncCzVC5+2sp9Z8I4GNrsNFq2AnF8fNsJd9Xgpoj8raB76A7BNcsngG
 eaDb7bMFX0wlDMXpuVyEEHgFnQafhmI+8HoLA1UA9DrqFM417R0tSSlX6rtbctmgfizoSS0rvZ
 sL6eTmMIrcSbigkGFgTpMDKf02Vlc5gDpWH4vt9B95MjAdZ/AIr+AgC//oIAjGGFQGoORKNPu2
 Mzc=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84067279"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:21:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:21:20 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:20:12 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 6/7] ARM: dts: at91: sama5d4: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 20:13:15 +0300
Message-ID: <20200721171316.1427582-7-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
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

Changes in v2:
 - none

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

