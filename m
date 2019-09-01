Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF259A4B20
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfIASXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 14:23:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39060 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729104AbfIASXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 14:23:01 -0400
Received: by mail-io1-f69.google.com with SMTP id g12so16180629iok.6
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 11:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nuF/NvQUPru9tAlC0mm8ctMiLuI0uuXct3/25gBy3VU=;
        b=G5vzhxWWvOexuN/rxcc/nuGl6oPS7pIwc9CChmC70orHA0djOD+p8C/Mf14YFgz6zp
         ULUYcsDwrTZvdENmxCbyUIxJhvjSXHZ2Yq9/9FENVa5LmXKoos1N1R0u4Zy6+9dVEQyn
         rn5aPA3VhBV+wCxYqoGgm/N8310rJXNZlyKB+LsypB3JLJzJgsZAFL4vBFW2zcGBL4cx
         i/ZMv6xb+6zjbwnfP6i5+aP7I4zAYWVaeKyl2f78icSkMXLH9sQLeK+mX0x/hukBK5ly
         p7zN/5w+HjKfPoTnCgQHHWZEkydrzhFKFlwrMsPkRBNte8xnFhtXWhazi1x/dYS0KScA
         WqeQ==
X-Gm-Message-State: APjAAAW2OatCIIvGzEZb8vGHgDHWi7Akdp9wb3OP7FV9RIZ5rhR/A4Uf
        plGKxNOa1t2Nn1GUwHA9+UsxdeZn+Seqnk08aiozorE19UgK
X-Google-Smtp-Source: APXvYqxx1JUJRFI65w6pHYwBvLIZxZYDddDgdFCblHTcdGM//eA3cmcidNDkcKZhgDPRTq/ohBQfHqUnNU60eqT/NjGvpKx0FZJx
MIME-Version: 1.0
X-Received: by 2002:a5d:8599:: with SMTP id f25mr3677451ioj.265.1567362180985;
 Sun, 01 Sep 2019 11:23:00 -0700 (PDT)
Date:   Sun, 01 Sep 2019 11:23:00 -0700
In-Reply-To: <000000000000b7a14105913fcca8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000083a86059181f20b@google.com>
Subject: Re: WARNING in __mark_chain_precision (2)
From:   syzbot <syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com>
To:     allison@lohutok.net, arvid.brodin@alten.se, ast@kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        daniel@iogearbox.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, hawk@kernel.org,
        jakub.kicinski@netronome.com, jic23@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, knaack.h@gmx.de,
        kstewart@linuxfoundation.org, lars@metafoo.de,
        linus.walleij@linaro.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        paulmck@linux.ibm.com, pmeerw@pmeerw.net, rfontana@redhat.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e786741ff1b52769b044b7f4407f39cd13ee5d2d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jul 11 22:36:02 2019 +0000

     Merge tag 'staging-5.3-rc1' of  
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11958f12600000
start commit:   47ee6e86 selftests/bpf: remove wrong nhoff in flow dissect..
git tree:       bpf-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13958f12600000
console output: https://syzkaller.appspot.com/x/log.txt?x=15958f12600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=c8d66267fd2b5955287e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d26ebc600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127805ca600000

Reported-by: syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com
Fixes: e786741ff1b5 ("Merge tag 'staging-5.3-rc1' of  
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
