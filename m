Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6513A170DAC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 02:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgB0BL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 20:11:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45619 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgB0BLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 20:11:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id v2so1192001wrp.12;
        Wed, 26 Feb 2020 17:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzgdFgLuQOadevD6Aw1QpIMN0fIJzcJjXFyaCoLmJcc=;
        b=OwB6BiAV2GdBT/WXCl4520WnbcAdznT14AVzOwbft5bVXiD7WWetXJUAEWEpSzse6y
         X6ns9VsNgSnZQuuA1ac1GzDERwbHs9FN2us/wWS1OJimCPj3uASNczRzvgdsvCBZXy0l
         1M3BNyNP4SHe877nC17i8RY2sIiaAzvZvTN8jS92hGkAf55y6Z5DXxnnmLbdwhM0ABj3
         AJyWJEcc3i9rZ/0Zpj3FnfDQuEHZ/wtJUK8ob1/kv9Tad2FCkYsuf87q3AGvns8FnMmO
         G+ZUTYpFAtRX+EKdQkj7LpzvIZtxnh1k52Q+XCkwDXqMcr7CfVmDdFV5Lw/g0PPd2hIL
         hGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzgdFgLuQOadevD6Aw1QpIMN0fIJzcJjXFyaCoLmJcc=;
        b=toUAuxvQ+9WUSPqkgjDd0uVaFLQN2ogi6+brfzHKnLkHlaHgC0soy94tB4lMZwJvVO
         +eJVid182++4QJEXXDd+16F4BLf6yXyo5fBJB3R2ywZpru1ViVPC03YbS6SZBje7gzgJ
         5pILmvZRxsKZcO+Y0DPCmu9X/3fF+D4/dE+4vK0FySe/sLgJLWRSax8x/jbB4zuBBPm1
         TuOmwX3HttS1HYeqR60XCLIoRU1EKlrioLedGevGsUy8hWs7r0+faduKjSNTKJT2RbIF
         61Vzhlf9lfl+1y17JS0izquKBD9tNDRBfmBAbD/mnHkLbyNiiRZP8aQZyUKoVqPdmnMx
         gyCg==
X-Gm-Message-State: APjAAAWo+rhubucLpWvBgOlOcCmxvmx9//+PktFmcIEljw0d4DaKCEVv
        yWS5hGN6nRm85DxS4EvD+WQ=
X-Google-Smtp-Source: APXvYqyeQIE+iTbx5WBdhTGlmrBrs5dtfiRn1XLOI3uo8Lm7ZyvsDRugxbZelBkngIvvIuA16qQS8w==
X-Received: by 2002:a5d:504e:: with SMTP id h14mr1459288wrt.82.1582765883170;
        Wed, 26 Feb 2020 17:11:23 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id s5sm3509507wru.39.2020.02.26.17.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 17:11:22 -0800 (PST)
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
Subject: [PATCH v8 2/2] dt-bindings: net: Add ipq806x mdio bindings
Date:   Thu, 27 Feb 2020 02:10:46 +0100
Message-Id: <20200227011050.11106-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200227011050.11106-1-ansuelsmth@gmail.com>
References: <andrew@lunn.ch>
 <20200227011050.11106-1-ansuelsmth@gmail.com>
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
Changes in v8:
- Fix error in dtb check
- Remove not needed reset definition from example
- Add include header for ipq806x clocks
- Fix wrong License type

Changes in v7:
- Fix dt_binding_check problem

 .../bindings/net/qcom,ipq8064-mdio.yaml       | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
new file mode 100644
index 000000000000..4334a415f23c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0-only
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
+    items:
+        - const: qcom,ipq8064-mdio
+        - const: syscon
+
+  reg:
+    description: address and length of the register set for the device
+
+  clocks:
+    description: A reference to the clock supplying the MDIO bus controller
+
+  clock-names:
+    const: master
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
+        compatible = "qcom,ipq8064-mdio", "syscon";
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

