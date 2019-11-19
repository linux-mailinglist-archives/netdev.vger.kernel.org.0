Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BD91015B4
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 06:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbfKSFqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 00:46:32 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37898 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbfKSFq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 00:46:28 -0500
Received: by mail-io1-f66.google.com with SMTP id i13so21803812ioj.5;
        Mon, 18 Nov 2019 21:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=15sG7WwI0A4mLcXUEC+53crFGzOHHgMla1N2x01sfjo=;
        b=WvTAPYhXX54zb7iIe8XI0y2w8S/kGWn+mXUmBWnSNk+MIKmuUqI+GdjGjzwFhhbgqO
         zRItWR3OrKQfmy4PNbeT50h1X0gHZ0Nmh2V9zNrO43dlMW0qv/mFf+XEMotxf3qCoiKb
         EzmrY3P40wJkVBSaXrDpMJBDsscptZAvNnLrNzkiQwSA0B+31jmRTLp3MnRDaHxn9Uht
         T7hkl0s1jsxpvfHc4/1nfyKKLKxOI21MCjhp7b7fjlrIIZ3dTHd9+AIrbVtg3VtJSG4K
         GynzppgBItTv7EHv5wFstrV7ny8S2ylmbmXlkBVquPjQbei7ufBqquaFg0K4JBHJ0V5n
         vsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=15sG7WwI0A4mLcXUEC+53crFGzOHHgMla1N2x01sfjo=;
        b=W1ymI/pSIwU+q/m1O6chgUL6Vh59qqqhKG8E74VyHwMs56xTElSBTO2v8yRl4Nbfhz
         LaI+X++n6pfdx7xRZ43Rq7OJDSgidq5LT5kW+PZibJXvK7gOhGOuNl8JoqhAbFCCj5CM
         u9vAXVglNQzg+9qtlVDiQ5fBCc8kMxpPoDW+oVvFmGlHtFCG6Gl7jWDbXXeHe2dkO6GR
         5QisWsZMU1MKj++sUfx7oqtUIuA2Me5xe5tfMmPR0oiLx197hBxotGoelOO4zwxOKprH
         do6tw9fQX0llP/K/YGlf36ABkQTo6FjINtC5K9AV8nPmYDYIjLZuBi0DYDMP5ZfqiUH/
         WJGg==
X-Gm-Message-State: APjAAAXFNGprFlXc2eufiwADtg6V9f7RtkCpWcxLvG5sD3JABuEHfiso
        BwNhCEtmhgaGbOErMvlQW3M=
X-Google-Smtp-Source: APXvYqxAs/BZjfOp2KYg7JxU3+VBmTY/1oL+KTB92gYTrvi34a/3tnXsMN9XN4jhXA1matMnBkd9JA==
X-Received: by 2002:a05:6638:68f:: with SMTP id i15mr17305616jab.37.1574142386999;
        Mon, 18 Nov 2019 21:46:26 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q69sm5171521ilb.4.2019.11.18.21.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 21:46:26 -0800 (PST)
Date:   Mon, 18 Nov 2019 21:46:17 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        syzbot <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Message-ID: <5dd381a974490_613b2afc5fa285c45a@john-XPS-13-9370.notmuch>
In-Reply-To: <20191119052912.GM163020@sol.localdomain>
References: <0000000000009b3b80058af452ae@google.com>
 <0000000000000ec274059185a63e@google.com>
 <CACT4Y+aT5z65OZE6_TQieU5zUYWDvDtAogC45f6ifLkshBK2iw@mail.gmail.com>
 <20191017162505.GB726@sol.localdomain>
 <20191017163007.GC726@sol.localdomain>
 <20191119052912.GM163020@sol.localdomain>
