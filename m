Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87615471AF9
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 15:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhLLOvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 09:51:12 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:35105 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhLLOvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 09:51:11 -0500
Received: from localhost.localdomain ([37.4.249.122]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MbRwP-1mPpSP3QDJ-00bppz; Sun, 12 Dec 2021 15:50:52 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH V3 net-next 2/3] dt-bindings: net: add Vertexcom MSE102x support
Date:   Sun, 12 Dec 2021 15:50:26 +0100
Message-Id: <1639320627-8827-3-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
References: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:k1exPWyfeyTQ/GsfXXPCmiGHaAWc5aA/3zMi644sT3GsBEt8EX9
 sL6szsBpPKf7Ly6Z+0WAi02Xt1oKsMhe46MqwEeapBpCeXqQXybW4aX1tFW5V1sCk40C/hW
 JZzoJklLjEY1oGlCsKfe6Lf5Cw0Ec4h1kIh9bvlLFs7ZbDh37Qc3Vk0z2imB5M3fbSA0ni7
 fTAQKE977ukl/Fw3zDx6g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:W9dumw6KuJE=:GRsGTtG6HvkbgURhtuCCUu
 mgGmIQXVk0hGzQAXV54t5J+joySlkdKfvKZpskLofvcpkbQGfmp2SQj/VLJ9WyeY3DR7PITlC
 JlAVMLw7i92u+yeccn7eoZIDWvsIpHnu3sIe39irls/ztIm+BWSW9gn6wV6gu2NHoK0M+WXdC
 ML63YEE3se29CXxKgJJu8RcYpZBToQRQZMOgd2nUpN5RD7uD7bwdtbBJINoUPZnLvX8O9ZVCg
 xNLfNygSfotOuD5pA+soixnS4PmT9sW6JJYmSlZVw4KqLMmmnwxCz1rPwXmkSxmjlHRf9+A2U
 5UNBlKT6FYmlFosH/PoxjvoIOFI/3/L7D8eRf7G+Zj7D6kk/deF0eohWxBXpIqPeCLaHAizlN
 8m9bsfjrapbxF3Qc4tjP+zh1X+ixJkE+K5bDE0ZIjIvhvFbBfXahXd9i6E0EuolWAjNepAi78
 I4/HKzrZ4JYLtIiEQ7XUVTG1GF6sUzED9Q+Li/ZSHojhdqNYyo1UXlSk9nSW6rSpUhkpwFFbE
 0xGpjNqU7A01nulFCLrVtNCB7MKcb5wPq6cVPy9XyKE8mX+wTXdBDGntBUMLLpak/f826BKuU
 si/13aqcJtJfSvaSUdu7ouchSdE5iIlAbX/QL3pC6UiaaX/c8sFpOqOnMB8igqdrAHpuixufs
 Y32drLz3g6B0mwo5gcBhypLl7MLNkI/67u8rGwMq+HBqDFRLwzC9zyFhio4dTxTMOAV3MiaKH
 Ib9tbPymTFdvfGXx
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

