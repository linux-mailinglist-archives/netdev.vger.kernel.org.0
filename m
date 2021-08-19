Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FC63F147C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhHSHqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbhHSHqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:46:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D555EC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 00:45:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGcjn-0003uQ-O5; Thu, 19 Aug 2021 09:45:19 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:5b60:c5f4:67f4:2e1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7A5A066A438;
        Thu, 19 Aug 2021 07:45:17 +0000 (UTC)
Date:   Thu, 19 Aug 2021 09:45:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/7] can: netlink: allow user to turn off unsupported
 features
Message-ID: <20210819074514.jkg7fwztzpxecrwb@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dk2dvfwdioe3ydli"
Content-Disposition: inline
In-Reply-To: <20210815033248.98111-2-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dk2dvfwdioe3ydli
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.08.2021 12:32:42, Vincent Mailhol wrote:
> The sanity checks on the control modes will reject any request related
> to an unsupported features, even turning it off.
>=20
> Example on an interface which does not support CAN-FD:
>=20
> $ ip link set can0 type can bitrate 500000 fd off
> RTNETLINK answers: Operation not supported
>=20
> This patch lets such command go through (but requests to turn on an
> unsupported feature are, of course, still denied).
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

I'm planing to send a pull request to net-next today. I want to do some
more tests with this series, but this patch is more or less unrelated,
so I can take it in this PR, should I?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dk2dvfwdioe3ydli
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEeDAgACgkQqclaivrt
76lFpQf/ZOCz9dnWOYqnnfcFlW2/u9QPd0YYYCk41MM/OBScEJKVVhPzZ22GE8ws
uy0m/Af79ojMB/Cqj2JVVSoVjnt+EKap3r7acadIBAVnYfiK6nh+dC0jgU2OzJxx
xP6DKt/Iiqg7h6WWuOBCho2rHI3RCoxVOi7AFtKsHeO+ygin8pHc7RKT4Qrflcwl
sRWlpbxum2AW7SW69mOdBrzmzwhDojw9jdxsFb/+9ERB9tKZ5EZXJlscUttfHAUx
7hVrbciKQlmMdtYBGCMBPpbpFFDr6SZYIK8dqryi3KQ28iIRH/Qe+f+bRGMJMcqi
IlooJTdPp0esm0w8Inv94JbF9FvnVQ==
=NRjs
-----END PGP SIGNATURE-----

--dk2dvfwdioe3ydli--
