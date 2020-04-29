Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321131BD2C2
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgD2DDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:03:04 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:39734 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgD2DDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 23:03:04 -0400
Received: by mail-il1-f198.google.com with SMTP id c11so1124689ilr.6
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 20:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=N8mW6W7Y78YylLmYnbJuNiFdBMiqWdbzuI1dVnHVmdY=;
        b=kHVuOM9HJ9LkEC5L4mD0wVFyYUAZXdNqSqENPdjNH5HzXzdjxxq7tfranvjUi1zDet
         DJ3B5MorMa5U5gJx526WFzT5Ml+rqraclny+X5uN95cztAPCKOvhB3GxI/zvQaixjK1p
         BeiLIXIfh5MR7KAWoTSjoOxUuZWBlLEBUGSFIM3v0FLueuZITUvqGd5drOoHAWIlil8X
         nTef368ja0BzLXnMw8WXEWcszPeYwOjrEVnAANx3Wt+C/3mkF1+nGBlqCCI+fmq1QFnl
         8qmqoyeyATZuupp17gwuuG8tSWeiBFk0tiLrMhFaJZk/H7EkIneVnWcml6KhD1VMnlpu
         gAFQ==
X-Gm-Message-State: AGi0PuZZ1Wd3sTomI52Uc3dPi/Us/MkadSsNAIj1cN32f1MdVvP0g7aC
        izEAAgbO/8DLEgRcOIdLnMscxtwYbkq29elKdJMTNX1ImWGd
X-Google-Smtp-Source: APiQypK+2ms6ncmWJOWhIQQVVliR9Zr/n/qv2KwLwCey7WgpXY/yCDsGr2fm1ZtCS3RqQpq8WFKsrGLw5CdokvGGfIGga6fJkuUN
MIME-Version: 1.0
X-Received: by 2002:a6b:8bd2:: with SMTP id n201mr8634223iod.131.1588129383557;
 Tue, 28 Apr 2020 20:03:03 -0700 (PDT)
Date:   Tue, 28 Apr 2020 20:03:03 -0700
In-Reply-To: <0000000000006601b005a08774fd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3b0f205a4652f38@google.com>
Subject: Re: general protection fault in tcf_action_destroy (2)
From:   syzbot <syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 0d1c3530e1bd38382edef72591b78e877e0edcd3
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Mar 12 05:42:28 2020 +0000

    net_sched: keep alloc_hash updated after hash allocation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e74154100000
start commit:   67d584e3 Merge tag 'for-5.6-rc6-tag' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=92a80fff3b3af6c4464e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160c3223e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f790ade00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net_sched: keep alloc_hash updated after hash allocation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
