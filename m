Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0408431803
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhJRLvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJRLvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 07:51:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C74CC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 04:48:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcR8G-0003IK-0z; Mon, 18 Oct 2021 13:48:44 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c2ef-28ab-e0cd-e8fd.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c2ef:28ab:e0cd:e8fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1680869667F;
        Mon, 18 Oct 2021 11:48:42 +0000 (UTC)
Date:   Mon, 18 Oct 2021 13:48:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] can: rcar: Drop unneeded ARM dependency
Message-ID: <20211018114841.g6lhqmhjj5dkddqm@pengutronix.de>
References: <362d9ced19f3524ee8917df5681b3880c13cac85.1630416373.git.geert+renesas@glider.be>
 <20210831133238.75us5ipf25wzqkuq@pengutronix.de>
 <CAMuHMdX63XMfHS+d9FM0oR_-hnFi4z_GsSwhCmkNKQ01093ttQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dqep4stlafi7ze6u"
Content-Disposition: inline
In-Reply-To: <CAMuHMdX63XMfHS+d9FM0oR_-hnFi4z_GsSwhCmkNKQ01093ttQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dqep4stlafi7ze6u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.10.2021 13:34:34, Geert Uytterhoeven wrote:
> Hi Marc,
>=20
> On Tue, Aug 31, 2021 at 3:32 PM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> > On 31.08.2021 15:27:40, Geert Uytterhoeven wrote:
> > > The dependency on ARM predates the dependency on ARCH_RENESAS.
> > > The latter was introduced for Renesas arm64 SoCs first, and later
> > > extended to cover Renesas ARM SoCs, too.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Applied to linux-can-next/testing.
>=20
> Thanks!
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/lo=
g/?h=3Dtesting
> still predates my patch. Am I looking at the wrong tree?

I've just updated the branch.

I'm working on can-next patches while waiting on other things, and I'm
not finished yet, so I haven't pushed it until now. More updates and
probably rebases will be done to the testing branch.

Regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dqep4stlafi7ze6u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFtXxYACgkQqclaivrt
76nUVAgAkjgphtYG7xiudeAsbUG4bevPIfZ79yVFUcNAYapMtEItW9OvYzI8wbcj
/epJrqVWsI5M+Q+Lxnn4wOtaPqCO8/nvGhQqBo3T5Ve0Wo1/t75dOehBWJxvp8zX
u+C+ogzLpOYp3zpTKvw9wgGNf6fI7AhvKghx6TCVuv6NEgN++5JqKf9ns6thoRWK
HSUZYQ1ZSWyaNlpB/Nb9C+MNx0M/GdInV+5waxaBClY06974DzXSNqDNgJqGMxxa
659otjJjXns+rZDi0Y96GHYi4frYaymc3N+yXF4eB8RyynKY4MGXkHRq2wDgU6vM
XmqudxWvR36+pNvxyttjd8o8WgGgvA==
=VeZK
-----END PGP SIGNATURE-----

--dqep4stlafi7ze6u--
