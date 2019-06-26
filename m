Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548A556181
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 06:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFZElC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 00:41:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36443 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfFZElB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 00:41:01 -0400
Received: by mail-io1-f71.google.com with SMTP id k21so1155514ioj.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 21:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jsPciA+puK9ooK4TlyjKh7gObZtMQdfgKm0QqLbpEs8=;
        b=MF32AjuEpBHRLjAXnWTRXLbHE8BPWs0y27DtdrXxQ4KkzUcmfq6tTGtJ+AZgG3qgUo
         WCd7kX4tYAyUM3LH54KTNkQkQMzivzkum7c1s0vy3qi0IFTkt3w26+CvCZD8nQRKuOeF
         i814+ib/FUzltbVnq5Oq4FdGZpeTLe5MlTS/vEx3WUCUKwgS4qZdUATiXGt5KeE618S9
         4TUR11DIoRHWLbiy/QYrd1WrN8IOrapjJx8QVysCERvuPl1/AXl1VR7P8lC/JHpN7mry
         MmQedFlBKNjMVX1tKv/jFEL78fi3+UB4TgLLETb0CerLztJQUJJvnHLi7a9lQoaGqU1r
         o1uw==
X-Gm-Message-State: APjAAAUYsAu8DdDQxioms2N1tsjP94SZlLIgP66BOLHgXCZquVxUqhTq
        M+GQZ0qnFJzruq1rAMji8aApp8Mz00ebzNLI9fRRxO83BgGc
X-Google-Smtp-Source: APXvYqyXfpl4H9vcElTo0RyNBNTKRr1zt/joRVze4f5+kmA0j1HSzuur+KvWjGLp4vBlUOXhsUCfd2sdQ0vWM9rH41vo5ex9cnt8
MIME-Version: 1.0
X-Received: by 2002:a02:54c1:: with SMTP id t184mr2597199jaa.10.1561524061066;
 Tue, 25 Jun 2019 21:41:01 -0700 (PDT)
Date:   Tue, 25 Jun 2019 21:41:01 -0700
In-Reply-To: <000000000000c7a272058c2cde21@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f7df7e058c32a611@google.com>
Subject: Re: kernel panic: stack is corrupted in validate_chain
From:   syzbot <syzbot+6ba34346b252f2d497c7@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d4e129a00000
start commit:   249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13d4e129a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15d4e129a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
dashboard link: https://syzkaller.appspot.com/bug?extid=6ba34346b252f2d497c7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135e34eea00000

Reported-by: syzbot+6ba34346b252f2d497c7@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
