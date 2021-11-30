Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140B2463085
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbhK3KGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240582AbhK3KGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:06:11 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A401C061746;
        Tue, 30 Nov 2021 02:02:52 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so16661933pjb.5;
        Tue, 30 Nov 2021 02:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5zGMQE96Y+XWE7CkaXakuxxVaWZNiO/peDBXG3QSjFk=;
        b=Qy2eXlE3Ci9NEO4fpdARukCsbaoJbti7w6uiDBMrni3rBxbC2KyXtle7OBXTazjHab
         EXkDtcAFBEWENmYAAFZLRkZKVNZ1NTJFntu7vh9/paS0Ux6rxaO8O9HQZpTsJ2oKQsqp
         kpJR6zY0mLhpt0dEMoz2yUVhYjsVVjmwv280HdNJ6j44ZSaGNu8E/osC2FBczRIyUZuA
         qxy4PoKt1bLEHovck8XCwCt7h9S/XKsUrlSTtbwwPJPCxtXWOQzNPdtkbCTqSU9AnVfH
         a/8OQSEkvnXm/6GxkiGcrT5eAGYsD1ZoXo0ps25RJsVMvbYrKGQ8/zFgR2iOgp6QrVUa
         AWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5zGMQE96Y+XWE7CkaXakuxxVaWZNiO/peDBXG3QSjFk=;
        b=0VcRbV6xY/A+QVXLBq4PRfk1YztIacBZ5ek5vbPdCU0BrSr05uOdBsfzcjYZ2N3Gnv
         GkQACIZNaEgW6FQ7C/0ASb3p8lCL8m4ODjE5hze/VP4WXAVLdhlbEj360zPXYEGeGboV
         qIqA714vLPMeemWYw3kpOn0BK6t7TZJgkMsCZpRD4XFc5FQDYseCQ6WwaPO0snFOguAw
         7JLSQpT2YPm+0Ir0E6rZ8FQQ+7snzB2+GRWH0lD3D7Gd2XucSxxWeza1PtNOCy2ihXzg
         4kUPN/aQQakpBYXzm2/pLadIo1GkiisJ0nzUpaxWZG5iLyZ6XUiGwpxtFlLFX9FEH5QA
         GCxQ==
X-Gm-Message-State: AOAM532iTHpaKfAePrbqBBumHAjvJNKXJCqV5Wr4JJHtj/YhnimiiVWf
        /+TKM6fNuHSNXOdXhLugJUE=
X-Google-Smtp-Source: ABdhPJzQDBtXojWuLK7L+JWAT+JdO8EnPLP9pI5KJl9EkVWGlEiRij1HD2HyC0DP38SzEFpkSrIqow==
X-Received: by 2002:a17:90b:3758:: with SMTP id ne24mr4755050pjb.59.1638266571458;
        Tue, 30 Nov 2021 02:02:51 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id e29sm10497114pge.17.2021.11.30.02.02.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Nov 2021 02:02:51 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     wells.lu@sunplus.com, vincent.shih@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v3 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Tue, 30 Nov 2021 18:02:51 +0800
Message-Id: <1638266572-5831-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021.

Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
Changes in v3
  - Addressed all comments from Mr. Andrew Lunn.
    - Added node 'ethernet-ports' and sub-nodes 'port'.
    - Moved properties phy-handle and phy-mode to sub-nodes 'port'.
    - Limit maximum value of reg of ethernet-phy port to 30.
  - Addressed all commetns from Mr. Rob Herring.
    - Fixed wrong indentation in dt doc (yaml).

 .../bindings/net/sunplus,sp7021-emac.yaml          | 172 +++++++++++++++++++++
 MAINTAINERS                                        |   7 +
 2 files changed, 179 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 0000000..b9b0635
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -0,0 +1,172 @@
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
+    items:
+      - description: the EMAC registers
+      - description: the MOON5 registers
+
+  reg-names:
+    items:
+      - const: emac
+      - const: moon5
+
+  interrupts:
+    description: |
+      Contains number and type of interrupt. Number should be 66.
+      Type should be high-level trigger.
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  nvmem-cells:
+    items:
+      - description: nvmem cell address of MAC address of 1st MAC
+      - description: nvmem cell address of MAC address of 2nd MAC
+
+  nvmem-cell-names:
+    description: names corresponding to the nvmem cells of MAC address
+    items:
+      - const: mac_addr0
+      - const: mac_addr1
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
+        required:
+          - reg
+          - phy-handle
+          - phy-mode
+
+  mdio:
+    type: object
+    description: external MDIO Bus
+
+    properties:
+      "#address-cells":
+        const: 1
+
+      "#size-cells":
+        const: 0
+
+    patternProperties:
+      "^ethernet-phy@[0-9a-f]+$":
+        type: object
+        description: external PHY node
+
+        properties:
+          reg:
+            minimum: 0
+            maximum: 30
+
+        required:
+          - reg
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - clocks
+  - resets
+  - pinctrl-0
+  - pinctrl-names
+  - nvmem-cells
+  - nvmem-cell-names
+  - ethernet-ports
+  - mdio
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    emac: emac@9c108000 {
+        compatible = "sunplus,sp7021-emac";
+        reg = <0x9c108000 0x400>, <0x9c000280 0x80>;
+        reg-names = "emac", "moon5";
+        interrupt-parent = <&intc>;
+        interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clkc 0xa7>;
+        resets = <&rstc 0x97>;
+        pinctrl-0 = <&emac_demo_board_v3_pins>;
+        pinctrl-names = "default";
+        nvmem-cells = <&mac_addr0>, <&mac_addr1>;
+        nvmem-cell-names = "mac_addr0", "mac_addr1";
+
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+                reg = <0>;
+                phy-handle = <&eth_phy0>;
+                phy-mode = "rmii";
+            };
+
+            port@1 {
+                reg = <1>;
+                phy-handle = <&eth_phy1>;
+                phy-mode = "rmii";
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
index da2fb28..f9f81ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18242,6 +18242,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
+SUNPLUS ETHERNET DRIVER
+M:	Wells Lu <wellslutw@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+W:	https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
+F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
+
 SUPERH
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 M:	Rich Felker <dalias@libc.org>
-- 
2.7.4

