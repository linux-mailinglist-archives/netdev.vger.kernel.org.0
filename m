Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93199153982
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 21:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBEUXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 15:23:48 -0500
Received: from mxout2.idt.com ([157.165.5.26]:49696 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEUXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 15:23:48 -0500
Received: from mail6.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id 015KNekt001341;
        Wed, 5 Feb 2020 12:23:40 -0800
Received: from corpml3.corp.idt.com (corpml3.corp.idt.com [157.165.140.25])
        by mail6.idt.com (8.14.4/8.14.4) with ESMTP id 015KNejQ015665;
        Wed, 5 Feb 2020 12:23:40 -0800
Received: from minli-office.na.ads.idt.com (corpimss2.corp.idt.com [157.165.141.30])
        by corpml3.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id 015KNdW01014;
        Wed, 5 Feb 2020 12:23:39 -0800 (PST)
From:   min.li.xe@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next 1/2] dt-bindings: ptp: Add IDT 82P33 based PTP clock
Date:   Wed,  5 Feb 2020 15:23:27 -0500
Message-Id: <1580934207-15415-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Add device tree binding doc for the PTP clock based on IDT 82P33
Synchronization Management Unit (SMU).

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 .../devicetree/bindings/ptp/ptp-idt82p33.yaml      | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml

diff --git a/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
new file mode 100644
index 0000000..11d1b40
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ptp/ptp-idt82p33.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: IDT 82P33 PTP Clock Device Tree Bindings
+
+description: |
+  IDT 82P33XXX Synchronization Management Unit (SMU) based PTP clock
+
+maintainers:
+  - Min Li <min.li.xe@renesas.com>
+
+properties:
+  compatible:
+    enum:
+      - idt,82p33810
+      - idt,82p33813
+      - idt,82p33814
+      - idt,82p33831
+      - idt,82p33910
+      - idt,82p33913
+      - idt,82p33914
+      - idt,82p33931
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
+        phc@51 {
+            compatible = "idt,82p33810";
+            reg = <0x51>;
+        };
+    };
-- 
2.7.4

