Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DC811C0EF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfLKXx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:29 -0500
Received: from mout.web.de ([217.72.192.78]:43621 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbfLKXx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108398;
        bh=K8Vc5xH9CLUyhrYV9Z9NpTgYitA6qCYeXvgl/cznLdk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZhH62FngPLmTZ+IdrSHvMTvuAiMhumBY/SSyMoqsurhoPfd3fZXaEoxerGDMPlHjc
         RGGgLowA8MYk0+FXeCMWwDc/e7/etUgg+Rm0lQGOXje99HVfuqJFRZLzVM4cvsk4c5
         WNIBYFcBe6Huwt27d8GE4Fxc9fUdRatekxMjDJtc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0Lvjiy-1heUNt3nx6-017VQ6; Thu, 12 Dec 2019 00:53:18 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>
Cc:     Soeren Moch <smoch@web.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
Date:   Thu, 12 Dec 2019 00:52:52 +0100
Message-Id: <20191211235253.2539-9-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:L21aj6hQ1G9ozqVXJyR+jL3/TO5bynJLSxDfhNGSe1Rw8oAm7Wh
 SVbp+ikLF/2EPn0nZmcvm5YIG1HCByn4xEDa6rPlPUysF3CFVxpvW50QQTgeJolHioJK8a+
 vdtFIORtgibmAbPh71fTBffw+MK2aNpzNorAtB3WPMz41+9VonHT7at7a9EV1JZncEZYKD9
 RngAU5nMIJf2AKSkXN0KA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YSBqNQLYU1g=:j8cAXIxiWNNd35q6LT3OgX
 GeM/7AHZpfcEVoLkEe0tdIkPDboYEbx/M6sCY/dFFjl/xi5QWOsUGg5Mtl9vpb3w8V61El126
 6ciCK/PWyuYSXsg5t5NKcZNeP6zqNDAu6w6NBnWjC1YPkMSCaMLmXCENzVoxQTm5XiV2KtbKa
 hlt/w9GlUq9hBprFAIsIQEamSJ6LTXNfbVm21xplliLvq0qQw1wKEoEh9OQMcVdDARFOUvhQw
 ONmNaMTaTQ0zy3RN1lEKVCHcmykRAnmPKlwRULsUy6b3NG/J04bDlSSp/5311GpYSRI8TCTHp
 9WrHbOdmI9sV/Oq6TAapfArLVtA7SySEELnaaA/It6/YyyIzqkm5ah24+1rrvFy5uKx2UdZIg
 +RC5KFBVqGkUN8gLqZrJgg6xb3gsLJgYPecb0Q9az1mZjoqH90hyUDsofJGDFkJ101FQwYfcx
 3G2941vByhX8BLwnpI3Z4NmUqe4kk/JNuV5zzoShWAhKgPQcnxv3HfFq5gozRJGQQslgQlWrJ
 VEIAv0fvnCWyKkIGuoJhSiqLKScs5BoGqrhpkAcJQ8N8Wt3Q+hLsoEMw0tCXz8FXbp1iScb1c
 ZAEbXhR/9ekLXIEQJI2wQYahmWk8+l/lN76Nka4NLxxXds4RsHT8hWBbvDKtCSC98KJRdN9VW
 b2bUPH129AepFZWXvVbDJE9VlTg48F4b2J/bEk3uwgvdoPlMArK2NV+i5p9gYQp8vpH9Bz+ab
 lVQn7AGzRcroUWIr/SjYVm58CRjtTXR4w1LP5q4jDl0wzZULOMDgH1l9vVgTtjIcDhUO0tGD/
 FgJwFX6JpW7eyPltGaXd3oxs3wPuNPaeJuRwI/59N9TViAzNpNjuwTQQRxZCvIOTXXw6Ijx+i
 dIyyAZyTFUTjKJxqCharuCPksb49t5hXGDWd/4H8zhr05gldjjNXJyGFLQiCcGUoTwKtj4WMO
 8vjeAgaV1S5ZrCyZ/phs4zowE5RI9e/SK5of3G3rnuO+LnorAm1C9zU0vO+FBh5m96e1AhNN6
 8rxHhOolIq5XgOCLE+LY4FGU2LrkWy6N88hYlH+S9wxT+e1YMJ2D8bT7ogEFOrRjnxUrKn6BO
 79fvSsbso36Q3YyJtWMP8mQ65M7FlfDE912iCJ2NJkZ4iejDoP6SVcXJAU6HEc7YUCp1cqt3+
 iJFon6kjMAfrt4C1HCGRy50OtqZYYXkeu5FeVrrvuk9+r8u2vT8v/Oq0aRQLoyg0MESknOIQQ
 f14pcRgZltqtlGM4+1o8kmNR/eYGRFzOoLYk//Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
The BCM4359/9 wifi controller in this module is connected to sdio0,
enable this interface.

Use the in-band sdio irq instead of the out-of-band wifi_host_wake_l
signal since the latter is not working reliably on this board (probably
due to it's PCIe WAKE# connection).

Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
changes in v2:
- add comment about irq in commit message

Not sure where to place exactly the sdio0 node in the dts because
existing sd nodes are not sorted alphabetically.

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
 .../boot/dts/rockchip/rk3399-rockpro64.dts    | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm6=
4/boot/dts/rockchip/rk3399-rockpro64.dts
index 7f4b2eba31d4..9fa92790d6e0 100644
=2D-- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -71,13 +71,6 @@
 		clock-names =3D "ext_clock";
 		pinctrl-names =3D "default";
 		pinctrl-0 =3D <&wifi_enable_h>;
-
-		/*
-		 * On the module itself this is one of these (depending
-		 * on the actual card populated):
-		 * - SDIO_RESET_L_WL_REG_ON
-		 * - PDN (power down when low)
-		 */
 		reset-gpios =3D <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
 	};

@@ -650,6 +643,20 @@
 	status =3D "okay";
 };

+&sdio0 {
+	bus-width =3D <4>;
+	cap-sd-highspeed;
+	cap-sdio-irq;
+	disable-wp;
+	keep-power-in-suspend;
+	mmc-pwrseq =3D <&sdio_pwrseq>;
+	non-removable;
+	pinctrl-names =3D "default";
+	pinctrl-0 =3D <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
+	sd-uhs-sdr104;
+	status =3D "okay";
+};
+
 &sdmmc {
 	bus-width =3D <4>;
 	cap-sd-highspeed;
=2D-
2.17.1

