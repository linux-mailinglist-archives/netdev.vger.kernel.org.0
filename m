Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E0B637BAC
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiKXOpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKXOpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:45:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05079EC09E
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:45:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDTu-0002tY-0V; Thu, 24 Nov 2022 15:45:38 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D20CF12867C;
        Thu, 24 Nov 2022 14:45:33 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:45:32 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     yashi@spacecubics.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mailhol.vincent@wanadoo.fr, stefan.maetje@esd.eu,
        socketcan@hartkopp.net, hbh25y@gmail.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcba_usb: fix potential resource leak in
 mcba_usb_xmit_cmd()
Message-ID: <20221124144532.6u3hnvb6b2ninlxy@pengutronix.de>
References: <20221120101414.6071-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kd4a5kaznfiyppsu"
Content-Disposition: inline
In-Reply-To: <20221120101414.6071-1-niejianglei2021@163.com>
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


--kd4a5kaznfiyppsu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.11.2022 18:14:14, Jianglei Nie wrote:
> mcba_usb_xmit_cmd() gets free ctx by mcba_usb_get_free_ctx(). When
> mcba_usb_xmit() fails, the ctx should be freed with mcba_usb_free_ctx()
> like mcba_usb_start_xmit() does in label "xmit_failed" to avoid potential
> resource leak.
>=20
> Fix it by calling mcba_usb_free_ctx() when mcba_usb_xmit() fails.
>=20
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Applied to linux-can.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kd4a5kaznfiyppsu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/g4kACgkQrX5LkNig
010q9wgAsGR/W7WPpvudvy/7dkjbwq2fVAQGbS68F1LyfZeISBI80NaWc1PMF1lj
J329herD+T+wmhrT7WIYAXjjiSXg1P3eGdNTk3Xe7vnbKoFcmTRIHZ8cKBfyi6zP
bf0Nu3MHfoTwi642VHmm97ZH0+qdQ5mB2f0Q9+k2+Y19lBC+lGvy7op4635krQ9t
egdwUw1XnbaLFN6k8xUxVW1y36401ZMvicC/LwGVqdKk7pclYbzHdhTZ7oGP2uW3
vFrtfhsrPNK8/S3TWGmB2bIMcWF0VAHLjXIsPSCCSYxbjHzUEvjtrhjya4Boltlr
fVwu7Rxi/lDoBViwe5oo1yXbLHYy9g==
=rsFT
-----END PGP SIGNATURE-----

--kd4a5kaznfiyppsu--
