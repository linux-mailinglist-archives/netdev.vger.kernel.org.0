Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA52749CB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgIVUF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:05:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54916 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgIVUF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:05:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9238C1C0BAC; Tue, 22 Sep 2020 22:05:24 +0200 (CEST)
Date:   Tue, 22 Sep 2020 22:05:24 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     eranbe@mellanox.com, lariel@mellanox.com, saeedm@mellanox.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: remove unreachable return
Message-ID: <20200922200524.GA4975@duo.ucw.cz>
References: <20200921114103.GA21071@duo.ucw.cz>
 <5d37fdcb0d50d79f93e8cdb31cb3f182548ffcc1.camel@kernel.org>
 <4eb581435bd7ac528c29815a7d26016bd1c429f4.camel@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <4eb581435bd7ac528c29815a7d26016bd1c429f4.camel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-09-22 12:54:20, Saeed Mahameed wrote:
> On Mon, 2020-09-21 at 22:54 -0700, Saeed Mahameed wrote:
> > On Mon, 2020-09-21 at 13:41 +0200, Pavel Machek wrote:
> > > The last return statement is unreachable code. I'm not sure if it
> > > will
> > > provoke any warnings, but it looks ugly.
> > >    =20
> > > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > >=20
> > >=20
> >=20
> > Applied to net-next-mlx5.
> >=20
> > Thanks,
> > Saeed.
> >=20
>=20
> Actually checkpatch reports this issue:
> WARNING:NO_AUTHOR_SIGN_OFF: Missing Signed-off-by: line by nominal
> patch author 'Pavel Machek <pavel@ucw.cz>'
>=20
> Do you want me to override the Signed-off-by tag with the above email ?

Sorry about that.

Actually, overriding patch author to match signoff would be better (I
should have sent it from: denx), but either way is okay with me.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2pZBAAKCRAw5/Bqldv6
8jkJAKCN+rn7YSGCZRIAF9TT3/s9SQHGWQCfdyaR/Z42wf5Wjz13hY8Ctge+uIk=
=sk8T
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
