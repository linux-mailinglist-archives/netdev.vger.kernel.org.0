Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E540B9F36
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 19:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbfIURlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 13:41:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43725 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731402AbfIURlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 13:41:01 -0400
Received: by mail-io1-f70.google.com with SMTP id o6so16140232ioh.10
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 10:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Vou0Mi/j/M2Ma5Ajew5/N8RpeWCXouricDj+EREdNZY=;
        b=bKcjp4TxHTMvU/FKbYzvjsJyj5bJQN+r5ajxzRx2z2icgZ6Pw5twXzQDEZXFxsHaO9
         G9WfjuyoX8h/rMK5DLAxy8jvK9ViGEJS/G2wL1SwRr6vTd0R/NjH3jKqul/hhUtI6ecm
         f5RwP6wOKpOdBJweHsxpPLxiX+FfkC0f4edYRed8XyypnuhxakFQsCj0tKXSwn0PW2Bd
         R0EnzI+nMn6J/9KJfNeriOXVY5hKU1RA3TuoA+YLlZux+qtRi/OGQ2E7fvNHiy9XWFT+
         smkqnkY/TKJ2MuhJHuKzSMhI/axpOsxbHCIajz9yr7kMG9BNvK321jMdeNuSusVYCKZT
         xkkQ==
X-Gm-Message-State: APjAAAUpCRALuAMmVoMhxccMxZ/F7J6AL++wW6KyJhVm+v/u6zOjrq9W
        v+AN7+c7SU5Fg+bUHl0PObRrU2OXw6eiFb2m5SKEztVIlvA1
X-Google-Smtp-Source: APXvYqyr/QnaH7gCOgIYf0MJcv1TUeTtRpr75v8rwd0Su2cX1DH7UXwxXu2hOzyHWLdGdlgaclDhr2teY+qtZB+BASzqQhvSpW0K
MIME-Version: 1.0
X-Received: by 2002:a6b:ec07:: with SMTP id c7mr4441481ioh.84.1569087661223;
 Sat, 21 Sep 2019 10:41:01 -0700 (PDT)
Date:   Sat, 21 Sep 2019 10:41:01 -0700
In-Reply-To: <000000000000727bd10590c9cf6c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab325a059313b071@google.com>
Subject: Re: KASAN: use-after-free Read in rxrpc_release_call
From:   syzbot <syzbot+eed305768ece6682bb7f@syzkaller.appspotmail.com>
To:     MAILER_DAEMON@email.uscc.net, davem@davemloft.net,
        dhowells@redhat.com, hdanton@sina.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 2baec2c3f854d1f79c7bb28386484e144e864a14
Author: David Howells <dhowells@redhat.com>
Date:   Wed May 24 16:02:32 2017 +0000

     rxrpc: Support network namespacing

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16240b09600000
start commit:   f97c81dc Merge tag 'armsoc-late' of git://git.kernel.org/p..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15240b09600000
console output: https://syzkaller.appspot.com/x/log.txt?x=11240b09600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61f948934213449f
dashboard link: https://syzkaller.appspot.com/bug?extid=eed305768ece6682bb7f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf8ea1600000

Reported-by: syzbot+eed305768ece6682bb7f@syzkaller.appspotmail.com
Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
