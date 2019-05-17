Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0621603
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 11:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfEQJKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 05:10:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50202 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbfEQJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 05:10:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so6204209wme.0;
        Fri, 17 May 2019 02:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eaf5Ipr1bpOETTVk1SAmOHqLToU3CpMdXPYSRYeKKjA=;
        b=YXJD/1hglFl0pnDDfF74Ywf3c4zt7D4175urGlyS+k6FQDd7O/6naje+Jvy7cQTDO4
         TE+QviMTY/eT2TA4zW9ZS7qUNb7P9MABmzGVpkrX/NeOU33etIB6BfPFeRPXeLZqOezS
         qwjXXDxzxAmtQoqq/Jk79saxsFCetCSVHOai1HP5KC3nljbXUrE/4hr0d2OCh/qwwRzR
         f3K/SQtjfW6IdXngOm+OWy0NI0Zp3wa+8xJiDmY5eeEfqniFJMD3a2j5jyLdFBSIxuV6
         qXPz9ZgJ1gHP5FotgxUxPJfSRG8Am9co0vfeNOircsvxdalfKZhLBwYWyIGYWVM0srK0
         rMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eaf5Ipr1bpOETTVk1SAmOHqLToU3CpMdXPYSRYeKKjA=;
        b=spXYHRxZgPdbmvM924jWDm6COlnHEisN7d5BqyGubf9lC2XFcDy2a2dktFPIDpRS8w
         n2Gb5xsnTX1igvak55UAMm+6atjRp0gLPXP0AbF/4dfQwwGNcYgFloS7SyTFaR0wVJIM
         LVpuEw/nrVWF/PGZkXOZDxBU5IUxkdqWWw6Z18iOJMzrF3VijMTdgb4Lpyi6H5zBBdgm
         y1hhBmI8wWvXED7ryJBFmn15MAnrT12qEV8se96IkFK/Zy9e9InUz9niB3ZNXBoSA0HX
         M0CckgfCYnAbL1XDIjtAVxDNrkVVGNdFokXs5i7kxtzUDDnrrR28zNrRsB/kD9atBeOT
         EqiA==
X-Gm-Message-State: APjAAAV5/1Zte/M0ZAG2UCcEtCF2gUESpoHPoCoyp52VSSKRnlZjok60
        xeWABAJne7WneDOOk3nILTw=
X-Google-Smtp-Source: APXvYqxFOY58ZqwXg8fVVvJAlslz0/tyCf/ge8I35up63wRN3uGnpEHDzlGY3ZG5esoWo/ddWvZhLw==
X-Received: by 2002:a1c:a804:: with SMTP id r4mr1398577wme.21.1558084216318;
        Fri, 17 May 2019 02:10:16 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id e8sm17526930wrc.34.2019.05.17.02.10.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 02:10:15 -0700 (PDT)
Date:   Fri, 17 May 2019 10:10:14 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Jorge E. Moreira" <jemoreira@google.com>
Cc:     linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] vsock/virtio: Initialize core virtio vsock before
 registering the driver
