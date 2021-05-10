Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95DF378FB9
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhEJNxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243349AbhEJNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:46:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77DAC061343
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:29:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lg5xz-0001Ay-Gx; Mon, 10 May 2021 15:28:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:80ab:77d5:ac71:3f91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 25AAE6215A7;
        Mon, 10 May 2021 13:28:55 +0000 (UTC)
Date:   Mon, 10 May 2021 15:28:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] can: c_can: add ethtool support
Message-ID: <20210510132854.mrqag7vjzqdvfh7j@pengutronix.de>
References: <20210509124309.30024-1-dariobin@libero.it>
 <20210509124309.30024-3-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ombjtqvc7trra5hf"
Content-Disposition: inline
In-Reply-To: <20210509124309.30024-3-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ombjtqvc7trra5hf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.05.2021 14:43:08, Dario Binacchi wrote:
> With commit 132f2d45fb23 ("can: c_can: add support to 64 message objects")
> the number of message objects used for reception / transmission depends
> on FIFO size.
> The ethtools API support allows you to retrieve this info. Driver info
> has been added too.

> +static const struct ethtool_ops c_can_ethtool_ops =3D {
> +	.get_drvinfo =3D c_can_get_drvinfo,
> +	.get_channels =3D c_can_get_channels,
> +};

I think you're filling the wrong information here. I think channels is
for independent RX/TX channels. I think you want to implement
get_ringparam.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ombjtqvc7trra5hf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCZNRMACgkQqclaivrt
76lfqAf9HARu8Ohru3bnD+mX1WDpmANN9GJkTmFclbth4mZR1+g6Y7TabDYnSzPK
hSmf5Q90pg/M7of+r8//chVZ9s9wTwJg7vh0ZPJfS2C7GzPMTpV2BoDrV0J5Tj8i
qIappCKonVowqiODLp+9yGwB3W91uiFjWPzcqo6fU8gEdvCHUpp1tvSy2OqGyTwQ
zcIaLCQ+cJPIMaaaZXi6XSTIxv2SYo/aqepuLu+iNu7/GaoR7jr+R4L7gzTEuADb
mYyrC6fpEa2S6O35oHnasGujAob2r9LeMm9obMX6/jK/HINdTOn929vlwXippx+w
oSe/9yrBVBAImSRaktpIu6EyBmBM3Q==
=qxxQ
-----END PGP SIGNATURE-----

--ombjtqvc7trra5hf--
