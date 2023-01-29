Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2664367FF39
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 13:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjA2Mth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 07:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2Mtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 07:49:36 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CCE1E2BC;
        Sun, 29 Jan 2023 04:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1674996564; bh=JjSLd0m8cRytyvJTD2h8ilJ4qprOTJIhhPyxhW1Hs7M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WYhpWPQxOm7A8S4H4+YBbhRKOw/lEN0MzGaJzVaFzLAbwuu0qZOH70cCEYv3AzbDE
         a31G6KvCyRMbea+br5jmmMQm0fFjdm1ljNOm0Id2OO1pvkcWKH5Xtk0wFpCaZ79okn
         9ktF532/5WD4Hf5UHqGriGP4ZjwYk8y7DI8qJEP7BpREs/1EtFFpJ2dfF/ch/EV1Xi
         bnquxJ41ALG1Jt7ovudZbWvKrsV5ghRwGZAeuTHuUjC2ZPzb/Ls79elts93xMwoskn
         IB/g3SlSNR2JqvCILHa+LQM+xi0mFfQEw13ypsFzUrC17gnsVotFljBJPqtZOAUlXg
         4ajGuV4/0T3Bg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([95.223.44.193]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mwwdl-1oSutz2s8Z-00yNTj; Sun, 29
 Jan 2023 13:49:24 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wl1251: Fix a typo ("boradcast")
Date:   Sun, 29 Jan 2023 13:49:18 +0100
Message-Id: <20230129124919.1305057-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ijQXBCwdC00JRP2C79RCUndGcFf6aXNCkRiUS+d0Xs4LzjmeRKr
 eD2pc3hQsmGq/UedJfaTUTqxhaqN5bIcc+aA8jeHIWmBAm8D5SeXH7b4ay7ECwFFMyzFMgO
 +bdOJPivDMhCDzxFmXGAYOynnEDESvhm5Zf4IHxPogw6m/cUw/WQnDSmT91dyp5shNxal56
 mKoGl1BE0a0ZA5VE56Giw==
UI-OutboundReport: notjunk:1;M01:P0:6HIQhe0tTsI=;wWunIsnufDb2HeOu1FgjQM8684R
 elQTRIyDhTfDqtqdHBdTWh6HN8ifIT8q2h3aB1/lRqE69hUsm4fdf3MXEIn4gUbdAnM/QDl8W
 4VR3P9E2FSvN222u7MC9KbNs+CbNozdxU2QLktV4XdV18I5mysdtltCQ+hMgZ4M+HTLZ1wxiD
 /b8UY/Kn0XYRwLisKacxhG9WhV0bmB1pZUFknRT6JNAGUXvZEV+eTeRQQacq/D4XmoaptHTst
 UOHCaDVCx3c0OuMTgzRp8PNPWkZkGsfKL0c2xctfV5nAN4bg9k0byNYwjLdL6PTaTCKKXo6l7
 E+N9foSKxvGs8IteCiYRQwTqseHg6j3Qmp/GHVmd4jMKD1UHFMNGetmdJu38bjigdbpv4HgJD
 HtEC4g68bF+TnHXAhITfAGbsFHBCGM0JLQQzkc61gPdXkQ6j3yPMWGzbRu9CLMGeM1O2qrhHP
 AwF5A0qTIhsT2lemGGO2yjikFa2oe0Silt5pqjgbT1Qdzoo6FUdioyCbgYoXuicy4jN3QYT8a
 0O+kiYc90wiUcItZFUzS7HhPtlhS/21zwIhNteh5rVwq7NX5jKmk6EB8+DHxENVyHpPfTmUX6
 xhKyX0U6mwjXC+Xd6uK95A5yR1Uah7O1SI7zOuk4ndKLS7pPRIXKEn7FjFtHV/N6edj7xrd9C
 xFhGXwLwH48TZ0GU/I770oWL3ueG9hxIFPA8+yJ6OiU8zVM9ASAVwahJawjlOmT7ArM3j4W1v
 ZxCTMowDPXivIGAaWasf5gyfbptR09x5WA4tjqaJVtwzEXYE3KmVb3pD1270nvZcubyKrzqYZ
 lO2NUDGr8hmPxkYiW1Q6hAHpqiETdxc4JbG2BX/rJdpKVF6nJht24cEJTxF525lsIYxjctLIu
 QUM03/Xyn1+4hgFTHKkPZwibCDHSyx4pywm1rtdnnw9MGKvQMJMfzyedJPkI40zIMSgw+oYkW
 OfhIgy+qDO0fgQxJb3coI2DP/jY=
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be "broadcast".

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 drivers/net/wireless/ti/wl1251/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/init.c b/drivers/net/wireless/=
ti/wl1251/init.c
index a19cce3a7e6f0..5663f197ea69f 100644
=2D-- a/drivers/net/wireless/ti/wl1251/init.c
+++ b/drivers/net/wireless/ti/wl1251/init.c
@@ -373,7 +373,7 @@ int wl1251_hw_init(struct wl1251 *wl)
 	if (ret < 0)
 		goto out_free_data_path;

-	/* Beacons and boradcast settings */
+	/* Beacons and broadcast settings */
 	ret =3D wl1251_hw_init_beacon_broadcast(wl);
 	if (ret < 0)
 		goto out_free_data_path;
=2D-
2.39.0

