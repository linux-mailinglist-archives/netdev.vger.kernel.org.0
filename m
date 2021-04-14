Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8110C35F7F8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhDNPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352270AbhDNPjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:39:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DB0C06138C
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:39:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWhbj-0004qo-KI; Wed, 14 Apr 2021 17:39:11 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:69d2:43d8:822b:d361])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 69A3460EA55;
        Wed, 14 Apr 2021 15:39:09 +0000 (UTC)
Date:   Wed, 14 Apr 2021 17:39:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2 4/6] phy: phy-can-transceiver: Add support for generic
 CAN transceiver driver
Message-ID: <20210414153908.vt7vxohfc76pnu6q@pengutronix.de>
References: <20210414140521.11463-1-a-govindraju@ti.com>
 <20210414140521.11463-5-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aldzm3xee5a5ngey"
Content-Disposition: inline
In-Reply-To: <20210414140521.11463-5-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aldzm3xee5a5ngey
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.04.2021 19:35:19, Aswath Govindraju wrote:
> The driver adds support for generic CAN transceivers. Currently
> the modes supported by this driver are standby and normal modes for TI
> TCAN1042 and TCAN1043 CAN transceivers.
>=20
> The transceiver is modelled as a phy with pins controlled by gpios, to put
> the transceiver in various device functional modes. It also gets the phy
> attribute max_link_rate for the usage of CAN drivers.
>=20
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  MAINTAINERS                       |   1 +
>  drivers/phy/Kconfig               |   9 ++
>  drivers/phy/Makefile              |   1 +
>  drivers/phy/phy-can-transceiver.c | 146 ++++++++++++++++++++++++++++++
>  4 files changed, 157 insertions(+)
>  create mode 100644 drivers/phy/phy-can-transceiver.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e666d33af10d..70e1438c372d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4047,6 +4047,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/gi=
t/mkl/linux-can.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.=
git
>  F:	Documentation/devicetree/bindings/net/can/
>  F:	Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> +F:	drivers/phy/phy-can-transceiver.c
>  F:	drivers/net/can/

please keep this alphabetically sorted

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--aldzm3xee5a5ngey
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB3DJkACgkQqclaivrt
76l/IwgAreD/6IHK8z047ucV0MPRO/TLhJE1s9R30MAhPc4nPrt4LnatRYfZz5Oj
dQF6fsUQ3t4r8FVdzSIRxshoM1UcORaIsGv6jLZ4IqjIVcyJE1rwoGA3EghhnD0R
xR+DL85B/9Fxn8K5tg8O0xu7XmMZ2cvOlC6nzoNBrbuVcfP4n2G8FPhsPiv6e668
ufmytXBM5gzMVoMXgEfdUg/Q55uCfGR6aCf3LaYXUNrrt+sOqfZm366jKjlJfM/V
+JY/mIT1R9MnS/Ycf0mPV5i4AD2GTOQ9hoiSqaxhpw7/4iHKAgziOSTuVS0EzHpl
8+KKLu8KKMiJjtazjfMaISdlGjiH5A==
=wqm5
-----END PGP SIGNATURE-----

--aldzm3xee5a5ngey--
