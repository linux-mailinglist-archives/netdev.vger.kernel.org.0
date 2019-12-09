Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62A2117982
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfLIWiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:50 -0500
Received: from mout.web.de ([212.227.15.14]:57057 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfLIWis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931116;
        bh=iIcwtGZ7q6+1IJH8HBswoh2M79f+M/HgGj3GZwWb4cU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dXkT1kvsdkuwRbOxQScIQBPCRrzbGwdWzLu4BQCSuuEj0kG8RHK0rIZWCiDspQd5M
         9amJoQ4CO5o7MG1TqhSYNwStoZZaHhMfqf0uvPjX5XoLlHJHLLDT2eQt3yi4GDBgEL
         kBbqE8GEr5gRE6W7jq5qBAxRSxnzotqcIuYJsxEs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0MhOpG-1iQe9W21cg-00MaZJ; Mon, 09 Dec 2019 23:38:36 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Soeren Moch <smoch@web.de>, Heiko Stuebner <heiko@sntech.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
Date:   Mon,  9 Dec 2019 23:38:22 +0100
Message-Id: <20191209223822.27236-8-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JKaU5d2nwpiRHKBLzQOON+w/GWu5jnq3s0cFpfDnyxfLY+ReLv/
 t12RKSkr3wPF+ZXfo6jgBaaUs/Sr54X1V8eD6PJaFVY+DgTx6VMLMd7g5I7Hayx91AKGzYd
 k5/EMQWsoV/viwnF71yh4jM1+SfgE876IVxnXgsSOJm4pDiJ4rGfqvo34S7gD5Dz5PhDPdm
 O10Y1Wx3Kr3rFf+Er7VvQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0gjPZqsxZ3Y=:xsl37Z8u/T3zQJLs0iGiK/
 StbtdO1MulGqkOI+0tC3R05+D2BpUsATmsbUwYvMTdMJ3OpzKLHfRDd68+QV3PPw2PgMwxOMQ
 VpBEc4yTRu71nhJLg1dVBwXFQKswD++aPVZhORWRtZJVzyTlFbMoSj0esJ/iZbsqUYZi7wfIY
 awg05E6yD76DgI1dWcu8OJpCiBzEaAEw+RnKQ5Xpf5AA9ej53O0JN2HEg2b6U45PBW3lbO6Ld
 zvq/bDtAcgnIZWEHx9AGXTGCsg70Rmy/+3Qg+wFhKx6jUDZPfoS6G3Dkffhedq/KZPF8nK7iG
 eomxsBW5LqiZjeiWZ8g5RP4GYJs3pDo3c5+wZSkHcBbKn6MV/2ho41pbe7wBQsau0fxnx5zv1
 6Lv3jRNvabGS9On3sGpkBLqoAF6Z/mHjLQFoMJBo4YSbAIFyFCeNEXqFbaGdkK5romGqZtMnx
 G7t+nZERHayx5lS9jwBxfDjSfrsCRmPCiif7i+7LCvm8yXr0Xg6PVN7vckZ3As7TUSn6MK4ws
 XLlY7Pxi7yL39FL5e0T4DMS8iQm07ItTBluliHakdLdY9uVnd5kNJK3w/9rdFMo0yeGuGDgxg
 7y4KDtPKk6CA5Y4lJaeuQnIAwwqX2eRCZMv6ybx01MK/VJTALX4Gq+yacxQF0ugsgEOOM227D
 jWiLxIeaxUJ3uNIME4qiGPQsbre8UoL4ktZzkrqhmda3AQXQMRhB1utmVP5I55YJWB6FQ1BfR
 Mr5iI1kkSe8S90bv1BYE+RLxrcyW15NuOPGvjA6rILHH7iespmAjLPpZuWX9UbQPPEABU/l+b
 5t6txaPL48St70RlCaXyt7hZTvBW7zqM0m97OM2TkTG9y7GhdvZlDEdKZCTlsBt90P/4b3+K5
 zV8Hj/s8t3J8Qwgcbjl0hzuZrSqySpjqixTY+UChyQCn5mWzv9XbbeSAim3v/pr0dUvUh6A9W
 ke1lp7aR6krzNhehMW425OFITdJLWWRuNxuJZ5W6Y5BqCdtk0N3eD6mxMrfY1E4iLL2uIFMI6
 xkRoqTp4UpoTsXLD7uuaLOZtv7VBPFaeAqhgNX9U57R1HKY2gqEtzc5v8QvODnm4tqkCbJbUe
 x7LcBmKEXxNOayGev5jeN0fv/PdgLlSuzuF7/uSs+LkiMuoa81CQHIGEth1eoBf1hqhQgQtZf
 Nov8rQce8IcauTPloExst3Jp5mukVxxMTCBUioixs79KP1H3m+8rsf2p07s9mkEvvhVNyS/DA
 S0zQ1hJ9bCHz3dLOuyHMO/ZL6CGjuHij7UNTIMA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
The BCM4359/9 wifi controller in this module is connected to sdio0,
enable this interface.

Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
Not sure where to place exactly the sdio0 node in the dts because
existing sd nodes are not sorted alphabetically.

This last patch in this brcmfmac patch series probably should be picked
up by Heiko independently of the rest of this series. It was sent together
to show how this brcmfmac extension for 4359-sdio support with RSDB is
used and tested.

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

