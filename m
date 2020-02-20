Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDE91663F5
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgBTRHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:07:48 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37987 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgBTRHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:07:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id a9so2881449wmj.3;
        Thu, 20 Feb 2020 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37niT//lDaILKiAgLmVPycHnKOoR/1yOuQ3A2inzDzc=;
        b=QEux0/eakJEJPRRBSy1DQ6l5a06ZagxVBvGVuOCMSFWIsHeD2cwNQoGNgd9VlMx6op
         zcAqKt4+NATcE1Hv2LynemAgW2pR/xcddfiX1iktQDIfEPXfXnp1NA0M597F0YSqwvx1
         MYcBz/H7zS1i6a142ioxHZXZHHbTteEe5Rn3j2NCCML7NjCpr5MOZ6/ZeJo4/m2CzDzR
         GS+qD7c8szn3Cd/+vDole5anHZrN5DFkK+fZtI4m/08LkJP4NQv7aUT1BxFFSBZbq1TO
         /WaI4O1m2w98WleIHpxsPKarvZhlR1b0exnc1NTzmOo7wHy5spZMS49Vc8sj+VeprJwy
         vfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37niT//lDaILKiAgLmVPycHnKOoR/1yOuQ3A2inzDzc=;
        b=Hkqf20WOC2lfV4sdhDtlL6jT2jvlSmydpNCCY/5NQNcik6m5qtkpn8cvZHyiHAZaEr
         /i/20eEiTZroGrVq6wHPGsjoAiJsbc3kKHPl/JY9BoGWULpwijkZhuvOgo9m7XRXXnMc
         QOgHoyHV04UEydqrUpzrZOKDHPPlaG8crTVJSKqGIu39BbuFKbU4IlyAqS2Dt71pp7J8
         LBVsfAjTdQk3NZ8/QAZhIUN0hUVLxtdUJhl5APq8dFIfcqY4P3HUssrjMe+duySORADa
         WGQcqON+OP7oCF5CsUfWv2DVsMyozOMeiga84xhl9Zcf/MLIg0ZxZqGBlF27WTcBPXn9
         3viQ==
X-Gm-Message-State: APjAAAVW1ixWG8SvGHawDwYu9tdEfFlmCNNhqiXEp72FXaNoQLudPaFV
        bSZ76f38/TvnZ2dPJSKXeek=
X-Google-Smtp-Source: APXvYqwR7P069VhMerWiRTx40KIARgMf/C2Ty0f48VwkRBQcE79u5/YkJkbiR2A7GlGkhkjAqT+wAQ==
X-Received: by 2002:a1c:cc11:: with SMTP id h17mr5446322wmb.19.1582218465545;
        Thu, 20 Feb 2020 09:07:45 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id o77sm5817883wme.34.2020.02.20.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 09:07:45 -0800 (PST)
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
Subject: [PATCH v2 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Thu, 20 Feb 2020 18:07:29 +0100
Message-Id: <20200220170732.12741-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220170732.12741-1-ansuelsmth@gmail.com>
References: <20200220170732.12741-1-ansuelsmth@gmail.com>
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

