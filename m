Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF716B9B5
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfGQKFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:05:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52790 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfGQKFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 06:05:01 -0400
Received: by mail-io1-f69.google.com with SMTP id p12so26547292iog.19
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 03:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TTvRZwA8TDPGBK9TibJ6ly9VeeNnSU2IT+OU5u4KhhE=;
        b=PvR55KinjuA9p92teSAnTSDcz/ypx4FocCfZzngzCGQNT0XbUg9KCaR8+d9k9VZPGX
         S9QNwRKdyC9SyHUklNRmidimhIbJJdwofIr3zxg95nYJ5kDgMKs4S/r0Ap0Q0HniEvqP
         LkU2qVkUpVOahi7O/JuVlLoS7r6uiYhJx30TxunSHfRrtPUUtx+U8knPb0b8g0CZ/W3Y
         UWJtTW+Q+yYBtb3GGeEheUI4Z2C0JaKfQJXHvxrJ4c/6onHRoAW2Xsu3fWITKV5zqhWY
         mQQ7pUxZ5VMROxo8TH/X7ySFSgazplv5fCagXcXbkS+q51VGin/Gjucm2pZVo+R9QV0w
         f0lQ==
X-Gm-Message-State: APjAAAWNE/wh9tj4oDNbCTiDUU7yByx3rWciv3d7CPRuDLeF30NrlhBF
        Qffi1PlCBeBYNEMm74av4Cr89VTmOimQzMr2geFERYGmZVel
X-Google-Smtp-Source: APXvYqygQgdRgLCMVKgGwqYS2YzrTxrwtIneXoQQgmYGyvms+ow3F6cA2ozkKNBfmEvrb6Cbs/OgXfe3/5McPbETYvJRCUiZzHs9
MIME-Version: 1.0
X-Received: by 2002:a05:6638:281:: with SMTP id c1mr40048066jaq.43.1563357900838;
 Wed, 17 Jul 2019 03:05:00 -0700 (PDT)
Date:   Wed, 17 Jul 2019 03:05:00 -0700
In-Reply-To: <00000000000015d943058ddcb1b3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000561cd5058ddda0ce@google.com>
Subject: Re: WARNING: held lock freed in nr_release
From:   syzbot <syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14022e8fa00000
start commit:   a5b64700 fix: taprio: Change type of txtime-delay paramete..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16022e8fa00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12022e8fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
dashboard link: https://syzkaller.appspot.com/bug?extid=a34e5f3d0300163f0c87
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1460b458600000

Reported-by: syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
