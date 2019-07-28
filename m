Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E86877FD5
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 16:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfG1OUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 10:20:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:49854 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfG1OUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 10:20:01 -0400
Received: by mail-io1-f69.google.com with SMTP id x24so64624459ioh.16
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 07:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hnSE0IkAtQQd9LTTGkd+F6q8mkeCAgFd7SlsTWCyTMI=;
        b=P6IQ0o+Qmil1I01yhJ9aaQO1razyAkqrti1epihR4OywF7ikrlRI1fxHyHab5HAw0Y
         LPRXQZiJli6wcbJwf4mEhRUEtlOJyCj5StNRoatlmPIyrq/QrU3cyNcFhyi+KU5UDjqh
         lWLDI+0oGrN5OQ6dUajgpN3y016XGoTtILNK4PgEopknIo+SHOA0QDLE1F33SIStUXRc
         lPjp/I0qmsDQPUaYU+KifDdlF9apeaJ1TbvhmHfWZJjx7R+CoZ/k3XgOHClW2Q9GGX/f
         KGWPAB2B6voKusKqGIqX6VAQcFRxp6NeT/FJrqquVJVVKrEysroGayRC/l1e2PcRzTnH
         4ZIg==
X-Gm-Message-State: APjAAAWE8UrD6zWkIXO637HDtouFTqZAAgOH223DtgpJVVd6MFYejN1S
        ThCYJ5G2RNDxOuzQSx7hCtorvF6sjxbOLsOuH9Y6S3JZ6Lsa
X-Google-Smtp-Source: APXvYqzqsQPOZw9eJjrE3cvYQcF0WB7rEVn52ueiw3GFmGkorKwxWzihfkn52GZd9Jx4mk8mOoeNflmypz7lP+W90dHc9moAjCoN
MIME-Version: 1.0
X-Received: by 2002:a5d:924e:: with SMTP id e14mr88096039iol.215.1564323600914;
 Sun, 28 Jul 2019 07:20:00 -0700 (PDT)
Date:   Sun, 28 Jul 2019 07:20:00 -0700
In-Reply-To: <0000000000005e6124058c0cbdbe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008be1b2058ebe7805@google.com>
Subject: Re: memory leak in fdb_create
From:   syzbot <syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, bsingharora@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, duwe@suse.de,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 04cf31a759ef575f750a63777cee95500e410994
Author: Michael Ellerman <mpe@ellerman.id.au>
Date:   Thu Mar 24 11:04:01 2016 +0000

     ftrace: Make ftrace_location_range() global

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1538c778600000
start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1738c778600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1338c778600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
dashboard link: https://syzkaller.appspot.com/bug?extid=88533dc8b582309bf3ee
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16de5c06a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10546026a00000

Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Fixes: 04cf31a759ef ("ftrace: Make ftrace_location_range() global")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
