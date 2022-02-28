Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5F14C66D3
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiB1KHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbiB1KHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:07:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70A82D1FB
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 02:06:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nOcv6-0001BA-IF; Mon, 28 Feb 2022 11:06:20 +0100
Received: from pengutronix.de (unknown [90.153.54.255])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 07E333F02B;
        Mon, 28 Feb 2022 08:55:36 +0000 (UTC)
Date:   Mon, 28 Feb 2022 09:55:36 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: usb: delete a redundant dev_kfree_skb() in
 ems_usb_start_xmit()
Message-ID: <20220228085536.pa5wdq3w4ul5wqn5@pengutronix.de>
References: <20220228083639.38183-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3b5jwxwlprqckkxj"
Content-Disposition: inline
In-Reply-To: <20220228083639.38183-1-hbh25y@gmail.com>
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


--3b5jwxwlprqckkxj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.02.2022 16:36:39, Hangyu Hua wrote:
> There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
> can_put_echo_skb deletes original skb and can_free_echo_skb deletes the c=
loned
> skb.
>=20
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Thanks for the patch. Please add a Fixes tag, that points to the commit
that introduced the problem, here it's:

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB i=
nterface")

I've adjusted the subject a bit ("can: usb: ems_usb_start_xmit(): fix
double dev_kfree_skb() in error path") and added stable on Cc.

Added patch to can/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3b5jwxwlprqckkxj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIcjgUACgkQrX5LkNig
011JaAgAgazwqrThdzTSMQPN3Jz7o80maSyjAnDnztQyxz7rmwW5gFoEHkXA61Hi
ih20UirDRgWIFJJOkK+oKuvCEDAvrMMXi2oc5vM5lHdev5dPyNoEhw1c7dGpMA7v
gbaArI3x0/qEBgwUIc0NUed1zPYHd86J6++4exGaVg5Ht915pFdznq8oHVrepgY/
dEWiwQh4gjVgZwTHQ9xGouS+VV6egSz/K6GS5FUHHRm59C594vglVwYKbEwSRPSH
fSM+FGC8c64/Jcmq9DzP8B19BC7czeEmim3cR6+oyZe99fKGAwJf015YbvGxLN1J
pAmOrdGIsydoKimv4s6Tkf8aekXRXA==
=HJiM
-----END PGP SIGNATURE-----

--3b5jwxwlprqckkxj--
