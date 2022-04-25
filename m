Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4CB50DDED
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbiDYKer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241248AbiDYKen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:34:43 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6066FD09;
        Mon, 25 Apr 2022 03:31:27 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g3so12430294pgg.3;
        Mon, 25 Apr 2022 03:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k9fX4QyWTzA0y00nOsSz5XPtLo1F8esV9J1yjU08QfY=;
        b=jjCW6bRaVcQ0yJumdf0PnnmaxJ33DgH8w8H47FEfg3IVO8dNl/0h4qZbohwZ5++9A5
         5dMP82k3bY7TV7YDQG4MokgC1ACyMdzumlYkLr5BB3tYxcDzO6qNLmjcPJIHxtzA83Xo
         zha5DkvsEJioF3t7ImI7HFjcKB9BcOAazt/CdLFIwBRcWleJ/TsFuhoLIedrQLGRwjCl
         XuwDoIZZNP99KBQLV3GDWyPBJnFqWhRzN+7DpJHhzxkeSD9FT2qS6BcV/ufxJoB/0/aC
         9R/R729dNmLgs4Kd6QIxZ/gX/WNOZrSusLwjrI9BChYMZMZt889nQGKZkB/xuGaBd0yd
         /DSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k9fX4QyWTzA0y00nOsSz5XPtLo1F8esV9J1yjU08QfY=;
        b=S8yI3/vs7XwOCRF+EAMkGs786FM4PLSODkxjX/tdM2u910x5rdwLqAlgmhhJsp2FSW
         ulblC+rQ1UuolwuaZ5OovNdfll3M1W1AxdyciE6TqT03rOgYQQMAqgu4vRgNBRG2ARqt
         mjrgKGu4WKIcRtI+5tLjlt0wK3I1jtgVhLO3xWRJCGA2D2Oy23Ns0ZbcPfu3TbHh//0R
         o/Orv12+LU74XkXdwgAWpQzgGxhfR5/JrZy0vMbgce3xGOf5ApD+PWkarH+/ymPy6rt5
         eoqm8HoD0+DZhIrAsATMUMZWLRblsH9uiyX48zF04gZg8feqtSnNCzJsmZWtzlTl9hjr
         WVqg==
X-Gm-Message-State: AOAM530S2jiUsTIvLk4q+R8U0ADJ/nDm12z1F0+pokOexlUM+Ye2qOzp
        zLNEjtcOEsh4BJ09tTJt2bE9RQ7IRki/yA==
X-Google-Smtp-Source: ABdhPJzBlhzBPaI09ro6oLJ3+RLEqRy8uhh05U2JjEmJD7PJDRpwvXNIX6SRGRgQrWC6u/arx2wv6Q==
X-Received: by 2002:a05:6a00:228b:b0:50d:3c82:911a with SMTP id f11-20020a056a00228b00b0050d3c82911amr5377143pfe.16.1650882687370;
        Mon, 25 Apr 2022 03:31:27 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id m4-20020a17090ab78400b001cd4989fed0sm14680828pjr.28.2022.04.25.03.31.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Apr 2022 03:31:27 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v9 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Mon, 25 Apr 2022 18:30:39 +0800
Message-Id: <1650882640-7106-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021 SoC.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
Changes in v9
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
index dd61684c2..84b17ef41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18888,6 +18888,13 @@ L:	netdev@vger.kernel.org
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

