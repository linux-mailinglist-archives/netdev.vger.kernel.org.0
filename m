Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F0134888
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgAHQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:53:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40474 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgAHQxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:53:01 -0500
Received: by mail-il1-f198.google.com with SMTP id e4so2540815ilm.7
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QolCxUn5s/4K7GKyA5X2xLHSsYz24NpJzFUvvR3OMz0=;
        b=k1BWwY5Iud3Icz7btAarusH0D6oVzsin2wtGi8QOfXzC3xmwxoomQpBUtPliTdzmTp
         AJvGxWQvIsxCKcsE708ntKfthY1/MFMG5XBognoSomIPqFvKw7NSGofZe+zBK8PoXy+A
         pOQ7Btg01tbcj4XKh1wcNP7zLoJwcJZsif6KUDoOak67iJwoAM540zwB+IwIg21rvDZo
         B9IDjzBKhF2xbvDswja84PB7ua0G0YE1SfsHEAVd68LwjU7+83Zce29q9nuuIoGEiVA9
         89OX6JfHMFEgpMZLqXDQuaiOmpdMZw9RXziDvHcHVotMhRJRoFb+thi2jRjzOK6lh0oq
         tTpw==
X-Gm-Message-State: APjAAAWhUYB6AX+JtglWKnkI8JKDbiB7cMdNc2F+YG1U0mibnZ8lTsON
        kcwUOLu85AnXssdMj2JUDrbwkik5w7jJkOmWMS9BOfHKvuVO
X-Google-Smtp-Source: APXvYqw7GKpl01VnwgT3uyXH2jOmkGxwN/KTGFcWtwBlYHLJt+Fn1jSB1cHbmeA3E1QqBW3DFyLuj5USskG7K+2UGNRRJRO1ZW6V
MIME-Version: 1.0
X-Received: by 2002:a02:2446:: with SMTP id q6mr4800559jae.78.1578502380699;
 Wed, 08 Jan 2020 08:53:00 -0800 (PST)
Date:   Wed, 08 Jan 2020 08:53:00 -0800
In-Reply-To: <000000000000a347ef059b8ee979@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000adcc3c059ba3b9e9@google.com>
Subject: Re: general protection fault in hash_ipportnet4_uadt
From:   syzbot <syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, gregkh@linuxfoundation.org, info@metux.net,
        jengelh@inai.de, jeremy@azazel.net, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

     netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13a9d115e00000
start commit:   ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1069d115e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17a9d115e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=34bd2369d38707f3f4a7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118d6971e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b47c9ee00000

Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and  
protocol version 7")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
