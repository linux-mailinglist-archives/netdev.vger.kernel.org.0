Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768BA3DFC06
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhHDHYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbhHDHYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 03:24:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB38C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 00:24:05 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBBFj-0007IB-7e; Wed, 04 Aug 2021 09:23:47 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:e44:2d7c:bf4a:7b36])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6C26D6605BC;
        Wed,  4 Aug 2021 07:23:43 +0000 (UTC)
Date:   Wed, 4 Aug 2021 09:23:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: can: Document power-domains property
Message-ID: <20210804072341.l4flosh7rkvma22o@pengutronix.de>
References: <20210802091822.16407-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sqkjar3j54e2j6hq"
Content-Disposition: inline
In-Reply-To: <20210802091822.16407-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sqkjar3j54e2j6hq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.08.2021 14:48:22, Aswath Govindraju wrote:
> Document power-domains property for adding the Power domain provider.
>=20
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>

Applied to linux-can-next/testing.

BTW: TI's dkim is broken:

|   =E2=9C=97 [PATCH v2] dt-bindings: net: can: Document power-domains prop=
erty
|     + Link: https://lore.kernel.org/r/20210802091822.16407-1-a-govindraju=
@ti.com
|     + Acked-by: Rob Herring <robh@kernel.org>
|     + Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
|   ---
|   =E2=9C=97 BADSIG: DKIM/ti.com

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--sqkjar3j54e2j6hq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEKQHsACgkQqclaivrt
76lNRwf+LJv6+mLtM8GeYEzkRoHsLsugVutHrFlAP0iIKEHubqbIrBYKSXQ+Nukp
KJD2A3nwJsEjwNbkfhSapiZHrRRB1pjfTNOEq8l+8pAShXXji/pzN1tRC+Vk66Fg
TUdfLGCEXKQUqpniLE7Uke0QZn8rUz8ObxRKho5/0jrH9+49l1ZdeQRGTB4mbUmD
JxWC3V0BME0+wqeHxnsKxLhsJji5AwcXsAnW8gFNC96tLmlNJB3erxg+RTcD803S
B8m1sYbm/TB2phLF+W8yjQgtRopC/jFxMgenBQjmwM2euG8xwItAGQZ1ldnVLupw
47LjpU12bjyyceebX30FcJaZEg7CQw==
=p8BA
-----END PGP SIGNATURE-----

--sqkjar3j54e2j6hq--
