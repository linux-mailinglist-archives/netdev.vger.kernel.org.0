Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6D361FFC
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 14:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbhDPMhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 08:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbhDPMhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 08:37:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487EDC061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 05:37:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lXNie-0007oq-Rc; Fri, 16 Apr 2021 14:37:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:b21a:a98c:8cd:ce9c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F3648610325;
        Fri, 16 Apr 2021 12:37:01 +0000 (UTC)
Date:   Fri, 16 Apr 2021 14:37:00 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>
Subject: Re: [PATCH v2 0/2] MCAN: Add support for implementing transceiver as
 a phy
Message-ID: <20210416123700.s77prohqjqkegebv@pengutronix.de>
References: <20210415154635.30094-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xqo6yibeskab43ot"
Content-Disposition: inline
In-Reply-To: <20210415154635.30094-1-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xqo6yibeskab43ot
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.04.2021 21:16:33, Aswath Govindraju wrote:
> The following series of patches add support for implementing the
> transceiver as a phy of m_can_platform driver.
>=20
> TCAN1042 has a standby signal that needs to be pulled high for
> sending/receiving messages[1]. TCAN1043 has a enable signal along with
> standby signal that needs to be pulled up for sending/receiving
> messages[2], and other combinations of the two lines can be used to put t=
he
> transceiver in different states to reduce power consumption. On boards
> like the AM654-idk and J721e-evm these signals are controlled using gpios.
>=20
> These gpios are set in phy driver, and the transceiver can be put in
> different states using phy API. The phy driver is added in the series [3].
>=20
> This patch series is dependent on [4].

Looks good. Can you ping me after the next -rc1, when this patch hits
mainline. Then I'll merge this into linux-can-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xqo6yibeskab43ot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB5hOkACgkQqclaivrt
76kycAf/TIfrDUXPJ4ouUR5LkNcMylId2QQaYz+ki2uzFPcL4UAXc0pLCn28b/vH
2mzqV8XCm7nKVp5mlmsdGFgVVTsgmQRvfTZIJoElsilOag3/BteSrdokpZAORcMO
RBRQakm1Y3pvWr+8oiWXXkpuDwU+KQRP4XzC3IIaxed9Nbilh6bQkSc6E4396fSP
lF9CWFILd+XcWcDJcdSwbYvXCUw1ofGanJ8To1ylT5GT8Hbcn6G3rv7ro1fQXua2
JO722JYSmk/TkhiyCAELW6sDePv/0qJcYu/VX/P7QMsudUYhYjtGsEB402JXRKnr
SJSwEJHtF20H8Eb9mamNsvo3CTk0+w==
=4TFD
-----END PGP SIGNATURE-----

--xqo6yibeskab43ot--
