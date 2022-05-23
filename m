Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C09531015
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbiEWMiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiEWMiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:38:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC374ECD1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 05:38:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nt7KY-0005ze-8S; Mon, 23 May 2022 14:38:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 65D7A844E9;
        Mon, 23 May 2022 12:38:36 +0000 (UTC)
Date:   Mon, 23 May 2022 14:38:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: peak_usb: fix typo in comment
Message-ID: <20220523123835.66rliknnve2fcvxf@pengutronix.de>
References: <20220521111145.81697-24-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6tfwm2abi6tnm2pi"
Content-Disposition: inline
In-Reply-To: <20220521111145.81697-24-Julia.Lawall@inria.fr>
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


--6tfwm2abi6tnm2pi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.05.2022 13:10:34, Julia Lawall wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6tfwm2abi6tnm2pi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKLgEkACgkQrX5LkNig
012IxQf/aRf4MSg/hFbjtTdruurxnVyu2AwYiFKbZd+ePVLX5kS6TmNhHyYgbcwX
uT0EviEdh/i0isJGE9/avs+e57qdZQfSVDRmr4wKCW4TzfJ4aGLBmZAQ75ieQPLa
hUneN+BHSuD6WZ9I2AzNLJQjmZ/CokegYRC73TPRZhhAHhO+k9qtiZ5r7xD8RTap
CrX1uylgNtBH3neHr4d2B4Pjgy52DhdBGE3HlhBr8TruqhqLS+H6DbbpM+TRFAKG
QyEmi+cCtzj1vdqr0F3AEyTdAe78stfaFKllc4Vbey/T0Tp4BpUuEqaCP3LAI3Gi
u9A6EGzJZyqji3nki1ld0JGAs3G5ZA==
=KXF5
-----END PGP SIGNATURE-----

--6tfwm2abi6tnm2pi--
