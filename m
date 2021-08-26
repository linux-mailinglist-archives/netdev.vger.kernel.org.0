Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3A13F8298
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbhHZGoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhHZGoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 02:44:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6384C0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 23:43:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mJ96X-000885-PP; Thu, 26 Aug 2021 08:43:13 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-b2ee-1fdd-6b26-f446.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:b2ee:1fdd:6b26:f446])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8295C66FF4C;
        Thu, 26 Aug 2021 06:43:12 +0000 (UTC)
Date:   Thu, 26 Aug 2021 08:43:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] can: usb: esd_usb2: Fix the interchange of CAN TX
 and RX error counters
Message-ID: <20210826064311.c3wrmxivzuppb24x@pengutronix.de>
References: <20210825215227.4947-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5suf7qa6qtsi6bcm"
Content-Disposition: inline
In-Reply-To: <20210825215227.4947-1-stefan.maetje@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5suf7qa6qtsi6bcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.08.2021 23:52:26, Stefan M=C3=A4tje wrote:
> In the driver for the esd CAN-USB/2 the CAN RX and TX error counters
> were fetched interchanged from the ESD_EV_CAN_ERROR_EXT message and
> therefore delivered wrong to the user.
>=20
> To verify the now correct behavior call the candump tool to print CAN
> error frames with extra infos (including CAN RX and TX error counters)
> like "candump -e -x can4,0:0,#fffffffff".
> Then send a CAN frame to the open (no other node) but terminated CAN
> bus. The TX error counter must increase by 8 for each transmit attempt
> until CAN_STATE_ERROR_PASSIVE is reached.
>=20
> Stefan M=C3=A4tje (1):
>   can: usb: esd_usb2: Fix the interchange of the CAN RX and TX error
>     counters.
>=20
>  drivers/net/can/usb/esd_usb2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to linux-can/testing.

Thanks,
Marc

> base-commit: cbe8cd7d83e251bff134a57ea4b6378db992ad82

BTW: Thanks for including a base-commit. Your base is
linux-can-next-for-5.15-20210825, but this is a bug-fix patch. It should
be based on the latest can pull request, can/master or net/master
instead. It doesn't matter here, as the patch applies without problems.

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5suf7qa6qtsi6bcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEnN/wACgkQqclaivrt
76l81Af/Rv8oQATPJBM2ThVeUa4zLmHN4sVf2IBLdaRrG323fQHgl05JiGUgU+pB
IHiF6oCLC5oTYtJSDXPZ3L7Dj6rXh4J89L9KsDo2oWa+XcD23iS+vjz2T3cZKUc3
2CWXKjuOK8S/cNiVn9nYFG0BiJAILbNP6ED/uFzHLjSB5k8XJ5l4jM/Ch49KyE9x
t1u/Omv/47wqt20ehtko9XCbEykWoSO+e10WeT4BLwGXGOCGtWmxNTyqpQVd6Zqp
9IICTFM+1I8e+FzRolPFz4UgYrEp7I98owynxKGRxgcUgIo2hfbmJR6PL4u8EOX3
IY8qyqdp6TXbEBKmj0V7NTJ3Ps2sZg==
=dOHP
-----END PGP SIGNATURE-----

--5suf7qa6qtsi6bcm--
