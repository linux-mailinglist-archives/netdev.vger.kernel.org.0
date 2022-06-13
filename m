Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E35454805D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 09:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiFMHW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 03:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiFMHWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 03:22:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1191E140A5
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 00:22:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0ePE-0004li-1r; Mon, 13 Jun 2022 09:22:36 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 199EA938F6;
        Mon, 13 Jun 2022 07:22:34 +0000 (UTC)
Date:   Mon, 13 Jun 2022 09:22:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 09/13] can: slcan: send the close command to the
 adapter
Message-ID: <20220613072233.or64qzh2jko2jhob@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-10-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kqbqd6v2shjjrfph"
Content-Disposition: inline
In-Reply-To: <20220612213927.3004444-10-dario.binacchi@amarulasolutions.com>
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


--kqbqd6v2shjjrfph
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.06.2022 23:39:23, Dario Binacchi wrote:
> In case the bitrate has been set via ip tool, this patch changes the
> driver to send the close command ("C\r") to the adapter.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Nitpick: Please squash the open and close patches.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kqbqd6v2shjjrfph
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKm5bcACgkQrX5LkNig
010T9gf9HNXL3Mnnekggg0MEFpnO12bDWBZB64mSw9O5auqtI/2Zmi2olHK22bPe
E1oFWdk+Ej4G1gnxyKKv5EUj92QlQMNTPT75WKYQkEZvz2UVvgs51XVULRx/ZIXX
f5RcyODulmRmJ6o45vxmdMCcjvKL3IhzQ6z1BkWWmzQhjrg8M3v3wgC703VyukA8
HHObwomdcjhbO/AmwzwFvGTBR705ZgYKoXhRK1yE4+AR1w9PmMeO9ltLedfWioT7
e2NTeHJqRviQwEm01UoZpiSPvpyW13d+bmIRckiRc0K78RL+oAnkHBOkjw76r/sa
MfBA8bS5IQCOsv+/nbfHUVoRiyabcw==
=d4nN
-----END PGP SIGNATURE-----

--kqbqd6v2shjjrfph--
