Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0847C22D517
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 07:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGYFLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 01:11:05 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52656 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGYFLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 01:11:05 -0400
Received: by mail-il1-f198.google.com with SMTP id o17so7142896ilt.19
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 22:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OxvLZmqjPIgyfFJFD3jU0NCXtLqtMkM6RdMtuDq0MCs=;
        b=eD8a159vhKP7HoXgFUPuC7vlE4+ZY0CQma2QuEMC0j3iL0dFAJI5Kzy4HWb+2rZQEB
         YDRl0If92YgbMvwp6Gjjt63amMzEvuchpzEox4TrpJAq/SZ2WRF3y1jIE7ZQmRPlrfOv
         uCJVl9rcciBwPLvHPJiEe5ucivW3VGwjdt08ceRC9lEq/T9u1IWKSoY/CWBIoTiDfUFB
         9euehVZ9rQxg7uscWlBsHFMF3klETRbX5WrAmE8mRH1tmXCESiI+SAVbprHhjtYQPGol
         NRS/AsAxIoI1kts8myckfP4vn+qh/Qi56IaEV/cki9IEKDuVasg7Xv/5y1tWcHxjD7/T
         hA0w==
X-Gm-Message-State: AOAM531gkbTU4klCCNthxqaeRg1cNaQfA+UB3Q14ky3cFcqd42qqWj+J
        NfUz8YCnEx7ZRClbb0lXXVxcIPksDhauwMtDssxSJUS3NCoY
X-Google-Smtp-Source: ABdhPJz7r05qYNwD8iAc+QKC+Tc9C8Eqv0mYlaRsqfEyEpJszHU46Z43bkEBNCZQUn51WRKL3DEvQ3smKEI3RDnTLqC1oTSQ+4/l
MIME-Version: 1.0
X-Received: by 2002:a92:c912:: with SMTP id t18mr10628820ilp.186.1595653864438;
 Fri, 24 Jul 2020 22:11:04 -0700 (PDT)
Date:   Fri, 24 Jul 2020 22:11:04 -0700
In-Reply-To: <000000000000402c5305ab0bd2a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c641a505ab3d1d48@google.com>
Subject: Re: INFO: task hung in synchronize_rcu (3)
From:   syzbot <syzbot+0c6da80218456f1edc36@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vinicius.gomes@intel.com, viro@zeniv.linux.org.uk,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=149057ef100000
start commit:   4fa640dc Merge tag 'vfio-v5.8-rc7' of git://github.com/awi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=169057ef100000
console output: https://syzkaller.appspot.com/x/log.txt?x=129057ef100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=0c6da80218456f1edc36
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e2a437100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13af00e8900000

Reported-by: syzbot+0c6da80218456f1edc36@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
