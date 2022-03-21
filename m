Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBAF4E3467
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiCUXfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiCUXfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:35:10 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Mar 2022 16:33:43 PDT
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21B66E34C;
        Mon, 21 Mar 2022 16:33:43 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 4D1FC30AE007;
        Tue, 22 Mar 2022 00:33:42 +0100 (CET)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 6885230ADC00;
        Tue, 22 Mar 2022 00:33:41 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 22LNXfOx014320;
        Tue, 22 Mar 2022 00:33:41 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 22LNXfWM014319;
        Tue, 22 Mar 2022 00:33:41 +0100
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
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v8 2/7] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Tue, 22 Mar 2022 00:32:29 +0100
Message-Id: <c5a37fc470ae065b21e79caa65863539393c0d7c.1647904780.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device-tree bindings for open-source/open-hardware CAN FD IP core
designed at the Czech Technical University in Prague.

CTU CAN FD IP core and other CTU CAN bus related projects
listing and documentation page

   http://canbus.pages.fel.cvut.cz/

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 .../bindings/net/can/ctu,ctucanfd.yaml        | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml

diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
new file mode 100644
index 0000000000000..fb34d971dcb39
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
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
+    [2] datasheet : https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf
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


