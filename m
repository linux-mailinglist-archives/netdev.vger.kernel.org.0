Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1334684FE
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385028AbhLDNVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:21:50 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:43339 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhLDNVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 08:21:48 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MKKpV-1n968l1cBL-00LpNF; Sat, 04 Dec 2021 14:18:08 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC V2 2/4] dt-bindings: net: add Vertexcom MSE102x support
Date:   Sat,  4 Dec 2021 14:17:49 +0100
Message-Id: <1638623871-21805-3-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
References: <1638623871-21805-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:ofEfx0MkNvb5x3SQOvOS8JHipDuZZUWHoSh7T2cKp/fwQi+UI/a
 RndhEAmPXg8YD56zk8+efP0dO4gracnh+XDyyfhV1FEGKvBZVsScm4X+VRdUxaYVkPUTvg3
 cy7U/iqrztXeeirJdAYS24GK+zNDedsblQT1O4QEqZzS0excusT2yWVeUWkl6QDFwOAxnce
 zm2vUd53VX+Jd9f1vjjBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vORl/YsucBc=:hOaQ3R+WVCosbk0t4EVbd6
 Uu6gcceQqgc9tjVt2nAoxLDbAS4lM/FSjAhtdLJBR0c+8J6ZSc7ldQjk1FYq4k8M76c8oBm3F
 aV1Sd+H+ccPAobyHpL94iAhcUuCiyVamRvjhTrkUABVCox4nGltzzb/jJRIU1/QetDN2xiqvg
 y86MnHLw5LbQ+hqu31KF6mAs6Z6zXl3vtT3QcDk7zqN7RP3sevJD1a+qnIDE0TD50cBoZLCXw
 HowCaVRnfdt38KkmX961sxH9lSmz+ENlKSuszW4m4ER86kCemJf01GcQUwHkJyXdh09/zeOON
 ++ln9em7KGTYvv4St0Ta7OVQqqL8PvDlPVX44ow2jIPZIV/c7eNLPaK4goyCpuFh8nNVATgdT
 HL4jjv2qM8iwpF6ElqDfOjxY6XE/t8RsSO2OWRYVaTQIBrKi81t6qk/Ae7zoOJQBJApgvH5Oy
 lg8ldihEF5DhVu6UaO0d/HlTw+pxt34PvAAzS38mYIsCYNN4qUpzihowgXmcXq+pk+5LPrryb
 9ue+oE06OIuB94iaF13jjVsTlIgFM+5A1oAlUSpJVDlVaInlB9qxpJ0L3zVO6FxptFt8EjQIh
 h6eJYbzbNqCFbQZJQfP9169isCqPn5G+uSPmlOmSZe49BKwxkmP0GUiwgk0wtN5gquXPqEFPQ
 dVqbgKtQadp0vXpyNA8IGfZRyf40gm+i4BgIxsiZVZKVM1VGFRHSuRm6/HZIewu+tTFDHy53s
 N18J1CKr+W5A5EbG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree binding for the Vertexcom MSE102x Homeplug GreenPHY chip
as SPI device.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/vertexcom-mse102x.yaml | 71 ++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml

diff --git a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
new file mode 100644
index 0000000..8156a9a
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
2.7.4

