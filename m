Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEAA5E7A7A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiIWMWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiIWMVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:21:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307AE138F32
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:12:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhXk-0008VJ-2y; Fri, 23 Sep 2022 14:12:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 32A1CEB1A1;
        Fri, 23 Sep 2022 12:12:31 +0000 (UTC)
Date:   Fri, 23 Sep 2022 14:12:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] can: bcm: can: bcm: random optimizations
Message-ID: <20220923121230.hxfngsq7ngy442ya@pengutronix.de>
References: <cover.1663206163.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2saqxs33poxjr5yu"
Content-Disposition: inline
In-Reply-To: <cover.1663206163.git.william.xuanziyang@huawei.com>
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


--2saqxs33poxjr5yu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.09.2022 09:55:54, Ziyang Xuan wrote:
> Do some small optimization for can_bcm.

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2saqxs33poxjr5yu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMtoqwACgkQrX5LkNig
013jWwgAnfCO4+T4DhyqD9Sx7DyFZpEZp+FBRFI5H3zWvo7uDlZSm5ZCbH5Enc4I
a/PTo/5eKZhY5t9eRj6zFFlzqnCdg0sxLxLceHF1ykJjQW2YiG9VKcM+3gSvTbsS
K9zl7R1ZoqZpGI7DgTAgHXYX/4sG/6DCuLIaE9A2Mdn6RlWTqQaesOuuJT0WQG9z
cl1RAaGbooYWGeI/I9yfymiyiLu83+TavR70w6aFHXUfbNx2X6QcaluFssRi12Fs
ye1A/Eu006E2/ZWcARCJEXPnIDaISXq9GUCn608Bba9M/5oxlvDckcBN7zDA9I8B
YUwSSm3aVVhHd2e5R6LR4lbSPY/kqA==
=CW5D
-----END PGP SIGNATURE-----

--2saqxs33poxjr5yu--
