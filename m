Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217222C4890
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgKYTiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgKYTiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:38:21 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4106FC0617A7;
        Wed, 25 Nov 2020 11:38:21 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id n11so3325949ota.2;
        Wed, 25 Nov 2020 11:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yB2v8jEthaUaz8LqrjGQD32i2xtWphXh9h6+6P8RP8Y=;
        b=BFz23Zbi5xKyeHIUo4dl7hkbnk/xAqVW1RHeusQCGhf9h7uCOO0jrP2TtHc6J4pgby
         zgFIXbHLXLdBUPWNjnD8a/eE2pRvPFEO2GCHWZ272QfQN0EWDzlXJkVIqz9TIrwC+z7K
         0dSZPP/Q3N3Uv8RONfH51JK2aPN3OcCyZgUUe61Mpv/elXnOVYrCD2aOaUZ1gnhJY0DO
         AiGjUBwTs8jNQ3lZ3cNIRcD9G6vUBSGWG2yxyC6X1IGiuP2Exqogqo0P1Q03GKJDh/iP
         j9S43ASVo3N5AM2BXRIXDvqEGiYzm9uXUYYNaevg2bHmn6iqRArHgNQwV426rz/3tbgE
         w+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yB2v8jEthaUaz8LqrjGQD32i2xtWphXh9h6+6P8RP8Y=;
        b=n2Bphh6vhxI8eqf29uPG2W5J1TeyaqQxJ2Tr/vSpD370ia0dp8hm0pDJt9jbXU7Jyv
         bebE+Ip6TC0w7chQxonJy7J9PomIofrBn0a2KeOrglxYzXULokkwUFK3kMqUE4iQ4GFd
         Kn8AVQ+l9f+Kvxg4bONG47KmUuH4FwR68GRWtLmIo2KiymSJMkgzabLHvlIOwIqtiUFK
         gQZCvtvbLbu5bRJjAiCatQcFPvk/qjBOwLDfXchQnM+CU4ZdVZZUwC7MJIUfFmpMLhz1
         aOvCwnvb0ehJX8G8Sjvudvan8cw7S9hS8Aukop47ZKIWjnCix9h3f/5X9ScX5HFqD31Q
         aR+w==
X-Gm-Message-State: AOAM533jBrX0+r2g7x6fVSoj9jo5Bb4awmtre0ywgYQXs1Zho+RBFvyc
        TSkATAFiSiyXiZJyghwWRQ==
X-Google-Smtp-Source: ABdhPJxnjPG2Tq8SJdxdg+o0lHAIjJc6JayQQ15Dw4mc3ZabCSs9Yw1Xs6y8c3QFxcMWb96mMUGKhA==
X-Received: by 2002:a9d:1f5:: with SMTP id e108mr4043482ote.309.1606333100651;
        Wed, 25 Nov 2020 11:38:20 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id m109sm1655753otc.30.2020.11.25.11.38.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Nov 2020 11:38:18 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 3/3] dt-bindings: net: dsa: add bindings for xrs700x switches
Date:   Wed, 25 Nov 2020 13:37:40 -0600
Message-Id: <20201125193740.36825-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201125193740.36825-1-george.mccollister@gmail.com>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation and an example for Arrow SpeedChips XRS7000 Series
single chip Ethernet switches.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
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

