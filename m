Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D453771C6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 14:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhEHMbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 08:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhEHMbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 08:31:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDAC061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 05:30:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lfM6T-00037N-T6; Sat, 08 May 2021 14:30:41 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:b841:e208:7812:9dd1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 987B561F553;
        Sat,  8 May 2021 12:30:39 +0000 (UTC)
Date:   Sat, 8 May 2021 14:30:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Drew Fustini <pdp7pdp7@gmail.com>
Cc:     Drew Fustini <drew@beagleboard.org>, netdev@vger.kernel.org,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Will C <will@macchina.cc>, menschel.p@posteo.de
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <20210508123038.zzowctdgpjld23hs@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
 <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
 <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
 <CAEf4M_Dg5u=b+fYwXDUMRGSXeXHuo-bXZmzoAs2bW0kFncMSQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7mc4hxetxzanenrr"
Content-Disposition: inline
In-Reply-To: <CAEf4M_Dg5u=b+fYwXDUMRGSXeXHuo-bXZmzoAs2bW0kFncMSQg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7mc4hxetxzanenrr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.05.2021 15:36:32, Drew Fustini wrote:
> > > > Would it be possible for you to pull these patches into a v5.10 bra=
nch
> > > > in your linux-rpi repo [1]?
> > >
> > > Here you are:
> > >
> > > https://github.com/marckleinebudde/linux-rpi/tree/v5.10-rpi/backport-=
performance-improvements
> > >
> > > I've included the UINC performance enhancements, too. The branch is c=
ompiled
> > > tested only, though. I'll send a pull request to the rpi kernel after=
 I've
> > > testing feedback from you.
> >
> > Drew, Patrick, have you tested this branch? If so I'll send a pull
> > request to the raspi kernel.
>=20
> Thank you for following up.
>=20
> I need to build it and send it to the friend who was testing to check
> if the CRC errors go away.  He is testing CANFD with a 2021 Ford F150
> truck.  I will follow up here once I know the results.

The CRC Errors don't go away completely, however they are reduced by
more than an order of magnitude.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7mc4hxetxzanenrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCWhGwACgkQqclaivrt
76nq4Af/YCRApll2xTUO0JeBwC0Q3z08g6zbPpm6mwk/8tvq2DSlBvZ0lZMhuAEE
2UX/ujLBjpVPkOtjBsE5XAbClUCBr3n7ESCQKwXw8+83zIgJIzS28HZyTnJsCDDH
H0j5xryhL1rZhcgsBt5PTPQgTJ4XYtHZ2Yi6A2KKMxXn2FDoIFyP9SmIuC+dVehF
pjrYLmd0TmYMLZGyZUpSXRISFifOYZe7WRpJhIdFiznml93YTvajZf178e7LRk5P
akmvEvAlP6KtujAWVCOImpzkNkhFLgzibCZiOSz00jBflVNpoS8QsPsTeZvbKvaP
FaWGiVZBBQs0phWtOsFlPsaAIDBAlQ==
=E8ul
-----END PGP SIGNATURE-----

--7mc4hxetxzanenrr--
