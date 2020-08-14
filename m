Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EC9244E8C
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 20:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHNSsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 14:48:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56403 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgHNSsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 14:48:09 -0400
Received: by mail-io1-f71.google.com with SMTP id q20so6629950iod.23
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 11:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FdIRXuZCQukDRQ0XU5HzlXLbagxjzssCGhlf1mUy6ZA=;
        b=tnjoJ2ikxwGBB8j/0Tr2nO/fmNwYKGVD26y5ieDe0t84SBwQbyMbB8F5l0bfhzrrVY
         cEvw6hQqiwIInWX+SpQlRBWbRoKgiF44GeYI3OZWWZOaiMn7vHRNhMRK07PMTotolshV
         qi6Dj3gcCc8YXaQWzCoiN3Lki+ly7QwjV34Co0AhYKgMr3XZLJAcDmfT2bqEKR9idhk5
         rdIcC4c1XHgO4rXziJNRJMRc/EqimjA0ngHNr2yDbr430r3KvOCzkt+gZxB1SAkqNkut
         ImF6mWjqtOSrNn2w9kapvaVa4GA78w2citTWlSDrkZiUUnzwJjROleA5DzEinUr7PGh2
         W8Ag==
X-Gm-Message-State: AOAM533sWPD2twfjOQdtHDbqSs3m+Ca3vObHqA4zgKwOW0birq8iYDR/
        RJVNa86qboZtGbLRG0szXNohS8mvN571nUdk1DYINBn+INcZ
X-Google-Smtp-Source: ABdhPJzNTvNy1dhu9pwSXa3tWa4iLGVzBCdcRYK93MYJzzPqsQW/K4PnkT/GdTdJGW94oI0/s3HorImYD5cpCRRwVwYGVaoycdZT
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c09:: with SMTP id d9mr3762153ile.289.1597430888599;
 Fri, 14 Aug 2020 11:48:08 -0700 (PDT)
Date:   Fri, 14 Aug 2020 11:48:08 -0700
In-Reply-To: <000000000000eea12405843bc43c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab163105acdadc50@google.com>
Subject: Re: KASAN: use-after-free Read in refcount_inc_not_zero_checked (2)
From:   syzbot <syzbot+eff6b596cc8194e2f029@syzkaller.appspotmail.com>
To:     ardb@kernel.org, davem@davemloft.net, linux-efi@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org, nivedita@alum.mit.edu,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 987053a30016a7d9ab3e4ad973e7c51aeb1f1ef6
Author: Arvind Sankar <nivedita@alum.mit.edu>
Date:   Thu Apr 30 18:28:40 2020 +0000

    efi/x86: Move command-line initrd loading to efi_main

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11680f6a900000
start commit:   9c7dc824 Merge tag '5.1-rc-smb3' of git://git.samba.org/sf..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e1aaa1cfbfe1abf
dashboard link: https://syzkaller.appspot.com/bug?extid=eff6b596cc8194e2f029
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e294a3200000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: efi/x86: Move command-line initrd loading to efi_main

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
