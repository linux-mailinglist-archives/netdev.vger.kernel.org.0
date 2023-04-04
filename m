Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B246D588E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjDDGP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjDDGPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:15:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842DD2686
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:15:24 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pjZwS-0007IN-6j; Tue, 04 Apr 2023 08:14:52 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 33E2A1A5DF0;
        Tue,  4 Apr 2023 06:14:50 +0000 (UTC)
Date:   Tue, 4 Apr 2023 08:14:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: esd_usb: Add support for CAN_CTRLMODE_BERR_REPORTING
Message-ID: <20230404-worrisome-cable-9486f6795772@pengutronix.de>
References: <20230330184446.2802135-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="blqp6dvgfsr376jr"
Content-Disposition: inline
In-Reply-To: <20230330184446.2802135-1-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--blqp6dvgfsr376jr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.03.2023 20:44:46, Frank Jungclaus wrote:
> Announce that the driver supports CAN_CTRLMODE_BERR_REPORTING by means
> of priv->can.ctrlmode_supported. Until now berr reporting always has
> been active without taking care of the berr-reporting parameter given
> to an "ip link set ..." command.
>=20
> Additionally apply some changes to function esd_usb_rx_event():
> - If berr reporting is off and it is also no state change, then
> immediately return.
> - Unconditionally (even in case of the above "immediate return") store
> tx- and rx-error counters, so directly use priv->bec.txerr and
> priv->bec.rxerr instead of intermediate variables.
> - Not directly related, but to better point out the linkage between a
> failed alloc_can_err_skb() and stats->rx_dropped++:
> Move the increment of the rx_dropped statistic counter (back) to
> directly behind the err_skb allocation.
>=20
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>

Applied to linux-can-next

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--blqp6dvgfsr376jr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQrwFYACgkQvlAcSiqK
BOh28Af+MlH6MoPRA+EDMuSmn+NSuTSQpn2RxD9/UQrTuyig29aUjIMIVuREksym
Dn5bVb0C9V43K6TQ767Y9lBuoVRXgXB0fdurVKHxGP0cuABf4DwhAw1UaZFvUH21
G+WUVIHGtamM3WgQ8PR69m3Yay4RRNlxO2W90Elwnf4zZNUJdTXYlQtWZzl2ues1
IlFaEHUE/pEj8ALmTY0kegsYD30tq6hq8u7hpUKk/NmClU2DOyH57yr6g6ziLlng
5scVvajveEkg8F9T01z2tqBjdDJHeJ2lkj81bkXqz+/zT5LQxXXy1w9xQdToaeBA
PX4KakMomvaFQhGK5WgP99MKcQkVgQ==
=W/Id
-----END PGP SIGNATURE-----

--blqp6dvgfsr376jr--
