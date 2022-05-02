Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCD7516B55
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 09:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359499AbiEBHje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 03:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383683AbiEBHj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 03:39:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F88F63FA
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:35:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQaw-0000J8-0H; Mon, 02 May 2022 09:35:46 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-dbb7-8e81-d7fe-7589.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:dbb7:8e81:d7fe:7589])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C7A3B72DEE;
        Mon,  2 May 2022 07:35:44 +0000 (UTC)
Date:   Mon, 2 May 2022 09:35:44 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Andrew Dennison <andrew.dennison@motec.com.au>
Subject: Re: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual
 rules and documentation linking
Message-ID: <20220502073544.yr4qo7udyxpzgmam@pengutronix.de>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
 <20220428072239.kfgtu2bfcud6tetc@pengutronix.de>
 <202204292331.28980.pisa@cmp.felk.cvut.cz>
 <20220502072151.j6nx5kddqxeyfy3h@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3h3n53twihjnxtpi"
Content-Disposition: inline
In-Reply-To: <20220502072151.j6nx5kddqxeyfy3h@pengutronix.de>
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


--3h3n53twihjnxtpi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.05.2022 09:21:51, Marc Kleine-Budde wrote:
> On 29.04.2022 23:31:28, Pavel Pisa wrote:
> > > Split into separate patches and applied.
> >=20
> > Excuse me for late reply and thanks much for split to preferred
> > form. Matej Vasilevski has tested updated linux-can-next testing
> > on Xilinx Zynq 7000 based MZ_APO board and used it with his
> > patches to do proceed next round of testing of Jan Charvat's NuttX
> > TWAI (CAN) driver on ESP32C3. We plan that CTU CAN FD timestamping
> > will be send for RFC/discussion soon.
>=20
> Sounds good!

Please make use of struct cyclecounter/struct timecounter if needed,
e.g.:

| https://elixir.bootlin.com/linux/v5.18-rc5/source/drivers/net/can/spi/mcp=
251xfd/mcp251xfd-timestamp.c

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3h3n53twihjnxtpi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJvic4ACgkQrX5LkNig
013BAAf/dARabT4u19tDXwz0EG2eFwLH2LqQwNvZ+Mzay7mzgzglGwVx/Ywua89i
IQ2m8jZbGZnKTjwdcSWxstyMa/y4B0KdVyuPrGicjMOjsY+0aTY9T+TFNInu4F+5
T5cYfpQnhWgJM5AXpvcTH4iuaLNsJqNJ/0L2o1XZPGCcfpLdm9Nfohib9k9yHOdu
DF9lvjikLcxXzQf0DvHwcUpM7ze+Lqb47sflVB5DCpfKiWEx7EwQVScrkjNUI0U0
+PDgTWJi1J/jytBbo2rrYSJ4BS+A4bFOitM3XNudCAdqqZsJv7twi7XQSheo5AAN
p9lZV4QAiMZAenxtulGPmaXcSDV3uQ==
=atus
-----END PGP SIGNATURE-----

--3h3n53twihjnxtpi--
