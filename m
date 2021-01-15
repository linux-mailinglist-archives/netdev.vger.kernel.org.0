Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEABC2F882D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbhAOWHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:07:54 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:53372 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbhAOWHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 17:07:54 -0500
Received: by mail-io1-f70.google.com with SMTP id a19so7689558ioq.20
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 14:07:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ni8yaQuabPx7HTWh4ePzjfz8VlgGJ45ofwREdAgCaIA=;
        b=M9f7slHbM4MxgV8EZnRQJXaSRMKLdpGM2sPVoEPG3tnMZ2ajmrFgqlEY/Nc0UwWB/g
         Ew5mx0J6OJ9kMZc3/M3NAPS/g4wsRKVpNXVww4sCwkuvS1bF0Z/D3lSX7EHjpIrgF9xK
         BcZarKfKK1z2fkne9eiXP8qedWLqsnPry7S47fCzhgo+9WDAhCqRajT2ERGNWPTUhLJx
         rEmqOFcq449nEtpI11M1zU1crhCrEZwb5Iq43qdZKEVRa04N4AK//nEEs7BfvOvBe1SE
         7UsnxSdoYxPz0XThJzxjx6enTQgTO3EWREgSIcpnO9minQLvKHIohZndsoQQ1n0PEio3
         cRDQ==
X-Gm-Message-State: AOAM533OkwS2v78EaQ2+Dy1yNFG+JlyW8RpkSmu9wjbtNHpYhXlAWAge
        hdx+eD6pMuLcTRAtFz94FTc/7VY72P+L+XUfRTQCFWe/gaYc
X-Google-Smtp-Source: ABdhPJwl5lqi00q3NK/YL4hxeMbwf8+7Xw7x+Xx7N2oQtjO9QTWtGNrmxRFpAhlx4fn68gu+vAWrPashN7vHa2ezNTX9R9pKv/+c
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr12778970ilj.155.1610748433062;
 Fri, 15 Jan 2021 14:07:13 -0800 (PST)
Date:   Fri, 15 Jan 2021 14:07:13 -0800
In-Reply-To: <0000000000005d946305a9f5d206@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ce11a05b8f7980a@google.com>
Subject: Re: INFO: rcu detected stall in sock_close (3)
From:   syzbot <syzbot+4168fa4c45be33afa73c@syzkaller.appspotmail.com>
To:     Markus.Elfring@web.de, axboe@kernel.dk,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        ebiederm@xmission.com, fweisbec@gmail.com, hdanton@sina.com,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org, oleg@redhat.com,
        pcc@google.com, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tipc-discussion@lists.sourceforge.net, tuong.t.lien@dektech.com.au,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 98b89b649fce39dacb9dc036d6d0fdb8caff73f7
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Oct 9 22:03:01 2020 +0000

    signal: kill JOBCTL_TASK_WORK

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b99c20d00000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=4168fa4c45be33afa73c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112223b7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154793a3100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: signal: kill JOBCTL_TASK_WORK

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
