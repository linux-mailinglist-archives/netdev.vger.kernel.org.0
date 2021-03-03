Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7AA32C416
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358485AbhCDALA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351571AbhCCKrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:47:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE09C06178B
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:36:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lHOrx-00029t-SL; Wed, 03 Mar 2021 11:36:41 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:a20d:2fb6:f2cb:982e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 75EFC5ECB4F;
        Wed,  3 Mar 2021 10:36:36 +0000 (UTC)
Date:   Wed, 3 Mar 2021 11:36:35 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210303103635.qyhej226njsymjv3@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210302184901.GD26930@x1.vandijck-laurijssen.be>
 <91394876.26757.1614759793793@mail1.libero.it>
 <20210303090036.aocqk6gp3vqnzaku@pengutronix.de>
 <1871630605.34606.1614767470294@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4qxc2r77l4axq5yy"
Content-Disposition: inline
In-Reply-To: <1871630605.34606.1614767470294@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4qxc2r77l4axq5yy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.03.2021 11:31:10, Dario Binacchi wrote:
> I think these features need to be developed in a later series.=20
> I would stay with the extension to 64 messages equally divided=20
> between reception and transmission.

Fine with me.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4qxc2r77l4axq5yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA/ZrEACgkQqclaivrt
76nM8gf+IpB/LAvj08wxFrYV8bTK0TskGmhD0tNOfLfWhv3Xcc+7Z8yVOHf6LE7p
sApSD//7DcS4U9qsxwA+lxdF7QlwghPlM9q7obdX9CPzdh6Q7VcZx+xoR+fmfL3Q
zSU9ramJgGopuAudhyrOl/26/ZAEFwU36f1a/ivo0bo7WOr3w7Cng6WF9dv13dK8
wCd99cHDK00XFQcfMRUYj6wC1uQX4tuF2c4IjN+tWqBaGZvzgzAVv+ktor2/RCkf
inqcXLrugVd/o4Wn9kks6+GKvWnAiHGaTLRYL3p/44sV0z/PZarwWo9SLqYSKr3O
UIkyOutV1ldvdf1myJvBup5UR9T1rA==
=avgB
-----END PGP SIGNATURE-----

--4qxc2r77l4axq5yy--
