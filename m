Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68520418AEE
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 22:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhIZUU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 16:20:59 -0400
Received: from mout.web.de ([217.72.192.78]:55573 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhIZUU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 16:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1632687553;
        bh=YAZx6uMTn8UHHnGn3OyHkQnyCYvNpVezM1nufQAewNI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ZYhkhKPSEha5vvIK8h/tNpBMZEJKvbi5TXZ5lrDWNAj6xOGL9plqfJi27gQnLyOUL
         QIE6bAapGEBPnYH32f44IHALlGdtxO8RSYwce5wOyDVAb6ujPUzQhMpaM9cEM54E3d
         r2Ol/2Ak4meAe67+7OWxLwLm/Z0OFYEZxfwCuW0g=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from platinum.fritz.box ([62.227.172.72]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M9ons-1mfdFJ0C40-00B49Y; Sun, 26
 Sep 2021 22:19:13 +0200
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Soeren Moch <smoch@web.de>, stable@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"
Date:   Sun, 26 Sep 2021 22:19:05 +0200
Message-Id: <20210926201905.211605-1-smoch@web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wiw80L1xb1bzJTo8zFLnmmlAzMynYyYcgNQTAAK6uC5sezFBB39
 hc7rOYZIBXhUo22/bStfWXbQeb6uwY8l6ilCCl8W/pu8oBqrzPGcftlMKnG95WLbH1g3LtH
 Bgz3tEfi3NJ/R/5s9qrOaIpLQEpw1DeJmmQ0qTI5/xaUEU+RYJjICwjHPB7ZET9GPdA56Kw
 Nxi0F3xE1bx88rrfXVGDA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lYOL1DxY8Oo=:TBkCSv6ALwh/Fk2KN+eEa0
 GP33HqqrUK1Y8qTstTqSkaKBIlgTC1EQnZpH432/4FwtAxJbXGigC8B7MlHpDc0Z6SKCZgPxd
 XulJ+ju7ybJcABtskYOBgh1oiFrmEEf8R9onWHfkh8fZrtOf7q4sGia8lNADD0QKkRqqPWKtv
 +e+7vFRBtWONY+nsQNaheciSi/btSRxs8Sb3VgiKP8KcPzGpVuWUCWlP06kKZB+V09yxaVDPU
 /2qow3gWTtxGxdUqOWXqwHz/833PsqEK9I+LQTohQ2UI01335e/NlxrRdXNIazYxv92D4+46n
 kjEucKxSIYWTlGxr0XoN+ZkoQR/4xV0S4+ui9/dLxh3If2AjaFCBN46/EiCUBw4daVLgxlLnK
 ehmdBM6Q1EzLaCpWeYYfFblaOfOA3fnLMgEm5a5BbH+dpLZPkgvnIXx8MKKaWgt/UZii25whU
 V6qVTD1XUHL3mICzXur+IJLaHpEoC9aunIYf6GsAkJErN84lhdwvmqNvuP5+SB8yulZ4qvqBg
 knVLy1apj5pQUctaSqHfIBsu2Jh/NO4dX2hG8Vbgi4jJP5xx2cl3sS7UZ0Wa/AWRibPl8f5vd
 FfoK3Rt14THczvJWfZbvB/FrvEJIPT3y3rhrIalgA+0qWmKDjVWPwZ3GvaEXQ4MaV9DDpm2XO
 nfaZMsuYKx9t2O4jF5E6LQoDiji3jR5YzJEzsKWclJHY7s5DuNUBFt6rKL5CPPOuQ2qrDjLfw
 hz1pAEhdCKzN9fRBAVDAcJS7wF0al4fJml5GU8lm0WO9lXyky5KXYurMtbOaEmGRLLBviR1ns
 +pGGJvFasjwMxMHLmVy2MoA/DTc6fYUGcyptedPHfgdOqWd3k/fJZby/4ZhkuQ/i5LutxTHme
 9V4fXjVx84jmM5P29IL0LOXQKKIWHWCGnZuriWCI/pb4vB0j1xf0xYDrgW0NoKH13g/HsL6oB
 FU9gUaH1MJAfKpKGtgVQ8kgw8VREIoKXJ55n+cFx+xnnn74TsYeAG7cmDkwzzaGum0VYwtZqq
 Ir2bKddjH4BzOJ7re+n7YyNw8mMrrB0dfcLF+g7ZrtfHHnz2zCY0kOkBkyfCAN6yZbiZrOu7Q
 31mZqoh14eMIsc=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b0b524f079a23e440dd22b04e369368dde847533.

Commit b0b524f079a2 ("brcmfmac: use ISO3166 country code and 0 rev
as fallback") changes country setup to directly use ISO3166 country
codes if no more specific code is configured. This was done under
the assumption that brcmfmac firmwares can handle such simple
direct mapping from country codes to firmware ccode values.

Unfortunately this is not true for all chipset/firmware combinations.
E.g. BCM4359/9 devices stop working as access point with this change,
so revert the offending commit to avoid the regression.

Signed-off-by: Soeren Moch <smoch@web.de>
Cc: stable@vger.kernel.org  # 5.14.x
=2D-
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-hsien Lin <chi-hsien.lin@infineon.com>
Cc: Wright Feng <wright.feng@infineon.com>
Cc: Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
=2D--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f7b96cd69242..9db12ffd2ff8 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7463,23 +7463,18 @@ static s32 brcmf_translate_country_code(struct brc=
mf_pub *drvr, char alpha2[2],
 	s32 found_index;
 	int i;

+	country_codes =3D drvr->settings->country_codes;
+	if (!country_codes) {
+		brcmf_dbg(TRACE, "No country codes configured for device\n");
+		return -EINVAL;
+	}
+
 	if ((alpha2[0] =3D=3D ccreq->country_abbrev[0]) &&
 	    (alpha2[1] =3D=3D ccreq->country_abbrev[1])) {
 		brcmf_dbg(TRACE, "Country code already set\n");
 		return -EAGAIN;
 	}

-	country_codes =3D drvr->settings->country_codes;
-	if (!country_codes) {
-		brcmf_dbg(TRACE, "No country codes configured for device, using ISO3166=
 code and 0 rev\n");
-		memset(ccreq, 0, sizeof(*ccreq));
-		ccreq->country_abbrev[0] =3D alpha2[0];
-		ccreq->country_abbrev[1] =3D alpha2[1];
-		ccreq->ccode[0] =3D alpha2[0];
-		ccreq->ccode[1] =3D alpha2[1];
-		return 0;
-	}
-
 	found_index =3D -1;
 	for (i =3D 0; i < country_codes->table_size; i++) {
 		cc =3D &country_codes->table[i];
=2D-
2.25.1

