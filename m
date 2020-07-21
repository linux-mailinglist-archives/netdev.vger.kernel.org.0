Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58907227C85
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgGUKG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:06:29 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:43206 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGUKG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595325988; x=1626861988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ugupFvNUPF8FuehP3ksTBUyo0lliEzV3XM3HFd37shU=;
  b=Nv+LGGO3QpdX8N0qLuAzvQkf03XkhXe2GFxjU1GBM1Q9SQJghUAXVbRH
   tt/uSd7ujolXwpqiAMWZCZ0kmygtySws2EaEfF/PbUxz1Qf7zSD323BJk
   dSCSbF60z+fmd279EUEpz8jsO7ols99GzYTbAnX44ZfRm+G+xogHZ/0g8
   9nvcNxdpQkX76Oj8bTe7/IkANW3XAewWlpCCDDh51oj22vbPPKm9F2p0X
   C4ZRT7TJ4adTVBigCuSWEb7TfqUZp/2nPPVkKP9V+fFJ6zcF4nzW1cDD0
   GCzHz6jHQh1/KL/ibL76zUPozH9Ac7oCugULT2cD+/AYrd5wIxhmY2nKu
   A==;
IronPort-SDR: FGePf6p8HLuXtALEkGo3Low74GqV4AxxjBQqDVu8qRvPfx1kKZC7BrozdV2daQo2ur73pQULTZ
 Oc1Scj8uNmDy/2LX08X+q9PpiUocbKfU0+goT3k+lyXwhF5w0tP7WQ6IVe8fMMC1MN8aGMh4n+
 FIWuneeIZT2RrFHIp8ber/wfMgb/V67LaiCGsi6Kl/fx+D+vQurIj3xct+S9VYE2zXkrpFhSM5
 Qnx3r8P+5+hQ6T6IUC7mlwcmku8sEw0jiy45fgNx7JnBimaps7r3HeQFbKSMVcU9UTlq6PrLHM
 VJM=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="84004861"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:06:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:06:25 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:05:14 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 5/7] ARM: dts: at91: sama5d3: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 13:02:32 +0300
Message-ID: <20200721100234.1302910-6-codrin.ciubotariu@microchip.com>
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
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index 61f068a7b362..25d2646ce4cb 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -133,8 +133,12 @@ macb0: ethernet@f0028000 {
 				#size-cells = <0>;
 				status = "okay";
 
-				ethernet-phy@7 {
-					reg = <0x7>;
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					ethernet-phy@7 {
+						reg = <0x7>;
+					};
 				};
 			};
 
@@ -200,8 +204,12 @@ macb1: ethernet@f802c000 {
 				#size-cells = <0>;
 				status = "okay";
 
-				ethernet-phy@1 {
-					reg = <0x1>;
+				mdio {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					ethernet-phy@1 {
+						reg = <0x1>;
+					};
 				};
 			};
 
-- 
2.25.1

