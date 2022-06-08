Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57465428B0
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiFHH4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiFHHzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 03:55:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612C719CED3
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:25:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyq2V-0006tL-8N; Wed, 08 Jun 2022 09:23:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 09B2E8EA6B;
        Wed,  8 Jun 2022 07:19:47 +0000 (UTC)
Date:   Wed, 8 Jun 2022 09:19:47 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] can: slcan: extend supported features
Message-ID: <20220608071947.pwl4whyzqpyubzqn@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220608021537.04c45cf9.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zltmsl6xgx33hokg"
Content-Disposition: inline
In-Reply-To: <20220608021537.04c45cf9.max@enpas.org>
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


--zltmsl6xgx33hokg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.06.2022 02:15:37, Max Staudt wrote:
> To speed up the slcan cleanup, may I suggest looking at can327?
>=20
> It started as a modification of slcan, and over the past few months,
> it has gone through several review rounds in upstreaming. In fact, a
> *ton* of things pointed out during reviews would apply 1:1 to slcan.
>=20
> What's more, there's legacy stuff that's no longer needed. No
> SLCAN_MAGIC, no slcan_devs, ... it's all gone in can327. May I suggest
> you have a look at it and bring slcan's boilerplate in line with it?

+1

Most of Dario's series looks good. I suggest that we mainline this
first. If there's interest and energy the slcan driver can be reworked
to re-use the more modern concepts of the can327 driver.

> It's certainly not perfect (7 patch series and counting, and that's
> just the public ones), but I'm sure that looking at the two drivers
> side-by-side could serve as a good starting point, to avoid
> re-reviewing the same things all over again.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zltmsl6xgx33hokg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKgTZAACgkQrX5LkNig
013DMQf+Oowv9u1tls3YgQbK2Ek0zFsMF5BZXa9eBmGDKBf+HIIQx5g0+pzec8gq
wBRNRaOlS1KGLewF86lK9yPxUG/CpwB9NpIDDsLtG+kL/AGfuj4Kguf/LfbjtOpV
0vAibm8x7iyJB5AKmAgnyf9F32He0evcBCam2ZbItdLLVJT3txmhCQmvIK5gQj8S
v342uBUKiTfyy+q1Z+7OfzX+iPsmRgjgz4IGNr4d/x8GvD3LMtMdFWCSKmyv0ZJ6
JTdoUILLkMj6R2w9xnurIsz1RtJXJXMHNgBu1gDx9SMGxw9MlhTC7Bv0LKJ+bJZ6
A05xF3jOzD+bLkfQF9X7a5702XOG8g==
=1VoJ
-----END PGP SIGNATURE-----

--zltmsl6xgx33hokg--
