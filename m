Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88938367C77
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhDVIZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhDVIZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 04:25:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0ECC06138B
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 01:25:05 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lZUdz-0000jT-Oc; Thu, 22 Apr 2021 10:25:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:621c:4946:3355:86a4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A1BA5613930;
        Thu, 22 Apr 2021 08:25:02 +0000 (UTC)
Date:   Thu, 22 Apr 2021 10:25:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Daniel =?utf-8?B?R2zDtmNrbmVy?= <dg@emlix.com>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: Softirq error with mcp251xfd driver
Message-ID: <20210422082501.mvi5x6seiokglf4e@pengutronix.de>
References: <20210310064626.GA11893@homes.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pwalfuj3rnpezbql"
Content-Disposition: inline
In-Reply-To: <20210310064626.GA11893@homes.emlix.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pwalfuj3rnpezbql
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.03.2021 07:46:26, Daniel Gl=C3=B6ckner wrote:
> Hi,
>=20
> the mcp251xfd driver uses a threaded irq handler to queue skbs with the
> can_rx_offload_* helpers. I get the following error on every packet until
> the rate limit kicks in:
>=20
> NOHZ tick-stop error: Non-RCU local softirq work is pending, handler
> #08!!!

FYI:

echo 1 > /sys/class/net/can0/threaded

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pwalfuj3rnpezbql
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCBMtsACgkQqclaivrt
76kHFwgArWeDl80non1JVFQMICOkPLGBeGX4Vs6cuxnf0uZOEJV1ZDbHzFwpzcd8
lKcEjns/uEialSe7agov5XQHPbLB2iqyAA8uAPtlkFCUml/T8KsXBTw2aNsV6Ss0
+Q5sabQnVHCbVYRgR9POiQVHXWFMGw45dyA46tRCGbo8e8P3Ufo9GQYzM74GbGqE
wuY4ervyoGkCFkyfAPgWiRU1XXFihiMvsji1MorRuSl3TMzGul0HuYMp9t3fPiZ4
a+wpfKiiLvCYCPYjNglGBeWTQDA+BDxsd0CK6N4rlYy1elkSfAMU+B+VyXgVepEA
bEaiCF2UINuYeVdfiLLSJgzS88c4kQ==
=gbye
-----END PGP SIGNATURE-----

--pwalfuj3rnpezbql--
