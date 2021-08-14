Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE8F3EC24F
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhHNLPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbhHNLPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:15:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881D5C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 04:14:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mErcW-0006nt-I0; Sat, 14 Aug 2021 13:14:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:9c12:ab28:ecb4:fe2f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DCFB56672BB;
        Sat, 14 Aug 2021 11:14:29 +0000 (UTC)
Date:   Sat, 14 Aug 2021 13:14:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
Message-ID: <20210814111428.2jivv6rbj5piqrto@pengutronix.de>
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="73h3dlf3qatldber"
Content-Disposition: inline
In-Reply-To: <20210814101728.75334-5-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--73h3dlf3qatldber
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.08.2021 19:17:28, Vincent Mailhol wrote:
>  include/uapi/linux/can/netlink.h |  30 +++++++-

IIRC, changes of the uapi headers will be pull in regularly from the
mainline kernel.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--73h3dlf3qatldber
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEXpZIACgkQqclaivrt
76kKYgf+JV/LuzN1hF+gI3ry0V34s2jMRSTFIQByzhHWHzB1Qazs7i0LGyx5hxz0
gj82ic9FwIsQEjJ+4XaBBhvAw/8j0VC2/6y1buTg28ncM5uBPxm4p9z2nIucDjLx
dne76fM7Zhk6Ck0Cjp4dxZ5Pvt5/j2PNaYdkendHRpl4/5+XJe2qXMryAYqSA0qS
p7rto3EjzOlBPOeVJ4BRrtHGyHQKNTmz5CRpxjnZ7AkZXzwbLt7nzShp6Ma5tdo0
Uf1xiz7Nd2/N+2HEpe1sZDVED2xbvpt3OavcetX7TGamg60LIaS/3S28ut9W6Vzw
ROV6s7b4Yxmb5K5uGWKZ2t4a3qHu3w==
=5Uju
-----END PGP SIGNATURE-----

--73h3dlf3qatldber--
