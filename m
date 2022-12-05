Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECD86424FD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiLEIqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiLEIqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:46:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D22C17AB3
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:46:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p276t-0004mn-5J; Mon, 05 Dec 2022 09:45:59 +0100
Received: from pengutronix.de (hardanger-8.fritz.box [IPv6:2a03:f580:87bc:d400:c1b8:7ff9:10eb:2660])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B9E471361CF;
        Mon,  5 Dec 2022 08:45:56 +0000 (UTC)
Date:   Mon, 5 Dec 2022 09:45:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <vincent.mailhol@gmail.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] can: can327: Flush tx_work on ldisc .close()
Message-ID: <20221205084556.etpo2xufbsl5753d@pengutronix.de>
References: <20221202160148.282564-1-max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y3v7ghucklse6fhe"
Content-Disposition: inline
In-Reply-To: <20221202160148.282564-1-max@enpas.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y3v7ghucklse6fhe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.12.2022 01:01:48, Max Staudt wrote:
> Additionally, remove it from .ndo_stop().
>=20
> This ensures that the worker is not called after being freed, and that
> the UART TX queue remains active to send final commands when the netdev
> is stopped.
>=20
> Thanks to Jiri Slaby for finding this in slcan:
>=20
>   https://lore.kernel.org/linux-can/20221201073426.17328-1-jirislaby@kern=
el.org/
>=20
> A variant of this patch for slcan, with the flush in .ndo_stop() still
> present, has been tested successfully on physical hardware:
>=20
>   https://bugzilla.suse.com/show_bug.cgi?id=3D1205597
>=20
> Fixes: 43da2f07622f ("can: can327: CAN/ldisc driver for ELM327 based OBD-=
II adapters")
> Cc: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
> Cc: Max Staudt <max@enpas.org>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Staudt <max@enpas.org>

Applied to linux-can.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--y3v7ghucklse6fhe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmONr8EACgkQrX5LkNig
012LCwf8CMDCZv6PnSKRAlBjjjDBvBq29KA/kv21asReFn7i+WoSd6hqvKIT0mnM
7oKfo57cdk2qPJC1hjzsRtnMHlvgEXlqHFFkJtqD08IXPW/n+hJt3O3R4qpe6q0Q
ooLTpZTC7l8Ze6MEdeO95DOfFj71ziLBk+583Xjm+caUNwE9IeDzXHBlv3F6+Sji
efgmaCKqsgmEoJMc7Enz+412PAiMtN/8mHfH4par5n3WP0nIOD4njkWXpyOu7WnU
ORiRJideTEgeSQwDkiUJkjfDo+iFVvtWLeSVViYcUXlOeOfDTYvhhYGjTofRd6Ja
XWGZDP69+co9pHGh58o78sd+jbI+ag==
=urxd
-----END PGP SIGNATURE-----

--y3v7ghucklse6fhe--
