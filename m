Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E795C95F9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfJCAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:39:03 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36522 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfJCAjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:39:03 -0400
Received: by mail-io1-f69.google.com with SMTP id g126so2356157iof.3
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 17:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hAyRxHbLq7PsOy9LqQwegUEDVde8994wxe1XrflzGUM=;
        b=ZLwF+itkhNAFSuy1ZOGm/4Ac2X4y+GfsdMwS0ZIq3R1PY3vAGQzgqp8TRWcY662iUF
         NGJweDthzcFabMWuwx5iKTUZl5i/LsKesCFlcRekF7X3M6dS8lJyrkwmiNVU7r96luE2
         oCTDxW10BhWTurSat/FZrT0TN+CXm+ceQA7uTFGu/WcgyRP2HqzwGQ4IkpvydJ2UFRBn
         /J6rlWKUkkZRZK4GysZv7fUXI15/cj/KNWO+zUKOXPsz1iXJuu9KHsJqK+GcKaBa0M0U
         A+b5qWIi/rIwNeiYNPzTynKLb7sJMf+gZKlRMFzTWWz0K7m+S9VRk5h/Ky06bYL0Hcuu
         G8yw==
X-Gm-Message-State: APjAAAXyAMnObmMNHKxuiHpBt+A/jOCGhq+xiU65xV9YNVbhoIB1ZzN4
        x8rJvq4SIRH+7CWnglFT5wDmrDg/7w/y90SOWeC9Qx2aBscP
X-Google-Smtp-Source: APXvYqxLjRUmgh2d6EecgdKK5+UBkQJlDH3RJylgogoZWNEXOfN2dd+nu0IV57qzRQ40+amE9KW3w1+hdoL4brm4t/WLU7XYn/av
MIME-Version: 1.0
X-Received: by 2002:a92:9915:: with SMTP id p21mr7204717ili.74.1570063141284;
 Wed, 02 Oct 2019 17:39:01 -0700 (PDT)
Date:   Wed, 02 Oct 2019 17:39:01 -0700
In-Reply-To: <0000000000001530e00593f47496@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cfb2cb0593f6cfad@google.com>
Subject: Re: general protection fault in sit_exit_batch_net
From:   syzbot <syzbot+1695af5ca559927e2db8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        gbastien@versatic.net, idosch@mellanox.com, jiri@mellanox.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, stephen@networkplumber.org,
        syzkaller-bugs@googlegroups.com, willemb@google.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ff92741270bf8b6e78aa885f166b68c7a67ab13a
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Mon Sep 30 09:48:15 2019 +0000

     net: introduce name_node struct to be used in hashlist

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13719e33600000
start commit:   c01ebd6c r8152: Use guard clause and fix comment typos
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10f19e33600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17719e33600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ffbfa7e4a36190f
dashboard link: https://syzkaller.appspot.com/bug?extid=1695af5ca559927e2db8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1156242b600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17253b19600000

Reported-by: syzbot+1695af5ca559927e2db8@syzkaller.appspotmail.com
Fixes: ff92741270bf ("net: introduce name_node struct to be used in  
hashlist")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
