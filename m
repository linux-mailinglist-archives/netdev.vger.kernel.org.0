Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5F4DAC29
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354388AbiCPICf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244787AbiCPICe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:02:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9396E5C354
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:01:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUOan-0006Fx-Mq; Wed, 16 Mar 2022 09:01:13 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-58ae-3d0e-218c-eca6.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:58ae:3d0e:218c:eca6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BB7244C41D;
        Wed, 16 Mar 2022 08:01:11 +0000 (UTC)
Date:   Wed, 16 Mar 2022 09:01:11 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        linux-can <linux-can@vger.kernel.org>
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220316080111.s2hlj6krlzcroxh6@pengutronix.de>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
 <20220316074802.b3xazftb7axziue3@pengutronix.de>
 <7445f2f1-4d89-116e-0cf7-fc7338c2901f@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gtrnbsganf6o7yud"
Content-Disposition: inline
In-Reply-To: <7445f2f1-4d89-116e-0cf7-fc7338c2901f@hartkopp.net>
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


--gtrnbsganf6o7yud
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.03.2022 08:53:54, Oliver Hartkopp wrote:
> > Should this go into net/master with stable on Cc or to net-next?
>=20
> This patch is for net-next as it won't apply to net/master nor the
> stable trees due to the recent changes in net-next.
>=20
> As it contains a Fixes: tag I would send the patch for the stable
> trees when the patch hits Linus' tree and likely Greg would show up
> asking for it.
>=20
> I hope that's the most elegant process here?!?

Another option is to port the patch to net/master with the hope that
back porting is easier. Then talk to Jakub and David about the merge
conflict when net/master is merged to net-next/master.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--gtrnbsganf6o7yud
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIxmT8ACgkQrX5LkNig
01087gf+OX1FlioJmrgiKmTnmPuQaD4rGOqzkxNIHKITJxiZ8PiWhmb7Dotu4FEQ
f07Vi3WPD4Z/04wOKz/ttrefX4neFBOfU2r6y7BGsrEvECuz24nTC3EVgRbN9JCE
iQVymE0xnarpitvHJJGv5ZF5KhvhDkx7AVvPi95x3fUBMgtMeIjDl6flsb4H1QQm
f+qfFewCa52hLiw7qdp2pDy68dLX//LyabCz8HcRO/lB2bDNY0zGEQURTtmlVMy/
i03wDoUyyahiQuT/9tvv40mygA1i9Sd51nJXr+gglf2scw6pEtgQU/9r+/zuiAHl
OTGNXJzDap66d/hqoS6Dw2q3vM+kIQ==
=gGTf
-----END PGP SIGNATURE-----

--gtrnbsganf6o7yud--
