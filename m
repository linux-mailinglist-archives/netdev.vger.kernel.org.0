Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0E179B1B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388435AbgCDVjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:39:18 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45360 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729836AbgCDVjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:39:17 -0500
Received: by mail-wr1-f66.google.com with SMTP id v2so4347294wrp.12;
        Wed, 04 Mar 2020 13:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x01+jNJEiuD2hhZQCzQh9Zg3CojuPoTE1hhCHqpd4aE=;
        b=Siil2aZbW14lFtKkB7GPNGQad7mIYTZPOGnv68/j1tvjDpX7nGYcTPt1qq0nZpadb+
         LIvWG2xXhXe2RMEv7c9iXnQWbOsv4NovvDxnUpokNjbAcVYQuAE22+JzpUNg7qhqfDqM
         knLWWqD/aSpomxEqFJ7XMmQC0UTi4qmCGotpp5URAzRE8jlfsGAaApWfkUIJ71uyQ/G4
         Wwlzm71+n9zpiH8GESni3ZHAr8w8izHSFFva4Z79xdkpvY4Kq4R5f9ZTBq9v7EgLSMvt
         3tcahs0Zc303DK4LgKOpy/3fsiifAKsktRiQdL24/RIMg2EgyxOZc5+G21RqFCbaXQhz
         v6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x01+jNJEiuD2hhZQCzQh9Zg3CojuPoTE1hhCHqpd4aE=;
        b=qjo/KVeBcse6lJlmD3wRCAQRaiw9IkkUUa0sTKYvUYVo0deEoeG0zj4kTaSwwWCVo3
         GsFCyjZ8nJbe2TJwkWbDhbUUyMDRobAUz59y1pBNKoE4JA1N5K0L6+5FO1Ne1ufs59NF
         zoctx9TVUfaoOGcdSyi1vtQZ5BdXdOpV4L9m4lhFP0s2kwHxNY7H2rYM/9biliWw8f83
         HuSlbBmldRiXZIAbnLr0cVUFkcI5QYH/1Ghl0cjChTtsaP5e0ZChAsz169f2loY2YOhA
         j12qxbIumoMI/t7o2WiExIv7wAGjZJYr8xmG/w++2D78Gev3q9z1U7fY8LPj768+e+Xh
         AI3w==
X-Gm-Message-State: ANhLgQ1LH5dlWels3HnhtF52wMQQ77wB8owVLS4Lj3hEFfv4e7xhwWLS
        jZs4GynWfJ322snHl2Pxvp4=
X-Google-Smtp-Source: ADFU+vtr7R55d/OTUmy++pVkOXkuiWSa2SqC3eh58CN0Gowo8QkOPPm0/u4GVx0xPLcgB2UVF+TUPA==
X-Received: by 2002:a05:6000:1042:: with SMTP id c2mr6274571wrx.360.1583357953594;
        Wed, 04 Mar 2020 13:39:13 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id e8sm42453280wrr.69.2020.03.04.13.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 13:39:12 -0800 (PST)
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
Subject: [PATCH v9 2/2] dt-bindings: net: Add ipq806x mdio bindings
Date:   Wed,  4 Mar 2020 22:38:33 +0100
Message-Id: <20200304213841.5745-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200304213841.5745-1-ansuelsmth@gmail.com>
References: <robh@kernel.org>
 <20200304213841.5745-1-ansuelsmth@gmail.com>
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
Changes in v9:
- Update License
- Drop syscon

Changes in v8:
- Fix error in dtb check
- Remove not needed reset definition from example
- Add include header for ipq806x clocks
- Fix wrong License type

Changes in v7:
- Fix dt_binding_check problem

 .../bindings/net/qcom,ipq8064-mdio.yaml       | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
new file mode 100644
index 000000000000..b9f90081046f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
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
+description:
+  The ipq806x soc have a MDIO dedicated controller that is
+  used to communicate with the gmac phy connected.
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: qcom,ipq8064-mdio
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
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
+    #include <dt-bindings/clock/qcom,gcc-ipq806x.h>
+
+    mdio0: mdio@37000000 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        compatible = "qcom,ipq8064-mdio";
+        reg = <0x37000000 0x200000>;
+
+        clocks = <&gcc GMAC_CORE1_CLK>;
+
+        switch@10 {
+            compatible = "qca,qca8337";
+            /* ... */
+        };
+    };
-- 
2.25.0

