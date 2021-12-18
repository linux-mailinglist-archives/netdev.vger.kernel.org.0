Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1AC47999C
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhLRIPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhLRIPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:19 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A00C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:19 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id j17so5060662qtx.2
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p40XvdS6QXeKkNIFd5zfRoaB/MiFYSMLoW8xR11SoMU=;
        b=m8a3zii2hHjSwvaoaLV3/h3xhS4GlObKN9UskZriHYEw02fPNf3zoEaBFw4S549M/u
         xmbENqhNPcKkIiKCxJdc0xyDfuHKylfDYlemKZqN94hCktZUQnqJ5AAQrimc3Qg8CCik
         SdnDjlCfiaRIPDCgzM2Hz7PnSWR0K0PpkOHhz9M2lWxk7U7xlFAnqhyi9ClG1AeVwHwd
         c8IGnQEoCii41AOZus+UlUbfQW4yKL3qJIHtd5Uo9YscfT3HPuRPacml/ZxuDMOWZO8R
         fzpe/VCn1xQg3oJzPeodJ1vtTPJON+PGdeTimjlr7WaIO7muRiJri7vSHPYGnQnQK1/c
         CQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p40XvdS6QXeKkNIFd5zfRoaB/MiFYSMLoW8xR11SoMU=;
        b=jE91dv0p42NR55dKOzBRGeejOGJ+fWFymgvOStGYCWVzApzKKsX+OnrxVtygO3ylPO
         97rJzXme0nmjJpod2KXkEAs0Utj5x8b9kLSAQM7a+KBdvxNymtOih9rDVnF/fE9fCm1n
         YcCldtaTMLv1FTSYKS2Q9NsiMoMnl1YvjABaFPLzPPRKSi/tvO0SkVh8tLvdPHCGH/k2
         oWZbqJlp5OvYccmHnTBQnhDg3esNK66wPjzgCuuKjOcqTynSuCTm+Ku8LkCh6TlC/T0V
         xXpg6zGdwTDOgbKv7i6MMXv9mRpe3KX+jawIoTmAWuAqU/j6Xv7TgDJ0n7whtYbyytD9
         FAuw==
X-Gm-Message-State: AOAM53071k3NZg1QlKDE5rIb3Xq6S6W8uNVf04gDaqSwuvdyJH2iBp8R
        cvxcRXGiSaWSUsklzft66YWxOiUOAjHgnw==
X-Google-Smtp-Source: ABdhPJwQaGJaPoDP0TVXZ2Vn5EuN6nadL15VFraxlo1/mdAimMZrCBn0gFHlkDE8ZiAgfxDheGxDXw==
X-Received: by 2002:a05:622a:1491:: with SMTP id t17mr5409352qtx.402.1639815318426;
        Sat, 18 Dec 2021 00:15:18 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:17 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 08/13] dt-bindings: net: dsa: realtek-mdio: document new interface
Date:   Sat, 18 Dec 2021 05:14:20 -0300
Message-Id: <20211218081425.18722-9-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

realtek-mdio is a new mdio driver for realtek switches that use
mdio (instead of SMI) interface.

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-mdio.txt         | 91 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 2 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
new file mode 100644
index 000000000000..71e0a3d09aeb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
@@ -0,0 +1,91 @@
+Realtek MDIO-based Switches
+==========================
+
+Realtek MDIO-based switches use MDIO protocol as opposed to Realtek
+SMI-based switches. The realtek-mdio driver is an mdio driver and it must
+be inserted inside an mdio node.
+
+Required properties:
+
+- compatible: must be exactly one of (same as realtek-smi):
+      "realtek,rtl8365mb" (4+1 ports)
+      "realtek,rtl8366"               (not supported yet)
+      "realtek,rtl8366rb" (4+1 ports)
+      "realtek,rtl8366s"  (4+1 ports) (not supported yet)
+      "realtek,rtl8367"               (not supported yet)
+      "realtek,rtl8367b"              (not supported yet)
+      "realtek,rtl8368s"  (8 port)    (not supported yet)
+      "realtek,rtl8369"               (not supported yet)
+      "realtek,rtl8370"   (8 port)    (not supported yet)
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

