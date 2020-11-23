Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1460D2C04FD
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgKWLxS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Nov 2020 06:53:18 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:42761 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbgKWLxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:53:17 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 77795CECCF;
        Mon, 23 Nov 2020 13:00:27 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH] Bluetooth: sco: Fix crash when using BT_SNDMTU/BT_RCVMTU
 option
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201116132421.94624-1-weiyongjun1@huawei.com>
Date:   Mon, 23 Nov 2020 12:53:15 +0100
Cc:     =?utf-8?Q?Marcel_Holtmann_Johan_Hedberg_Jakub_Kicinski_Joseph_Hwang_Al?=
         =?utf-8?Q?ain_Michaud_Abhishek_Pandit-Subedi_Pali_Roh=C3=A1r?= 
        <"marcel@holtmann.orgjohan.hedberg@gmail.comkuba@kernel.orgjosephsih@chromium.orgalainm@chromium.orgabhishekpandit@chromium.orgpali"@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B55CF6CB-6C4F-4F9D-9FFC-83B495913A96@holtmann.org>
References: <20201116132421.94624-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei,

> This commit add the invalid check for connected socket, without it will
> causes the following crash due to sco_pi(sk)->conn being NULL:
> 
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> CPU: 3 PID: 4284 Comm: test_sco Not tainted 5.10.0-rc3+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> RIP: 0010:sco_sock_getsockopt+0x45d/0x8e0
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 ca 03 00 00 49 8b 9d f8 04 00 00 48 b8 00
>      00 00 00 00 fc ff df 48 8d 7b 50 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84
>      c0 74 08 3c 03 0f 8e b5 03 00 00 8b 43 50 48 8b 0c
> RSP: 0018:ffff88801bb17d88 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83a4ecdf
> RDX: 000000000000000a RSI: ffffc90002fce000 RDI: 0000000000000050
> RBP: 1ffff11003762fb4 R08: 0000000000000001 R09: ffff88810e1008c0
> R10: ffffffffbd695dcf R11: fffffbfff7ad2bb9 R12: 0000000000000000
> R13: ffff888018ff1000 R14: dffffc0000000000 R15: 000000000000000d
> FS:  00007fb4f76c1700(0000) GS:ffff88811af80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005555e3b7a938 CR3: 00000001117be001 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
> ? sco_skb_put_cmsg+0x80/0x80
> ? sco_skb_put_cmsg+0x80/0x80
> __sys_getsockopt+0x12a/0x220
> ? __ia32_sys_setsockopt+0x150/0x150
> ? syscall_enter_from_user_mode+0x18/0x50
> ? rcu_read_lock_bh_held+0xb0/0xb0
> __x64_sys_getsockopt+0xba/0x150
> ? syscall_enter_from_user_mode+0x1d/0x50
> do_syscall_64+0x33/0x40
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: 0fc1a726f897 ("Bluetooth: sco: new getsockopt options BT_SNDMTU/BT_RCVMTU")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

patch has been applied to bluetooth-next tree.

Regards

Marcel

