Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1DD553E9E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354748AbiFUWgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354582AbiFUWgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:36:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110E31DD9
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 15:36:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o3mUH-00072Y-BQ; Wed, 22 Jun 2022 00:36:45 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-ad3c-d4a3-b7b8-663d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:ad3c:d4a3:b7b8:663d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D10FB9BC62;
        Tue, 21 Jun 2022 22:36:42 +0000 (UTC)
Date:   Wed, 22 Jun 2022 00:36:42 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Liang He <windhl@126.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: Remove extra of_node_get in grcan
Message-ID: <20220621223642.zovfknmkl46d3lrs@pengutronix.de>
References: <20220619070257.4067022-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7hp4pruqbs2u4bdq"
Content-Disposition: inline
In-Reply-To: <20220619070257.4067022-1-windhl@126.com>
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


--7hp4pruqbs2u4bdq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.06.2022 15:02:57, Liang He wrote:
> In grcan_probe(), of_find_node_by_path() has increased the refcount.
> There is no need to call of_node_get() again.
>=20
> Fixes: 1e93ed26acf0 (can: grcan: grcan_probe(): fix broken system id chec=
k for errata workaround needs)
>=20
> Signed-off-by: Liang He <windhl@126.com>

Applied to linux-can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7hp4pruqbs2u4bdq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKyR/cACgkQrX5LkNig
012j4QgAil42H+AKdjYOmRnYwjdDdSVagPnwXJ8o1Xy8K5dBH9r/qNWyLdcOKHhH
0M0D/R/uNtFDGhXFkWz5pH9K/04BPpwZN9s3Je6vHsWvj6vULUDcOyW4I+SzdZaE
EMszknbppkNEJBg9C6OmapupzYMOq553CxYEIZPv7pXUAxe/ONDPZi7u8zstXFNp
n1f7MV+PdKYZ+v35EJtWIAqYr5TezaEzzcrwJE8ZtbGXT7l7Yg44JN30y6052mbj
fr33Lblwi/GT3y0SIdgmXoZnvNLYAq4CJVdpifUzA5tL+BeJRrRGkmtKYuNdAMZM
4HlThHfSdTNgSqjlUaXw42GTzOjPhQ==
=u3Xx
-----END PGP SIGNATURE-----

--7hp4pruqbs2u4bdq--
