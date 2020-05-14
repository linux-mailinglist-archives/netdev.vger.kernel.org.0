Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16161D2F98
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgENMY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726389AbgENMY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 08:24:57 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D5AC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 05:24:57 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b1so2646344qtt.1
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 05:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MDY/jqEtMAaYkrjcBwZZMUT5NqpDPZcVLijHWxBZHSY=;
        b=lbnbOpBUQPKdKhj2u3py/03HGz9QAQfhsW70J/4zygpGvFtl8OOJJ/KJMlEjyfPGt2
         F1AOQyEoDJP1HwOoxItNFlGL+F7fif5limeDvIbQhilhARhvXa8x2BQIPXXdICR4afIf
         q4uZKeUukSEG42qu1q4bLsFwaG2LnilC09lm3bCUVAxgn5NW8N6sgf/EsEIMQNqpQN2x
         FeWZcyN3qoeOCh6acZqay6yCytynnk9CvZ1tYWIh/PAYT5xW3555VdLmBMrRLJpxI9yG
         U+ZqFBmyOpCTX1TrvZGvtwPAu0KWE3BUw7Gim4BgahsMoOuqGSnpR+oSw/SbkiQTtNz0
         PFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MDY/jqEtMAaYkrjcBwZZMUT5NqpDPZcVLijHWxBZHSY=;
        b=Lz1me2uXMYQV4i4QgsMz2oCXx6csnJ9CoF331uqFbEZ7V8mLCqA520YM2n2rUydhmi
         V/52PJbNibUnD05PoiK+a7KPjJZTf0/5ovkPjh6pzgTEH6AnuTrDhWvZeVoDxTvLxnl4
         EHwAcode4cBCGld1/fDbOQ5n9d6J7DpJiWJ7J3HY1kuuLupX8OGTuAOBFZZL1KBlhKPD
         yta3t8bidL7oN9FhzW9fhlLEiVVuLk0cZL3KHZdlfaXDqUrfwC3c+OTcUXf9rA1tELvM
         iBKMGCGGiNpkgAyL6GlfRl5eSIvdgLq+3cR4fLz/RYepwhEmHqIJnWaQFXcqxOIo+/MN
         CHLg==
X-Gm-Message-State: AOAM533MiCTZ4z2vVPxiC51x1XNR9Hlw9+tFbSCV00+V+xiR9ED1zxzJ
        DJwa67jVguNbR1gl/qfzE5OVtw==
X-Google-Smtp-Source: ABdhPJy6ecg3eHEDh7Mm+mkG7MxI7G9M2y1I86Os1RTwzez2Z9Qi/SSJwX7yVhb0PPWXQudP4Pm94w==
X-Received: by 2002:ac8:1418:: with SMTP id k24mr4182324qtj.344.1589459096400;
        Thu, 14 May 2020 05:24:56 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id i59sm2439299qtb.58.2020.05.14.05.24.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 May 2020 05:24:55 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 bpq_device_event
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <000000000000785a6905a59a1e4a@google.com>
Date:   Thu, 14 May 2020 08:24:54 -0400
Cc:     allison@lohutok.net, ap420073@gmail.com,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A19DAE77-5DCD-460A-88E5-437450CBD50B@lca.pw>
References: <000000000000785a6905a59a1e4a@google.com>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Amol Grover <frextrite@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 14, 2020, at 7:37 AM, syzbot =
<syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    c9529331 Add linux-next specific files for 20200514
> git tree:       linux-next
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D17119f48100000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D404a80e135048067
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dbb82cafc737c002d11ca
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the =
commit:
> Reported-by: syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> 5.7.0-rc5-next-20200514-syzkaller #0 Not tainted
> -----------------------------
> drivers/net/hamradio/bpqether.c:149 RCU-list traversed in non-reader =
section!!

How about teaching the bot to always CC Madhuparna and Amol for those =
RCU-list bug reports?

>=20
> other info that might help us debug this:
>=20
>=20
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by ip/3967:
> #0: ffffffff8a7bad88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock =
net/core/rtnetlink.c:72 [inline]
> #0: ffffffff8a7bad88 (rtnl_mutex){+.+.}-{3:3}, at: =
rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5458
>=20
> stack backtrace:
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 01/01/2011
> Call Trace:
> __dump_stack lib/dump_stack.c:77 [inline]
> dump_stack+0x18f/0x20d lib/dump_stack.c:118
> bpq_get_ax25_dev drivers/net/hamradio/bpqether.c:149 [inline]
> bpq_device_event+0x796/0x8ee drivers/net/hamradio/bpqether.c:538
> notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
> call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
> call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
> call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
> call_netdevice_notifiers net/core/dev.c:2042 [inline]
> __dev_notify_flags+0x121/0x2c0 net/core/dev.c:8279
> dev_change_flags+0x100/0x160 net/core/dev.c:8317
> do_setlink+0xa1c/0x35d0 net/core/rtnetlink.c:2605
> __rtnl_newlink+0xad0/0x1590 net/core/rtnetlink.c:3273
> rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
> rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
> netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
> netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
> netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
> sock_sendmsg_nosec net/socket.c:652 [inline]
> sock_sendmsg+0xcf/0x120 net/socket.c:672
> ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
> ___sys_sendmsg+0x100/0x170 net/socket.c:2406
> __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
> do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x7f76dcdfcdc7
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 8b 05 =
4a 49 2b 00 85 c0 75 2e 48 63 ff 48 63 d2 b8 2e 00 00 00 0f 05 <48> 3d =
00 f0 ff ff 77 01 c3 48 8b 15 a1 f0 2a 00 f7 d8 64 89 02 48
> RSP: 002b:00007ffd45eccf28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000005ebd27cd RCX: 00007f76dcdfcdc7
> RDX: 0000000000000000 RSI: 00007ffd45eccf70 RDI: 0000000000000003
> RBP: 00007ffd45eccf70 R08: 0000000000001000 R09: fefefeff77686d74
> R10: 00000000000005e9 R11: 0000000000000246 R12: 00007ffd45eccfb0
> R13: 0000561a2ddea3c0 R14: 00007ffd45ed5030 R15: 0000000000000000
> ip (3967) used greatest stack depth: 23144 bytes left
>=20
>=20
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

