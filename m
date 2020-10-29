Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D1E29F93D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJ2XtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:49:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:50176 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgJ2XtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:49:06 -0400
Received: by mail-io1-f72.google.com with SMTP id l17so3090062iol.17
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 16:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7hk9TAk77DHYI/kt84nHphsd4t0j8ackh+hIcD9azRA=;
        b=TEqUpyJXiXlTX0hjFBo3+xRpWI9VW8ncyNM+iSONumHJQlqztAKad9sthoQbB3PhOk
         77SZLT9eBZLVbLrL6qlBLuPRpuEEHue1wQphT7SyQdIDhDW/pSieekGQIEXfVSs1ZLKW
         1iyaIEXU4xFgr9RcJSfFglONaGBL25udCzsrr7O3dtyIZfpnFz2X2Yl4g8Tzt0IBWwNG
         qqjzNacuo7xxfYfSPM+i2uQLwbkShGePbZKdtoIsQ42uTTa/zk75NaOSeA7pckNM2jV3
         yRbxjBDTSWVm3j2Ra4xlo0Tf9RbFckbQgc2wD1MTvUz7X53qwnUML8LyLRJ4L4ZcCNhs
         WEyQ==
X-Gm-Message-State: AOAM533zqY3Wda2lTVDXlGFkbozkJ+TM3Ou7XOdTcYozDwWyM3qmWi6t
        2QK0JiZsYbnBwSR62c4L8CRhRMiSv8C+kiDDuaaV3H3TU+Xs
X-Google-Smtp-Source: ABdhPJz6K8mon/7XpZee7kuOHWkBYo0uS+iOWapJ5rphJshKApo1O0v13M/qqv/Tjl2G6Owe5vvRA42KTOQIJB6nBYdm8sB9h+VV
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3f1:: with SMTP id s17mr5648658jaq.102.1604015345410;
 Thu, 29 Oct 2020 16:49:05 -0700 (PDT)
Date:   Thu, 29 Oct 2020 16:49:05 -0700
In-Reply-To: <000000000000bd1edd05b087535a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e0a53705b2d7ec44@google.com>
Subject: Re: INFO: rcu detected stall in security_file_open (3)
From:   syzbot <syzbot+d2b6e8cc299748fecf25@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, dhowells@redhat.com, fweisbec@gmail.com,
        ktkhai@virtuozzo.com, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, miklos@szeredi.hu, mingo@kernel.org,
        mszeredi@redhat.com, netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6
Author: David Howells <dhowells@redhat.com>
Date:   Fri Oct 16 12:21:14 2020 +0000

    afs: Fix cell removal

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14bc220a500000
start commit:   fb0155a0 Merge tag 'nfs-for-5.9-3' of git://git.linux-nfs...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=41b736b7ce1b3ea4
dashboard link: https://syzkaller.appspot.com/bug?extid=d2b6e8cc299748fecf25
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1249c717900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1048d9e3900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: afs: Fix cell removal

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
