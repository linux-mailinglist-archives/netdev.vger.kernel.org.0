Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1883E23E8
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbhHFHVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243617AbhHFHVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:21:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223ECC061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 00:20:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBu9y-0002hU-1c; Fri, 06 Aug 2021 09:20:50 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:66f0:974b:98ab:a2fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1B0BC661BEA;
        Fri,  6 Aug 2021 07:20:46 +0000 (UTC)
Date:   Fri, 6 Aug 2021 09:20:45 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5] dt-bindings: net: can: c_can: convert to json-schema
Message-ID: <20210806072045.akase7hseu4wrxxt@pengutronix.de>
References: <20210805192750.9051-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ywt3kfhn3c2zmo73"
Content-Disposition: inline
In-Reply-To: <20210805192750.9051-1-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ywt3kfhn3c2zmo73
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.08.2021 21:27:50, Dario Binacchi wrote:
> Convert the Bosch C_CAN/D_CAN controller device tree binding
> documentation to json-schema.
>=20
> Document missing properties.
> Remove "ti,hwmods" as it is no longer used in TI dts.
> Make "clocks" required as it is used in all dts.
> Update the examples.
>=20
> Signed-off-by: Dario Binacchi <dariobin@libero.it>

[...]

> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - bosch,d_can
> +
> +then:
> +  properties:
> +    interrupts:
> +      minItems: 4
> +      maxItems: 4

The driver uses only 1 interrupt, on the other hand the only in-tree
user the bosch,d_can compatible specifies 4 interrupts.

Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ywt3kfhn3c2zmo73
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEM4ssACgkQqclaivrt
76kH+wf/Us0Znp2pcbUwxbQq8O11+Bbroua1J8Na8qc7NwTESuk9N2Qu0zpUO8Tz
oTTsibqJD9m3Z3AXxILJcv0mueNL4NbvFdjQ2hd7kl28X7B1KgqJvx63DLRrI9Vp
ZtY1ve+ZEqf1ZwG0CnHThvLBqAR0102h29X7HrjS1JGD9mVNXiobqArfcLfh5Lpu
7rGXUYj6OtQmg+QoWsduOpMAwod91M0bCkvGuTDZGqdCOxyTb/TZPZTtQOTS0e2Z
FBSD8hp8mp4AffaX3MXe2rEbDCSY/ZRFlhth3WRigVSu0rpf5m0al9QiRcOe9nUc
0hcetz9jGIIn4gNvOm6nxBKRXO10MA==
=Boa7
-----END PGP SIGNATURE-----

--ywt3kfhn3c2zmo73--
