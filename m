Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34966C8531
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjCXSeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjCXSd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:33:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1388821A0C
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:33:35 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfmDk-0000Jh-3A; Fri, 24 Mar 2023 19:33:00 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C68F919BB99;
        Fri, 24 Mar 2023 18:32:58 +0000 (UTC)
Date:   Fri, 24 Mar 2023 19:32:57 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/16] can: m_can: Optimizations for m_can/tcan part 2
Message-ID: <20230324183257.qpis4cip5cp4gebu@pengutronix.de>
References: <20230315110546.2518305-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="maei3lwmc22rxdz5"
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--maei3lwmc22rxdz5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.03.2023 12:05:30, Markus Schneider-Pargmann wrote:
> Hi Marc and everyone,
>=20
> third version part 2, functionally I had to move from spin_lock to
> spin_lock_irqsave because of an interrupt that was calling start_xmit,
> see attached stack. This is tested on tcan455x but I don't have the
> integrated hardware myself so any testing is appreciated.
>=20
> The series implements many small and bigger throughput improvements and
> adds rx/tx coalescing at the end.

I've applied patches 1...5 to can-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--maei3lwmc22rxdz5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQd7NcACgkQvlAcSiqK
BOho7Af/W+9fuaKIaN99W/mZF0Xe48ZngWQMU7/COYFSUIWFiX6RcLORYZRRPrxK
zMp/1uFYmTK9VBxQPd/dyHA7IA1Fa1Yf7xaRRw+XdmIxzQgfGSpQDg0gnyRc/fty
7tBr5RElXS9E2pFyuza48H+lkejkwFO9W5w+KhUjfF9FX9WkeUhMOMBbVzC6XLMT
tQTbmpD4pN53ov8JpeQYFjSGGmsPrp8e6HP2yRJxXEOX15ac+tGypBjOh52769k0
eERaA3LMXAQmYZezfDsvZkFHjD+Xe4EChmcUjQ0iqOReDxYoHjzTNjrcaPVyckYy
JhIyZVKbGp0cHEnAA915bVBI7cxscA==
=YQla
-----END PGP SIGNATURE-----

--maei3lwmc22rxdz5--
