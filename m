Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA73EA273
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhHLJth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhHLJtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 05:49:36 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7647DC061765;
        Thu, 12 Aug 2021 02:49:11 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id h9so9701382ljq.8;
        Thu, 12 Aug 2021 02:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WZthFEJ8KkVScOuLbPHTpjAuNA+7nGabUlW0Rl7a24I=;
        b=gQAIe4s/JBqyPC2P9fza8HJYUZN81+kqjnI22VMCWKwe+NR9427X3wvs1kSEi6eAo1
         bdJ+6Wp+tgNvDvq364U8Ti9Ol8S0UOcBJYioZBDuYf4OiQGOaKNyfdaDFImNam8+ZnHC
         ZqWm/OF1OSyPxNY0o8VfURVxyyRPOdwuiJvfDEydxAO36rHk0LpwzW+sao5c6fOz5ZeM
         5RkguveUEnnFoVfEGAbt/rmUa8WjY7+Y064+GAuffMU6tz/lRWvkqWaa3U5hONqYo9n4
         +OYw7G1bZia6DHLzjiR7YJGfrlCzSMznIaANI/Tt+KPnDo55Jg06DfVT5s9SNb+uDs10
         QgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZthFEJ8KkVScOuLbPHTpjAuNA+7nGabUlW0Rl7a24I=;
        b=Sc/mozIzc851k/ABNY+lSQjVEWnyNzwcda06QahKZesmH2n1ABnmgGrv5PWLbgF27O
         +eLWIWz4a5m9xO7frzF11YFaIqt41Tw0oXopqEy7e5ZxYpSPBnMUbyThHf7iKnoTyykT
         QmY2WDsAjYs1JmeT9kxh+aJmuJlqx5eeAEEzob6V5b+pE7kabw0MvKS1G+gn/jPFwWxB
         8t0qo4MTi55w9Lpu+yOPxtSsA8rIu61u8/c6Qd7d//N3QLXUHmHIFB4kvmeniOn215f2
         gh6dlr4N/98Mg28ahf3OlxxFPwgmxX6O5iogpAzmr6anYDCwYd5Pu9MddFeE5IpZew0n
         cdOQ==
X-Gm-Message-State: AOAM531ugzJo5DkHPBYKKQriJSJSegZ5KHqGkc4NDKl4gMalackjPFqV
        1YPJbZlZYLSU1zk4v8OXvlA=
X-Google-Smtp-Source: ABdhPJwMzL2bT90OERiDPxPbF40q7QMmktAMESdfa9kh3Jt60pD+CeEdOxHjIF65kkSV0YNZhxdH6g==
X-Received: by 2002:a05:651c:902:: with SMTP id e2mr1490792ljq.198.1628761749825;
        Thu, 12 Aug 2021 02:49:09 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id l24sm208328lfe.272.2021.08.12.02.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 02:49:09 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in hci_req_sync
To:     syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000c5482805c956a118@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <9365fdfa-3cee-f22e-c53d-6536a96d27ae@gmail.com>
Date:   Thu, 12 Aug 2021 12:49:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000c5482805c956a118@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/21 9:13 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c9194f32bfd9 Merge tag 'ext4_for_linus_stable' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1488f59e300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
> dashboard link: https://syzkaller.appspot.com/bug?extid=be2baed593ea56c6a84c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b5afc6300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcd192300000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17dce4fa300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=143ce4fa300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=103ce4fa300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
> 
> INFO: task syz-executor446:8489 blocked for more than 143 seconds.
>        Not tainted 5.14.0-rc4-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor446 state:D stack:28712 pid: 8489 ppid:  8452 flags:0x00000000
> Call Trace:
>   context_switch kernel/sched/core.c:4683 [inline]
>   __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
>   schedule+0xd3/0x270 kernel/sched/core.c:6019
>   schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
>   __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>   __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
>   hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
>   hci_inquiry+0x6f4/0x9e0 net/bluetooth/hci_core.c:1357
>   hci_sock_ioctl+0x1a7/0x910 net/bluetooth/hci_sock.c:1060
>   sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
>   sock_ioctl+0x477/0x6a0 net/socket.c:1221
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:1069 [inline]
>   __se_sys_ioctl fs/ioctl.c:1055 [inline]
>   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x446449
> RSP: 002b:00007f36ab8342e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004cb400 RCX: 0000000000446449
> RDX: 00000000200000c0 RSI: 00000000800448f0 RDI: 0000000000000004
> RBP: 00000000004cb40c R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffffffffffff R11: 0000000000000246 R12: 0000000000000003
> R13: 0000000000000004 R14: 00007f36ab8346b8 R15: 00000000004cb408
> INFO: task syz-executor446:8491 blocked for more than 143 seconds.
>        Not tainted 5.14.0-rc4-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor446 state:D stack:28176 pid: 8491 ppid:  8452 flags:0x00000004
> Call Trace:
>   context_switch kernel/sched/core.c:4683 [inline]
>   __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
>   schedule+0xd3/0x270 kernel/sched/core.c:6019
>   schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
>   __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>   __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
>   hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
>   hci_inquiry+0x6f4/0x9e0 net/bluetooth/hci_core.c:1357
>   hci_sock_ioctl+0x1a7/0x910 net/bluetooth/hci_sock.c:1060
>   sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
>   sock_ioctl+0x477/0x6a0 net/socket.c:1221
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:1069 [inline]
>   __se_sys_ioctl fs/ioctl.c:1055 [inline]
>   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x446449
> RSP: 002b:00007f36ab8342e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004cb400 RCX: 0000000000446449
> RDX: 00000000200000c0 RSI: 00000000800448f0 RDI: 0000000000000004
> RBP: 00000000004cb40c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 0000000000000004 R14: 00007f36ab8346b8 R15: 00000000004cb408
> 
> Showing all locks held in the system:
> 6 locks held by kworker/u4:0/8:
> 1 lock held by khungtaskd/1635:
>   #0: ffffffff8b97c180 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
> 1 lock held by in:imklog/8352:
>   #0: ffff888033e1d4f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
> 1 lock held by syz-executor446/8486:
>   #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
> 1 lock held by syz-executor446/8489:
>   #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
> 1 lock held by syz-executor446/8491:
>   #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
> 

Looks like too big timeout is passed from ioctl:


C repro:

     *(uint16_t*)0x200000c0 = 0;
     *(uint16_t*)0x200000c2 = 0;
     memcpy((void*)0x200000c4, "\xf0\x08\xa7", 3);
     *(uint8_t*)0x200000c7 = 0x81;	<- ir.length
     *(uint8_t*)0x200000c8 = 0;
     syscall(__NR_ioctl, r[0], 0x800448f0, 0x200000c0ul);


Then ir.length * msecs_to_jiffies(2000) timeout is passed to
hci_req_sync(). Task will stuck here

	err = wait_event_interruptible_timeout(hdev->req_wait_q,
			hdev->req_status != HCI_REQ_PEND, timeout);

for 258 seconds (I guess, it's because of test environment, but, maybe, 
we should add sanity check for timeout value)



With regards,
Pavel Skripkin
