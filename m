Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60739DF661
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbfJUT6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:58:34 -0400
Received: from mxout2.idt.com ([157.165.5.26]:58754 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJUT6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 15:58:34 -0400
Received: from mail6.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id x9LJwKdh002423;
        Mon, 21 Oct 2019 12:58:20 -0700
Received: from corpml3.corp.idt.com (corpml3.corp.idt.com [157.165.140.25])
        by mail6.idt.com (8.14.4/8.14.4) with ESMTP id x9LJwJif008501;
        Mon, 21 Oct 2019 12:58:19 -0700
Received: from vcheng-VirtualBox.na.ads.idt.com (corpimss2.corp.idt.com [157.165.141.30])
        by corpml3.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id x9LJwHW22079;
        Mon, 21 Oct 2019 12:58:17 -0700 (PDT)
From:   vincent.cheng.xh@renesas.com
To:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, robh+dt@kernel.org
Cc:     mark.rutland@arm.com, richardcochran@gmail.com,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT ClockMatrix based PTP clock
Date:   Mon, 21 Oct 2019 15:57:47 -0400
Message-Id: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Add device tree binding doc for the IDT ClockMatrix PTP clock.

Co-developed-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---

Changes since v2:
 - As suggested by Rob Herring:
   1. Replace with DT schema
   2. Remove '-ptp' from compatible string
   3. Replace wildcard 'x' with the part numbers.

Changes since v1:
 - No changes
---
 .../devicetree/bindings/ptp/ptp-idtcm.yaml         | 63 ++++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml

diff --git a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
new file mode 100644
index 0000000..d3771e0
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
@@ -0,0 +1,63 @@
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
+    phc@5b {
+          compatible = "idt,8a34000";
+          reg = <0x5b>;
+    };
-- 
2.7.4

