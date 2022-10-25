Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483C460C53A
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiJYHdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiJYHc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:32:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE8CBEAEA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:32:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onEQL-0008Px-7X; Tue, 25 Oct 2022 09:32:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2951D1092C7;
        Tue, 25 Oct 2022 07:32:32 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:32:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] can: mcan: Add MCAN support for FSD SoC
Message-ID: <20221025073230.3dzu7wli3goeuvre@pengutronix.de>
References: <CGME20221021102614epcas5p18bcb932e697a378a8244bd91065c5496@epcas5p1.samsung.com>
 <20221021095833.62406-1-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f4xb25bwerpzf74j"
Content-Disposition: inline
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f4xb25bwerpzf74j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.10.2022 15:28:26, Vivek Yadav wrote:
> Add support for MCAN instances present on the FSD platform.
> Also add support for handling error correction code (ECC) for MCAN
> message RAM.

Some patches are missing your S-o-b.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--f4xb25bwerpzf74j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXkQwACgkQrX5LkNig
012U6wf+LubB/UbltyFk3Jc5tRVxlcW90iChBlCK1rGgRdINoau8vkZNB5s47iv0
yebP6ckgXvRd/fOIqFucB550dBb4RdpLasicWPLmVrHRoQh18yeI0CJWeONZu1Ej
dtP+XbGFc/0iP2OAh0tyu9OLLc+ms5SSZ6YVRBpsALfpDqXn5TlJJN3utzLHAWvn
pLQOAu8msuY0xSUEVayVy3vhwYM2pgmeH/tSPaLAZgMb0IgYkZwAyZiFPClHa1ob
uoZssAxQTpSDFOWPSTVqMDDgZTaWkskdPYf0zcAvK/VVuCZ/x74nDa9nqG79mUOQ
dvIZ7Y5OSWsps7u6ujPaimmBEPCvig==
=NwLN
-----END PGP SIGNATURE-----

--f4xb25bwerpzf74j--
