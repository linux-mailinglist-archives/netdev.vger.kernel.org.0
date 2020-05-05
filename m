Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704E91C59AC
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgEEOdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbgEEOdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:33:09 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851E3C061A0F;
        Tue,  5 May 2020 07:33:09 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a21so1828074ljj.11;
        Tue, 05 May 2020 07:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yyBCAEOtVSPbMrEm7lYVHsTzxI11co2b75HQs0mAhQ=;
        b=TOyRiw6rXYpPTg0x9FbRVPwKTrrQLmYeIAjAV1WDFOkGQecgEOc4i3gfWDnrXUY9wg
         pyeGjfvYtPmFLNYi2zP+BW0cEdv95IAn1Ay/o/oblaLO9TbLtAh+O3vpftkixE+UD6H2
         M0yYlMWbHXo1VAu5Ruz1JlMetHNpRnxQ3D92NPS8RxWhJOByD4UbHcO/ldKtqiVSUYc3
         nVhXbJsZiiZFtv1S41CqiUey6nnP3TCEyx19VVmpi3uuxfYPB040Vc9jleeiMkjyIwhj
         oJRN7vtt7z6ifG4mEZjOkPGYa/kXorAg+d0npunBVcCgQqA6rngOa0wscOVoyVl0tIgE
         mxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yyBCAEOtVSPbMrEm7lYVHsTzxI11co2b75HQs0mAhQ=;
        b=a1CeLV8HFI8AnhqdBmP0T/rdkE90dWMeVG+bq1cmaHJdWk4ZG2KEFR/CIfllW6dkaY
         45dBNGqND3UjWXYdrrwWC+9t0W60anzIDjYMyMjmUa9RlaBOsys55TXtRnH6z6jIL0DQ
         b/jE4OKIxEYp2CosNml5gm5WuHiX0Kf5wFaRpExDOccRYqIHSus3ceE4w1WSpp0Socjb
         si/x6eTz3HesLCs9x7IDTF9gAsu6zueIyEy7TQYFE6uTDMwZY3zGs3AbMUacoFVvmhkH
         iCcoYVpolT/gjC0XnvJ2fkG7vZdiPxvlVZuB1KX7cnbuZ2sVphbrGlLslGg/bg0EWXPX
         oRSA==
X-Gm-Message-State: AGi0PuZdlrGcRqFM4bETN6s88zVFJKLIilrOwTETRlWa7SJRlnInjkzL
        Hb+xhZi3loRVJMGHCOFWW/zJQ8ulCmvvMuA9y38=
X-Google-Smtp-Source: APiQypJDS6+xmYuy7ShucmxpoBa526M7IUnx2+GIok6Qd+RrQDQOkfiwZm+S6OVLYr/fG+tbj2BxgC2iXyF2OS+CoxI=
X-Received: by 2002:a2e:9a93:: with SMTP id p19mr1861345lji.77.1588689187806;
 Tue, 05 May 2020 07:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ea641705a350d2ee@google.com>
