Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2CE46CFE7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 10:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhLHJTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 04:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhLHJTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 04:19:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24FBC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 01:16:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mut3W-0002pZ-6Q; Wed, 08 Dec 2021 10:16:06 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-e45e-c028-b01c-c307.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e45e:c028:b01c:c307])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 25BA16BF98E;
        Wed,  8 Dec 2021 09:16:04 +0000 (UTC)
Date:   Wed, 8 Dec 2021 10:16:03 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Jimmy Assarsson <extja@kvaser.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH v5 0/5] fix statistics and payload issues for error
Message-ID: <20211208091603.hg7pqm6stnppgfr2@pengutronix.de>
References: <20211207121531.42941-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="intcjf25qocp5gxe"
Content-Disposition: inline
In-Reply-To: <20211207121531.42941-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--intcjf25qocp5gxe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.12.2021 21:15:26, Vincent Mailhol wrote:
> Important: this patch series depends on below patch:
> https://lore.kernel.org/linux-can/20211123111654.621610-1-mailhol.vincent=
@wanadoo.fr/T/#u

This series will go into net-next/master, I'll wait until net/master
(which includes the above mentioned patch) is merged into
net-next/master.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--intcjf25qocp5gxe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGwd9AACgkQqclaivrt
76kePAgAiD47E4+0+PgjYIfKfgPkhWW6YB4tkOdih+ExgEkz0cnQPiS1BenGDxgg
7LmsWhgOXWucJacHnQ+FlSdx7yVWxeGGpMqcJVQwS+E2iDRnYXLG/T4jLcQuGBC9
KyO1Oidg/r/CKQsH7flaIweZ5kfU7t1nywPXCRGHSipME0/HoDGrb9G5o0M+E2lO
oTjcJ1Md2EWycA+wXHCyvExHEoskR9cXQeRHQc3x25ZJXpsthGjD/sH/K1vvDCFS
t9h7mBUtc59LhygL8lk2V0V110pGF6mJ07h6wN2m63I3VySyz2Kt45wCwORj8PjP
c5bzCxv3QG1y6bD0POx+B1zos5PM3Q==
=ompj
-----END PGP SIGNATURE-----

--intcjf25qocp5gxe--
