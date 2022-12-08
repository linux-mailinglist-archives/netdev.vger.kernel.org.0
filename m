Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272F9646B76
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLHJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiLHJHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:07:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761044E6BE
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:06:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p3CrR-0005XE-14; Thu, 08 Dec 2022 10:06:33 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:92e:b9fb:f0e7:2adf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 786E713948F;
        Thu,  8 Dec 2022 09:06:30 +0000 (UTC)
Date:   Thu, 8 Dec 2022 10:06:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ye Bin <yebin@huaweicloud.com>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, yebin10@huawei.com
Subject: Re: [PATCH net-next] net: af_can: remove useless parameter 'err' in
 'can_rx_register()'
Message-ID: <20221208090622.7vp6xjkyh26jzvpz@pengutronix.de>
References: <20221208090940.3695670-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nqaj6drbuy6wf66i"
Content-Disposition: inline
In-Reply-To: <20221208090940.3695670-1-yebin@huaweicloud.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nqaj6drbuy6wf66i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.12.2022 17:09:40, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
>=20
> Since commit bdfb5765e45b remove NULL-ptr checks from users of
> can_dev_rcv_lists_find(). 'err' parameter is useless, so remove it.
>=20
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nqaj6drbuy6wf66i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmORqQsACgkQrX5LkNig
010ZUwf+MGBRuJnw3cRwCfUcjhjmK4LSK4B4C9xyb6aeorVds6iQ9kunEeZp/kUP
c1JLeGBu48d+ruONAUgBfH0THAfYiiTJSjp6jfwsCM5N/nr2Z+Yex5TL2kTORVBU
BFuT+POvP0HhCGgEHgrzKhCLmmAJYaCBc4y24pHuwqezEfJtnKX873OSOLIDLiQa
Q+/EKlvmbHNNGOXjNFXn8itsSjNgntsdXulDc23d9lJQnw82FvQfORgjTOAf76HI
FH8IB2C9CWrr0V3dQYzZ2IsdUZrVXVMDmZlJTG8/wHM3KVaT7tkV81uTnnlaOrC1
g2Wnd7gsq6/tg7rg4A49mImf3AkT+A==
=xiRa
-----END PGP SIGNATURE-----

--nqaj6drbuy6wf66i--
