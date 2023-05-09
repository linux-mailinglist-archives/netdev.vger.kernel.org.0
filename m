Return-Path: <netdev+bounces-1158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 626DA6FC60C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C7D1C20B27
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656A3182B6;
	Tue,  9 May 2023 12:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529D4DDB7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:15:36 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08CD358C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:15:34 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pwMF8-0003R6-NN; Tue, 09 May 2023 14:14:58 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id C08281C0DC1;
	Tue,  9 May 2023 12:14:51 +0000 (UTC)
Date: Tue, 9 May 2023 14:14:51 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: kernel test robot <lkp@intel.com>
Cc: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>, wg@grandegger.com,
	michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
	mailhol.vincent@wanadoo.fr, oe-kbuild-all@lists.linux.dev,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, frank.jungclaus@esd.eu,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Subject: Re: [PATCH V7] can: usb: f81604: add Fintek F81604 support
Message-ID: <20230509-exert-remindful-0c0e89bf6649-mkl@pengutronix.de>
References: <20230509073821.25289-1-peter_hong@fintek.com.tw>
 <202305091802.pRFS6n2j-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n6k4denxlayn7yaw"
Content-Disposition: inline
In-Reply-To: <202305091802.pRFS6n2j-lkp@intel.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--n6k4denxlayn7yaw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good Bot!

On 09.05.2023 18:17:43, kernel test robot wrote:
> Hi Ji-Ze,
>=20
> kernel test robot noticed the following build warnings:
>=20
> [auto build test WARNING on mkl-can-next/testing]
> [also build test WARNING on linus/master v6.4-rc1 next-20230509]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Ji-Ze-Hong-Peter-H=
ong/can-usb-f81604-add-Fintek-F81604-support/20230509-154045
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-nex=
t.git testing
> patch link:    https://lore.kernel.org/r/20230509073821.25289-1-peter_hon=
g%40fintek.com.tw
> patch subject: [PATCH V7] can: usb: f81604: add Fintek F81604 support
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230509=
/202305091802.pRFS6n2j-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/9549380f8d5eea359=
f8c83f48e10a0becfd13541
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Ji-Ze-Hong-Peter-Hong/can-usb-f8=
1604-add-Fintek-F81604-support/20230509-154045
>         git checkout 9549380f8d5eea359f8c83f48e10a0becfd13541
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dsh olddefconfig
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dsh SHELL=3D/bin/bash drivers/net/
>=20
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202305091802.pRFS6n2j-lkp@i=
ntel.com/
>=20
> All warnings (new ones prefixed by >>):
>=20
>    drivers/net/can/usb/f81604.c: In function 'f81604_read_bulk_callback':
> >> drivers/net/can/usb/f81604.c:440:67: warning: format '%lu' expects arg=
ument of type 'long unsigned int', but argument 4 has type 'unsigned int' [=
-Wformat=3D]
>      440 |                 netdev_warn(netdev, "URB length %u not equal t=
o %lu\n",
>          |                                                               =
  ~~^
>          |                                                               =
    |
>          |                                                               =
    long unsigned int
>          |                                                               =
  %u
>      441 |                             urb->actual_length, sizeof(*frame)=
);
>          |                                                 ~~~~~~~~~~~~~~=
    =20
>          |                                                 |
>          |                                                 unsigned int

Replaced "%lu% by "%zu" while applying the patch.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--n6k4denxlayn7yaw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRaOTgACgkQvlAcSiqK
BOh9SggAgfKi9g6CXX8twuTW5gnJPOwYRXY17ehQj3aadTLd0SVqOV1IYSwJ5H0R
JQmZmANMv/SXMRZveWaVm+PsJfiZr2YX2fB5wzTLiGmjo8ObVZD1rm0xVHFracNX
oo1DovenPn8Qyj9/5p/dgIzbEWIUaM2hH7IWzzcvZ8EFkXD3TL3NXXdhxckIBBo1
vpEKKLbcdNyFjgKg436XsxVBPFA2GHQFpHNF/9IGS/98nh7SO96Cjb+2sntSw3Rs
KvoQy5lRMU+wb7ir+ewpKoPCJyYeBOUIsT6GOUDf4p4r7as7Bl6B1HvULDZiqeaZ
7+233QdSU1x2MDN7qBHX4xvF9lzrZQ==
=Pl8e
-----END PGP SIGNATURE-----

--n6k4denxlayn7yaw--

