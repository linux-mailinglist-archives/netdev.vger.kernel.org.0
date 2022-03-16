Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8164DAC04
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354321AbiCPHtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 03:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354332AbiCPHtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 03:49:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5FDDFBA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 00:48:05 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUOO3-0004pa-7F; Wed, 16 Mar 2022 08:48:03 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-58ae-3d0e-218c-eca6.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:58ae:3d0e:218c:eca6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9CB6E4C3F6;
        Wed, 16 Mar 2022 07:48:02 +0000 (UTC)
Date:   Wed, 16 Mar 2022 08:48:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220316074802.b3xazftb7axziue3@pengutronix.de>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iqmkpn33uytbhv24"
Content-Disposition: inline
In-Reply-To: <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
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


--iqmkpn33uytbhv24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.03.2022 08:35:58, Oliver Hartkopp wrote:
>=20
>=20
> On 16.03.22 02:51, Jakub Kicinski wrote:
> > On Tue, 15 Mar 2022 21:37:48 +0100 Oliver Hartkopp wrote:
> > > Syzbot created an environment that lead to a state machine status that
> > > can not be reached with a compliant CAN ID address configuration.
> > > The provided address information consisted of CAN ID 0x6000001 and 0x=
C28001
> > > which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
> > >=20
> > > Sanitize the SFF/EFF CAN ID values before performing the address chec=
ks.
> > >=20
> > > Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> > > Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> > > Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> >=20
> > CC Marc, please make sure you CC maintainers.
>=20
> Oh, that would have been better! I'm maintaining the CAN network layer st=
uff
> together with Marc and there was no relevant stuff in can-next to be pull=
ed
> in the next days. So I sent it directly to hit the merge window and had a=
ll
> of us in the reply to the syzbot report.
>=20
> Will CC Marc next time when posting to netdev only!
>=20
> Maybe I treated this patch more urgent than it needed to be handled
> =C2=AF\_(=E3=83=84)_/=C2=AF

Should this go into net/master with stable on Cc or to net-next?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--iqmkpn33uytbhv24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIxli8ACgkQrX5LkNig
0100nwf/f8+i4bn9wteTJ2mBsDGexIY1+unKOqXQBG/i4Ump+FtyBHcEuzDuuLrW
h95CCwdpRNaNXJTlULY4EfWAYdJ1CywVKtppTc4ItvVFevZswhFEwqEMj6qSruN9
KYkiavewhJgtNgrR0k9veISLOUcNFM6yBuOdvnYpYvb5ar/tyXbu9XUKVXfHwgv6
b5qvR48z+Jd18Af0iovh/Z9BjLhXj2hLKOnECV3g6QvGHIUB5lfYMQIKY6gfK/LA
3vFyOxSDF7sEiW1ZU3JHM5bsDq5Mo0HDTj7I0HQRjvs3rsZkbO27N3F6oxas0slx
v/xBhqyc0XZZtZErQqQqPQopn5y/eg==
=Ayxv
-----END PGP SIGNATURE-----

--iqmkpn33uytbhv24--
