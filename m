Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE151F4F61
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 09:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgFJHo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 03:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgFJHo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 03:44:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653C3C03E96F
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:44:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so620973pgn.5
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D5wpVa2/XN6m1sQCYfcdRcpjlnTpDyn4pCl/sB+sGr4=;
        b=FaW2IaQV+r7P93uoAgYFbVSHwrlIAWFar4ukwDRizxpruAAEKLbT9ZGCuAfcFtiqvp
         5VXnwr8XZGqv2p3st1VhCev8QV4uIiwctrNGcNbHTEKDApc6JHt/dPdTrtLiU6eSBple
         zAGfJigjnXkTY2elpzC5cg6jN4Wo+6BTLaDECUjQP9bNfdGCHpfRqEbHCWiomgDRE7o8
         if6XsSeKwq3PEy7bH9D8sIKKIFJvLzfNpjwxEnbNcqyerScSyfp0SRMzS9yJFS5Y4ZxQ
         SsS4PVNdDod5XCVZCPd5DOnkSaAEqPiFyUhznmTz4n1dE5WagBkg4H5rs+tyUR0rJjcN
         +iOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D5wpVa2/XN6m1sQCYfcdRcpjlnTpDyn4pCl/sB+sGr4=;
        b=W2eePkJIVQUU35UXhNZv5daybkXsxK/yK96NpIR45uab9ORKluKbHTv1c05F6V+kf1
         72/wb5vQKdhR+b4QMEd9q2h+8iFRUA6px2Puzw0N1w3zBX0+cqsPQciF3F/cO3SdYwa2
         AeewGrtokutdcgmuP3+b4flWKQHUSOhZYZNVlUNCNS90zY76+cwnNv6kHA3GXLBOqSH5
         Vn4ZRx30XmJ9DFoq8iQCeaYgZ7kzWdLhdcVMj81DZQtyrT+RnQfyP7D4wiGC0tmbjXxW
         3wT+/jsDJH3nDftjtnm1PNxoFZxhrXybEOOlDPgmuPxhwD9m+SuInoS7uF0KcAl2gni2
         SyNQ==
X-Gm-Message-State: AOAM530mSTj9LNT7v84sprH5bViVsOe0aDYxmpt7ccqeVrdb7VPi10dt
        EfZDNgMeqMm0Ge2bfGARG/qb
X-Google-Smtp-Source: ABdhPJya/wYkffZ4Vj8lRPI/HtA8nIXm2uBjOxPrm+Yv/cNoJmPxD97LW4CdEjzJO0QIMzAR+RiNXQ==
X-Received: by 2002:a65:46cc:: with SMTP id n12mr1664976pgr.80.1591775097893;
        Wed, 10 Jun 2020 00:44:57 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:630f:1dba:c41:a14e:6586:388a])
        by smtp.gmail.com with ESMTPSA id a20sm11516795pff.147.2020.06.10.00.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 00:44:57 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     kernel@martin.sperl.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 1/6] dt-bindings: can: Document devicetree bindings for MCP25XXFD
Date:   Wed, 10 Jun 2020 13:14:37 +0530
Message-Id: <20200610074442.10808-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
References: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Sperl <kernel@martin.sperl.org>

Add devicetree YAML bindings for Microchip MCP25XXFD CAN controller.

Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
[mani: converted to YAML binding]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../bindings/net/can/microchip,mcp25xxfd.yaml | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml b/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
new file mode 100644
index 000000000000..7b87ec328515
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/microchip,mcp25xxfd.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip MCP25XXFD stand-alone CAN controller binding
+
+maintainers:
+  -  Martin Sperl <kernel@martin.sperl.org>
+  -  Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
+
+properties:
+  compatible:
+    const: microchip,mcp2517fd
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  gpio-controller: true
+
+  "#gpio-cells":
+    const: 2
+
+  vdd-supply:
+    description: Regulator that powers the CAN controller
+
+  xceiver-supply:
+    description: Regulator that powers the CAN transceiver
+
+  microchip,clock-out-div:
+    description: Clock output pin divider
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2, 4, 10]
+    default: 10
+
+  microchip,clock-div2:
+    description: Divide the internal clock by 2
+    type: boolean
+
+  microchip,gpio-open-drain:
+    description: Enable open-drain for all pins
+    type: boolean
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+  - gpio-controller
+  - vdd-supply
+  - xceiver-supply
+
+additionalProperties: false
+
+examples:
+  - |
+    spi {
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           can0: can@1 {
+                   compatible = "microchip,mcp2517fd";
+                   reg = <1>;
+                   clocks = <&clk24m>;
+                   interrupt-parent = <&gpio4>;
+                   interrupts = <13 0x8>;
+                   vdd-supply = <&reg5v0>;
+                   xceiver-supply = <&reg5v0>;
+                   gpio-controller;
+                   #gpio-cells = <2>;
+           };
+    };
+
+...
-- 
2.17.1

