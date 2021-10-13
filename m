Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15B442C1FA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhJMOBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhJMOBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:01:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C796CC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 06:59:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1maenF-00047v-AN; Wed, 13 Oct 2021 15:59:41 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-4e9e-60fc-b8e7-7754.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:4e9e:60fc:b8e7:7754])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 85F196924D0;
        Wed, 13 Oct 2021 13:59:39 +0000 (UTC)
Date:   Wed, 13 Oct 2021 15:59:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 05/11] can: bcm: Use hrtimer_forward_now()
Message-ID: <20211013135938.mdg3ucyjtkvfcxcu@pengutronix.de>
References: <20210923153311.225307347@linutronix.de>
 <20210923153339.684546907@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ulf5aacqnjevo763"
Content-Disposition: inline
In-Reply-To: <20210923153339.684546907@linutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ulf5aacqnjevo763
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.09.2021 18:04:27, Thomas Gleixner wrote:
> hrtimer_forward_now() provides the same functionality as the open coded
> hrimer_forward() invocation. Prepares for removal of hrtimer_forward() fr=
om
> the public interfaces.
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: linux-can@vger.kernel.org
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: netdev@vger.kernel.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>

Tnx, applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ulf5aacqnjevo763
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFm5kgACgkQqclaivrt
76ly8Af+MZpwNSBSkgu3BoHbXJM/ftEtG8NwqL4gN3XFG2q00fGFifF6cR1SZqB8
lnFWAfGMCPGla49W/6vkAg9x1QwGR74q++Z+Dj51dImt7qYTsDMoVhDS3jrSO+5b
ESnvU6e5FXZbI0bvnZCvM3ML9kxSb8vXaYUxKRBrkf4gK7dQNAl1PAAK4B3h03xf
JPV4wpZGxcxeVUEffv9PvvX9fdwVfb7szCmt8KqaxIUuH1IfM+gZGxxoiNW8YEPZ
YgixZRWjON1Y5SJ/FmEYBW3Wk/1Scyqg/Ts9LC0TQRvLJIiojQrpC4X5qDUr2P8N
3tH/WZoW99MfvlmrL8zSxRcp0sNqPQ==
=PxYX
-----END PGP SIGNATURE-----

--ulf5aacqnjevo763--
