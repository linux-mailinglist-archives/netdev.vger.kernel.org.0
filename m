Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF0A167E9A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgBUN3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:29:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39533 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgBUN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 08:29:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so2077107wrt.6;
        Fri, 21 Feb 2020 05:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=dktp3WIZYxljosWl/N7+aNj0PVy8ipvMQAriSCCnpFrElA4gwCfPQxZGp+21YScCEx
         xlqCE84EJKbJcc/r+yFzKP2ZoXHa8iTQ8AMGo9TxolR8njR+cWtvH2U14R+epE2bOo8D
         gZtc/2xYWjXH7eUo/IRk6XcwLycWoVE9fA10JliR9278tEkVRMcK6kn5cUD81rE3bi3h
         PJTywOJes8pKwfndZflffgyzBnHH+6eQKKZUm5+hWLqYDtw3OjvLlupOtfBou0THOSP4
         IUvRM8iF0mhO/STzV90f50nESnOM0dzIuGh/TGEh3WnSmmqRGh9aBig4r5Yv2ABluun/
         ojKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=F1aW9e4isABiXzlVZGl8ee1zJGBe0DepWNlpfU7LjM/zrSopT1AmncvBsnrKNyI7Lu
         gdtuDrx48mmCK83N6BuHOtqMlLGoBaGJZdodgZlOpd96ubuCCPZ7UkMLmCABjpgjjD7m
         KI49DqxV7YR0JBLx8hFjApWP4CB45te6LEseHbkTkpaQZLKBHmc6apagqRvD56GEAu0u
         cCP0fCSmT3waLPA2pZYXKDQ52ZN2iH85bUUHUW6iai7gr2ubL7wv3LKXKzyGBETJU+OT
         TrInT0lm581lExE56QyWbh1pIOkNj9ttchf/D0ufD+zi1PFI3g9EATWamzdSmOileZ1Y
         qIYg==
X-Gm-Message-State: APjAAAUaKTblzRcFk5FdAZDZx4nokrXdADtiyhm4wPK3d0UA7paGdOBN
        ViGVfSecZd/EWPDdEKBqnGc=
X-Google-Smtp-Source: APXvYqz68j2XrpShir0+OUe+uyLOCXmz4RlALj+fnMj6xsUiTLw8BzSmMUr34KGBTqAqNt0uxpRxIg==
X-Received: by 2002:adf:f586:: with SMTP id f6mr46834031wro.46.1582291774763;
        Fri, 21 Feb 2020 05:29:34 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id h5sm4172178wmf.8.2020.02.21.05.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:29:34 -0800 (PST)
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
Subject: [PATCH v4 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Fri, 21 Feb 2020 14:28:32 +0100
Message-Id: <20200221132834.20719-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221132834.20719-1-ansuelsmth@gmail.com>
References: <20200221132834.20719-1-ansuelsmth@gmail.com>
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

