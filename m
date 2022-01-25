Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF5549B89E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiAYQb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245690AbiAYQZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:25:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DD6C06175C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:25:28 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nCOdJ-0006iI-Bf; Tue, 25 Jan 2022 17:25:25 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C0B3A22EEF;
        Tue, 25 Jan 2022 16:25:14 +0000 (UTC)
Date:   Tue, 25 Jan 2022 17:25:07 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Message-ID: <20220125162507.sxjzjk5pqdpppxsl@pengutronix.de>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ockqoulgc4mli6xe"
Content-Disposition: inline
In-Reply-To: <20211201220328.3079270-1-stefan.maetje@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ockqoulgc4mli6xe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2021 23:03:24, Stefan M=C3=A4tje wrote:
> *Note*: scripts/checkpatch.pl still emits the following warnings:
>   - esd_402_pci-core.c:270: Possible unnecessary 'out of memory' message
>     This error message is there to tell the user that the DMA allocation
>     failed and not an allocation for normal kernel memory.

The kernel takes care of printing a error message in case the DMA mem
allocation fails. This is why checkpatch asks you to remove that message.

>   - esdacc.h:255: The irq_cnt pointer is still declared volatile and
>     this has a reason and is explained in detail in the header
>     referencing the exception noted in volatile-considered-harmful.rst.

I'll look into this, I'll probably ask you to explain the IRQ demux to
me :)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ockqoulgc4mli6xe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHwJGAACgkQqclaivrt
76ldxwf/aB9FKOCrDocj0sQzhnkX2fMunr+Hs16al4ZgxsLG/KJa4/tlLJwAjPz3
NjlXIy++bEJmmBREDQ+6QKUXKoMewvEn1AM4qDRykO2os2DgitDpWHspEPShe8/N
sFIU6cl0yOzKFsTzvTxnbT6K+aqyPX8LkSOsyIc3ASZGjFgsoY34sSprE2Hm8iN2
S87Iy54Wec/P/C34xrg+JCYFpigDwheRqqKld3czddD6UmOvtEJvkp41HxFM20H1
mSHTimgXQYtaZd4PZj0nCbSpl2s3Q6j9+3Dyd1HchR5xXlLHhjxlR6tLFt1zc2xj
/G+hjrMggmGWOl+gsdfKAAytdRT+kw==
=EW4t
-----END PGP SIGNATURE-----

--ockqoulgc4mli6xe--
