Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A133D6C0D
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 04:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhG0CES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 22:04:18 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:43920 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhG0CEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 22:04:16 -0400
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2021 22:04:16 EDT
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1m8Chj-0007ER-B8; Tue, 27 Jul 2021 04:20:23 +0200
Received: from ben by deadeye with local (Exim 4.94.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1m8Chi-000cTJ-KA; Tue, 27 Jul 2021 04:20:22 +0200
Date:   Tue, 27 Jul 2021 04:20:22 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, carnil@debian.org
Subject: Re: [PATCH net 1/4] sctp: validate from_addr_param return
Message-ID: <YP9tZryTbUGaQQ+e@decadent.org.uk>
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
 <a8a08b7fbb0bf76377e26584682c12dd82202d2e.1624904195.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l8KlNNhMC8kbt7or"
Content-Disposition: inline
In-Reply-To: <a8a08b7fbb0bf76377e26584682c12dd82202d2e.1624904195.git.marcelo.leitner@gmail.com>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l8KlNNhMC8kbt7or
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 28, 2021 at 04:13:41PM -0300, Marcelo Ricardo Leitner wrote:
[...]
> @@ -1174,7 +1175,8 @@ static struct sctp_association *__sctp_rcv_asconf_l=
ookup(
>  	if (unlikely(!af))
>  		return NULL;
> =20
> -	af->from_addr_param(&paddr, param, peer_port, 0);
> +	if (af->from_addr_param(&paddr, param, peer_port, 0))
> +		return NULL;
> =20
>  	return __sctp_lookup_association(net, laddr, &paddr, transportp);
>  }
[...]

This condition needs to be inverted, doesn't it?

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--l8KlNNhMC8kbt7or
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmD/bWEACgkQ57/I7JWG
EQkoVw/9EGrgEYZ3OHwwXGI2peGZ3V0z/R0pYw7Jpvs5skI49MeuwZdHMXB3h+Kf
57nYT9Sy+mOI8ilvlBcXpTimv4Nnog4nv2cT/GX7VpxcWeegQDBLpCqAdOF4C64S
gc078OeX2DTq0nc59cdookKN1Z3QKdpNshw9WrPOPdX7lWeB93UB2DZENpM4Q+N1
dDM35HSuCYzotfgyryuAY1khHJHgN7f4MloZfIskKPlsBitSPA4SwtR2FafyNohA
nyAot0de8WMx7wdNCYVdK7TfL2KgVuaXakMkQpVOSynv2aVigeDPkw0NXruanAPx
dCF+LvdKVbxuD7XwTmdmRovMsuMG9fzYFYe2szNUVvw0aN9JFWs2TCc00clqhvyU
XMn+XxMJMCZS+fbsuKjOCDgxn4wxVaWyFzys0xMyPvAjnMOig4r91gkzgxVwV6zq
TYIB0lUIFwszNHOjqugEHXrx4Ks0lNxIz28eDdoEXewabDFkVpt6jJGg/dEmFOqx
5Izr9uRhJ2Mcj5IXJQegCLzRp9eeYzFg9YdmQ4Jkc2CGNCG3uuzue7xowPsh0Da8
KxgqM04QL7GsFk4wDvukNstlKyB2aD9pdoKR3niRWQKC7R9k4aToWdht6loZx+eS
Ewemb1LmsRXFOu+UtEy5ZS0nGC9bl2siqap38G/KFFtxYEqfqlA=
=lAh5
-----END PGP SIGNATURE-----

--l8KlNNhMC8kbt7or--
