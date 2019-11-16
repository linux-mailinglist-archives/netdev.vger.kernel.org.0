Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC24FF469
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 18:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfKPRmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 12:42:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:57066 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfKPRmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 12:42:01 -0500
Received: by mail-io1-f71.google.com with SMTP id u6so9798835ion.23
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 09:42:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EWN//L91CyTslFFeakj+mgyvWWWFpOQoVBvfSDcuags=;
        b=i2jZddc1w2lD/SmkiRaynZlggnrfPIWj0D1lIFW8m/oOrkBoTe/32RQ+Vh08JT5jGt
         TbsPW25qtO8VltkiVjG8k341FE0w2XDGni39sayxDJ4kiIC4SkoptLw60+xMNaIsVn3r
         RZOGZH4/9oIn3LvMjEHZgId1ci7TlJGHkUR+J+09LAsbaPaBn1b8vyOzNDZkpdsqZWws
         yyCzsR35zynUvnaQy1SQfPY+p1Hf3/y8Q/KegLXQFBxFETfSJ3SyLK+Ve/BdCHwQQeFl
         UT+sCHgGhY0uqG/AkMYkO0JKbpaZeaFUSvBT2r+1hmIPTUHyj6L1Ppk5h+ETz3HlahyQ
         IcfQ==
X-Gm-Message-State: APjAAAXpoCjrQhATbnFqUZMs972FZW0CnmQbdevDriLLtR/l6tAujO5x
        U1hjCXACFojgIuMpwOnTd1tp0OkTiZarWDZ3AGq4IJugjllX
X-Google-Smtp-Source: APXvYqyPXHr27XD9qFJx9csZgs2fVi5n7W3qz+3U4f6wnRc6QocEac5JBhTcWn6Bcp6WcLpjvOUYRZWSU1CzyYJ7kWmiELv609xh
MIME-Version: 1.0
X-Received: by 2002:a92:dd12:: with SMTP id n18mr7609659ilm.9.1573926120871;
 Sat, 16 Nov 2019 09:42:00 -0800 (PST)
Date:   Sat, 16 Nov 2019 09:42:00 -0800
In-Reply-To: <000000000000675cea057e201cbb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056b92d05977a3b19@google.com>
Subject: Re: BUG: unable to handle kernel paging request in slhc_free
From:   syzbot <syzbot+6c5d567447bfa30f78e2@syzkaller.appspotmail.com>
To:     akinobu.mita@gmail.com, akpm@linux-foundation.org,
        davem@davemloft.net, dvyukov@google.com,
        linux-kernel@vger.kernel.org, mhocko@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tejaswit@codeaurora.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e41d58185f1444368873d4d7422f7664a68be61d
Author: Dmitry Vyukov <dvyukov@google.com>
Date:   Wed Jul 12 21:34:35 2017 +0000

     fault-inject: support systematic fault injection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144b8772e00000
start commit:   8fe28cb5 Linux 4.20
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=164b8772e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=124b8772e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d581260bae0899a
dashboard link: https://syzkaller.appspot.com/bug?extid=6c5d567447bfa30f78e2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136130fd400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1607c563400000

Reported-by: syzbot+6c5d567447bfa30f78e2@syzkaller.appspotmail.com
Fixes: e41d58185f14 ("fault-inject: support systematic fault injection")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
