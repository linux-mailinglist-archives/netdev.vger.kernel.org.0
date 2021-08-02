Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B33DD102
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 09:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhHBHLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 03:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbhHBHLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 03:11:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACC6C0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 00:11:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mAS69-0001v0-T2; Mon, 02 Aug 2021 09:10:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:4a0c:d314:db6a:e70b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 53AB765D6D5;
        Mon,  2 Aug 2021 07:10:49 +0000 (UTC)
Date:   Mon, 2 Aug 2021 09:10:47 +0200
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
Subject: Re: [PATCH] dt-bindings: net: can: Document power-domains property
Message-ID: <20210802071047.n6mxecdohahhzifr@pengutronix.de>
References: <20210731045138.29912-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o67442xqmg5tkmue"
Content-Disposition: inline
In-Reply-To: <20210731045138.29912-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o67442xqmg5tkmue
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.07.2021 10:21:38, Aswath Govindraju wrote:
> Document power-domains property for adding the Power domain provider.
>=20
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b=
/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index a7b5807c5543..d633fe1da870 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -104,6 +104,13 @@ properties:
>            maximum: 32
>      maxItems: 1
> =20
> +  power-domains:
> +    description:
> +      Power domain provider node and an args specifier containing
> +      the can device id value. Please see,
> +      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml

Why are you referring to a TI specific file in a generic binding?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--o67442xqmg5tkmue
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEHmnUACgkQqclaivrt
76mUdggAjrFdavL7Dr/oqcEEPBT4eddl+T9hQgJRRR6i4H1hsq+nU0vOhItxpg1A
BXqalihcrHqyzNjWQMqBsnW9vSgaJBKEV8LlC1Zsbjry67dkP1tTLUxp3WuaBsdm
fPt5laCPuJ8c1QZydryQUKgjx+Vz27ooFd8EIic7PBVeGhfRrDnFDMbXCb407m9p
5j2z8HhCSJgVu61+Pqf+4j45NYK4o2+62jr9QjZbJDJUiGfrAau7vheK62fguGxa
mN548WUJTKqGrk/6UqQ9O1wDuMcPbXWaIyfs/4bEHFlSdrg2A5edPITZWcmcE6x3
Yq5DNNJMMerizk9W3cjTulBhsvYkiQ==
=UbZx
-----END PGP SIGNATURE-----

--o67442xqmg5tkmue--
