Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14D3168732
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgBUTFD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Feb 2020 14:05:03 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:39377 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729407AbgBUTFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 14:05:03 -0500
Received: by mail-il1-f198.google.com with SMTP id c24so3517793ila.6
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 11:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=6HPd5BpaEdwQYZOa0Jq69qrFdmHHelt8oh9R02313yI=;
        b=qv04FgOWdQQiHrgBXYPdO8jxgAyGS6SR/VrF3BnhMnBtw3Ag11oysQjDpUUuC+iTlp
         DhslTHbybMyBMlaPMnsvbqXT5W8QJWIsnBIFSLcVl/j2QhmKv4i/npwc90TPKlMNPW5G
         J3ILezObiVeVWl/l4fb/v+iHzrua2MCO1+Hsh/E0EJWL2XSrwPnJCdVDQNtH7QgZSUSS
         hwLvQg6gHqLACTOnAuJ76yVfSBWsaOc1hV64Z1tIm9pcBfzDT9U549lN72HIAnqGgPAO
         bzRBVTyXxyy2V/fRARyJxA+Q9zCNpL+EBS5PPquioQiq5bTbwRQuYtdzLkNYU01NJQcS
         JW3g==
X-Gm-Message-State: APjAAAXMqWk/URGzHCh0fI2U3/0+p+6wv71Io+BHIqA5dK7fpJLySdrm
        9nEeLkB4XAYbIdkXC1nuCpdwoHbDheKtlO2i8B3bNFtqCwzC
X-Google-Smtp-Source: APXvYqwLW2r3BmTlbIIeJFfAs7Uv80Ut/LNDiARQZ70MK0QKfO5+10fP12va8gN8C1TWjny8qjdR5O6xuKt+aWLqAsKZ/K16uMae
MIME-Version: 1.0
X-Received: by 2002:a5e:8e4d:: with SMTP id r13mr30243768ioo.60.1582311902722;
 Fri, 21 Feb 2020 11:05:02 -0800 (PST)
Date:   Fri, 21 Feb 2020 11:05:02 -0800
In-Reply-To: <000000000000f649ad059c8ca893@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2c2c9059f1ab2bb@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in bitmap_ip_del
From:   syzbot <syzbot+24d0577de55b8b8f6975@syzkaller.appspotmail.com>
To:     allison@lohutok.net, arvid.brodin@alten.se, coreteam@netfilter.org,
        davem@davemloft.net, dirk.vandermerwe@netronome.com, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net,
        jakub.kicinski@netronome.com, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1226da7ee00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=24d0577de55b8b8f6975
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14cddd76e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f459c9e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
