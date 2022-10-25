Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8560C5B4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiJYHpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiJYHpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:45:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A086406
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:44:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onEbu-0001jd-0z; Tue, 25 Oct 2022 09:44:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C32D91092E3;
        Tue, 25 Oct 2022 07:44:27 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:44:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] can: mcan: enable peripheral clk to access mram
Message-ID: <20221025074424.udfltascaqjc6dhs@pengutronix.de>
References: <20221021095833.62406-1-vivek.2311@samsung.com>
 <CGME20221021102632epcas5p29333840201aacbae42bc90f651ac85cd@epcas5p2.samsung.com>
 <20221021095833.62406-5-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2636diqrfd4pgcj5"
Content-Disposition: inline
In-Reply-To: <20221021095833.62406-5-vivek.2311@samsung.com>
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


--2636diqrfd4pgcj5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.10.2022 15:28:30, Vivek Yadav wrote:
> When we try to access the mcan message ram addresses, make sure hclk is
> not gated by any other drivers or disabled. Enable the clock (hclk) before
> accessing the mram and disable it after that.
>=20
> This is required in case if by-default hclk is gated.

=46rom my point of view it makes no sense to init the RAM during probe.
Can you move the init_ram into the m_can_chip_config() function? The
clocks should be enabled then.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2636diqrfd4pgcj5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXk9YACgkQrX5LkNig
012s4wgAgEvXknoIf4nkxglrh4BH7qZ19M3p2awqWomcLpkgCN0XfHo7NGFtd4pD
UABYD6nDQYc+aOPqQmDFfYVghWHXv5BvjLWuojiq5d9m6YLXw9zcPzBH3NcTlTV8
Unt4dCYLjDW3HAurEG5C4OA0/zyzaIezFtIil+UszYX19g/JEknxydnkxMsakrqH
Bwr0CUBmi3tytW1oWMpgpSh6VCbcH9XKzEP9OeXQtDyZZdOcNeJM6G/nJSecPV8j
rUogXNZcuHGqIp0rWsJV8bfjDK4fgfcntfznWgV+MN8V3X1vfmpKNmD6cqrAsj0O
eisHx4gR0CXKc+LzFJ2NCGWPjCl8dg==
=3bl7
-----END PGP SIGNATURE-----

--2636diqrfd4pgcj5--
