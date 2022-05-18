Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35B452B964
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbiERMMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiERMMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:12:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D159514ACA1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:12:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrIXT-0003wh-SJ; Wed, 18 May 2022 14:12:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C627681373;
        Wed, 18 May 2022 12:12:26 +0000 (UTC)
Date:   Wed, 18 May 2022 14:12:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Max Staudt <max@enpas.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Device Drivers: (was: Re: [PATCH v3 3/4] can: skb:: move
 can_dropped_invalid_skb and can_skb_headroom_valid to skb.c)
Message-ID: <20220518121226.inixzcttub6iuwll@pengutronix.de>
References: <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3kuiw7eefpz5cmyt"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
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


--3kuiw7eefpz5cmyt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.05.2022 21:03:37, Vincent MAILHOL wrote:
> On a different topic, why are all the CAN devices
> under "Networking support" and not "Device Drivers" in menuconfig
> like everything else? Would it make sense to move our devices
> under the "Device Drivers" section?

ACK

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3kuiw7eefpz5cmyt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKE4qcACgkQrX5LkNig
012uAwf+LE2AN6s/mYbZjNau8v96x1hj/9QBlr0QTmKGAt9UN0QPqms3zhapK2C0
8s0SKtEykDR/6gx9OyIDeQWQbQqf07R/iX0amf7OXnE4TPSx56p3pYk85MCXPoX4
KWoGcTZSBLFV9Sim+yfs6JaXak1L6mejyWQDz8VqqOx2dpuTgrPETQaGe43Sfh7+
FH4cIvzhEncq6UpzTpV95hCkv0pqykrhaD4K3Edy8Ay2uBi8ojw1oX5fP2PR5BLu
SgqJHj+7isGkwRJWgcaYlGBk6jeDsewb5t2UCF+Gt7B4D8ODh8YTSUH7KQwAH+3Q
bONELRwrsSPNcQqaX/63QyjA7MOiDw==
=tKnl
-----END PGP SIGNATURE-----

--3kuiw7eefpz5cmyt--
