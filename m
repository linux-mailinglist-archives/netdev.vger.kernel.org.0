Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A013F6F4A
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbhHYGSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbhHYGSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:18:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FBCC061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 23:17:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mImEE-0006SA-6d; Wed, 25 Aug 2021 08:17:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:b509:65fb:e781:8611])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2391066E7BC;
        Wed, 25 Aug 2021 06:17:36 +0000 (UTC)
Date:   Wed, 25 Aug 2021 08:17:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH -next] can: rcar_canfd: Fix redundant assignment
Message-ID: <20210825061735.x3izwhs2koy4o4qp@pengutronix.de>
References: <20210820161449.18169-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="th6pl7v54vicbrcb"
Content-Disposition: inline
In-Reply-To: <20210820161449.18169-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--th6pl7v54vicbrcb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.08.2021 17:14:49, Lad Prabhakar wrote:
> Fix redundant assignment of 'priv' to itself in
> rcar_canfd_handle_channel_tx().
>=20
> Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Applied to linux-can-next/testing

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--th6pl7v54vicbrcb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEl4HwACgkQqclaivrt
76mHtgf+L41N6scrOm0h9o+PDnNvJscBHw3+LLuiB1J6Nw+07SHjlj71p5orr2K2
+hBymWJcoSn7z5Wk1WdioM5T2LFXTqAp79MmxOrAlhg96+cVcgCem+eASheVOLMa
KM8B0HjPQoCvH+TWko8EuGoHX1/wc3eVr4Yy7hnIw9YcxR8ykMBGL8CtzUap4I/b
PQ7qkX2y+ePs8CJnGeVEG/+c078YrnvSNhiuK9S18a/qDXt/unY3FdNk/ABurPKZ
OACDylrR7IEgpQeO6qTLbXxY06oC5SEKx5cUIK3dxssmTTl3cObyMPrlKp7Ye5Lc
UMcj7ODrPvjsSn/RaE4X8EM7PHaDUw==
=3+Gz
-----END PGP SIGNATURE-----

--th6pl7v54vicbrcb--
