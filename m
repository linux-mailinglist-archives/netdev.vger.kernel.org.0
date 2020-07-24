Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC0222BC6F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 05:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGXD2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 23:28:06 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36706 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgGXD2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 23:28:06 -0400
Received: by mail-il1-f200.google.com with SMTP id o191so2546691ila.3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 20:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ont9djuNY0GU/qTuUTW3soxu8Qb4Ubkk1v7mFHEioWA=;
        b=G7VM8y0LiznHEkU9ah3NjnQMPrZnvJpb7Ydi4l2h16QfKD+wBELaE44RpHSa4hB7d7
         hGQ2F91gk4MIfVwYuY1Tj74sHy9UZEPMY6gGy4AH7krbjcD3wCYlzkLVQElrXWqUSySS
         hM0nlm2Hn5GaTYYe9ypIXxPU3Y1pu7gEZ/4C1mRaHddqOKYZVAAJ3OE2AhQwU+2d1ysJ
         nBqPDXXChkgbxGuTbPX6L+ijN0RFW+0HfYIVyiEvZvc1AQopiGFKsx0Vv1+0shYxPZG2
         Zc1Jekim1xehddr9ky3e7XCd8RTRLq2z/9/T+Ra0GNgpGmTg2jzCG7IlSDcViChbNlVy
         8W0g==
X-Gm-Message-State: AOAM533vhWmtd1XHUPBq7DKvK4SyqjqIDeyltRndvXuMxawa6eD8uaCY
        zZCQtXLhhpeFxuMUYqfDoffuM5cydUqJyfgyKmtH8CEwrwZd
X-Google-Smtp-Source: ABdhPJyJhGuaT6ThvP5DAjoFMNwap5je5huhz7wXrzNaWbB0+3IhSTSajSiENIBUlIaXs4NeyJWylMSwM1m6OQPseXtVJY63B+ii
MIME-Version: 1.0
X-Received: by 2002:a92:cf06:: with SMTP id c6mr8246821ilo.73.1595561284301;
 Thu, 23 Jul 2020 20:28:04 -0700 (PDT)
Date:   Thu, 23 Jul 2020 20:28:04 -0700
In-Reply-To: <0000000000000a8e8605a22a1ae0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000091792505ab278f0a@google.com>
Subject: Re: INFO: rcu detected stall in netlink_sendmsg (4)
From:   syzbot <syzbot+0fb70e87d8e0ac278fe9@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vinicius.gomes@intel.com,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16d46e1b100000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d46e1b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=0fb70e87d8e0ac278fe9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1023588f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1647a88f100000

Reported-by: syzbot+0fb70e87d8e0ac278fe9@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
