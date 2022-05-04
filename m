Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFF851969E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 06:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344610AbiEDEju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 00:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239363AbiEDEjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 00:39:48 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A3529CA2
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 21:36:12 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2F06E2C019D;
        Wed,  4 May 2022 04:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651638969;
        bh=6FaGZa12henirzB20VLIIITZhWvMCD3N+Hr2xV6HwkA=;
        h=From:To:Cc:Subject:Date:From;
        b=pXa8nFmOsz5ACdbxOqrdY831y533w4h6UrXbxl/D8w3rm/qQ+PqjLKwxDAMJl0WDN
         od0Jg7ct7+n20ItIsmkKlxqWyazL5IQtINwLDr9QqmMepLcaI2VYoGZSESjl52ke5R
         cDUK1W1t9WR497KMayQ/9+vDlWQDiersV0RrHhbEiohLFwXy+Dp7gqKw5zjsMZTZKG
         xfpeU6eSCUF1HFVnTli8gvBvvn8WctVNBRIYTIupBLJr7kTNfBz7G3SSuWNYBX/Qk2
         CKpdunXUtW7GJ1s530f2TTiiV6u2gLTZ0Su7MuhQaAimIQTnPyOXW0QnqhHKsldgrO
         TufeB7WUjgU6g==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B627202b80000>; Wed, 04 May 2022 16:36:08 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id E0B4013ED63;
        Wed,  4 May 2022 16:36:08 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id DAAF02A1FA9; Wed,  4 May 2022 16:36:08 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, atenart@kernel.org,
        thomas.petazzoni@free-electrons.com, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] dt-bindings: net: orion-mdio: Convert to JSON schema
Date:   Wed,  4 May 2022 16:36:02 +1200
Message-Id: <20220504043603.949134-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=oZkIemNP1mAA:10 a=gEfo2CItAAAA:8 a=VwQbUJbxAAAA:8 a=uP1ucDPQAAAA:8 a=pGLkceISAAAA:8 a=DUOwM17OdgdjODy0UN4A:9 a=sptkURWiP4Gy88Gu7hUp:22 a=AjGcO6oz07-iQ99wixmX:22 a=9a9ggB8z3XFZH39hjkD6:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the marvell,orion-mdio binding to JSON schema.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    Thomas, Antione & Florian I hope you don't mind me putting you as
    maintainers of the binding. Between you you've written the majority o=
f
    the mvmdio.c driver.
   =20
    This does throw up the following dtbs_check warnings for turris-mox:
   =20
    arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: s=
witch0@10:reg: [[16], [0]] is too long
            From schema: Documentation/devicetree/bindings/net/marvell,or=
ion-mdio.yaml
    arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: s=
witch0@2:reg: [[2], [0]] is too long
            From schema: Documentation/devicetree/bindings/net/marvell,or=
ion-mdio.yaml
    arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: s=
witch1@11:reg: [[17], [0]] is too long
            From schema: Documentation/devicetree/bindings/net/marvell,or=
ion-mdio.yaml
    arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: s=
witch1@2:reg: [[2], [0]] is too long
            From schema: Documentation/devicetree/bindings/net/marvell,or=
ion-mdio.yaml
    arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: s=
witch2@12:reg: [[18], [0]] is too long
            From schema: Documentation/devicetree/bindings/net/marvell,or=
ion-mdio.yaml
    arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: s=
witch2@2:reg: [[2], [0]] is too long
            From schema: Documentation/devicetree/bindings/net/marvell,or=
ion-mdio.yaml
   =20
    I think they're all genuine but I'm hesitant to leap in and fix them
    without being able to test them.
   =20
    I also need to set unevaluatedProperties: true to cater for the L2
    switch on turris-mox (and probably others). That might be better tack=
led
    in the core mdio.yaml schema but I wasn't planning on touching that.

 .../bindings/net/marvell,orion-mdio.yaml      | 62 +++++++++++++++++++
 .../bindings/net/marvell-orion-mdio.txt       | 54 ----------------
 2 files changed, 62 insertions(+), 54 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,orion-m=
dio.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-orion-m=
dio.txt

diff --git a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yam=
l b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
new file mode 100644
index 000000000000..43cd896a0851
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,orion-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell MDIO Ethernet Controller interface
+
+maintainers:
+  - Antoine Tenart <atenart@kernel.org>
+  - Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+description: |
+  The Ethernet controllers of the Marvel Kirkwood, Dove, Orion5x, MV78xx=
0,
+  Armada 370, Armada XP, Armada 7k and Armada 8k have an identical unit =
that
+  provides an interface with the MDIO bus. Additionally, Armada 7k and A=
rmada
+  8k has a second unit which provides an interface with the xMDIO bus. T=
his
+  driver handles these interfaces.
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    enum:
+      - marvell,orion-mdio
+      - marvell,xmdio
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+    maxItems: 4
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: true
+
+examples:
+  - |
+    mdio@d0072004 {
+      compatible =3D "marvell,orion-mdio";
+      reg =3D <0xd0072004 0x4>;
+      #address-cells =3D <1>;
+      #size-cells =3D <0>;
+      interrupts =3D <30>;
+
+      phy0: ethernet-phy@0 {
+        reg =3D <0>;
+      };
+
+      phy1: ethernet-phy@1 {
+        reg =3D <1>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt=
 b/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
deleted file mode 100644
index 3f3cfc1d8d4d..000000000000
--- a/Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
+++ /dev/null
@@ -1,54 +0,0 @@
-* Marvell MDIO Ethernet Controller interface
-
-The Ethernet controllers of the Marvel Kirkwood, Dove, Orion5x,
-MV78xx0, Armada 370, Armada XP, Armada 7k and Armada 8k have an
-identical unit that provides an interface with the MDIO bus.
-Additionally, Armada 7k and Armada 8k has a second unit which
-provides an interface with the xMDIO bus. This driver handles
-these interfaces.
-
-Required properties:
-- compatible: "marvell,orion-mdio" or "marvell,xmdio"
-- reg: address and length of the MDIO registers.  When an interrupt is
-  not present, the length is the size of the SMI register (4 bytes)
-  otherwise it must be 0x84 bytes to cover the interrupt control
-  registers.
-
-Optional properties:
-- interrupts: interrupt line number for the SMI error/done interrupt
-- clocks: phandle for up to four required clocks for the MDIO instance
-
-The child nodes of the MDIO driver are the individual PHY devices
-connected to this MDIO bus. They must have a "reg" property given the
-PHY address on the MDIO bus.
-
-Example at the SoC level without an interrupt property:
-
-mdio {
-	#address-cells =3D <1>;
-	#size-cells =3D <0>;
-	compatible =3D "marvell,orion-mdio";
-	reg =3D <0xd0072004 0x4>;
-};
-
-Example with an interrupt property:
-
-mdio {
-	#address-cells =3D <1>;
-	#size-cells =3D <0>;
-	compatible =3D "marvell,orion-mdio";
-	reg =3D <0xd0072004 0x84>;
-	interrupts =3D <30>;
-};
-
-And at the board level:
-
-mdio {
-	phy0: ethernet-phy@0 {
-		reg =3D <0>;
-	};
-
-	phy1: ethernet-phy@1 {
-		reg =3D <1>;
-	};
-}
--=20
2.36.0

