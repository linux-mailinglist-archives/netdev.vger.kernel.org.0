Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DFE1C1EED
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgEAUu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:50:29 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35660 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgEAUu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 16:50:28 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 041KoMtU011926;
        Fri, 1 May 2020 15:50:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588366222;
        bh=qN0Xb9wQCu3JbxXp4EMURVZTD0wb2cLpIsPzt8Vp0jg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=lztPcqDdAGo1TLlVfh8yNtFo7IvkzZ1iYn7pF7TlEi96XXbcNaDQ1q+zLEz8AqsIs
         /IvBeTYPoQc8MmZtV6p3PR6tWBd3P5q1IEiRLjk8Ro72SnrJnc3ad//jG5csNvsQZ3
         9GGvRuaOPzfTPjco+t18S27xIwkcbZnYm6rdU1Jk=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 041KoMpv040054
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 May 2020 15:50:22 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 1 May
 2020 15:50:22 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 1 May 2020 15:50:22 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 041KoKBY026260;
        Fri, 1 May 2020 15:50:21 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>
CC:     Lokesh Vutla <lokeshvutla@ti.com>, <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/7] dt-binding: ti: am65x: document common platform time sync cpts module
Date:   Fri, 1 May 2020 23:50:05 +0300
Message-ID: <20200501205011.14899-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501205011.14899-1-grygorii.strashko@ti.com>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document device tree bindings for TI AM654/J721E SoC The Common Platform
Time Sync (CPTS) module. The CPTS module is used to facilitate host control
of time sync operations. Main features of CPTS module are:
  - selection of multiple external clock sources
  - 64-bit timestamp mode in ns with ppm and nudge adjustment.
  - control of time sync events via interrupt or polling
  - hardware timestamp of ext. events (HWx_TS_PUSH)
  - periodic generator function outputs (TS_GENFx)
  - PPS in combination with timesync router
  - Depending on integration it enables compliance with the IEEE 1588-2008
standard for a precision clock synchronization protocol, Ethernet Enhanced
Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
Measurement (PTM).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |   7 +
 .../bindings/net/ti,k3-am654-cpts.yaml        | 152 ++++++++++++++++++
 2 files changed, 159 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 78bf511e2892..0f3fde45e200 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -144,6 +144,13 @@ patternProperties:
     description:
       CPSW MDIO bus.
 
+  "^cpts$":
+    type: object
+    allOf:
+      - $ref: "ti,am654-cpts.yaml#"
+    description:
+      CPSW Common Platform Time Sync (CPTS) module.
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
new file mode 100644
index 000000000000..1b535d41e5c6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -0,0 +1,152 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ti,am654-cpts.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: The TI AM654x/J721E Common Platform Time Sync (CPTS) module Device Tree Bindings
+
+maintainers:
+  - Grygorii Strashko <grygorii.strashko@ti.com>
+  - Sekhar Nori <nsekhar@ti.com>
+
+description: |+
+  The TI AM654x/J721E CPTS module is used to facilitate host control of time
+  sync operations.
+  Main features of CPTS module are
+  - selection of multiple external clock sources
+  - Software control of time sync events via interrupt or polling
+  - 64-bit timestamp mode in ns with PPM and nudge adjustment.
+  - hardware timestamp push inputs (HWx_TS_PUSH)
+  - timestamp counter compare output (TS_COMP)
+  - timestamp counter bit output (TS_SYNC)
+  - periodic Generator function outputs (TS_GENFx)
+  - Ethernet Enhanced Scheduled Traffic Operations (CPTS_ESTFn) (TSN)
+  - external hardware timestamp push inputs (HWx_TS_PUSH) timestamping
+
+   Depending on integration it enables compliance with the IEEE 1588-2008
+   standard for a precision clock synchronization protocol, Ethernet Enhanced
+   Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
+   Measurement (PTM).
+
+  TI AM654x/J721E SoCs has several similar CPTS modules integrated into the
+  different parts of the system which could be synchronized with each other
+  - Main CPTS
+  - MCU CPSW CPTS with IEEE 1588-2008 support
+  - PCIe subsystem CPTS for PTM support
+
+  Depending on CPTS module integration and when CPTS is integral part of
+  another module (MCU CPSW for example) "compatible" and "reg" can
+  be omitted - parent module is fully responsible for CPTS enabling and
+  configuration.
+
+properties:
+  $nodename:
+    pattern: "^cpts(@.*|-[0-9a-f])*$"
+
+  compatible:
+    oneOf:
+      - const: ti,am65-cpts
+      - const: ti,j721e-cpts
+
+  reg:
+    maxItems: 1
+    description:
+       The physical base address and size of CPTS IO range
+
+  reg-names:
+    items:
+      - const: cpts
+
+  clocks:
+    description: CPTS reference clock
+
+  clock-names:
+    items:
+      - const: cpts
+
+  interrupts-extended:
+    items:
+      - description: CPTS events interrupt
+
+  interrupt-names:
+    items:
+      - const: "cpts"
+
+  ti,cpts-ext-ts-inputs:
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32
+    maximum: 8
+    description:
+        Number of hardware timestamp push inputs (HWx_TS_PUSH)
+
+  ti,cpts-periodic-outputs:
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32
+    maximum: 8
+    description:
+         Number of timestamp Generator function outputs (TS_GENFx)
+
+  refclk-mux:
+    type: object
+    description: CPTS reference clock multiplexer clock
+    properties:
+      '#clock-cells':
+        const: 0
+
+      clocks:
+        maxItems: 8
+
+      assigned-clocks:
+        maxItems: 1
+
+      assigned-clocks-parents:
+        maxItems: 1
+
+    required:
+      - clocks
+
+required:
+  - clocks
+  - clock-names
+  - interrupts-extended
+  - interrupt-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    cpts@310d0000 {
+         compatible = "ti,am65-cpts";
+         reg = <0x0 0x310d0000 0x0 0x400>;
+         reg-names = "cpts";
+         clocks = <&main_cpts_mux>;
+         clock-names = "cpts";
+         interrupts-extended = <&k3_irq 163 0 IRQ_TYPE_LEVEL_HIGH>;
+         interrupt-names = "cpts";
+         ti,cpts-periodic-outputs = <6>;
+         ti,cpts-ext-ts-inputs = <8>;
+
+         main_cpts_mux: refclk-mux {
+               #clock-cells = <0>;
+               clocks = <&k3_clks 118 5>, <&k3_clks 118 11>,
+                        <&k3_clks 157 91>, <&k3_clks 157 77>,
+                        <&k3_clks 157 102>, <&k3_clks 157 80>,
+                        <&k3_clks 120 3>, <&k3_clks 121 3>;
+               assigned-clocks = <&main_cpts_mux>;
+               assigned-clock-parents = <&k3_clks 118 11>;
+         };
+    };
+  - |
+
+    cpts {
+             clocks = <&k3_clks 18 2>;
+             clock-names = "cpts";
+             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
+             interrupt-names = "cpts";
+             ti,cpts-ext-ts-inputs = <4>;
+             ti,cpts-periodic-outputs = <2>;
+    };
-- 
2.17.1

