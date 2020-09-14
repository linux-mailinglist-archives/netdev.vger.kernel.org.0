Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9433D26897B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgINKoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 06:44:01 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:51228 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgINKnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 06:43:11 -0400
Received: by mail-il1-f205.google.com with SMTP id i80so12233449ild.18
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 03:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nb6tKmJrQ0MmWDFi2dgAqU18Vn8+HnihNjS4obNqQco=;
        b=W3sWd6MhDHVsP/H3AqtJ2xqHaW2j8JcXWZ2Bi/YR+4QDQbBuV2GEm4e2knQLZjVhl0
         jePSDhTx23+yJUGLvpI18/VSbeydknXNb/bGO9/we8X2/c4a7xu/kT/pGblW9YKa7Up/
         63vFjwSbioH1cDtwmJ+3DWThQ48DXdufcRQ3u2fQ9NvLjrL04rMG2BBRBzNRPwrKn2bE
         B3BH1vO4l6WBVd/L5abcGumK2NhcPQLA3AbAQEXKxpqTWxiRNSspyW3Vy6Ex6mqnq/GL
         KU7PPmxHMNk9REf0qiJvOoYs5KWThL8MPhk9UDqWFJeAD9DSrry66Wjmj/KeUmrVzQHQ
         bSIw==
X-Gm-Message-State: AOAM531umsHVU5ygSn4nX6XaOSlZHMhVq320IxdyoiEoyvVf6RGmji8h
        gZO6r0A9Aok9HlI5GRvyHQjbjTmjwhWE4FIUTBdezMRACfg0
X-Google-Smtp-Source: ABdhPJw3hKEMEFQ6nl0KkpYooE/vnNAMhKv3GfHMUPVBUXKB8aMSrYkYbBuuawf5tSFsTTZBsh8wJCl+lxAnm8WpnpiGPDu7HIsV
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d88:: with SMTP id l8mr12660369jaj.95.1600080187586;
 Mon, 14 Sep 2020 03:43:07 -0700 (PDT)
Date:   Mon, 14 Sep 2020 03:43:07 -0700
In-Reply-To: <000000000000eb3fa9057cbc2f06@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000031842b05af43b363@google.com>
Subject: Re: INFO: task hung in ctrl_getfamily
From:   syzbot <syzbot+36edb5cac286af8e3385@syzkaller.appspotmail.com>
To:     avagin@virtuozzo.com, davem@davemloft.net, dvyukov@google.com,
        jon.maloy@ericsson.com, keescook@chromium.org,
        ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, xiyou.wangcong@gmail.com,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 47733f9daf4fe4f7e0eb9e273f21ad3a19130487
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat Aug 15 23:29:15 2020 +0000

    tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f287b3900000
start commit:   f5d58277 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
dashboard link: https://syzkaller.appspot.com/bug?extid=36edb5cac286af8e3385
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=139f101b400000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
