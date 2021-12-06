Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345C546A54E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348172AbhLFTGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhLFTGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:06:20 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7170C061746;
        Mon,  6 Dec 2021 11:02:51 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id t8so11274171ilu.8;
        Mon, 06 Dec 2021 11:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=DGKaEcXL8IOy/SVzbuQAC3UpZ4Q1Y1ENlH6uq7i+0Hw=;
        b=JdkupEYh9uGJbqMf0WCdukWqjLlIqPy3WUA3x8qfq0Jl3Dd2Q05Gsy0hAS5HhjbiLl
         xHNpVRYYclUMPrcFDuFQKYAWoqxfrfMp1GLI+MxjrhFjGQuSMEkNmiU8ISvIvM2SGVCD
         kSRqi0c6EZWSt0vAvbGjfDL1ouQHT8J92jw2n8nRb5h4LHxqXJA6qgIcZEsXnutZjpA7
         HruZUMb+CWIv5qGMZDBBEJ0B9SqtmsLkdZYUhL9G6ngMKYY6O6cP/KhfrXtDcCwC1ndL
         r6RUUqRMmyeSzq/1GHSgZvoJx5NyuI83y1TZV0VNE1Q5hbFSNsERiSYUWeMfMeGo6Nlo
         yONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=DGKaEcXL8IOy/SVzbuQAC3UpZ4Q1Y1ENlH6uq7i+0Hw=;
        b=tuDoN1TJ/haPEzioeLCZSrvpLsspd3L/VO79dtHBcJj0nzYKUhzHoMik2h3/K8AopB
         4UYNag88x9kjjZTXr+D1nH4yTNBGyZcq+baLU3paZRWVUw13BSgFw4AOJYXdsbmxWfOc
         rkutxNH2MaztFUH8n5VARtQzdT/7+d1DvTyAU2VPm8qhpHGC6fKo2oI0iDDSFDXy4Uwh
         vyXOjpR1YX8uFcw4lbOYAVlGK3aap1cY8xXKm8UCZdDoM8RCNknUltyBtLnZXqpmluVN
         K8ehJ1OKzR+EA1V931aKxw8hxVffKmdDCRQZglHfnaGUQKqC+YkwkiQ7Hv/bVKvpGsyi
         elZQ==
X-Gm-Message-State: AOAM533PPwqUWcLfkGCYaxYHGKcQRjX7IO455I827dWH388qY8z2ocfV
        eQmndMvOVwcuO9kHaF5ho5EaEqZ6tUZ3Lw==
X-Google-Smtp-Source: ABdhPJzW8cN3NemLiQ02j3NaTMiMGE75FnmsuoXR5qLQCsVp0c1Y6d5j2G3ltIgD6TAWzL3Xr1G2EA==
X-Received: by 2002:a05:6e02:12cb:: with SMTP id i11mr32239553ilm.12.1638817371156;
        Mon, 06 Dec 2021 11:02:51 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id r1sm4434540ilo.38.2021.12.06.11.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:02:50 -0800 (PST)
Date:   Mon, 06 Dec 2021 11:02:42 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+5027de09e0964fd78ce1@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Message-ID: <61ae5e52b9712_c5bd2082e@john.notmuch>
In-Reply-To: <000000000000367c2205d2549cb9@google.com>
References: <000000000000367c2205d2549cb9@google.com>
Subject: RE: [syzbot] KASAN: vmalloc-out-of-bounds Read in __bpf_prog_put
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ce83278f313c Merge branch 'qed-enhancements'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c8ce3ab00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b5949d4891208a1b
> dashboard link: https://syzkaller.appspot.com/bug?extid=5027de09e0964fd78ce1
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5027de09e0964fd78ce1@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put.constprop.0+0x1dd/0x220 kernel/bpf/syscall.c:1812
> Read of size 8 at addr ffffc90000cf2038 by task kworker/0:24/16179
> 
> CPU: 0 PID: 16179 Comm: kworker/0:24 Not tainted 5.16.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events sk_psock_destroy
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xf/0x320 mm/kasan/report.c:247
>  __kasan_report mm/kasan/report.c:433 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
>  __bpf_prog_put.constprop.0+0x1dd/0x220 kernel/bpf/syscall.c:1812
>  psock_set_prog include/linux/skmsg.h:477 [inline]
>  psock_progs_drop include/linux/skmsg.h:495 [inline]
>  sk_psock_destroy+0xad/0x620 net/core/skmsg.c:804
>  process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
>  kthread+0x405/0x4f0 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> 
> 
> Memory state around the buggy address:
>  ffffc90000cf1f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffc90000cf1f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >ffffc90000cf2000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>                                         ^
>  ffffc90000cf2080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffc90000cf2100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

I'll take look some psock issue here.
