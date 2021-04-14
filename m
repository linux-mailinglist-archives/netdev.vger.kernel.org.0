Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723BA35EE1A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244919AbhDNHAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346577AbhDNHAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:00:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494D0C06138D
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 23:59:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWZUp-0004A5-83; Wed, 14 Apr 2021 08:59:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:69d2:43d8:822b:d361])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6880960E540;
        Wed, 14 Apr 2021 06:59:29 +0000 (UTC)
Date:   Wed, 14 Apr 2021 08:59:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH 0/4] CAN TRANSCEIVER: Add support for CAN transceivers
Message-ID: <20210414065928.d2carmtxsp57cczw@pengutronix.de>
References: <20210409134056.18740-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="raq3yd6i5d77bb2l"
Content-Disposition: inline
In-Reply-To: <20210409134056.18740-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--raq3yd6i5d77bb2l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.04.2021 19:10:50, Aswath Govindraju wrote:
> The following series of patches add support for CAN transceivers.
>=20
> TCAN1042 has a standby signal that needs to be pulled high for
> sending/receiving messages[1]. TCAN1043 has a enable signal along with
> standby signal that needs to be pulled up for sending/receiving
> messages[2], and other combinations of the two lines can be used to put t=
he
> transceiver in different states to reduce power consumption. On boards
> like the AM654-idk and J721e-evm these signals are controlled using gpios.
>=20
> Patch 1 models the transceiver as a phy device tree node with properties
> for max bit rate supported, gpio properties for indicating gpio pin numbe=
rs
> to which standby and enable signals are connected.

Please add a patch that adds the driver and the bindings to the
MAINTAINERS file. Feel free to add it CAN NETWORK DRIVERS.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--raq3yd6i5d77bb2l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB2ks4ACgkQqclaivrt
76mHgQf/QZQQBkLEljBddFitlXSkW2erh/AEf1A4VAjsY2cWJEcOrWAzCT5FLV+v
+kNI7gUwtFl8wB6eHnC9OVl7fsvYgqhukX+KPkw6BNESbrSgzB3QBzOHoZOseTpm
nMiKP8gcKM5RVsoXWdiVOuUibbN6iLwKZvBvY6Vww1iz2wwtnPWqT5EyEoKh0YzO
ZfV6/5KCYVYzoAU/Jowk+iNfiPq9928Z0ek3hJHo9jaddhONcQ/PWM73ob/wAD+I
e5ixdVWJQEsmVaw2mG4C8sYXoYvqKIqMxd9S+O3Lu49oZcBrkEsrK4dwyEi8mLmt
MEJYPENQoVsvsWkX+OvhDQqOrg1eug==
=EjJc
-----END PGP SIGNATURE-----

--raq3yd6i5d77bb2l--
