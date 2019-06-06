Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A8F37995
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfFFQbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:31:12 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50118 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfFFQbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:31:11 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x56GV6JV108047;
        Thu, 6 Jun 2019 11:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559838666;
        bh=DlaHGuBwA9qxrYjkx0p7cfUajFkarVJmB4WO+zGG17g=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=dXnCDunR5KQ175AyxGWOZl1uOf1a4h2Q517O/ipisK8ES5vxxm45eM8EpiIU1R935
         uIs7UOiUNZwCDTvODnzR2tjXXRM8gpID32AbRTp37blx/B28wlXl5HAiClQiKEWqTd
         1KiaN7UrhwaN+lXSiVWRfmov8wkZnf/WY4setmoQ=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x56GV5J3082453
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Jun 2019 11:31:05 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 6 Jun
 2019 11:31:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 6 Jun 2019 11:31:05 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x56GV4Ef052215;
        Thu, 6 Jun 2019 11:31:05 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 01/10] dt-bindings: doc: net: keystone-netcp: document cpts
Date:   Thu, 6 Jun 2019 19:30:38 +0300
Message-ID: <20190606163047.31199-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606163047.31199-1-grygorii.strashko@ti.com>
References: <20190606163047.31199-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Keystone 2 66AK2HK/E/L 1G Ethernet Switch Subsystems contains The
Common Platform Time Sync (CPTS) module which is in general compatible with
CPTS module found on "legacy" TI AM3/4/5 SoCs. So, the basic support for
Keystone 2 CPTS is available by default, but not documented.
The Keystone 2 CPTS module supports also some additional features like time
sync reference (RFTCLK) clock selection through CPTS_RFTCLK_SEL register
(offset: x08) in CPTS module, which is modelled as multiplexer clock.

This patch adds missed binding documentation for Keystone 2 66AK2HK/E/L
CPTS module.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 .../bindings/net/keystone-netcp.txt           | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/keystone-netcp.txt b/Documentation/devicetree/bindings/net/keystone-netcp.txt
index 6262c2f293b0..24f11e042f8d 100644
--- a/Documentation/devicetree/bindings/net/keystone-netcp.txt
+++ b/Documentation/devicetree/bindings/net/keystone-netcp.txt
@@ -104,6 +104,23 @@ Required properties:
 			- 10Gb mac<->mac forced mode : 11
 ----phy-handle:	phandle to PHY device
 
+- cpts:		sub-node time synchronization (CPTS) submodule configuration
+-- clocks:	CPTS reference clock. Should point on cpts-refclk-mux clock.
+-- clock-names: should be "cpts"
+-- cpts-refclk-mux: multiplexer clock definition sub-node for CPTS reference (RFTCLK) clock
+--- #clock-cells: should be 0
+--- clocks:	list of CPTS reference (RFTCLK) clock's parents as defined in Data manual
+--- ti,mux-tbl: array of multiplexer indexes as defined in Data manual
+--- assigned-clocks: should point on cpts-refclk-mux clock
+--- assigned-clock-parents: should point on required RFTCLK clock parent to be selected
+-- cpts_clock_mult: (optional) Numerator to convert input clock ticks
+		into nanoseconds
+-- cpts_clock_shift: (optional) Denominator to convert input clock ticks into
+		nanoseconds.
+		Mult and shift will be calculated basing on CPTS
+		rftclk frequency if both cpts_clock_shift and
+		cpts_clock_mult properties are not provided.
+
 Optional properties:
 - enable-ale:	NetCP driver keeps the address learning feature in the ethernet
 		switch module disabled. This attribute is to enable the address
@@ -168,6 +185,23 @@ netcp: netcp@2000000 {
 			tx-queue = <648>;
 			tx-channel = <8>;
 
+			cpts {
+				clocks = <&cpts_refclk_mux>;
+				clock-names = "cpts";
+
+				cpts_refclk_mux: cpts-refclk-mux {
+					#clock-cells = <0>;
+					clocks = <&chipclk12>, <&chipclk13>,
+						 <&timi0>, <&timi1>,
+						 <&tsipclka>, <&tsrefclk>,
+						 <&tsipclkb>;
+					ti,mux-tbl = <0x0>, <0x1>, <0x2>,
+						<0x3>, <0x4>, <0x8>, <0xC>;
+					assigned-clocks = <&cpts_refclk_mux>;
+					assigned-clock-parents = <&chipclk12>;
+				};
+			};
+
 			interfaces {
 				gbe0: interface-0 {
 					slave-port = <0>;
@@ -219,3 +253,13 @@ netcp: netcp@2000000 {
 		};
 	};
 };
+
+CPTS board configuration - select external CPTS RFTCLK:
+
+&tsrefclk{
+	clock-frequency = <500000000>;
+};
+
+&cpts_refclk_mux {
+	assigned-clock-parents = <&tsrefclk>;
+};
-- 
2.17.1

