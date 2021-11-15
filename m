Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AC745164C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348870AbhKOVTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244885AbhKOU4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:56:45 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF22C04319F
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w29so33113227wra.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oXD373T9aSkiJb8JUH3unNEp2ZqiLUDsZE8U/4qlrOo=;
        b=VCIerusgiCywGVY2xSLNxW18f9EWWjR3mLBntTaS2NAyul8hLCMzgaZdIS1c0i+dss
         vupw5tr9XOjuxufK1jFI5K5KCo0/T0jXIzddTAtgQ75pzLqmw2lymLpTuQtOQQBSSLLT
         ekioUSCGTyBYDKEV7whLEOerVaK5bqty2HAz+QjCV+2qHICWDcl4SKsfW1Qpr0qGuITu
         JkB2WcPoLw7sfzOlydm3e7hpqZ6XjRLsbOLhblKWZOavbr68MT6BwaCpt6X8c8V905wG
         6QM6X3M1o3ybBDPZQktoLtbkAAAzwcUphT6ELFYxXYXJ5+mJWJJ7rtr1PGKhBcq4mfm1
         pnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oXD373T9aSkiJb8JUH3unNEp2ZqiLUDsZE8U/4qlrOo=;
        b=S4buZ7z6wyLP/Emf0WVzLRGPVY6EWFjhij3isFyI512SQ/AARFWTWDTU8ww3I7krei
         lJeLYhsb5KhJ7/0CjO1o8vjTspegDhkGwd4twT+0Qv0HqFh1N6rfe43+PqQqaf6a8DnV
         g9bhrY1j3R/CrH9Fl8UsbhXXSUxlal7uEib4TGpomBoCIc5vgQEOf58NW6SpBRH+x8nK
         OqKLgNO0LsBp+p6OViI2VKjsFPVLF6ZhPMT0VbQugTtukiW6ATJh5Jn7P/fCk0JYoX9I
         GmoPp3z9FMndXuYf3drlILHfVPPlS+1m3a69u7AAYJ1KdYF59+u1uznOt1HkEscyZL/q
         W2yw==
X-Gm-Message-State: AOAM530FNVxJ6izB8Nf3qwzhOih4QJrUHoaM1E6AiJ+1cZ2n4lVUtDEL
        IazC6EiApucdoc1o9UbkAgyU0g==
X-Google-Smtp-Source: ABdhPJy61ifbQknqfiURzUi/ZSGeC6evF83ww+I0PHxIVmLIAlwCJmH9QLKqsy63uIei61wV3TxN/w==
X-Received: by 2002:a5d:400e:: with SMTP id n14mr2393494wrp.368.1637009426812;
        Mon, 15 Nov 2021 12:50:26 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z6sm15763704wrm.93.2021.11.15.12.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:50:26 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v5 2/3] dt-bindings: net: Add tsnep Ethernet controller
Date:   Mon, 15 Nov 2021 21:50:04 +0100
Message-Id: <20211115205005.6132-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211115205005.6132-1-gerhard@engleder-embedded.com>
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC is a FPGA based network device for
real-time communication.

It is integrated as normal Ethernet controller with
ethernet-controller.yaml and mdio.yaml.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/engleder,tsnep.yaml          | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
new file mode 100644
index 000000000000..d0e1476e15b5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/engleder,tsnep.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: TSN endpoint Ethernet MAC binding
+
+maintainers:
+  - Gerhard Engleder <gerhard@engleder-embedded.com>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: engleder,tsnep
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+  nvmem-cells: true
+
+  nvmem-cells-names: true
+
+  phy-connection-type:
+    enum:
+      - mii
+      - gmii
+      - rgmii
+      - rgmii-id
+
+  phy-mode: true
+
+  phy-handle: true
+
+  mdio:
+    type: object
+    $ref: "mdio.yaml#"
+    description: optional node for embedded MDIO controller
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    axi {
+        #address-cells = <2>;
+        #size-cells = <2>;
+        tnsep0: ethernet@a0000000 {
+            compatible = "engleder,tsnep";
+            reg = <0x0 0xa0000000 0x0 0x10000>;
+            interrupts = <0 89 1>;
+            interrupt-parent = <&gic>;
+            local-mac-address = [00 00 00 00 00 00];
+            phy-mode = "rgmii";
+            phy-handle = <&phy0>;
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                suppress-preamble;
+                phy0: ethernet-phy@1 {
+                    reg = <1>;
+                    rxc-skew-ps = <1080>;
+                };
+            };
+        };
+    };
-- 
2.20.1

