Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ED0244A3E
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgHNNRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:17:08 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56125 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbgHNNRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 09:17:08 -0400
Received: by mail-il1-f200.google.com with SMTP id q17so6543207ile.22
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 06:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=IH2yFUwfReDyb+ZllS6U8RBdlomdqdJ/qVk5KbqvAis=;
        b=dlZqniQfMBRGGtbUtOpYZVTca+s48m5mOyYBcfS/IhHmlrnYYIXMTdT87qHX2Ij6H1
         58XjOqqB8jKleGxgIOc//PCUR90ndMkRXLGmuvv7fAft/kBZRyEmT9YQ/v5Oe+COhokA
         6wY2ToE8NuGyyGG3A/Xvsica0CJFXZCFz18BmptpMz8XxIEIgLrFCEgGWhH6FNs7fk//
         Bv2x3WDgCgscpsmyP/HjGGGnzD5o5jk373F5702gIxQo37Zdr8ZdRJEeHWedIOOlJe47
         IOAEqsHAw62VpnzcCCo+lo8LbbyRZoMQmR2KWQCkuRGoIReS9+yEC3PQgx4YnObVZf5V
         NpWA==
X-Gm-Message-State: AOAM530AOCbfP/l2dK2kZqG+TGQZ0IWZMSPo18Rwy7YnMOALZjbO8RUQ
        Yxf+Z3Pzv4fEoQovGBwJpru/GWocgaFiN4m8UV0BAn2KC2oY
X-Google-Smtp-Source: ABdhPJw0DlrmX1wRwvc5QY6U9kAZSrT6vpFGHl67k3p4ysMpI61y/3sf2z41wWaLsVc2vLfboRZmffcWc+uADhjTbkL89fyq6HPG
MIME-Version: 1.0
X-Received: by 2002:a92:d588:: with SMTP id a8mr2552007iln.146.1597411027574;
 Fri, 14 Aug 2020 06:17:07 -0700 (PDT)
Date:   Fri, 14 Aug 2020 06:17:07 -0700
In-Reply-To: <0000000000006dc0290581ca413e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dbe6ee05acd63ca2@google.com>
Subject: Re: WARNING: locking bug in try_to_grab_pending
From:   syzbot <syzbot+2b713236b28823cd4dff@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 1378817486d6860f6a927f573491afe65287abf1
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu May 21 18:29:58 2020 +0000

    tipc: block BH before using dst_cache

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175599f6900000
start commit:   6663cf82 flow_offload: Fix flow action infrastructure
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=8572a6e4661225f4
dashboard link: https://syzkaller.appspot.com/bug?extid=2b713236b28823cd4dff
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e932a8c00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: tipc: block BH before using dst_cache

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
