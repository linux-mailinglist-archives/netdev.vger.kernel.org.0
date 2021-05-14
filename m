Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3553811EF
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhENUmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhENUmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 16:42:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55A3C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:41:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lhecK-0006lj-3Z; Fri, 14 May 2021 22:41:04 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:d2a9:f0ae:b10b:5ba5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7929A6246DB;
        Fri, 14 May 2021 20:40:59 +0000 (UTC)
Date:   Fri, 14 May 2021 22:40:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     zuoqilin1@163.com
Cc:     socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] net: Remove unnecessary variables
Message-ID: <20210514204058.lqd2gryxbfkto4ra@pengutronix.de>
References: <20210514100806.792-1-zuoqilin1@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gyij337c7zi7s5x5"
Content-Disposition: inline
In-Reply-To: <20210514100806.792-1-zuoqilin1@163.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gyij337c7zi7s5x5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.05.2021 18:08:06, zuoqilin1@163.com wrote:
> From: zuoqilin <zuoqilin@yulong.com>
>=20
> There is no need to define the variable "rate" to receive,
> just return directly.
>=20
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>

Applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gyij337c7zi7s5x5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCe4FgACgkQqclaivrt
76n23Qf/cgv1dhi3wsb0LE/7sAE/Ui1kVpBZ4FnrVb39mfj9OwlaGIw9kq+Ibfzg
BNZcFYkNh5Je/B7sEkdtLrmuITgdidzhZyfMRa8Dx21kTxD1FQL+fO2Zx45imfzn
BfvyVPrxLdypRxvrD6QyvfwI7iqPxasBXfu0Hzz9TpNSEXCs+SAn9WEYUHl6HHrn
y7T/tPQx+NxUTXM1WsuA+rNTyWG0BcLECG78ivgxtPbFNtHyfRKj4uWTReZpa3Ae
5kJCWSL77ZmhJc0cQeuH1rHJsIJLWqKVJ1EcBGwYPUdI9P5WxSGo92Bnukg66o4V
ex1yG02lzElETbg5ogIXTzRLiunO/Q==
=Ds8o
-----END PGP SIGNATURE-----

--gyij337c7zi7s5x5--
