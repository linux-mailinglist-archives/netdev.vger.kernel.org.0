Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF41035F818
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350738AbhDNPoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbhDNPn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:43:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BCDC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:43:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWhfm-0005Fg-3Y; Wed, 14 Apr 2021 17:43:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:69d2:43d8:822b:d361])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 429EA60EA5B;
        Wed, 14 Apr 2021 15:43:20 +0000 (UTC)
Date:   Wed, 14 Apr 2021 17:43:19 +0200
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
Subject: Re: [PATCH v2 0/6] CAN TRANSCEIVER: Add support for CAN transceivers
Message-ID: <20210414154319.knn323wo6vi3t2dp@pengutronix.de>
References: <20210414140521.11463-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ls64vuqf5liwgxeq"
Content-Disposition: inline
In-Reply-To: <20210414140521.11463-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ls64vuqf5liwgxeq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.04.2021 19:35:15, Aswath Govindraju wrote:
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
> Patch 1 rewords the comment that restricts max_link_rate attribute to have
> units of Mbps.
>=20
> Patch 2 adds an API for devm_of_phy_optional_get_by_index

You probably want to split this into 2 or even 3 separate series. The
first one would be patches 1+2 then 3+4 they can go via the phy tree.
Patches 5+6 can go via linux-can-next

> Patch 3 models the transceiver as a phy device tree node with properties
> for max bit rate supported, gpio properties for indicating gpio pin numbe=
rs
> to which standby and enable signals are connected.
>=20
> Patch 4 adds a generic driver to support CAN transceivers.
>=20
> Patches 5 & 6 add support for implementing the transceiver as a phy of
> m_can_platform driver.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ls64vuqf5liwgxeq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB3DZQACgkQqclaivrt
76l7xQf9EU/0dxjIIELdncw7YgkbG5MzMjxlZsTwehF/S7YPFD+SrhSE33kjSFr/
yan8/T+N6Gg3fSsLFQxpw3E5w2i5+0d2UjFErypXkUrLsTgT0d1rjKgywvakE7lj
+4hn33gfbCEK3Nx7vdDsZTbjmPpkXuCgrZKuFhvC8mtVTVMLC2p9hxdpvpzD7pOL
AmQJJwLv3ubkD2PUihd1Tbj1xbVK0vKtOFeGBCi4qE/EIdJMSldDvFkC9+6525pN
XXB7gAkAO/GGx+rkfmyV36bj97nfyoVoNGFjdPPY+VtIAiL7Vg8xBuXL7O7Eod70
AqwTVUnL6UCnpbH4gqtjjkock/G82w==
=kqEi
-----END PGP SIGNATURE-----

--ls64vuqf5liwgxeq--
