Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86537171B
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhECOy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhECOyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:54:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DC5C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 07:53:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ldZwi-0005np-TW; Mon, 03 May 2021 16:53:16 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1b0:e062:be12:b9c6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AEA9061B32F;
        Mon,  3 May 2021 14:53:10 +0000 (UTC)
Date:   Mon, 3 May 2021 16:53:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] can: mcp251xfd: fix an error pointer dereference in
 probe
Message-ID: <20210503145309.fhij36vze4d5xrte@pengutronix.de>
References: <YJANZf13Qxd5Mhr1@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uffqkjhbb2ctxi46"
Content-Disposition: inline
In-Reply-To: <YJANZf13Qxd5Mhr1@mwanda>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uffqkjhbb2ctxi46
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.05.2021 17:49:09, Dan Carpenter wrote:
> When we converted this code to use dev_err_probe() we accidentally
> removed a return.  It means that if devm_clk_get() it will lead to
> an Oops when we call clk_get_rate() on the next line.
>=20
> Fixes: cf8ee6de2543 ("can: mcp251xfd: mcp251xfd_probe(): use dev_err_prob=
e() to simplify error handling")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Good catch, found that yesterday, too, but haven't posted it here.

Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uffqkjhbb2ctxi46
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCQDlMACgkQqclaivrt
76kzcQf9HuBx3N3HU3kNHeC2hmvSIgDptYkjb2HwaKINxHVyP5uFUHgPCYDiC5RO
D9Qf4lBPSEhSyYv3V2OuNNwkjmA8qHrkitYJ2FCrfULPo3YU/FlVRLBt6xlQnInr
g3avJ5LHm3LxxF7yoDcIsrDtd5ocVWvvqI0uHCjC2WUCM92XyX+6Zb3WF2r29it1
FljJTQoEOFCZrzUDIdJHYiHxmW8ZtOo8kmtUYf++eCMHCgIjAY9KJWU6D54ojY48
P3mAW40JQGKmQK+DUb/3iooiNRaelv8pa8WbQXCBnbqCAJZDhGoU4fKB4JU/L5Kg
5heBqtMwKqpIQ7uzTiOcbZaHvjgi4Q==
=Pojn
-----END PGP SIGNATURE-----

--uffqkjhbb2ctxi46--
