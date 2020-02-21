Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69397168046
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgBUOcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:32:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38963 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUOcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:32:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so2123590wme.4;
        Fri, 21 Feb 2020 06:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=RSS8G86A2iOHXIt+m5SYMDSTduj+VJhaaT16v/AYbp3oc0PYHHR7O/KhHKrh/yyD2l
         IMxPtwG09XK/ateKXoQpKTjzLjgUeRYv2uugUkO2njJC2PZvzvTrj2XRXhS+JfA4yRmT
         D8TjJjSel09swB47hxOgbk7f7cyLPKPEcgYP5lppkhYRQQms71JrWfLUyiqxHpMYNedL
         ECwH7pYc14kQ6r7Zd2REhZ6eLcmMQ3W7JacPE1zJ/yVRyHJ083mhA6gqhwk6fj2m/itR
         ZsX7hTdRWwhIzU8U/phcSHdilQsqmrroddIaLwdJij4vAPvWUuOpH6g0sVPjWfELq4UV
         raww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=rQWhMBW6SqSDYhwq96YOnjr5TOsqwNYnOkxLgNtG4jhTaWd6NV6aWpVWU6QRuiaCeA
         Klomzk95JqSMPyf8rhY/GZorhn+I/L/O3JbBUmrtADDYp3+geGY/TYo7hzK5BMGog3EI
         8FFaoHCi04l+U57w02EWmw3BMv+YGx8Uh1X2bqtxMARzVGUoawUYTQ2BffuPgvxGorS6
         WsShezaPcfzuODJPxvAzfgGqlZTnh1r42ndProotL890oOSSO3Nd6AQLKskwwhaj3QRI
         vlUjCRD2858ZPJgb0SOqgdSENmxSdnVBbpgwxE+X6/twO+YpzZX3tUv43eDlkprhfOY5
         VX6Q==
X-Gm-Message-State: APjAAAWNz3/huEirgK8n2mQCLQEX2ZjnW+NVg7FPAanShALJEPed8uOH
        OeboqClw+VsPL2tFDpeQOnJ1OqWQKiY=
X-Google-Smtp-Source: APXvYqz8aEgYoUhbOHE6PpkLL/zuy243O+yjkamkO4hz8v9eZB0TUbtgcfvuxOlmM0MojBai/11wfQ==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr4381037wmj.72.1582295527411;
        Fri, 21 Feb 2020 06:32:07 -0800 (PST)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id y185sm4291290wmg.2.2020.02.21.06.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:32:06 -0800 (PST)
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
Subject: [PATCH v5 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Fri, 21 Feb 2020 15:31:51 +0100
Message-Id: <20200221143153.21186-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221143153.21186-1-ansuelsmth@gmail.com>
References: <20200221143153.21186-1-ansuelsmth@gmail.com>
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

