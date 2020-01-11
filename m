Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1297137DAF
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 11:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgAKKAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 05:00:13 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:51579 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbgAKKAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 05:00:02 -0500
Received: by mail-io1-f72.google.com with SMTP id t18so3055212iob.18
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 02:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DrXkIWbrBX7Fd3/gNLvsOw44mmxpzBLe8lrnfiRlxxU=;
        b=sWQJmSJVfF7qoJSMbNmiwhVR8+kB+cKc5d92TF+IGtOKUrRsgZXcQHNoe27t9z24A5
         yS2SJPg6SayU6rE/B9bEVSH8vzSqic4H8NSms9lqYKQuM9ZEjdWDhBwdVVZurwH4pLqS
         NHKFn2LU4lCyIVWKnyW1UJVr6S+o/R1+E4aHOi2Px6cZqlmNsGB7vq1merCl14Skw8Vs
         aqq8Rh7tA2GIa4BqbAZuUIruia7zxpJkZBClVMNTibfZssBVkihv0r2wIuLT/nF2s0lX
         JQUhbsrMAoNT+7s2n4RvdeqORpya4viAzB0uRlJP1gyBIiOloEfHwgA5tJColKcWaNXm
         JqIw==
X-Gm-Message-State: APjAAAXeSijC1dPA+k+cqxSbVQHi/bR7nPMeOJGkaQe9YE09w52Op1P2
        ucjkiwoYdOFA9/hBRBT4h/OUk8r6p5O80TrnJQt/QEc8zq1Z
X-Google-Smtp-Source: APXvYqyyzAXe87hNpCj8KaNkoKxDWd8rM9/pHrdZJgUyZW+0chTRAqzVJVUlQ1uS+a/5JliEf7yngQJ01ZzullfmzWMeqcTDBvPj
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5c3:: with SMTP id l3mr6947066ils.260.1578736801574;
 Sat, 11 Jan 2020 02:00:01 -0800 (PST)
Date:   Sat, 11 Jan 2020 02:00:01 -0800
In-Reply-To: <0000000000007a5aad057e7748c9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004078ac059bda4ef9@google.com>
Subject: Re: KASAN: use-after-free Read in lock_sock_nested
From:   syzbot <syzbot+500c69d1e21d970e461b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhogan@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, paul.burton@mips.com,
        paulburton@kernel.org, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com, tbogendoerfer@suse.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit a07e3324538a989b7cdbf2c679be6a7f9df2544f
Author: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date:   Mon May 13 11:47:25 2019 +0000

     MIPS: kernel: only use i8253 clocksource with periodic clockevent

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11dd033ee00000
start commit:   3ea54d9b Merge tag 'docs-5.3-1' of git://git.lwn.net/linux
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=195ab3ca46c2e324
dashboard link: https://syzkaller.appspot.com/bug?extid=500c69d1e21d970e461b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145318b4600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ac7b78600000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: MIPS: kernel: only use i8253 clocksource with periodic clockevent

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
