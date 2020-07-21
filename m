Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3213A228735
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgGURVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:21:51 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:22525 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGURVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595352110; x=1626888110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cr9yMh/643YG+tS2Nsorca62cbZHykMm0kwOqg1UwAk=;
  b=lw/szNsMajlb+0AdVo8voOGoG/msPvajoNGh8yH6vKT+IUNw1d5wqFo2
   JMO+ruKApIR4Zud3EDItOlwybE6NOBYUtgVNj/Yma8f0EAmiVYeFC/Jz7
   J+KcKTa2BDFS0ApkxoMq57h4xMtRc+Tcwos8chSvHmZJ5NoC/f0SP8az0
   xzZvUiR+wG/W/QgiwrSkPONdmdthBwfQYW4wIttUUGr1kEMPBqdjwnSX4
   pwSSldYwpwkDYuuPnJhjxglGUrB6aVOj1fhnIfquVxXdQM1cJ64BLWP56
   PCO0YNHJfDC/ofEpSIHOS07kFdR3VTNub2Vc6ocb8y5AVaFu/38ICWrry
   Q==;
IronPort-SDR: CcUTc3On6c0yp9yuLQT1QB8qmu3kf1ctzNkAZV5ykz+c/Q4nHoQAmZsZXurSKjCElhdpE9vH3X
 jviXJD+TgYaZfN7gnZ3sCQD0xVo3KtgMuMMonpP989J6dwByPekkqtHLlHUj8URJbA/vwgc2zu
 etVGQzMqLQDCpsrUbbFKPiatvFNQsrnpSJQSZocfLuYXb3e1rVQQBLP3Of2S8Pu/Q70iPcdG/f
 oswuX8YdXbPr3uCVZQR1raA7mdWkVOwhzBIFqJUd4p2nxS0rUtgLsXJOjG7a3SJY7YsOZchP0J
 XaE=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84067376"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:21:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:21:47 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:20:43 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 7/7] ARM: dts: at91: sam9x60: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 20:13:16 +0300
Message-ID: <20200721171316.1427582-8-codrin.ciubotariu@microchip.com>
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

 arch/arm/boot/dts/at91-sam9x60ek.dts | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index a5f5718c711a..ba871ebe10d4 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -324,8 +324,12 @@ &macb0 {
 	pinctrl-0 = <&pinctrl_macb0_rmii>;
 	status = "okay";
 
-	ethernet-phy@0 {
-		reg = <0x0>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ethernet-phy@0 {
+			reg = <0x0>;
+		};
 	};
 };
 
-- 
2.25.1

