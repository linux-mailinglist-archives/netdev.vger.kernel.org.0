Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565F010FCE7
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfLCLyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:54:05 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57745 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfLCLyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 06:54:05 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic6kj-0000DV-B1; Tue, 03 Dec 2019 12:54:01 +0100
Received: from [IPv6:2a03:f580:87bc:d400:858e:130c:14c0:366e] (unknown [IPv6:2a03:f580:87bc:d400:858e:130c:14c0:366e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A142A4885E2;
        Tue,  3 Dec 2019 11:53:58 +0000 (UTC)
To:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jouni Hogander <jouni.hogander@unikie.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-stable <stable@vger.kernel.org>
References: <20191203104703.14620-1-mkl@pengutronix.de>
 <20191203104703.14620-4-mkl@pengutronix.de>
 <df8db94f-307f-6a08-2711-c869b4548a67@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH 3/6] can: slcan: Fix use-after-free Read in slcan_open
Message-ID: <78836d74-1440-fb8d-3178-08d01480d73d@pengutronix.de>
Date:   Tue, 3 Dec 2019 12:53:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <df8db94f-307f-6a08-2711-c869b4548a67@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="m5q2nLK3MfThEV8N3sBiy9t3Trj7TCZ1P"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m5q2nLK3MfThEV8N3sBiy9t3Trj7TCZ1P
Content-Type: multipart/mixed; boundary="2qNtbmPEnGrGDMxkUcanKkFxyGpCXlfzi";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-can@vger.kernel.org, kernel@pengutronix.de,
 Jouni Hogander <jouni.hogander@unikie.com>,
 Wolfgang Grandegger <wg@grandegger.com>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>,
 linux-stable <stable@vger.kernel.org>
Message-ID: <78836d74-1440-fb8d-3178-08d01480d73d@pengutronix.de>
Subject: Re: [PATCH 3/6] can: slcan: Fix use-after-free Read in slcan_open
References: <20191203104703.14620-1-mkl@pengutronix.de>
 <20191203104703.14620-4-mkl@pengutronix.de>
 <df8db94f-307f-6a08-2711-c869b4548a67@hartkopp.net>
In-Reply-To: <df8db94f-307f-6a08-2711-c869b4548a67@hartkopp.net>

--2qNtbmPEnGrGDMxkUcanKkFxyGpCXlfzi
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 12/3/19 12:21 PM, Oliver Hartkopp wrote:
>=20
>=20
> On 03/12/2019 11.47, Marc Kleine-Budde wrote:
>> From: Jouni Hogander <jouni.hogander@unikie.com>
>>
>> Slcan_open doesn't clean-up device which registration failed from the
>> slcan_devs device list. On next open this list is iterated and freed
>> device is accessed. Fix this by calling slc_free_netdev in error path.=

>>
>> Driver/net/can/slcan.c is derived from slip.c. Use-after-free error wa=
s
>> identified in slip_open by syzboz. Same bug is in slcan.c. Here is the=

>> trace from the Syzbot slip report:
>>
>> __dump_stack lib/dump_stack.c:77 [inline]
>> dump_stack+0x197/0x210 lib/dump_stack.c:118
>> print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.=
c:374
>> __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
>> kasan_report+0x12/0x20 mm/kasan/common.c:634
>> __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
>> sl_sync drivers/net/slip/slip.c:725 [inline]
>> slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
>> tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
>> tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
>> tiocsetd drivers/tty/tty_io.c:2334 [inline]
>> tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
>> vfs_ioctl fs/ioctl.c:46 [inline]
>> file_ioctl fs/ioctl.c:509 [inline]
>> do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
>> ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
>> __do_sys_ioctl fs/ioctl.c:720 [inline]
>> __se_sys_ioctl fs/ioctl.c:718 [inline]
>> __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
>> do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> Fixes: ed50e1600b44 ("slcan: Fix memory leak in error path")
>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
>> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
>> Cc: linux-stable <stable@vger.kernel.org> # >=3D v5.4
>=20
> I think this problem existed from the initial commit in 2010 and is not=
=20
> restricted to >=3D v5.4
>=20
> Together with commit commit ed50e1600b4483c049 ("slcan: Fix memory leak=
=20
> in error path") from Jouni Hogander.

Yes, both patches shoud be backported:

ed50e1600b44 slcan: Fix memory leak in error path
9ebd796e2400 can: slcan: Fix use-after-free Read in slcan_open

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--2qNtbmPEnGrGDMxkUcanKkFxyGpCXlfzi--

--m5q2nLK3MfThEV8N3sBiy9t3Trj7TCZ1P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl3mTNIACgkQWsYho5Hk
nSAzwgf/dBXyxO4dG6a6EcSFB2muU2YA283PJtKsMsKDa2sNoHcdQjLxTol9K1Q1
C4J+k3I6iecCgPDbXQLPeo8MWzvDsBFVMAC8+46GZ46hbOvtz8iTq8b1y3d802UD
3SfB7KIXv0UzQrfQTZH+vgSS0iMak7E0kBR+AozPCdt6DC5G2CgaucNXV2h7h4EU
DE9D8ERBPWkw+0pvaMygDyiVSBW26oqqp+Prz+wAR9yxcSBEFqfaHIuTlXDuRgbf
WmFgF7Tv1n7Y29Hd7B+UcVaPaxCoIE7KwJxu3m4QpV9HdlxD40am0syO7E/w1Gmh
JE0si4pMzmPyioem02U9TOBbTT9M2w==
=AUfD
-----END PGP SIGNATURE-----

--m5q2nLK3MfThEV8N3sBiy9t3Trj7TCZ1P--
