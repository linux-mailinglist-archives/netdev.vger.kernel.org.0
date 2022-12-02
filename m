Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ABB640863
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbiLBO21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiLBO20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:28:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D52842F44
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 06:28:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p171Y-0000GT-6M; Fri, 02 Dec 2022 15:28:20 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D4B5B131705;
        Fri,  2 Dec 2022 14:28:18 +0000 (UTC)
Date:   Fri, 2 Dec 2022 15:28:10 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] can: tcan4x5x: Fix register range of first block
Message-ID: <20221202142810.kmd5m26fnm6lw2jh@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-15-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="afldurfie5cbuheh"
Content-Disposition: inline
In-Reply-To: <20221116205308.2996556-15-msp@baylibre.com>
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


--afldurfie5cbuheh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2022 21:53:07, Markus Schneider-Pargmann wrote:
> According to the datasheet 0x1c is the last register in the first block,
> not register 0x2c.

The datasheet "SLLSF91A =E2=80=93 DECEMBER 2018 =E2=80=93 REVISED JANUARY 2=
020" says:

| 8.6.1 Device ID and Interrupt/Diagnostic Flag Registers: 16'h0000 to
| 16'h002F

While the last described register is at 0xc.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--afldurfie5cbuheh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKC3gACgkQrX5LkNig
013FEQf/TUDXQbVkafJGyol7PjWr8gxAcdLLY5RI5HqBOAZk6TB4z141GP1ovuJ5
WebBj6CkO4Og2oqTXB0XM1My+lnu6pRxo9Z1vVKnJ9vf0OEgdxA/Wi6pbyAp+VP4
kvpMv1GI8YbpQ4SHLGhb8kb59Jmio2Re+AX4TazHVlhe4ceGeJ3Q0m3sMSB+D6Jq
rp45EM6kcewzRD5V1ZaHJv8ArXd52G9QIZIuiEFPPalck+U21tcsFZ1lKKr+sh+d
Ao0s43vQoXCZjxIYK0lJxvhBhpJWNKmbVivFn2WIY4VUfwl8WWfOJxqMryV1vEJw
HjSm5dcTYBVVEe7Sc/T3+feRHrn3/g==
=kbtm
-----END PGP SIGNATURE-----

--afldurfie5cbuheh--
