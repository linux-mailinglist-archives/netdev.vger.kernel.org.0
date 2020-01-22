Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA1F14542A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 13:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAVMBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 07:01:03 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:49278 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgAVMBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 07:01:03 -0500
Received: by mail-io1-f71.google.com with SMTP id c11so3868806iod.16
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 04:01:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=61s/b2ve7Ymq8tfjb3CXMkDvuEBC5uRjhgGwyXBI6Ks=;
        b=AbZ1QQe984JnhbOqFAqUjhTW4u5WgBB6ADufnBeF33Z9CmDguilQoAYzYPeJ3qg6Ly
         +SgE3ip61adIsqI9sJMyvmQgJ/Jlv+8pq9E23Uh+ejvJHt1icnD+2s1XR8pW3pFBZKDI
         6Qem98ql9cy+N8UP0SSGHGQrCdwHEF1h/j7Qzbrda8Avi+fW5Nk3kfBXW+7OP6fw2aaC
         5thJZ92sw+BjzUjHtvtaREk8/6xVXda+AdAhIi9IesjgjN2cfx5yp/AGKoUC8mu8ZdQi
         f5JkLYoTn2TzPIdjZpV3cuN0pC31kAC5hFMyeTL2MEZFlSiaugaqUP74LPQAVYk0TzFV
         7IPg==
X-Gm-Message-State: APjAAAVEJVwOKXZQDB3/Lxq0jxo8bWr1dFjJ0UzdL9U97TD59lRW50MK
        5ypoDm5MWK7M7JHIQWcU0zz2lO5bilwBdvnL6iYokhCU3eoS
X-Google-Smtp-Source: APXvYqyauwF/AYy3VXIkvRTGiyeWl5ltDClvjnrtOVeCsUgRufF0STZg5aTzuLZ1EBQ/uEcFf23kAN1WfFJdg2uVlA8aHwOKEUSo
MIME-Version: 1.0
X-Received: by 2002:a02:ce5c:: with SMTP id y28mr6785824jar.96.1579694462294;
 Wed, 22 Jan 2020 04:01:02 -0800 (PST)
Date:   Wed, 22 Jan 2020 04:01:02 -0800
In-Reply-To: <0000000000007c3ba2059cb50843@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004762b3059cb947b4@google.com>
Subject: Re: WARNING in cbq_destroy
From:   syzbot <syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, echaudro@redhat.com, ivecera@redhat.com,
        jhs@mojatatu.com, jiri@mellanox.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit d51aae68b142f48232257e96ce317db25445418d
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Mon Nov 27 17:37:21 2017 +0000

    net: sched: cbq: create block for q->link.block

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a51a95e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16a51a95e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a51a95e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=63bdb6006961d8c917c6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a1a721e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a91a95e00000

Reported-by: syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com
Fixes: d51aae68b142 ("net: sched: cbq: create block for q->link.block")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
