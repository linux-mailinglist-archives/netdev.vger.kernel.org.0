Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFDF1F4F79
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 09:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgFJHrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 03:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgFJHrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 03:47:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2647C08C5C2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:47:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh7so637876plb.11
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D5wpVa2/XN6m1sQCYfcdRcpjlnTpDyn4pCl/sB+sGr4=;
        b=PhN0M8ZoAvKB7gn48oGxxNQNjY/3uWTb4TbP84JJOqTujF+orc9kDVA5lM3jz62FWe
         OfXTr72NcVMesi2EYapCyGM32JEo4RWi1l53gJ+80fgeBm2+zS0bNaaTWv0Ittsgg8Ig
         8UPsx5tmdCGwQef+Kfn4X2Zr2zTB9OQurHcoWeQd3O5BcUBBiicytcLTpy6NJpcPHgPI
         m11NMbY6B1yygA7K1yuxw0Oyl8ySbUu47iohDQaq+YP8kM0ZI+4IbDOvAgi57/eufQkn
         yPg3nnp2DNU7dq5q9BS4u0p+RZh9T2rTxIfKU8fntOFSJNxsrR3N4ejTL/HLbasxi1j3
         rvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D5wpVa2/XN6m1sQCYfcdRcpjlnTpDyn4pCl/sB+sGr4=;
        b=mE+dLqblJCdqQvKhtYbVxZr/AW+4aa+i3pOkzKwHfCuAXtti8esM40BUNIDrBjim8Y
         iVaspMaKRtB5wHQX9yeQtMayWrOSehFwCY3TYRoyuWTbZrJTjxBsHa5nUmB+11S5aHSg
         vqE621Y6VNv11n+oftHC8CGg/91UUdZoZRmUYlSQabQZxsoCO90A7aYBG7d+nlL7hTrz
         qgsEZtHW4f4BhGIaIFRlc4TBlGrjsbl2iZLsCGw0w4FCq6G2TvAtvIGh0mJRjrPNnDjX
         hPk2wE8qCAuKsUZhymZkahDdSXAj5i2SXfQPcpOuoUDXudht1QkkzCkCEZVthkejkfiV
         A4vQ==
X-Gm-Message-State: AOAM532nZ/igq56axzb7idh8J8kVidlH8FgRloSC7GxcqYZLieMgePMj
        20+kTYFOoDUKbk5ZK+SswGbz
X-Google-Smtp-Source: ABdhPJwGHvsEV460dCkm/Yp/AQnaMuPgQ4DG+gLBCor8qjTX8+8FcdUUupQJMph+dGbpnQU3/nWRFQ==
X-Received: by 2002:a17:902:7c81:: with SMTP id y1mr2036371pll.236.1591775249377;
        Wed, 10 Jun 2020 00:47:29 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:630f:1dba:c41:a14e:6586:388a])
        by smtp.gmail.com with ESMTPSA id u1sm10075040pgf.28.2020.06.10.00.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 00:47:28 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     wg@grandegger.com, mkl@pengutronix.de, robh+dt@kernel.org
Cc:     kernel@martin.sperl.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [RESEND PATCH 1/6] dt-bindings: can: Document devicetree bindings for MCP25XXFD
Date:   Wed, 10 Jun 2020 13:17:06 +0530
Message-Id: <20200610074711.10969-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
References: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
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

