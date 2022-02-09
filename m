Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5262B4AEB64
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiBIHqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiBIHqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:46:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E733C05CB80
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 23:46:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHhg9-0002HK-Ae; Wed, 09 Feb 2022 08:46:17 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DC4532EED4;
        Wed,  9 Feb 2022 07:46:13 +0000 (UTC)
Date:   Wed, 9 Feb 2022 08:46:10 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: Re: [PATCH] can: isotp: fix error path in isotp_sendmsg() to unlock
 wait queue
Message-ID: <20220209074610.dstzmwloiqr4qfwc@pengutronix.de>
References: <20220209073601.25728-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kx7rudp3oxk2w2sm"
Content-Disposition: inline
In-Reply-To: <20220209073601.25728-1-socketcan@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kx7rudp3oxk2w2sm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.02.2022 08:36:01, Oliver Hartkopp wrote:
> Commit 43a08c3bdac4 ("can: isotp: isotp_sendmsg(): fix TX buffer concurre=
nt
> access in isotp_sendmsg()") introduced a new locking scheme that may rend=
er
> the userspace application in a locking state when an error is detected.
> This issue shows up under high load on simultaneously running isotp chann=
els
> with identical configuration which is against the ISO specification and
> therefore breaks any reasonable PDU communication anyway.
>=20
> Fixes: 43a08c3bdac4 ("can: isotp: isotp_sendmsg(): fix TX buffer concurre=
nt access in isotp_sendmsg()")
> Cc: Ziyang Xuan <william.xuanziyang@huawei.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied to linux-can/testing. Added stable on Cc.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kx7rudp3oxk2w2sm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDcUAACgkQrX5LkNig
010urgf+I5mFg46J354WwV0/dHPZxI6ijEoHoeSMS5cr2hMshUnQiKOc51ga+ZwS
bSZnMsUHOER4GRN1NjGZmpdsntcsNgs91akPvUEmeWEN2gFnmFlGEA7Lz9R+NhQR
VD2a+Ej8NSUBN9g4KmPXxAdK1Uv8TWtH2BlhOdQ5ipiQCainoeiEhOwIH8z2Opbh
FxlrTRtD4oi4Ch6RQKoHtGxbVAkuJDKDp1AFfp6nfCQf5sV34LhgL749zum2iUnh
QdQHpPuN2SNJ0dz9Hj8JTTSCQ4jr7UwGOhmN4dKJAdSG6dLHk10O1O1BJjlbCmhl
A4zqhWqCdK73GiA0YjXGoBvN7x/yyw==
=hNPV
-----END PGP SIGNATURE-----

--kx7rudp3oxk2w2sm--
