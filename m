Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A810C4A709C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbiBBMVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiBBMVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:21:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EB3C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:21:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nFEdp-0002oV-EN; Wed, 02 Feb 2022 13:21:41 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9523829C05;
        Wed,  2 Feb 2022 12:21:39 +0000 (UTC)
Date:   Wed, 2 Feb 2022 13:21:36 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Message-ID: <20220202122136.nmrza36tfqb6zfh6@pengutronix.de>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fhgf3yvjppidpmlv"
Content-Disposition: inline
In-Reply-To: <20211201220328.3079270-1-stefan.maetje@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fhgf3yvjppidpmlv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2021 23:03:24, Stefan M=C3=A4tje wrote:
> The purpose of this patch is to introduce a new CAN driver to support
> the esd GmbH 402 family of CAN interface boards. The hardware design
> is based on a CAN controller implemented in a FPGA attached to a
> PCIe link.
>=20
> More information on these boards can be found following the links
> included in the commit message.
>=20
> This patch supports all boards but will operate the CAN-FD capable
> boards only in Classic-CAN mode. The CAN-FD support will be added
> when the initial patch has stabilized.
>=20
> The patch is reuses the previous work of my former colleague:
> Link: https://lore.kernel.org/linux-can/1426592308-23817-1-git-send-email=
-thomas.koerper@esd.eu/
>=20
> *Note*: scripts/checkpatch.pl still emits the following warnings:
>   - esd_402_pci-core.c:270: Possible unnecessary 'out of memory' message
>     This error message is there to tell the user that the DMA allocation
>     failed and not an allocation for normal kernel memory.
>   - esdacc.h:255: The irq_cnt pointer is still declared volatile and
>     this has a reason and is explained in detail in the header
>     referencing the exception noted in volatile-considered-harmful.rst.

I think you can use READ_ONCE() instead of the volatile.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fhgf3yvjppidpmlv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmH6d00ACgkQrX5LkNig
010MYwf/anJrAUZWGxxmww7+YQW3Wo3HGQ97tBtPfQxkrhr2y+vRkrksvbqGPFkN
U8XILWMYZs1LIZfGsOVgSpLeQyF0kE8XDMyTshNkQ1edN/1EX+SVMqn366RBIA2+
f3J7FkRYIvru8QoggP/K2bTITR0jI6o/5kNscAXfpWJB+kQElots345EFM0K1Bq5
Ajd1mzlvagLvI+p0I736cfpYkrrO9xVNo76OLC1qj+VqfVavCmKQeGEbK+JadyUJ
uhEWtRfxmBLfI4A2+gA6kZvwhb8GQGlbmswdG7rrlpDmDZZ5neNYEURAMJ71fWWx
2wvTy6p383k+phq+0fHKUrWW2rZAFg==
=l77b
-----END PGP SIGNATURE-----

--fhgf3yvjppidpmlv--
