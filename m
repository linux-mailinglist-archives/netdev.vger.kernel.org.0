Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D626A35F5DF
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351791AbhDNOGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:06:41 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33046 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349092AbhDNOGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:06:18 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13EE5f8w049791;
        Wed, 14 Apr 2021 09:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618409141;
        bh=SbyTJ4nrIzPbNTHEIea0gu+NlxpkXKwgFDRim/hhn7g=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=xj6v6yYGGZt1t29Qk0f0qFccFV3/eNAcJejciXGwZ98AcnPtDvjo5DLOROMnfnoux
         KPe7U/dksJlZCtyCMcEkEf9PVYtQ4YkF3odqIMLPgkfSL9wSFNV0rTxEFqEEPYEHbe
         NzXbedYSLcus8DlNbWlDlfAsXAAx9w9XSTr9f9sM=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13EE5fFE057032
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Apr 2021 09:05:41 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 14
 Apr 2021 09:05:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 14 Apr 2021 09:05:41 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13EE5LuB074247;
        Wed, 14 Apr 2021 09:05:36 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-phy@lists.infradead.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH v2 3/6] dt-bindings: phy: Add binding for TI TCAN104x CAN transceivers
Date:   Wed, 14 Apr 2021 19:35:18 +0530
Message-ID: <20210414140521.11463-4-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210414140521.11463-1-a-govindraju@ti.com>
References: <20210414140521.11463-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding documentation for TI TCAN104x CAN transceivers.

Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 57 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml

diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
new file mode 100644
index 000000000000..4abfc30a97d0
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TCAN104x CAN TRANSCEIVER PHY
+
+maintainers:
+  - Aswath Govindraju <a-govindraju@ti.com>
+
+properties:
+  $nodename:
+    pattern: "^tcan104x-phy"
+
+  compatible:
+    enum:
+      - ti,tcan1042
+      - ti,tcan1043
+
+  '#phy-cells':
+    const: 0
+
+  standby-gpios:
+    description:
+      gpio node to toggle standby signal on transceiver
+    maxItems: 1
+
+  enable-gpios:
+    description:
+      gpio node to toggle enable signal on transceiver
+    maxItems: 1
+
+  max-bitrate:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      max bit rate supported in bps
+    minimum: 1
+
+required:
+  - compatible
+  - '#phy-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    transceiver1: tcan104x-phy {
+      compatible = "ti,tcan1043";
+      #phy-cells = <0>;
+      max-bitrate = <5000000>;
+      standby-gpios = <&wakeup_gpio1 16 GPIO_ACTIVE_LOW>;
+      enable-gpios = <&main_gpio1 67 GPIO_ACTIVE_LOW>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 84ef96a444c3..e666d33af10d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4046,6 +4046,7 @@ W:	https://github.com/linux-can
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git
 F:	Documentation/devicetree/bindings/net/can/
+F:	Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
 F:	drivers/net/can/
 F:	include/linux/can/bittiming.h
 F:	include/linux/can/dev.h
-- 
2.17.1

