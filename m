Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5362460C4CB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiJYHNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiJYHNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:13:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A658517E0B
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:13:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onE6q-0005NE-NB; Tue, 25 Oct 2022 09:12:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F3F9810925C;
        Tue, 25 Oct 2022 07:12:11 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:12:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Gerhard Sittig <gsi@denx.de>,
        Anatolij Gustschin <agust@denx.de>,
        Mark Brown <broonie@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mscan: mpc5xxx: fix error handling code in
 mpc5xxx_can_probe
Message-ID: <20221025071209.jwe6wxxbh33vfeob@pengutronix.de>
References: <20221024114810.732168-1-dzm91@hust.edu.cn>
 <Y1Z+XHdOozjBFBzF@smile.fi.intel.com>
 <6A916694-CA4E-4D73-8CF0-B35AC8C6B9D3@hust.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bxmmnmhog6mtsffw"
Content-Disposition: inline
In-Reply-To: <6A916694-CA4E-4D73-8CF0-B35AC8C6B9D3@hust.edu.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bxmmnmhog6mtsffw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2022 10:29:50, Dongliang Mu wrote:
>=20
>=20
> > On Oct 24, 2022, at 20:00, Andy Shevchenko <andriy.shevchenko@linux.int=
el.com> wrote:
> >=20
> > On Mon, Oct 24, 2022 at 07:48:07PM +0800, Dongliang Mu wrote:
> >> The commit 1149108e2fbf ("can: mscan: improve clock API use
> >> ") only adds put_clock in mpc5xxx_can_remove function, forgetting to a=
dd
> >=20
> > Strange indentation. Why the '")' part can't be on the previous line?
>=20
> :/ it is automatically done by vim in `git commit -a -s -e`. I can
> adjust this part in v2 patch.

Fixed while applying the patch.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bxmmnmhog6mtsffw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXjEcACgkQrX5LkNig
012TTQf/etsqXRQvWattfWnfryXMggOz2Sjuz+AVNk0LyNmySJ05MR9CZ/VZ/DHg
tk9N/7ycolCnujDGAvNYSoIuezlLI7GrWBOrrjtUjSn5Dl30Y0G72sjNEAhHaz4b
qamtuv+nrT2gC60IUy+11lob296T8iV5PabzO4uNPn5I2to5ZIIgMYpdaN/wrA4o
Ssh+0OPhkfjXQyDUiDFhrKVJUx2FJViYnoCur8m9bpyeqCNCMQLH458CQiKGWFrz
mYpMGX0jha3C6fwvXa47pBEYoPZ89RDCLB9c5Xd8hfPqBLtAOHnCh4gfzYZNukHH
E//JZ1puSEpdNpsLz2MjeFY0AIqTkw==
=wi2j
-----END PGP SIGNATURE-----

--bxmmnmhog6mtsffw--
