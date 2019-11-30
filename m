Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC310DF53
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 22:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfK3VED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 16:04:03 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51975 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3VED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 16:04:03 -0500
Received: by mail-io1-f71.google.com with SMTP id t18so17272290iob.18
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 13:04:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ajRnvypnjscQlLjcnb2EcjX6WsZvwjmcn8iDAJm1MBA=;
        b=jBrEC0ibeqO9WPDvRNraMSkJbzvWQbGdg9XhSgeqXkDWb7q5DuR5o7NnaugkhLWXsG
         2XKUJBdrs60dEMT8uwOlhUg99Kq846yTG5YsdGiLuttvrWZlwH0331xVC78uHQPRlbwD
         tdgcZAsu5TjjxVA88BoXxFv4kd+tEXHh9aCzgpItDiHerEhYPLhzGlwxzkhq7G7PTGcL
         LVRIMoAk/r+qP5QCp3yJe+UeTuntFQtULwrVSiUo0XgnX2arp0aEBJnUPIJ9WfgjNDTL
         1q+50wHjydzgc1+5olp9URzJ7xn7mTHUawt85TuR+R9pUCnfy2Xk1uAKH2q0WIISQZkG
         Y8rA==
X-Gm-Message-State: APjAAAWk6fvuWx3/JE7AVx2BKb1B+CbgPIWX9aKB4czTcDL1Nb0mkrL7
        z7Auj3IX1CrIMmaH/xIWv+zfZElxiVKnF1R8qGW7wYndDq6e
X-Google-Smtp-Source: APXvYqyk0rTcqugfdtur6uiuIuBVEo0q39xqazGWbjHn8D5vwxIrxEHCKojMOgpwHWUMv5+j3+qw1ag0Lxh+CojKUAkDMAHfCxI3
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3b6:: with SMTP id z22mr8076076jap.35.1575147841422;
 Sat, 30 Nov 2019 13:04:01 -0800 (PST)
Date:   Sat, 30 Nov 2019 13:04:01 -0800
In-Reply-To: <089e0825d4a4d2cb2a0562e878f1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008e8a99059896af4c@google.com>
Subject: Re: possible deadlock in sch_direct_xmit
From:   syzbot <syzbot+29cc278357da941e304e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        lucien.xin@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit c84bed440e4e11a973e8c0254d0dfaccfca41fb0
Author: Xin Long <lucien.xin@gmail.com>
Date:   Sun Oct 1 14:00:56 2017 +0000

     ip_gre: erspan device should keep dst

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=153a767ee00000
start commit:   c92a9a46
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=173a767ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=133a767ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46986c099cb53bc6
dashboard link: https://syzkaller.appspot.com/bug?extid=29cc278357da941e304e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143636c9800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16856849800000

Reported-by: syzbot+29cc278357da941e304e@syzkaller.appspotmail.com
Fixes: c84bed440e4e ("ip_gre: erspan device should keep dst")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
