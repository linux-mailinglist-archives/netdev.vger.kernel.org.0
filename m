Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4155F9D1C
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 12:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiJJKy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 06:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiJJKy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 06:54:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4B26BD72
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 03:54:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ohqQT-0005qC-0y; Mon, 10 Oct 2022 12:54:25 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EF555F9229;
        Mon, 10 Oct 2022 10:54:23 +0000 (UTC)
Date:   Mon, 10 Oct 2022 12:54:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] iplink_can: add missing `]' of the bitrate, dbitrate and
 termination arrays
Message-ID: <20221010105420.rljwxdgwmzvu4cyv@pengutronix.de>
References: <20221010105041.65736-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qk55ih6swerstpce"
Content-Disposition: inline
In-Reply-To: <20221010105041.65736-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qk55ih6swerstpce
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vincent,

thanks for taking care, and finding the other missing closing ']'!

On 10.10.2022 19:50:41, Vincent Mailhol wrote:
> The command "ip --details link show canX" misses the closing bracket
> `]' of the bitrate, the dbitrate and the termination arrays. The JSON
> output is not impacted.
>=20
> Change the first argument of close_json_array() from PRINT_JSON to
> PRINT_ANY to fix the problem. The second argument is already set
> correctly.
>=20
> Fixes: 67f3c7a5cc0d ("iplink_can: use PRINT_ANY to factorize code and fix=
 signedness")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de> via vger.kernel.org>
                                                      ^^^^^^^^^^^^^^^^^^^^
Copy/Paste mistake? Please remove :)

> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qk55ih6swerstpce
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmND+dkACgkQrX5LkNig
01091Qf9H7CJ8MVxjPwv7K+8OPh0FswlDZWNEUuDGivmYMUxhILD0A02FFYIWiJ/
Sidy+Y8Sc3eXgvVel8+j+cNoT0TGC34NPuV76kcs3xuqBUYH1wobJ3x65OZhum5W
94W1QIchtQi/nUZTp8fjxD2F39a27oQLL/PfvjgmBKEbDUh5y/LaCsWKyHknsmRc
fDCIYIN5JchsHvw4iDTuY+rzsmgmV7fYxAo3UTYsUXv1mYy+SeunSQo3zTrsa54W
/IPzPehBCt3d5cMttZeh/J9y3iHZHRX3tmohVWLFnjFxHvjdRbu6w80YjV6yOrnt
WBHtGHdqBj1D19D0mAiIRDJe5NBvuA==
=p3+h
-----END PGP SIGNATURE-----

--qk55ih6swerstpce--
