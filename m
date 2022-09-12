Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AB45B59E0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiILMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiILMCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:02:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D673E75B
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:02:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXi8p-0000HU-5f; Mon, 12 Sep 2022 14:02:19 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9A554E12F5;
        Mon, 12 Sep 2022 12:02:18 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:02:10 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, edumazet@google.com,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] can: bcm: check the result of can_send() in
 bcm_can_tx()
Message-ID: <20220912120210.6oc4tbb7xjxhjihc@pengutronix.de>
References: <cover.1662606045.git.william.xuanziyang@huawei.com>
 <5c0f2f1bd1dc7bbb9500afd4273e36378e00a35d.1662606045.git.william.xuanziyang@huawei.com>
 <1caf3e52-c862-e702-c833-153f130b790a@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rnwntybvven35lb2"
Content-Disposition: inline
In-Reply-To: <1caf3e52-c862-e702-c833-153f130b790a@hartkopp.net>
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


--rnwntybvven35lb2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.09.2022 08:47:57, Oliver Hartkopp wrote:
> Sorry, but NACK.
>=20
> The curr_frame counter handles the sequence counter of multiplex messages.
>=20
> Even when this single send attempt failed the curr_frame counter has to
> continue.
>=20
> For that reason the comment about statistics *before* the curr_frame++ mi=
ght
> be misleading.
>=20
> A potential improvement could be:
>=20
> 	if (!(can_send(skb, 1)))

Nitpick:
In the kernel we usually assign the return value to a variable first,
and evaluate this variable in the if ().

> 		op->frames_abs++;
>=20
> 	op->currframe++;

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rnwntybvven35lb2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfH78ACgkQrX5LkNig
011kxwgAqOqSIZx3uPc8Kfl3nqztqUiLqG9DrtssBRQfFziA8lBSlDwcOip3QywP
1VApIpOCREvpcVeIOqW8Iz8O+3Uo90Do2GXPSh+aciJo/PgSjnKFb69iwMHV5SI6
2lSXs56tAGjIHKESrIQUpCIaYmDHJZIPjHY/NEh1nk9gR3X/lH1+w9ts2XJJ+v9w
suTw/v1DneHJSmdIaCj+UgiZiLl64rTWjv4BwIDibavSkunvo5sc0o9QHiH8HnB9
KFd8kBkcSMR5JhWay/J4RPo2KtMnlFy7vPEh2whyx7Kz5FRi8HY0pr1H0AQ2SUOk
jqq4J6cSwerwHBplJDZIdCyfjcGkYw==
=oJz8
-----END PGP SIGNATURE-----

--rnwntybvven35lb2--
