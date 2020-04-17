Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFB1AE568
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgDQTFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:05:04 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:48834 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgDQTFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:05:03 -0400
Received: by mail-io1-f72.google.com with SMTP id w10so3025974iod.15
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5c8LCDRq12f8g3OYrnBxOb2S1vJ1If0MMyvK95Cf5Fk=;
        b=h0ylXllL1pef1LdUiwwcjlyRsN5iN9LgoB08fyg2tyc0UL8c7fNvApwmrXjhwFGlGD
         aC0S2U+PjlLHIeBXLJ43zdk7cSZQeLzu9rCxJEiGdOv7TaGqgYC2idpkXiAx+GUxgB5o
         J7O1akQHc1LN28s7/74TMyTgmF5kXiffahs/Oejpt1mA5DXDlrNQT7fDPDckPDXBdAVl
         GNX74oYW6o0dAVMCXON3KY+dYZpcQBhXEOTn/vNQX201jADo9PLWbqA2Dfc5QHAwdowU
         Ptk0I0LwMVKHPhSpgh4iF1FVzqJNZnDPUswAbbSpOqAqfLCe7338u1gcH3LONj7Jdmwf
         vi9w==
X-Gm-Message-State: AGi0Puajx0ALS4DTuPK69bINo9x2YgP7QW/7b+pch6z8dBYwks/ZvEEC
        9ETA7l1UJNvxkMLdkRmzrnHuDIzO5plffGk33qYe9tBCQ/ts
X-Google-Smtp-Source: APiQypKsq7TxaiPrXeHTLAURaor6Vs0GiUzQw/HOVdjNTAiVTr5h6r9VDsXe7qVE1r1NZsa4mN8p+sOD4iQMPGQkiM1vyKec2V7l
MIME-Version: 1.0
X-Received: by 2002:a92:b74e:: with SMTP id c14mr4736743ilm.52.1587150302788;
 Fri, 17 Apr 2020 12:05:02 -0700 (PDT)
Date:   Fri, 17 Apr 2020 12:05:02 -0700
In-Reply-To: <00000000000088487805a116880c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000000c55c05a3813a66@google.com>
Subject: Re: KASAN: use-after-free Write in tcindex_change
From:   syzbot <syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 0d1c3530e1bd38382edef72591b78e877e0edcd3
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Mar 12 05:42:28 2020 +0000

    net_sched: keep alloc_hash updated after hash allocation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a956d7e00000
start commit:   ac309e77 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=ba4bcf1563f90386910f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1771b973e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1248a61de00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net_sched: keep alloc_hash updated after hash allocation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
