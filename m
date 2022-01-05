Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC248551C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241147AbiAEOyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiAEOyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:54:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917EEC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:54:52 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57gc-0005tC-Sz; Wed, 05 Jan 2022 15:54:46 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-7899-4998-133d-b4b9.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7899:4998:133d:b4b9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 271596D1BFB;
        Wed,  5 Jan 2022 14:54:46 +0000 (UTC)
Date:   Wed, 5 Jan 2022 15:54:45 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <20220105145445.fton3qt5szecwy4y@pengutronix.de>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
 <YbHvcDhtZFTyfThT@smile.fi.intel.com>
 <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
 <YbNT4iOj+jfMiIDu@smile.fi.intel.com>
 <YdWpWSMhzmElnIJH@smile.fi.intel.com>
 <20220105143448.pnckx2wgal2y3rll@pengutronix.de>
 <YdWvfdRTpPZ0YcSD@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="moumr2otajt4bson"
Content-Disposition: inline
In-Reply-To: <YdWvfdRTpPZ0YcSD@smile.fi.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--moumr2otajt4bson
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.01.2022 16:47:25, Andy Shevchenko wrote:
> > > Can we have a chance to see it in the v5.17-rc1?
> >=20
> > Yes:
> > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/=
log/?h=3Dlinux-can-next-for-5.17-20220105
> >=20
> > 'about to send that PR.
>=20
> Cool, thanks! Happy new year!

Thanks. Happy new year, too!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--moumr2otajt4bson
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHVsTIACgkQqclaivrt
76nPCwf/eCXKkkJEyH0493PhSIQujsikknG1Iml6sqKoFq9rwF4h8mSbRgpaVRIn
9EGT/EE5mNzFBVUo2B0on2cw/1ygYWkQ5ySj/P9SYw9U1Sx+7RRdBXFt4MKmCmq0
mKzfAY3quIxmzEiPTegtbcAeN5wN8PiM9G0YvDGbFkEtujd5Z4Ekik8zZ8Sm0Qx7
G7PJrsFmU0viZU9LrbHwwApLMDwLLuLYZVuCaDCvtDvCjMZIkGs4ywg0k/ZTSjtV
3W1P+1cBXqcLhRtdKGNCxxpFOYGQrin3smFa7PZPm0l9S734rDCFrCWM5NOkVFG8
//hgrO50xxttmkQ2c56RsVrLFYUOQg==
=WWje
-----END PGP SIGNATURE-----

--moumr2otajt4bson--
