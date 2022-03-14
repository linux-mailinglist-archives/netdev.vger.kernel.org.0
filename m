Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815384D8EB8
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbiCNVdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245255AbiCNVdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:33:23 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94E332EED
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:32:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 5F02A2C049B;
        Mon, 14 Mar 2022 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647293527;
        bh=tk1E4VagxLubGQCwJVnsW/0dqlT2PhJSY91Py3AQRjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLFHu1LVVtnH+HDj69dWPBHDKFzQ9qkU+Uo5GrBMMLanflF/rRV63kqqTrtg2pu7L
         UrD9BsyniTBZ4i0blG0Qg2EniPkOkMPeJz5UfkF71voYP7NZxzBMAtjZwMM8w8BoZe
         jaAytWpz8SywlrnIwm9TiWDyLxhSPNZqK0xzII9D3b6mTvOREe9Sg8XZq51nPVnwV+
         c0yU8wqimYp+xz/+W5dKd0wmJvf670O8wySRi5/Fy6v8q9BJamfkREXX49mpbyXpVI
         M7v8mJYhoHfDk13bUGwgq6AX2jfbdNN+Yqi/1vg44lQcKOTJWCNpkMz0eSLvUnonJ5
         wMNt6Q+HIrr9A==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fb4570003>; Tue, 15 Mar 2022 10:32:07 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 0D90D13EE8E;
        Tue, 15 Mar 2022 10:32:07 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id E8A162A2678; Tue, 15 Mar 2022 10:32:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 3/8] dt-bindings: mmc: xenon: add AC5 compatible string
Date:   Tue, 15 Mar 2022 10:31:38 +1300
Message-Id: <20220314213143.2404162-4-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=ZuYvX9HxE-CSu40lHJ4A:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Import binding documentation from the Marvell SDK which adds
marvell,ac5-sdhci compatible string and documents the requirements for
the for the Xenon SDHCI controller on the 98DX2530.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    Changes in v2:
    - New

 .../bindings/mmc/marvell,xenon-sdhci.txt      | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/marvell,xenon-sdhci.tx=
t b/Documentation/devicetree/bindings/mmc/marvell,xenon-sdhci.txt
index c51a62d751dc..43df466f0cb3 100644
--- a/Documentation/devicetree/bindings/mmc/marvell,xenon-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/marvell,xenon-sdhci.txt
@@ -14,6 +14,7 @@ Required Properties:
   - "marvell,armada-ap806-sdhci": For controllers on Armada AP806.
   - "marvell,armada-ap807-sdhci": For controllers on Armada AP807.
   - "marvell,armada-cp110-sdhci": For controllers on Armada CP110.
+  - "marvell,ac5-sdhci": For CnM on AC5, AC5X and derived.
=20
 - clocks:
   Array of clocks required for SDHC.
@@ -33,6 +34,13 @@ Required Properties:
     in below.
     Please also check property marvell,pad-type in below.
=20
+  * For "marvell,ac5-sdhci", one or two register areas.
+    (reg-names "ctrl" & "decoder").
+    The first one is mandatory for the Xenon IP registers.
+    The second one is for systems where DMA mapping is required and is t=
he
+    related address decoder register (the value to configure is derived =
from
+    the parent "dma-ranges").
+
   * For other compatible strings, one register area for Xenon IP.
=20
 Optional Properties:
@@ -171,3 +179,47 @@ Example:
=20
 		marvell,pad-type =3D "sd";
 	};
+
+
+- For eMMC with compatible "marvell,ac5-sdhci" with one reg range (no dm=
a):
+	sdhci0: sdhci@805c0000 {
+		compatible =3D "marvell,ac5-sdhci";
+		reg =3D <0x0 0x805c0000 0x0 0x300>;
+		reg-names =3D "ctrl", "decoder";
+		interrupts =3D <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
+		clocks =3D <&core_clock>;
+		clock-names =3D "core";
+		status =3D "okay";
+		bus-width =3D <8>;
+		/*marvell,xenon-phy-slow-mode;*/
+		non-removable;
+		mmc-ddr-1_8v;
+		mmc-hs200-1_8v;
+		mmc-hs400-1_8v;
+	};
+
+- For eMMC with compatible "marvell,ac5-sdhci" with two reg ranges (with=
 dma):
+	mmc_dma: mmc-dma-peripherals@80500000 {
+		compatible =3D "simple-bus";
+		#address-cells =3D <0x2>;
+		#size-cells =3D <0x2>;
+		ranges;
+		dma-ranges =3D <0x2 0x0 0x2 0x80000000 0x1 0x0>;
+		dma-coherent;
+
+		sdhci0: sdhci@805c0000 {
+			compatible =3D "marvell,ac5-sdhci", "marvell,armada-ap806-sdhci";
+			reg =3D <0x0 0x805c0000 0x0 0x300>, <0x0 0x80440230 0x0 0x4>;
+			reg-names =3D "ctrl", "decoder";
+			interrupts =3D <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
+			clocks =3D <&core_clock>;
+			clock-names =3D "core";
+			status =3D "okay";
+			bus-width =3D <8>;
+			/*marvell,xenon-phy-slow-mode;*/
+			non-removable;
+			mmc-ddr-1_8v;
+			mmc-hs200-1_8v;
+			mmc-hs400-1_8v;
+		};
+	};
--=20
2.35.1

