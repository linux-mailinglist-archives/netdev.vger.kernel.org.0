Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90C044D3BA
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhKKJH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKJHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:07:54 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0000C061766;
        Thu, 11 Nov 2021 01:05:05 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p18so5202193plf.13;
        Thu, 11 Nov 2021 01:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Qap7jU3pKbD9wB1gL4FC2+loQy7R9hd7KNyGg6OulRI=;
        b=cBoAH5xPZgMZBiIP6qWoJGlaccUP85YFCZElSj7Ntd1Y04JPrl8FdZ1C8jxUDVVo0G
         qyXp/zbCrjfK2gSH/MEOhTHAglh1ZzGs59lzxEh8ec/YOTna76U9dGpfPc/+P2ugN4qs
         yj0GoL2kF4Wf4gGmEtreKR8Cw1nbWjc+crS/DvyJmzLgpV4z8Z+o5d1NHaZeNZsMEtGK
         gO6rvu3ddfS7QQI8uHA4Ogn1GZXebrnrq6zwuCxt3cDDrieINrtNy5xv4apLL4bNK06Q
         ZFbycaVepLPko0eZGjNOKDfA57uSImBLs/D8B4kcnUR2/VuHmh4Ir5apbbdJiWIqdGGs
         0BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Qap7jU3pKbD9wB1gL4FC2+loQy7R9hd7KNyGg6OulRI=;
        b=ZgDCHNUrbzybuulnzIVADSslOg+VHYyPZMnyxnRCQDcmFqt2zaBzgsVPRWWSI0aOTd
         4v/oYkg3xyEr1Ao9yBFQ3njUXErFCwyxX2fbGK/7ACXiKn/tzq9PngDrzg6dkiqZjgJe
         9gH8WAdxRS/TdK60DXLPVcu+Fj5uvkKvN1+hddjIqDjaScqERaUZAnYZl052iD3SF85n
         P++bABcb38CKTsT428VxSxjN6yq1pR/3BvA2ihA9tP4YUZOWKmdPd5Fqbtij78qIpVeJ
         Owy+YUUh0VLab9qLTEh9ZSzg4XRJPZ7Uc0oi3qPMLRDKp9A2yGOPUuY+pRMftMPsuqaJ
         VfmA==
X-Gm-Message-State: AOAM530R/UH+N4CBCFC0tkv15vK7C4gjYRz96l1Q+hsxzfOBNAupxIBp
        TEjxYERdw+zznVZR9uPkXOM=
X-Google-Smtp-Source: ABdhPJy28eOTy4ErIiz9W9rSCV4Tz7aBBHQCN1D823p6ZsLd+pc02PN0pwKoJ4hJSWq0tFu1wi4hqg==
X-Received: by 2002:a17:903:2288:b0:141:e76d:1b16 with SMTP id b8-20020a170903228800b00141e76d1b16mr5816701plh.21.1636621505464;
        Thu, 11 Nov 2021 01:05:05 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id cv1sm7626011pjb.48.2021.11.11.01.05.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Nov 2021 01:05:04 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
X-Google-Original-From: Wells Lu <wells.lu@sunplus.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     vincent.shih@sunplus.com, Wells Lu <wells.lu@sunplus.com>
Subject: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Thu, 11 Nov 2021 17:04:20 +0800
Message-Id: <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1636620754.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
In-Reply-To: <cover.1636620754.git.wells.lu@sunplus.com>
References: <cover.1636620754.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021.

Signed-off-by: Wells Lu <wells.lu@sunplus.com>
---
Changes in V2
 - Added mdio and phy sub-nodes.

 .../bindings/net/sunplus,sp7021-emac.yaml          | 152 +++++++++++++++++++++
 MAINTAINERS                                        |   7 +
 2 files changed, 159 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 0000000..9bb0b4a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -0,0 +1,152 @@
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
+  - Wells Lu <wells.lu@sunplus.com>
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
+      - description: Base address and length of the EMAC registers.
+      - description: Base address and length of the MOON5 registers.
+
+  reg-names:
+    items:
+      - const: emac
+      - const: moon5
+
+  interrupts:
+    description: |
+      Contains number and type of interrupt. Number should be 66.
+      Type should be high-level trigger
+    maxItems: 1
+
+  clocks:
+    description: |
+      Clock controller selector for Ethernet MAC controller.
+    maxItems: 1
+
+  resets:
+    description: |
+      Reset controller selector for Ethernet MAC controller.
+    maxItems: 1
+
+  phy-handle1:
+    description: A handle to node of phy 1 in mdio node
+    maxItems: 1
+
+  phy-handle2:
+    description: A handle to node of phy 2 in mdio node
+    maxItems: 1
+
+  pinctrl-names:
+    description: |
+      Names corresponding to the numbered pinctrl states.
+      A pinctrl state named "default" must be defined.
+    const: default
+
+  pinctrl-0:
+    description: A handle to the 'default' state of pin configuration
+
+  nvmem-cells:
+    items:
+      - description: nvmem cell address of MAC address of MAC 1
+      - description: nvmem cell address of MAC address of MAC 2
+
+  nvmem-cell-names:
+    description: names corresponding to the nvmem cells of MAC address
+    items:
+      - const: mac_addr0
+      - const: mac_addr1
+
+  mdio:
+    type: object
+    description: Internal MDIO Bus
+
+    properties:
+      "#address-cells":
+        const: 1
+
+      "#size-cells":
+        const: 0
+
+    patternProperties:
+      "^ethernet-phy@[0-9]$":
+        type: object
+
+        description:
+          Integrated PHY node
+
+        properties:
+           reg:
+             maxItems: 1
+
+           phy-mode:
+             maxItems: 1
+
+        required:
+          - reg
+          - phy-mode
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
+  - phy-handle1
+  - phy-handle2
+  - pinctrl-0
+  - pinctrl-names
+  - nvmem-cells
+  - nvmem-cell-names
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
+        phy-handle1 = <&eth_phy0>;
+        phy-handle2 = <&eth_phy1>;
+        pinctrl-0 = <&emac_demo_board_v3_pins>;
+        pinctrl-names = "default";
+        nvmem-cells = <&mac_addr0>, <&mac_addr1>;
+        nvmem-cell-names = "mac_addr0", "mac_addr1";
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            eth_phy0: ethernet-phy@0 {
+                reg = <0>;
+                phy-mode = "rmii";
+            };
+            eth_phy1: ethernet-phy@1 {
+                reg = <1>;
+                phy-mode = "rmii";
+            };
+        };
+    };
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index dcc1819..737b9d0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18000,6 +18000,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
+SUNPLUS ETHERNET DRIVER
+M:	Wells Lu <wells.lu@sunplus.com>
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

