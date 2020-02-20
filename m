Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBF1660A4
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgBTPNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:13:32 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42412 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbgBTPNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:13:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id k11so5004518wrd.9;
        Thu, 20 Feb 2020 07:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37niT//lDaILKiAgLmVPycHnKOoR/1yOuQ3A2inzDzc=;
        b=eH/leP5NlYA5Itg6BI0WErCodKroiFgEuGBBLA2wHlD4l7UaHQ6dKg4XgBRkN77CCD
         n3Csjk8ofEc79L3wtX6H5AF7WUZB5z7b5HT7EKlIqElxEz8F5IRf+GIYjuCionyT5TDa
         TtdYpW5fvQm6Z606gfuGZGyMlBDEWlfuOcXhdkmaUZ8o0UdNp5Z3LM+U9+UcAOnTulGa
         NVQxIvTUEgZ7p+ID1GFprx4Y0guB3LZ608HUTNUz/5AwYUTY38Cpqf16KNMr+anVKyS8
         7L+LSf1RCm6f/Yen7ME4kkvN5V7HBU5IRJzf/R3xnfNXoXGqNYGW5cIQu6aUIVEJK3OZ
         sh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37niT//lDaILKiAgLmVPycHnKOoR/1yOuQ3A2inzDzc=;
        b=Q/p2LunmHUojN8MemZwh7H0ANcsRBNrS5MI8cNFWFUfdfnIfvd+chp4/Ao5k8zkBQa
         GJJkVCfhlJc1qaoOmGxWZy5Jalkk7Uybz92rN00/WcV88Fz9SN7HGLOD4adhQBdCrEtC
         W+uP7lBsOQveuyZd95PkeWQE+6TpWg8gn258z6PwAY5Yep5QpiGxlp0IhAO8lrw/bfk4
         s/Z1LjZ70J4jAPywLjVcoJGAZqvWyTnrGfVRNKeSvf1CdPvibKPPzo7wtKxzgUHSoXxL
         cq1OyzIwMRJnuWAPTgYQGlukUXpOve8CPPbAcsHb6vqujEhDJiiwVBmqE0LM2OODhsuZ
         luuA==
X-Gm-Message-State: APjAAAUIic8yTmcdVgGrNllsqmPcYPORpFPUDLDDQkdZhzE+tzLzG2dj
        PSDNUd8glAl/YUveFGm+ELeXB1aG/98=
X-Google-Smtp-Source: APXvYqwmwbRvuHx4af/oZnjAvr4YUKjXjsXo6mMq9ZViF7JNcfBWZUJACFKbtWe/mSnfEeXybGaRMw==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr41339339wru.181.1582211609872;
        Thu, 20 Feb 2020 07:13:29 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id d4sm4983642wra.14.2020.02.20.07.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 07:13:29 -0800 (PST)
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
Subject: [PATCH 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Thu, 20 Feb 2020 16:12:56 +0100
Message-Id: <20200220151301.10564-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220151301.10564-1-ansuelsmth@gmail.com>
References: <20200220151301.10564-1-ansuelsmth@gmail.com>
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
 .../bindings/net/qcom,ipq8064-mdio.yaml       | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
new file mode 100644
index 000000000000..c5a21c0b5325
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -0,0 +1,52 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ipq8064-mdio.txt
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm ipq806x MDIO bus controller
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
+    mdio@37000000 {
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
\ No newline at end of file
-- 
2.25.0

