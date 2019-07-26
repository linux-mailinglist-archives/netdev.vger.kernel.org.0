Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76A976E2A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 17:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbfGZPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 11:39:30 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54958 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387753AbfGZP0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 11:26:01 -0400
Received: by mail-io1-f69.google.com with SMTP id n8so58997431ioo.21
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 08:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iHIZY3n79tjWiqF4FrsxNYHlKLoyYYCqi0zeJqFjTkY=;
        b=jap4mcDg8eGdhgaODJJvV5QAKMzREM7cM8yem3J590Rnm68gxOetDMRg2ItyYOnbeV
         1/9Vw7Ndv9cXU78jn0oETZnf3NL5Ce0ELThUfG8nx1ApYzL5EnP9EYY7lV/93aLSqSeg
         f5Xk9/yNEYm1eWBIH9HoIiVfQNHxxka4QImp/RjjgZrwxLWmZCB9da35CCs3dEVNjoic
         +3B5QSwcOJgvC+wBXG5y5UPaEXQWazUY0rf36zFjWPnsw35l7d6nQ1gI2b0ShP4+9tIy
         BqBtoo2ocrGI/WEYKUyY0mG1+i0DyCuYrtGhWnW8cmtBES6hL1rMGR3kn2Fg6hUjC0Xp
         GHDA==
X-Gm-Message-State: APjAAAVx4gOUTh2HlaKcByIGo4BnOpAsRRoZ/3sN2GVq+nNsXkfQUeb9
        cVZUhTwEuAwQgaEqpDeVDE0gVSM8cLkwbY9OWwLz6AGcrwyL
X-Google-Smtp-Source: APXvYqzHpk/vEMkIMKMtiMdg8PB4RYhne1o6pJ8WL+G6Degv9dbMalQiRsRdhyVuMJOgTkwheM+dhLdMfqp+YLyIul4ruGrn56Gi
MIME-Version: 1.0
X-Received: by 2002:a02:4484:: with SMTP id o126mr98783066jaa.34.1564154761082;
 Fri, 26 Jul 2019 08:26:01 -0700 (PDT)
Date:   Fri, 26 Jul 2019 08:26:01 -0700
In-Reply-To: <000000000000b4358f058e924c6d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e87d14058e9728d7@google.com>
Subject: Re: INFO: rcu detected stall in vhost_worker
From:   syzbot <syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.lkml@markovi.net, mst@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        yamada.masahiro@socionext.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0ecfebd2b52404ae0c54a878c872bb93363ada36
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jul 7 22:41:56 2019 +0000

     Linux 5.2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118810bfa00000
start commit:   13bf6d6a Add linux-next specific files for 20190725
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ae987d803395886
dashboard link: https://syzkaller.appspot.com/bug?extid=36e93b425cd6eb54fcc1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15112f3fa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131ab578600000

Reported-by: syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com
Fixes: 0ecfebd2b524 ("Linux 5.2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
