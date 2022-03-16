Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AF44DABF9
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354290AbiCPHqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354280AbiCPHqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 03:46:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA3655BE9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 00:45:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUOLM-0004Nj-KA; Wed, 16 Mar 2022 08:45:16 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-58ae-3d0e-218c-eca6.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:58ae:3d0e:218c:eca6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7C1B14C3EC;
        Wed, 16 Mar 2022 07:45:15 +0000 (UTC)
Date:   Wed, 16 Mar 2022 08:45:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220316074515.jchjdelc722dkug7@pengutronix.de>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a7jkxwlyxzf4a2wp"
Content-Disposition: inline
In-Reply-To: <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a7jkxwlyxzf4a2wp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.03.2022 18:51:34, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 21:37:48 +0100 Oliver Hartkopp wrote:
> > Syzbot created an environment that lead to a state machine status that
> > can not be reached with a compliant CAN ID address configuration.
> > The provided address information consisted of CAN ID 0x6000001 and 0xC2=
8001
> > which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
> >=20
> > Sanitize the SFF/EFF CAN ID values before performing the address checks.
> >=20
> > Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> > Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> > Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>=20
> CC Marc, please make sure you CC maintainers.

Thx. And make sure you have the linux-can ML on Cc :)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--a7jkxwlyxzf4a2wp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIxlYgACgkQrX5LkNig
013J4Af+I/NIkvAMDcLPbEyYurqV1Dv+WHXAZ2vnk8hTDBOnqELRTqTUj/ZRGHtn
Yeq67ip2InVP5woUfmhikSDWjOaULUsF5tAHEwuXtk0bgF3vqydSRq14U5mWEM74
lb9sC0KPfTZlcHiafOT5/uiaIv1eD2TMOGPzxkBz6Gl5HHQteiFtkOljlAcvdbTd
TN52/tO2LA3CUYo9DAcjBAxPiAVMgjsgOAiq70isc/V/XTRcZpqMnn8TUEdZxJC8
G+W+z+OEa2zMwK61mU7FIO0Wy9B/jwNyDLN6+0NhyKQQsKHzSY5X27BN8URirQeU
8eaplG6IroTFS9flA9FpPclCH/MCWg==
=u3B6
-----END PGP SIGNATURE-----

--a7jkxwlyxzf4a2wp--
