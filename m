Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE4310688
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhBEIVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:21:09 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39117 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhBEIVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:21:03 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l7wKg-0000N3-Q1; Fri, 05 Feb 2021 09:19:14 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:8f9f:ac65:660b:ab5f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D5C875D727A;
        Fri,  5 Feb 2021 08:19:11 +0000 (UTC)
Date:   Fri, 5 Feb 2021 09:19:11 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Xulin Sun <xulin.sun@windriver.com>
Cc:     wg@grandegger.com, dmurphy@ti.com, sriram.dash@samsung.com,
        kuba@kernel.org, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xulinsun@gmail.com
Subject: Re: [PATCH 2/2] can: m_can: m_can_class_allocate_dev(): remove
 impossible error return judgment
Message-ID: <20210205081911.4xvabbzdtkvkpplq@hardanger.blackshift.org>
References: <20210205072559.13241-1-xulin.sun@windriver.com>
 <20210205072559.13241-2-xulin.sun@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qc4ism5jczzmdofu"
Content-Disposition: inline
In-Reply-To: <20210205072559.13241-2-xulin.sun@windriver.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qc4ism5jczzmdofu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.02.2021 15:25:59, Xulin Sun wrote:
> If the previous can_net device has been successfully allocated, its
> private data structure is impossible to be empty, remove this redundant
> error return judgment. Otherwise, memory leaks for alloc_candev() will
> be triggered.

Your analysis is correct, the netdev_priv() will never fail. But how
will this trigger a mem leak on alloc_candev()? I've removed that
statement. I'll add it back, if I've missed something.

> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qc4ism5jczzmdofu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAc/3wACgkQqclaivrt
76lp7wf+NhRkk+GC8Jw8tp95kPP8BRbv03JY3AbOsFUkoyIO6FiIXKsJ3deH/Mz+
nYWq5nVAZLOxwB1leQp6VD4dAd8GUmKZ7p04MkIpG+kqo860F7FZTrIcwWkHId/M
Y7nuNOS+EffNS9Cr0pkOHNEk8CTRdx6ft4FjP9p683ZyJeAflGFL5dbz3VxiDNCO
slss4QrTnqylCgrtToI2C/0m5eWPX3Cf8ns9HkKfy57Z6gbkv6R6Yi0dcfOF8FBV
c2nLLpW/Nu9LGLqecBPvsQUkN/z2S0B3LQbWOOC7EdBgz2s27XncPv4LdaaUD08V
/qpaOKF4r/Z0ua4Q5IvleS8jj0TJyA==
=WwKn
-----END PGP SIGNATURE-----

--qc4ism5jczzmdofu--
