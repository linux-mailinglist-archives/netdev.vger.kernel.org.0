Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B072A6881B3
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjBBPXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjBBPXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:23:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A899EB60
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:23:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNbQX-0002Jl-H8; Thu, 02 Feb 2023 16:23:05 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:fff9:bfd9:c514:9ad9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BECC116D6F8;
        Thu,  2 Feb 2023 15:23:04 +0000 (UTC)
Date:   Thu, 2 Feb 2023 16:22:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <Frank.Jungclaus@esd.eu>
Cc:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
Message-ID: <20230202152256.kc5xh4e4m6panumw@pengutronix.de>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
 <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
 <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
 <CAMZ6RqLeHNzZyKdCmqXDDtd5GZC8KZ0Y1hESYyPaaMbFe=ryYQ@mail.gmail.com>
 <786db8fae65a2ed415b5dd0c3001b4dfc8c7112b.camel@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ppub2d66ohev7mn5"
Content-Disposition: inline
In-Reply-To: <786db8fae65a2ed415b5dd0c3001b4dfc8c7112b.camel@esd.eu>
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


--ppub2d66ohev7mn5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.01.2023 15:47:22, Frank Jungclaus wrote:
> On Thu, 2022-12-22 at 11:21 +0900, Vincent MAILHOL wrote:
> > On Thu. 22 Dec. 2022 at 03:42, Frank Jungclaus <Frank.Jungclaus@esd.eu>=
 wrote:
> > > On Tue, 2022-12-20 at 14:49 +0900, Vincent MAILHOL wrote:
> > > > On Tue. 20 Dec. 2022 at 06:29, Frank Jungclaus <frank.jungclaus@esd=
=2Eeu> wrote:
> > > > > Started a rework initiated by Vincents remarks "You should not re=
port
> > > > > the greatest of txerr and rxerr but the one which actually increa=
sed."
> > > > > [1]
> > > >=20
> > > > I do not see this comment being addressed. You are still assigning =
the
> > > > flags depending on the highest value, not the one which actually
> > > > changed.
> > >=20
> > >=20
> > > Yes, I'm assigning depending on the highest value, but from my point =
of
> > > view doing so is analogue to what is done by can_change_state().
> >=20
> > On the surface, it may look similar. But if you look into details,
> > can_change_state() is only called when there is a change on enum
> > can_state. enum can_state is the global state and does not
> > differentiate the RX and TX.
> >=20
> > I will give an example. Imagine that:
> >=20
> >   - txerr is 128 (ERROR_PASSIVE)
> >   - rxerr is 95 (ERROR_ACTIVE)
> >=20
> > Imagine that rxerr then increases to 96. If you call
> > can_change_state() under this condition, the old state:
> > can_priv->state is still equal to the new one: max(tx_state, rx_state)
> > and you would get the oops message:
> >=20
> >   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/dev/de=
v.c#L100
> >=20
> > So can_change_state() is indeed correct because it excludes the case
> > when the smallest err counter changed.
> >=20
> > > And
> > > it should be fine, because e.g. my "case ESD_BUSSTATE_WARN:" is reach=
ed
> > > exactly once while the transition from ERROR_ACTIVE to
> > > ERROR_WARN. Than one of rec or tec is responsible for this
> > > transition.
> > > There is no second pass for "case ESD_BUSSTATE_WARN:"
> > > when e.g. rec is already on WARN (or above) and now tec also reaches
> > > WARN.
> > > Man, this is even difficult to explain in German language ;)
> >=20
> > OK. This is new information. I agree that it should work. But I am
> > still puzzled because the code doesn't make this limitation apparent.
> >=20
> > Also, as long as you have the rxerr and txerr value, you should still
> > be able to set the correct flag by comparing the err counters instead
> > of relying on your device events.
> >=20
>=20
> I agree, this would be an option. But I dislike the fact that then
> - beside the USB firmware - there is a second instance which decides on
> the bus state. I'll send a reworked patch which makes use of
                      ^^^^^^^^^^^^^^^^^^^^^
> can_change_state(). Hopefully that will address your concerns ;)
> This also will fix the imperfection, that our current code e.g. does
> an error_warning++ when going back in direction of ERROR_ACTIVE ...

Not taking this series, waiting for the reworked version.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ppub2d66ohev7mn5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPb1U0ACgkQvlAcSiqK
BOj+jwf/d0Pwy8uSo/wLobyNUl6lxARo3Geh3ihJqojvNY+OM9RsPyDiIVUXZNSm
xNkUEBr7Xi9gLNvHwbak9HKUpJicTf3tsdlbzR2SETgdeMx5McXUQO/LI5bWV2mG
xUq72x8yoUO4DWHe9a3Kh8Pc5UVU2IvLWh4/yo7SBq9LYGO50YsfJ/Bgo2zPH36M
o0dBJhH7MuaWTrfHlPWZRR069BxaqCQeqXoLkeseijWdLexIwiakuqDslslgZTPQ
eiqvk5jFqnItW0KYY6a4jK916TSvz1vIgj964Y62uW9tUfNsZOb7R3nlLHpzKiuY
wWsq1ND2YhCj07JRVnp4sVk1Sca5Nw==
=xxNZ
-----END PGP SIGNATURE-----

--ppub2d66ohev7mn5--
