Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0C916B1CC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBXVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:10:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38255 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgBXVKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:10:46 -0500
Received: by mail-wm1-f68.google.com with SMTP id a9so853098wmj.3;
        Mon, 24 Feb 2020 13:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6yWM1dVY3KXj+nN/ReZRFLyP/i4t8gAHjBcXNGyYMFQ=;
        b=mEQqfu/sa9O0wq9FoZjyB9hUTWBa49Do30CEHoosU8I3drOeyns0gC/iuheDQyubhm
         OCXQE1qe58xL9PnsLfZizKbQTBlmKJ/l1QCnoY2mfh/jp1+q1yDELzhrbKHUsgt0Lk7K
         GldgrHtK+7B4E+tmjmJexuQkBHi2+zfJrD9rv9kQQMTJ/2zX+uNqRCvWmRK6ttUMge1/
         dXw7z78dorngi9f4d6Jh4a7/WP8EEeg12oTS04V5Vi5NnkDP6s+9pYPrkdQ0AnqmSO+5
         o9X2tvRJX0BnfdaoiPMOjLgp0NRIpowhse0FOEZE0w5owUentgkd03jn41a80cUR3/wf
         RCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yWM1dVY3KXj+nN/ReZRFLyP/i4t8gAHjBcXNGyYMFQ=;
        b=YNRHL2qps+WJDv4pKxNdCtyfRueL9W7q7W3Ejh2qi5MAQC//qnqNp8LdJ2SMNDUbX2
         Dw+iHXDFctkwhzouwSRFhX+tHUkZgeOiMWSLWVMIJsjjkyi6/V8I/J9ZfTxeJajfTcUV
         6WXWMJldqhDoi5SX0IVVaFxBWM73cuy8If/c0mscQMCEqVewMQbbJ4r8zVlfE+2kZtSk
         RBllxOJfoV7zxpnUsQRDtC8+Pjk/cewfzR5O0C5aqYVw8zVsI1m5BAiZYt4eU3TDKXOH
         Lp+CbbNz4zGALXX/DGyu5KSoVcYgtp9O9MFAV5R1J3AUoVJ+C8gM2DIoYw8Irma9S0LX
         QJ3w==
X-Gm-Message-State: APjAAAW7UZXVd0g8BYl0+pGIh/RlfhWiv4FGQD8jtav0xLat7YKtuI8l
        AcJCpDB/jWFz35ig0BQo9Xs=
X-Google-Smtp-Source: APXvYqz9cj0t68TUy8GusArQPezxkC+gx4AYZMHTOs3PD80Kjlhjopv9YCUoeEh7xdXJ1rKrFGO04Q==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr938547wmo.13.1582578642434;
        Mon, 24 Feb 2020 13:10:42 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id i204sm917780wma.44.2020.02.24.13.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:10:41 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Mon, 24 Feb 2020 22:10:31 +0100
Message-Id: <20200224211035.16897-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224211035.16897-1-ansuelsmth@gmail.com>
References: <20200224211035.16897-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentations for ipq806x mdio driver.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
Changes in v7:
- Fix dt_binding_check problem

 .../bindings/net/qcom,ipq8064-mdio.yaml       | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
new file mode 100644
index 000000000000..3178cbfdc661
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipq8064-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm ipq806x MDIO bus controller
+
+maintainers:
+  - Ansuel Smith <ansuelsmth@gmail.com>
+
+description: |+
+  The ipq806x soc have a MDIO dedicated controller that is
+  used to comunicate with the gmac phy conntected.
+  Child nodes of this MDIO bus controller node are standard
+  Ethernet PHY device nodes as described in
+  Documentation/devicetree/bindings/net/phy.txt
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: qcom,ipq8064-mdio
+  reg:
+    maxItems: 1
+    description: address and length of the register set for the device
+  clocks:
+    maxItems: 1
+    description: A reference to the clock supplying the MDIO bus controller
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - "#address-cells"
+  - "#size-cells"
+
+examples:
+  - |
+    mdio0: mdio@37000000 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        compatible = "qcom,ipq8064-mdio", "syscon";
+        reg = <0x37000000 0x200000>;
+        resets = <&gcc GMAC_CORE1_RESET>;
+        reset-names = "stmmaceth";
+        clocks = <&gcc GMAC_CORE1_CLK>;
+
+        switch@10 {
+            compatible = "qca,qca8337";
+            /* ... */
+        };
+    };
-- 
2.25.0

