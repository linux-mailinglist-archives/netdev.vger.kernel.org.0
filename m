Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14146637C7F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiKXPJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKXPJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:09:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5587F15B4E5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:09:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDqL-0007Hq-Lx; Thu, 24 Nov 2022 16:08:49 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D6762128715;
        Thu, 24 Nov 2022 15:08:48 +0000 (UTC)
Date:   Thu, 24 Nov 2022 16:08:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] can: cc770: add missing free_cc770dev() in
 cc770_isa_probe()
Message-ID: <20221124150847.5mzafztlb6qr6wzo@pengutronix.de>
References: <1668168557-6024-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xyr6puzvnva3rugy"
Content-Disposition: inline
In-Reply-To: <1668168557-6024-1-git-send-email-zhangchangzhong@huawei.com>
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


--xyr6puzvnva3rugy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.11.2022 20:09:16, Zhang Changzhong wrote:
> Add the missing free_cc770dev() before return from cc770_isa_probe() in
> the register_cc770dev() error handling case.
>=20
> In addition, remove blanks before goto labels.
>=20
> Fixes: 7e02e5433e00 ("can: cc770: legacy CC770 ISA bus driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied to linux-can.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xyr6puzvnva3rugy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/iPwACgkQrX5LkNig
010AHAgAgcTbWF4nsjKqCHvZgWivk46qroxzomBCVo34/xmM6um5TUs+Xeqf9KIA
3ONf8IX+HkhZxypT67VyCICWjVzdhItWzvuOu+hSqYSo78E/R1IqroDUAupI4UEY
6UyP+p1SJwY/uK7A5NK8W/GeHJhqpb8HJLwVKNoKYKhCJ6ILkcs3IewVkI1ukUJq
hva2VnBjBtUkKGia9sNKRHQanGCD+ZkXtRyor0kTRmsKd8c268BXO3DVSZrQLKCJ
FT1nj0fu15QfSJVY7QJ2SLuUtK3jSDfCtGD+G7KgDeq73d/E+1OmU5ZpLXiB7ZCq
aAyAammdlhEXxqdY+h8b4EklrjcNKQ==
=qmtl
-----END PGP SIGNATURE-----

--xyr6puzvnva3rugy--
