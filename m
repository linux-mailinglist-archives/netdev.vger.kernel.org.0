Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6A44404F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKCLGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhKCLGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 07:06:17 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6597C061714;
        Wed,  3 Nov 2021 04:03:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t7so2033774pgl.9;
        Wed, 03 Nov 2021 04:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=APVgVTA8y/qzrm/n4UzEX2UK88bXa8AMQreUZayIOLA=;
        b=Jbgs3PRq/xoD2tVj/T4azPxXYZ8MC6xCY2dJcS6xA0X0qoGmIl4aBzxIhFdkY0zZVA
         rDT3KJRf93sb7OrGh/2sbnMHZxKcP7+BDN/WHqhtg9LY1Dru8T+OGxxglziAYG7w1454
         iqcR6rksSDDUItmfl1UBDeNiOFrUpA9n2Ty1cIFlfw/YAD8sRSuW2Yq6IsD1+M6gUsBT
         2JuY2SVun2sKQ5i7FTemg+P8Nz9j/r0pb3YBMoOjD9xgWzqkPXbe8hBZ6/6JVmaEhoik
         XLrkEt2ptu37fx5R5BbXS/jqcleYM38JYptrOhVwlq/R9lYDhtpNhuKrfQteXjdaRA2C
         o+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=APVgVTA8y/qzrm/n4UzEX2UK88bXa8AMQreUZayIOLA=;
        b=2GG3Zze4/eafGX7CnscSZkuJ8+Eeqf8RmupuJhdWCRBUDgruDZIkZmc82jbEk1lEdK
         1assP+iOtLpcL4Zay4cMDd7jdXbuuraZl9PB2EWDcqmLQsh+QeaqN3YUir8lmucQO1dm
         fGq1gE4FYEspB9eMp3fmj8LumoKtmLlbU6sEg129hfwDdW9VT0vIK65C7y2oq0MQnhiQ
         eeW/OW55pDdq/PS4/Nt/flF7UuXlQmhhFYaeQigh0s+qLUigUU3yJiRcnzslPNeRvxNz
         p4Kd1z4jB8LZSL8axL6PbdAauZ37I/AeLpQibFyS4ZUeCS7KToNAoY5xP1usvSObZdxK
         BLZA==
X-Gm-Message-State: AOAM532EcdxZ34DvuAa958+jym0ZP+GhkcYUaSz8RsmjCDqcvTfuq8BN
        039HoaY+rFQ47Zind3R209Q=
X-Google-Smtp-Source: ABdhPJxha0UCiUAMGaz4+zXFUFvUf1RtpfkaXtwfZSXMKUp9xmIr9eWXXvwz6+4ehWoUPBpXsZch0A==
X-Received: by 2002:a05:6a00:1593:b0:492:67eb:355f with SMTP id u19-20020a056a00159300b0049267eb355fmr2746762pfk.32.1635937421173;
        Wed, 03 Nov 2021 04:03:41 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id qe16sm2440222pjb.5.2021.11.03.04.03.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 04:03:40 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
X-Google-Original-From: Wells Lu <wells.lu@sunplus.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
Subject: [PATCH 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Wed,  3 Nov 2021 19:02:44 +0800
Message-Id: <9b52ec8f927309d542244588bc966817ff697eba.1635936610.git.wells.lu@sunplus.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1635936610.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
In-Reply-To: <cover.1635936610.git.wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021.

Signed-off-by: Wells Lu <wells.lu@sunplus.com>
---
 .../bindings/net/sunplus,sp7021-l2sw.yaml          | 123 +++++++++++++++++++++
 MAINTAINERS                                        |   7 ++
 2 files changed, 130 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
new file mode 100644
index 0000000..1fc253d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
@@ -0,0 +1,123 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (C) Sunplus Co., Ltd. 2021
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/sunplus,sp7021-l2sw.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Sunplus SP7021 Dual Ethernet MAC Device Tree Bindings
+
+maintainers:
+  - Wells Lu <wells.lu@sunplus.com>
+
+description: |
+  Sunplus SP7021 dual 10M/100M Ethernet MAC controller with Layer 2 switch.
+  The controller can operate at either dual Ethernet MAC mode or one Ethernet
+  MAC with layer 2 switch (daisy-chain) mode.
+  The device node of Sunplus SP7021 Ethernet (L2SW) MAC controller has
+  following properties.
+
+properties:
+  compatible:
+    const: sunplus,sp7021-l2sw
+
+  reg:
+    items:
+      - description: Base address and length of the L2SW registers.
+      - description: Base address and length of the MOON5 registers.
+
+  reg-names:
+    items:
+      - const: l2sw
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
+  mode:
+    description: |
+      Set operating modes of Sunplus Dual Ethernet MAC controller.
+      Please set one of the following modes:
+        0: daisy-chain mode
+        1: dual NIC mode
+        2: daisy-chain mode but disable SA learning
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2 ]
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
+  - pinctrl-names
+  - pinctrl-0
+  - nvmem-cells
+  - nvmem-cell-names
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    l2sw: l2sw@9c108000 {
+        compatible = "sunplus,sp7021-l2sw";
+        reg = <0x9c108000 0x400>, <0x9c000280 0x80>;
+        reg-names = "l2sw", "moon5";
+        interrupt-parent = <&intc>;
+        interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clkc 0xa7>;
+        resets = <&rstc 0x97>;
+        phy-handle1 = <&eth_phy0>;
+        phy-handle2 = <&eth_phy1>;
+        pinctrl-names = "default";
+        pinctrl-0 = <&l2sw_demo_board_v3_pins>;
+        nvmem-cells = <&mac_addr0>, <&mac_addr1>;
+        nvmem-cell-names = "mac_addr0", "mac_addr1";
+        mode = < 1 >;
+    };
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index dcc1819..4669c16 100644
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
+F:	Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
+
 SUPERH
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 M:	Rich Felker <dalias@libc.org>
-- 
2.7.4

