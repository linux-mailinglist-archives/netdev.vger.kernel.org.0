Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE658C47F
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242011AbiHHH5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237712AbiHHH53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:57:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CE813D39
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:57:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oKxd6-0008Ov-7v; Mon, 08 Aug 2022 09:56:52 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 87AA1C45A6;
        Mon,  8 Aug 2022 07:56:46 +0000 (UTC)
Date:   Mon, 8 Aug 2022 09:56:45 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] can: j1939: fix memory leak of skbs
Message-ID: <20220808075645.qtgwu64mjc2rxnuc@pengutronix.de>
References: <20220805150216.66313-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hiqec7dmmpfnqmy6"
Content-Disposition: inline
In-Reply-To: <20220805150216.66313-1-pchelkin@ispras.ru>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hiqec7dmmpfnqmy6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.08.2022 18:02:16, Fedor Pchelkin wrote:
> We need to drop skb references taken in j1939_session_skb_queue() when
> destroying a session in j1939_session_destroy(). Otherwise those skbs
> would be lost.
>=20
> Link to Syzkaller info and repro: https://forge.ispras.ru/issues/11743.
>=20
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Suggested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Added to can/master

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hiqec7dmmpfnqmy6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLwwboACgkQrX5LkNig
010SAgf8DcRHAVx/USEkzkATwto/JOfRALIMKu8UHkPr+0JyLricXyQYn4NPMUjg
3dP3ZYZY3l5Pg5hCrto9W0T1tgn/9SxRR7ngIgqX46YNphbBgIr07DjWMOrB5Lv+
YnrdkYgWfBH2rx1f6BJfF+9Dmur3vLomVG7IpwemLDeWa4azE2f9gRnJwHLBbfGX
RuvaBIgA+F6qAMXdU9RZv8d4/NGlI3gHQdvzrmNIZA79NEIVZMQA3DrZroN/W8t1
Hf/mJncv4eRYt38RcDoihu/CKEbS3C4gq2olzLN4xA1h+jUDJsDNdBHDHfd0w1fo
/3KKaSQleo2KY+k8pFkGm3LivhmhQQ==
=TBCJ
-----END PGP SIGNATURE-----

--hiqec7dmmpfnqmy6--
