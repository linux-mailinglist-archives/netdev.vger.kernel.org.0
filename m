Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59746EBC4F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 04:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfKADUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 23:20:41 -0400
Received: from mxout2.idt.com ([157.165.5.26]:57573 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbfKADUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 23:20:41 -0400
Received: from mail3.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id xA13KYJu022983;
        Thu, 31 Oct 2019 20:20:34 -0700
Received: from corpml1.corp.idt.com (corpml1.corp.idt.com [157.165.140.20])
        by mail3.idt.com (8.14.4/8.14.4) with ESMTP id xA13KXs5004839;
        Thu, 31 Oct 2019 20:20:33 -0700
Received: from vcheng-VirtualBox.localdomain (corpimss2.corp.idt.com [157.165.141.30])
        by corpml1.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id xA13KRV10326;
        Thu, 31 Oct 2019 20:20:27 -0700 (PDT)
From:   vincent.cheng.xh@renesas.com
To:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v4 1/2] dt-bindings: ptp: Add device tree binding for IDT ClockMatrix based PTP clock
Date:   Thu, 31 Oct 2019 23:20:06 -0400
Message-Id: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Add device tree binding doc for the IDT ClockMatrix PTP clock.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
Changes since v3:
 - Reported-by: Rob Herring:
   1. Fix dtbs_check error: Warning (reg_format):
          /example-0/phc@5b:reg: property has invalid length

Changes since v2:
 - As suggested by Rob Herring:
 - Replace with DT schema
 - Remove '-ptp' from compatible string
 - Replace wildcard 'x' with the part numbers.

Changes since v1:
 - No changes
---
 .../devicetree/bindings/ptp/ptp-idtcm.yaml         | 69 ++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml

diff --git a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
new file mode 100644
index 0000000..9e21b83
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
@@ -0,0 +1,69 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ptp/ptp-idtcm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: IDT ClockMatrix (TM) PTP Clock Device Tree Bindings
+
+maintainers:
+  - Vincent Cheng <vincent.cheng.xh@renesas.com>
+
+properties:
+  compatible:
+    enum:
+      # For System Synchronizer
+      - idt,8a34000
+      - idt,8a34001
+      - idt,8a34002
+      - idt,8a34003
+      - idt,8a34004
+      - idt,8a34005
+      - idt,8a34006
+      - idt,8a34007
+      - idt,8a34008
+      - idt,8a34009
+      # For Port Synchronizer
+      - idt,8a34010
+      - idt,8a34011
+      - idt,8a34012
+      - idt,8a34013
+      - idt,8a34014
+      - idt,8a34015
+      - idt,8a34016
+      - idt,8a34017
+      - idt,8a34018
+      - idt,8a34019
+      # For Universal Frequency Translator (UFT)
+      - idt,8a34040
+      - idt,8a34041
+      - idt,8a34042
+      - idt,8a34043
+      - idt,8a34044
+      - idt,8a34045
+      - idt,8a34046
+      - idt,8a34047
+      - idt,8a34048
+      - idt,8a34049
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
+            compatible = "idt,8a34000";
+            reg = <0x5b>;
+        };
+    };
-- 
2.7.4

