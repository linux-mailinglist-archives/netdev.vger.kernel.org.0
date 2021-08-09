Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66663E4673
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhHINXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbhHINXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:23:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE2DC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 06:22:49 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mD5EY-0004BF-Pq; Mon, 09 Aug 2021 15:22:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:565a:9e00:3ca4:4826])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 592916634AA;
        Mon,  9 Aug 2021 13:22:22 +0000 (UTC)
Date:   Mon, 9 Aug 2021 15:22:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v4 3/3] arm64: dts: renesas: r9a07g044: Add CANFD node
Message-ID: <20210809132220.dr5fguraiuyfc47k@pengutronix.de>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210804075855.2vjvfb67kufiibqx@pengutronix.de>
 <CA+V-a8tWMVfnS3PWeOSqtDddO-M6zDS+WFpUSjv=2MgUV56Qvg@mail.gmail.com>
 <CAMuHMdU5q0_gC7e_n=+Nq-1q2OkOvEB_iY7bMRnB0ZAcOZk9Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6ok3gdedsoqgsdxb"
Content-Disposition: inline
In-Reply-To: <CAMuHMdU5q0_gC7e_n=+Nq-1q2OkOvEB_iY7bMRnB0ZAcOZk9Eg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6ok3gdedsoqgsdxb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.08.2021 15:05:30, Geert Uytterhoeven wrote:
> > > This doesn't apply to net-next/master, the r9a07g044.dtsi doesn't hav=
e a
> > > i2c0 node at all. There isn't a i2c0 node in Linus' master branch, ye=
t.
> > >
> > I had based the patch on top [1] (sorry I should have mentioned the
> > dependency), usually Geert picks up the DTS/I patches and queues it
> > via ARM tree. Shall I rebase it on net-next and re-send ?
> >
> > @Geert Uytterhoeven Is that OK ?
>=20
> Please do not take Renesas DTS patches through the netdev tree
> (or any other subsystem tree).

Ok, I'm taking path 1 and 2 then.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6ok3gdedsoqgsdxb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmERLAoACgkQqclaivrt
76mo9Qf8CZ0JJWPgA33crkNVLB+u0tltfBSDMshDI9dcbzi6dNWEBeZeV9LYQbdy
3bJMII7VgsbNrgLDbfIvkQb8ZEy51234cLYjo+KbnDi/sfTsxmjeTsywXGN7AIjt
ZZUHg1CRixfx9OPDUTp5ju7KWWHeCHAlkvu9LUgWOvRrq0aaiOPBYodojZqDjYtk
G7ZYFqjkbY9HhJ1E3022iP+vZbZv7z+b45eUAJQn2u2mGfBC2WU1GuO9NvQ/wGeu
uRZeIEIDed307rDvHDcqNL2ivyusfoZ71zHahqwir+/MYqVs35FwltQz4GE3w77L
KcLA3oVOFv96JkUYBg8HsD+kGXjwRw==
=ppvL
-----END PGP SIGNATURE-----

--6ok3gdedsoqgsdxb--
