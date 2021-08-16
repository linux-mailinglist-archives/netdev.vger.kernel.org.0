Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BDE3ED2F8
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbhHPLQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbhHPLQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:16:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20053C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 04:15:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFaae-0001ZS-0x; Mon, 16 Aug 2021 13:15:36 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 97AA2668225;
        Mon, 16 Aug 2021 11:15:32 +0000 (UTC)
Date:   Mon, 16 Aug 2021 13:15:31 +0200
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
Message-ID: <20210816111531.bkn2ede33f6hntcb@pengutronix.de>
References: <20210805192750.9051-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ik5fvajssuvkrg4d"
Content-Disposition: inline
In-Reply-To: <20210805192750.9051-1-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ik5fvajssuvkrg4d
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

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ik5fvajssuvkrg4d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaSNAACgkQqclaivrt
76kkLQf9FQy4inlhFNhTldseSLf/ZVm/d5VLDzbyHH99ovDmBvSA3a/N8RPHF74i
Glbh4+tuSU8ACsWZqRgGV4Ick8JP4chPLDm5nDs9RCbFfabJLoyVd7QbzwbdX8W8
nNdkqsomxnbwxhjbZ/hksDZqplRSVV5mtBbHJgmrnRzkj3gyHWmYbY85j/fGjEpF
kIfhAW4hAmGn9sniglLANIgAjOeThqzAFtUxMzkiYgjbqSfhDEjxG6ujus5QW4qW
WfWfVWe4PoRtRl9RnvtF/6Ir4fSC5TyTI03LNjiv87+QPrpUP+WbG36mxKSs6rWj
kAyVE9f9xVbXRM6MXkyFQtYRolWKFQ==
=h0Ec
-----END PGP SIGNATURE-----

--ik5fvajssuvkrg4d--
