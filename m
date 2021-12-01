Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AA4465768
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbhLAUxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:53:54 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56215 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239866AbhLAUx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:53:29 -0500
Received: by mail-io1-f69.google.com with SMTP id y74-20020a6bc84d000000b005e700290338so30138355iof.22
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 12:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=X/WRQR8STDSXJRhWuJ7l+MpIYKViU5igfD9Z/w6cwnE=;
        b=uYwCNoDv8DoiMIoj31HU3QUQKqp3uBcxYY7Oe9JwwxPVVdWEFuN3oHd3eoMuxrNsUS
         eLB2UP5XB3tuvGfqTrHL4IghPtPbt6mgpsRYjAo1hL7JANpMYCuqKr4U3DG2Z/1vpMKE
         yxd0I5J79kETXc3T14FyYz4V9q1rYRPruJYjhScIIJfpi7nfiVUViraeVl7fBbKos6nJ
         c39o3x2ce/5jWqvvrLudoq2mCXQRXesHZKT9g2tAw9ZTUl89hUS9DN6+Uz4VaTwG4RY9
         TiNSsljmNHx5HTT9PE1aMjv/Rww2WEJb5tNs0poRRsTeMqpr6OWGpOYjL5BBzuM4Uotd
         q2Qw==
X-Gm-Message-State: AOAM531n4WKTsuyHXPG+6Q6c7D7d43ry8cttZa5NkW76GNS6mllmlF4V
        WKtq3TuMOTNfPG4zfyACAj0bNuSNEF+GvcsQnRpnDyQaSr9W
X-Google-Smtp-Source: ABdhPJxwnTjayukxQsPm7f3vzoFuy8C1JldbQMohbfblKSqInY3rP+nF24H24uBktfOukSFRQgYKFbRtf7c4JSZgMRbBhRziF+lR
MIME-Version: 1.0
X-Received: by 2002:a92:d291:: with SMTP id p17mr1253204ilp.154.1638391807990;
 Wed, 01 Dec 2021 12:50:07 -0800 (PST)
Date:   Wed, 01 Dec 2021 12:50:07 -0800
In-Reply-To: <00000000000069924b05c8cc3b84@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7e3ee05d21bd19d@google.com>
Subject: Re: [syzbot] WARNING in trc_read_check_handler
From:   syzbot <syzbot+fe9d8c955bd1d0f02dc1@syzkaller.appspotmail.com>
To:     bigeasy@linutronix.de, jgross@suse.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, namit@vmware.com, netdev@vger.kernel.org,
        paulmck@kernel.org, peterz@infradead.org, rcu@vger.kernel.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 96017bf9039763a2e02dcc6adaa18592cd73a39d
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Wed Jul 28 17:53:41 2021 +0000

    rcu-tasks: Simplify trc_read_check_handler() atomic operations

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1281d89db00000
start commit:   5319255b8df9 selftests/bpf: Skip verifier tests that fail ..
git tree:       bpf-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
dashboard link: https://syzkaller.appspot.com/bug?extid=fe9d8c955bd1d0f02dc1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14990477300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ebd84b00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: rcu-tasks: Simplify trc_read_check_handler() atomic operations

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
