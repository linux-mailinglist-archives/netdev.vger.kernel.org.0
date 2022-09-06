Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251865ADFD1
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiIFGcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbiIFGcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:32:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495A56B167
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:32:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVS8N-0006wF-KZ; Tue, 06 Sep 2022 08:32:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:a3ba:d49d:1749:550])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E6C53DB57C;
        Tue,  6 Sep 2022 06:32:29 +0000 (UTC)
Date:   Tue, 6 Sep 2022 08:32:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] docs: networking: device drivers: flexcan: fix invalid
 email
Message-ID: <20220906063228.evruouqqbeh737f5@pengutronix.de>
References: <20220828134442.794990-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="agwluqgtxlz3sxir"
Content-Disposition: inline
In-Reply-To: <20220828134442.794990-1-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--agwluqgtxlz3sxir
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.08.2022 15:44:42, Dario Binacchi wrote:
> The Amarula contact info email address is wrong, so fix it up to use the
> correct one.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--agwluqgtxlz3sxir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMW6XkACgkQrX5LkNig
011CewgAh/0isgB9H3tAaQXwXufKklY44Xo0Cy/VlLJYRvIpiEJPVSk9KtB51rOE
I4mzbxTuj1nA/+CfsOmXcgS4unNPQYpOpSrFxEUf1eJDZuwhh0Xq8g5eWKCIpylN
fepOmCadyLUQkgtpDZMnCWcF3LPL2w3OYrV9CCfR/POEDGo6+gUBuUEy9AmvGGL0
ELQM25x9qNNEhWHP88G+DcWxgPyGTa10fxU6zK2Yd9a0bwt2tg465ow+XpAP0hFB
d9aq4vzaSs/dbIMV6Xiu40azJ1j1Q8uLt8Vm+sUy3q+kb2jexzcnHW0YArV87Jmu
flosg9GTXLlmY26J83+vFBeAe2fslg==
=QnEP
-----END PGP SIGNATURE-----

--agwluqgtxlz3sxir--
