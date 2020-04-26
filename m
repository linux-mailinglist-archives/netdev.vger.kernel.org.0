Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59D71B9297
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 19:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgDZR5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 13:57:05 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51195 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgDZR5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 13:57:04 -0400
Received: by mail-io1-f70.google.com with SMTP id a12so17980284ioe.17
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8TjkhMFVPAtlJvNNJhAgu9a5c+xNP6W5RwxgCUtPT8A=;
        b=SKIqaSJfyjPdglSDD7/2avshswhpdoqVwU0GN2FKHAt/oALaXQ96EYwVf+ipIlQCbN
         H9OfolVZbIXYFkcUg/PnCfXc80FmmVqTYzst0N3SEJSdttDCyzYMQR9B+2w5I1ffm9Ex
         OaoR1xbH79homPzBMAUxk8+oSpzaiuUJiwQfPY+X2s1sl+++OBMEdtuM1kEmBSbYuExy
         FcDwq2gTxS4AxqlK//WKgnaEDX3blN01WyOc5JWHxoVlXPnUbLpI4zpbimpYMx99B/bM
         E1c4jTg5pKYhItMW4pSvYJBcYKt8zHMkSJdlPdc2xHusnAnlG5fbuekL5I2j+esxcHF2
         PVtA==
X-Gm-Message-State: AGi0PuZxEilmveO5UNFM+v54znCHXgdyxQzjgJReDL0UTNsuXzJOi9Ss
        pgLuoN6S6Fqt2LNwc333GPpEKs92RxiVQlLgZTAM3b+42daY
X-Google-Smtp-Source: APiQypJ1WErfclfWRklquQXKUFrHvg+ilCR/GXhMmL7xYap+ltlezJQoVrYWsI2Igs/lBP1SJGZYdLEjU0efu91+I8ON/mzNsiup
MIME-Version: 1.0
X-Received: by 2002:a5d:8715:: with SMTP id u21mr2705169iom.46.1587923822561;
 Sun, 26 Apr 2020 10:57:02 -0700 (PDT)
Date:   Sun, 26 Apr 2020 10:57:02 -0700
In-Reply-To: <00000000000005d1ab05a4351006@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fd19505a4355311@google.com>
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
From:   syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, jason@zx2c4.com, jhs@mojatatu.com,
        jiri@resnulli.us, krzk@kernel.org, kuba@kernel.org,
        kvalo@codeaurora.org, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e7096c131e5161fa3b8e52a650d7719d2857adfd
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Sun Dec 8 23:27:34 2019 +0000

    net: WireGuard secure network tunnel

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15258fcfe00000
start commit:   b2768df2 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17258fcfe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13258fcfe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
dashboard link: https://syzkaller.appspot.com/bug?extid=0251e883fe39e7a0cb0a
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5f47fe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e8efb4100000

Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
