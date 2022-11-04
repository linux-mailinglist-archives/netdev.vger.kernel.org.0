Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1206B619544
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiKDLSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiKDLSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:18:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9539B63BD
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:18:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oquiF-00014k-Q7; Fri, 04 Nov 2022 12:18:15 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7C0DE112D6E;
        Fri,  4 Nov 2022 11:18:12 +0000 (UTC)
Date:   Fri, 4 Nov 2022 12:18:11 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: m_can: sort header inclusion alphabetically
Message-ID: <20221104111811.dxavkstmmr3ltgje@pengutronix.de>
References: <CGME20221104050835epcas5p21514293206d887aa3d6c746d529dc2f2@epcas5p2.samsung.com>
 <20221104051617.21173-1-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6pliafhzmh4d6t5e"
Content-Disposition: inline
In-Reply-To: <20221104051617.21173-1-vivek.2311@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6pliafhzmh4d6t5e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.11.2022 10:46:17, Vivek Yadav wrote:
> Sort header inclusion alphabetically.
>=20
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6pliafhzmh4d6t5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNk9PAACgkQrX5LkNig
010FTwf9GqkzaJBflCl8wOQRT5Lzl2Dt4d+WGLEwo88Zin/NT5aU/mMfVXikhoTo
XZXpiZCcrNbO2CuVdjiZNnNBH6aL/tx/R1roxTzspNGf2uDl57x/P8VFXpw+30d8
V+HttrqvAkPJwbs0x9wffr5VC/LdmeLvjKrt62AeEQOu4BH2rC60G33NilRIPfNX
qw4SzqgON+GsyE7bfbAz/B6QckTELEnV1czFHDf28D5tm/A7OzfqbfX5zsN0FUyL
Y/Dpvd4VZpXQ5m+HfbNHVTad5/nxXSzjSk/ViY5yE4CHTuJoShuohNbd65In2J0t
inzQPVFnpBWqnl/90Gcplc/V8Jug0Q==
=qvrq
-----END PGP SIGNATURE-----

--6pliafhzmh4d6t5e--
