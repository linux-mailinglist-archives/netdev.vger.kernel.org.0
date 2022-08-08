Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD8558C484
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiHHH5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242061AbiHHH5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:57:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33A613D73
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:57:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oKxdm-000065-Br; Mon, 08 Aug 2022 09:57:34 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E59C9C45B4;
        Mon,  8 Aug 2022 07:57:32 +0000 (UTC)
Date:   Mon, 8 Aug 2022 09:57:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: rcar_canfd: Use dev_err_probe() to simplify code
 and better handle -EPROBE_DEFER
Message-ID: <20220808075732.gue3p4d5lhsa4sse@pengutronix.de>
References: <f5bf0b8f757bd3bc9b391094ece3548cc2f96456.1659858686.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sbokewfw5xtt5aba"
Content-Disposition: inline
In-Reply-To: <f5bf0b8f757bd3bc9b391094ece3548cc2f96456.1659858686.git.christophe.jaillet@wanadoo.fr>
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


--sbokewfw5xtt5aba
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.08.2022 09:52:11, Christophe JAILLET wrote:
> devm_clk_get() can return -EPROBE_DEFER, so use dev_err_probe() instead of
> dev_err() in order to be less verbose in the log.
>=20
> This also saves a few LoC.
>=20
> While at it, turn a "goto fail_dev;" at the beginning of the function into
> a direct return in order to avoid mixing goto and return, which looks
> spurious.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Added to can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--sbokewfw5xtt5aba
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLwweoACgkQrX5LkNig
012yDgf/VDv2f0dcYbhTF4sZWOuz4JarIS/2huEEeU7inNy2gjqWXvlWV5WLDrSP
FfZYXJWFl/RDOERfC0mi3AGHMghOA9WAkkXgZEpz/9edR3yF94TWvHmQkRIBYYvg
wiRR4O6VaSRfbW+2bHf9aROEx5xczf+jszHmmlZcqQpM9oTUqOxZiwg2KKQVM9oL
fM9orCR8kGetnbE6B0AsDf2HulQNWkjMqA+AiSM/QwxvG3XlvfCD/QG5/wGXns0s
FTNEyP6sf9iNfhiFFquKEbxv9JBOEV6Tar9Q5Xs7M3w0dfwbVYOiZ0lTT8Hkt8q2
hTvTcuS7m/0miL8xZvIBymTW7iz7Zg==
=IjJ6
-----END PGP SIGNATURE-----

--sbokewfw5xtt5aba--
