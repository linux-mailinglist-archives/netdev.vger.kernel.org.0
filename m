Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4A36A708
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 14:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhDYMKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYMKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:10:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3129C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:09:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ladaE-0002o5-IA; Sun, 25 Apr 2021 14:09:54 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:c28e:7dee:2502:6631])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 99B8E61691C;
        Sun, 25 Apr 2021 12:09:52 +0000 (UTC)
Date:   Sun, 25 Apr 2021 14:09:51 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Erik Flodin <erik@flodin.me>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] can: proc: fix rcvlist_* header alignment on 64-bit
 system
Message-ID: <20210425120951.q42w5ue3ihuxwigf@pengutronix.de>
References: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
 <20210425095249.177588-1-erik@flodin.me>
 <CAAMKmodFEXj69mA2nHNfdtJYBTUR+sBpPc_2krm27oKUyVtqKA@mail.gmail.com>
 <CAMZ6RqLdjYg49Sq3cp3dpseMMgTk+WoOvqXac=YuxdWas_xi7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q644m6pqozd3pvqy"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLdjYg49Sq3cp3dpseMMgTk+WoOvqXac=YuxdWas_xi7g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q644m6pqozd3pvqy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.04.2021 21:05:41, Vincent MAILHOL wrote:
> On Sun. 25 Apr 2021 at 20:40, Erik Flodin <erik@flodin.me> wrote:
> >
> > None of these versions are really grep friendly though. If that is
> > needed, a third variant with two full strings can be used instead.
> > Just let me know which one that's preferred.
>=20
> Out of all the propositions, my favorite is the third variant
> with two full strings.  It is optimal in terms of computing
> time (not that this is a bottleneck...), it can be grepped and
> the source code is easy to understand.

+1

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--q644m6pqozd3pvqy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCFXA0ACgkQqclaivrt
76lftwf9HfTF3P+ofmQCC9h2rdzwe1N80oif9klGE0C894ajsK41+5xL8vRenL1+
BgDWPsnjAUC9mvfaTdZRv+sxbTp/tNfFy6KdC5toLSchshf1qULGjM9dNZG6duyt
txpNqN4Z0Cj11Sq+R88/WCpiGQBCr9RDlGxBuiT/LioTnNPWUZ/CJE4Fby17Owxi
kRdZOsVU9hMpWbEXtdTe/ZYQCyTKJmpl3504PPA+sRJtOpQx7AsEGH8yQ+IZJMfr
lNjdN5enC4gjZfb5db171eGtfzG+r6BeQZt5k4ncOQuzEqPrkhToj9YJn+ix+MYh
y9bjxzEXy9POPeJDiloQRppuB1OGUQ==
=xfZv
-----END PGP SIGNATURE-----

--q644m6pqozd3pvqy--
