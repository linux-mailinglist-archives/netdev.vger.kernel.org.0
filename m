Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58724854AF
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiAEOe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240948AbiAEOe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:34:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6288CC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:34:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57NK-00037A-IT; Wed, 05 Jan 2022 15:34:50 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-7899-4998-133d-b4b9.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7899:4998:133d:b4b9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1AA216D1AA5;
        Wed,  5 Jan 2022 14:34:49 +0000 (UTC)
Date:   Wed, 5 Jan 2022 15:34:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <20220105143448.pnckx2wgal2y3rll@pengutronix.de>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
 <YbHvcDhtZFTyfThT@smile.fi.intel.com>
 <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
 <YbNT4iOj+jfMiIDu@smile.fi.intel.com>
 <YdWpWSMhzmElnIJH@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="762u6kffwpy7zvea"
Content-Disposition: inline
In-Reply-To: <YdWpWSMhzmElnIJH@smile.fi.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--762u6kffwpy7zvea
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.01.2022 16:21:13, Andy Shevchenko wrote:
> On Fri, Dec 10, 2021 at 03:19:31PM +0200, Andy Shevchenko wrote:
> > On Fri, Dec 10, 2021 at 02:06:07PM +0100, Marc Kleine-Budde wrote:
> > > On 09.12.2021 13:58:40, Andy Shevchenko wrote:
> > > > On Thu, Dec 02, 2021 at 10:58:55PM +0200, Andy Shevchenko wrote:
> >=20
> > ...
> >=20
> > > > Marc, what do you think about this change?
> > >=20
> > > LGTM, added to linux-can-next/testing.
> >=20
> > Thanks for applying this and hi311x patches!
>=20
> Can we have a chance to see it in the v5.17-rc1?

Yes:
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/=
?h=3Dlinux-can-next-for-5.17-20220105

'about to send that PR.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--762u6kffwpy7zvea
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHVrIUACgkQqclaivrt
76kBnggAiDw0TUmgxr0o/LYLxeriAV+TB/mXMAirE1sX7f8bBL+4jty9j91esGmp
/Z5EPqZ16LUUpxuyM6dsQj2e7k+L9nZ3TaHzAs8KpHMC0l89wLd3bP8PVH5Lzbkt
wc4ITxLoveDQ1Jx2sP9GhbmG4Tx3caskycLvG9cxPqi3yTJXowCt95abVv09m6tg
HvYmU45/UFZ3XCAqzEkvz8Y8UldkjqnvyDF/z4/wKFhs3Sa/nl6oqCHEDA71076s
qwVv3qjCEiWg2pMbYLYT8FVnC96DpUJl7p6pVHcsgF9f7CMFq+FFUG6RRLgB34kS
wm7i6DEcEfllLJyDml0xA6ljpYLWoQ==
=NVy2
-----END PGP SIGNATURE-----

--762u6kffwpy7zvea--
