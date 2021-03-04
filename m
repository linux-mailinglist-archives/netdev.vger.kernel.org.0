Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDD032D565
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 15:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCDOfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 09:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhCDOfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 09:35:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F55C06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 06:34:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lHp37-0003ae-2R; Thu, 04 Mar 2021 15:33:57 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3b3:61f5:ff65:ce3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CAB235EDC4E;
        Thu,  4 Mar 2021 14:33:51 +0000 (UTC)
Date:   Thu, 4 Mar 2021 15:33:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/6] can: c_can: add support to 64 message objects
Message-ID: <20210304143350.7vddiwb7slghuvhb@pengutronix.de>
References: <20210302215435.18286-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mew7tbg2zbjzh4dd"
Content-Disposition: inline
In-Reply-To: <20210302215435.18286-1-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mew7tbg2zbjzh4dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.03.2021 22:54:29, Dario Binacchi wrote:
>=20
> The D_CAN controller supports up to 128 messages. Until now the driver
> only managed 32 messages although Sitara processors and DRA7 SOC can
> handle 64.
>=20
> The series was tested on a beaglebone board.
>=20
> Note:
> I have not changed the type of tx_field (belonging to the c_can_priv
> structure) to atomic64_t because I think the atomic_t type has size
> of at least 32 bits on x86 and arm, which is enough to handle 64
> messages.
> http://marc.info/?l=3Dlinux-can&m=3D139746476821294&w=3D2 reports the res=
ults
> of tests performed just on x86 and arm architectures.

Applied to linux-can-next/testing.

I've added some cleanup patches to the series. I'll send it around soon,
please test.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mew7tbg2zbjzh4dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBA78wACgkQqclaivrt
76ljZAgAseVI7B24JPuI6qKYxxc0qy4xsQeQM/4OYXK/pziAHW7soRQrZvpnuIvg
+yWPtqaWjHT5TVK0HH6PTUPGRBWZemAgJdcgP/QgC4ETTbyjEdJw2N2aGhrS8PGF
F6rBddSgUWCaF1JL7xrUKi1R/x5amHfGQrYnadAk3fMISb8mZ906chxCev1omXlP
ZSM0gqCORls/s2F07kHoHQgyeR65oTVV5twUudwtxebBB35Ll4rBDbO1jC2Zr6YN
J3ib6iKz7Q6kgGrQTZ2iOacu9O3KiSrbHGHnvKID2B9De0b+ynxfN05rzHlHwmhr
jXh99FbVRSIaYnqpSQCPLYLoUWIa1g==
=1bZI
-----END PGP SIGNATURE-----

--mew7tbg2zbjzh4dd--
