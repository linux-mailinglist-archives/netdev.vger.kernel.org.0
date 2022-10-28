Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE82610BE8
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiJ1IJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJ1IJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:09:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3BE1C409
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:09:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ooKQc-0007cj-KE; Fri, 28 Oct 2022 10:09:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 44B4310BD46;
        Fri, 28 Oct 2022 06:53:09 +0000 (UTC)
Date:   Fri, 28 Oct 2022 08:53:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <extja@kvaser.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20221028065307.hjw64fmzmxduljui@pengutronix.de>
References: <20221028102811.5938f029@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lxuruu2uz3jgswru"
Content-Disposition: inline
In-Reply-To: <20221028102811.5938f029@canb.auug.org.au>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lxuruu2uz3jgswru
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2022 10:28:11, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
>=20
> between commit:
>=20
>   2871edb32f46 ("can: kvaser_usb: Fix possible completions during init_co=
mpletion")
>=20
> from Linus' tree and commit:
>=20
>   abb8670938b2 ("can: kvaser_usb_leaf: Ignore stale bus-off after start")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

The fix looks good to me!

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lxuruu2uz3jgswru
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNbfFEACgkQrX5LkNig
010rpwf/UYh9nCCC6/psiwDgpvekVkMedOQ4RCQoMLqWKzJ4U1Nn79Wjouw6qxz0
TPHY/CJcZKaq0fAsfgVLCvttrphCpVqluBMfW0OELARUn4WPEmsR0KftmHZFQaLd
qFpTCl+hoiV1YLKx8aJNJlXIAoeM5hyMxTtAzQ4l6oslkiv5y10AE15Xa/vUhBHm
znknbOGorVEs5x2EcetsFXWhAitSJykrHdhPYhC0BkbmyvG1uzBlUwCREw+BYQdU
pf6YZdsXlRXIzmK8VpIxV9SNmN1AI31nB/8+L8shVIlfG2IWf4PzwaBpnFEKrZAB
AS6+8INKiuhPX+SHD9839LRZPvMosw==
=rIdh
-----END PGP SIGNATURE-----

--lxuruu2uz3jgswru--
