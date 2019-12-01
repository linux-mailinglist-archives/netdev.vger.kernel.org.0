Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C6B10E1DB
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 13:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLAMVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 07:21:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:38989 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfLAMVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 07:21:01 -0500
Received: by mail-il1-f199.google.com with SMTP id t4so29280329iln.6
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 04:21:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GVY0UTUiXioZDjlRk/qecxkTZeBZDfVOMX99Ih6OaLc=;
        b=LKQO7xCZY2VKasalAek6TFBFiqVJjCvee03W1XMsoSIzQx28gc3/RAkPI0D5etxx+H
         0CQP6YXlrmy5n20fgiUKxXupp0gxQXLFHDhgfmsoIOCvVXFrZhhAiLpIo50sGg/kLS1Z
         IVh+gThjuZA2dFaRaD+qHyhsNItoA93/qk4VPVHPNyeOfo0zYDPA8OiN2MAZJYjqCqIB
         TjG4vdX0wxk7pBHwXA19NdbP1nv0XHUJMd2JdyhcApCvDmxxFR4x7gXHzKKyb7S0O2Ve
         zdf1FNFbk8MNPUAtUI3y0TB0c21+TcfW5GGV+ab7Zp/b18D86ifwaTLI8TC9nmykU718
         bjMA==
X-Gm-Message-State: APjAAAWs80X3UpIm3csH2n2fxsPkT3HwgTPvJDbyAOCoNLgufOI64e1M
        ZAvzQhIiZdwXe/rBhcquw32B3QmoQ+IlPLuGTn3hwvOZATsx
X-Google-Smtp-Source: APXvYqwLjsnwo03Ul2BYgUkun/p3JrCB6SxssAjMKsUkndmkq3uSYWsLeXnN03u+Z3ZugKktO5DrMm7z1HBb+XaIz9d6MA9i8PdJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:6c1:: with SMTP id p1mr19554105ils.217.1575202861317;
 Sun, 01 Dec 2019 04:21:01 -0800 (PST)
Date:   Sun, 01 Dec 2019 04:21:01 -0800
In-Reply-To: <0000000000007cace40598282858@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff87e40598a37ead@google.com>
Subject: Re: WARNING: refcount bug in smc_release (2)
From:   syzbot <syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 50717a37db032ce783f50685a73bb2ac68471a5a
Author: Ursula Braun <ubraun@linux.ibm.com>
Date:   Fri Apr 12 10:57:23 2019 +0000

     net/smc: nonblocking connect rework

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a234a2e00000
start commit:   32ef9553 Merge tag 'fsnotify_for_v5.5-rc1' of git://git.ke..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a234a2e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14a234a2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff560c3de405258c
dashboard link: https://syzkaller.appspot.com/bug?extid=96d3f9ff6a86d37e44c8
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b57336e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149e357ae00000

Reported-by: syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com
Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
