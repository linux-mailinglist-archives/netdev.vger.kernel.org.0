Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A5213D40C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 07:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgAPGDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 01:03:01 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:42708 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgAPGDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 01:03:01 -0500
Received: by mail-io1-f72.google.com with SMTP id e7so11995639iog.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 22:03:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=l8bygRXo9H61q/xTgsjVCR2mIDWLRv2gXicQnyi0I1Y=;
        b=WkCilIx1r50MoWnI0PRh6cUcpIhTCQDnpip9KM6GxMfZQKj8pO1NjAJP4+WobShl98
         sxmxkdt2SzfdVQgcgpp4iOY6ajchcjrPgy2ToHHDk1AxPFuLbQ5NuKmq5xcLxaO5/E/t
         eOveo9D1Be1ILX/1P/1OJ8OrOcV6Ak3Ph40SfLt6mQQjm52CkspjJ33VB8zNWkS9BvUB
         3L8rFqRxgcLckIQFXAm93HmiFu4qiIvz3k4p9xe9ZiNGflg+hXZ9oyYJj+qyg7Co8aeQ
         UoTAeBUVs/2EFd4WrApEGlq0PaNKcNhrqgzso5t6jZHrb6vWfnSrOJhRE/gYRImyWWNp
         51hg==
X-Gm-Message-State: APjAAAWLZxv1Onz1cEpqKWo1cYaDew1Asgt5/DSExIo09dG9W+/anAsD
        rPK5fSkXHdBpaOpOuYlL1fwolnnGTgDFXYvPRzc+IemBGnrP
X-Google-Smtp-Source: APXvYqyE5UypONJc+dmBaDsn10ba1W1VIkt9suVws575jhjE72sLjeZaHsFFX7HXfIFYuVXUR87AMCJI8zBfRLZmt8GGKLBO81wQ
MIME-Version: 1.0
X-Received: by 2002:a92:d8d0:: with SMTP id l16mr2094256ilo.43.1579154580939;
 Wed, 15 Jan 2020 22:03:00 -0800 (PST)
Date:   Wed, 15 Jan 2020 22:03:00 -0800
In-Reply-To: <000000000000bc757e059c36db18@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7aad9059c3b93b7@google.com>
Subject: Re: BUG: corrupted list in nft_obj_del
From:   syzbot <syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 20651cefd25ffa77a15cab5853b175a6dc975ec2
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Jan 9 13:30:48 2018 +0000

     netfilter: x_tables: unbreak module auto loading

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1073a33ee00000
start commit:   8b792f84 Merge branch 'mlxsw-Various-fixes'
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1273a33ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1473a33ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=6ca99af7e70e298bd09d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168b95e1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f29b3ee00000

Reported-by: syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com
Fixes: 20651cefd25f ("netfilter: x_tables: unbreak module auto loading")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
