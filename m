Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F023F64B672
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 14:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiLMNjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 08:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiLMNjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 08:39:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A272BE
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 05:39:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p55Ul-0005G3-Gf; Tue, 13 Dec 2022 14:38:55 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:7718:f6d6:39bc:6089])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 751B613DE93;
        Tue, 13 Dec 2022 13:38:53 +0000 (UTC)
Date:   Tue, 13 Dec 2022 14:38:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     haibo.chen@nxp.com
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH] can: flexcan: avoid unbalanced pm_runtime_enable warning
Message-ID: <20221213133847.cm2qzzymdb6t4njm@pengutronix.de>
References: <20221213094351.3023858-1-haibo.chen@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qhhbnn5cffyxdz4f"
Content-Disposition: inline
In-Reply-To: <20221213094351.3023858-1-haibo.chen@nxp.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qhhbnn5cffyxdz4f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.12.2022 17:43:51, haibo.chen@nxp.com wrote:
> From: Haibo Chen <haibo.chen@nxp.com>
>=20
> When do suspend/resume, meet the following warning message:
> [   30.028336] flexcan 425b0000.can: Unbalanced pm_runtime_enable!
>=20
> Balance the pm_runtime_force_suspend() and pm_runtime_force_resume().
>=20
> Fixes: 8cb53b485f18 ("can: flexcan: add auto stop mode for IMX93 to suppo=
rt wakeup")
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>

Looks good. Applied to linux-can-next.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qhhbnn5cffyxdz4f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOYgGUACgkQrX5LkNig
010nxAf+NjBJ+1wRVVVJ37nm2cK+BlXmFrC/hOi/0Nr4dgjBsBgyljqUvnNyKceB
1JpcjNCyX9eqWFcKpvC4dOSWg5n99jPeDEcJVwK2EiR647LxrJ5DlEElq+vKuaZ6
N7+TabuaRwTxPFsPsgqNuyiZi6vBNm6MJobH0Wf9iEihiWqRxAIEqeL/yXjHovuu
rN7lawEvNG8HDfpzNbHuNhdwgojsYWiQ65mmeDBr6s8pUqgq1GX4xLJq+ETuBhup
uWOItTINoV2WLEvONYOzeZsnBJ7MVIHlU/zlEI4GJIRQoU5eM6hZPthechyonEQ1
y4I2FQD+/IGzjUA+SgQnNkx8SoFFDg==
=azsO
-----END PGP SIGNATURE-----

--qhhbnn5cffyxdz4f--
