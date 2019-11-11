Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36167F8086
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfKKTvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:39 -0500
Received: from mout.gmx.net ([212.227.15.15]:41555 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbfKKTvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501793;
        bh=am5k+ShH8U/QfQdyBRZNILtXr6ux5dgQyoLfNDeiNlM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZWLhzips9JEVDIrybY6YZcYBeIVNzxFEKx90FCwd2Yiba8sDGCabOeWQ347jmVkr7
         ogVIhSnMlCy45GR5EjCClDrm3fXviNF7L7mKdH6W5/MiD3CMKn7EB3KMm/4a06aBHU
         uZqFYg9N9RGBN5PsEVU3JvL8fdUFDi8zGLmo67wg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MGz1V-1ihfgw2UBX-00E9p7; Mon, 11 Nov 2019 20:49:53 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 7/7] ARM: dts: bcm2711-rpi-4: Enable GENET support
Date:   Mon, 11 Nov 2019 20:49:26 +0100
Message-Id: <1573501766-21154-8-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:UbrYrgHW74lfPA+tgJPjDhRQ6IU7i7clWdYMrwjznjqM4z8OCOv
 9soJZvWh6RiQjlx86Z4/ybxzlbBbCNoWCxQlfbKHxsUtUJapUW6VkMLllv8A6l7+DKr0up1
 ttn3VEs/6ZR1/JwC/HOvqKkvM3mCvjip6er3QlQeVsN+hQZE2GCRPObWy2qgkIvbZqajF/3
 ROvXvD0XmLIqc4aQSP1rQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:grgUlR0qMM0=:g+87Wk7DpT63/3SlHoio/H
 QTUC9LkZyBoxnpDHuuTBxZ/sMXjNFqsmoWwwM2K+4MblutuXqlS4LSx6XAto5aNy5VDpvDVr3
 TeukniDGy+yKwRev2xXONw9DYmMCGX/CPQfzx1/ZBuh9Zu9t+KoTBx/rUlFdGgXO4hyEGdKHJ
 UOOA+tbd95sjl/72JNSNcophpZkRTX4n5LB53ye3OnxxBUKDe0NMhs5cmgn4z2wmb0OzQTPeK
 v/+4gOLM7ebmIqchn6JVJx4UgaMMLmryU9TDCn3Y0/R6MK+R8nl5DzK9nPFfYPMhcpys0gJoz
 DzYwn1bzopphNrPyKVz4dQVQ8KnEurKaMeJA791iWl3dSdaJgdx9Y5EfM3vzOGRlwSgQIFAy2
 n1uBj3fkakArQ1PWdY4Pwj8GrjZL2RaOF/NCJSfDkBfVpwGrYi2Wv4QaUsPBi+/N0bYxnuns3
 64zBjryA+Wc7EDF3CGRs//6C2F9Nxi8WT9sUjSz1+zfGv1a2J34qvKj5N6KlrW97i9jytGp++
 qmds288WQfB1aOAUVS9+OIDzlogo0HgFpmc8jWNXvOnfpmsPpfD97Gqb9iOGchjgLDPNzTshl
 RLjKvGqQ7NBwStZkAMW+aXZG4kWRIa8PoQNSudd7qaXFsvcxf4FQl0C6XwyBn1bGXsM3x5zKn
 v4vtMQARqStBLrQpwBfzUogAFjX8eV8wh6/ynFcugCQNzlyPAGtVIMI7weinOJbIWcSd97FxD
 44mlK961rBcPBKnKssezG3ujTgMzaYS3GoWVUndhTmHMK0EqB1JR2uk/7fYFCwJrnMAdrP1Re
 v/QaGTh6TxXjhCUs5DMV/z/VQzNTpcOIWKvxi2hJLCp5oGCR5Qpbn6tG3rVEhO9G4bapQoNBz
 NnbuortocfuBz5itzKt3kbP3DhNB/bSFqko8fMcqAOht1OCcl734k2NWv5pemPxIcJLN3CxfX
 Dk0i2s+aCoKNKyj4Jy/TQ3ZUmDhcvQDQxP+uOLK8/FXXHOKUBvvTEq/nUCRi4q2Xy/DguPc/e
 Dfl026/Hx2EmacHN7BvXV2fow57s1hn6E9ThXG9Jg/dZsNsniuOu0NBojv61W+CfyvqlUehYt
 2zUo3kipSI/irjy5lJ1gl9G+Z87s6h5gMRsIX4aw0eQNoZZWghmawg8POkiAU0geDOkkgJV0s
 rIRz2cXTRziCZrLf0AY8i/LEuLsMH3CGTbyLtTxtwcak9P7RhUd/+2oGP02Lt3MaE6kScdQiN
 VyE18gITYg62+tlQUO54NRoHQ2JhoNBOHHsJSCw==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables the Gigabit Ethernet support on the Raspberry Pi 4.
The defined PHY mode is equivalent to the default register settings
in the downstream tree.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
=2D--
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts | 17 +++++++++++++++++
 arch/arm/boot/dts/bcm2711.dtsi        | 26 ++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts b/arch/arm/boot/dts/bcm=
2711-rpi-4-b.dts
index cccc1cc..1b5a835 100644
=2D-- a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
@@ -19,6 +19,10 @@
 		reg =3D <0 0 0>;
 	};

+	aliases {
+		ethernet0 =3D &genet;
+	};
+
 	leds {
 		act {
 			gpios =3D <&gpio 42 GPIO_ACTIVE_HIGH>;
@@ -97,6 +101,19 @@
 	status =3D "okay";
 };

+&genet {
+	phy-handle =3D <&phy1>;
+	phy-mode =3D "rgmii-rxid";
+	status =3D "okay";
+};
+
+&genet_mdio {
+	phy1: ethernet-phy@1 {
+		/* No PHY interrupt */
+		reg =3D <0x1>;
+	};
+};
+
 /* uart0 communicates with the BT module */
 &uart0 {
 	pinctrl-names =3D "default";
diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dt=
si
index ac83dac..a571223 100644
=2D-- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -305,6 +305,32 @@
 			cpu-release-addr =3D <0x0 0x000000f0>;
 		};
 	};
+
+	scb {
+		compatible =3D "simple-bus";
+		#address-cells =3D <2>;
+		#size-cells =3D <1>;
+
+		ranges =3D <0x0 0x7c000000  0x0 0xfc000000  0x03800000>;
+
+		genet: ethernet@7d580000 {
+			compatible =3D "brcm,bcm2711-genet-v5";
+			reg =3D <0x0 0x7d580000 0x10000>;
+			#address-cells =3D <0x1>;
+			#size-cells =3D <0x1>;
+			interrupts =3D <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>;
+			status =3D "disabled";
+
+			genet_mdio: mdio@e14 {
+				compatible =3D "brcm,genet-mdio-v5";
+				reg =3D <0xe14 0x8>;
+				reg-names =3D "mdio";
+				#address-cells =3D <0x0>;
+				#size-cells =3D <0x1>;
+			};
+		};
+	};
 };

 &clk_osc {
=2D-
2.7.4

