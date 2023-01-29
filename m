Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519E967FFEA
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 16:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjA2PkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 10:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2PkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 10:40:22 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4281285E;
        Sun, 29 Jan 2023 07:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1675006808; bh=YiKAXNFSCMlzXoKkRN50AAzFu992yQn7pF6AViDZrkY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=nzQ68EaNjzGHEYgdzdcqRw9HpvSbngSb272Zm8fBXF0jaLdIQzcmldyIDVV039vzh
         PvoYFsPhKs68NVExQUwDFhl3tVq2C0AoLzl0Eo5uQnoBep8gO6i05TCT+o8aD4J3tE
         WFUaV+I97WPXfLw8Iu/liCtj+wcIkWFyg4QzfMkiS+7uxYM8H0OBcBVBQZDpGYedPK
         W6kaPZtaEWjrLHkMIcRWpBbndE8zmlyz8AaV+niOjiMVDzOldhQawcMpybPIhzZLic
         7wNJ9y0QLfIPDHLYLXWoO0G1YIfA89UqSDwlBmjjSTfI/b/XCZ9lQs6oZD/c3rCgdR
         iHPk8WfDvNXVQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([95.223.44.193]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MsYv3-1oXDpD17Nb-00txjl; Sun, 29
 Jan 2023 16:40:08 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: tulip: Fix a typo ("defualt")
Date:   Sun, 29 Jan 2023 16:40:05 +0100
Message-Id: <20230129154005.1567160-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sKYtz7oO7cugsmepK6A5DJ9yFejnLG/pEG/Q9cq2xFQvG5Dkv3Z
 mUr+idcSDZeU4jUiiSahS9JKGJdVPpXYWjOJYKZlKOLVAhVo8Z6uyP/U4/TJ0z3WfDfzZvr
 qYxqVymenrTlMU6lrHmlUdkQWkHfc16vxC1RzvLmjhv1shd5uR1bvzpNPfA3zxYXx5+JylC
 p5Dzw4yKVBJtgOMQhMUPQ==
UI-OutboundReport: notjunk:1;M01:P0:Tp7sUqyx1qg=;Muf6IWuwcg8/zZqXKSiTHlUk2MN
 b5Aii1G1d3a3DNio0lVCBvD+bKa/V5B6O7lABhG+WqfZMPWyaKZ/X0eNc/fUyLNT2w3I65WkD
 wmjdF3zmi7Mz4G7bXHU6KxYYJi8uOH1Xenim3aDxbwJYK978dISfP5Zm083VrpTKC1Kp8+1YR
 6jRu295b77GAVA4tFYeCGlWT3QM9Yfl3WWLyW+vZ9aNc8EQ39yIUbopDEyJ7pUmjcPuSdBQpn
 eUzz+ujq6+R3QGLqvuueGuXjyEKm8NzNZRxeUFkA7DZy8f1TnZp6fsPkjLK5zX6tIJaCGr3oW
 UMGREJhiarKJ8P6atpYZMQpQjH2ewomjT7wtg8q9bTogW6tMKcmKju8hcPFDb3QGkTWK6g5uv
 YrIVDt/Km01hKW+2ULiXC5J9+SV1NZNMgLDVfdOiBvqFMRuTV0dVcxG/KWTIiyH7wkzRhcQ0f
 mlKORSJY6lInBK1r/4VmSkpVNbwFO1MWroQhR6PtjG3/evWsmohCCyLtUAwyRiu+gTn78LC4h
 fZzWTXJ3P4FphZtvBnHdkn7b6D/rtCKkhOguHvLUc1FCE/qtqoJ26PPc5ZyLCWAIOYtEyjcxD
 rMDTeA60ouk7sfVy6eCOWHAzPkM3OPZjsEmeyIvOjLl1XBmdArYC8B1hao8RfoIEvCgJF6d0L
 93t98oey7Vnn1FszN4COu/i8USMxhBfCfufuUP3i4iK4/aqcMigO36U/CTZHeNDVKWkGUThtd
 /wnZq00Y7RrQCEqWrAXOuTaO7n2/j4Cnii/pqMs0wrfzsBLPc2OSbij11B5re2VerzloEB8On
 tV0xe2UPHTstJ142RmcjERU+qr8+q+p0y7pKfkyFQXcIcTdBQ8EsWzw+wv4f7MjWfONRV3BnA
 pGUZgvrqYU/YSkKsQHCB6IJzGFll9Eju9Km3ddX4he+yC6trCaBcsZGPp1BrmTc9XpVSxkmmI
 awGtMGkv0SS/K9KJbVX5nuJAofM=
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spell it as "default".

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 drivers/net/ethernet/dec/tulip/tulip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip.h b/drivers/net/ethernet=
/dec/tulip/tulip.h
index 0ed598dc7569c..0aed3a1d8fe4b 100644
=2D-- a/drivers/net/ethernet/dec/tulip/tulip.h
+++ b/drivers/net/ethernet/dec/tulip/tulip.h
@@ -250,7 +250,7 @@ enum t21143_csr6_bits {
 	csr6_ttm =3D (1<<22),  /* Transmit Threshold Mode, set for 10baseT, 0 fo=
r 100BaseTX */
 	csr6_sf =3D (1<<21),   /* Store and forward. If set ignores TR bits */
 	csr6_hbd =3D (1<<19),  /* Heart beat disable. Disables SQE function in 1=
0baseT */
-	csr6_ps =3D (1<<18),   /* Port Select. 0 (defualt) =3D 10baseT, 1 =3D 10=
0baseTX: can't be set */
+	csr6_ps =3D (1<<18),   /* Port Select. 0 (default) =3D 10baseT, 1 =3D 10=
0baseTX: can't be set */
 	csr6_ca =3D (1<<17),   /* Collision Offset Enable. If set uses special a=
lgorithm in low collision situations */
 	csr6_trh =3D (1<<15),  /* Transmit Threshold high bit */
 	csr6_trl =3D (1<<14),  /* Transmit Threshold low bit */
=2D-
2.39.0

