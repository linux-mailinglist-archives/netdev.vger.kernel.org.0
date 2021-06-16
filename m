Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A69C3A95DE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhFPJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhFPJTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:19:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ECDC061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 02:17:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltRfc-0003ml-OX; Wed, 16 Jun 2021 11:17:12 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27:4a54:dbae:b593])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 303EF63CFC9;
        Wed, 16 Jun 2021 09:17:10 +0000 (UTC)
Date:   Wed, 16 Jun 2021 11:17:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v4 0/2] MCAN: Add support for implementing transceiver as
 a phy
Message-ID: <20210616091709.n7x62wmvafz4rzs7@pengutronix.de>
References: <20210510052541.14168-1-a-govindraju@ti.com>
 <2c5b76f7-8899-ab84-736b-790482764384@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xi2ul63vu6ldwtxz"
Content-Disposition: inline
In-Reply-To: <2c5b76f7-8899-ab84-736b-790482764384@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xi2ul63vu6ldwtxz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.06.2021 18:02:53, Aswath Govindraju wrote:
> Hi Marc,
>=20
> On 10/05/21 10:55 am, Aswath Govindraju wrote:
> > The following series of patches add support for implementing the
> > transceiver as a phy of m_can_platform driver.
> >=20
> > TCAN1042 has a standby signal that needs to be pulled high for
> > sending/receiving messages[1]. TCAN1043 has a enable signal along with
> > standby signal that needs to be pulled up for sending/receiving
> > messages[2], and other combinations of the two lines can be used to put=
 the
> > transceiver in different states to reduce power consumption. On boards
> > like the AM654-idk and J721e-evm these signals are controlled using gpi=
os.
> >=20
> > These gpios are set in phy driver, and the transceiver can be put in
> > different states using phy API. The phy driver is added in the series [=
3].
> >=20
> > This patch series is dependent on [4].
> >=20
>=20
> [4] is now part of linux-next
>=20
> > [4] - https://lore.kernel.org/patchwork/patch/1413286/
>
> May I know if this series is okay to be picked up ?

As soon as this hits net-next/master I can pick up this series.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xi2ul63vu6ldwtxz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDJwZMACgkQqclaivrt
76neagf+PXv8hHXAkalpf3chBfPYgznGea7sTT1F4/dYQtdZe+8k8AIEGXK7ZuIG
uLf1DuHDlWrimYQFF/1fwPa3uA3c6qtYgfA1Lypbd/iA3ACxEEHKZKlKeVDMnlpu
eVxyncnfq24p+ele4v5ZKckP3LHr0WFWoIsvF0BZ7J00dD7Pof3hmW7w2AS0t+Y4
Y3dWWmlizlhJlqgvPtEe5ykEgbmZ+AR1kUtBNnUHXSpVgrFVUJ+xK67Zcs/UeSD5
08aEJ2OEaaZY1gO6OHqmwgykrTIKJNBebdG3dPDk8SOcGzPexB3T4BNXja4Ex9+4
aXDh4WMwZ2+bEXUM82JyHmwg54bHEg==
=Qq1D
-----END PGP SIGNATURE-----

--xi2ul63vu6ldwtxz--
