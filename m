Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30234307F6
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245310AbhJQKhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 06:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245315AbhJQKhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 06:37:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF19C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 03:34:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc3Uz-0001EN-Qq; Sun, 17 Oct 2021 12:34:37 +0200
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B87EF69589A;
        Sun, 17 Oct 2021 10:33:10 +0000 (UTC)
Date:   Sun, 17 Oct 2021 12:32:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session
 if receive TP.DT with error length
Message-ID: <20211017103239.4q6klfqh2gxvrfbh@pengutronix.de>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6jn4v6heyfmiekk5"
Content-Disposition: inline
In-Reply-To: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6jn4v6heyfmiekk5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.09.2021 11:33:20, Zhang Changzhong wrote:
> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
> cancel session when receive unexpected TP.DT message.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied to linux-can/testing, added stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6jn4v6heyfmiekk5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFr+8QACgkQqclaivrt
76n8uQgAlX6AGpoX/AxKrzvJDOQ1tipLZXM9q54k9y1dyMdLDL9lEKKASSa9DePV
7g6ajYai9mbT1Ui10ZVW/peep1W69wQTBU2pc49+Q1nYT8hL1jZN+cszUze42hfV
d70WcOxPkD1CukFgI7vGnu34tg5k4pVX8PD/gdBpSMtwnAZpw+X6di3IgrUQR3FE
Xe3I7xgYsS4GqDbgWmBaxXWIpBTvgIqdpgIZxJErDPX/zrXJP8YPJHXiW47Xm7zt
vmuIEFNxJJ04JlGqhfhKmUQsaMhi6VvGY2BcGn3FvEypG+W8zAONrhCETXRQu15I
kGkm/sb6d1PIpKNSiEY9ozOUNRAzsw==
=myFN
-----END PGP SIGNATURE-----

--6jn4v6heyfmiekk5--
