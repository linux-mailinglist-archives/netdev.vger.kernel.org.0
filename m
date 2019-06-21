Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C094E699
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 13:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfFULAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 07:00:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51975 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfFULAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 07:00:34 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 11FC68057B; Fri, 21 Jun 2019 13:00:19 +0200 (CEST)
Date:   Fri, 21 Jun 2019 12:59:42 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-leds@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 20/29] docs: leds: convert to ReST
Message-ID: <20190621105942.GA24145@amd>
References: <cover.1560890800.git.mchehab+samsung@kernel.org>
 <b8185b2d816810281a2b712c70518159516785b6.1560890801.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <b8185b2d816810281a2b712c70518159516785b6.1560890801.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-06-18 17:53:38, Mauro Carvalho Chehab wrote:
> Rename the leds documentation files to ReST, add an
> index for them and adjust in order to produce a nice html
> output via the Sphinx build system.
>=20
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0MuJ4ACgkQMOfwapXb+vLr4wCgr/sTE2xCAfouKtIL4+mRDlDH
r3gAniPvzpOgYRlsEHIkVK0sPOYobZVO
=AOCV
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
