Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EBA40B2DE
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhINPUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:20:15 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:59513 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhINPTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 11:19:13 -0400
Received: from stefan-VirtualBox.in-tech.global ([37.4.249.93]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MlO9r-1nBYAk3mjV-00lpdR; Tue, 14 Sep 2021 17:17:44 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC 2/3] dt-bindings: net: add Vertexcom MSE102x support
Date:   Tue, 14 Sep 2021 17:17:16 +0200
Message-Id: <20210914151717.12232-3-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210914151717.12232-1-stefan.wahren@i2se.com>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:1ZE4Im6uBBTGgTjcBWfo1wrdnHGRNDI/VWsWeTs5snvPcZS/M5K
 BcsgwyS5DSvTOp57XPGCLKUKEjfAzsxHB08Ev2sJtU1KTdlOn3ixc7++X2UUbKMO8wjBIFY
 I4OocWcLEifyM+JXN5d9KmvA6nzdop2mUoIYskr8EPClGfRmsA8U5u3D4iqVf2OAA0o8gmP
 UlGkLAZdI/FXjFTV5/eVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CK6dBgP2rGA=:Se42K6KpfYVgrx7+4hrTFu
 J/AM85tABDabsQEiqIiTH/2v99L5nobVq/thDIGyygE+Os0mSuXRM6CDFnRBz43IUhsvAydmG
 e2rZQdruo4no+MLLMTM8Wa1bO/L16IVDUrqsWqMZebToF+OarG96L02E8NbJW02ixwDZ7rs/9
 Zo28FaXLDMOcg2moYRNS3dIdnL/1tfIIc4d0YW7NBCKOBs9h/ncLTI1ZvIQ60qk6rOvrVPI9f
 lMvQ2RI4trKR5MHNmyEwNIQXgpUFMkrgRg+Kibi61AXQet3fsNlc/zw6y7z1a4fdKcXbpE4Zf
 BWdN53tKHugYIYUhZfSAvxQXUcICuZkpu56rT4ilCQiQUg39py+Ioe1x43kli7wp4avhwFPYR
 TWx/wgp1mbJRZMbXcPDNlwBI0f5gpSR+X7pS3PZ1+m6z9OZy3k3DXPBp+1HY1V+cVXJkE28n/
 E4W3edd0Ow5aEuxV9OfOK7T9o0W6OnumdruiexhQXD0UeMu/XAJ7gPI9ScnNDSe63x2YGE1xj
 cUU5GLB5AMkA8UJAHVyDgWz4GUKO1rva6MbwjPxmdZI9LbqFRhGtjIHSUdkzYrflTWFrHQxCL
 +P/zQB9Sqi5d3WFQbWA5KdwZpKUOs3Zd4vuLV2KAftGVZLD75NgH3YEKc45TqM45OMiNTlZo4
 0R9zlkU9P6COyYwpPjMAQtXsK75hCJpXnYYq/pkN3CIdfQXioblE7IUJQkmyvFgpfi+GxlUWa
 f7Bo/L0W/UQInePrW3uqTWfHCOZl3ceX+F3A8/izm3s3XbR1tXppva5jp3E=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree binding for the Vertexcom MSE102x Homeplug GreenPHY chip
as SPI device.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 .../bindings/net/vertexcom-mse102x.yaml       | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml

diff --git a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
new file mode 100644
index 000000000000..d1a4159a8449
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
@@ -0,0 +1,71 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/vertexcom-mse102x.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: The Vertexcom MSE102x (SPI) Device Tree Bindings
+
+maintainers:
+  - Stefan Wahren <stefan.wahren@in-tech.com>
+
+description:
+  Vertexcom's MSE102x are a family of HomePlug GreenPHY chips.
+  They can be connected either via RGMII, RMII or SPI to a host CPU.
+
+  In order to use a MSE102x chip as SPI device, it must be defined as
+  a child of an SPI master device in the device tree.
+
+  More information can be found at
+    http://www.vertexcom.com/doc/MSE1022%20Product%20Brief.pdf
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    enum:
+      - vertexcom,mse1021
+      - vertexcom,mse1022
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  spi-cpha: true
+
+  spi-cpol: true
+
+  spi-max-frequency:
+    minimum: 6000000
+    maximum: 7142857
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - spi-cpha
+  - spi-cpol
+  - spi-max-frequency
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    spi0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "vertexcom,mse1021";
+            reg = <0>;
+            interrupt-parent = <&gpio>;
+            interrupts = <23 IRQ_TYPE_EDGE_RISING>;
+            spi-cpha;
+            spi-cpol;
+            spi-max-frequency = <7142857>;
+        };
+    };
-- 
2.17.1

