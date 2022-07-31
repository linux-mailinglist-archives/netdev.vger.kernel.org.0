Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E49158607A
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 20:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiGaS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 14:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiGaS6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 14:58:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FCE037
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 11:58:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIE8f-0004uc-1G; Sun, 31 Jul 2022 20:58:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 39135BEBD0;
        Sun, 31 Jul 2022 18:58:05 +0000 (UTC)
Date:   Sun, 31 Jul 2022 20:58:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Max Staudt <max@enpas.org>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220731185803.bdg4dugwf4dv2owk@pengutronix.de>
References: <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
 <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
 <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
 <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
 <20220728105049.43gbjuctezxzmm4j@pengutronix.de>
 <20220728125734.1c380d25.max@enpas.org>
 <CABGWkvo0B8XM+5qLhz3zY2DzyUrEQtQyJnd91VweUWDUcjyr5A@mail.gmail.com>
 <20220729073352.rfxdyjvttjp7rnfk@pengutronix.de>
 <CABGWkvpgDZohEwPJu0hgm+OqfKbH=PgpPHjMMp=t3PxpPfVhVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="46pf6oluekbhoi4p"
Content-Disposition: inline
In-Reply-To: <CABGWkvpgDZohEwPJu0hgm+OqfKbH=PgpPHjMMp=t3PxpPfVhVQ@mail.gmail.com>
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


--46pf6oluekbhoi4p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.07.2022 17:54:01, Dario Binacchi wrote:
> > If an adapter follows 100% the official firmware doc the BTR registers
> > are interpreted as SJA1000 with 8 MHz CAN clock.
>=20
> I checked the sources and documentation of the usb adapter I used (i.
> e. Https://www.fischl.de/usbtin/):
> ...
> sxxyyzz[CR]                 Set can bitrate registers of MCP2515. You
> can set non-standard baudrates which are not supported by the "Sx"
> command.

I hope the effective clock speed is documented somewhere, as you need
this information to set the registers.

>                                      xx: CNF1 as hexadecimal value (00-FF)
>                                      yy: CNF2 as hexadecimal value (00-FF)
>                                      zz: CNF3 as hexadecimal value
> ...
>=20
> Different from what is reported by can232_ver3_Manual.pdf :
>=20
> sxxyy[CR]         Setup with BTR0/BTR1 CAN bit-rates where xx and yy is a=
 hex
>                          value. This command is only active if the CAN
>=20
> And here is the type of control carried out by the slcan_attach for
> the btr parameter:
> https://github.com/linux-can/can-utils/blob/master/slcan_attach.c#L144
> When I would have expected a different check (i. e. if (strlen(btr) > 4).
> Therefore it is possible that each adapter uses these bytes in its own
> way as well as
> in the content and also in the number of bytes.

I expected something like that.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--46pf6oluekbhoi4p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLm0LkACgkQrX5LkNig
013AQwf/eh8bIF53PTKoQPbikvqT6o6izoKdHiIuQetbs61GRgGpOo2jXKUjRrLu
l6BiXmM7OvXDW26Y1+Wqu/DgTkL90vyy7UOyKjGQ+NnwDVYHUvwDfLTSBXXO4DKH
rMhQ1imz68YcRUfd9EMyLOKKOux7sim1a1Xtksgy1C6hLmpiKhLwpNqe/4xA1KxM
N3rLrliHOdxYNIlYzFXXuyrtNXD6CsSpAjq9DANHQ/kfLmWGwj6ijXGknP7KR2Rz
rYU1dEQjNaDOtNwpnGpDPVrbOIFZDb30b/OOvUrJ1HpkjeuttOX7Mw/OnDLE1ReJ
DSODRfUZWnK2LSQkf4TEvUkCpHw7fw==
=aL16
-----END PGP SIGNATURE-----

--46pf6oluekbhoi4p--
