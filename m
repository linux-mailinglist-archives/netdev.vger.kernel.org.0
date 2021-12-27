Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5511C47FA72
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 07:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhL0GJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 01:09:09 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:56859 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbhL0GJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 01:09:09 -0500
Received: by mail-il1-f199.google.com with SMTP id a15-20020a92d58f000000b002b452d7b5ffso9369088iln.23
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 22:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=unjn7X6K3rrzNU/l+8Jw+B6hhKFnH/4HAxILo3tMAEk=;
        b=D287B9v83ZioeIhgvnRpr+IF/gP4kHp87tRX3rvCeVxy/rGs+tmyRNQKXAezO8dxAP
         uFzZV69dC+9BGeX+rI5ktooRecZD+E6WApakTKMfIx3JLwjbHFaHIgBIiFWiUrTfEmQ+
         fNzYtpzwru1MIv02DA3VLvyjD/tUvt6VkV+2lrYVN2Iq/erkrHBEdFuS99h0andO5rW1
         N6ZEiYTvzjoiG7UvzIfUeRa/71MAHdfbjE+6zYB8taKBAfZu+SVWk6ghddgnFd8zthLe
         vSbR/1yL4TDGrRenZhDz4kZnafm4EsnxbY//LYLYmz0Jt2imvzWP01yB7P6D9kt0Dic2
         kM7w==
X-Gm-Message-State: AOAM531NWPgxok25GOzmR1MwWlGT9dqIohJ/q/PS94oLMSm6A2ETUVpB
        fg94fJa9Zmk14szWtc3JC0UR1JawHAW5q6uyhwQ3bcdQCX+l
X-Google-Smtp-Source: ABdhPJwACejVfVL9+7l7+kS518IEvGSPs4tr19NzKLmykGwDdv+/wb4a9B2073UiwjnSk6RDe9bkJ7doubPE8BDHug71X47dC5wU
MIME-Version: 1.0
X-Received: by 2002:a5d:9f01:: with SMTP id q1mr6892053iot.144.1640585348815;
 Sun, 26 Dec 2021 22:09:08 -0800 (PST)
Date:   Sun, 26 Dec 2021 22:09:08 -0800
In-Reply-To: <000000000000e37c9805bbe843c1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f09fca05d41a8aee@google.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in nl802154_new_interface
From:   syzbot <syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com>
To:     aahringo@redhat.com, alex.aring@gmail.com,
        anant.thazhemadam@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 451dc48c806a7ce9fbec5e7a24ccf4b2c936e834
Author: Alexander Aring <aahringo@redhat.com>
Date:   Fri Nov 12 03:09:16 2021 +0000

    net: ieee802154: handle iftypes as u32

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1084d10db00000
start commit:   ec681c53f8d2 Merge tag 'net-5.15-rc6' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
dashboard link: https://syzkaller.appspot.com/bug?extid=7bf7b22759195c9a21e9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14398d94b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117fc40cb00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: ieee802154: handle iftypes as u32

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
