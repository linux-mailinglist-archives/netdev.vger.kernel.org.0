Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3F12454C6
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgHOWpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgHOWpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 18:45:42 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46720C0045A5
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:47:41 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 07FJkqOV068015;
        Sat, 15 Aug 2020 21:46:52 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 07FJkpI4000504;
        Sat, 15 Aug 2020 21:46:51 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 07FJkpJv000503;
        Sat, 15 Aug 2020 21:46:51 +0200
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v5 2/6] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Sat, 15 Aug 2020 21:43:04 +0200
Message-Id: <4ad7279ba263bb4da35edcefc66679a9d72702ec.1597518433.git.ppisa@pikron.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1597518433.git.ppisa@pikron.com>
References: <cover.1597518433.git.ppisa@pikron.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 07FJkqOV068015
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.497, required 6, autolearn=not spam, BAYES_00 -0.50,
        KHOP_HELO_FCRDNS 0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1598125614.27224@CINxMI+r4dBBZ1Gq4CkgmA
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device-tree bindings for open-source/open-hardware CAN FD IP core
designed at the Czech Technical University in Prague.

CTU CAN FD IP core and other CTU CAN bus related projects
listing and documentation page

   http://canbus.pages.fel.cvut.cz/

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 .../bindings/net/can/ctu,ctucanfd.yaml        | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
new file mode 100644
index 000000000000..6fa42112bb58
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/ctu,ctucanfd.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: CTU CAN FD Open-source IP Core Device Tree Bindings
+
+description: |
+  Open-source CAN FD IP core developed at the Czech Technical University in Prague
+
+  The core sources and documentation on project page
+    [1] sources : https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core
+    [2] datasheet : https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf
+
+  Integration in Xilinx Zynq SoC based system together with
+  OpenCores SJA1000 compatible controllers
+    [3] project : https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top
+  Martin Jerabek dimploma thesis with integration and testing
+  framework description
+    [4] PDF : https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf
+
+maintainers:
+  - Pavel Pisa <pisa@cmp.felk.cvut.cz>
+  - Ondrej Ille <ondrej.ille@gmail.com>
+  - Martin Jerabek <martin.jerabek01@gmail.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - const: ctu,ctucanfd-2
+          - const: ctu,ctucanfd
+      - const: ctu,ctucanfd
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    description: |
+      phandle of reference clock (100 MHz is appropriate
+      for FPGA implementation on Zynq-7000 system).
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    ctu_can_fd_0: can@43c30000 {
+      compatible = "ctu,ctucanfd";
+      interrupts = <0 30 4>;
+      clocks = <&clkc 15>;
+      reg = <0x43c30000 0x10000>;
+    };
-- 
2.20.1

