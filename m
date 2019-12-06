Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98353114ED7
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 11:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfLFKOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 05:14:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36167 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfLFKOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 05:14:01 -0500
Received: by mail-il1-f198.google.com with SMTP id v15so4905913iln.3
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 02:14:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Fa+DdxX+lo+lJe7dbFyW3kXCcKwv4MKa5Zg9OwBsWXc=;
        b=hcw8F8wZudO9ZNsxMSOae9bSRWkDb0btZaml4UwWLajpAuI4nhhFe1RRe4yrxPQ4wg
         hgMq+A+NIpeLATBVz8gRgNdIL55TRgEQYUhurlckiQ6bx1EhYoOppt+Z6//+hvnNPdFi
         0jk5rwZyQUADbhyBNc5sMtehW6WKwI8NpuW7sLfL6ILgtMgG/L2yaZpQJHnuRwjrK2Oh
         iQA0L/zhh4bKhqiY67YhudlSs5qOuDdWBzablVjE74ZeWvelba9FniAZv1Jo0ZhHcMDB
         9Wbo/ah6IWWnKMhJydLTbzYBt5Po6bQlrbvfFwmtHneA9ciahjL9kRrQVaKtUtQDXSxD
         NQaw==
X-Gm-Message-State: APjAAAWZrdvk5PtYPbVCdse/DLM7qSH/VmZj9pPzQ5QM7C+JHdD0x+bV
        iVs3Poak7KR92aiAOAboBxkupZ+eCk6tZUE8XgZuesrM1LVZ
X-Google-Smtp-Source: APXvYqzGg5ZzkX9hHhaO+/fwV0I2Tn4tW8ji/5Qstkgv6wEgzMsaJk3DJuUegmXDOOmXieSunteRMIQPjKQJQu1fBDNzjI+1JDXN
MIME-Version: 1.0
X-Received: by 2002:a02:c6d5:: with SMTP id r21mr12524117jan.129.1575627240875;
 Fri, 06 Dec 2019 02:14:00 -0800 (PST)
Date:   Fri, 06 Dec 2019 02:14:00 -0800
In-Reply-To: <00000000000054cc6d05834c33d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fdad650599064dc5@google.com>
Subject: Re: kernel BUG at include/linux/mm.h:LINE! (5)
From:   syzbot <syzbot+5013d47539cdd43e7098@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, dirk.vandermerwe@netronome.com,
        edumazet@google.com, eranbe@mellanox.com, eric.dumazet@gmail.com,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 9354544cbccf68da1b047f8fb7b47630e3c8a59d
Author: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Date:   Mon Jun 24 04:26:58 2019 +0000

     net/tls: fix page double free on TX cleanup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ebd77ae00000
start commit:   9e9322e5 selftest/net: Remove duplicate header
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=47f2db597668ac40
dashboard link: https://syzkaller.appspot.com/bug?extid=5013d47539cdd43e7098
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148763eb200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1416ff3d200000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/tls: fix page double free on TX cleanup

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
