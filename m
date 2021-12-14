Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9938474476
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhLNOFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbhLNOFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:05:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2696C061574;
        Tue, 14 Dec 2021 06:05:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h24so14395462pjq.2;
        Tue, 14 Dec 2021 06:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fh/1eoV7ZCBgVRMld4Bwvbe3CWsIYUjpVGQ/oEsRIN0=;
        b=ajVo1O+p7XABWk+cNNIe0FxNf/P+wpViFhUgGuSZdlBVEuKvoRNP5FobCpcWSiLfus
         lQzDnJurEUrhbBbPqW0KADrXG8cTFFtzrGTn4Nwi07DDbKnrw5170p78ehY/0w2ECAxM
         UPBGTWKf+O91H0mi9YWnmEh0XSiioAxWBXnrPyf+jBYKe0JZQooEoeFNkCSIJIyCeuHQ
         v2kPPz3qd+xXuR0Mce2thfGqnOsMczBDXtp3acUu7JOWpu/3ZOxYdLyZLP/nZ5WKlXTM
         vmriigY35JUEeHfz0uFf8BIMWHwSKrcwe4StjsqkgDoUThOYAT9OpkAUjHUlCN/vIIkO
         pRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fh/1eoV7ZCBgVRMld4Bwvbe3CWsIYUjpVGQ/oEsRIN0=;
        b=mfOmjPGpa68CSVC3gTTi0GoO/kmEE7tFeyoYA6GupctMfw/ogn/LVARCDsofy+Z31G
         Ae4SYNT7rnNuPCBbr8PJBSdUjMZpoK3kM2ocaU+t8PKVV18imUBLE4Uw0u22ZzCh2KZk
         IR3FKPqOM6LU+lmh7WZ4Akald3hU96N/rgEo5nYt8zC5k1/DZI9qeJ+5+WBUYu2ile/d
         tDnMokU5meHXnZBcSI+QxSklSaD0FwyjLQuAsH/XtEc3eLu29CiP5DVERu+phXgeWKKe
         gLBg5Fl/YIChrf8/2cWwJyBu+dbmYQHpjjpKnZIB6KKhuBA5lmj3UaRtIhhufIoLu62E
         +qig==
X-Gm-Message-State: AOAM530HD5zS30/Hb9dpQ3Wt5ySh8AsUh69sHIBWCJj2Wky1Kr9biwu9
        VxU6tTUqKemU4clyqm/KaRY=
X-Google-Smtp-Source: ABdhPJw2UqysGt9lvhRPKZN3H1yrVV3PBqBOGVFzhNbV5wwqSOEOl7E4tEzsXtD9eLbhb58Zt9U6yQ==
X-Received: by 2002:a17:90b:2389:: with SMTP id mr9mr6049161pjb.152.1639490743351;
        Tue, 14 Dec 2021 06:05:43 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id j20sm2245986pjl.3.2021.12.14.06.05.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 06:05:43 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     wells.lu@sunplus.com, vincent.shih@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v5 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Tue, 14 Dec 2021 22:05:42 +0800
Message-Id: <1639490743-20697-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639490743-20697-1-git-send-email-wellslutw@gmail.com>
References: <1639490743-20697-1-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021 SoC.

Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
Changes in v5
  - Addressed comments of Mr. Rob Herring.

 .../bindings/net/sunplus,sp7021-emac.yaml          | 149 +++++++++++++++++++++
 MAINTAINERS                                        |   7 +
 2 files changed, 156 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 0000000..85a0a3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -0,0 +1,149 @@
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
+    ethernet@9c108000 {
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
index 19d6fcc..ee67bb9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18249,6 +18249,13 @@ L:	netdev@vger.kernel.org
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

