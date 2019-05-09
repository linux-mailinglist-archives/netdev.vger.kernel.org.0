Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A16518DB6
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfEIQLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:11:17 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32910 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfEIQLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:11:15 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x49GB39I109735;
        Thu, 9 May 2019 11:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557418263;
        bh=QyO9JNb19fKRIufl/XESIap5+A4FqNJ+m71MLyaO02M=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UUaYSfW70rwYnyIxAwv8voEU5n3REvWN3Az9P+QsBEVv12kJf8c4hhT/lhCQRQ8nC
         eticHG8dCboXiPrEJLZrUfXKLPTXBLnY5Pikili+EPTYnC1RCo/F4QMwFy95NR4h/K
         ayy8KTQCGBjc50m03L76K9GCpxXmrTkfX0kxFTU8=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x49GB3Pw036056
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 May 2019 11:11:03 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 9 May
 2019 11:11:02 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 9 May 2019 11:11:02 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x49GB2Sv043836;
        Thu, 9 May 2019 11:11:02 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v12 3/5] dt-bindings: can: tcan4x5x: Add DT bindings for TCAN4x5X driver
Date:   Thu, 9 May 2019 11:11:07 -0500
Message-ID: <20190509161109.10499-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.21.0.5.gaeb582a983
In-Reply-To: <20190509161109.10499-1-dmurphy@ti.com>
References: <20190509161109.10499-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DT binding documentation for TI TCAN4x5x driver.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v12 - No changes - https://lore.kernel.org/patchwork/patch/1052300/

v11 - No changes - https://lore.kernel.org/patchwork/patch/1051178/
v10 - No changes - https://lore.kernel.org/patchwork/patch/1050488/
v9 - No Changes - https://lore.kernel.org/patchwork/patch/1050118/
v8 - No Changes - https://lore.kernel.org/patchwork/patch/1047981/
v7 - Made device state optional - https://lore.kernel.org/patchwork/patch/1047218/
v6 - No changes - https://lore.kernel.org/patchwork/patch/1042445/

 .../devicetree/bindings/net/can/tcan4x5x.txt  | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/tcan4x5x.txt

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
new file mode 100644
index 000000000000..c388f7d9feb1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -0,0 +1,37 @@
+Texas Instruments TCAN4x5x CAN Controller
+================================================
+
+This file provides device node information for the TCAN4x5x interface contains.
+
+Required properties:
+	- compatible: "ti,tcan4x5x"
+	- reg: 0
+	- #address-cells: 1
+	- #size-cells: 0
+	- spi-max-frequency: Maximum frequency of the SPI bus the chip can
+			     operate at should be less than or equal to 18 MHz.
+	- data-ready-gpios: Interrupt GPIO for data and error reporting.
+	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
+
+See Documentation/devicetree/bindings/net/can/m_can.txt for additional
+required property details.
+
+Optional properties:
+	- reset-gpios: Hardwired output GPIO. If not defined then software
+		       reset.
+	- device-state-gpios: Input GPIO that indicates if the device is in
+			      a sleep state or if the device is active.
+
+Example:
+tcan4x5x: tcan4x5x@0 {
+		compatible = "ti,tcan4x5x";
+		reg = <0>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		spi-max-frequency = <10000000>;
+		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
+		data-ready-gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
+		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
+		device-wake-gpios = <&gpio1 15 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
+};
-- 
2.21.0.5.gaeb582a983

