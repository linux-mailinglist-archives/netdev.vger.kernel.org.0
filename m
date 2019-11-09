Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21BFF60F6
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfKITCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:15 -0500
Received: from mout.gmx.net ([212.227.15.15]:32943 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfKITCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326042;
        bh=am5k+ShH8U/QfQdyBRZNILtXr6ux5dgQyoLfNDeiNlM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cZpggyVblENYQ8ikzV3r4BcTVr7iUbdFFO0vGhP4E0prQQMVaC8FJjxNXMyaU0W56
         Yc5thYPFmb1lJKMv7B4OJYhsC/JCvZ+3pAT0c08PmamjTxQ3iGpKwTBA0yqaCjKw+V
         iHozUROD3nlt/ZFPCp614kLZ256rHiRBKqx/jMWg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MlNpH-1i46K43UU9-00lpmk; Sat, 09 Nov 2019 20:00:41 +0100
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
Subject: [PATCH V3 net-next 7/7] ARM: dts: bcm2711-rpi-4: Enable GENET support
Date:   Sat,  9 Nov 2019 20:00:09 +0100
Message-Id: <1573326009-2275-8-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:0oger14fwpFQo8s87jr5yrqC+lDUCdi9IE6VdOjEBDE/rVbwlzG
 iYpUGckhrV1HUKj3aVRXJXtn539zkzIoK2SF64wVFeAuCzWN8DX2l9ceVSn0kwMh5XhWzC/
 B6INzHgRuZOyaLx+NmsM2obXgb/BvEUDD9pP9QvGESGr1wBHHo+zkbwL5TKxXiIJpUVyRNw
 lhp4bRTVvUJCxnouvN6zA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4+Xt7+RTBHU=:VS24gW3EpEapiurPZu4hJt
 763PrKk9aWi5WOTtTm4JoR/QNX6LR6BiEU2LFDwfYpUShTl/RZO/GDKiZj+mEuTFMlrT4lI8X
 247uhgbg9an/tvWNkSRH6hV3y1/RTy73ODaw+Rd7UXhgcb3/7VrWx9gG5D3z61NF1SGf6pZJ2
 NV05iSOBPzvKoOFV4T6K4fzbfO8k5UQHQGg1oKtyzbNcbjchK9ZCZvEwY9pMkSb9VsQcSb5sK
 TIeolYc3EFyXHgYF9H79qEEOjprPdyrUgCmng66MYqX6C2nsoKRdcAwNvymJMn3394FooYVV6
 /IK8047Gx06UQHD7+BhIMIBIc3HfiPgNMnpuWAVQdUhJdyV1GsVHpAIeiXsiIGJ93jOza9Q8R
 V51bVR4vdMatyhZe7jQjFC6ba3xNwGw5eIO7BeIcVnJV/tDfsSzh6VF11TjzBTj6OgwEzA4ZJ
 HY4tOjDIraslDfEXA6tf8p/AkgSaX2GweQKrotJSEljkpIbdtBk6bffo/pqrqyCzL9C7vhi22
 erFF864RjHqznNyNv/Hsfeju//xII5u4uqG773jo7IHQekzED36ZhOl+nfVzOdA1bdytv7ap4
 mRl1eOWUtYx0qZpQY+YI5CrEJhWZXb2eZ6nt3BWBnAqLdX8vf7TdcZjXt8SMR6U3R1SVWy+KO
 A/W4aKCJllzntt6uyw11U5+UOPTF+CrCoSiY4EUXf42QRppymKXDi1wbunDF6SJoGmDReFXAb
 Tub4M+3VRI1f2msUIzIadh9Bgd2G1YPqlxr9euWOI3GvrfTqs88gcYYJQ4Xu1bDR5HcfjpeJN
 Qsxrbb6w39lLTZBa6iDbGMSmbtHDU2WlJ7ShIII3WeeCU8+U9+ijmE93NsxvqcvuSHCai1PHF
 V45l28+cQl2K4ipHAFyhItEX/8pFhx2Sfz8O8qbyOUlXLcRe0lGixPW7YI9v2tgkt3DKMA2Rh
 mUcdTy1GLDtRz3+NiBcD9IdtEZawhj9LUYjfvOI0SNUaM4x4lwfBah6l5NhrHgXWRIdWQdCna
 kkYBn2CkUvceytdXz5bb5HtQT3eWDogN/nsdENu63ji8bxLBXlG9e7Dt9viIT/2Zj0zSN1H6s
 ThWvnH0qA7mR6pfxs60MGEaPvXfS9hycYTz+ukkAIwa+uFTfrx3H+rZ+j/zxfWNZrUyj4uUGi
 /FjOCMH65RqfnFm7hh+FmyIlLFQB0f7eOkd4mfhRjp6LZkuJf0iIFKhTY9iK1HVv5pEcGLXbf
 W/+7Kvd3ldYzOTQV6e5zP6k1EkJL5Epyz5aMSzg==
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

