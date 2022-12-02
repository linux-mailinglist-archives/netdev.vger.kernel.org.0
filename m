Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E26406CE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiLBM1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbiLBM13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:27:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA0BCEFB8
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:27:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p158K-0001lB-Qk; Fri, 02 Dec 2022 13:27:12 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5BC4D1315BB;
        Fri,  2 Dec 2022 12:27:10 +0000 (UTC)
Date:   Fri, 2 Dec 2022 13:27:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v5 7/7] Documentation: devlink: add devlink documentation
 for the etas_es58x driver
Message-ID: <20221202122702.rlxvatn2m6dx7zyp@pengutronix.de>
References: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-8-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qhumjgptn36xoee2"
Content-Disposition: inline
In-Reply-To: <20221130174658.29282-8-mailhol.vincent@wanadoo.fr>
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


--qhumjgptn36xoee2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 02:46:58, Vincent Mailhol wrote:
> List all the version information reported by the etas_es58x driver
> through devlink. Also, update MAINTAINERS with the newly created file.
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  .../networking/devlink/etas_es58x.rst         | 36 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 37 insertions(+)
>  create mode 100644 Documentation/networking/devlink/etas_es58x.rst
>=20
> diff --git a/Documentation/networking/devlink/etas_es58x.rst b/Documentat=
ion/networking/devlink/etas_es58x.rst
> new file mode 100644
> index 000000000000..9893e57b625a
> --- /dev/null
> +++ b/Documentation/networking/devlink/etas_es58x.rst
> @@ -0,0 +1,36 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +etas_es58x devlink support
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +This document describes the devlink features implemented by the
> +``etas_es58x`` device driver.
> +
> +Info versions
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``etas_es58x`` driver reports the following versions
> +
> +.. list-table:: devlink info versions implemented
> +   :widths: 5 5 90
> +
> +   * - Name
> +     - Type
> +     - Description
> +   * - ``fw``
> +     - running
> +     - Version of the firmware running on the device. Also available
> +       through ``ethtool -i`` as the first member of the
> +       ``firmware-version``.
> +   * - ``bl``
            ^^
            fw.bootloader?

Fixed that up while applying.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qhumjgptn36xoee2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOJ7xMACgkQrX5LkNig
013Y7AgAnssEQg25CUvEzFSLY+/dbRF2c8RrwDCd03ktRpkfI+k4Aty3/c9XqPIE
WxqLNMKeLi1qSSw/faRTh2LXz8D8/zGkJBSXG6VDSKyp/5ZCLVW8CfBkvjFi8RWt
BAKCVg57fhJK6+0aCYs4K4Y1IHcMfSwaOGOVFEYkllVTJm+bCPEzqBEwNnh3Es3i
9XQx2lauRndXeI+bMLpi50cDOfb1AGwZLnNIgRLrOGxMtdzEn3ricDbgpNAZbZkD
I4zBb8b/JGXHaIowQf9GxqljLRredRNQOkqjWMiAE9PJlp+JjyYZwD24FMChpg5C
G21cpJnOrx0EN4ZtcCgcMYvBxQg9Ug==
=EdDV
-----END PGP SIGNATURE-----

--qhumjgptn36xoee2--
