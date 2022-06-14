Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2454AA82
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354503AbiFNHYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353151AbiFNHY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:24:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A51E3BBFB
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 00:24:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o10uO-00034J-F5; Tue, 14 Jun 2022 09:24:16 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3A8EB94613;
        Tue, 14 Jun 2022 07:24:15 +0000 (UTC)
Date:   Tue, 14 Jun 2022 09:24:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 05/13] can: netlink: dump bitrate 0 if
 can_priv::bittiming.bitrate is -1U
Message-ID: <20220614072414.dxdrzrcokusunf3v@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-6-dario.binacchi@amarulasolutions.com>
 <20220613071058.h6bmy6emswh76q5s@pengutronix.de>
 <CABGWkvoNJYfK6bcjYtUi9qKvRfEfHUyrCWDBhOL4EjurW5YJ8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ziwxdbyycswus75l"
Content-Disposition: inline
In-Reply-To: <CABGWkvoNJYfK6bcjYtUi9qKvRfEfHUyrCWDBhOL4EjurW5YJ8Q@mail.gmail.com>
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


--ziwxdbyycswus75l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.06.2022 22:44:12, Dario Binacchi wrote:
> On Mon, Jun 13, 2022 at 9:11 AM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> > This would make the code a lot cleaner. Can you think of a nice macro
> > name for the -1?
> >
> > 0 could be CAN_BITRATE_UNCONFIGURED or _UNSET. For -1 I cannot find a
> > catchy name, something like CAN_BITRATE_CONFIGURED_UNKOWN or
> > SET_UNKNOWN.
> >
>=20
> Personally I would use CAN_BITRATE_UNSET (0) and CAN_BITRATE_UNKNOWN (-1).
> Let me know what your ultimate preference is.

Looks good.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ziwxdbyycswus75l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKoN5wACgkQrX5LkNig
012SQQf+MCc/KN4pvlFpJLP2EPpCUYG70n+5XaUEvz9ZZ+hDCfpEvX69pVFhGg/8
58BYsbjIo4lh8XeZ9gzAIkeXjWsoHmBX2XHzcjLPM70sc8RN9VMr+uC32Wgn/VKo
0e+S3Tvjd4EmSr0D7ulIjssYDatwdxTY+LgJUk47njL+x5PaoDFqub+MScRcNFt1
cNk+2+B9H0klY6GCMpQiGGSHkNmOB+QVBo5tpBRaSJH9oLTIT3W5KO65U6FPz57H
xm7kChVAUgHEx9vHRS92v2XyapmpTZwsMU2GJZRvNaoy+blRgsACrR0MbuGPnb6o
PaGXdriKS8wM/WKuTKky0cuPYR7WLg==
=OWqG
-----END PGP SIGNATURE-----

--ziwxdbyycswus75l--
