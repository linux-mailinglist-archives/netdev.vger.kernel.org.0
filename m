Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0074322C3BE
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgGXKvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:51:08 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:43033 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgGXKvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587866; x=1627123866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FLhngoXrCuNQcx7HD4LHuGyoTAihVc+5VFvEfe4l+JU=;
  b=RgWjR+H/+sacJTW4I1YnVHJVBUGfsKHfV63UR8FYetFU8sOJgtzsSWek
   vHJ8TumAtrk9U3t5wuG2CT2Oh18xfDEIaM3Fh68wtgXnkMTYZO596DNKL
   LGQ6NWS+B/Qw2wo+C+Fx0MN07EvvVtZNZ8MgPufYyv1E2X4VBKNDgqM+9
   SxOInUfjgBN9UTVUd0efv2g8FyGRORDnMufY+B38lXibXWjX97UoWhhF2
   wXkhC+Ckwej2OmeLGcokYnMG6Gi34lJ61AR+ItdpTgVQIGjdcDRt7QPOP
   7xiH8Ucrs4RjorueBIEWakZrSzvio3rNasElqQ6IpNRi2FLX9gbnPflHF
   Q==;
IronPort-SDR: Gq62LaNjHmD2XI0QWEYwc2ue3kEPW8mrby9ftJacR982M0sI7zZ6G7PenB0q62Fy4CKwZOUg+o
 80tM1ZJs9sl65ZtiSAnTQf3iNk+yXq3JInegDA6gbiRONF4JnV22wKle+sELfOL3FK5tH4ptOP
 NGCuYG5hfKQEnTL6qPKJn5+0EC9hh1PTpTBhRcKmhd3Y9PPbprSLXcg0sabTA2KH7oR9z/Uxb8
 iDnlUIwW6uzYsPB9YCYquvY7JG7nUu+koDw8Z3dafiP1LHh3nRcK/Ti3SlkNCQQk49U0yrrTra
 qv0=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="81155768"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:51:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:51:05 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:50:20 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v3 5/7] ARM: dts: at91: sama5d3: add an mdio sub-node to macb
Date:   Fri, 24 Jul 2020 13:50:31 +0300
Message-ID: <20200724105033.2124881-6-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

Changes in v3:
 - added tag from Florian

Changes in v2:
 - none

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

