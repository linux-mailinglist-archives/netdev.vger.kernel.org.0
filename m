Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F94182988
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388078AbgCLHMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:12:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:38139 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388069AbgCLHME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:12:04 -0400
Received: by mail-il1-f197.google.com with SMTP id i67so3264460ilf.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 00:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NkGoJSV/Bp/D1AVTh2vJ5bc0esVeByDEUU8v4C2fFZI=;
        b=ab8VpbwF5654KwaklvQeuhyPE8jZhYJKy7570HkRyfkrqCYZhEGb2B/78mlF2F+3vr
         auUwUtjTMQHskb6iR87r2bfbEBcTEVjuyDIpaWW40epREo0fJUW/BDkrZegzQ7BeTRRM
         CObMbMruibteZg4ylatQIc8Ams79rKivrmhgtFzobG4qmUNJJ/oLOF5lvOQVmXJ6W//r
         qeUiZjLDiX0yeSeZv9qO52BuxBtMhT/hi3awo25KQiUqHbzKevJw6b1xmbbZyFqWOCUT
         ZMedv06xzSDSNWVwtHrnR3Vuwm5dGVq9dq+uHNev5e4NkumvNGxWOonJf70yOG/N8AUM
         w82w==
X-Gm-Message-State: ANhLgQ1WNTHe88hMA9XuUDsCpR6MruXwHsB8mBWkwkrBIeA6iCjn5f1V
        KHOkTWpp5dn3kDd8/qgElTA/HzEZ5OwM8ePdf9Xi0r2lgkKN
X-Google-Smtp-Source: ADFU+vu0tdPEZAEJ4MkiMJN9x0Wbxty5U2bPaFvIoXsT+C6ccTSohSa61FoSXLPgeHbcrwZMk4ztdS8AxE6Gq/FdTX412XuVHtKt
MIME-Version: 1.0
X-Received: by 2002:a02:30c8:: with SMTP id q191mr6475552jaq.34.1583997121957;
 Thu, 12 Mar 2020 00:12:01 -0700 (PDT)
Date:   Thu, 12 Mar 2020 00:12:01 -0700
In-Reply-To: <0000000000000ea4b4059fb33201@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7979105a0a311f6@google.com>
Subject: Re: WARNING in geneve_exit_batch_net (2)
From:   syzbot <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        hdanton@sina.com, jbenc@redhat.com, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, moshe@mellanox.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sd@queasysnail.net,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 4e645b47c4f000a503b9c90163ad905786b9bc1d
Author: Florian Westphal <fw@strlen.de>
Date:   Thu Nov 30 23:21:02 2017 +0000

    netfilter: core: make nf_unregister_net_hooks simple wrapper again

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1594fbfde00000
start commit:   63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1794fbfde00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1394fbfde00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=68a8ed58e3d17c700de5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f08165e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17902329e00000

Reported-by: syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com
Fixes: 4e645b47c4f0 ("netfilter: core: make nf_unregister_net_hooks simple wrapper again")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
