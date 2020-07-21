Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00714228730
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgGURUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:20:53 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:22426 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGURUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595352052; x=1626888052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=djao7XJFkQBlS3QbE2ngJuOq6kvDMlGOyGzmYSfMPxE=;
  b=NT8Me9VQrLrAeMnVbg9fp4/S2gNPoIRj8dw6Zrv9A38mqum0oTOGv1vu
   H+Xznb6YzPw0dnatcYOoqG8hCsF9blqjWakhaeAO9zjPmf+zAB+rRxV3N
   5qOiv3JjVZlV9NT2euGryRwoHqLtigvHF9fkNhUHtH+sa4qOk/HCW38X2
   tLFrVDnqeWeB45yfRloQwMcEgLTKKaC8C4W5lvGv3Js0IvVPO3ickWiFh
   Fwj5BQNoCaCLMor1HEbAFvP4YvF4+q1mjfy6MBqgSgrG8hj9IqUEmppC5
   KIHeCBeBNGXmrIWyPIPXEBjn+SAk/e1fMkF78Foz4Hr5xMJO23KDJsq0w
   w==;
IronPort-SDR: H6UjchvUyd5cFnz/ERy9emwbTS70swPTeoiMJO4YC0mN7OrvQe06ZYQ7AGU8WsQB7EG8nfGbJy
 EqasAqoe1a9CwO5Cw9WgL4YHG06lndPbMocJWYVzTij0DwOdCIw3L2C3C5NRNuWnFyU4MZvHQB
 eIkOA2K7Io5F06W4LtXoDAV4mpnmW+Rwqfst+KnV7U7Vdv1MZndmj/LoIQZGL4WGUkh3hzA18Q
 bcho2OP7k75V7XO23u2ZDgvE05d2wIWk0WGFM2bUR0GIkh/7cOBCbiNYSPlD640TN5Wmm2r2Nw
 EzE=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84067153"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:20:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:20:50 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:19:52 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 5/7] ARM: dts: at91: sama5d3: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 20:13:14 +0300
Message-ID: <20200721171316.1427582-6-codrin.ciubotariu@microchip.com>
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
 - none;

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