Subject: Re: kernel panic: stack is corrupted in __lock_acquire (4)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Biggers wrote:
> On Thu, Oct 17, 2019 at 09:30:07AM -0700, Eric Biggers wrote:
> > On Thu, Oct 17, 2019 at 09:25:05AM -0700, Eric Biggers wrote:
> > > On Sun, Sep 01, 2019 at 08:23:42PM -0700, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> > > > On Sun, Sep 1, 2019 at 3:48 PM syzbot
> > > > <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > syzbot has found a reproducer for the following crash on:
> > > > >
> > > > > HEAD commit:    38320f69 Merge branch 'Minor-cleanup-in-devlink'
> > > > > git tree:       net-next
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13d74356600000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=1bbf70b6300045af
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=83979935eb6304f8cd46
> > > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1008b232600000
> > > > 
> > > > Stack corruption + bpf maps in repro triggers some bells. +bpf mailing list.
> > > > 
> > > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > > Reported-by: syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com
> > > > >
> > > > > Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:
> > > > > __lock_acquire+0x36fa/0x4c30 kernel/locking/lockdep.c:3907
> > > > > CPU: 0 PID: 8662 Comm: syz-executor.4 Not tainted 5.3.0-rc6+ #153
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > > > Google 01/01/2011
> > > > > Call Trace:
> > > > > Kernel Offset: disabled
> > > > > Rebooting in 86400 seconds..
> > > > >
> > > 
> > > This is still reproducible on latest net tree, but using a different kconfig I
> > > was able to get a more informative crash output.  Apparently tcp_bpf_unhash() is
> > > being called recursively.  Anyone know why this might happen?
> > > 
> > > This is using the syzkaller language reproducer linked above -- I ran it with:
> > > 
> > > 	syz-execprog -threaded=1 -collide=1 -cover=0 -repeat=0 -procs=8 -sandbox=none -enable=net_dev,net_reset,tun syz_bpf.txt
> > > 
> > > Crash report on net/master:
> > > 
> > > PANIC: double fault, error_code: 0x0
> > > CPU: 3 PID: 8328 Comm: syz-executor Not tainted 5.4.0-rc1-00118-ge497c20e2036 #31
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
> > > RIP: 0010:mark_lock+0x4/0x640 kernel/locking/lockdep.c:3631
> > > Code: a2 7f 27 01 85 c0 0f 84 f3 42 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 <41> 57 41 56 41 55 41 54 53 48 83 ec 18 83 fa 08 76 21 44 8b 25 ab
> > > RSP: 0018:ffffc9000010d000 EFLAGS: 00010046
> > > RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> > > RDX: 0000000000000008 RSI: ffff888071f92dd8 RDI: ffff888071f92600
> > > RBP: ffffc9000010d000 R08: 0000000000000000 R09: 0000000000022023
> > > R10: 00000000000000c8 R11: 0000000000000000 R12: ffff888071f92600
> > > R13: ffff888071f92dd8 R14: 0000000000000023 R15: 0000000000000000
> > > FS:  00007ff9f7765700(0000) GS:ffff88807fd80000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: ffffc9000010cff8 CR3: 000000000221d000 CR4: 00000000003406e0
> > > Call Trace:
> > >  <IRQ>
> > >  mark_usage kernel/locking/lockdep.c:3592 [inline]
> > >  __lock_acquire+0x22f/0xf80 kernel/locking/lockdep.c:3909
> > >  lock_acquire+0x99/0x170 kernel/locking/lockdep.c:4487
> > >  rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
> > >  rcu_read_lock include/linux/rcupdate.h:599 [inline]
> > >  tcp_bpf_unhash+0x33/0x1d0 net/ipv4/tcp_bpf.c:549
> > >  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
> > >  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
> > >  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
> > >  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
> > [...]
> > 
> > Recursive tcp_bpf_unhash() also showed up in
> > "BUG: unable to handle kernel paging request in tls_prots"
> > (https://lkml.kernel.org/lkml/000000000000d7bcbb058c3758a1@google.com/T/)
> > which was claimed to be fixed by
> > "bpf: sockmap/tls, close can race with map free".
> > But that fix was months ago; this crash is on latest net tree.
> > 
> 
> Is anyone planning to look into this?  This is still occurring on net-next
> (4 days ago).
> 
> - Eric

I'll take a look in the morning thanks.

.John
