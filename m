Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA75428B2
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiFHH4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiFHHys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 03:54:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E259A1D81AB
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:23:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyq2V-0006tM-78; Wed, 08 Jun 2022 09:23:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EC4F88EA76;
        Wed,  8 Jun 2022 07:21:24 +0000 (UTC)
Date:   Wed, 8 Jun 2022 09:21:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: dp83td510: add cable testing
 support
Message-ID: <20220608072124.epd6zq6r4ttl6du4@pengutronix.de>
References: <20220608071749.3818602-1-o.rempel@pengutronix.de>
 <20220608071749.3818602-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aodkzja2s5fdzm6x"
Content-Disposition: inline
In-Reply-To: <20220608071749.3818602-3-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aodkzja2s5fdzm6x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.06.2022 09:17:48, Oleksij Rempel wrote:
> Cable testing was tested in different HW configurations and cables:
> - SJA1105 + DP83TD510
> - ASIX + DP83TD510
> - STM32MP1 + DP83TD510
>=20
> Results provided by this PHY should be interpreted with grain of sold.
                                                                   ^^^^
                                                                   salt
> For example testing unshielded and shielded twisted pair may give
> different results. Nevertheless, it still can be usable.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--aodkzja2s5fdzm6x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKgTfEACgkQrX5LkNig
010vdwf/bDkW4meDh4hBrBPhJembo+zcC64ORWdIN9AFn5p64e8hrm29IBmoJ/pV
Vxz90aHP2bz8eC10T2IwghV44QRSIaIfwHrdfEtgxHPB4wNE/gnGwLMWJ7oCObC/
vIES+M2t9aRq9Wt+8ELn66SnN8txWHhprQZu9ZkYX76ihMR2nMcNt3xIywBpXPJZ
8CEui29oMcyt9qVA24EpKQqTafRQvjPmCiBKy8zqrFSPZ0jn4ZbbU0/2l67grGWn
hrbQBnSAwU17eiKkQ/cYyEC0moul2Ut/nSXT5wTOBeAFt7v+Kei8/Ksq9wFKo6P0
h34KLOBRppih7JdT5BPSd5jDrVxsdg==
=+uWu
-----END PGP SIGNATURE-----

--aodkzja2s5fdzm6x--
