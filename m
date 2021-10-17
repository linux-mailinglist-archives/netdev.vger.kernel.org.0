Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9255B4307FB
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 12:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbhJQKji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 06:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbhJQKjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 06:39:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD6CC061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 03:37:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc3XS-0001hh-FJ; Sun, 17 Oct 2021 12:37:10 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-11af-1534-a8a1-94ea.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:11af:1534:a8a1:94ea])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2FAFD6958A7;
        Sun, 17 Oct 2021 10:37:09 +0000 (UTC)
Date:   Sun, 17 Oct 2021 12:37:08 +0200
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
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_rts_session_new(): abort TP
 less than 9 bytes
Message-ID: <20211017103708.bzygs6hccnwpjyrp@pengutronix.de>
References: <1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6jstrlgcr7ltahid"
Content-Disposition: inline
In-Reply-To: <1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6jstrlgcr7ltahid
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2021 17:26:40, Zhang Changzhong wrote:
> The receiver should abort TP if 'total message size' in TP.CM_RTS and
> TP.CM_BAM is less than 9 or greater than 1785 [1], but currently the
> j1939 stack only checks the upper bound and the receiver will accept the
> following broadcast message:
>   vcan1  18ECFF00   [8]  20 08 00 02 FF 00 23 01
>   vcan1  18EBFF00   [8]  01 00 00 00 00 00 00 00
>   vcan1  18EBFF00   [8]  02 00 FF FF FF FF FF FF
>=20
> This patch adds check for the lower bound and abort illegal TP.
>=20
> [1] SAE-J1939-82 A.3.4 Row 2 and A.3.6 Row 6.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied to linux-can/testing, added stable on Cc.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6jstrlgcr7ltahid
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFr/NEACgkQqclaivrt
76kZPAf/dskpstn/SvhV+5z5Q2gidizf5s7CiC7AjujBQcuz4dn5F7RePEyIO112
kCVAFsDgi0ynHFvHKk0ZPX5gP4/Y5RkUl6nLJkHEd31MqKnti4dCR/KjOtwUsGjE
8Z83/YpH3UulABDJ2xsZsHRGHkvGo9KZbIC+EKhqFgCs7GhdXgCsajrlvtTi8qGA
WgrJ2A8ms0z79BMK4w//3Gac6p6kCyQ5socwhZmfvPUgmI1h7KHuPdn1AVTCI4v6
I4b/NC/frGAG1HJkGFseZStZAVgFCmpTaRitzuw4+nav7QT+rk8oebbGY8t9M22X
duccm00Mge3OA3kaz3ZzxcUjNbACnw==
=mBE8
-----END PGP SIGNATURE-----

--6jstrlgcr7ltahid--
