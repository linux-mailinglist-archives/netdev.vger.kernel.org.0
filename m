Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86731367AF
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbgAJGuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 01:50:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39840 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731555AbgAJGuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:50:01 -0500
Received: by mail-io1-f69.google.com with SMTP id p6so885408iol.6
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:50:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nSBEziQIAgMmreD/bwiDUMfwTZxHkivHwZB8qVu7K9M=;
        b=TvehoVr6oSjdF5LUGqo1E3At6AzsnQ3catPcrjurwb2oVTsYL0vAakIcVM2ZhdYUgI
         FvSLHU19/vSAFqK0a1aTF8rG74tOvtvn76yDX5qB6B80UfKF6DP+1c/u0+5Y3Hn4golP
         MEBvDeDUd0rEy8UIVgqPZMbkvPN8NHSifa7ShYDdP3qXPt37Lnmp8TrMjbNjBxcwjVNi
         SXQmsF+2mTPMMX1xXUKEPc+U+/Pgc4/TQgHqrfbWqgHJl51eS3fyH/4rXpDwfHzw7sTh
         KVNXmd73wJvFiwwUAeBKxy7Tl3IU5BR6jAz5sBAVHoCC/GLhA1k0P738q4+6eFa9bCnl
         srcg==
X-Gm-Message-State: APjAAAVoPrbGiP3DnPLXaRtsSN8gszS7wCWWnZc0Bd/+VXcPG5zh5lOc
        o1EhaassTW/atHjw4l1vn2GVHliPxbTbN/75p19oPyqvUWs8
X-Google-Smtp-Source: APXvYqygb++rANaYFZ2skaGuTLPRW7b0m2B1Xr7kXiLH/wZnhkt0oZWvxvj3A3b+HGzLordUY9WM6fV0K7+EMxq+HVsg4swltiWA
MIME-Version: 1.0
X-Received: by 2002:a92:84d1:: with SMTP id y78mr1319946ilk.69.1578639000707;
 Thu, 09 Jan 2020 22:50:00 -0800 (PST)
Date:   Thu, 09 Jan 2020 22:50:00 -0800
In-Reply-To: <000000000000946842058bc1291d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ddae64059bc388dc@google.com>
Subject: Re: WARNING in add_event_to_ctx
From:   syzbot <syzbot+704bfe2c7d156640ad7a@syzkaller.appspotmail.com>
To:     acme@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, arvid.brodin@alten.se,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jbacik@fb.com, jolsa@redhat.com, kafai@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 311633b604063a8a5d3fbc74d0565b42df721f68
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Jul 10 06:24:54 2019 +0000

     hsr: switch ->dellink() to ->ndo_uninit()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1005033ee00000
start commit:   6fbc7275 Linux 5.2-rc7
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bff6583efcfaed3f
dashboard link: https://syzkaller.appspot.com/bug?extid=704bfe2c7d156640ad7a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1016165da00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b27be5a00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: hsr: switch ->dellink() to ->ndo_uninit()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
