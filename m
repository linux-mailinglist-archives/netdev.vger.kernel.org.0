Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A07F584CB4
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbiG2HeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiG2HeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:34:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7004804A8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:34:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oHKVT-0007Pt-Hy; Fri, 29 Jul 2022 09:33:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2F80CBD688;
        Fri, 29 Jul 2022 07:33:55 +0000 (UTC)
Date:   Fri, 29 Jul 2022 09:33:52 +0200
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
Message-ID: <20220729073352.rfxdyjvttjp7rnfk@pengutronix.de>
References: <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
 <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
 <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
 <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
 <20220728105049.43gbjuctezxzmm4j@pengutronix.de>
 <20220728125734.1c380d25.max@enpas.org>
 <CABGWkvo0B8XM+5qLhz3zY2DzyUrEQtQyJnd91VweUWDUcjyr5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uvqgmkh7exxi4qsq"
Content-Disposition: inline
In-Reply-To: <CABGWkvo0B8XM+5qLhz3zY2DzyUrEQtQyJnd91VweUWDUcjyr5A@mail.gmail.com>
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


--uvqgmkh7exxi4qsq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.07.2022 08:52:07, Dario Binacchi wrote:
> Hello Marc and Max,
>=20
> On Thu, Jul 28, 2022 at 12:57 PM Max Staudt <max@enpas.org> wrote:
> >
> > On Thu, 28 Jul 2022 12:50:49 +0200
> > Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> > > On 28.07.2022 12:23:04, Dario Binacchi wrote:
> > > > > > Does it make sense to use the device tree
> > > > >
> > > > > The driver doesn't support DT and DT only works for static serial
> > > > > interfaces.
> > >
> > > Have you seen my remarks about Device Tree?
> >
> > Dario, there seems to be a misunderstanding about the Device Tree.
> >
> > It is used *only* for hardware that is permanently attached, present at
> > boot, and forever after. Not for dyamically added stuff, and definitely
> > not for ldiscs that have to be attached manually by the user.
> >
> >
> > The only exception to this is if you have an embedded device with an
> > slcan adapter permanently attached to one of its UARTs. Then you can
> > use the serdev ldisc adapter to attach the ldisc automatically at boot.
>=20
> It is evident that I am lacking some skills (I will try to fix it :)).

We're all here to learn something!

> I think it is equally clear that it is not worth going down this path.

If you have a static attached serial devices serdev is the way to go.
But slcan has so many drawbacks compared to "real" CAN adapters that I
hope the no one uses them in such a scenario.

> > If you are actively developing for such a use case, please let us know,
> > so we know what you're after and can help you better :)
>=20
> I don't have a use case, other than to try, if possible, to make the driv=
er
> autonomous from slcand / slcan_attach for the CAN bus setup.

=46rom my point of view your job is done!

> Returning to Marc's previous analysis:
> "... Some USB CAN drivers query the bit timing const from the USB device."
>=20
> Can we think of taking the gs_usb driver as inspiration for getting/setti=
ng the
> bit timings?
>=20
> https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/gs_usb=
=2Ec#L951
> https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/gs_usb=
=2Ec#L510
>=20
> and, as done with patches:
>=20
> can: slcan: extend the protocol with CAN state info
> can: slcan: extend the protocol with error info

You can define a way to query bit timing constants and CAN clock rate,
but you have to get this into the "official" firmware. You have to roll
out a firmware update to all devices. What about non official firmware?

> further extend the protocol to get/set the bit timing from / to the adapt=
er ?
> In the case of non-standard bit rates, the driver would try, depending on=
 the
> firmware of the adapter, to calculate and set the bit timings autonomousl=
y.

If an adapter follows 100% the official firmware doc the BTR registers
are interpreted as SJA1000 with 8 MHz CAN clock.

See

| https://lore.kernel.org/all/20220728105049.43gbjuctezxzmm4j@pengutronix.de

where I compare the 125 Kbit/s BTR config of the documentation with the
bit timing calculated by the kernel algorithm.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uvqgmkh7exxi4qsq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLjjV0ACgkQrX5LkNig
011JXggAirzTuOAHUICqHeBohgikqNvfpTC2TSgukAcL9Gw2AkuU4P9kXEW/lHTc
gjVFYxly67MCoBLXjpcbS4tvY4KveQBrD1UdFjka6NmWuSK1cf6TBiv9aw6OCWb+
tWVgZuVk9SuPCDaHaY0ohfP4XflqH2M+ruFdKuoN2bElkM9gOv9exPCE+etGiVKq
PnhCVwcGpUn04XqIOcnaIGjjhH68/rOLFnZH8vcV2uzHJ4iCfzok+1i5wZq0pvr6
PtpHnfomhjtyc+kpzdEVoIz2e6ew1vQkQWchzhrRzrk+bnwMlnOBdvhbbkVecAKd
oqeuYMqzgnafTco7n6a93CnUEQt/FA==
=aZAq
-----END PGP SIGNATURE-----

--uvqgmkh7exxi4qsq--
