Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4967AD052F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfJIBYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:24:01 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52288 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfJIBYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:24:01 -0400
Received: by mail-io1-f71.google.com with SMTP id g8so1718446iop.19
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 18:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sTtRhHB+FIjWWxBw0tW/N10Uhy+DblHPCwc6eoAtz5k=;
        b=oiAWWqUylNr3KOETw/hKXjooTyE40LpNUb3gnh6GCEbRBD91yGcllcNX4o+Nvc7d5K
         LZzk/FZl9Aw7cZaqU3o0yl7XB0O1G04Ron2Ztk3xH14Rspw2rcVnTGATUey7GEWkcdB6
         Y9GX7KrsnAdhU2n61jw0s5aWQaYJh/ENkBk62gQfISZUYC5efTE9r4ys+AjQf/oQfigd
         5gVVwnFRFYINppyv4Rd0RaGw+hSGyMcXOT05cYqidsNlu9fdgJKon8eDAUCIhpyVWXqu
         QNCl2jW5/x+zmjsnTUu/JqlwLyvPnm5mwF7fmyVkZd6fxLoxNy6tqZHSjXBRyonZToSP
         gW7Q==
X-Gm-Message-State: APjAAAUZEPWHIGUA72NH/HQI1cG6syJWKUCMuwlRtOlAt0tWDP+JZFO7
        JNPgnLePXqYSHCAzzuudK1oYIPAuyRdudRoYQTc1ITyMqHoO
X-Google-Smtp-Source: APXvYqyml+7hac2zw8kA+I+beki59R3+vmtmhi38APoNrgs+TwehFpFdJXlSQvQdoHGpVepARpzBN69101g2pAxrteTrw07JUTF4
MIME-Version: 1.0
X-Received: by 2002:a5e:d917:: with SMTP id n23mr1244594iop.28.1570584240714;
 Tue, 08 Oct 2019 18:24:00 -0700 (PDT)
Date:   Tue, 08 Oct 2019 18:24:00 -0700
In-Reply-To: <000000000000ba89a9059456a51f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1f845059470233a@google.com>
Subject: Re: KASAN: use-after-free Read in nl8NUM_dump_wpan_phy
From:   syzbot <syzbot+495688b736534bb6c6ad@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 75cdbdd089003cd53560ff87b690ae911fa7df8e
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Sat Oct 5 18:04:37 2019 +0000

     net: ieee802154: have genetlink code to parse the attrs during dumpit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14620210e00000
start commit:   056ddc38 Merge branch 'stmmac-next'
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16620210e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12620210e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=495688b736534bb6c6ad
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e256c3600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175ecdfb600000

Reported-by: syzbot+495688b736534bb6c6ad@syzkaller.appspotmail.com
Fixes: 75cdbdd08900 ("net: ieee802154: have genetlink code to parse the  
attrs during dumpit")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
