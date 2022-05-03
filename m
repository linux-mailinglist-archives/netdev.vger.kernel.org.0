Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A874F517D91
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 08:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiECGu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 02:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiECGuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 02:50:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D13F377D7
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 23:46:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlmIq-00058T-Bn; Tue, 03 May 2022 08:46:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E808F7455F;
        Tue,  3 May 2022 06:46:27 +0000 (UTC)
Date:   Tue, 3 May 2022 08:46:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andrew Dennison <andrew.dennison@motec.com.au>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>
Subject: Re: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual
 rules and documentation linking
Message-ID: <20220503064626.lcc7nl3rze5txive@pengutronix.de>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
 <20220428072239.kfgtu2bfcud6tetc@pengutronix.de>
 <202204292331.28980.pisa@cmp.felk.cvut.cz>
 <20220502072151.j6nx5kddqxeyfy3h@pengutronix.de>
 <CAHQrW0_bxDyTf7pNHgXwcO=-0YRWtsxscOSWWU4fDmNYo8d-9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cyyqri6cnwnql6qc"
Content-Disposition: inline
In-Reply-To: <CAHQrW0_bxDyTf7pNHgXwcO=-0YRWtsxscOSWWU4fDmNYo8d-9Q@mail.gmail.com>
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


--cyyqri6cnwnql6qc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.05.2022 16:32:32, Andrew Dennison wrote:
> > > When value is configurable then for (uncommon) number
> > > of buffers which is not power of two, there will be likely
> > > a problem with way how buffers queue is implemented
> >
>=20
> Only power of 2 makes sense to me: I didn't consider those corner
> cases but the driver could just round down to the next power of 2 and
> warn about a misconfiguration of the IP core.

+1

> I added the dynamic detection because the IP core default had changed
> to 2 TX buffers and this broke some hard coded assumptions in the
> driver in a rather obscure way that had me debugging for a bit...

The mainline driver uses a hard coded default of 4 still... Can you
provide that patch soonish?

> > You can make use of more TX buffers, if you implement (fully
> > hardware based) TX IRQ coalescing (=3D=3D handle more than one TX
> > complete interrupt at a time) like in the mcp251xfd driver, or BQL
> > support (=3D=3D send more than one TX CAN frame at a time). I've played
> > a bit with BQL support on the mcp251xfd driver (which is attached by
> > SPI), but with mixed results. Probably an issue with proper
> > configuration.
>=20
> Reducing CAN IRQ load would be good.

IRQ coalescing comes at the price of increased latency, but if you have
a timeout in hardware you can configure the latencies precisely.

> > > We need 2 * priv->ntxbufs range to distinguish empty and full
> > > queue... But modulo is not nice either so I probably come with
> > > some other solution in a longer term. In the long term, I want to
> > > implement virtual queues to allow multiqueue to use dynamic Tx
> > > priority of up to 8 the buffers...
> >
> > ACK, multiqueue TX support would be nice for things like the
> > Earliest TX Time First scheduler (ETF). 1 TX queue for ETF, the
> > other for bulk messages.
>=20
> Would be nice, I have multi-queue in the CAN layer I wrote for a
> little RTOS (predates socketcan) and have used for a while.

Out of interest:
What are the use cases? How did you decide which queue to use?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cyyqri6cnwnql6qc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJwz78ACgkQrX5LkNig
010bsQf+MXL6+dSa0vRSipAheKxPJvKrSi8rwE+DztN4k+WRuAuFTxjMr0yg/cZC
lxE8J6WmpiSQs+sXFvACYeeLnYtcQpMHc6xvYZZozyJPNetRgkXURby1k/+KJP5U
CGvrdjG8G43DioIVcob7gETJ1j28xUW3kCflFgui5o/VmmtRNBhstRBboKf2ORsJ
6DvzmPgeSfos9rVkqtXsP1HtUDZRnBrI6wW8RzCGx0/YLQIadBYspu4IN7zVmWiy
WUNR5yLYY3l2rYCmWKDVgMqoXAAwKMZs3pj4AV+58RKjCBMhainOb6v/9GT33NGy
Y8UTeBdFSr6v53uivxqxE1wOwyM5NA==
=rpae
-----END PGP SIGNATURE-----

--cyyqri6cnwnql6qc--
