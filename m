Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE4511480C
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfLEU0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:26:01 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:54548 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLEU0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:26:01 -0500
Received: by mail-io1-f70.google.com with SMTP id h10so1653525iov.21
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:26:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=AMndx8hKdrf5iaXiiQjZKFNKn0Vs2y02qLzZazcs3CU=;
        b=U0C5g72Kftkg3ppW629m3TnnjVR38dA6sXJe8amF16zUp4MrxLcA2vsz0Mq5Jdgq+n
         mcuG0tclYrccIdBX/M3BsWuPzM9jRiyrNQDkyTmV8ubd59s4DBn1FIS2rin8WE8Jkrpm
         F+xmshmPBY/vDhKKYZVtlpQ23xrmaokyYVZ103rNOiErZQOIAkfnWJzzjQRkZypPvtV6
         vTKSIj4qNTobi+SSStvsUH6ynH6rwLwZcep0g4NGsZ2HDwMT535aMlTWlRZE29d16Zgs
         U+/UsbLObi6v+xLsfFa8AUKXIA+Kbko4+nZ0mEGYR8o8V/j+XXclHoL5y3yVhwycyoRd
         QSHw==
X-Gm-Message-State: APjAAAV/w4mWfSUsUC8hmHPWtdcEJTBTkD84SfhGBfuPByMItjSYJSY7
        MsG94neNEBKQ79ct8VfWDroZG9k8dGhQSevs0Z0GoMZz/757
X-Google-Smtp-Source: APXvYqwiSIAto3Fuczl3Mloud2GJhz4nWhZmFjdSE7R2+4HUud1uZ12DR1iX6fOWVWwSNwnDp6A3S3YOROzLJiWU36yLPucT+7Cj
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2541:: with SMTP id j1mr7805807ioe.239.1575577560491;
 Thu, 05 Dec 2019 12:26:00 -0800 (PST)
Date:   Thu, 05 Dec 2019 12:26:00 -0800
In-Reply-To: <000000000000675cea057e201cbb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf2c140598fabc5c@google.com>
Subject: Re: BUG: unable to handle kernel paging request in slhc_free
From:   syzbot <syzbot+6c5d567447bfa30f78e2@syzkaller.appspotmail.com>
To:     adobriyan@gmail.com, akinobu.mita@gmail.com,
        akpm@linux-foundation.org, ben@decadent.org.uk,
        davem@davemloft.net, dvyukov@google.com,
        linux-kernel@vger.kernel.org, mhocko@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tejaswit@codeaurora.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit baf76f0c58aec435a3a864075b8f6d8ee5d1f17e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Apr 25 23:13:58 2019 +0000

     slip: make slhc_free() silently accept an error pointer

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114af97ee00000
start commit:   8fe28cb5 Linux 4.20
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d581260bae0899a
dashboard link: https://syzkaller.appspot.com/bug?extid=6c5d567447bfa30f78e2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136130fd400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1607c563400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: slip: make slhc_free() silently accept an error pointer

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
