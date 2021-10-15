Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3446E42F9CE
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbhJORNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbhJORNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:13:05 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4200DC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:10:58 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w19so40518887edd.2
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 10:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cZtlYEaBOOOUDak05RsEGLYYUfgqdd0jrw6IwnOtniE=;
        b=hl6C0N8YszS3Hc91yBf0OJ5BNoTznZVly52qPiFIgmpDuPFe/QkTwv8FACn4i3AFUM
         0nfrsUE/3To7+RXVOkyVt7EFB5F0yY6GNMjXsf6O+5XGvZDlK6e2wvNUzkKG+vNkoEFG
         7s6usQpw3lOpyoEQZKUIb+8gZfmorKjQljCDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cZtlYEaBOOOUDak05RsEGLYYUfgqdd0jrw6IwnOtniE=;
        b=63iIwO7ZjFc7JdW/c6rHzbQV8Nmw4uWVmx7nw5gJut3SIP/itBB/3hzAnjHZ6k3K94
         xXbvBEC2q+skogaH85qZLS7krJG3f/2CZaX5DdhxT2ZebcPKQS3X92ZjvZFY2QjdbK3l
         T5BO8dc1YHwfkDf8dLXLFy3izupr720roAMa2ZKIhaqlMWtEBF8BW2kN+nCA2qOk86sW
         f2oTJfwekeIgt0Pt5djxkNuzDxDwXfUM7WgORm4MMW49t/iwzUWAhfWKGog8Q7Ro64NU
         PtQmUCrHS7XSqEVP5ZctUm3OuyWGJyo1gCV3PAGgvhaJWJK92bqY2rr23Y2mQX/8Krcm
         G+BA==
X-Gm-Message-State: AOAM531yBMaDgNTO7oTpgqBBln30X/lGZ6X21gEyHt6gFqY4TQT9mrh8
        gGjHPdWsCYmNvTh3KDb5mxsPqg==
X-Google-Smtp-Source: ABdhPJzArYM/aKr535DLyKoBHED/s+pYPPYoLwSS4L9tS0dqnJWACQTUdRtFKfQWRwF3N6X0TiSmeA==
X-Received: by 2002:a17:906:4e4a:: with SMTP id g10mr8078353ejw.524.1634317856780;
        Fri, 15 Oct 2021 10:10:56 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id jt24sm4735792ejb.59.2021.10.15.10.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 10:10:56 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 4/7] dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
Date:   Fri, 15 Oct 2021 19:10:25 +0200
Message-Id: <20211015171030.2713493-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211015171030.2713493-1-alvin@pqrs.dk>
References: <20211015171030.2713493-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

rtl8365mb is a new realtek-smi subdriver for the RTL8365MB-VC 4+1 port
10/100/1000M Ethernet switch controller. Its compatible string is
"realtek,rtl8365mb".

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---

v2 -> v3: no change

v1 -> v2:
  - add an example to highlight RGMII delay configuration and CPU port
    reg number

RFC -> v1: no change; collect Reviewed-by and Acked-by

 .../bindings/net/dsa/realtek-smi.txt          | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index b6ae8541bd55..7959ec237983 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -9,6 +9,7 @@ SMI-based Realtek devices.
 Required properties:
 
 - compatible: must be exactly one of:
+      "realtek,rtl8365mb" (4+1 ports)
       "realtek,rtl8366"
       "realtek,rtl8366rb" (4+1 ports)
       "realtek,rtl8366s"  (4+1 ports)
@@ -62,6 +63,8 @@ and subnodes of DSA switches.
 
 Examples:
 
+An example for the RTL8366RB:
+
 switch {
 	compatible = "realtek,rtl8366rb";
 	/* 22 = MDIO (has input reads), 21 = MDC (clock, output only) */
@@ -151,3 +154,87 @@ switch {
 		};
 	};
 };
+
+An example for the RTL8365MB-VC:
+
+switch {
+	compatible = "realtek,rtl8365mb";
+	mdc-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
+	mdio-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>;
+	reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
+
+	switch_intc: interrupt-controller {
+		interrupt-parent = <&gpio5>;
+		interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-controller;
+		#address-cells = <0>;
+		#interrupt-cells = <1>;
+	};
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0>;
+		port@0 {
+			reg = <0>;
+			label = "swp0";
+			phy-handle = <&ethphy0>;
+		};
+		port@1 {
+			reg = <1>;
+			label = "swp1";
+			phy-handle = <&ethphy1>;
+		};
+		port@2 {
+			reg = <2>;
+			label = "swp2";
+			phy-handle = <&ethphy2>;
+		};
+		port@3 {
+			reg = <3>;
+			label = "swp3";
+			phy-handle = <&ethphy3>;
+		};
+		port@6 {
+			reg = <6>;
+			label = "cpu";
+			ethernet = <&fec1>;
+			phy-mode = "rgmii";
+			tx-internal-delay-ps = <2000>;
+			rx-internal-delay-ps = <2000>;
+
+			fixed-link {
+				speed = <1000>;
+				full-duplex;
+				pause;
+			};
+		};
+	};
+
+	mdio {
+		compatible = "realtek,smi-mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy0: phy@0 {
+			reg = <0>;
+			interrupt-parent = <&switch_intc>;
+			interrupts = <0>;
+		};
+		ethphy1: phy@1 {
+			reg = <1>;
+			interrupt-parent = <&switch_intc>;
+			interrupts = <1>;
+		};
+		ethphy2: phy@2 {
+			reg = <2>;
+			interrupt-parent = <&switch_intc>;
+			interrupts = <2>;
+		};
+		ethphy3: phy@3 {
+			reg = <3>;
+			interrupt-parent = <&switch_intc>;
+			interrupts = <3>;
+		};
+	};
+};
-- 
2.32.0

