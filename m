Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F6477D2D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241253AbhLPUOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241257AbhLPUOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:39 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E10C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:39 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id p3so346070qvj.9
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SOSz7rMupCFksrwJBW8UoZ28B1jBI4VrYHVrRF7aGbw=;
        b=LSjeJ6ael/XAVlGHke/dM1eoNC58i7oPslHeKAVHrSQCEzXExsfFlPQocp0q+tHPYf
         7qHEdHuc1AvYVISy59beDFXMnj8cLN657E+/T98JRb+ZF2FxypRI6ewHrUCc6UKHexDL
         P77vAcU52v3XD6fIFZ9Jt4AW0DcSdkMsOvYxM3/6jaLR7whjUyPYtE1afS7DQSBsHYyi
         l8DpjrczgPS362XDY0SbBqu+E4KRL04mCz4X6TZ934PhZmlnPQ9W3FO6KHfF+oh2yPAV
         BH80x2OHkKxEPQScNnypq37UCyptKSI0zWH5saxUxHPlyqhIhoNkTBiTIu/TGKBYgEzc
         K0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SOSz7rMupCFksrwJBW8UoZ28B1jBI4VrYHVrRF7aGbw=;
        b=BWuhfRcls37LCPvysjkk4sk+kB6iwMq7IkKh5P6TRgbXwMRbflnGPqVy2l8jn79DaM
         oeQhop90cZbfRfuJxgqgX1ubyXvj+E92ggm2hd2MfoIYEGv9oSjuZuc23hQo8b56qIwV
         Ff7OrqeR4JdSGzIwwtRbb90x1VB81dZnotIfDu8l+wtR9iBUSfBJSAbHTqF7WjOUpx0d
         j+4YwA+zdwg8D1lTFxoTmhZ9UJL4wUPex3j8c2ZjHX8kHzaqouL2aB/f9zqssYO3WXh9
         6G7rS5Pd8I7UOFr35yOVYIegiveL0WLRSCo0U0LHNE0COarwPMCI99TAfFvTMpLfMxQY
         XQbg==
X-Gm-Message-State: AOAM532kh0r2v9ffhmq2GcAjPHSs2Knlf7GxC/BsfqG3e5i/FHWDZM0T
        Wn8tCqSuMx/w1jVa+NUaJslQ227ypLNIBg==
X-Google-Smtp-Source: ABdhPJzJDbFUyyBCOeoopDgsPTwZLfNXRlpcXFJiuUXfS6DTq6D25UpLFrPZLRB6vqavHGlA+4toEA==
X-Received: by 2002:a05:6214:528c:: with SMTP id kj12mr17363211qvb.4.1639685678322;
        Thu, 16 Dec 2021 12:14:38 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:37 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 09/13] dt-bindings: net: dsa: realtek-mdio: document new interface
Date:   Thu, 16 Dec 2021 17:13:38 -0300
Message-Id: <20211216201342.25587-10-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

realtek-mdio is a new mdio driver for realtek switches that use
mdio (instead of SMI) interface.

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-mdio.txt         | 85 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 2 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
new file mode 100644
index 000000000000..01b0463b808f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
@@ -0,0 +1,85 @@
+Realtek MDIO-based Switches
+==========================
+
+Realtek MDIO-based Switches uses MDIO protocol as opposed to realtek
+SMI-based switches. The realtek-mdio driver is an mdio driver and it must
+be inserted inside an mdio node.
+
+Required properties:
+
+- compatible: must be exactly one of (same as realtek-smi):
+      "realtek,rtl8365mb" (4+1 ports)
+      "realtek,rtl8366rb" (4+1 ports)
+      "realtek,rtl8366s"  (4+1 ports)
+
+Required properties:
+- reg: MDIO PHY ID to access the switch
+
+Optional properties:
+- realtek,disable-leds: if the LED drivers are not used in the
+  hardware design this will disable them so they are not turned on
+  and wasting power.
+
+See net/dsa/dsa.txt for a list of additional required and optional properties
+and subnodes of DSA switches.
+
+Optional properties of dsa port:
+
+- realtek,ext-int: defines the external interface number (0, 1, 2). By default, 1.
+
+Examples:
+
+An example for the RTL8367S:
+
+&mdio0 {
+	switch {
+		compatible = "realtek,rtl8367s";
+		reg = <29>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			port@0 {
+				reg = <0>;
+				label = "lan4";
+			};
+
+			port@1 {
+				reg = <1>;
+				label = "lan3";
+			};
+
+			port@2 {
+				reg = <2>;
+				label = "lan2";
+			};
+
+			port@3 {
+				reg = <3>;
+				label = "lan1";
+			};
+
+			port@4 {
+				reg = <4>;
+				label = "wan";
+			};
+
+			port@7 {
+				reg = <7>;
+				ethernet = <&ethernet>;
+				phy-mode = "rgmii";
+				realtek,ext-int = <2>;
+				tx-internal-delay-ps = <2000>;
+				rx-internal-delay-ps = <0>;
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+		};
+	};
+};
+
diff --git a/MAINTAINERS b/MAINTAINERS
index a8f949b368a8..750f5c68c5fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16152,7 +16152,7 @@ F:	sound/soc/codecs/rt*
 REALTEK RTL83xx SMI DSA ROUTER CHIPS
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+F:	Documentation/devicetree/bindings/net/dsa/realtek-*.txt
 F:	drivers/net/dsa/realtek/*
 
 REALTEK WIRELESS DRIVER (rtlwifi family)
-- 
2.34.0

