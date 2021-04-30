Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62D136FC46
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhD3OXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhD3OXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 10:23:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145EEC06138F
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 07:22:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lcU1w-000541-EV; Fri, 30 Apr 2021 16:22:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:454b:889d:aa6e:bca6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E0D97619D4C;
        Fri, 30 Apr 2021 14:22:04 +0000 (UTC)
Date:   Fri, 30 Apr 2021 16:22:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: softing: Remove redundant variable ptr
Message-ID: <20210430142204.ifru27tgwweslnpa@pengutronix.de>
References: <1619520767-80948-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="exo2uog6yox3ifuk"
Content-Disposition: inline
In-Reply-To: <1619520767-80948-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--exo2uog6yox3ifuk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.04.2021 18:52:47, Jiapeng Chong wrote:
> The value stored to ptr in the calculations this patch removes is not
> used, so the calculation and the assignment can be removed.
>=20
> Cleans up the following clang-analyzer warning:
>=20
> drivers/net/can/softing/softing_main.c:279:3: warning: Value stored to
> 'ptr' is never read [clang-analyzer-deadcode.DeadStores].
>=20
> drivers/net/can/softing/softing_main.c:242:3: warning: Value stored to
> 'ptr' is never read [clang-analyzer-deadcode.DeadStores].
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   -Make the commit message more clearer.

Thanks - Applied to linux-can-next/testing

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--exo2uog6yox3ifuk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCMEokACgkQqclaivrt
76lfHAf/dGek2dTPwb8VhTajGZouFH7CNtizPxXa69GZb6Y/Ts/c/mn1Unkf+ZnH
97etDra6fZtv2Zdo/+G//RlFcwBLl3pi3hgsZn/AEA5mop9GHRFwocIAcf+RAPwL
RMRM2f6ifym5r7BihVqYcMAAwj9hpN/rjU2lsrCAC/9Y4XOkxZxIYE7ldmTxPqEV
Llu5kviEJ4u+KEW2bJNWM4bTN0q3uisQN0jTRTjqRE1YOtDd+vmPhxkJWn7RmRpX
S1mSd/gG2VSjNKgMsQrJ45i9OniYUUiyKwJFsXq157O63rd1zxL36wclq2xcHQaw
5G0CQXbWazkR7ntz/43ianv2z645Og==
=6wV2
-----END PGP SIGNATURE-----

--exo2uog6yox3ifuk--
