Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7E16CB9C9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjC1Irr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjC1Irq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:47:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891804C04
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:47:44 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ph4z7-00020w-1P; Tue, 28 Mar 2023 10:47:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EB51019E085;
        Tue, 28 Mar 2023 08:47:11 +0000 (UTC)
Date:   Tue, 28 Mar 2023 10:47:10 +0200
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
Message-ID: <20230328084710.jnrwvydewx3atxti@pengutronix.de>
References: <20230328073328.3949796-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jrabto3ooziwdlnq"
Content-Disposition: inline
In-Reply-To: <20230328073328.3949796-1-dario.binacchi@amarulasolutions.com>
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


--jrabto3ooziwdlnq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.03.2023 09:33:23, Dario Binacchi wrote:
> The series adds support for the basic extended CAN controller (bxCAN)
> found in many low- to middle-end STM32 SoCs.
>=20
> The driver has been tested on the stm32f469i-discovery board with a
> kernel version 5.19.0-rc2 in loopback + silent mode:
>=20
> ip link set can0 type can bitrate 125000 loopback on listen-only on
> ip link set up can0
> candump can0 -L &
> cansend can0 300#AC.AB.AD.AE.75.49.AD.D1
>=20
> For uboot and kernel compilation, as well as for rootfs creation I used
> buildroot:
>=20
> make stm32f469_disco_sd_defconfig
> make
>=20
> but I had to patch can-utils and busybox as can-utils and iproute are
> not compiled for MMU-less microcotrollers. In the case of can-utils,
> replacing the calls to fork() with vfork(), I was able to compile the
> package with working candump and cansend applications, while in the
> case of iproute, I ran into more than one problem and finally I decided
> to extend busybox's ip link command for CAN-type devices. I'm still
> wondering if it was really necessary, but this way I was able to test
> the driver.

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jrabto3ooziwdlnq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQiqYsACgkQvlAcSiqK
BOgCXAf+NWJnGcM64I8QZW2GZ+4p1b5BV4hNDu4ehwwXOtajDqX0icFMJ+ADogBm
1OPOaNIWM5FLmL8Psn9S2O7DIH30kTJub7X58xxQl2vw9AVvg2ufgXFsrWrNcbR0
7lrbOzY4ghA7jXXWu7bya2sZ2OPp4xvF4zJRHF1axJ9Y4mWZ5UUomyhMc2It6nNV
MImbzZWnuFBLQxbUXefUz0CgEMCdi8N1hpJ2rHkNR0LPTVIGFDLtxBkj7rsvn/nj
eG2Q6WVQEFz/BWdc2e0xMjbvH5cWfp+tDDhh8UAwjSzUFCHm9sbZsXQQ5+j1S2kh
y2zuT0AX2HJPn+sJLsz9wM8SsswTmQ==
=7WBc
-----END PGP SIGNATURE-----

--jrabto3ooziwdlnq--
