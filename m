Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64D27B36C
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgI1RkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:40:07 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:54120 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgI1RkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:40:06 -0400
Received: by mail-il1-f208.google.com with SMTP id v5so1409793ilj.20
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YJj+NKirC78aDBHmX2WKsxxPVFYimQaCt4KWlG1d+NM=;
        b=skN7sLkIukXSytpr8NH42wnMVK3m/k1rJOn+2nuQU0xmrtS/xkVCL93MmQCElT5dF6
         9hjU/uC2QnrEMiIkL5V2NqsuiB1sgIgLyom4P5iejMmfSx7WRJw4dsZwr7d7HRzKzI0P
         6M5XxjMJodY70EQztEa7+6sHqK/exhQPytiuyG9EEDa11k7nAryf7EIHeIokmmio+Ge1
         ntNwXgA05y4xERMSS++WiB1fz9PI/lFuL0jMAycRuBCB1TtlFsIBxDNS+2dypc5HalPm
         uz45mwQdN97THYDlRv2b4QLJfqRcbhPHBqhROf/8kQEiQtCyKjP5tATsqdEaMHJIZXFq
         Tm0Q==
X-Gm-Message-State: AOAM5321PVoz7HePrr0611m2i5OrgBxwjaz/9zJ0aQRGPnr66dfY89/0
        6vpmPbHZ2TvNgSKKWpae/+/9bnupVxhR7XHqEDb8iXZZg5ll
X-Google-Smtp-Source: ABdhPJyACsKcOzagLGt6tchEW46xgXXf0ncWeiIXVtEwQtLLeOF/H8MmdTl5xCixGz8iVvFR/G5TTrpiwBozN+CFGBXJmyS2hR2v
MIME-Version: 1.0
X-Received: by 2002:a92:d105:: with SMTP id a5mr2164301ilb.206.1601314805962;
 Mon, 28 Sep 2020 10:40:05 -0700 (PDT)
Date:   Mon, 28 Sep 2020 10:40:05 -0700
In-Reply-To: <000000000000650d4005b00bcb0c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002edd5605b0632812@google.com>
Subject: Re: general protection fault in strncasecmp
From:   syzbot <syzbot+459a5dce0b4cb70fd076@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dhowells@redhat.com, hch@lst.de,
        hdanton@sina.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mhiramat@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit bfd45be0b83e8f711f3abc892850d6047972d127
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Oct 11 20:52:22 2016 +0000

    kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1613329d900000
start commit:   98477740 Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1513329d900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1113329d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=459a5dce0b4cb70fd076
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125d46c5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c58f8b900000

Reported-by: syzbot+459a5dce0b4cb70fd076@syzkaller.appspotmail.com
Fixes: bfd45be0b83e ("kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
