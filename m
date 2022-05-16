Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DCE5293C5
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349732AbiEPWsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348868AbiEPWsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:48:12 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C016840E55
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:48:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A7D452C022D;
        Mon, 16 May 2022 22:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1652741288;
        bh=yck0K+zg9Rk64Z3+P5kyIChCgdh0HS53j4rjHi8Gkzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Plsrq3xNg3eLxOgGv947hqy6f7he/F8cFFMdQr955ypBDoj6WY23sunnjksuM5oCT
         DSZc/UziM9wck6/YAm87OkFc8jpQcPjmA72BDh8RKsQnXqgWaxcZXKTkpsQtvo+qwq
         MfahU1YBLxw3/JW270TuzmlkPxr+hMYgWax403lmqqAhNaRYRBVeFpmZ7P7DqNejnu
         fq55PB3WqfaEMZ7qAFgBjUiuY28GTF8c/NlUm90LxsqKSbmBRr73D7mieQCtgWCaO9
         p1mOKwCDWvIW+j6G6hVji/VPqyLSV4WaDWryC2x2I3wHeVpIFBWMboX5wygS6LMK3P
         E2SpMxsYaa9cQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6282d4a80001>; Tue, 17 May 2022 10:48:08 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 5595113ED7D;
        Tue, 17 May 2022 10:48:08 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 52C322A0086; Tue, 17 May 2022 10:48:08 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        kabel@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 1/2] arm64: dts: armada-3720-turris-mox: Correct reg property for mdio devices
Date:   Tue, 17 May 2022 10:48:00 +1200
Message-Id: <20220516224801.1656752-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
References: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=oZkIemNP1mAA:10 a=0UGfjhEQY5xZ206faIcA:9
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

MDIO devices have #address-cells =3D <1>, #size-cells =3D <0>. Now that w=
e
have a schema enforcing this for marvell,orion-mdio we can see that the
turris-mox has a unnecessary 2nd cell for the switch nodes reg property
of it's switch devices. Remove the unnecessary 2nd cell from the
switches reg property.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 .../boot/dts/marvell/armada-3720-turris-mox.dts      | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arc=
h/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 1cee26479bfe..98c9a3265446 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -303,7 +303,7 @@ phy1: ethernet-phy@1 {
 	/* switch nodes are enabled by U-Boot if modules are present */
 	switch0@10 {
 		compatible =3D "marvell,mv88e6190";
-		reg =3D <0x10 0>;
+		reg =3D <0x10>;
 		dsa,member =3D <0 0>;
 		interrupt-parent =3D <&moxtet>;
 		interrupts =3D <MOXTET_IRQ_PERIDOT(0)>;
@@ -428,7 +428,7 @@ port-sfp@a {
=20
 	switch0@2 {
 		compatible =3D "marvell,mv88e6085";
-		reg =3D <0x2 0>;
+		reg =3D <0x2>;
 		dsa,member =3D <0 0>;
 		interrupt-parent =3D <&moxtet>;
 		interrupts =3D <MOXTET_IRQ_TOPAZ>;
@@ -495,7 +495,7 @@ port@5 {
=20
 	switch1@11 {
 		compatible =3D "marvell,mv88e6190";
-		reg =3D <0x11 0>;
+		reg =3D <0x11>;
 		dsa,member =3D <0 1>;
 		interrupt-parent =3D <&moxtet>;
 		interrupts =3D <MOXTET_IRQ_PERIDOT(1)>;
@@ -620,7 +620,7 @@ port-sfp@a {
=20
 	switch1@2 {
 		compatible =3D "marvell,mv88e6085";
-		reg =3D <0x2 0>;
+		reg =3D <0x2>;
 		dsa,member =3D <0 1>;
 		interrupt-parent =3D <&moxtet>;
 		interrupts =3D <MOXTET_IRQ_TOPAZ>;
@@ -687,7 +687,7 @@ port@5 {
=20
 	switch2@12 {
 		compatible =3D "marvell,mv88e6190";
-		reg =3D <0x12 0>;
+		reg =3D <0x12>;
 		dsa,member =3D <0 2>;
 		interrupt-parent =3D <&moxtet>;
 		interrupts =3D <MOXTET_IRQ_PERIDOT(2)>;
@@ -803,7 +803,7 @@ port-sfp@a {
=20
 	switch2@2 {
 		compatible =3D "marvell,mv88e6085";
-		reg =3D <0x2 0>;
+		reg =3D <0x2>;
 		dsa,member =3D <0 2>;
 		interrupt-parent =3D <&moxtet>;
 		interrupts =3D <MOXTET_IRQ_TOPAZ>;
--=20
2.36.1

