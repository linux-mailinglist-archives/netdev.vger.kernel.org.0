Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C562AB5BB
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgKILDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:03:06 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48784 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbgKILDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:03:06 -0500
Received: by mail-il1-f198.google.com with SMTP id o5so6147280ilh.15
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:03:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RC1F7ktIPdtkjf9WZxb33quJkR4mZqslLpcDaMizXIQ=;
        b=QBHmve8DHzh3tmvWNY+QXSVEyNbF20oZO8z+VB9Tp+CgnMYsoCXypgu5YYNTm1mXhd
         RL45I9WG/FKJZJzO77Q96a/DRl09np+uoXiXmhSPpfgYHEUMKvffWy+35BwVFqh31baQ
         u7ZhVvUTDs/5TBosK/p6E/ch6O5mYynoCaUFwHysnQlOTptXhG35j5fH9WBMlbjT4ElW
         RtytoGok0VpbfCTuQZhJb1Uqak18h5IU1h5sjH2IaAr3hC7kt85AsQWDTGEf5HtNtJ7B
         ycEwBGEOVMKht1o5Sc4Q6JHAVUWHLWRkKfQRt3e9NdrejT43F5GDG7eqvYLtaGCi4t6t
         2b6w==
X-Gm-Message-State: AOAM531s+mVySzNhWtU8oHzuHzL2VYNWtnOHvWFd09hCueYvYLDoXTLv
        2tV9bgrqjbXhrdinOLRI8v1c0HMHPwDMTA3ewJdlrrehf7LH
X-Google-Smtp-Source: ABdhPJywQbYbN3++ou8k2gB6sjlyy0rEKh+k8IYljtbeI93rm6pObmoUSlPtAT1Ld4D0aDBhwcdPxIgVjgAK/RKW4DgHAskDUE5K
MIME-Version: 1.0
X-Received: by 2002:a92:d5d0:: with SMTP id d16mr10009802ilq.223.1604919785429;
 Mon, 09 Nov 2020 03:03:05 -0800 (PST)
Date:   Mon, 09 Nov 2020 03:03:05 -0800
In-Reply-To: <000000000000a48f9e05aef6cce1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4227e05b3aa8101@google.com>
Subject: Re: INFO: rcu detected stall in exit_group
From:   syzbot <syzbot+1a14a0f8ce1a06d4415f@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, dhowells@redhat.com, fweisbec@gmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mareklindner@neomailbox.ch,
        mike.kravetz@oracle.com, mingo@kernel.org, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6
Author: David Howells <dhowells@redhat.com>
Date:   Fri Oct 16 12:21:14 2020 +0000

    afs: Fix cell removal

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b65c3a500000
start commit:   34d4ddd3 Merge tag 'linux-kselftest-5.9-rc5' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
dashboard link: https://syzkaller.appspot.com/bug?extid=1a14a0f8ce1a06d4415f
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c6642d900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132d00fd900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: afs: Fix cell removal

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
