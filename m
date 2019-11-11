Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1706F6EC8
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfKKG5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:57:34 -0500
Received: from mout.gmx.net ([212.227.15.19]:44591 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfKKG5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573455364;
        bh=am5k+ShH8U/QfQdyBRZNILtXr6ux5dgQyoLfNDeiNlM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RApLwqGMk/oF/T5fy2n6Ki38f/8gU1sAmixbHhlw3w1a7r8ohDhQ7v/NqitDChArt
         qWBhwPankPJZaw0slnTVr3USIkng8xK7WrbVZgRXCMjmVciWkSAisNO549MMRyOWHT
         KWPcQ0JIfJvg+gfrJaKOH7l0Na5b3BwuY4MLO9hA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MFKGZ-1ieqKo3hVZ-00FmJG; Mon, 11 Nov 2019 07:56:04 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V4 net-next 7/7] ARM: dts: bcm2711-rpi-4: Enable GENET support
Date:   Mon, 11 Nov 2019 07:55:41 +0100
Message-Id: <1573455341-22813-8-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
References: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:FtYw9AitZ/QWi6w2TJzn4EBO/VhwqWfVGIfXiA4PmfXq1eBy23k
 muNpAVhuygC+ZOR06igORgZiQv1dAJXdmyX7LtqN8uUZmcGGTjBKRADTPf3vJBnih9tfulD
 qlP33dILLeEuc1kaQiICvpE3+1knRWBVsMCLY/nYTwlIWbWFOrmgQwTIrZ9QNzOSRQyD1US
 ZHVZUCSdmV4x7pRIMDgSA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VEcE/ir0bqg=:JaxsQix5JyZ8OVQ8MCL5dy
 h+CuFtGAhAaAt67se0yoAFCbDhAz4z/B3qHYexipnRMhOL7yba5WHSFcx0J7DlZn99+ap942t
 8QOa2uUYcutnLQlp8fp9xwlzykVx3jg0+bOa2qA7g/58lKlQM7L3q1ZdrGgqldMgKhrpq2qfZ
 zv1vdURGvJxZhEe/MDFiAxzh5+c1o0Ogag5TJVyH5iZkvFnSqV27xOozh50aiHjDbfi4Jy7zk
 P+KPswjbW583RA2tz9pD9Uqt3TYY20bEfX/23U813fBimEvk3ggmV11mbGg5WipEhJNPp0JCJ
 5S0TCjiEaMGhS7Tv+uXcqXO/cotg7PMBIkRSt02gUbYFoqEjgDZNrZXRUzZ4wSHh1dWbOl/sw
 qJvx0rN7aEeFPbS+fTLQgHOlUPB4A6uRVLzTh0oSGPpmXs+BgayfD2zrUQJfwkjHU/u862N+M
 +tT6HC5i6chR2hmoF+E75BxtwFZFPMrNLfVa90nyKKYmo+6cVZr5cXE2mtCm9pa7xaSo49txr
 0Hw0wo5AZPojFkQgsraq74smoLrNyFtHX6l42+JO0Qt0C9oDo0CytmFlQF9y8ctbnNFCF4nPm
 CtIdrKDKB8r6qpS/3EqUID7zxVSIBm5ijfIwaG7Mlhu8L2cnq+cSw6w6t803h16eatJ8VC0ty
 1enBFgaUb9KOImqxH50hqC7DW9CGpnkmQq4UTc5clxP+jGdqW+EnCwXzXAAK8Tq/75xe4ORT9
 0k7Kv7c9NIdTQ7jjJHlw3Dzv5o3Gs6n2F7qu7fw1Vcugm9RQkL+oEiiyYB9xcRcJ+wqD80ioA
 mkKPRDPCxgwxklnRqwrlD6RO5H3eS7pzNw3AQPJXE4G6BrKQFFORimgHYCZgEP8T3S2QINYaM
 tQ0zZE4PU+ncf2kqrNuMQ1befO/hTXZi3MrIyk9zSQCAW/8U0r/vp3O6jnXXX41NAONKrvdxt
 w64yq1xYtA0matk40zJRd2GdQcYBxX9qsotZm1pzx9E9nyTi2ohbgie/fNekdw2ck9ao9+6Vg
 YG3idxsdetLUijaq/7UmhfHOVgWzObqO7TCUcPy0tybpEQ3/EXq0KulpNc5Cb7U/9jAux0Nt0
 LSTfxxuZSpOl542kSCQ7jVZNJYmhMWTLrbJuHKnWxAPExfxwNoTldvePff2i2N7YcpzkzkUz6
 2Tdm0pH9bJ4WZ8+GbUHlDy/CawrSoE8l2/lGuZg9L5WARF94F6Q2BXbHnI9Q4P5D0qBnlIjhx
 IzsOj9HN3UJ2fwHKH8vsY5DlhIv4JUDLsLyZ1IQ==
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

