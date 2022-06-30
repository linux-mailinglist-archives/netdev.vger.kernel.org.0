Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4699C5617BC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiF3KWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiF3KWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:22:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3B44552C;
        Thu, 30 Jun 2022 03:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656584503; x=1688120503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xhiQ3J25pI+QFFvwUQD7MMrKkNjewIfXvKSGpcLbB88=;
  b=vfD/ceQmhot4IiL4YDiAHeeSFzcmpgqeh0RBvdVL5G0Fox+COOxmamJx
   Oobo8RAGwsix8VKkqICCUNRAfPhv36Ubt5R9AUKKR/Y5zVKctuCGy4Nnu
   Dvm+0u9NHzjfyw+juH445BY0PEqFKcieowFnLeOtMVxwGuK9wVqOofIi1
   Wb2getP+6PUqTzIHNHm2VYQbW4ezakFG24IImAEJjxmuYImfHJsjklNca
   QPKYuE++mDyqzyq3hua9ZI0RtL7Xy33JKeG0aYEAisKmOPHAq0W357sPv
   sW7W13asmj2Mh8X8njIrV9nfZ11Pps0Bw3x2h+oaObyIEOu5yCh1zisYc
   A==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="180172301"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 03:21:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 03:21:41 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 30 Jun 2022 03:21:33 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v14 02/13] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Thu, 30 Jun 2022 15:50:30 +0530
Message-ID: <20220630102041.25555-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630102041.25555-1-arun.ramadoss@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Documentation in .yaml format and updates to the MAINTAINERS
Also 'make dt_binding_check' is passed.

RGMII internal delay values for the mac is retrieved from
rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
v3 patch series.
https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/

It supports only the delay value of 0ns and 2ns.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/dsa/microchip,lan937x.yaml   | 192 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 193 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
new file mode 100644
index 000000000000..630bf0f8294b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -0,0 +1,192 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LAN937x Ethernet Switch Series Tree Bindings
+
+maintainers:
+  - UNGLinuxDriver@microchip.com
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
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        allOf:
+          - if:
+              properties:
+                phy-mode:
+                  contains:
+                    enum:
+                      - rgmii
+                      - rgmii-id
+                      - rgmii-txid
+                      - rgmii-rxid
+            then:
+              properties:
+                rx-internal-delay-ps:
+                  enum: [0, 2000]
+                  default: 0
+                tx-internal-delay-ps:
+                  enum: [0, 2000]
+                  default: 0
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
+    macb0 {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            fixed-link {
+                    speed = <1000>;
+                    full-duplex;
+            };
+    };
+
+    spi {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            lan9374: switch@0 {
+                    compatible = "microchip,lan9374";
+                    reg = <0>;
+                    spi-max-frequency = <44000000>;
+
+                    ethernet-ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            port@0 {
+                                    reg = <0>;
+                                    label = "lan1";
+                                    phy-mode = "internal";
+                                    phy-handle = <&t1phy0>;
+                            };
+
+                            port@1 {
+                                    reg = <1>;
+                                    label = "lan2";
+                                    phy-mode = "internal";
+                                    phy-handle = <&t1phy1>;
+                            };
+
+                            port@2 {
+                                    reg = <2>;
+                                    label = "lan4";
+                                    phy-mode = "internal";
+                                    phy-handle = <&t1phy2>;
+                            };
+
+                            port@3 {
+                                    reg = <3>;
+                                    label = "lan6";
+                                    phy-mode = "internal";
+                                    phy-handle = <&t1phy3>;
+                            };
+
+                            port@4 {
+                                    reg = <4>;
+                                    phy-mode = "rgmii";
+                                    tx-internal-delay-ps = <2000>;
+                                    rx-internal-delay-ps = <2000>;
+                                    ethernet = <&macb0>;
+
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                    };
+                            };
+
+                            port@5 {
+                                    reg = <5>;
+                                    label = "lan7";
+                                    phy-mode = "rgmii";
+                                    tx-internal-delay-ps = <2000>;
+                                    rx-internal-delay-ps = <2000>;
+
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                    };
+                            };
+
+                            port@6 {
+                                    reg = <6>;
+                                    label = "lan5";
+                                    phy-mode = "internal";
+                                    phy-handle = <&t1phy6>;
+                            };
+
+                            port@7 {
+                                    reg = <7>;
+                                    label = "lan3";
+                                    phy-mode = "internal";
+                                    phy-handle = <&t1phy7>;
+                            };
+                    };
+
+                    mdio {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            t1phy0: ethernet-phy@0{
+                                    reg = <0x0>;
+                            };
+
+                            t1phy1: ethernet-phy@1{
+                                    reg = <0x1>;
+                            };
+
+                            t1phy2: ethernet-phy@2{
+                                    reg = <0x2>;
+                            };
+
+                            t1phy3: ethernet-phy@3{
+                                    reg = <0x3>;
+                            };
+
+                            t1phy6: ethernet-phy@6{
+                                    reg = <0x6>;
+                            };
+
+                            t1phy7: ethernet-phy@7{
+                                    reg = <0x7>;
+                            };
+                    };
+            };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 7c029ab73265..683ecc0973b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13057,6 +13057,7 @@ M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
2.36.1

