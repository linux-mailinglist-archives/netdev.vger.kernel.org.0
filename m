Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8D122374
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 06:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLQFMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 00:12:38 -0500
Received: from mxout2.idt.com ([157.165.5.26]:54554 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfLQFMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 00:12:24 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 00:12:21 EST
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id xBH53Em7031482;
        Mon, 16 Dec 2019 21:03:14 -0800
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id xBH53EuC026484;
        Mon, 16 Dec 2019 21:03:14 -0800
Received: from vcheng-VirtualBox.localdomain (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id xBH53DV16985;
        Mon, 16 Dec 2019 21:03:13 -0800 (PST)
From:   vincent.cheng.xh@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 1/3] dt-bindings: ptp: Rename ptp-idtcm.yaml to ptp-cm.yaml
Date:   Tue, 17 Dec 2019 00:03:06 -0500
Message-Id: <1576558988-20837-2-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1576558988-20837-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Renesas Electronics Corporation completed acquisition of IDT in 2019.

This patch removes IDT references or replaces IDT with Renesas.
Renamed ptp-idtcm.yaml to ptp-cm.yaml.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 Documentation/devicetree/bindings/ptp/ptp-cm.yaml  | 69 ++++++++++++++++++++++
 .../devicetree/bindings/ptp/ptp-idtcm.yaml         | 69 ----------------------
 2 files changed, 69 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-cm.yaml
 delete mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml

diff --git a/Documentation/devicetree/bindings/ptp/ptp-cm.yaml b/Documentation/devicetree/bindings/ptp/ptp-cm.yaml
new file mode 100644
index 0000000..0a26307
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-cm.yaml
@@ -0,0 +1,69 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ptp/ptp-cm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas (IDT) ClockMatrix(TM) PTP Clock Device Tree Bindings
+
+maintainers:
+  - Vincent Cheng <vincent.cheng.xh@renesas.com>
+
+properties:
+  compatible:
+    enum:
+      # For System Synchronizer
+      - renesas,8a34000
+      - renesas,8a34001
+      - renesas,8a34002
+      - renesas,8a34003
+      - renesas,8a34004
+      - renesas,8a34005
+      - renesas,8a34006
+      - renesas,8a34007
+      - renesas,8a34008
+      - renesas,8a34009
+      # For Port Synchronizer
+      - renesas,8a34010
+      - renesas,8a34011
+      - renesas,8a34012
+      - renesas,8a34013
+      - renesas,8a34014
+      - renesas,8a34015
+      - renesas,8a34016
+      - renesas,8a34017
+      - renesas,8a34018
+      - renesas,8a34019
+      # For Universal Frequency Translator (UFT)
+      - renesas,8a34040
+      - renesas,8a34041
+      - renesas,8a34042
+      - renesas,8a34043
+      - renesas,8a34044
+      - renesas,8a34045
+      - renesas,8a34046
+      - renesas,8a34047
+      - renesas,8a34048
+      - renesas,8a34049
+
+  reg:
+    maxItems: 1
+    description:
+      I2C slave address of the device.
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    i2c@1 {
+        compatible = "abc,acme-1234";
+        reg = <0x01 0x400>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phc@5b {
+            compatible = "renesas,8a34000";
+            reg = <0x5b>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
deleted file mode 100644
index 9e21b83..0000000
--- a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
+++ /dev/null
@@ -1,69 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-%YAML 1.2
----
-$id: http://devicetree.org/schemas/ptp/ptp-idtcm.yaml#
-$schema: http://devicetree.org/meta-schemas/core.yaml#
-
-title: IDT ClockMatrix (TM) PTP Clock Device Tree Bindings
-
-maintainers:
-  - Vincent Cheng <vincent.cheng.xh@renesas.com>
-
-properties:
-  compatible:
-    enum:
-      # For System Synchronizer
-      - idt,8a34000
-      - idt,8a34001
-      - idt,8a34002
-      - idt,8a34003
-      - idt,8a34004
-      - idt,8a34005
-      - idt,8a34006
-      - idt,8a34007
-      - idt,8a34008
-      - idt,8a34009
-      # For Port Synchronizer
-      - idt,8a34010
-      - idt,8a34011
-      - idt,8a34012
-      - idt,8a34013
-      - idt,8a34014
-      - idt,8a34015
-      - idt,8a34016
-      - idt,8a34017
-      - idt,8a34018
-      - idt,8a34019
-      # For Universal Frequency Translator (UFT)
-      - idt,8a34040
-      - idt,8a34041
-      - idt,8a34042
-      - idt,8a34043
-      - idt,8a34044
-      - idt,8a34045
-      - idt,8a34046
-      - idt,8a34047
-      - idt,8a34048
-      - idt,8a34049
-
-  reg:
-    maxItems: 1
-    description:
-      I2C slave address of the device.
-
-required:
-  - compatible
-  - reg
-
-examples:
-  - |
-    i2c@1 {
-        compatible = "abc,acme-1234";
-        reg = <0x01 0x400>;
-        #address-cells = <1>;
-        #size-cells = <0>;
-        phc@5b {
-            compatible = "idt,8a34000";
-            reg = <0x5b>;
-        };
-    };
-- 
2.7.4

