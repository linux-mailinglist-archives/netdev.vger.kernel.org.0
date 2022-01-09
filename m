Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED34888E1
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 12:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbiAILh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 06:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiAILh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 06:37:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0CDC061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 03:37:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6WVj-0001G8-2u; Sun, 09 Jan 2022 12:37:19 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-a4a9-3301-a0d2-087c.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:a4a9:3301:a0d2:87c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4D0C46D3E59;
        Sun,  9 Jan 2022 11:37:17 +0000 (UTC)
Date:   Sun, 9 Jan 2022 12:37:16 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] can: flexcan: add ethtool support to get rx/tx ring
 parameters
Message-ID: <20220109113716.r4l432ixsjbbcwtu@pengutronix.de>
References: <20220108181633.420433-1-dario.binacchi@amarulasolutions.com>
 <20220108201650.7gp3zlduzphgcgkq@pengutronix.de>
 <CABGWkvoGs_VBGD-7dt18LY9NV=63w50OceKjmaKYeqDe_WJk9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rzgzvcem3jngzhan"
Content-Disposition: inline
In-Reply-To: <CABGWkvoGs_VBGD-7dt18LY9NV=63w50OceKjmaKYeqDe_WJk9g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rzgzvcem3jngzhan
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.01.2022 12:22:54, Dario Binacchi wrote:
> > >  static const struct ethtool_ops flexcan_ethtool_ops =3D {
> > > +     .get_ringparam =3D flexcan_get_ringparam,
> > >       .get_sset_count =3D flexcan_get_sset_count,
> > >       .get_strings =3D flexcan_get_strings,
> > >       .get_priv_flags =3D flexcan_get_priv_flags,
> >
> > BTW: If you're looking for more TX performance, this can be done by
> > using more than one TX buffer.
>=20
> I didn't expect only one message buffer to be used for transmission

It was easier to implement, but now we've sorted it out how to implement
multiple TX buffers race free and lock-less. Have a look at the
mcp251xfd driver.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rzgzvcem3jngzhan
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHayOgACgkQqclaivrt
76nPQgf/an5RfIK7HvAVii+TyXj7m/vfw+8gGayLUQxfMEeCZsdHBk25wsM76unP
Mu4faJe15cxzs3whPcdpbDfMFC2t8zXSOjf2vlCcbjmqS0IOfxFIijYodI7KCFpO
KPa13t6DDuJRLVzKi4TEEw/GgVNKQMbjN6TDpFLxgEf6Iz7V+DWf2brvyqRDRy5M
+2qF/6403FycAUzgyo230UXGhLxdWn8Ac1XUx84xnqzXKs7v94iN2WR0HxynEL70
bZz2FBDCpVwSnoL3iL7Kw5gKoXmVHJHXrV/MrAbEaEovT/axW+SMNr/lX5n7tYVj
wt03+WrvEkPkMoA3fIRWvXv3WCXUTg==
=M/Pi
-----END PGP SIGNATURE-----

--rzgzvcem3jngzhan--
