Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CD7614FF2
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiKARDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiKARD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:03:27 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A60C23A;
        Tue,  1 Nov 2022 10:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1667322179; bh=aOCWvJv79NgDvVom/w2tvTfFXKGbJM6sKKH13IpFB7M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=cPXfSJnNEe7Af2shXadKlGtOB9k4GYomCl3adICnN7605fjw49FFA9XOIzgfgaRMI
         T38p+gKCZFzzQcx7TsRRp5bloGrxhCTV9k22LUVYtggnaNFGdn8G59nUOb1rE6COKo
         xKBormN3c/hVbehoeVb7AQch95jyWoUhBAvAKOAWfW6GeadxLQAveYxgOvXkUvrGIF
         5qf8bKKG9DQqroZCnKdXWaYle5fFE6vqYrxWzd6bO/no+jyrAtpm4uuglyWFGbn1xs
         1xyV07eeET8B4HjFlWpkmeP97LSwOcWMK83r975NEfosxAdnpEatuQUw0K48NHYYCT
         wQVWDUjotOxlw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([78.34.126.36]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M26vB-1orqTS1xCz-002V1o; Tue, 01
 Nov 2022 18:02:59 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marek Vasut <marex@denx.de>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        linux-wireless@vger.kernel.org, SHA-cyfmac-dev-list@infineon.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: Fix a typo ("unknow")
Date:   Tue,  1 Nov 2022 18:02:51 +0100
Message-Id: <20221101170252.1032085-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GcER9f/7uFGjpZ+1KOFLvDWHE5DVZelh2ZhxzaDDgDVX7diSkt0
 ZmUNYKrpVyv3+0wV0sRieNm91J69Lt8QxAzmLKNuVaeQ3TOwgRRw+xIsOWjanH5C8w0dv1y
 n9nicRSLFzb3BANAaDDMi9BKd5wSuyce4ycDKowrdq44fjokl557JYmu2BhBqjjRGBPwZE0
 +QTUNBNa0sodO76WO1pRw==
UI-OutboundReport: notjunk:1;M01:P0:EdTa8okbI7I=;ki4E2lA04s2fuQlEapZCnLZc+xW
 8aqieMN6lRSdqh7m1HOjTxcgxGbHwX2gzkrniKB6D/MmRdjEzUEIKR6SCI8159QoAu5rWpebz
 QliSgsKXBqfbI4zeNVFYeg37oRwdinH4w4fGkQXv7MnWwSqltklaJvmdXnJaeqkx5P840f4Cz
 Oe6el1fxVRzSgHjMGms9JWKNs4rr4mMR5xccAx1ZHiWhcADr96Sn5OuwSQ7kxg7FYr9L5kKvo
 hv7TrFXF/3qJKMxErWuWzShM+6bzKYG9koTNOBznMnawJZlPnsunasiAHcChoTewHA/EgNaxQ
 yZ3E9Jh2b+QHPP27um7Lc+VGFqC9OdkagcMze5MedmLTCK9KXZkb5N0Xpb2pX+fw+6lMmCbn1
 oAYmTQ9NT4S8zt/43AVciJn43pjib7l/ccrfAYUWWEqPTc5ZS/+PR5blD7paf4L6VAnBTXJTh
 vFyNPJMfkP4U0SIi/AgEvnnQVT9uXNerkKsdCKHQZ0MzymqXqhxn/EM/IMNL35N9Raax0AwIk
 KTlGPRQYXHAEoeGUURXF3RDrv9dbWyN5BVG2LIB0Cwj+iXOUyQdlVSvyBu7KfFggCIZVedW2j
 pQ8KKxbH83nRQS3xrrkqQ1qYED2oGd2wgxfkHSsiMzaFRFRFKd21xzsrvDDxlu3Kt2nGr+DQE
 Vik/NPr/CVZLK2ImomA8q6HF8W3AeS2y3G5ol+it5uEzsi6G47eLvNN64HJPOfZmPXMcvYwGO
 P3vTVea3pAkFcp7JLXkbUp1Zii3WyG8JZAakTa0H/nY1Ke6Mmu0S7fgD/cSHfrmjBuXEVt5fD
 n4q/bYg9TG6J7yyfRuIfuDolqLj21AntVfTDTdLYm3u9DA02eip8/ZW35tcra6t6h9zjdO+pE
 CuuBh4Rr375wpkselR/8Y+NFIKf/qhDBUlXE1N9+cl0ru+zDoHJo5EMGKXpZgGU3UD7OWUvOq
 W/rV4g==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be "unknown".

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 465d95d837592..bb3108c3af93e 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1886,7 +1886,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio =
*bus, uint maxframes)
 		}

 		rd->len_left =3D rd->len;
-		/* read header first for unknow frame length */
+		/* read header first for unknown frame length */
 		sdio_claim_host(bus->sdiodev->func1);
 		if (!rd->len) {
 			ret =3D brcmf_sdiod_recv_buf(bus->sdiodev,
=2D-
2.35.1