Message-ID: <20190517091014.GD3679@stefanha-x1.localdomain>
References: <20190516205107.222003-1-jemoreira@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <20190516205107.222003-1-jemoreira@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2019 at 01:51:07PM -0700, Jorge E. Moreira wrote:
> Avoid a race in which static variables in net/vmw_vsock/af_vsock.c are
> accessed (while handling interrupts) before they are initialized.
>=20
> [    4.201410] BUG: unable to handle kernel paging request at fffffffffff=
fffe8
> [    4.207829] IP: vsock_addr_equals_addr+0x3/0x20
> [    4.211379] PGD 28210067 P4D 28210067 PUD 28212067 PMD 0
> [    4.211379] Oops: 0000 [#1] PREEMPT SMP PTI
> [    4.211379] Modules linked in:
> [    4.211379] CPU: 1 PID: 30 Comm: kworker/1:1 Not tainted 4.14.106-4192=
97-gd7e28cc1f241 #1
> [    4.211379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.10.2-1 04/01/2014
> [    4.211379] Workqueue: virtio_vsock virtio_transport_rx_work
> [    4.211379] task: ffffa3273d175280 task.stack: ffffaea1800e8000
> [    4.211379] RIP: 0010:vsock_addr_equals_addr+0x3/0x20
> [    4.211379] RSP: 0000:ffffaea1800ebd28 EFLAGS: 00010286
> [    4.211379] RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffffffffb=
94e42f0
> [    4.211379] RDX: 0000000000000400 RSI: ffffffffffffffe0 RDI: ffffaea18=
00ebdd0
> [    4.211379] RBP: ffffaea1800ebd58 R08: 0000000000000001 R09: 000000000=
0000001
> [    4.211379] R10: 0000000000000000 R11: ffffffffb89d5d60 R12: ffffaea18=
00ebdd0
> [    4.211379] R13: 00000000828cbfbf R14: 0000000000000000 R15: ffffaea18=
00ebdc0
> [    4.211379] FS:  0000000000000000(0000) GS:ffffa3273fd00000(0000) knlG=
S:0000000000000000
> [    4.211379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.211379] CR2: ffffffffffffffe8 CR3: 000000002820e001 CR4: 000000000=
01606e0
> [    4.211379] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [    4.211379] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [    4.211379] Call Trace:
> [    4.211379]  ? vsock_find_connected_socket+0x6c/0xe0
> [    4.211379]  virtio_transport_recv_pkt+0x15f/0x740
> [    4.211379]  ? detach_buf+0x1b5/0x210
> [    4.211379]  virtio_transport_rx_work+0xb7/0x140
> [    4.211379]  process_one_work+0x1ef/0x480
> [    4.211379]  worker_thread+0x312/0x460
> [    4.211379]  kthread+0x132/0x140
> [    4.211379]  ? process_one_work+0x480/0x480
> [    4.211379]  ? kthread_destroy_worker+0xd0/0xd0
> [    4.211379]  ret_from_fork+0x35/0x40
> [    4.211379] Code: c7 47 08 00 00 00 00 66 c7 07 28 00 c7 47 08 ff ff f=
f ff c7 47 04 ff ff ff ff c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 8b 47 0=
8 <3b> 46 08 75 0a 8b 47 04 3b 46 04 0f 94 c0 c3 31 c0 c3 90 66 2e
> [    4.211379] RIP: vsock_addr_equals_addr+0x3/0x20 RSP: ffffaea1800ebd28
> [    4.211379] CR2: ffffffffffffffe8
> [    4.211379] ---[ end trace f31cc4a2e6df3689 ]---
> [    4.211379] Kernel panic - not syncing: Fatal exception in interrupt
> [    4.211379] Kernel Offset: 0x37000000 from 0xffffffff81000000 (relocat=
ion range: 0xffffffff80000000-0xffffffffbfffffff)
> [    4.211379] Rebooting in 5 seconds..
>=20
> Fixes: 22b5c0b63f32 ("vsock/virtio: fix kernel panic after device hot-unp=
lug")
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org [4.9+]
> Signed-off-by: Jorge E. Moreira <jemoreira@google.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzeenYACgkQnKSrs4Gr
c8h69wf+Op5LZ8i7xc0r4f7Y1ZYE/4xTQ2AveN9jwvItfuQz2ZRmEBXX+I8baURN
nw4FOLWxgr9aitsovjcAQt/JJUgxwSMcaavVXBuwI4oJam2hUCEf+NIixvQdzYIV
yy7h06EXm6+gNP1ZgQA2gRNIZFwGbhgOEXRSqvsGxM4E/I5MC9gz718OttQK20bn
gAgp4p7d/nQ3oHI09lRM3JRcKIJOgtuAyWAjhkHSHcNmWyoa7CIFxB+kQCHdItNH
DRJw732tcBl/jo/HpXpZhJkEQ5ykCOg/yVhXEzhc+2Hi3CFEeRm8wDV6oAfXOhJL
OSGLmVV8t5QFHjOnT8RcgoJ+tdaHrA==
=ysW+
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
