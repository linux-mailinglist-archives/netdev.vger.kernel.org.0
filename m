Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9890306DD0
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhA1Gpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:45:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:3043 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhA1Gpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816329; x=1643352329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kcXRAuyJ9EzBjv3KtVbdwXLLCjOZ76LBz3uqxTXCFms=;
  b=X17qqdVC8jj/VEXWMQJIty9wX2aS45CK+GXUzmEyo+krzjONORtJc36x
   PaQCb+pPujrYFgpRFcUVzjW6quB6wDau7JjpqnKkuK5vSsMMUAaY0EsSn
   wremAsCf2wtYeL3yx27/kFzgjl8C4GNsxgvfa3wxtaxNLXeS4Vx3qpQVb
   iRtkMEXkHlUkqWVyPAw95X8WRdZNFYIsi4uTqmb8qrt0USL4zv3YWd6x2
   KKf7DyaPhuEBKVahHeYpghRy5lyMUTr8+NfPyEaCO6gTVXrlahWfV5eZg
   F5s8KLE3OkrzHvbrboDHKBsm8y75neUIZuL68GudpQ4hyKvndaOkNSNUy
   Q==;
IronPort-SDR: cjovsn4rTTduX1BxOOHl/kNOqE3l+rQoKiG6M83lMbT2MYfpw+QdIgV8cSNcVaveKHLNDyAlwm
 Xft8zEt0kE+mcWQ/D0o9BJ4Y4FWnpx1zGHyhw2SmeTmVFU28ZT87f+T8J+vdAR2pOwaaJOajCp
 Brv90IdZXju1cLMSrpsouIXIhudSERoUmJpjgIvAu9kqfp7LKMEDWFVk0Gtp/TdO8hr+1Dr0LW
 KQvowp83Z0rY23k0UWux/G7OaKugkngq9nLuBSvWXVoTSokgaK27WPqDVnPo892p+EWJ4xKRCR
 7YM=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="101713940"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:13 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:08 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 1/8] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Thu, 28 Jan 2021 12:11:05 +0530
Message-ID: <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation in .yaml format and updates to the MAINTAINERS
Also 'make dt_binding_check' is passed

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 .../bindings/net/dsa/microchip,lan937x.yaml   | 115 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 116 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
new file mode 100644
index 000000000000..8531ca603f13
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -0,0 +1,115 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LAN937x Ethernet Switch Series Tree Bindings
+
+maintainers:
+  - woojung.huh@microchip.com
+  - prasanna.vengateshan@microchip.com
+
+allOf:
+  - $ref: dsa.yaml#
+
+properties:
+  compatible:
+    enum:
+      - microchip,lan9370
+      - microchip,lan9371
+      - microchip,lan9372
+      - microchip,lan9373
+      - microchip,lan9374
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 50000000
+
+  reset-gpios:
+    description: Optional gpio specifier for a reset line
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    //Ethernet switch connected via spi to the host, CPU port wired to eth1
+    eth1 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      fixed-link {
+        speed = <1000>;
+        full-duplex;
+      };
+    };
+
+    spi1 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      pinctrl-0 = <&pinctrl_spi_ksz>;
+      cs-gpios = <0>, <0>, <0>, <&pioC 28 0>;
+      id = <1>;
+
+      lan9374: switch@0 {
+        compatible = "microchip,lan9374";
+        reg = <0>;
+
+        spi-max-frequency = <44000000>;
+
+        ethernet-ports {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          port@0 {
+            reg = <0>;
+            label = "lan1";
+          };
+          port@1 {
+            reg = <1>;
+            label = "lan2";
+          };
+          port@2 {
+            reg = <7>;
+            label = "lan3";
+          };
+          port@3 {
+            reg = <2>;
+            label = "lan4";
+          };
+          port@4 {
+            reg = <6>;
+            label = "lan5";
+          };
+          port@5 {
+            reg = <3>;
+            label = "lan6";
+          };
+          port@6 {
+            reg = <4>;
+            label = "cpu";
+            ethernet = <&eth1>;
+            fixed-link {
+              speed = <1000>;
+              full-duplex;
+            };
+          };
+          port@7 {
+            reg = <5>;
+            label = "lan7";
+            fixed-link {
+              speed = <1000>;
+              full-duplex;
+            };
+          };
+        };
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 650deb973913..455670f37231 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11688,6 +11688,7 @@ M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
2.25.1

