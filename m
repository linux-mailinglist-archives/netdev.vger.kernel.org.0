Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D825ADFC6
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbiIFGaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiIFGaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:30:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA9222BF5
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:30:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVS5y-0006S3-TP; Tue, 06 Sep 2022 08:30:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:a3ba:d49d:1749:550])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C2AF9DB56C;
        Tue,  6 Sep 2022 06:30:00 +0000 (UTC)
Date:   Tue, 6 Sep 2022 08:29:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] can: etas_es58x: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <20220906062958.bevxqhg3azvkky5l@pengutronix.de>
References: <Yw00w6XRcq7B6ub6@work>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fzdtkz7rshitpii6"
Content-Disposition: inline
In-Reply-To: <Yw00w6XRcq7B6ub6@work>
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


--fzdtkz7rshitpii6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.08.2022 16:50:59, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length array
> declaration in union es58x_urb_cmd with the new DECLARE_FLEX_ARRAY()
> helper macro.
>=20
> This helper allows for a flexible-array member in a union.
>=20
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fzdtkz7rshitpii6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMW6OMACgkQrX5LkNig
010r6wf+K9aVetaGedEST1E6cBqeWfNruF0sfYhbgsJjK/8Omrpz67b5yTJZU8vH
4d6LCf9swiZlfyOg7rs5gPa5kqtlqwht9GDxW6B1JjPIIXTAw603e8kqI0JKzLo8
VJ3BPoWYy9FM/oMwtgiGTiAM+gmiXNOyCLBm+lkFbpNTXY+/kUjnttRGg5DOXQWW
Ki2LUQO/hhDis4u1Cm1fFSqkTm4rGMURufm+eVDLGN6QAiegVJ4NiF6drLzUGx23
L3wXQysf8zXzhH/r6UrxLK4PyQN3IgDo3ZGhoqM4iFLl2wta9ESN/y96NJk8MYxw
QceEIjFLM6SJlM0lXvngUt7T/fSRvQ==
=JFZH
-----END PGP SIGNATURE-----

--fzdtkz7rshitpii6--
