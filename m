Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B865710DCD3
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 07:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfK3GwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 01:52:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:47533 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfK3GwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 01:52:01 -0500
Received: by mail-il1-f199.google.com with SMTP id d4so22106943ile.14
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 22:52:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LH+oNIdXBIwxjg57W3FD/l3zRLVtt0ZQgS0IxdqkKI4=;
        b=RkaiTDLl09m/B8V8dt6z5PUkZ9+OcIrlzDNgCKyOuC/uJ0pqaSgopokSKPZgrazlAv
         B2y8qE24Wsvm7p4IvTd3hXK5hO4xbm08k6Mj4vhDFaCW2+I9573wDjX9qVk2KSKnY4EO
         uJrhOPjHfmt6zsrwwkPTF2cdT+JPxJz5V70yeyiTG18wKXlpwKkBbmfQg7OXB5kYVsWI
         otYKldC/LsVs5u1XqClocqY7vRJbysctbjkiI+Jcf129nAzBmtjywCqMF5lgbm5oYR7S
         iUFn4CfN9dImDKbjmP0Hgf+zKxYTuxZ6d6JTOd4xznwoii2Gbm61JDwjpOXiMDCbnv+I
         c4fQ==
X-Gm-Message-State: APjAAAWM4mUlzTDpHB+RDtvdQnTXi91Cqf/r7YuWZ6yO5+6DdxfpKRBR
        vDkcIU39CojI2Om4MkFbXDVapLv8MF+Va/t0DG+4X0ne19YA
X-Google-Smtp-Source: APXvYqzqoowMlvXf8CnOvya7QGH5LnuwTEQxwGpMIbMv3o9ZqFbpzbnW4ixzkc+NCt/1cA8yqhHjXrz1y4jgMjrpQgUS8JclaVsN
MIME-Version: 1.0
X-Received: by 2002:a6b:6e05:: with SMTP id d5mr11393518ioh.90.1575096721095;
 Fri, 29 Nov 2019 22:52:01 -0800 (PST)
Date:   Fri, 29 Nov 2019 22:52:01 -0800
In-Reply-To: <001a113f39820d16d50567379661@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008c415905988ac808@google.com>
Subject: Re: WARNING in tcp_enter_loss (2)
From:   syzbot <syzbot+c5a3099b94cbdd9cd6da@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jmorris@namei.org,
        kaber@trash.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, ncardwell@google.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ycheng@google.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit a0370b3f3f2cfb8b424b04c0545414abaa53f5ee
Author: Yuchung Cheng <ycheng@google.com>
Date:   Fri Jan 13 06:11:36 2017 +0000

     tcp: enable RACK loss detection to trigger recovery

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114cbdf2e00000
start commit:   0644f186 Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=134cbdf2e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=154cbdf2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61c12b53c2a25ec4
dashboard link: https://syzkaller.appspot.com/bug?extid=c5a3099b94cbdd9cd6da
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112146e7800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1317f95b800000

Reported-by: syzbot+c5a3099b94cbdd9cd6da@syzkaller.appspotmail.com
Fixes: a0370b3f3f2c ("tcp: enable RACK loss detection to trigger recovery")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
