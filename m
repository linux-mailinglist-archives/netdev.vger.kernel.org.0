Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F9D911A1
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfHQP2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 11:28:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39395 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfHQP2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 11:28:01 -0400
Received: by mail-io1-f69.google.com with SMTP id g12so6721976iok.6
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 08:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qXE76hfKHYN2qVI6DJHVNV4EHRnZduBHUK4jM6XkuBk=;
        b=thVrsTD7L8BM1M73Ovi7XLxNJtRozX3S3g8c5GTJ1ExjYPmZz0Gl2eFRFm6Ok+3gVy
         QZ3yLcaV6Y0/A0exD6blCVXW3023esxRa8S8DS2d+Dz8uIdaaR2zeuLmPNJW2jRG8RLD
         cw20jwylq3U235MTBLZT3O/BLyotkovZn7xut/PiaBl4J8sPsp1+cCvIW6VoG+69EQPV
         50/7ll1Z2FM4LseB74XMHJY/1lw2/EBLITvv20+revlem/trKFItTAbsX9ZdJWjWapGJ
         frU288CpjKe8lgsa2AZ2v3fJTiv2THJZnvBgqMtEbk2CK4+84Un/hWcQPh6HCqs7WvAt
         UrSg==
X-Gm-Message-State: APjAAAVovEgYryKJYjddVoPPjAY28BvP0FRgwEEHZ/wa/KU4aMheC2Ob
        DrS0l3QrNoZ+M+qaVHAkKmr0q1Om9TCGk5ygyzlYc44QN4N/
X-Google-Smtp-Source: APXvYqy32T19mCY7ScSzCH1AG2iuA/7tu57F30CzrxJU8e3Sn3tTW2DL/KSoBpfG8OZDLLKbeWQvoE0KFNbqI5MpLRsdLPIx4Cxm
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2193:: with SMTP id b19mr11372341iob.113.1566055680310;
 Sat, 17 Aug 2019 08:28:00 -0700 (PDT)
Date:   Sat, 17 Aug 2019 08:28:00 -0700
In-Reply-To: <0000000000008182a50590404a02@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000860647059051c0b8@google.com>
Subject: Re: kernel BUG at include/linux/skbuff.h:LINE! (2)
From:   syzbot <syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com>
To:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, idosch@mellanox.com,
        kimbrownkd@gmail.com, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vyasevich@gmail.com, wanghai26@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit bc389fd101e57b36aacfaec2df8fe479eabb44ea
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jul 2 21:12:30 2019 +0000

     Merge branch 'macsec-fix-some-bugs-in-the-receive-path'

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=125c5c4c600000
start commit:   459c5fb4 Merge branch 'mscc-PTP-support'
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=115c5c4c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=165c5c4c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=eb349eeee854e389c36d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111849e2600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1442c25a600000

Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
Fixes: bc389fd101e5 ("Merge  
branch 'macsec-fix-some-bugs-in-the-receive-path'")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
