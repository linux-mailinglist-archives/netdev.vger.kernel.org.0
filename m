Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9C4EB42C
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 21:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbiC2Til (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 15:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbiC2Tif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 15:38:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16522986E6
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 12:36:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZHdw-0005xZ-Qf; Tue, 29 Mar 2022 21:36:40 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-363f-4dd9-8273-6da4.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:363f:4dd9:8273:6da4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AE8B456710;
        Tue, 29 Mar 2022 19:36:38 +0000 (UTC)
Date:   Tue, 29 Mar 2022 21:36:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     syzbot <syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, pfink@christ-es.de,
        syzkaller-bugs@googlegroups.com, wg@grandegger.com
Subject: Re: [syzbot] memory leak in gs_usb_probe
Message-ID: <20220329193638.34h7nczdrr7pdful@pengutronix.de>
References: <000000000000bd6ee505db5cfec6@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ggxulcklerfpozv7"
Content-Disposition: inline
In-Reply-To: <000000000000bd6ee505db5cfec6@google.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ggxulcklerfpozv7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.03.2022 08:22:20, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    52deda9551a0 Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12b472dd700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9ca2a67ddb200=
27f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4d0ae90a195b269=
f102d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e96e1d700=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12f8b513700000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com

Good Bot!

Fixed:
https://lore.kernel.org/all/20220329193450.659726-1-mkl@pengutronix.de

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ggxulcklerfpozv7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJDX8MACgkQrX5LkNig
010OZQf+IJFjX8rqOFRI9q1xLxEcaOBCkM8n360aEkwlSzvXRJZOLLM4ru27deZq
qPcNRPHPtJv/siB7FsZtb5XDRl7aZJwFqGkr2sShlipEUBtHgk2u/Nkj0OGMe14E
of43LQ267hoD2dk4RHvXbUBMzTV52U07c4tes68DY7c6uY4vJ8xQjLCSbBhN6vAG
xvF2tqkypG6j8PPIqOI7BzvXuuP08At/xiHsKeXnBELYy+WP0Duby/SourWok8Au
kdC5hGh1vdGj+bCxeyde78B+DaR+oVsdaAVdGt2M4oXuOYfsehd07ki1FiJuRKXt
zdZpmly9+GQLFrK2kQuXeDzyeZFMzA==
=yXC7
-----END PGP SIGNATURE-----

--ggxulcklerfpozv7--
