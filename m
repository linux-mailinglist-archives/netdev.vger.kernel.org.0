Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB2660C5B8
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiJYHp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiJYHpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:45:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBDED57FA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:45:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onEcP-0001oW-P8; Tue, 25 Oct 2022 09:45:01 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A35CF1092E5;
        Tue, 25 Oct 2022 07:45:00 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:44:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: Re: [PATCH 5/7] arm64: dts: fsd: Add MCAN device node
Message-ID: <20221025074459.z7utljgnexqnohir@pengutronix.de>
References: <20221021095833.62406-1-vivek.2311@samsung.com>
 <CGME20221021102635epcas5p33623e6b6ed02d3fb663da9ec253585ad@epcas5p3.samsung.com>
 <20221021095833.62406-6-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ykpmhpitlojghido"
Content-Disposition: inline
In-Reply-To: <20221021095833.62406-6-vivek.2311@samsung.com>
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


--ykpmhpitlojghido
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.10.2022 15:28:31, Vivek Yadav wrote:
> Add MCAN device node and enable the same for FSD platform.
> This also adds the required pin configuration for the same.
>=20
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

Please add the DT people on Cc.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ykpmhpitlojghido
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXk/kACgkQrX5LkNig
010figf9HAIKN8UzsLOvNgGVazFnTNDI5tr95FdMvQeuO1BeZwnLjuds+XoH9PuQ
nAvGgrbwb6QvGV0CDdNOJS/M+MvS5KcJw81TohuToDxiNZKZYoNJ3IF98jue78Ew
0EoEp0abO9L6vnferQu3JGNIhDpoBub/99SxGryO6ID6MpdHvvkrl8QEnx7ipwZN
ATpzUMoaX9y/18Cdjs6ijCu1uE2u8ZPWGGVSqVbW+ZhEhQFUiH0cCnnA3eXdn4ZK
HEcGG+oARd/BBCZUCN8zj+GxCJ8JP6K5hVaPxKknUl0/wlB084tg8mf/wZBkVwW8
niXj5O+v4+rzwGvxM7SWUFRkeHh0Sw==
=kt9G
-----END PGP SIGNATURE-----

--ykpmhpitlojghido--
