Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DCA46B526
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhLGIKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhLGIKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:10:31 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC751C061746;
        Tue,  7 Dec 2021 00:07:01 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id kl8so12414951qvb.3;
        Tue, 07 Dec 2021 00:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0WpbOjtaOGDJNbp/SkWnne9JtZM+2Dp25nX2xKJqalw=;
        b=K6YQvPPVPTavswc54fUBF6EQuVwxB+Nflm9UbIK3W/cQdK4SBNipwpaTdJa6QdM+ri
         A/Ic35SiSMHlvE2BQqqa7wflKtuScFeAOcYQIO8sqfTETe3RFZnd4oDHWBq+XhVFOqBm
         Fes+oaeCvOw8NzRmnRqKunXob1yPIEBCI6q9i/Wd1d5cVxHtsm+Wy29LQ3cbsN0my2pS
         NWgWwEHKke7sd96qiycPK+cGwNr26Ne+auxXjx7wAkWaiz4VTw3BXrIMwKUhi84/0yIu
         Viy1vWcvcehCfY6I6tNPrsK0Re2ljxU2g2n2349V71Z+yI9S0rXcwStwoCdRjh6773lu
         I/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0WpbOjtaOGDJNbp/SkWnne9JtZM+2Dp25nX2xKJqalw=;
        b=GZqUMG9Xza+mxUAh/z7ZQZdsnK31oMcjJyp+UavqhSeN5ffjcuPAiQl9/MAAM7RGWU
         y0wYUleE4J/EXhxI4VrJQiXwo/Syz4I+SHxVblScBGP3NBYZFnylj95r+PEv9CWXkz43
         D4Rj12Re8ZY19vxe3JycCvHomsrF8CfdZFc4b0zv+2s/WcTOJLLZYkxye4pfLZAkloWs
         0Q5hMa9r/IHISJWOTTa0tQuiKcVDqN3RZMi9b9ACP2vdQUMRo7kYLwyed5tDgUOIUHhu
         UIyWa5LmrphlE4LRiFMqJCACKZFrJp1gv1A27GWlecmnrQb9K3T+xe8qgdihBxyZY0ak
         7r8w==
X-Gm-Message-State: AOAM532A7lE4yl/33y+odmXcGnwEl6uucpyK3V7V27/BBkxI5xD4Nsnm
        9eIZ4KdsR4qyEWCw/wCzHNpJ/sHEHlU=
X-Google-Smtp-Source: ABdhPJztZ3zCskeqo/UQ8fOxGNYu8+j6g5r9ZBsklbAHdgik6nf9yScio5krxISaiLhbo7xmJa25Eg==
X-Received: by 2002:a05:6214:501b:: with SMTP id jo27mr44177293qvb.64.1638864420896;
        Tue, 07 Dec 2021 00:07:00 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id bj32sm7673679qkb.75.2021.12.07.00.06.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 00:07:00 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     wells.lu@sunplus.com, vincent.shih@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v4 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Tue,  7 Dec 2021 16:06:58 +0800
Message-Id: <1638864419-17501-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021.

Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
Changes in v4
  - Addressed all comments from Mr. Andrew Lunn.
    - Moved properties 'nvmem-cells' and 'nvmem-cell-names' to port of ethernet-ports.
    - Changed value of property 'nvmem-cell-names' to "mac-address".

 .../bindings/net/sunplus,sp7021-emac.yaml          | 172 +++++++++++++++++++++
 MAINTAINERS                                        |   7 +
 2 files changed, 179 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 0000000..efc987f
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
index 0dc08cd..5b1ef9d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18245,6 +18245,13 @@ L:	netdev@vger.kernel.org
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

