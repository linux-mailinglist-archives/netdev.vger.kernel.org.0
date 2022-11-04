Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6091B6195CA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiKDMEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiKDMEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:04:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBF02CE36
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:04:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oqvR2-0007eW-Uz; Fri, 04 Nov 2022 13:04:33 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8F3E7112E0A;
        Fri,  4 Nov 2022 12:04:31 +0000 (UTC)
Date:   Fri, 4 Nov 2022 13:04:30 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com
Subject: Re: [PATCH] can: j1939: fix missing CAN header initialization
Message-ID: <20221104120430.2e6gbglqvv2hex4v@pengutronix.de>
References: <20221104075000.105414-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vvixvfgqetn2iapa"
Content-Disposition: inline
In-Reply-To: <20221104075000.105414-1-socketcan@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vvixvfgqetn2iapa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.11.2022 08:50:00, Oliver Hartkopp wrote:
> The read access to struct canxl_frame::len inside of a j1939 created skbu=
ff
> revealed a missing initialization of reserved and later filled elements in
> struct can_frame.
>=20
> This patch initializes the 8 byte CAN header with zero.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Link: https://lore.kernel.org/linux-can/20221104052235.GA6474@pengutronix=
=2Ede/T/#t
> Reported-by: syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied to linux-can + add stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vvixvfgqetn2iapa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNk/8oACgkQrX5LkNig
011QjQgAkg2pIAedaZ4l3g8DItRlte83J5X4N4aYKNEOxLSfZE2tmTgGNd1VoBZI
BPj4LBMgRl/WQfprhP74yKC4bWauzM9W8cHVI90BVLLV+gUB6KS40Ah5yXhlSdGb
GF26YLtefr938KEZCNFFE8sXHE7vicq3hOVuVzL2jYvsjbkeiFSO71UsuurKli4k
uGen17P1qTHufnTZDPsLYYyeJjr9OSq3xS/oabPdtEoPSHNCHxq4DJnX7IZJGQhc
weQY5qSLoSjseJSeiUoZ0oNOCZP/iC/4OiHIYrxaBakURPbqUKeG2I/YQ1EPeOGb
jrWpZy9lz2PId8uyPra66SZAvAVaSg==
=9b44
-----END PGP SIGNATURE-----

--vvixvfgqetn2iapa--
