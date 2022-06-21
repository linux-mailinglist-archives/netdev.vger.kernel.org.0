Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9E1552B85
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346501AbiFUHM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345500AbiFUHM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:12:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F962222A0
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:12:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o3Y3a-0006RX-Ql; Tue, 21 Jun 2022 09:12:14 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-bd72-15a3-eb10-2206.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:bd72:15a3:eb10:2206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 353969B386;
        Tue, 21 Jun 2022 06:35:02 +0000 (UTC)
Date:   Tue, 21 Jun 2022 08:35:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] can/esd_usb2: Added support for esd CAN-USB/3
Message-ID: <20220621063501.wxxpotw6vck42gsn@pengutronix.de>
References: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5bpvqibdgubwlgdb"
Content-Disposition: inline
In-Reply-To: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
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


--5bpvqibdgubwlgdb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Frank,

thanks for your patch!

On 20.06.2022 22:26:02, Frank Jungclaus wrote:
> This patch adds support for the newly available esd CAN-USB/3.
>=20
> The USB protocol for the CAN-USB/3 is similar to the protocol used
> for the CAN-USB/2 and the CAN-USB/Micro, so most of the code can be
> shared for all three platforms.
> Due to the fact that the CAN-USB/3 additionally supports CAN FD
> some new functionality / functions are introduced.
> Each occurrence of the term "usb2" within variables, function names,
> etc. is changed to "usb" where it is shared for all three platforms.

Can you split the patch into several ones. Please do the renaming first.
There's some seemingly unrelated reformatting, this could be a separate
patch, too. If this is too much work, you might take this into the
renaming patch. Then add the new device. This makes reviewing a lot
easier.

> The patch has been tested against / should apply to Marc's=20
> current testing branch:
> commit 934135149578 ("Merge branch 'document-polarfire-soc-can-controller=
'")

Note: Better use the linux-can-next/master branch as a base, it will be
only fast forwarded. The testing branch will be rebased. As you don't
depend on any new features, it doesn't make any difference for you.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5bpvqibdgubwlgdb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKxZpIACgkQrX5LkNig
010Wzgf9EESo1mSFr/dxiOtxvp0BR3UdEVIbciQ4jaSBnN1ANqBSmp0Vb1JsaXdx
ueC/1P4q9gygB15XcS7ITmOI3pfQwKcEbW/c/X8CJn7gCU1fRRDrqKtlloYY+i8u
xkwAY3Vgy7hJ1M1gChDJ+7WFTkXEL86agYZmYxGPQBB+GBsLF50d7Jgsn6Piuge3
3Mw6X2T7PWsYeQ1CA6YHhcplKuMLUZZ10tM1rDnVVcRMjzjS/hCk+wSJ67KKo1mr
Iy6GeLT0fkDvr/hLpZfJqFSk892lK4jyur4rHTFjXRmUx0fM9mnZc1rwiCObOWsy
sHIJhathYttsCASc9/vj16torj6Szw==
=Bhiy
-----END PGP SIGNATURE-----

--5bpvqibdgubwlgdb--
