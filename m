Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249841639D2
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 03:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgBSCID convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 21:08:03 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:56815 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbgBSCIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 21:08:02 -0500
Received: by mail-io1-f71.google.com with SMTP id d13so15214246ioo.23
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 18:08:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=4diWwWLXm7lY/GHl3gvscC/1M0a1R7YH2cSj9Fw5eHQ=;
        b=FOSZCDv5h7bQDPethG5H9GBRNTchRQP5rZ90OODeji51NqHL5+wHAol8/IlflDCXWy
         v+OF/JF5+wl+9bfnblhC5FRbTgPPXuYR2r9IqkWOTFQkz326oPWDDXIQGG/P9RL6cxV2
         xZQaeIUCA8U33XIYZUPUrUEAgC9TgQGvCefMiljg8tzx8TKGJapnE8TYlzxxgzIG+Adc
         oXQLV72udIPRPYY6nqOwnyaVHWtShDA+I8MBUQkEx8035hRxas8xuxcIlsR4TOLnvJpI
         TV+qnMijsfPjyAIA1IEHsQ8B+HVUhuu/vyZZ3TATc1NC0CSo+Y4dgFYPRdV3unx8L6bP
         4p/g==
X-Gm-Message-State: APjAAAXVlTIQ+WGOGcnaiBgRfLSzWr3ToCe4V8W8IR1UFuJESHkWf0TI
        JTVfJc632nH71WUqSFZJZptyu3Gp6ZPUd0JGCeZ61dHQgnH9
X-Google-Smtp-Source: APXvYqzdxPP1bcYe7a4xOJJ2PZvwgFfZkFkliW3rcWAp+NO+QUzOk5XyZt5pyzhMqqramXLk6gwjJUtyolpYMy0PBvZtFLrsOuX6
MIME-Version: 1.0
X-Received: by 2002:a92:15c2:: with SMTP id 63mr22276770ilv.111.1582078081462;
 Tue, 18 Feb 2020 18:08:01 -0800 (PST)
Date:   Tue, 18 Feb 2020 18:08:01 -0800
In-Reply-To: <000000000000bb0378059c865fdf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d774c059ee442e6@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ip_destroy
From:   syzbot <syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tanhuazhong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17fc79b5e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8b5f151de2f35100bbc5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e22559e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16056faee00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
