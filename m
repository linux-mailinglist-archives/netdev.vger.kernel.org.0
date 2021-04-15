Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D3F36087C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 13:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhDOLrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 07:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhDOLro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 07:47:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D693AC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 04:47:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lX0So-0005kK-1U; Thu, 15 Apr 2021 13:47:14 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:983:856d:54dc:ee1c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 78A1E60F64A;
        Thu, 15 Apr 2021 11:47:12 +0000 (UTC)
Date:   Thu, 15 Apr 2021 13:47:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Colin King <colin.king@canonical.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] can: etas_es58x: Fix missing null check on netdev
 pointer
Message-ID: <20210415114711.fqxj2j744fmqw6pb@pengutronix.de>
References: <20210415084723.1807935-1-colin.king@canonical.com>
 <20210415090412.q3k4tmsp3rdfj54t@pengutronix.de>
 <CAMZ6RqJvN10Qf7rg-Z1aD82kJGPqueqgr+t88=yoJH93m+OuGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t7rubfvizd7wa7y7"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJvN10Qf7rg-Z1aD82kJGPqueqgr+t88=yoJH93m+OuGw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--t7rubfvizd7wa7y7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.04.2021 20:42:36, Vincent MAILHOL wrote:
> On Thu. 15 Apr 2021 at 18:04, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 15.04.2021 09:47:23, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > >
> > > There is an assignment to *netdev that is can potentially be null but=
 the
>                                            ^^
> Typo: that is can -> that can

Fixed.

> > > null check is checking netdev and not *netdev as intended. Fix this by
> > > adding in the missing * operator.
> > >
> > > Addresses-Coverity: ("Dereference before null check")
> > > Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58=
X CAN USB interfaces")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
>=20
> Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Added to the patch.

Tnx,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--t7rubfvizd7wa7y7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB4J70ACgkQqclaivrt
76kHtAgAr2VHjyVKYe8lsy62ZU9S+BhaUtOfaHJF8shAcpOeiyBIJyAaxExUjGri
xEmOffCtfWmRmuk3sWLczgQ5690LfMZIGCz2n5zJZ2wjxUywNnWFCKY60pWKhYly
kR2GVviWErqSq5V2ibkj7qCgQCtMAPsQinJx4YbSmw37xVFaluCZfDobiznLs0Xk
ZLgpCXK4kzXrI0ZpoVJ4Lpc4lz7eF/l9z62oUlAxBGx0b2lIe4ogRPIzKG7gGci8
CZY+aWMUGOVNkdcO2gm/9bPH9Ot58QAS1Y1D0FPX4lxRgKr7TRtT7QQl3gof/9ik
LaFtRQ7qWKpbaVTLiOgg0Mu9bbfJpg==
=qXQD
-----END PGP SIGNATURE-----

--t7rubfvizd7wa7y7--
