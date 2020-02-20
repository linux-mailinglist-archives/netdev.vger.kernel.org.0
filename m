Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408BD1669CD
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 22:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgBTV1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 16:27:48 -0500
Received: from mxout2.idt.com ([157.165.5.26]:44673 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgBTV1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 16:27:48 -0500
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id 01KLRfuQ021297;
        Thu, 20 Feb 2020 13:27:41 -0800
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id 01KLReAw029767;
        Thu, 20 Feb 2020 16:27:40 -0500
Received: from minli-office.na.ads.idt.com (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id 01KLRdV06567;
        Thu, 20 Feb 2020 13:27:40 -0800 (PST)
From:   min.li.xe@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next v3 1/2] dt-bindings: ptp: Add device tree binding for IDT 82P33 based PTP clock
Date:   Thu, 20 Feb 2020 16:27:37 -0500
Message-Id: <1582234057-6250-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Add device tree binding doc for the PTP clock based on IDT 82P33
Synchronization Management Unit (SMU).

Changes since v1:
 - As suggested by Rob Herring:
   1. Drop reg description for i2c
   2. Replace i2c@1 with i2c
   3. Add addtionalProperties: false

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 .../devicetree/bindings/ptp/ptp-idt82p33.yaml      | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml

diff --git a/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
new file mode 100644
index 0000000..9bc664f
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
@@ -0,0 +1,45 @@
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
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phc@51 {
+            compatible = "idt,82p33810";
+            reg = <0x51>;
+        };
+    };
-- 
2.7.4

