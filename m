Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F52141C00
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 05:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgASElC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 23:41:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:43706 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgASElC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 23:41:02 -0500
Received: by mail-il1-f199.google.com with SMTP id o13so22336174ilf.10
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 20:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EHfWBR0huIHFcTJaoFUtGUR7IDOZ8MVrcyGekqx8mAE=;
        b=rrHvh8xa6so3eJYk7mK/0eAvcMgmRpt4qhiDr4rNTHLGm4BAmwdt7w1PowGdGdtY9u
         sLcYe7k9+GMmbUUWSXBispyXV+ioX2zadCntWev7k6cejPOv4Qs2Gn6htV9LD3RV1yiD
         bv3BT0fXtbrCOrWV+kspekMoFZHBDfK7oGzIW+HQexEzxUSPr6OVE3tz4MyDnJxKve30
         BrOEscJnlvHHRYCzTGJ12Fv2i2sviYb0FH0i2doOdzuxjU5JukKDnSUAqQjk9TISK1TL
         8F/Wlqpdd8z7jOxC97MehFMrYaNq2mDUHr7keSwBj85KPCQv81HapT9QNk4/R5u2qVtd
         YebA==
X-Gm-Message-State: APjAAAUzGNSxrvlOG4crTYNfQEyAap5p5BMI9UyKYO0yXTLmpixQ1LMU
        8na/WeY5srYO2onixDBmiRrS7LBSMWg4E4OLeh7e1z3ROwZT
X-Google-Smtp-Source: APXvYqxTvS9QIRjVWv+5NS7HReJdEStlb/ujZ5/QAI12PGUg0ITxDVVyZ+dB04yYCxhUmlbpujJjRydgNvYEngV+/fm8FPnQG0fR
MIME-Version: 1.0
X-Received: by 2002:a92:b712:: with SMTP id k18mr5669699ili.259.1579408861675;
 Sat, 18 Jan 2020 20:41:01 -0800 (PST)
Date:   Sat, 18 Jan 2020 20:41:01 -0800
In-Reply-To: <000000000000717523059c6cabc9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027c814059c76c818@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_gc
From:   syzbot <syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com>
To:     allison@lohutok.net, arvid.brodin@alten.se, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, info@metux.net,
        jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ddfa85e00000
start commit:   25e73aad Merge tag 'io_uring-5.5-2020-01-16' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=103dfa85e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ddfa85e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=df0d0f5895ef1f41a65b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124774c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15aa48d6e00000

Reported-by: syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
