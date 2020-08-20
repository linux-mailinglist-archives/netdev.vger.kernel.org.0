Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4424BD89
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgHTNHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728219AbgHTNHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 09:07:21 -0400
Received: from localhost (p54b3333c.dip0.t-ipconnect.de [84.179.51.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F322B207BB;
        Thu, 20 Aug 2020 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597928840;
        bh=9T4WeDp0RYzmw5XlXp9uYtO1HytLjTO0M9v9kwsrWf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVlhYFh3XV1+TA5Oe6DIE5oEjDi94Rt10we1LK8ZozUWHc/cfLYVjjEniqZMmpRGL
         cQQOx0q8nmki/LH94WEslevVWm1QLAzs5udMYpgNoi9QdzXtTConvoGjce6mzAC+S/
         gWpulzQ8AH2xNYzOjoSTRBPMzFK7AT4GMfUBspl8=
Date:   Thu, 20 Aug 2020 15:07:08 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     kernel@pengutronix.de, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: mscan: mpc5xxx_can: update contact email
Message-ID: <20200820130707.GA11403@ninjato>
References: <20200502142657.19199-1-wsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20200502142657.19199-1-wsa@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 02, 2020 at 04:26:56PM +0200, Wolfram Sang wrote:
> The 'pengutronix' address is defunct for years. Use the proper contact
> address.
>=20
> Signed-off-by: Wolfram Sang <wsa@kernel.org>

Ping?

> ---
>  drivers/net/can/mscan/mpc5xxx_can.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/=
mpc5xxx_can.c
> index e4f4b5c9ebd6..e254e04ae257 100644
> --- a/drivers/net/can/mscan/mpc5xxx_can.c
> +++ b/drivers/net/can/mscan/mpc5xxx_can.c
> @@ -5,7 +5,7 @@
>   * Copyright (C) 2004-2005 Andrey Volkov <avolkov@varma-el.com>,
>   *                         Varma Electronics Oy
>   * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
> - * Copyright (C) 2009 Wolfram Sang, Pengutronix <w.sang@pengutronix.de>
> + * Copyright (C) 2009 Wolfram Sang, Pengutronix <kernel@pengutronix.de>
>   */
> =20
>  #include <linux/kernel.h>
> --=20
> 2.20.1
>=20

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl8+dXcACgkQFA3kzBSg
Kbbitw/9F16nwRBCNgwSGqNwxfnuj1puuUpdtbdyXSh3CwYylq50zKpHrYTd232F
qEyVjLzVCF+qfq5o9P3GkWb6jL/kAnB9GVz+jkoLxYpXpk+Z4x3hxTXo/6I3AeMm
s9wY9Svr06xrsn8hqk7K0m4LWcSTwBOH4qMAhTykf8bWsom/+mX5eLStF8FzFF9/
lmjNdZm38vZ4GAfD8INpS358dUMmKLrQ/sL5heWs8bLpwTLli+qDCFf3dHXOVr1b
bt2vNqUdk9jAIp4oc4gRxFEpWxJmLzPl7bUqb41bnUfx+ARra/iQtMiODZgmmevL
vy7tKrgH5y1Q9AFWZnyMqeCoi8NxwFS+kN7dERz/haBnocHHlzwPEcM3SfdU2A8o
4Rvo7FdEdXLROQsZWUzJaYtEN/aEyNyNGPU3HYYxZ0zjU1O7sTRlsMTbeyJXPCit
IxK77SEAZXSCP6oCwUqoZ303wAvL+YUxYU+CgKvn6nmJqj58+iN8t6z3VHA94Yyq
tybtEz6dp3qN6dhLK7LB3vT4o6H0OhVgnuBEmqFf+o6t2m5xIBNjxyCnkDBvkxBH
jHsBeUw0zynKxRt6x3zCvRZA2qL4nJ6WizyIm6uKd01fekTKTeM6NHTL91QNY+Rl
cxAIXV+esUM4psPYJ37M3je60bVX0ymkFSoXQ3XxQORTCntFmkg=
=Ucks
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
