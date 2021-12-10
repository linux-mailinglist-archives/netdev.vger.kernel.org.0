Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5381846FC40
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbhLJIFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238076AbhLJIFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:05:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A597EC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:02:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mvar0-0004Ti-8Q; Fri, 10 Dec 2021 09:02:06 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-5708-5a2a-1200-a3e0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5708:5a2a:1200:a3e0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A68856C11AD;
        Fri, 10 Dec 2021 08:02:04 +0000 (UTC)
Date:   Fri, 10 Dec 2021 09:02:03 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Jimmy Assarsson <extja@kvaser.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, Yasushi SHOJI <yashi@spacecubics.com>
Subject: Re: [PATCH v5 3/5] can: do not copy the payload of RTR frames
Message-ID: <20211210080203.sydpxiczjq3etxzm@pengutronix.de>
References: <20211207121531.42941-1-mailhol.vincent@wanadoo.fr>
 <20211207121531.42941-4-mailhol.vincent@wanadoo.fr>
 <20211210073545.qdldwmaykts5dr4u@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g4sbyd7w37o5qcbj"
Content-Disposition: inline
In-Reply-To: <20211210073545.qdldwmaykts5dr4u@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--g4sbyd7w37o5qcbj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.12.2021 08:35:45, Marc Kleine-Budde wrote:
> On 07.12.2021 21:15:29, Vincent Mailhol wrote:
> > The actual payload length of the CAN Remote Transmission Request (RTR)
> > frames is always 0, i.e. nothing is transmitted on the wire. However,
>                            ^^^^^^^
> I've changed this to "no payload" to make it more unambiguous.

Same for the other patches.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--g4sbyd7w37o5qcbj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGzCXkACgkQqclaivrt
76kh8Af/ahVBiyHkUsLlsXLUzg8gKGy94jUBzOO68kzADSNEES/sS1ckCY+QAEwA
WgmRffiBL+0f0CVZGcpDKxBdF1SYTIq447RW8Ig5XOOxaop0/E/Tq4vGbchuPXGt
NgEvUUDAFGykCCztepDDvbLHaaZQbdeESBry6HdumxJY1ak9c6f4dt0GzM9aUkAq
6QM9TlGHFBcriqt42dkGdFrY/01fbQwEo0BFAuJs0ocGl87/D1p8MzsTAycdwdzo
JJv7Md+Z1/P2LOoyG++4dGsqc80lVKZYv+K+Oym8rDZhQak/+sH/Uc9JaP/iaG30
Z5I8UV+TMDvk1FzY1vViA/12IWiLjA==
=zD6b
-----END PGP SIGNATURE-----

--g4sbyd7w37o5qcbj--
