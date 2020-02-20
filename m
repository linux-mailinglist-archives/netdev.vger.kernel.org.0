Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E595D166AF0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgBTX0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:26:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53341 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTX0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:26:45 -0500
Received: by mail-wm1-f68.google.com with SMTP id s10so327501wmh.3;
        Thu, 20 Feb 2020 15:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=czR69GA98BlVaV3juXRVfrOeKxTGVbSXZcDUM28FnLGX4nb01iuDNDo1u2qZHzinxf
         SRVHZd0ei9hcHWUlDbKF+atVq2Leusd7wwVTYbgFF9ZpMABfGtwAljGANnngwdw7aPTP
         +n/Mkya5XvlyAkwz5Xo+9+Rx2hI3aglGHNMQXN7Fg6p4e5h9mpL8aBYrodr971FY6jx7
         riiOzir04sedguPOo1WT+prKVxHzUX6idHYh9llE/RkyOTXZFxFTospdvIg5ddZa8ZG+
         KjWRD8Fxq0WOEN5Soz5G5rJ9jC1fSKTqEaV3EB0cC3pVF0I3wChYG5LNb1Sy4fZkfQES
         vhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=bOp7LDNTNA0j+kI5xY5/L0W2DZWS4Csl1ut6UCZhimrlyYLWhG4+MjhKrDhPiXSIbE
         B8KfXszMYqGa+nyJn70cTypKxN1TnUTU3A4p5QfzEu9laEUbQIMduSVLRFHNUUhYMqCz
         6VlpQgJpdbeEqpZnQX6CAyVt5gqRk/f4zb0kDJf/o3uocmSy748VehzJtRDoRFoiwmt/
         P+PjZowqM/OgSIkga7AGi+KmnU8uznDoC/ZTpRhIq5hjxOaorQH67Gj1xNTak5iKzS2P
         ZoWX/FE78HdOoc3eP9vfK00ntog17VE8g1tRKWkrQbIYEpEWKVA5EgMUtMaopo8A4M0U
         tWcA==
X-Gm-Message-State: APjAAAWtMgj96aQ1pUK60bcLbrO9S8UOhu+eMT3T9B3dqtMDOYL2Nzuv
        DPOxFgrl0Q57Zp9f/HgFe9E=
X-Google-Smtp-Source: APXvYqxK/aZGgmxmFiI9rohUoesB3MtDvIMAtuCgsHCBck2HW7UwTRhRDI9d1Dx0mKQo2ioQ5OQFjw==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr6963218wmj.33.1582241202986;
        Thu, 20 Feb 2020 15:26:42 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id h18sm1498064wrv.78.2020.02.20.15.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 15:26:42 -0800 (PST)
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
Subject: [PATCH v3 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Fri, 21 Feb 2020 00:26:22 +0100
Message-Id: <20200220232624.7001-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220232624.7001-1-ansuelsmth@gmail.com>
References: <20200220232624.7001-1-ansuelsmth@gmail.com>
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
 .../bindings/net/qcom,ipq8064-mdio.yaml       | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
new file mode 100644
index 000000000000..d2254a5ff2ad
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
+            ...
+        }
+    };
-- 
2.25.0

