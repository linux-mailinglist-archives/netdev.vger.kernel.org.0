Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FFD115080
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLFMlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 07:41:31 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:52039 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfLFMlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 07:41:31 -0500
Received: from mail-qv1-f45.google.com ([209.85.219.45]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MDQmW-1iUzRm1YNK-00AZju; Fri, 06 Dec 2019 13:41:28 +0100
Received: by mail-qv1-f45.google.com with SMTP id t9so2560697qvh.13;
        Fri, 06 Dec 2019 04:41:27 -0800 (PST)
X-Gm-Message-State: APjAAAXoNSix/KtbNPZh9axPa0rUvY0q1ZcHRSTIgCB9HJVLV+qdgx9z
        SltK+1qBc4+fySBn9z+Y2UqzxNsgAWKdKlbwCkA=
X-Google-Smtp-Source: APXvYqy7ap13X+QMNi1EkaLaeRWQmO6croMS+S+3y40SVzPbC+qRetyU3cHdC1YvxS7S5h1SRXGEfaYrvkLAf4Zsb2c=
X-Received: by 2002:ad4:4021:: with SMTP id q1mr7657501qvp.211.1575636086881;
 Fri, 06 Dec 2019 04:41:26 -0800 (PST)
MIME-Version: 1.0
References: <0000000000009bd693059905b445@google.com>
In-Reply-To: <0000000000009bd693059905b445@google.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 6 Dec 2019 13:41:10 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com>
Message-ID: <CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com>
Subject: Re: KASAN: null-ptr-deref Write in x25_connect
To:     syzbot <syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-x25@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:yr0FgwtAObQ8Na98weqsj1XByoWH54uq7O3KrsNtih/L2HW2mk8
 YcnJvjDUkuflX5ZIYMCpDq1NRsakL063MTycJ6YMiGaCYC+FbqSNC2retvWLUULRI9Vh653
 PbnyUClFzKswMSUF2jL+Xest8+1GOCoUsN18CJEnOIHoVRtRtIvGqbCTLQcJzDdEqLtwhw2
 bDmO2/BM32T18oTLz5Ovw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iKI8J8k/nT0=:9D7YJX/eMuCJakbmXGNmFQ
 xw6dPXAenJ9O54x7DKnGnRIgRegS5ezKlnpxxsnSv6BTE+XCyqElb9V5GjEXiH6nDATxxNT0b
 Ss1rUY3FYfIVusVlrX9s1myrIDvYQsoRCED5cUGKiFvj71eIUl+H6TeTULOGYWwhEg8u0LHcH
 ykJEgi7LoQvqVIztRaO2SpX7NCX0/xV97FS0BdUzmlVnPtOq7W28GK7J6fo5lUnyoG4Qp6O8t
 7wGxwWrCPn1EzEsm5SE6wP5X/JujUfIUqRbswQ2oC+Gs2D+Kas7++h4WDhxibTc2j23svCLFN
 /jX6nikuMeG0TGYGohFy6SuDotcUfIw8Zq5ufTVT/F643kwuto3i4o8eY3hZwmE1VTLYNBgmd
 6TxTsjivj84RiagZzdjQEFDebcw8m5SEYDuNoyBgSjWQE/andyWZO0X1dqpMDs6zIU+wu6hb3
 4+L2Mg9712ZN2hzjMmDTSpGKdcjaQOQqalPHBl2Ytfh24C9iG+l1wfxjFcJLzlPTh4AQZhvQe
 91zptXmHASWWHKYhcH0maBZ1Q6IbPrddZOXloteZCgUxepUCSqJ5dPKulw3DK3+fMBNgiavy2
 K1f7+KEcsG2OcxOms6gZhiUu7AH4xlLgpecSWa9k5WSHq/ceLU72VipOKVoLHWbgEnzopzOZo
 7YAL04t4irfu2d7xRaOKwTVwkWionZLI03tjkPmo3t8oRksq5gP23Yxp1EF1TiVzBf+AxqYMm
 dF8BPE35tM2ldr1Xeczf8Io1oFcUAQIQ3syvk/Vp3jWDC1d+JAMxQUQhAWpDNRCnWeFoh6i8Q
 UichQ7qFZzLvpkLKsG/IwOuatTNBt2EhhERceHH9SN8Q+vuzAdk2yTBGQ9xLhZXnAclO/ewTi
 zbUFqzwip4BxJT5BXlKw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 10:31 AM syzbot
<syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    9bd19c63 net: emulex: benet: indent a Kconfig depends cont..

This is a whitespace change, so clearly not the root cause.

> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=14b858eae00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=333b76551307b2a0
> dashboard link: https://syzkaller.appspot.com/bug?extid=429c200ffc8772bfe070
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: null-ptr-deref in atomic_fetch_sub
> include/asm-generic/atomic-instrumented.h:199 [inline]
> BUG: KASAN: null-ptr-deref in refcount_sub_and_test
> include/linux/refcount.h:253 [inline]
> BUG: KASAN: null-ptr-deref in refcount_dec_and_test
> include/linux/refcount.h:281 [inline]
> BUG: KASAN: null-ptr-deref in x25_neigh_put include/net/x25.h:252 [inline]
> BUG: KASAN: null-ptr-deref in x25_connect+0x974/0x1020 net/x25/af_x25.c:820
> Write of size 4 at addr 00000000000000c8 by task syz-executor.5/32400
>
> CPU: 1 PID: 32400 Comm: syz-executor.5 Not tainted 5.4.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>   __kasan_report.cold+0x5/0x41 mm/kasan/report.c:510
>   kasan_report+0x12/0x20 mm/kasan/common.c:634
>   check_memory_region_inline mm/kasan/generic.c:185 [inline]
>   check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
>   __kasan_check_write+0x14/0x20 mm/kasan/common.c:98
>   atomic_fetch_sub include/asm-generic/atomic-instrumented.h:199 [inline]
>   refcount_sub_and_test include/linux/refcount.h:253 [inline]
>   refcount_dec_and_test include/linux/refcount.h:281 [inline]
>   x25_neigh_put include/net/x25.h:252 [inline]
>   x25_connect+0x974/0x1020 net/x25/af_x25.c:820
>   __sys_connect_file+0x25d/0x2e0 net/socket.c:1847
>   __sys_connect+0x51/0x90 net/socket.c:1860
>   __do_sys_connect net/socket.c:1871 [inline]
>   __se_sys_connect net/socket.c:1868 [inline]
>   __x64_sys_connect+0x73/0xb0 net/socket.c:1868
>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45a679
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fa58a10ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a679
> RDX: 0000000000000012 RSI: 0000000020000000 RDI: 0000000000000004
> RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa58a10f6d4
> R13: 00000000004c0f1c R14: 00000000004d4088 R15: 00000000ffffffff
> ==================================================================

Eric Dumazet fixed a related bug in commit 95d6ebd53c79 ("net/x25: fix
use-after-free
in x25_device_event()"):

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -820,8 +820,12 @@ static int x25_connect(struct socket *sock,
struct sockaddr *uaddr,
        sock->state = SS_CONNECTED;
        rc = 0;
 out_put_neigh:
-       if (rc)
+       if (rc) {
+               read_lock_bh(&x25_list_lock);
                x25_neigh_put(x25->neighbour);
+               x25->neighbour = NULL;
+               read_unlock_bh(&x25_list_lock);
+       }
 out_put_route:
        x25_route_put(rt);
 out:

The most likely explanation I see is that we have two concurrent calls
to x25_connect racing in this code, so x25->neighbour is set to NULL
in one thread while another thread calls x25_neigh_put() on that pointer.

Given that all the x25 patches of the past years that are not global cleanups
tend to fix user-triggered oopses, is it time to just retire the subsystem?

I looked a bit closer and found:

- we used to support x25 hardware in linux, but with WAN_ROUTER
  removed in linux-3.9 and isdn4linux removed in 5.3, there is only
  hdlc, ethernet and the N_X25 tty ldisc left. Out of these, only
  HDLC_X25 made it beyond the experimental stage, so this is
  probably what everyone uses if there are users at all.

- The only common hdlc hardware that people seem to be using are
  the "farsync" PCIe and USB adapters. Linux only has drivers for
  the older PCI devices from that series, but no hardware that works
  on modern systems.

- The manufacturer still updates their own kernel drivers and provides
  support, but ships that with a fork or rewrite of the subsystem code now.
  Kevin Curtis is also listed as maintainer, but appears to have given
  up in 2013 after [1].

- The most popular software implementation appears to be X25 over TCP
  (XOT), which is supported by Farsite and other out-of-tree stacks
  but never had an implementation in mainline.

- The subsystem is listed as "odd fixes", but the last reply on the netdev
  mailing list from the maintainer was also in 2013[2].

      Arnd

[1] https://lore.kernel.org/netdev/E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA4@SOLO.hq.farsitecommunications.com/
[2] https://lore.kernel.org/netdev/CADo0ohh7jZhc_WJFkrYYxoYza8ZeSEadzwgwabJWwQ1TucdCcg@mail.gmail.com/
