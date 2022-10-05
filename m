Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67945F57F4
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJEQEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiJEQEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:04:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6C77B298
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 09:04:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1og6sT-00087I-83; Wed, 05 Oct 2022 18:04:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 01B34F5874;
        Wed,  5 Oct 2022 16:04:06 +0000 (UTC)
Date:   Wed, 5 Oct 2022 18:04:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: [PATCH v6 2/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Message-ID: <20221005160405.xcxecyic3nqhuhht@pengutronix.de>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
 <20211201220328.3079270-3-stefan.maetje@esd.eu>
 <20220201172508.vvftyw2vy4uq2jpu@pengutronix.de>
 <fa770d67ed8bb7feea08954ebf25d5c9bebbe700.camel@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ltk2dysu6dygmh2y"
Content-Disposition: inline
In-Reply-To: <fa770d67ed8bb7feea08954ebf25d5c9bebbe700.camel@esd.eu>
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


--ltk2dysu6dygmh2y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.09.2022 22:15:59, Stefan M=C3=A4tje wrote:
> I would like to resume the efforts to bring this driver in the Linux
> kernel after being kicked off track in February by another project.

\o/

> I did a lot of the changes on the driver you recommended, but some
> stuff is not yet clear to me. Please see my comments in-line of the
> email below.
>=20
> My local developement is at the moment rebased to
> linux-can-next:master on 7b584fbb36362340a2d9cfe459e447619eecebea.
> Should I send a V7 of the patch (rebased to another commit)? How
> should I proceed?

You can use latest net-next/main as base version.

> You have commented on many type casts that they would not be needed.
> But all of them had been introduced by me due to warnings of the
> compiler in the style of "warning: conversion from =E2=80=98u32=E2=80=99 =
{aka
> =E2=80=98unsigned int=E2=80=99} to =E2=80=98u8=E2=80=99 {aka =E2=80=98uns=
igned char=E2=80=99} may change value
> [-Wconversion]". These are triggered by building the driver with "W=3D3"
> as recommended in kernel documentation.

Oh? Is there a recommendation for W=3D3? I can only find a W=3D1:

| https://elixir.bootlin.com/linux/v6.0/source/Documentation/process/mainta=
iner-netdev.rst#L235

> Should these warnings generally be ignored and the casts be removed
> then?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ltk2dysu6dygmh2y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmM9qvIACgkQrX5LkNig
012H7AgAiUQMOx+sXOYO27Kq5AYVPjxXpHYC3pL1XTDpXUwF+Q/1CKvfLSYz4XGN
ayFxYF1AJ7+D7vH5TDorJRrxSpgnTy3QZXKg+IERvrYiqPptGYXi7hE3lrJlTC0T
5vrpwfV4fvolcaf5D/fjADZyIbP9zfbZkMlu9/CjN0uweV1E0SEulHdthdr58RP2
x8qao9pHWKuMbPUu8QL57XHV8waAmGiRtuLrMYxv/ZT1SJ/HwZrl7sx8xfLLaSlt
1V4UT8VEsAnK3fI+NdmT1F8P/uuOT9OI/T6RCcfLMChHMA6lbJZQ1JXH2qS0yNOj
c3F7Y1RILiQPXhL/r5maSCxMAQkQBg==
=+S8j
-----END PGP SIGNATURE-----

--ltk2dysu6dygmh2y--
