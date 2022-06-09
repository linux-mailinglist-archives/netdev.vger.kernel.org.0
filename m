Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4140544547
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbiFIIBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240422AbiFIIBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:01:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7AF60F4
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:01:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzD6R-0003tg-Ij; Thu, 09 Jun 2022 10:01:15 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D75DC8FD4B;
        Thu,  9 Jun 2022 08:01:12 +0000 (UTC)
Date:   Thu, 9 Jun 2022 10:01:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 11/13] can: slcan: add ethtool support to reset
 adapter errors
Message-ID: <20220609080112.24bw2764ov767pqc@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com>
 <20220607105225.xw33w32en7fd4vmh@pengutronix.de>
 <CABGWkvozX51zeQt16bdh+edsjwqST5A11qtfxYjTvP030DnToQ@mail.gmail.com>
 <20220609063813.jf5u6iaghoae5dv3@pengutronix.de>
 <CABGWkvrViDyWfU=PUfKq2HXnDjhiZdOMWSBt3xcmxFKxhHKCyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nrsx7nlshjl4uzjt"
Content-Disposition: inline
In-Reply-To: <CABGWkvrViDyWfU=PUfKq2HXnDjhiZdOMWSBt3xcmxFKxhHKCyw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nrsx7nlshjl4uzjt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.06.2022 09:24:14, Dario Binacchi wrote:
> > > > I'm a big fan of bringing the device into a well known good state d=
uring
> > > > ifup. What would be the reasons/use cases to not reset the device?
> > >
> > > Because by default either slcand and slcan_attach don't reset the
> > > error states, but you must use the `-f' option to do so. So, I
> > > followed this use case.
> >
> > Is this a CAN bus error state, like Bus Off or some controller (i.e. non
> > CAN related) error?
>=20
> The help option of slcan_attach and slcand prints " -f (read status
> flags with 'F\\r' to reset error states)\n" I looked at the sources of
> the adapter I am using (USBtin, which uses the mcp2515 controller).
> The 'F' command reads the EFLG register (0x2d) without resetting the
> RX0OVR and RX1OVR overrun bits.

The Lawicel doc [1] says 'F' is to read the status flags not to clear
it. However commit 7ef581fec029 ("slcan_attach: added '-f' commandline
option to read status flags") [2] suggests that there are some adapters
that the reading of the status flag clears the errors. IMHO the 'F'
command should be send unconditionally during open.

[1] http://www.can232.com/docs/can232_v3.pdf
[2] https://github.com/linux-can/can-utils/commit/7ef581fec0298a228baa71372=
ea5667874fb4a56

> The error states reset is done by 'f <subcmd>' command, that is not
> managed by slcan_attach/slcand.

Is the 'f' command is non-standard?

>         switch (subcmd) {
>             case 0x0: // Disable status reporting
>                 mcp2515_write_register(MCP2515_REG_CANINTE, 0x00);
>                 return CR;
>             case 0x1: // Enable status reporting
>                 mcp2515_write_register(MCP2515_REG_CANINTE, 0x20); //
> ERRIE interrupt to INT pin
>                 return CR;
>             case 0x2: // Clear overrun errors
>                 mcp2515_write_register(MCP2515_REG_EFLG, 0x00);
>                 return CR;
>             case 0x3: // Reinit/reset MCP2515 to clear all errors
>                 if (state =3D=3D STATE_CONFIG) {
>                     mcp2515_init();
>                     return CR;
>                 }
>                 break;
>         }

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nrsx7nlshjl4uzjt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKhqMUACgkQrX5LkNig
0114qAgArPEP1RPi8hQW1i+C4+/kWVLSk8Mlftr4ru7u4Nsp1miAiuP/E1pPIgyX
Wc5FiojY7XT2Rpc1543Ufz+7o67be2hvHApDPQTT30qPWWTD0hIHlEt3FU/5CPig
aseQYSnvpANP28Rp0ILvdf8odnDT6C/k0yEDKbbHnkZOARsV1fiLfkxTmfDac9i1
/2A6kmPAk48Y1pYGI9rPihYSfPxyPVGwSbQIEPQY35RHvLvgg74qS/2OJ5tieexF
8fE2io8j9+dMG62UHnPm9HQ5ATTeM0X+9zjsKGE2SPkGU/ayJ1MxMjaFR3TT4yOB
7X0G3ieyCwr5sunnmCkNld23UPxAhw==
=+BBy
-----END PGP SIGNATURE-----

--nrsx7nlshjl4uzjt--
