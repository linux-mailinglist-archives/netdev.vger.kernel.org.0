Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B668F4934E5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351720AbiASGOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 01:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiASGOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:14:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE01C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 22:14:19 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nA4Ea-0006V7-14; Wed, 19 Jan 2022 07:14:16 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5ABD71D2C0;
        Wed, 19 Jan 2022 06:14:15 +0000 (UTC)
Date:   Wed, 19 Jan 2022 07:14:11 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix array schemas encoded as matrices
Message-ID: <20220119061411.qcfef5jz6ibs327l@pengutronix.de>
References: <20220119015627.2443334-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yfm7kxmys4xwysix"
Content-Disposition: inline
In-Reply-To: <20220119015627.2443334-1-robh@kernel.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yfm7kxmys4xwysix
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.01.2022 19:56:26, Rob Herring wrote:
> The YAML DT encoding has leaked into some array properties. Properties
> which are defined as an array should have a schema that's just an array.
> That means there should only be a single level of 'minItems',
> 'maxItems', and/or 'items'.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/net/can/bosch,m_can.yaml         | 52 ++++++++--------

for net/can/

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yfm7kxmys4xwysix
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHnrDEACgkQqclaivrt
76n8HQf/a+g/PdevYZq4o0O2nN2m+skhWixp8n3W2cZBCDbJSy2T89Ey1nHNZoLI
tV/Kml5GYsZiYYsQY/TckNIMoTRx+aKDDJoxKm9h8lxzwUcai48kauTUJQ7xjAS7
FSKwvhnpD3PIvY8sGr8tUhNtLT9BShATBpLP/S3ALW4O4vNRSXzbkU3d2+14qQRo
+B+LVrjNYcFohHpcujjkLey19/0BY87JeMNihK/vt2HwHmQPEb7IHfvriDtKKXFV
rTsKpamKydHPhioR/MmBPHn+mxZtJAkQv+osW9CH9JpV0l590uiG11C2vqmHH2FU
Y6gecbPBCrVGDsB9A029tNHV7jABdg==
=sslO
-----END PGP SIGNATURE-----

--yfm7kxmys4xwysix--
