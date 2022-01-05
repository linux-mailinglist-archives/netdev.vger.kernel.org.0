Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AB7485408
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbiAEOFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiAEOFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:05:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AABC061785
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:05:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n56uH-0000CK-Ba; Wed, 05 Jan 2022 15:04:49 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-7899-4998-133d-b4b9.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7899:4998:133d:b4b9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5F8C96D1A43;
        Wed,  5 Jan 2022 14:04:44 +0000 (UTC)
Date:   Wed, 5 Jan 2022 15:04:43 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com>,
        anthony.l.nguyen@intel.com, changbin.du@intel.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        intel-wired-lan-owner@osuosl.org, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>
Subject: Re: [syzbot] kernel BUG in pskb_expand_head
Message-ID: <20220105140443.vwobz3yx4z3rux6a@pengutronix.de>
References: <0000000000007ea16705d0cfbb53@google.com>
 <000000000000c7845605d4d3f0a0@google.com>
 <CANn89i+LbcWn3xoYU-eMjjmQPz0x1pSAat2OpF=i0+RByc-h4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="72ar6nyolsauz65r"
Content-Disposition: inline
In-Reply-To: <CANn89i+LbcWn3xoYU-eMjjmQPz0x1pSAat2OpF=i0+RByc-h4w@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--72ar6nyolsauz65r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.01.2022 05:59:35, Eric Dumazet wrote:
> On Wed, Jan 5, 2022 at 3:20 AM syzbot
> <syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following issue on:
> >
> > HEAD commit:    c9e6606c7fe9 Linux 5.16-rc8
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D148351c3b00=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D32f9fa260d7=
413b4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4c63f36709a64=
2f801c5
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binu=
tils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15435e2bb=
00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12f4508db00=
000
> >
>=20
> This C repro looks legit, bug should be in CAN layer.

ACK - it's bug in CAN's ISOTP

> > The issue was bisected to:
> >
> > commit e4b8954074f6d0db01c8c97d338a67f9389c042f
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Tue Dec 7 01:30:37 2021 +0000
> >
> >     netlink: add net device refcount tracker to struct ethnl_req_info
>=20
> Ignore this bisection, an unrelated commit whent in its way.

ACK - We have a RFC fix for this:

https://lore.kernel.org/all/20220105132429.1170627-1-mkl@pengutronix.de

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--72ar6nyolsauz65r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHVpXkACgkQqclaivrt
76m+pAf+M8hsvuG1OEtF6bw1HNGyTla1VDEhL4hbgurkpql5872fKSOA+ROtuCKi
I2gOI0cqp/kJNzH1fdIQuiXuIqaM1f38sXb3q51Ng9TsXpk82Rd3FHpHK698t/Rq
ImxBIWHEQWzGgIYcRfP/WKh2dsNzLyW4dFo4hmPMuacEluVI7JAmr/dU1OvXebH0
1D1Z63rR37GOnQL9M/Sh2oY29UC/n5a4BDMC42en3Wb+5vMEPEH5S/AjvG1MBzen
YlCkkIEhyHM2DqN9jaXG6/rbaz5ckPxaEm+ES3xNDg9aHSS0zLi/Ct9nyrl5tJlm
KXMaxmP7EmEYr1W9XIVrHhZVs5h2aQ==
=1PmX
-----END PGP SIGNATURE-----

--72ar6nyolsauz65r--
