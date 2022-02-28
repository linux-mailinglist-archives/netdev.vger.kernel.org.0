Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A8E4C6742
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiB1KqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiB1KqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:46:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB9D5A5B7
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 02:45:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nOdWm-0005z3-QJ; Mon, 28 Feb 2022 11:45:16 +0100
Received: from pengutronix.de (unknown [90.153.54.255])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C54443F14B;
        Mon, 28 Feb 2022 10:45:14 +0000 (UTC)
Date:   Mon, 28 Feb 2022 11:45:14 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: usb: delete a redundant dev_kfree_skb() in
 ems_usb_start_xmit()
Message-ID: <20220228104514.der655r4jkl42e7o@pengutronix.de>
References: <20220228083639.38183-1-hbh25y@gmail.com>
 <20220228085536.pa5wdq3w4ul5wqn5@pengutronix.de>
 <75c14302-b928-1e09-7cd1-78b8c2695f06@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7eh4p5gbufrubt3s"
Content-Disposition: inline
In-Reply-To: <75c14302-b928-1e09-7cd1-78b8c2695f06@gmail.com>
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


--7eh4p5gbufrubt3s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.02.2022 18:44:06, Hangyu Hua wrote:
> I get it. I'll remake a patch that matches your suggestions.

Not needed, it's already applied:
> > Added patch to can/testing.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7eh4p5gbufrubt3s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIcp7cACgkQrX5LkNig
01340gf/Y+FncybB30L2oHpNPFt478Sked0wTAKMnn8MTwJA+zCDUwFwMmwM1QPN
u4v7v1lhNozapHCkU2lCgn0OwHuu4r42zTDxT/SWOFSR53bF3DE7OaCn44/7IcSe
qR253VIrPsA7dC0dvwAZ/EtdXc9sjJZMKP3VsibtmNZYn+3fvZEAQktCafPs1yfs
XkF7eEB2xD1ORONY+eRyW/LIXpdcZZsl/ShE+OoyMa4Jh2Udo215hOiLnvykAfh7
uxzMMGK+GS7kDVAESApxJWuxhcdSUxc5RDq0AX6JnL7EK5eSMKKFEXscUEI3NMBP
XqK8orgQoTkeNokWljv/bWBSbHNL9A==
=i5Li
-----END PGP SIGNATURE-----

--7eh4p5gbufrubt3s--
