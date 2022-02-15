Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608B24B69E9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiBOKzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:55:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiBOKzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:55:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1B6D76D5
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:55:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nJvTx-0001Ed-JO; Tue, 15 Feb 2022 11:54:53 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0933833A8B;
        Tue, 15 Feb 2022 10:54:51 +0000 (UTC)
Date:   Tue, 15 Feb 2022 11:54:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/8] dt-bindings: net: add schema for ASIX USB
 Ethernet controllers
Message-ID: <20220215105447.vimwbnyabyfxyl4v@pengutronix.de>
References: <20220215100018.2306046-1-o.rempel@pengutronix.de>
 <20220215100018.2306046-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ifqdzi4p4d6arjx2"
Content-Disposition: inline
In-Reply-To: <20220215100018.2306046-2-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ifqdzi4p4d6arjx2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.02.2022 11:00:11, Oleksij Rempel wrote:
> Create schema for ASIX USB Ethernet controllers and import some of
> currently supported USB IDs form drivers/net/usb/asix_devices.c
>=20
> This devices are already used in some of DTs. So, this schema makes it of=
ficial.
These

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ifqdzi4p4d6arjx2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmILhnUACgkQrX5LkNig
0127EAf8CJJABhnS+oUjbFpBGUxKQ7ySwvBPYhNMil097GqJDDjXWk8nLPgGs0PV
kXT/pRPTBDeVWP9o48FVVyOLtWRgK/8mqia24ZAvb6MqXEUTVVOV5xQi7nQsChwp
B6coQO7Py9d1yOw61MNEj/QR33O5qP3E4GqY4d0UE1p7DNVyeX9apoWDI5xRdZrL
NV5wzDHIE45Cdgm0Gry8x9UVy8kMbPFV4wqiZo4OS9Ct7b+JkjM6dCFL3gvv7EuK
kpaJSV2hefMCyrevDo4S6s0laNbec69cXTso9FXJVeWmZfz7L4xbiU3hRBXdyYNH
kK3tvNuH8nP8Rw0vJyzQlK027HRKCw==
=unWf
-----END PGP SIGNATURE-----

--ifqdzi4p4d6arjx2--
