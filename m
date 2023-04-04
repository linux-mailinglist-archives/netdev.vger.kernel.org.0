Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7146D5EF5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbjDDL2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbjDDL2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:28:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884581FF5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:28:41 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pjepm-00043P-Ln; Tue, 04 Apr 2023 13:28:18 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 42D791A6300;
        Tue,  4 Apr 2023 11:28:13 +0000 (UTC)
Date:   Tue, 4 Apr 2023 13:28:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [PATCH v10 0/5] can: bxcan: add support for ST bxCAN controller
Message-ID: <20230404-postage-handprint-efdb77646082@pengutronix.de>
References: <20230328073328.3949796-1-dario.binacchi@amarulasolutions.com>
 <20230328084710.jnrwvydewx3atxti@pengutronix.de>
 <CABGWkvq0gOMw2J9GpLS=w+qg-3xhAst6KN9kvCuZnV9bSBJ3CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vrolgxtwhc7crda5"
Content-Disposition: inline
In-Reply-To: <CABGWkvq0gOMw2J9GpLS=w+qg-3xhAst6KN9kvCuZnV9bSBJ3CA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vrolgxtwhc7crda5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.03.2023 11:28:59, Dario Binacchi wrote:
> > Applied to linux-can-next.
>=20
> Just one last question: To test this series, as described in the cover
> letter, I could not use the iproute2 package since the microcontroller
> is without MMU. I then extended busybox for the ip link command. I
> actually also added the rtnl-link-can.c application to the libmnl
> library. So now I find myself with two applications that have been
> useful to me for this type of use case.
>=20
> Did I do useless work because I could use other tools?

systemd-networkd also supports CAN configuration, but I this will
probably not work on no-MMU systemd, too.

Then there is:

| https://git.pengutronix.de/cgit/tools/canutils
| https://git.pengutronix.de/cgit/tools/libsocketcan

that contains canconfig, but it lacks CAN-FD support.

> If instead the tools for this use case are missing, what do you think
> is better to do? Submit to their respective repos or add this
> functionality to another project that I haven't considered ?

Yes, go ahead and upstream your changes!

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--vrolgxtwhc7crda5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQsCckACgkQvlAcSiqK
BOiwvQf/bknW5120duEvKB4vzq6g1FE4pHri1PUIfK32NY2ZntW/rs/zYYH5KMTC
A3DRsT4CsHVSXNDvW7JNgHJIxIZ8kFQGiAIfOv/a7OOYXZocvfBMW9yxgRqDlese
N9BqaRggCBDhP829laPpXYntgW6k8lTMpWI7C6ANyis9tbKJ68Ut0d7bZ4eiYGme
+R4neMSudT1l+tzSobkBpDrXloivl9uXhme25xmFTtQeokwCaXSZ7CFDpNcTV2zw
3wq4YYs3fnoxUbIauVk4mDGyoJTB0ZzDee5Kp8+ucH1+eukInkeHk37RerOpc4Wv
Gl61KK/5ijUZNnIHiOJIS9C8Sv6kSQ==
=L7qt
-----END PGP SIGNATURE-----

--vrolgxtwhc7crda5--
