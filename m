Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE9F583911
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiG1G4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbiG1G4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:56:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052AE4E878
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 23:56:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGxRf-0005FH-8V; Thu, 28 Jul 2022 08:56:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E8AC5BC99E;
        Thu, 28 Jul 2022 06:56:26 +0000 (UTC)
Date:   Thu, 28 Jul 2022 08:56:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Max Staudt <max@enpas.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
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
Message-ID: <20220728065625.vu2qpdvrtvcj2iap@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
 <fb31bfeb-e7bc-c7f8-db2c-f8d0c531af99@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r4kcys44o4vjfnpy"
Content-Disposition: inline
In-Reply-To: <fb31bfeb-e7bc-c7f8-db2c-f8d0c531af99@hartkopp.net>
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


--r4kcys44o4vjfnpy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.07.2022 22:12:13, Oliver Hartkopp wrote:
>=20
>=20
> On 27.07.22 20:24, Marc Kleine-Budde wrote:
> > On 27.07.2022 19:28:39, Max Staudt wrote:
> > > On Wed, 27 Jul 2022 13:30:54 +0200
> > > Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > >=20
> > > > As far as I understand, setting the btr is an alternative way to se=
t the
> > > > bitrate, right? I don't like the idea of poking arbitrary values in=
to a
> > > > hardware from user space.
> > >=20
> > > I agree with Marc here.
> > >=20
> > > This is a modification across the whole stack, specific to a single
> > > device, when there are ways around.
> > >=20
> > > If I understand correctly, the CAN232 "S" command sets one of the fix=
ed
> > > bitrates, whereas "s" sets the two BTR registers. Now the question is,
> > > what do BTR0/BTR1 mean, and what are they? If they are merely a divid=
er
> > > in a CAN controller's master clock, like in ELM327, then you could
> > >=20
> > >    a) Calculate the BTR values from the bitrate userspace requests, or
> >=20
> > Most of the other CAN drivers write the BTR values into the register of
> > the hardware. How are these BTR values transported into the driver?
> >=20
> > There are 2 ways:
> >=20
> > 1) - user space configures a bitrate
> >     - the kernel calculates with the "struct can_bittiming_const" [1] g=
iven
> >       by driver and the CAN clock rate the low level timing parameters.
> >=20
> >       [1] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/li=
nux/can/netlink.h#L47
> >=20
> > 2) - user space configures low level bit timing parameter
> >       (Sample point in one-tenth of a percent, Time quanta (TQ) in
> >        nanoseconds, Propagation segment in TQs, Phase buffer segment 1 =
in
> >        TQs, Phase buffer segment 2 in TQs, Synchronisation jump width in
> >        TQs)
> >      - the kernel calculates the Bit-rate prescaler from the given TQ a=
nd
> >        CAN clock rate
> >=20
> > Both ways result in a fully calculated "struct can_bittiming" [2]. The
> > driver translates this into the hardware specific BTR values and writes
> > the into the registers.
> >=20
> > If you know the CAN clock and the bit timing const parameters of the
> > slcan's BTR register you can make use of the automatic BTR calculation,
> > too. Maybe the framework needs some tweaking if the driver supports both
> > fixed CAN bit rate _and_ "struct can_bittiming_const".
> >=20
> > [2] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/ca=
n/netlink.h#L31
> >=20
> > >    b) pre-calculate a huge table of possible bitrates and present them
> > >       all to userspace. Sounds horrible, but that's what I did in can=
327,
> > >       haha. Maybe I should have reigned them in a little, to the most
> > >       useful values.
> >=20
> > If your adapter only supports fixed values, then that's the only way to
> > go.
> >=20
> > >    c) just limit the bitrates to whatever seems most useful (like the
> > >       "S" command's table), and let users complain if they really need
> > >       something else. In the meantime, they are still free to slcand =
or
> > >       minicom to their heart's content before attaching slcan, thanks=
 to
> > >       your backwards compatibility efforts.
> >=20
> > In the early stages of the non-mainline CAN framework we had tables for
> > BTR values for some fixed bit rates, but that turned out to be not
> > scaleable.
>=20
> The Microchip CAN BUS Analyzer Tool is another example for fixed bitrates:
>=20
> https://elixir.bootlin.com/linux/v5.18.14/source/drivers/net/can/usb/mcba=
_usb.c#L156
>=20
> So this might be the way to go here too ...

The slcan driver already supports fixed bitrates. This discussion is
about setting the BTR registers in one way or another.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--r4kcys44o4vjfnpy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLiMxYACgkQrX5LkNig
012etQgAjCPzvxq7Zconyk+xrBMFxHWt21LQ/deabkMrYS/HgCXuEc2kQgofoKkt
wxyej/vMFNGL3rRslBsixS3kkrCb67mke93TNlJMPORwqA2fGR7RtBMAdIHUZzBl
uzFR+gBlCxnKTMnryzVV1btQU9oAdDzPcXkakVKeuq0Ym26ISRR4ty38oUDqkGq4
CkL00Cdp0HMspFisy97hetfhbaM6zY3gL0Dg3z23l080E6gXR3gz9vejMef9NZq1
ZxE6FYy+huunUbg4TLrt/naTgisjs+xVhLNUDrf3pkLUcUDL3Y3jb3vuptMJ46jP
QJSIBjovVxdhW0KDp5kYSddvpQbcgw==
=EQn4
-----END PGP SIGNATURE-----

--r4kcys44o4vjfnpy--
