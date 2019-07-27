Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBDB77819
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfG0KQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:16:01 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:52863 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbfG0KQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:16:01 -0400
Received: by mail-io1-f72.google.com with SMTP id p12so61580590iog.19
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=x2XPPyWw+kTQEvjXcX/vC5JNb6a5vMqFuiwlUWd2Kag=;
        b=O1NbNXJhTW+qAWvyU6d+JJcm4mkTvIdRAW4tbezijNV2bk7ZXPnYPTp6XNr/WkFqMN
         ci+TSAFyry4PYS1NcfoncQwZTdDyQpCtseN1LKxtZnhgjaWtM+bYIe3epPEfXXzIG7RN
         xZI6fIoKZkq+NrqcjAW7dlckqcPMOo6+riNJ0MkEHsGQtTLOW0PqI7kwk3U4vV4l+Z2u
         Ptj50fAhZtbwxDNKLooUxy5z8m/zTO1WCMhyW4U6mwiwEgYJA7c8No98uCJ2aBTADaJP
         9gA8jHbMzuSCuQFMeYsSg9x4FwPx3/Tn/tyBtN9+xq8feMzUak4YuJEc/Q8xAtpMy4wJ
         VLTQ==
X-Gm-Message-State: APjAAAURMAmKGGUDI9t+j3kCjNbH9pNN1wXx/797IylmGPAQBR0qgVsH
        8XUsfQBJScALJXbcG4NZMA5sx895ppRdvqMit0M/6gbJfvlm
X-Google-Smtp-Source: APXvYqyUUXRwrDhv+Q8VwK3XJ+lyMBkXhuGvc/B+mH+HMjh06Rq3S9TIzl2shA7qpymnG5hvTqwSBsZorpk8Y0tjAKx1u9bCuJWS
MIME-Version: 1.0
X-Received: by 2002:a5d:994b:: with SMTP id v11mr46002856ios.165.1564222560256;
 Sat, 27 Jul 2019 03:16:00 -0700 (PDT)
Date:   Sat, 27 Jul 2019 03:16:00 -0700
In-Reply-To: <000000000000111cbe058dc7754d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000dc874058ea6f261@google.com>
Subject: Re: memory leak in new_inode_pseudo (2)
From:   syzbot <syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com>
To:     axboe@fb.com, axboe@kernel.dk, catalin.marinas@arm.com,
        davem@davemloft.net, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        michaelcallahan@fb.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit a21f2a3ec62abe2e06500d6550659a0ff5624fbb
Author: Michael Callahan <michaelcallahan@fb.com>
Date:   Tue May 3 15:12:49 2016 +0000

     block: Minor blk_account_io_start usage cleanup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13565e92600000
start commit:   be8454af Merge tag 'drm-next-2019-07-16' of git://anongit...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10d65e92600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17565e92600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d23a1a7bf85c5250
dashboard link: https://syzkaller.appspot.com/bug?extid=e682cca30bc101a4d9d9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155c5800600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1738f800600000

Reported-by: syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com
Fixes: a21f2a3ec62a ("block: Minor blk_account_io_start usage cleanup")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
