Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BF02BB24C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgKTSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgKTSRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:17:16 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC77C0613CF;
        Fri, 20 Nov 2020 10:17:14 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id k3so9555843otp.12;
        Fri, 20 Nov 2020 10:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IG8a1wcvQRIuVGB2tymyXaHF14EUUJsPSrTKn76mO20=;
        b=VWVaxReWxeR8WtwlTfUeEJGEdBo9n+q4nZlS7KBlGGnmMdqCB/2w5v9ew4nOZQ+EHM
         Ba5jY7HwOe8vN/BecXEYxkQSEw0CrNLnHVCbeKZFrj2YnCd6bSNRHFqHZLYnJJM6lpKG
         UnHPdll14wrSnrhXmEoWY3y0DLa+CBeaX00L1oBXZKo3vLkCKAkg+lGlzm6wxvkvqqim
         Byc0H7hXFlXI1JfL1gIvr6KP4f1MHXm6CuCqaZt3bCMxDfk/zsIgkT+F8JZocjarnkU7
         WVZiB8ukLl8e0yNbrW9KUbFEU8q4tI+u3+aGf6gtHzHb9om/a5XxOFA5/R0uqtaohjBA
         xrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IG8a1wcvQRIuVGB2tymyXaHF14EUUJsPSrTKn76mO20=;
        b=Z2QHzXcP3srxty51vJ0CIBgNwc0OdFQf9U9oT6I5s0QAIGWGGoCbcwVKMUy01j1X/n
         yyKdWbLexCpF3cb22/VNLRURzkTt0gSsWwWedjBNy6/A02BrqYFraw6FATYH56Wc/dhD
         JYmBqmRACzCi9LaYD/csLRdbwWZp1A3BHufuoYXM6nqDYsggLiS/xXJeObwzm2O3d+Mv
         +tXbIsKhUJIp3OcksgoXdmMNFUCbwrK90wa7b3OwOxUUMlfj0xedXnUuq46bXPtLdUBA
         X5Vazd/NsZLUX2WvH27DuE+n/pgcJe7TYXiAyrvcDvTUXR4q8K6jB14u3Y3McP7i5KmI
         gQSQ==
X-Gm-Message-State: AOAM5337oDmtAWk1ZaqDcRbOX/RuSe6F1Ic2EXjJlUK338fjfVCfUrlI
        lQLaRixQIiUeahExsDUEoA==
X-Google-Smtp-Source: ABdhPJxDh0Rwf0gdctdiVP0Z9pGaT0AgSej2apkYSBvfEUcu3PL7yG8UqYShC5LTI3nnQ1l4AeHr/g==
X-Received: by 2002:a9d:6d05:: with SMTP id o5mr211431otp.158.1605896234154;
        Fri, 20 Nov 2020 10:17:14 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y35sm1764420otb.5.2020.11.20.10.17.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2020 10:17:13 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 3/3] dt-bindings: net: dsa: add bindings for xrs700x switches
Date:   Fri, 20 Nov 2020 12:16:27 -0600
Message-Id: <20201120181627.21382-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201120181627.21382-1-george.mccollister@gmail.com>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation and an example for Arrow SpeedChips XRS7000 Series
single chip Ethernet switches.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 72 ++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
new file mode 100644
index 000000000000..92a350e8e0d4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -0,0 +1,72 @@
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
+          - arrow,xrs7003
+          - arrow,xrs7004
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
+            compatible = "arrow,xrs7004";
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

