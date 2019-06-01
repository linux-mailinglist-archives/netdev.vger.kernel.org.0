Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F208231B50
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfFAKp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:45:59 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:43784 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAKp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:45:58 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x51Ajqjw017215;
        Sat, 1 Jun 2019 05:45:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559385952;
        bh=bf1JSQ3o+4GDGCtl8ezINMDggnzBuxoGXO5FYeY/4Us=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=gnkB/3MMf5QBf6L8L+KiWPEu0bmO3jO9L/Cq6HyDL8HWzBnOhWt5UHpYWrIYCEaPI
         OnIS3gPI0OJsjqpXDKnmGyb/C4r+BqTL0DwBVUNXQdbtF1cVQEtcbf5Wj+E6kfrj3M
         XdX2bp3bb7Ac3mwH/SxcAuHg0DDJTz77wqm9QdRg=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x51AjqYf022690
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 1 Jun 2019 05:45:52 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 1 Jun
 2019 05:45:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 1 Jun 2019 05:45:51 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x51Ajobp051295;
        Sat, 1 Jun 2019 05:45:50 -0500
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
Subject: [PATCH net-next 01/10] dt-bindings: doc: net: keystone-netcp: document cpts
Date:   Sat, 1 Jun 2019 13:45:25 +0300
Message-ID: <20190601104534.25790-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190601104534.25790-1-grygorii.strashko@ti.com>
References: <20190601104534.25790-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Keystone 2 66AK2HK/E/L 1G Ethernet Switch Subsystems contains The
Common Platform Time Sync (CPTS) module which is in general compatible with
CPTS module found on TI AM3/4/5 SoCs. So, the basic support for
Keystone 2 CPTS is available by default, but not documented.
The Keystone 2 CPTS module supports also some additional features like time
sync reference (RFTCLK) clock selection through CPTS_RFTCLK_SEL register
(offset: x08) in CPTS module, which is modelled as multiplexer clock.

This patch adds missed binding documentation for Keystone 2 66AK2HK/E/L
CPTS module.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
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

