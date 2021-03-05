Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2588732E741
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 12:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCELc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 06:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCELc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 06:32:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC5CC061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 03:32:27 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lI8gk-0004qL-UY; Fri, 05 Mar 2021 12:32:10 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lI8gi-0002hy-Gg; Fri, 05 Mar 2021 12:32:08 +0100
Date:   Fri, 5 Mar 2021 12:32:08 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: c_can: move runtime PM enable/disable to
 c_can_platform
Message-ID: <20210305113208.3wm6fvqeunut2yci@pengutronix.de>
References: <20210301150840.mqngl7og46o3nxjb@pengutronix.de>
 <20210302025542.987600-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tedc23qcg7ntrk2r"
Content-Disposition: inline
In-Reply-To: <20210302025542.987600-1-ztong0001@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tedc23qcg7ntrk2r
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 01, 2021 at 09:55:40PM -0500, Tong Zhang wrote:
> Currently doing modprobe c_can_pci will make kernel complain
> "Unbalanced pm_runtime_enable!", this is caused by pm_runtime_enable()
> called before pm is initialized.
> This fix is similar to 227619c3ff7c, move those pm_enable/disable code to
> c_can_platform.

I can confirm this makes the warning go away on a Congatec Atom board. I
didn't do any further runtime tests.

Tested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--tedc23qcg7ntrk2r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmBCFrUACgkQwfwUeK3K
7AkanQf9G3uCIVa8WjFfyEnHR5Odw85asNQY6UqEntHOLnR5zslZrVtjknyTXj4I
O5tWJ1mB4l5n4Aqje5lHIHKTrkW8bx4kGBfAl94YxfPK6hjDlLivmL/SjHJB1C+t
UUBuVLAu23ay580qX7YRcOIh3PTK+URXQcZwQCu3TlVe4s3SUl+fMKU8CeKVpvEr
q03UFaTgoM5rVKqg54zI9V+NkHJHcABw/fCxsXo204ZLSeCJckjxHvNWSG1uPlvZ
9BaGRMYn87+bMOdMOAEFtz85WagHS9fKl/BW2FeOCY/1q+dcJJSKUkr5RWr2qyHD
Wb/nFrcn1fgjNYASlbFEO3glnLiBWw==
=yGiz
-----END PGP SIGNATURE-----

--tedc23qcg7ntrk2r--
