Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18E0149377
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAYFRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:17:03 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:37291 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgAYFRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 00:17:03 -0500
Received: by mail-il1-f198.google.com with SMTP id z79so3238168ilf.4
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 21:17:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Hm1zljW9y0AexWcJitkyOHbzqNCGgR9k713xPpYIVAY=;
        b=kFOtntslCRk1ENORXixMQOZ3b668SgbfRU4zHuo57ZhvyOLysuAK2qsjfGy4aZ9ypE
         34rboyU2B/rBFB393QKouosmyy3Ajf9k75gAQ+h//vQKWraej09hGCUVwDolLWhw0RR2
         vWi6TsUk5I5W6mDN2ICzEc0BhJjBNZ0DY+1FD28DzWAVe+RJJnyiZDFa0zyfPbM6Wg9M
         zpnQJ/LzgHTmcco/9Bn9D6b60HU4/joegOK7I/XUSPYsHjaPbypV1rxrhs2zKyDpwktn
         zVcB37p8/YebjBmV6TLWtSLnRu2sPjNAHCJ5g4fpyx1nTwVeGH0vMFO34A5Dxhp96PWZ
         wVfw==
X-Gm-Message-State: APjAAAXOe8MXrrNfMWtJIaDHTY7FXWIj260ZSpHc5uYuFN0OkyaaV/eh
        Nuv04JjjXstZeLKHaiyh3KuDZ/712NtKecDLN0aZfEpTUTmZ
X-Google-Smtp-Source: APXvYqzktrXlzRHbfMlINQ4SHuMoXb8GIG7MQZ6dYPldTUgzSyB7rjjYXEMSwB2k5zI32/xnqeOrTvFvtLKPcvFAYhveGhIqcFFK
MIME-Version: 1.0
X-Received: by 2002:a5d:9514:: with SMTP id d20mr5091562iom.198.1579929422654;
 Fri, 24 Jan 2020 21:17:02 -0800 (PST)
Date:   Fri, 24 Jan 2020 21:17:02 -0800
In-Reply-To: <000000000000c8a983059ce8298c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001f420059ceffc95@google.com>
Subject: Re: INFO: rcu detected stall in ip_set_udel
From:   syzbot <syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com>
To:     bp@alien8.de, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, hpa@zytor.com, info@metux.net, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

    netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1352c611e00000
start commit:   4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10d2c611e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1752c611e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=c27b8d5010f45c666ed1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1568f9c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17db3611e00000

Reported-by: syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
