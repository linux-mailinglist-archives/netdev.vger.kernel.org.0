Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C40260C4FF
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiJYHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiJYHZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:25:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD13BD65A
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:25:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onEIr-0006qd-Cw; Tue, 25 Oct 2022 09:24:49 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3196E10928E;
        Tue, 25 Oct 2022 07:24:43 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:24:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Message-ID: <20221025072441.2ag7lce6otf6iqgh@pengutronix.de>
References: <20221021095833.62406-1-vivek.2311@samsung.com>
 <CGME20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d@epcas5p4.samsung.com>
 <20221021095833.62406-3-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cqd4rpcgmhoe7alu"
Content-Disposition: inline
In-Reply-To: <20221021095833.62406-3-vivek.2311@samsung.com>
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


--cqd4rpcgmhoe7alu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.10.2022 15:28:28, Vivek Yadav wrote:
> Whenever the data is transferred or stored on message ram, there are
> inherent risks of it being lost or corruption known as single-bit errors.
>=20
> ECC constantly scans data as it is processed to the message ram, using a
> method known as parity checking and raise the error signals for corruptio=
n.
>=20
> Add error correction code config property to enable/disable the
> error correction code (ECC) functionality for Message RAM used to create
> valid ECC checksums.
>=20
> Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

Can you please add an example to the yaml that makes use of the
mram-ecc-cfg property?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cqd4rpcgmhoe7alu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXjzYACgkQrX5LkNig
010kgwgAsg5YMPXId/SwZXkoLXsOCA+ZmYo/8K9++Yo/BrjnTGfbBN6BhDi0PQcy
2O7nab0pEAD1/w8pGhu3k04M1GS/Q/ytLuoqI6UUByQhtS/54ttzk8FRiz2VEImH
UoBQ/cUeKBJYye4SfkcDvCIM98uATFmHTGSdfaS9hyLbJ4y8/02NfWk7MfyXLAIR
aC6/N/NDeGwhSYD6dOGnFJHSm2g3+6REkGDG728qIHPCpq4apmjIqntXYzaRMYLE
2sdfnIgMg4Opeazp95vlMJof7spsArZCJRdXeLPGfiHOx0yBt/PPToPY3p3rlxU6
2i+iKFwIaz85GQLMhucamxjsfQFyoA==
=h9JL
-----END PGP SIGNATURE-----

--cqd4rpcgmhoe7alu--
