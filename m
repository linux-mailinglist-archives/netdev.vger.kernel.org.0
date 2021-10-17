Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0014308A0
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245636AbhJQMYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245614AbhJQMYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:24:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E86BC061768
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 05:22:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc5B9-0003hi-GA; Sun, 17 Oct 2021 14:22:15 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-7b24-848c-3829-1203.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7b24:848c:3829:1203])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2A1BD695CC4;
        Sun, 17 Oct 2021 12:22:13 +0000 (UTC)
Date:   Sun, 17 Oct 2021 14:22:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] fix tx buffer concurrent access protection
Message-ID: <20211017122212.v47r3jl6ig7nmuiw@pengutronix.de>
References: <cover.1633764159.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="te4ulpsvjqnychhb"
Content-Disposition: inline
In-Reply-To: <cover.1633764159.git.william.xuanziyang@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--te4ulpsvjqnychhb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.10.2021 15:40:08, Ziyang Xuan wrote:
> Fix tx buffer concurrent access protection in isotp_sendmsg().
>=20
> v2:
>  - Change state of struct tpcon to u32 for cmpxchg just support 4-byte
>    and 8-byte in some architectures.
>=20
> Ziyang Xuan (2):
>   can: isotp: add result check for wait_event_interruptible()
>   can: isotp: fix tx buffer concurrent access in isotp_sendmsg()

Applied to linux-can/testing, added stable on Cc.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--te4ulpsvjqnychhb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFsFXEACgkQqclaivrt
76nlNwgAr2PaAhzQXcL1Tqr5Orb+SsglkRncI1Vmktt3bwkvfZ0IT98FBHEfISge
R8x0kp1KRCyMEb32zh1XHrd16ruEVWMMNdLbYUYWD2LITAq3cXJ82SGgtdyWjJTy
AHUXwGeHlPNmbZJOzcaUZUtKjA4glhUEQtD1wxWUJkwA34vdg2rQmDvkR2Ekqr4e
dTCQ4PQOZtWUiIxVPXIlkh1/AZR2VOvnpjuNp8TRDnstivcidz5n3hM9dw9hyXdj
uBuSw0lb4plCu+7zTWFSSGH9wiLcEJ+Yat+DebE2IMLpG5qc1BbcdXfQRr3uvSmV
F5C+PghtKVjYtDAwX4Q72xx2XhzVfA==
=Tbwa
-----END PGP SIGNATURE-----

--te4ulpsvjqnychhb--
