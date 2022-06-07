Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CCE53FB85
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbiFGKjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241218AbiFGKjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:39:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE182165
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:39:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyWcQ-0002wT-H4; Tue, 07 Jun 2022 12:39:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 75C2B8DB67;
        Tue,  7 Jun 2022 10:39:24 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:39:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] can: slcan: extend supported features
Message-ID: <20220607103923.5m6j4rykvitofsv4@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <CAMZ6RqLNq2tQjjJudSZ5c_fJ2VR9cX5ihjhhuNszm4wG-DgLfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xgepnltc5v4uivgz"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLNq2tQjjJudSZ5c_fJ2VR9cX5ihjhhuNszm4wG-DgLfw@mail.gmail.com>
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


--xgepnltc5v4uivgz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 19:27:05, Vincent MAILHOL wrote:
> On Tue. 7 juin 2022 at 18:47, Dario Binacchi
> <dario.binacchi@amarulasolutions.com> wrote:
> > This series originated as a result of CAN communication tests for an
> > application using the USBtin adapter (https://www.fischl.de/usbtin/).
> > The tests showed some errors but for the driver everything was ok.
> > Also, being the first time I used the slcan driver, I was amazed that
> > it was not possible to configure the bitrate via the ip tool.
> > For these two reasons, I started looking at the driver code and realized
> > that it didn't use the CAN network device driver interface.
>=20
> That's funny! Yesterday, I sent this comment:
> https://lore.kernel.org/linux-can/CAMZ6RqKZwC_OKcgH+WPacY6kbNbj4xR2Gdg2NQ=
tm5Ka5Hfw79A@mail.gmail.com/
>=20
> And today, you send a full series to remove all the dust from the
> slcan driver. Do I have some kind of mystical power to summon people
> on the mailing list?

That would be very useful and awesome super power, I'm a bit jealous. :D

> > Starting from these assumptions, I tried to:
> > - Use the CAN network device driver interface.
>=20
> In order to use the CAN network device driver, a.k.a. can-dev module,
> drivers/net/can/Kbuild has to be adjusted: move slcan inside CAN_DEV
> scope.
>=20
> @Mark: because I will have to send a new version for my can-dev/Kbuild
> cleanup, maybe I can take that change and add it to my series?

Let's get the your Kconfig/Makefile changes into can-next/master first.
Then Dario can then base this series on that branch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xgepnltc5v4uivgz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfKtkACgkQrX5LkNig
011xmQf/ffpSv+fL/PqSO5wtSUD5NNHM5cadO7QD4IDA9j6ySG4ZNM6bEBW9iq+e
KnAhMAFEe9560wYzftx4ZrDsi6CRJoNcSdPYPA0ETEu4aCwZLjbnorcjcm7F+aQp
qgNwDK/vYbSBqUSQFYCokGeuiwCrgZDzheUye1Z+zhFripjaltaTMGO62Pypc/wg
n8CUnzkcP1YDAoUMLGFcXWQMRgjVR3e7PMQNLln0R6SYDMhVL/VsdntfLBDLnNC1
z7IKfZfZN01tkCPbA6j6TBQWRyi3iORFzDB9AmhpVJerHpLTeb8yuvToQfJR2/SP
vSeFf9RD3tACnm/4FtDzk7UO0Dx0PQ==
=M5oH
-----END PGP SIGNATURE-----

--xgepnltc5v4uivgz--
