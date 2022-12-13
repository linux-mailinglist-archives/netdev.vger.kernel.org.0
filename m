Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB99964BD15
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiLMTS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiLMTSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:18:13 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F761AF24
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 11:18:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p5An1-00046O-Uz; Tue, 13 Dec 2022 20:18:08 +0100
Received: from pengutronix.de (hardanger.fritz.box [IPv6:2a03:f580:87bc:d400:154c:16df:813d:4fb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7131713E196;
        Tue, 13 Dec 2022 19:18:07 +0000 (UTC)
Date:   Tue, 13 Dec 2022 20:18:07 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221213191807.kdpfhh2eo5ujtqgq@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
 <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
 <20221201101220.r63fvussavailwh5@blmsp>
 <20221201110033.r7hnvpw6fp2fquni@pengutronix.de>
 <20221201165951.5a4srb7zjrsdr3vd@blmsp>
 <20221213171946.ejrb2glgo77jueff@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="73dyuhnoq6p7v3ny"
Content-Disposition: inline
In-Reply-To: <20221213171946.ejrb2glgo77jueff@blmsp>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--73dyuhnoq6p7v3ny
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.12.2022 18:19:46, Markus Schneider-Pargmann wrote:
> Hi Marc,
>=20
> On Thu, Dec 01, 2022 at 05:59:53PM +0100, Markus Schneider-Pargmann wrote:
> > On Thu, Dec 01, 2022 at 12:00:33PM +0100, Marc Kleine-Budde wrote:
> > > On 01.12.2022 11:12:20, Markus Schneider-Pargmann wrote:
> > > > > > For the upcoming receive side patch I already added a hrtimer. =
I may try
> > > > > > to use the same timer for both directions as it is going to do =
the exact
> > > > > > same thing in both cases (call the interrupt routine). Of cours=
e that
> > > > > > depends on the details of the coalescing support. Any objection=
s on
> > > > > > that?
> > > > >=20
> > > > > For the mcp251xfd I implemented the RX and TX coalescing independ=
ent of
> > > > > each other and made it configurable via ethtool's IRQ coalescing
> > > > > options.
> > > > >=20
> > > > > The hardware doesn't support any timeouts and only FIFO not empty=
, FIFO
> > > > > half full and FIFO full IRQs and the on chip RAM for mailboxes is=
 rather
> > > > > limited. I think the mcan core has the same limitations.
> > > >=20
> > > > Yes and no, the mcan core provides watermark levels so it has more
> > > > options, but there is no hardware timer as well (at least I didn't =
see
> > > > anything usable).
> > >=20
> > > Are there any limitations to the water mark level?
> >=20
> > Anything specific? I can't really see any limitation. You can set the
> > watermark between 1 and 32. I guess we could also always use it instead
> > of the new-element interrupt, but I haven't tried that yet. That may
> > simplify the code.
>=20
> Just a quick comment here after trying this, I decided against it.
> - I can't modify the watermark levels once the chip is active.
> - Using interrupt (un)masking I can change the behavior for tx and rx
>   with a single register write instead of two to the two fifo
>   configuration registers.

Makes sense.

> You will see this in the second part of the series then.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--73dyuhnoq6p7v3ny
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOYz+wACgkQrX5LkNig
0101Tgf/Q0VDS3beXweKnmW9HqfmcKbFGCg8iHZ7p5AO5PQSX0aRM2m+73ZkzSON
HbRst8mGO6Q3BQ0yZiz500wCK8jyHeoQEmKHneLwYvc/e1yJO9KW2Zh61+mYwTxr
yp7SF7Uw5iaoQY70w5iIukCuY6lHp+zlQuNsxLSTUvgx1Om89Ub2cMUjXVg1YxSo
2NoPjFRcibDoa+9OzEu3duo2uHV3cnS9MTyhqHhF8uOimuRKXxihVq3YT0YAs9Ef
3ils96dmIAg1VB2gnvGm2nitlgg7+Vsqw8QyO6R730y5hwhei9eENb7JRTHp1JU+
QzaRhlwVsQtPzALvmzCNvkURTCu4qA==
=JtNz
-----END PGP SIGNATURE-----

--73dyuhnoq6p7v3ny--
