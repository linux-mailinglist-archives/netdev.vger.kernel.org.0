Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D9816902C
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 17:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgBVQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 11:16:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38286 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgBVQQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 11:16:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id a9so5062127wmj.3;
        Sat, 22 Feb 2020 08:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=iSyv5Uf3jTCZi1qP7OEoGBdZIyralVcALePGw4cvaNP7kfkmVQGREiKmNzA7wQDrO8
         cBZ1BO/P8iec24Usy7d3kOzOBOOgKSOtpDtPs100S2W7K+sbWcsAa/SQlG/R4xFPYmpB
         4D8fCPiaD26lHJvNcl73hvZD2v/H0ke3f34x8i3X4zqHebQZQgGoq4/YpykzvYHuAVId
         mhYPJBoFPE59KXttN7/wCF2pGYrP7YuLjJcsPhDyhXFUZdH/w6wbogmYa2+8kgCidEFW
         JAqQqPNLfZXrludv7QhZSjC/V+MH7/TyQo8MtftNBITJbP1dV94DuvrnejW+pDOSkqJf
         uFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGlgDo9M9XGHB0o0rwRFWRiv//bvSK3bYB5+0sd515M=;
        b=oXkLJfrjxh6KcgjqE8NlNTFgeyK23R5yUxzen/Rru7ewXyFWZ2anPWRvxRoLuSBHk+
         M6hxDSz3iIphIAli4obZUZMOzeVkjPIVMLE6BxZ9O8/SE8XUkLAnQyjtYN3nQmNgN2P5
         OwCw2gkVWEjfH4ChzXb2zck2UvWGVE5Y9vkDTqbGyyaHr5fGph/FZrtYFW8y77P7D1jr
         643jSCbBD13MS/LQFxKg9aUnbTmJluqMaTH44ObMu20VQ8J0kKnfTcFNwbidg1DIwTFe
         RG/qLfFmECAgC2jDGIIk0RtWDsHUwQzqTJ5/bUkf0V1f5KL8HzeLHJ9QUFIZg6zPYyJm
         AbHA==
X-Gm-Message-State: APjAAAWZGiqhuSMto7tozm6QG8EcUKHITnTWgC++v6iEtxtjHQs6i5D7
        form76WLxo2q4UxuDS5bHLsBWUWVjBI=
X-Google-Smtp-Source: APXvYqw5kKBXigjGSz/Z92PocEd2TTF+JpExdkk8WwK2gpL/nherzvmltVWhU4TmOHhcV4Ifnfa/7w==
X-Received: by 2002:a7b:c14e:: with SMTP id z14mr10726823wmi.58.1582388205505;
        Sat, 22 Feb 2020 08:16:45 -0800 (PST)
Received: from Ansuel-XPS.localdomain (host110-18-dynamic.45-213-r.retail.telecomitalia.it. [213.45.18.110])
        by smtp.googlemail.com with ESMTPSA id a198sm8906855wme.12.2020.02.22.08.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 08:16:44 -0800 (PST)
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
Subject: [PATCH v6 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Sat, 22 Feb 2020 17:16:27 +0100
Message-Id: <20200222161629.1862-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200222161629.1862-1-ansuelsmth@gmail.com>
References: <20200222161629.1862-1-ansuelsmth@gmail.com>
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

