Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAB4517039
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiEBN1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbiEBN12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:27:28 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0E811144;
        Mon,  2 May 2022 06:23:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p8so12280779pfh.8;
        Mon, 02 May 2022 06:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y1MBTI2fZRzRGcuYvG64eYXq1ZKVuG6A5Hq9c/v6FTU=;
        b=pXBmknH4QtAgv4fzmAgLBwyxFyIWbuGpHX8ZNDsEY6AV2tzgcaL1kmDngTmMMeBJvP
         kjg45ZjW5W+uA4s9PsJ40TelgeE4m7NeUB5P5li9l8KZfxZ3k/Fq1Q9q/36eVIdrBfn8
         ZeS2Za6md//Qj0OispWwAm8RjRSe6DkIDvyZZfEYbHTgh1HsZWpWzC6Sv+QSR2ecLaYW
         GhetXZerDoONRY51/ljvz4V+DBmt1a5TOY9BiILOSUGeSAiAEZZHkXMAUItKDhXWoa89
         3xBok9IN5L5p6dXxHovXViPjZND0V2M6nSQJhNfVC/j1i9qF2556i0ihWiub3TO1Rp6z
         aSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y1MBTI2fZRzRGcuYvG64eYXq1ZKVuG6A5Hq9c/v6FTU=;
        b=7Qto1GaXMENFU6El3AVIU2JSUg2bm05vw7bTmnpjsfI4lp17fByCvioCG9RLBLVmIa
         e9czWhcw7ra9b56Qx/tyjIEyk8tYWGKGskMJ7HliQYbSWdJwHZMLy5yx3+szpr4znX7g
         eBij8JgjXg8fJJn7bry2r0NxJohYLOjTobFIZXvDMY7r5At5yHNmC59nl5TRm6qx4GW0
         ag77CqZlBeTEaUctPNPb9HwzPzgNsriphMkF6vqVPSaWlPQ2srEAF4vyLgz9RpGwNoKZ
         u2RG1vMS3m3qCmlf6zEZY3K9dZrsFav19XGxzWIr0xqcud2SAaqc5WxUA8f3bwFEdUca
         jmcg==
X-Gm-Message-State: AOAM531IPhdsSr6dB2xzp5kPQNwl1KPntHKk8DBY9HIF2Nz8ePymd0Kt
        2RvcWZeiPp5MCp44HjNBnto=
X-Google-Smtp-Source: ABdhPJzEOwflmCCktqkw0FviJNlW6+I2YEHv1iPNji3OyY/ycTZtcrwfe9pkwnhOiLih9Tkb0loIdw==
X-Received: by 2002:a63:5712:0:b0:39e:f4e7:da85 with SMTP id l18-20020a635712000000b0039ef4e7da85mr9800103pgb.109.1651497835681;
        Mon, 02 May 2022 06:23:55 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id e11-20020a62ee0b000000b0050dc762818bsm4676897pfi.101.2022.05.02.06.23.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 May 2022 06:23:55 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v10 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Mon,  2 May 2022 21:23:37 +0800
Message-Id: <1651497818-25352-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1651497818-25352-1-git-send-email-wellslutw@gmail.com>
References: <1651497818-25352-1-git-send-email-wellslutw@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021 SoC.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
Changes in v10
  - None

 .../bindings/net/sunplus,sp7021-emac.yaml     | 141 ++++++++++++++++++
 MAINTAINERS                                   |   7 +
 2 files changed, 148 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 000000000..62dffee27
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -0,0 +1,141 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (C) Sunplus Co., Ltd. 2021
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/sunplus,sp7021-emac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Sunplus SP7021 Dual Ethernet MAC Device Tree Bindings
+
+maintainers:
+  - Wells Lu <wellslutw@gmail.com>
+
+description: |
+  Sunplus SP7021 dual 10M/100M Ethernet MAC controller.
+  Device node of the controller has following properties.
+
+properties:
+  compatible:
+    const: sunplus,sp7021-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  ethernet-ports:
+    type: object
+    description: Ethernet ports to PHY
+
+    properties:
+      "#address-cells":
+        const: 1
+
+      "#size-cells":
+        const: 0
+
+    patternProperties:
+      "^port@[0-1]$":
+        type: object
+        description: Port to PHY
+
+        properties:
+          reg:
+            minimum: 0
+            maximum: 1
+
+          phy-handle:
+            maxItems: 1
+
+          phy-mode:
+            maxItems: 1
+
+          nvmem-cells:
+            items:
+              - description: nvmem cell address of MAC address
+
+          nvmem-cell-names:
+            description: names corresponding to the nvmem cells
+            items:
+              - const: mac-address
+
+        required:
+          - reg
+          - phy-handle
+          - phy-mode
+          - nvmem-cells
+          - nvmem-cell-names
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - resets
+  - pinctrl-0
+  - pinctrl-names
+  - ethernet-ports
+  - mdio
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    ethernet@9c108000 {
+        compatible = "sunplus,sp7021-emac";
+        reg = <0x9c108000 0x400>;
+        interrupt-parent = <&intc>;
+        interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clkc 0xa7>;
+        resets = <&rstc 0x97>;
+        pinctrl-0 = <&emac_demo_board_v3_pins>;
+        pinctrl-names = "default";
+
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+                reg = <0>;
+                phy-handle = <&eth_phy0>;
+                phy-mode = "rmii";
+                nvmem-cells = <&mac_addr0>;
+                nvmem-cell-names = "mac-address";
+            };
+
+            port@1 {
+                reg = <1>;
+                phy-handle = <&eth_phy1>;
+                phy-mode = "rmii";
+                nvmem-cells = <&mac_addr1>;
+                nvmem-cell-names = "mac-address";
+            };
+        };
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            eth_phy0: ethernet-phy@0 {
+                reg = <0>;
+            };
+
+            eth_phy1: ethernet-phy@1 {
+                reg = <1>;
+            };
+        };
+    };
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index b5f2a647e..22a2f9699 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18884,6 +18884,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
+SUNPLUS ETHERNET DRIVER
+M:	Wells Lu <wellslutw@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+W:	https://sunplus.atlassian.net/wiki/spaces/doc/overview
+F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
+
 SUNPLUS OCOTP DRIVER
 M:	Vincent Shih <vincent.sunplus@gmail.com>
 S:	Maintained
-- 
2.25.1

