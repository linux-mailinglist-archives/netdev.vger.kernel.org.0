Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047186C83B
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 06:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfGREFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 00:05:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39969 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfGREFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 00:05:01 -0400
Received: by mail-io1-f69.google.com with SMTP id v11so29460961iop.7
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 21:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rO6mN9k+vHdaOKXwiYK6lb8yy3omdcgM9VwY0e87b1I=;
        b=GjZSYTnVJXFxKJ+rUluUAecafnK7be4qdYLOQD/aDB8zbIj5zJk90FcBmCE54mnMGT
         Ea+JOIhxASB0MV79FCkErVlcBtBRF+KeBMvM996N3qavKHuZ3KUna3XAfIGx5/S99SOD
         W8Py+Q+KAaKygGlKODKij/9/N9edjvKnFjta9IuqXLCWkUtS3nB0vS6oT66QVERg3sOu
         8FhG77DN279P64WRjFsoZzAeaw8HmU+e4zqHZLn8pnRcMj8v4tbw4690P3yKJKnqQSki
         FbeJvvx+1Ti+j4EQxuvvTR2Onag4vzBxI3v1U7L8rk9eOhf7zVAHa9AYXPr+eDHzS5Oj
         S18w==
X-Gm-Message-State: APjAAAWiepLA3U7QFEG/0cIZP9UmRarSgPdorYSKPHVnzVTJcXu4oBg9
        5kYBiPEaxdnXqN5pKpj8bjQT2KaB3/0aH3I8dUg7GQfgC18G
X-Google-Smtp-Source: APXvYqyoTku210g3yO2ZxIoWRjLSWWYoJ7AIdVEja+ew4AgEiBHjNVm32t+GYNCHZjF/KU+MOvu5h3cIJpyzx3miUXglcYu1pfp9
MIME-Version: 1.0
X-Received: by 2002:a02:7a5c:: with SMTP id z28mr45781722jad.40.1563422701068;
 Wed, 17 Jul 2019 21:05:01 -0700 (PDT)
Date:   Wed, 17 Jul 2019 21:05:01 -0700
In-Reply-To: <0000000000007e8b70058acbd60f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb2b51058decb6a2@google.com>
Subject: Re: KASAN: use-after-free Read in nr_release
From:   syzbot <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a3bcd0600000
start commit:   192f0f8e Merge tag 'powerpc-5.3-1' of git://git.kernel.org..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a3bcd0600000
console output: https://syzkaller.appspot.com/x/log.txt?x=14a3bcd0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
dashboard link: https://syzkaller.appspot.com/bug?extid=6eaef7158b19e3fec3a0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15882cd0600000

Reported-by: syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
