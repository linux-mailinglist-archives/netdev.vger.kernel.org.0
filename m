Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43400433244
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhJSJeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 05:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhJSJeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 05:34:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDCEC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 02:31:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mclTH-0005zA-7A; Tue, 19 Oct 2021 11:31:47 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-6267-dd6f-bd00-49b6.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:6267:dd6f:bd00:49b6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 49884697F8B;
        Tue, 19 Oct 2021 09:31:44 +0000 (UTC)
Date:   Tue, 19 Oct 2021 11:31:43 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mscan: mpc5xxx_can: Make use of the helper function
 dev_err_probe()
Message-ID: <20211019093143.2cmc4ft755fu2ou5@pengutronix.de>
References: <20210915145726.7092-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z5bbuhray6wmbnlw"
Content-Disposition: inline
In-Reply-To: <20210915145726.7092-1-caihuoqing@baidu.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--z5bbuhray6wmbnlw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.09.2021 22:57:25, Cai Huoqing wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
>=20
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--z5bbuhray6wmbnlw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFukHwACgkQqclaivrt
76lP4wgAm1KRGmS9M+MjK6tmtI5Fp7BYKt/SpQbQQwvtuGSqdY4RwIX+Mayfq/TO
hrhHzjQ3ecdH03A1bjl7W5QTMyxBGoMFWXnyNl0NgX+8aGaWOzO3DXdThuXNubgk
YKHa/pmBM4nlwpKvvp4EuFZQVDkmQf7oQFlaciaWhv8UX9SfjThNmhEbbmRwRbru
+aPQc6Vpi+mFVkqL9dDnChVIk8qDEI/QAny1pRVnGzG+0TdEiLJVNYcoULYvTS5s
UgrKyUDsyWVGZdOXwKPabfoCxgt+ar/D4lVLBdxcgZuvg5Y4iq0nQJH/0MLpJB2g
CaFJbOR0xoyoPoiXkdR4xM6nVDxNfA==
=phmZ
-----END PGP SIGNATURE-----

--z5bbuhray6wmbnlw--
