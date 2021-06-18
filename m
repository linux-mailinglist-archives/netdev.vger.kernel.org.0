Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9AA3AC7B2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhFRJgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhFRJgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:36:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58028C061760
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:34:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luAtO-00039n-NP; Fri, 18 Jun 2021 11:34:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e7d0:b47e:7728:2b24])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4E88163EBDD;
        Fri, 18 Jun 2021 09:34:25 +0000 (UTC)
Date:   Fri, 18 Jun 2021 11:34:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="55cmhyzkkat2oovn"
Content-Disposition: inline
In-Reply-To: <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--55cmhyzkkat2oovn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2021 00:15:50, Vincent Mailhol wrote:
> Add the netlink interface for TDC parameters of struct can_tdc_const
> and can_tdc.
>=20
> Contrary to the can_bittiming(_const) structures for which there is
> just a single IFLA_CAN(_DATA)_BITTMING(_CONST) entry per structure,
> here, we create a nested entry IFLA_CAN_TDC. Within this nested entry,
> additional IFLA_CAN_TDC_TDC* entries are added for each of the TDC
> parameters of the newly introduced struct can_tdc_const and struct
> can_tdc.
>=20
> For struct can_tdc_const, these are:
>         IFLA_CAN_TDC_TDCV_MAX
>         IFLA_CAN_TDC_TDCO_MAX
>         IFLA_CAN_TDC_TDCF_MAX
>=20
> For struct can_tdc, these are:
>         IFLA_CAN_TDC_TDCV
>         IFLA_CAN_TDC_TDCO
>         IFLA_CAN_TDC_TDCF

I just noticed in the mcp2518fd data sheet:

| bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
| Secondary Sample Point (SSP) Two=E2=80=99s complement; offset can be posi=
tive,
| zero, or negative.
|=20
| 011 1111 =3D 63 x TSYSCLK
| ...
| 000 0000 =3D 0 x TSYSCLK
| ...
| 111 1111 =3D =E2=80=9364 x TSYSCLK

Have you takes this into account?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--55cmhyzkkat2oovn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDMaJ4ACgkQqclaivrt
76mKgAf9EkwICK14DmNGr4PmhjSWmlCIR0wQxINtOIXd10bn/QiPLDhtu9MSRN3X
Z22joQoze/4/cH2nRsPFNmhkNjiPX8CYYR4JJw6wimr9DpNp1l6R2w/gkaZOgJrw
QnH9oJ9eIbw0CCK9GHkpB43PoFsJYRNvGJAj6W4aUFY6JfwY1z+OkAkaxsmJL110
wtdD5XxSf2MJlgjrJOG94qI95tbcYvIk48AhiV6f1F7D26jEudo5zWySa0jKw134
q7NerS+9zNf2V5LcSSlE2pMn81aC9JTzYGrsM6lBKJQQSFNqdgT80PPj16A0bdk1
SuFnaI9VtjXbiaj1vv3z8kOt3PrQtA==
=1QdF
-----END PGP SIGNATURE-----

--55cmhyzkkat2oovn--
