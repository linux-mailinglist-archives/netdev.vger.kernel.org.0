Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CB445CB51
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349228AbhKXRpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:45:32 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51011 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344751AbhKXRpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:45:20 -0500
Received: by mail-io1-f69.google.com with SMTP id e14-20020a6bf10e000000b005e23f0f5e08so2433548iog.17
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:42:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=h0kvn1BdxoP46i2HNoKMazuHRf6SKPJskeY6V4kDJOE=;
        b=FVRPXlFZS9UIuinlw6NmgC0i/tIjbmwIXf4vU8LL0wSmb7ohJWDUT1CzY2OBB2kQb7
         2A0HQc33YP5k/gF6R0Mkzid3daw4hjiO80yBY2QycEpBy3GyGpa7KeMUbf18dZ6vgc6k
         mY4pfMW3VZwxN56ifaF5wdFVr6G8+wALKtsZJrpzLgbYaxEbNUZwkgWW2qP2d8xXBdjQ
         SFT84jBNvHu3nlrdtlKU1G526Z9IfA+aqFwWQm955by1Afuvz8+6x7PbSJjQZaZa2+CG
         KMUkcu7kklbE7QkHvORCihjP9AHOm+OCzyrP9hC5bwjg6Z8b8XnavGHMGUIbVQZCfseg
         hapQ==
X-Gm-Message-State: AOAM531dR1ORtktECOStW/73CDmLbtfr2GjiGpSfVbUtyPjHdurBfoGC
        +tEer6isMkkhS5httj8zTL1sXYMqlw7FCiEAUfYHotQdPa02
X-Google-Smtp-Source: ABdhPJwb7HvyUqHy3UoRecfI82f0bvHWHU2TDeSHzrJEyGEuUEO081UcqCkKr9ePW6QOXrKgj7ioth7zzj1e0gFO8okXtgY78HTC
MIME-Version: 1.0
X-Received: by 2002:a5d:9cd4:: with SMTP id w20mr17292523iow.178.1637775730232;
 Wed, 24 Nov 2021 09:42:10 -0800 (PST)
Date:   Wed, 24 Nov 2021 09:42:10 -0800
In-Reply-To: <000000000000ba80b905cdcd8b19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f52f205d18c60a7@google.com>
Subject: Re: [syzbot] WARNING: ODEBUG bug in batadv_v_ogm_free
From:   syzbot <syzbot+0ef06384b5f39a16ebb9@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, a@unstable.cc, amcohen@nvidia.com,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, fw@strlen.de,
        idosch@OSS.NVIDIA.COM, justin.iurman@uliege.be, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        praveen5582@gmail.com, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, willemb@google.com,
        yoshfuji@linux-ipv6.org, zxu@linkedin.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 6f68cd634856f8ca93bafd623ba5357e0f648c68
Author: Pavel Skripkin <paskripkin@gmail.com>
Date:   Sun Oct 24 13:13:56 2021 +0000

    net: batman-adv: fix error handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114e3c16b00000
start commit:   cf52ad5ff16c Merge tag 'driver-core-5.15-rc6' of git://git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9479508d7bb83ad9
dashboard link: https://syzkaller.appspot.com/bug?extid=0ef06384b5f39a16ebb9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17af7344b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15dc02fb300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: batman-adv: fix error handling

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
