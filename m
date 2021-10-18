Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAB74313A9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhJRJnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhJRJmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:42:50 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5DCC06176D
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z20so68662940edc.13
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BuWMZr4vimyMTgrLXxKUTvZjcX+vifXbUt3bLu3eF+I=;
        b=TLdpKtHrFwKW01k8APeQACgV/VlQ2bA/PkVkFfjQjwKSw2nVgOIrcJABpOTmieuEkX
         qi+oD68lzZTMhtj//Af6xsE04KMLEHJ/DhRwWHIjmnLJSV1qkSpzhD4D8o/p1j031iUp
         lM/7Gd6ZwtOuQc62sL9xrqW+CraBhH5BU4qAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BuWMZr4vimyMTgrLXxKUTvZjcX+vifXbUt3bLu3eF+I=;
        b=pjvSSTSuLR8eA4QTkRBgOefHb3u2iMe3Avb51WxQ5+gWUMakf9Lg+qusC8ApRCXMXo
         KW01ganAi3K/iXZUZCpGNLlRQ4AzmwF1a76w3gWcJ26XiGp6oBlJoAwcMw5D2gKx6JFP
         rrlp9F1qV1O39qk/EdX/oAeDJSf6RfflNTr8noUthWGmcQBhSz5kyciVU+Hg061Yuhqx
         NWCFPd0FHHjZMJVbcXEXKC6KOa/33oZaRjIFC+d1DACY4P5TMTaCqga3DIqO3ClfiQPB
         AH1TmpqhuCGhQdyDXcm8xdbFfE/gGEsjGy/Www8/vMjrwkj0zBUgAy4507EYOG5bpw6y
         O5hg==
X-Gm-Message-State: AOAM530qhKHdMBs1mdhT/nZrDTEWgJxpZATlHpwX81o0KGbP65iIrsLv
        rOMQGo9l9c0QfL3KpORJOOuFtg==
X-Google-Smtp-Source: ABdhPJwwUPWCiGXrfoI0vAyhgglpmCKBDQIia4xQ8QSR8fMzr3dt2y/KLEI9WZ2M4L2UuTl9Uw7RZQ==
X-Received: by 2002:a17:906:cec6:: with SMTP id si6mr28349464ejb.270.1634550038492;
        Mon, 18 Oct 2021 02:40:38 -0700 (PDT)
Received: from capella.. ([80.208.66.147])
        by smtp.gmail.com with ESMTPSA id z1sm10134566edc.68.2021.10.18.02.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:40:38 -0700 (PDT)
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
Cc:     arinc.unal@arinc9.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 4/7] dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
Date:   Mon, 18 Oct 2021 11:37:59 +0200
Message-Id: <20211018093804.3115191-5-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018093804.3115191-1-alvin@pqrs.dk>
References: <20211018093804.3115191-1-alvin@pqrs.dk>
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

v3 -> v4: no change

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

