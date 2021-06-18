Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413DE3AC7A4
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhFRJdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:33:10 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48624 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbhFRJce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:32:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 992DE1C0B76; Fri, 18 Jun 2021 11:30:24 +0200 (CEST)
Date:   Fri, 18 Jun 2021 11:30:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     David Miller <davem@davemloft.net>
Cc:     pavel@denx.de, linux-kernel@vger.kernel.org,
        colin.king@canonical.com, rajur@chelsio.com, kuba@kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cxgb4: fix wrong shift.
Message-ID: <20210618093024.GA19955@duo.ucw.cz>
References: <20210615095651.GA7479@duo.ucw.cz>
 <20210615.112242.1470575442069805806.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20210615.112242.1470575442069805806.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2021-06-15 11:22:42, David Miller wrote:
> From: Pavel Machek <pavel@denx.de>
> Date: Tue, 15 Jun 2021 11:56:51 +0200
>=20
> > While fixing coverity warning, commit
> > dd2c79677375c37f8f9f8d663eb4708495d595ef introduced typo in shift
> > value. Fix that.
> >    =20
> > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
>=20
> Please repost with an appropriate Fixes: tag, thank you.

Done, you should have PATCHv2 in your inbox.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYMxnsAAKCRAw5/Bqldv6
8hK7AKCnvFjPrjDPWADoYq4TJCc6J/w7pACbB6JwEPpI11vv2r9dbIPc2BiD4Jk=
=dd6X
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
