Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F695464BA
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 12:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349180AbiFJKzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 06:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349192AbiFJKyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 06:54:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D267921256B
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 03:51:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzcEU-0000CS-8q; Fri, 10 Jun 2022 12:51:14 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 775AE91008;
        Fri, 10 Jun 2022 10:51:10 +0000 (UTC)
Date:   Fri, 10 Jun 2022 12:51:09 +0200
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
Message-ID: <20220610105109.he4tiihbxggxhx7f@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com>
 <20220607105225.xw33w32en7fd4vmh@pengutronix.de>
 <CABGWkvozX51zeQt16bdh+edsjwqST5A11qtfxYjTvP030DnToQ@mail.gmail.com>
 <20220609063813.jf5u6iaghoae5dv3@pengutronix.de>
 <CABGWkvrViDyWfU=PUfKq2HXnDjhiZdOMWSBt3xcmxFKxhHKCyw@mail.gmail.com>
 <20220609080112.24bw2764ov767pqc@pengutronix.de>
 <CABGWkvq2nbfYRww0KWB1YxLQ92hjsWjfV9+nT-cKzc5FPF=DzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fmv4lnkvnggz7rbr"
Content-Disposition: inline
In-Reply-To: <CABGWkvq2nbfYRww0KWB1YxLQ92hjsWjfV9+nT-cKzc5FPF=DzA@mail.gmail.com>
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


--fmv4lnkvnggz7rbr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.06.2022 10:52:03, Dario Binacchi wrote:
> > > The help option of slcan_attach and slcand prints " -f (read status
> > > flags with 'F\\r' to reset error states)\n" I looked at the sources of
> > > the adapter I am using (USBtin, which uses the mcp2515 controller).
> > > The 'F' command reads the EFLG register (0x2d) without resetting the
> > > RX0OVR and RX1OVR overrun bits.
> >
> > The Lawicel doc [1] says 'F' is to read the status flags not to clear
> > it. However commit 7ef581fec029 ("slcan_attach: added '-f' commandline
> > option to read status flags") [2] suggests that there are some adapters
> > that the reading of the status flag clears the errors. IMHO the 'F'
> > command should be send unconditionally during open.
>=20
> When in doubt I would follow the slcand / slcan_attach approach, that don=
't
> send the 'F \ r' command by default. We would be more backward compatible
> as regards the sequence of commands to be sent to the controller.

Ok, keep it this way.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fmv4lnkvnggz7rbr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKjIhsACgkQrX5LkNig
010VdggAgzCPnmFDsBxLr+elg2NDIiGGSoOr+fWEHtMIkE37bCM9+3W7Ykh5lb1E
/g/eElBH89yLwRVxZfSHuWiu4uFTYflF6/4Jh1sOmOWLHHiFt9XhWDDNw4lOwZ/t
Y7gxaOiSgf5lUdcAvpFhBDP75GuH14uP3zeZTdpHbE836gFjXh9gPe5+1MJc6YJb
rTD2omTEBR8a01XUzTuooRdCoChRj3ekr7fzVxQZYpLPxnsZVJRabwEfKT4+iEr4
B7HfOdIeqtgVpOMj/hnns99US6Izxzz7gVxZLBH8gucqy3WoietOWZ7VI+tOirE+
JTA0661k6mExdytVRzUMgZRhYVfEGA==
=Fqe+
-----END PGP SIGNATURE-----

--fmv4lnkvnggz7rbr--
