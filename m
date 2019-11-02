Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0694FECED8
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfKBNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 09:42:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:36871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfKBNmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 09:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572702116;
        bh=h+XLGZgaXnLBawlPiG/UWpDjzgvkaAmMdoEeD7J3xyg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=c80KcgMJP7AgUKG/w6d+GdeCPFXqmxdehl+zHf+COyPYaUfCxPeG3S+grz0PUYOEU
         NfhVpH6lePgwjqNojo2OrmcIbySAkSa5Jzx4ZTU3PZDEVhoebi2ht2DE8OFqZUMvtK
         mXqTCU/Xbs0fjJCQu3hiKWR7YsWvs53f3TEmJBUk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MY68T-1iRqTx0JHJ-00YSmX; Sat, 02 Nov 2019 14:41:56 +0100
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
Subject: [PATCH RFC V2 6/6] ARM: dts: bcm2711-rpi-4: Enable GENET support
Date:   Sat,  2 Nov 2019 14:41:33 +0100
Message-Id: <1572702093-18261-7-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:N6m+f5BFnGoJCatvwlFDrW3tbyCRprl/nNngMCQxjVeOZVZUmse
 crXhNJXNNQvkCLfFuvNH7TSH7iNjlqiwG4NnCz7Y1fxERxRdQgDMGxSJDy8Y9XUOfrHazvR
 9GI4tJ23WH4NjLv9vI/dI4SOSmb1taHCpera9yrVB/Xv4kUfrkU3NTJb86vFcV3Yauz6Mxi
 OPJurtK/qCQsN131mN/mg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fpdkccpY6cQ=:+Y5/e/UMkB45uES7ufA1zh
 NTRe3cEbUEVBSAnQz7vmRp4vFnzdv8cIdnuxm+pKTQtIG7vy8w7X9inzCKlNbuJyU3WSZ8/5u
 OOmTTv9eV9hfjavAPNf5bSdQK9h2B5prvUJvmEu9p7r6hRTcMMhZTb/8IiFB5/qS1ssFGnQTk
 mjK94BMbfxWwMaU4W+iCbVXc/EEFJ8vXPH/0YGNSDSR/bBeI4gl676GttsOfHxw6eiHreclpE
 fwUf8r6aOXMpjFHtX6d++DIrrFZE/hSKzJdMyyGtGLl+rtqIXn0u5VEQtNK5arimFykTP4FCG
 VuMiF6fxX/31Ujya4IwBLzF2vtPtb8VPFi15J7Uou4VXbuzqUXwPviVjh92kI67j8jELCoIgs
 x7URHxzPm3ZE/w+a0lmAgaNHdqckK192R9tqFD6SkbUV8YALXHqA5vTwc9RTUr0X8Udb6zkTT
 CMW5hsy2KYoeQd/L628nMwOcSbv02I8R3UBU7khIGm07H3+BNc1mBqwx3SWePPoZRJtMtnE/p
 V+1O8QOQyzaXWMbcLjYcHbfehQ7MmflZeyESnYTCd1tZzEpvSWHDu9tsYKGrdqGBe/p8b3/Xg
 o8GYP8iaH2YnBJNuglN9k18ibia/9q5QDbxwZxCqWhzadMwmJQYPV2CyjaMZW/sercPIUC1IT
 0mDclnirqgYkwco3uCBp1axXeDTJRpsHof1BqOp1377HETvST+0QwghTlrgm6+pyL3L73156E
 VzeD62fxXc+ZgjYj+Yauzu4uQJ+2lTncdl12SbSZ4jl6sYmWbL6nPnrSP4ad8rxnpkb9+Q9mX
 a+TwzxnvnUJL1Na4MqiEAzJmOd6NGxJEXlJjIX+VriCoxg0fpTNfHVHYLNSlz4BiDOt5DzXRH
 Jv7yoKnaEFkX9JQcEt0KzkyQMSunEZPAxq4IZThrqB9Id/18rlwH9DJSgk9e/s4RofZ+bN7+h
 TZlGXIMtPNjBT1Ily+MBBvIr7bWnk4kliRNpdRZekFHKmOpKEUw8+CX2Y4ehJA4RE12WZzQUs
 8c52jB72jqpegH9oAzRuPvn6KWnzmNsfEtu5HkIP02M1IVcOP2Xsx5ylCLP8MUuQbBllL5YAt
 ySlqzCo1PtxLfNra40VBMw0Si6nU5fdZzkJmZB1QImhlAnNZN746Q3so5lGVDpc34kFxJYA1f
 YOpRvkUfsR+RcuLSHPT1ZpwjDkSERZNk78nE8QjDaaa8d73QrJxpmOQ0I0on0z/ptStogYZOW
 XZFUNXthUeQjrdzDtTBbG24poMqxnxV9IqcGLHA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables the Gigabit Ethernet support on the Raspberry Pi 4.
The defined PHY mode is equivalent to the default register settings
in the downstream tree.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
=2D--
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts | 23 +++++++++++++++++++++++
 arch/arm/boot/dts/bcm2711.dtsi        | 19 +++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts b/arch/arm/boot/dts/bcm=
2711-rpi-4-b.dts
index cccc1cc..904efe1 100644
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
@@ -97,6 +101,25 @@
 	status =3D "okay";
 };

+&genet {
+	phy-handle =3D <&phy1>;
+	phy-mode =3D "rgmii-rxid";
+	status =3D "okay";
+
+	mdio@e14 {
+		compatible =3D "brcm,genet-mdio-v5";
+		reg =3D <0xe14 0x8>;
+		reg-names =3D "mdio";
+		#address-cells =3D <0x0>;
+		#size-cells =3D <0x1>;
+
+		phy1: ethernet-phy@1 {
+			/* No PHY interrupt */
+			reg =3D <0x1>;
+		};
+	};
+};
+
 /* uart0 communicates with the BT module */
 &uart0 {
 	pinctrl-names =3D "default";
diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dt=
si
index ac83dac..ff24396 100644
=2D-- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -305,6 +305,25 @@
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
+			compatible =3D "brcm,genet-v5";
+			reg =3D <0x0 0x7d580000 0x10000>;
+			#address-cells =3D <0x1>;
+			#size-cells =3D <0x1>;
+			interrupts =3D <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>;
+			dma-burst-sz =3D <0x08>;
+			status =3D "disabled";
+		};
+	};
 };

 &clk_osc {
=2D-
2.7.4

