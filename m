Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8648C07F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351840AbiALI5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:57:11 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57850 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351847AbiALI4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:56:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 386671C0B76; Wed, 12 Jan 2022 09:56:33 +0100 (CET)
Date:   Wed, 12 Jan 2022 09:56:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH net 4/5] can: rcar_canfd: rcar_canfd_channel_probe():
 make sure we free CAN network device
Message-ID: <20220112085631.GA32251@amd>
References: <20220109134040.1945428-1-mkl@pengutronix.de>
 <20220109134040.1945428-5-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20220109134040.1945428-5-mkl@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2022-01-09 14:40:39, Marc Kleine-Budde wrote:
> From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>=20
> Make sure we free CAN network device in the error path. There are
> several jumps to fail label after allocating the CAN network device
> successfully. This patch places the free_candev() under fail label so
> that in failure path a jump to fail label frees the CAN network
> device.
>=20
> Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
> Link: https://lore.kernel.org/all/20220106114801.20563-1-prabhakar.mahade=
v-lad.rj@bp.renesas.com

Reviewed-by: Pavel Machek <pavel@denx.de>

Thank you!

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHel78ACgkQMOfwapXb+vKtEgCgrOr4KQRH/Juwlw3cIN4gVsUT
/G0AoKyX/U+G4z0D5MTOlZTdQUg9pazi
=uxpK
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
