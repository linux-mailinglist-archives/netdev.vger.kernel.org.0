Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF9637BA9
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKXOpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiKXOpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:45:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9ACF242C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:45:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDT7-0002eW-QH; Thu, 24 Nov 2022 15:44:49 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D24DC128665;
        Thu, 24 Nov 2022 14:44:46 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:44:45 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: m_can: Add check for devm_clk_get
Message-ID: <20221124144445.edeuxa4ryzcxgkkh@pengutronix.de>
References: <20221123063651.26199-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zadcz6b2upk7mjl4"
Content-Disposition: inline
In-Reply-To: <20221123063651.26199-1-jiasheng@iscas.ac.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zadcz6b2upk7mjl4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.11.2022 14:36:51, Jiasheng Jiang wrote:
> Since the devm_clk_get may return error,
> it should be better to add check for the cdev->hclk,
> as same as cdev->cclk.
>=20
> Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Applied to linux-can.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zadcz6b2upk7mjl4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/g1oACgkQrX5LkNig
011GKQf7BR7XYcW+ucxkt3SH3QKy+EH85aPtVwFIvzH1EJ4jpMvTK7aiXPne7kUP
JYtIjuM9Zt11IRUnEdmarM8JAekwrzz+MJGlnFAohkv/cvccFZ2UZRdIFE/bAtIL
DX34tFfXzeOiVNxuIjE5jQFitX8BH10b+Sq+ku93QhAzZjFxO815k3dohh6xFCRT
eRH+Lo4uffXF6adwJcO0yoyOu/w4ADfm2DTL81MEGkSoAQZaRFavtsHZ9k5Y4YRh
hIY7UEOSHeA7By9pH/Dw/HqHarIE3fJ6HvDVwwizyoqd9aP2FJFBt5lZkSUJ3tac
UmBEKFXVzuR03t2OKzr07BAdXQAH6g==
=mv3O
-----END PGP SIGNATURE-----

--zadcz6b2upk7mjl4--
