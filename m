Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1873D4CF7
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 11:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhGYJF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhGYJF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 05:05:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DCBC06175F
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 02:46:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7ai5-0006YS-AR; Sun, 25 Jul 2021 11:46:13 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6671:797e:8cf2:7596])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 80320657530;
        Sun, 25 Jul 2021 09:46:06 +0000 (UTC)
Date:   Sun, 25 Jul 2021 11:46:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     kernel test robot <lkp@intel.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, clang-built-linux@googlegroups.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/3] can: rcar_canfd: Add support for RZ/G2L family
Message-ID: <20210725094605.gzhrbunkot7ytvel@pengutronix.de>
References: <20210721194951.30983-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <202107251336.iD47PRoA-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y4plgjlsv5x2mcmy"
Content-Disposition: inline
In-Reply-To: <202107251336.iD47PRoA-lkp@intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y4plgjlsv5x2mcmy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2021 13:39:37, kernel test robot wrote:
> Hi Lad,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on renesas-devel/next]
> [also build test WARNING on v5.14-rc2 next-20210723]
> [cannot apply to mkl-can-next/testing robh/for-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>=20
> url:    https://github.com/0day-ci/linux/commits/Lad-Prabhakar/Renesas-RZ=
-G2L-CANFD-support/20210722-035332
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-dev=
el.git next
> config: arm64-randconfig-r031-20210723 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 9625=
ca5b602616b2f5584e8a49ba93c52c141e40)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/082d605e73c5922419a736a=
a9ecd3a76c0241bf7
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Lad-Prabhakar/Renesas-RZ-G2L-CAN=
FD-support/20210722-035332
>         git checkout 082d605e73c5922419a736aa9ecd3a76c0241bf7
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross AR=
CH=3Darm64=20
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> drivers/net/can/rcar/rcar_canfd.c:1699:12: warning: cast to smaller in=
teger type 'enum rcanfd_chip_id' from 'const void *' [-Wvoid-pointer-to-enu=
m-cast]
>            chip_id =3D (enum rcanfd_chip_id)of_device_get_match_data(&pde=
v->dev);
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
>    1 warning generated.

Seems we need the cast (uintptr_t), that I asked you to remove. Can you
test if

| chip_id =3D (enum rcanfd_chip_id)(uintptr_t)of_device_get_match_data(&pde=
v->dev);

works?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--y4plgjlsv5x2mcmy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD9MtsACgkQqclaivrt
76kqAQgAjSoUVJ3e+wxfDmjcDBWUjqWHDAX/uFWGQXQfCOdcCnnujfMBMJbgcAC0
QqyEWtFblN+zYQCqhUoJLNURHBbhAkCiByljWA0uNw8aO8GzsOiISDusY8us3FdK
VRpUW8yNEC9/7RdcpBew8HaE/0fVETC1OdSolqUsS2H1UWXFQsRQzCaYeEn5EFse
1ldsDrRsyXvvXZiKqibPKJ4DBhrmw81STNVBH+pIRexhrTGQrH5XVzARTJO7XJO8
6hTXIiCx5l0H0mwHXqBq6AZswzcEcqnH7P5U3N8i5MzKBi+v5H3RA63U/ytRMmn6
Qs1YmDFcUN7Sl4tcGqkQ1S+PWhZsEw==
=2kyD
-----END PGP SIGNATURE-----

--y4plgjlsv5x2mcmy--
