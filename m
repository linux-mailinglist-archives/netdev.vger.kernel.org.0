Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA06131D28
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 02:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgAGB2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 20:28:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:48148 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgAGB2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 20:28:02 -0500
Received: by mail-il1-f200.google.com with SMTP id u14so994251ilq.15
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 17:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=75DRJK5klYoLUbzgyGRVpTRFYRrPHK+zNd4vNtL85ZQ=;
        b=Hln5TRLp1lGx7Vg0runY7UpS9yimFmS12Pj068o5XGAt5MkBrWhA2t4BeQ4Oo9U4+A
         SXYXjWEYkjlFAfn6qzrplNZZpChhkrPs2USEPp2D8GrIR1x1pnYEl/SeJTYnJdzdBnXo
         Z0IBROk/lnYhbrQJVBm0NhJu4DuIq/9RTpgnkODPzTNA0P0db23b/8zneKMFvgP+lyMU
         9LjSnxASubCDSi6OW+mnGpDDXOY3yjYoNPfRs50+NEOlTUh8ipEzH4YWZNgGZN8knlrO
         C9NvH3AoNuy2gvoRVMGLKuArNP77uzaK1byXJJHWN/JYsv6jpwt2TL564eaEv7eus6ov
         msyw==
X-Gm-Message-State: APjAAAWCHIdygfL7Oml64XfWeQZ6agqugFg6W1+flCbxIpqEBKg4GrOe
        w7XKP2pSw97jg4uK/wG5WaHvmS8kKDj2dABV/qJ64JYqVxB9
X-Google-Smtp-Source: APXvYqze6nKMW0nX6ASAFlo5hVUFSK6rrj7ZAUCJAj0dZPg3taWf89Wj800pPzrot4VgciXRshJGrcRY8N62dRXGw0WFccatqMpz
MIME-Version: 1.0
X-Received: by 2002:a92:d151:: with SMTP id t17mr73212526ilg.175.1578360481266;
 Mon, 06 Jan 2020 17:28:01 -0800 (PST)
Date:   Mon, 06 Jan 2020 17:28:01 -0800
In-Reply-To: <0000000000009cd5e0059b7eb836@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d04359059b82afd9@google.com>
Subject: Re: general protection fault in dccp_timeout_nlattr_to_obj
From:   syzbot <syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit dd2934a95701576203b2f61e8ded4e4a2f9183ea
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Sep 17 10:02:54 2018 +0000

     netfilter: conntrack: remove l3->l4 mapping information

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10957485e00000
start commit:   d89091a4 macb: Don't unregister clks unconditionally
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12957485e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14957485e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=46a4ad33f345d1dd346e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ff2869e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16693751e00000

Reported-by: syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Fixes: dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping  
information")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
