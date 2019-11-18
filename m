Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A8D100D25
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 21:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKRUaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 15:30:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43337 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfKRUaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 15:30:09 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iWneu-0003hC-GH; Mon, 18 Nov 2019 21:30:04 +0100
Received: from [IPv6:2a03:f580:87bc:d400:5c97:9951:c8b:93e3] (unknown [IPv6:2a03:f580:87bc:d400:5c97:9951:c8b:93e3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CE36647EEFC;
        Mon, 18 Nov 2019 20:30:01 +0000 (UTC)
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: KMSAN: uninit-value in can_receive
Message-ID: <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
Date:   Mon, 18 Nov 2019 21:29:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4lfuLS5FUCQMFuAJ7EKKxq2kCUyYMXWZ8"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4lfuLS5FUCQMFuAJ7EKKxq2kCUyYMXWZ8
Content-Type: multipart/mixed; boundary="xcSkRBkEGR9QYePLhqRmrIc2GDGTHmLBT";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
 syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
 davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Message-ID: <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
Subject: Re: KMSAN: uninit-value in can_receive
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
In-Reply-To: <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>

--xcSkRBkEGR9QYePLhqRmrIc2GDGTHmLBT
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 11/18/19 9:25 PM, Oliver Hartkopp wrote:
> On 18/11/2019 20.05, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:=C2=A0=C2=A0=C2=A0 9c6a7162 kmsan: remove unneeded annotat=
ions in bio
>> git tree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://github.com/googl=
e/kmsan.git master
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14563416e0=
0000
>> kernel config:=C2=A0 https://syzkaller.appspot.com/x/.config?x=3D9e324=
dfe9c7b0360
>> dashboard link:=20
>> https://syzkaller.appspot.com/bug?extid=3Db02ff0707a97e4e79ebb
>> compiler:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clang version 9.0.0 (/ho=
me/glider/llvm/clang=20
>> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the com=
mit:
>> Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>> BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_can.c:6=
49
>> CPU: 1 PID: 3490 Comm: syz-executor.2 Not tainted 5.4.0-rc5+ #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S=20
>> Google 01/01/2011
>> Call Trace:
>>  =C2=A0<IRQ>
>>  =C2=A0__dump_stack lib/dump_stack.c:77 [inline]
>>  =C2=A0dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>>  =C2=A0kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
>>  =C2=A0__msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
>>  =C2=A0can_receive+0x23c/0x5e0 net/can/af_can.c:649
>>  =C2=A0can_rcv+0x188/0x3a0 net/can/af_can.c:685
>=20
> In line 649 of 5.4.0-rc5+ we can find a while() statement:
>=20
> while (!(can_skb_prv(skb)->skbcnt))
> 	can_skb_prv(skb)->skbcnt =3D atomic_inc_return(&skbcounter);
>=20
> In linux/include/linux/can/skb.h we see:
>=20
> static inline struct can_skb_priv *can_skb_prv(struct sk_buff *skb)
> {
> 	return (struct can_skb_priv *)(skb->head);
> }
>=20
> IMO accessing can_skb_prv(skb)->skbcnt at this point is a valid=20
> operation which has no uninitialized value.
>=20
> Can this probably be a false positive of KMSAN?

The packet is injected via the packet socket into the kernel. Where does
skb->head point to in this case? When the skb is a proper
kernel-generated skb containing a CAN-2.0 or CAN-FD frame skb->head is
maybe properly initialized?

>   do_softirq kernel/softirq.c:338 [inline]
>   __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:190
>   local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
>   rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
>   __dev_queue_xmit+0x38e8/0x4200 net/core/dev.c:3900
>   dev_queue_xmit+0x4b/0x60 net/core/dev.c:3906
>   packet_snd net/packet/af_packet.c:2959 [inline]
>   packet_sendmsg+0x82d7/0x92e0 net/packet/af_packet.c:2984
                                 ^^^^^^^^^^^^^^^^^^^^^^
>   sock_sendmsg_nosec net/socket.c:637 [inline]
>   sock_sendmsg net/socket.c:657 [inline]
>   ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
>   __sys_sendmsg net/socket.c:2356 [inline]
>   __do_sys_sendmsg net/socket.c:2365 [inline]
>   __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
>   __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
>   do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--xcSkRBkEGR9QYePLhqRmrIc2GDGTHmLBT--

--4lfuLS5FUCQMFuAJ7EKKxq2kCUyYMXWZ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl3S/0IACgkQWsYho5Hk
nSBH5Qf/XueijbPhWRM7b//MP73DST/n7wReugm1aRecsNHtLPxRDiGRUkAy8UtY
80pqOEcZHZhr+ULyK0DrBUPqt3cM0PepKYEFqvLcuvuo4JQoLiWftZusD0Ym9+BK
4moaRf6SnspV7z92s21EMJM8epMv9EFkQRxs2+W8TjMkDSf2VyXaw8uYlB/r8fbb
x2SfwuKkCj7hrd0+2AJ38SSXXBo375biC3kUVh3ROXPNZLpmQBZns3onZfX/AWPN
Wo/OotqzQgMA/oMv83tSq+eAxFebf4qfxvhEfXaMlU9jtKmw/dwkq1GQ67jJicvz
0ZfKh57N2QhgP4pXLr3WOzQ67uLJUA==
=JaOQ
-----END PGP SIGNATURE-----

--4lfuLS5FUCQMFuAJ7EKKxq2kCUyYMXWZ8--
