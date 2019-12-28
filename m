Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB812BD14
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 10:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfL1JGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 04:06:02 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:49622 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfL1JGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 04:06:02 -0500
Received: by mail-io1-f72.google.com with SMTP id c11so8331688iod.16
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 01:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WfGb9lGFdGhSi8hZEfWk/M3G0IsGwYCNAdgm6CjQ7QI=;
        b=uVHqBJ97XJhxgcpq6Uu/l2+oV3QSu1rTMBla9oOjv2d0ihrAW7YtYSghSPt5YoE/+Z
         0Cj09LMUH5qrFO5JK6cByr+JAvXs3KzV4gtb+leLQG9Nyma8c5D7An34RAIC7V6f9ife
         Tx5Sw+JFO8YMQWAUkOpna/bPvtPY3IKBru9UXOkY0KrDSCyCDZdlgx+HA/Q0nyV3hvxg
         nkuZ8/cS/nCQL3SDdAU6DEl4hvTVoJcYpdAvJ572AJyGhn2RLvEKbunnD2aoMBO0Sa2k
         harnDGufQQBMoig4PRhjopzIjHiMGmOEqez4Rt1uwSkK657uODw/Luv1U46KVuZSftYM
         tbtA==
X-Gm-Message-State: APjAAAUQm3AQdHuovOKMa7wMr/Xy/jU7k5f706/5j1PdtnzwRWVKgEQP
        EnZyXBYuqQJs0rtYojA/3AUzi/C1bxJN7e1uc83HmOmgdO7Q
X-Google-Smtp-Source: APXvYqyJDTFrNl+ZpW3oGkoUn5Ny0lVdEe36WgM5iN4TzGysRfB97r5Zok5DVtIDafRKxTRvqHwhuE0e1QpHyIt/5WWgjBGqL612
MIME-Version: 1.0
X-Received: by 2002:a6b:f404:: with SMTP id i4mr37323657iog.252.1577523961683;
 Sat, 28 Dec 2019 01:06:01 -0800 (PST)
Date:   Sat, 28 Dec 2019 01:06:01 -0800
In-Reply-To: <0000000000004718ff059abd88ef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c669c059abfebe7@google.com>
Subject: Re: general protection fault in nf_ct_netns_do_get
From:   syzbot <syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        hpa@zytor.com, kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, mareklindner@neomailbox.ch, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0a957467c5fd46142bc9c52758ffc552d4c5e2f7
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Wed Aug 15 20:22:27 2018 +0000

     x86: i8259: Add missing include file

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1579e751e00000
start commit:   46cf053e Linux 5.5-rc3
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1779e751e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1379e751e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=19616eedf6fd8e241e50
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a47ab9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170f2485e00000

Reported-by: syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com
Fixes: 0a957467c5fd ("x86: i8259: Add missing include file")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
