Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6826D3D67D1
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhGZTWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhGZTWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:22:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317BBC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:02:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m86ns-0001co-NK; Mon, 26 Jul 2021 22:02:20 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:bb61:39f9:30bb:99fb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8838E658759;
        Mon, 26 Jul 2021 20:02:16 +0000 (UTC)
Date:   Mon, 26 Jul 2021 22:02:15 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, socketcan@hartkopp.net,
        mailhol.vincent@wanadoo.fr, b.krumboeck@gmail.com,
        haas@ems-wuensche.com, Stefan.Maetje@esd.eu, matthias.fuchs@esd.eu,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] can: fix same memory leaks in can drivers
Message-ID: <20210726200215.wnfwj27v2x2vyyup@pengutronix.de>
References: <cover.1627311383.git.paskripkin@gmail.com>
 <20210726202916.5945e3d9@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="63zbmxht67o6x4ka"
Content-Disposition: inline
In-Reply-To: <20210726202916.5945e3d9@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--63zbmxht67o6x4ka
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.07.2021 20:29:16, Pavel Skripkin wrote:
> On Mon, 26 Jul 2021 18:29:38 +0300
> Pavel Skripkin <paskripkin@gmail.com> wrote:
>=20
> > Hi, Marc and can drivers maintainers/reviewers!
> >=20
>=20
> I reread this I found out, that I missed logic here.
>=20
> I mean:
>=20
> > A long time ago syzbot reported memory leak in mcba_usb can
> > driver[1]. It was using strange pattern for allocating coherent
> > buffers, which was leading to memory leaks.
>=20
> I fixed this wrong pattern in mcba_usb driver and

Thanks for your patches! Please resend them with an updated description
and the fixed patch 3.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--63zbmxht67o6x4ka
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD/FMQACgkQqclaivrt
76nrjQf/TTofghGBF24758Ocv4jTf+JAbhnZVQumdEB0CIG1gpEQdvfcHN0DOc+v
e3Ex/uwhAZur2owZghqVFvM8LAbHEJOfZCcXSXMYWW5AdxeH5D2ML+RYlIpL5MP6
PcXETRwW5LBGMCp8zAVsn17HDRusciQ1llAY8yDzvaCaO5+7slIcKz8A+aOpItso
zbLWgs1gtdkDUoJ3rIMhq+PLen2fQnDeSGVHa8TgdVs0eNR2TWCu0dOlyVPIk45V
JST5J/gT6ME1AgjEO69bSoAx1DxDkYDdi6GC/BeomPk9nZS9+/VNOOlnxlQkZpaf
A0tLby0E9O3bmB2zLYgZ9CYmk9t6Xw==
=mdMZ
-----END PGP SIGNATURE-----

--63zbmxht67o6x4ka--
