Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C7111C0E4
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfLKXxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:53 -0500
Received: from mout.web.de ([212.227.17.12]:43363 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbfLKXxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108399;
        bh=vpmcxnQM8xeIOrgf/nLMbY75MJAw3JLGxT3wkvLPkbo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BzrHW2OM7bnwDihbgxHzNh8UPyn71b0KWUeLA7jUPedIlK3QHYVlS0idBZM47pmbx
         u/s2Oorz8KhTT7wAZjxE29vQzv+lZoxVuVp4hoCqQLSOFesdNtpM70cAoxjkN8VesG
         2tWns90UzykDW0PtQzGz1+jRSE3N5Me3UUJVdcqs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0LmLoU-1i6PGv079u-00Zwng; Thu, 12 Dec 2019 00:53:19 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>
Cc:     Soeren Moch <smoch@web.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
Date:   Thu, 12 Dec 2019 00:52:53 +0100
Message-Id: <20191211235253.2539-10-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5PDFH2F0gjxlcHEJO1q+UhhYMk5qrPh+R32KnEj09Ga2cRHNb6a
 WRvTk6+wPGns5t79V6A5yoGWG8mUNT8/17s9oA0//bPLHcW6hDWVFW/oVkXNIt2bhpPEv0K
 lJgNfkZq5I4mKhPg5g5ld/AlrjfJATF9j+BESdBC3KhzSqzdzaYD6z9e2CNWxmPy1A8KAmw
 LisOj0yPMWY6dMp/VuCwA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tpVInoJ1RDg=:TY0Y8jY4BRFGaskvGFkBNh
 jwQgF+B6L5pOwcYFelXXSOSs3JUoLAzMJmi3lQHZG3zagTYa5ec3EmFKy2zWyjjkqDUYmfbxM
 SklKG+S9WrhxwukxqP48U1AB/c/nkv8Ff2Xxxxb/v4YznBy5PI9OANBHdeperFGLIG2D117rG
 RKU4govznHCUe4vzIx50qc3MBAAnQ4k2axKbCjCdQU0KZy+HjR1nMtaVUrRwb1ea0HyzBwg0v
 2oCg2XkNnBcaXqHeWTlqOG+FGoqnL19Syz4pKB+6GznH9jaSzQ49pjSd0q5JW5aw0gpCIqDdB
 q9HHB2tBJnKWHpvNmU7FfDZLZfcQPmWdK9owN/pIZOECF3V5KEXziEn6mZqordxnGDC/EInQq
 Lc4ISJgfJXU01ERmUroP2kb44G08JMtDG/qID9OWX9Gl74/gmZYYw8gCDf+xFPfg7ne6iZAqC
 nac05Sz6FjuQUc3H2J4BQcykdjrcBmF8s5qPACTOr5o86gvN90J8gCo87hR1QOGBaw1o/hHXh
 C20wpBWRlzCZSb81nOVbKt8H387nsw9GoYEnXJ3Ib3laZ4zoX1Zuk81CECo4zINJuY1ZTzkVb
 DHyJrRg5Tizk1YhMJ6y4BK+AgXsuWHS/7hG65fBo1U9e2+rWKIdrPb0ik4QJfDN01a1Ze9IpZ
 lZiM5ydyw6NLK9fS4k8cOWwAEE68qFwCMz5otMcDMUqA35FbAGlyfa12OmyhuNpOH8bNZfuCU
 S7kgGnpZm3AvTqOyKfJRic/h9o8vQtE5hSm7PAePDr8nPLp3PttDhdzcURTllw1Nhm77lMKTk
 q8h8HiV8VS7tg4nviLnyDNvrXDnDmiBB0fGzrRCyEjLQlg4wNk8r+WEXd64pLBrrYZYLr5UKy
 gFlIeqT6utsFoLYYGvAEkLXzJgj3ByToaly7FQr1YJej5cze5QoWGV3qAAfUBCnwXk8cBurre
 Il3LMG4GJKHlRMmtui9X93CJgjPhpYIwZ3FjYfOkDvlTs6Jz9IrOM7Dyd7gXPNGtpHxY8ZRPZ
 wZYfDyXjuZ7Ttli5eXTV6CgECOYT3ldVewSf8S96IRRbruiTZ43w8oe7R04a0mxVwh30YbRTS
 EZBwgktnaiZGCVaau1310BTCnvJMj0zHgswDCshOMY/l8q6kzKyWK4+ZSNbj25ChQuw5CBa6N
 W8cppyIDzVq9kBEvrDAiEUoq3h94zApYs2Lgs2Rb3fUbwaQqcf4n0XEpjL8FdAxA6sYX4gwGK
 viCgHHeD+54tWUevFFwkG18p6Ilf+g0GP4UA1Mw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With enabled wifi support (required for firmware loading) for the
Ampak AP6359SA based wifi/bt combo module we now also can enable
the bluetooth part.

Suggested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
changes in v2:
- new patch

Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
=2D--
 .../boot/dts/rockchip/rk3399-rockpro64.dts    | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm6=
4/boot/dts/rockchip/rk3399-rockpro64.dts
index 9fa92790d6e0..94cc462e234d 100644
=2D-- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -561,6 +561,20 @@
 };

 &pinctrl {
+	bt {
+		bt_enable_h: bt-enable-h {
+			rockchip,pins =3D <0 RK_PB1 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+
+		bt_host_wake_l: bt-host-wake-l {
+			rockchip,pins =3D <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_down>;
+		};
+
+		bt_wake_l: bt-wake-l {
+			rockchip,pins =3D <2 RK_PD3 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	buttons {
 		pwrbtn: pwrbtn {
 			rockchip,pins =3D <0 RK_PA5 RK_FUNC_GPIO &pcfg_pull_up>;
@@ -729,8 +743,21 @@

 &uart0 {
 	pinctrl-names =3D "default";
-	pinctrl-0 =3D <&uart0_xfer &uart0_cts>;
+	pinctrl-0 =3D <&uart0_xfer &uart0_cts &uart0_rts>;
 	status =3D "okay";
+
+	bluetooth {
+		compatible =3D "brcm,bcm43438-bt";
+		clocks =3D <&rk808 1>;
+		clock-names =3D "extclk";
+		device-wakeup-gpios =3D <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
+		host-wakeup-gpios =3D <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
+		shutdown-gpios =3D <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
+		pinctrl-names =3D "default";
+		pinctrl-0 =3D <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
+		vbat-supply =3D <&vcc3v3_sys>;
+		vddio-supply =3D <&vcc_1v8>;
+	};
 };

 &uart2 {
=2D-
2.17.1

