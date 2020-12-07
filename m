Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C163D2D1CBE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgLGWFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgLGWFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 17:05:32 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3947FC0617B0;
        Mon,  7 Dec 2020 14:04:52 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id k2so17189186oic.13;
        Mon, 07 Dec 2020 14:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+3bDMjvm5dK7UwQf2LVfrsERHvL5oyQX0YHBm6EFCGc=;
        b=edHolrFxAnvMRNqBNdF+fOpnmyceEy0z4lfkl8rLtPQo3Ez6aInMUCS4+UPSY/gl+Y
         uEUm3GARfJGXGhkv2q+P81ZnCEDwLy3AjSwgGVMErF6Zbbsf1fm2AmYXnOnMtqNPOXS6
         3NRlO+FrZcopcju7/eI8NNVJ/vM80utARxiE3QLD5qMSpFRtQCM43jlaC4AQfXZdL6A5
         iXQLnNcmdJ32/UtUKJ6menWelACB/wjyiHT4Kft0pAf6b2+OBpR53Ry1JOXGnaQu0Dw7
         Y4LIebPdfrjIwJvMWq46JOYtxKxqRGlixYuBDO36usMAvQzSz376kYAEjrHL+W0tOdbB
         Cydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+3bDMjvm5dK7UwQf2LVfrsERHvL5oyQX0YHBm6EFCGc=;
        b=WGBHNO4xZAABB3BbYUOTjWkcoZopmIrxVcsKoHzf7i++BWcCI1efA/DSEp5itcKlBF
         RRqFh0vAGzHfWlIhhwGKZL+Oe6VZisW3NVS5lwMBeTpukCrOugWiyAEWq8zDZnwSyhAu
         8gG52txKPGOG46ayaipZQC8JTLStHE7Zc4U33H6Q5ZzU0MiqHCYpaqWfE69TdItAvUGU
         s2z67PZ7f52zm6xwJuWB82m5hSqb8t5jFMBBlHLCUZo3UrWev7+d5kLVenL6MFNTYohT
         AHDoa8pNHBSBrOwQc4lLxmRlvuGKu9+e09fVDibpZm+V9IOPYTua+bYUE++lB3rMV7uy
         xGGg==
X-Gm-Message-State: AOAM531jHCqbA4FAl+hOfgR4Xk0YhUnuNGrHvzJJ2IJuzlyN5eXiyTej
        y4lL1nUAXBy9yovugPUJPw==
X-Google-Smtp-Source: ABdhPJwIrcY9ukHPrJ3KopypVMUscKSaJdnUR/Hr/x0hKKdGJaYYNI19O/LfmgrQMLkbJAeh+nA2FQ==
X-Received: by 2002:aca:ea87:: with SMTP id i129mr707960oih.166.1607378691632;
        Mon, 07 Dec 2020 14:04:51 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id g5sm2940472otq.43.2020.12.07.14.04.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2020 14:04:50 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v3 3/3] dt-bindings: net: dsa: add bindings for xrs700x switches
Date:   Mon,  7 Dec 2020 16:03:55 -0600
Message-Id: <20201207220355.8707-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201207220355.8707-1-george.mccollister@gmail.com>
References: <20201207220355.8707-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation and an example for Arrow SpeedChips XRS7000 Series
single chip Ethernet switches.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
new file mode 100644
index 000000000000..05ed36ce02ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -0,0 +1,74 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/arrow,xrs700x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - George McCollister <george.mccollister@gmail.com>
+
+description:
+  The Arrow SpeedChips XRS7000 Series of single chip gigabit Ethernet switches
+  are designed for critical networking applications. They have up to three
+  RGMII ports and one RMII port and are managed via i2c or mdio.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - arrow,xrs7003e
+          - arrow,xrs7003f
+          - arrow,xrs7004e
+          - arrow,xrs7004f
+
+  reg:
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
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        switch@8 {
+            compatible = "arrow,xrs7004e";
+            reg = <0x8>;
+
+            status = "okay";
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                port@1 {
+                    reg = <1>;
+                    label = "lan0";
+                    phy-handle = <&swphy0>;
+                    phy-mode = "rgmii-id";
+                };
+                port@2 {
+                    reg = <2>;
+                    label = "lan1";
+                    phy-handle = <&swphy1>;
+                    phy-mode = "rgmii-id";
+                };
+                port@3 {
+                    reg = <3>;
+                    label = "cpu";
+                    ethernet = <&fec1>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
-- 
2.11.0

