Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844E6ACCBC
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfIHMdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 08:33:03 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41575 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfIHMdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 08:33:02 -0400
Received: by mail-io1-f72.google.com with SMTP id t8so14310366iom.8
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 05:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Dlrt7nF+QMrAeB++A6Ck3UTmsUjVxvwblcY1dMvaVGw=;
        b=Ttj0iT8383RBoixsxJi4rLlfoc5SDM4HtPR6zAnZVbNv9ejd029hqStmR4vEDpr1Nz
         yZ7Tha1NdMa6mmDo/lBThgUmwcAZ9d4LNUA5Ts4jlyyA1dgV/QK/Nwjgk9DI1osqtOKW
         1LWy+1s6U1rjMYLAkBrrmuEtGxN8Q/FTJP3AEQZKnZPmk4jMFYt4xYxFhPrH5LPKn6Iw
         CrP66lzJfirLaYIQaINQKvqw90YFoNIDGO1DR94YkR3Zw/XnJCY2i6tUDl4EXYuBpWkK
         +Ebk0HOj36o9NVpo32cfuOD0RU/3sex42j2d7xJjYA0DLP8SGLBmCE2UPM+mM9y8JbfF
         9cFg==
X-Gm-Message-State: APjAAAWQViFmeJzFsPcsTef7rgBOLmzZBI0/42i0u/szmvcOEaV9EK0W
        C0ppsdDA8ZVzM6LDKuCyakgTI1HzlCxl3yTe8QfYA5j7mOy/
X-Google-Smtp-Source: APXvYqxLRIrArmm5jACs2Lrk6VJ5eg+Ycgp5MA+m/Uphdu7Qq3nvbW1MwZilaMC6yRKZe3KSnSSU1qER9VS/0ttQsNbDjxeHCSFq
MIME-Version: 1.0
X-Received: by 2002:a05:6638:a12:: with SMTP id 18mr16975290jan.123.1567945980605;
 Sun, 08 Sep 2019 05:33:00 -0700 (PDT)
Date:   Sun, 08 Sep 2019 05:33:00 -0700
In-Reply-To: <000000000000d2a5c60592047e58@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000337872059209df41@google.com>
Subject: Re: general protection fault in cbs_destroy
From:   syzbot <syzbot+3a8d6a998cbb73bcf337@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, jhs@mojatatu.com,
        jiri@resnulli.us, leandro.maciel.dorileo@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vedang.patel@intel.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e0a7683d30e91e30ee6cf96314ae58a0314a095e
Author: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Date:   Mon Apr 8 17:12:18 2019 +0000

     net/sched: cbs: fix port_rate miscalculation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158f3c01600000
start commit:   3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=178f3c01600000
console output: https://syzkaller.appspot.com/x/log.txt?x=138f3c01600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
dashboard link: https://syzkaller.appspot.com/bug?extid=3a8d6a998cbb73bcf337
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17998f9e600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10421efa600000

Reported-by: syzbot+3a8d6a998cbb73bcf337@syzkaller.appspotmail.com
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