In-Reply-To: <000000000000ea641705a350d2ee@google.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 5 May 2020 23:32:56 +0900
Message-ID: <CAMArcTVqHzX94rDYds75MQL-h8h3zTZjt7ocv+nWhOOrR4cKMQ@mail.gmail.com>
Subject: Re: WARNING: proc registration bug in snmp6_register_dev
To:     syzbot <syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kuznet@ms2.inr.ac.ru,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020 at 07:46, syzbot
<syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    ab6f762f printk: queue wake_up_klogd irq_work only if per-..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1395613fe00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3010ccb0f380f660
> dashboard link: https://syzkaller.appspot.com/bug?extid=1d51c8b74efa4c44adeb
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> proc_dir_entry 'dev_snmp6/hsr1' already registered
> WARNING: CPU: 0 PID: 22141 at fs/proc/generic.c:363 proc_register+0x2bc/0x4e0 fs/proc/generic.c:362
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 22141 Comm: syz-executor.2 Not tainted 5.6.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1e9/0x30e lib/dump_stack.c:118
>  panic+0x264/0x7a0 kernel/panic.c:221
>  __warn+0x209/0x210 kernel/panic.c:582
>  report_bug+0x1ac/0x2d0 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:175 [inline]
>  do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:proc_register+0x2bc/0x4e0 fs/proc/generic.c:362
> Code: 08 4c 8b 74 24 28 48 8b 6c 24 20 74 08 48 89 ef e8 99 29 d1 ff 48 8b 55 00 48 c7 c7 24 4e e9 88 48 89 de 31 c0 e8 e4 7c 65 ff <0f> 0b 48 c7 c7 20 e6 32 89 e8 66 41 2a 06 48 8b 44 24 30 42 8a 04
> RSP: 0000:ffffc900088feec0 EFLAGS: 00010246
> RAX: f20851673ab1bb00 RBX: ffff8880908a5264 RCX: 0000000000040000
> RDX: ffffc9000df22000 RSI: 00000000000150b4 RDI: 00000000000150b5
> RBP: ffff88808981bc18 R08: ffffffff815cac69 R09: ffffed1015d06660
> R10: ffffed1015d06660 R11: 0000000000000000 R12: dffffc0000000000
> R13: 0000000000000004 R14: ffff88808981bbd4 R15: ffff88808981bb40
>  proc_create_single_data+0x18e/0x1e0 fs/proc/generic.c:631
>  snmp6_register_dev+0xa1/0x110 net/ipv6/proc.c:254
>  ipv6_add_dev+0x509/0x1430 net/ipv6/addrconf.c:408
>  addrconf_notify+0x5f8/0x3ad0 net/ipv6/addrconf.c:3503
>  notifier_call_chain kernel/notifier.c:83 [inline]
>  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
>  raw_notifier_call_chain+0xd4/0x170 kernel/notifier.c:368
>  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
>  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
>  call_netdevice_notifiers net/core/dev.c:1974 [inline]
>  register_netdevice+0x14a4/0x1a50 net/core/dev.c:9421
>  hsr_dev_finalize+0x425/0x6d0 net/hsr/hsr_device.c:486
>  hsr_newlink+0x3b5/0x460 net/hsr/hsr_netlink.c:77
>  __rtnl_newlink net/core/rtnetlink.c:3333 [inline]
>  rtnl_newlink+0x143e/0x1c00 net/core/rtnetlink.c:3391
>  rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5454
>  netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
>  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>  netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
>  netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  ____sys_sendmsg+0x4f9/0x7c0 net/socket.c:2362
>  ___sys_sendmsg net/socket.c:2416 [inline]
>  __sys_sendmsg+0x2a6/0x360 net/socket.c:2449
>  do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x45c889
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f007299ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f007299b6d4 RCX: 000000000045c889
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000006
> RBP: 000000000076c180 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 00000000000009fc R14: 00000000004ccb7c R15: 000000000076c18c
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>

This is hsr module bug.
When a hsr interface is being removed,
"/proc/net/dev_snmp6/<interface name>" is removed and it is created again
because of NETDEV_CHANGEMTU after NETDEV_UNREGISTER.
So, this resource can't be released in the RTNL mutex critical section.
This remained resources will be released by netdev_run_todo() but it is
not protected by RTNL mutex. So that creating a new interface
routine(rtnl_newlink()) can be executed concurrently.
This routine would try to create the same proc entry
("/proc/net/dev_snmp6/<interface name>")
At this point, this warning could occur.
In order to fix this problem, ->dellink() can be used.
But the patch would cause conflict with 34a9c361dd48
("hsr: remove hsr interface if all slaves are removed").
That commit is not merged into "net" branch yet.
So, I will send fix patch after the merge.

Test commands:
#SHELL1
ip link add dummy0 type dummy
ip link add dummy1 type dummy
ip link set dummy0 mtu 1300
while :
do
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
done
#SHELL2
while :
do
    ip link del hsr0
done

Thank you,
Taehee Yoo

>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
