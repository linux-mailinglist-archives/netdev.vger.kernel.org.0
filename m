Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9A958C4AF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 10:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbiHHIHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 04:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242257AbiHHIH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 04:07:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E1913FA7
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 01:07:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oKxmW-0001rc-Jk; Mon, 08 Aug 2022 10:06:36 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CCFD4C45CB;
        Mon,  8 Aug 2022 08:06:34 +0000 (UTC)
Date:   Mon, 8 Aug 2022 10:06:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2] can: j1939: Replace WARN_ON_ONCE with
 netdev_warn_once() in j1939_sk_queue_activate_next_locked()
Message-ID: <20220808080632.vyl3zcchyyuwmpvn@pengutronix.de>
References: <20220729142634.GD10850@pengutronix.de>
 <20220729143655.1108297-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vreaklujen3bcdlb"
Content-Disposition: inline
In-Reply-To: <20220729143655.1108297-1-pchelkin@ispras.ru>
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


--vreaklujen3bcdlb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.07.2022 17:36:55, Fedor Pchelkin wrote:
> We should warn user-space that it is doing something wrong when trying to
> activate sessions with identical parameters but WARN_ON_ONCE macro can not
> be used here as it serves a different purpose.
>=20
> So it would be good to replace it with netdev_warn_once() message.
>=20
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Nitpick: You should add your S-o-b below every other tag line.

Added to linux-can with fixed indention.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vreaklujen3bcdlb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLwxAYACgkQrX5LkNig
012K0Af8D7wJmhikOyLYznZKn3Xobpfdif03hgTMbZKUK699it7FpxPLKtpz0glA
DELYBddvKZ4yLmQftWG4LaFSxNSOW+NRitUqdtTaW5sKxQdmarVony6BWKSy/XsF
upWRctkPBgXey/H3voaqQR3auOkvMnPnbigeNWCFZhEtezrpAwbXqqGKISV1tQrA
pajNlRwD1nvzY2ZiX87RxmWarWt6doeXaeiwfLGPK2vn7s4SZM1WGz1NlarA3AwX
E4ixgmPVXB81mXLKq9Na3XffQTW9oWZMahOOEcvq+IkpH1y3iR14TzazUskRXQ35
fLiK17VYB3DUE95M9duhJzH8XQ2bIw==
=5Wqw
-----END PGP SIGNATURE-----

--vreaklujen3bcdlb--
