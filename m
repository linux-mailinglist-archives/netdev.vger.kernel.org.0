Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F84028EF4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388449AbfEXB6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 21:58:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48170 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388307AbfEXB6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 21:58:01 -0400
Received: by mail-io1-f70.google.com with SMTP id l6so6310539ioc.15
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 18:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=955OHyvWfWzvm1GRTftGUzdKB7MA3Z4tCp1YPcfjoEE=;
        b=T+Eq6XxnDzT7gzsz6JF/vH/C0RgNm7rN1uA2S8JEA7H9xoAAAkdB4k85R06cGTnWB2
         e5no8/suynss+1wNunzF5mfZ8WpkTcyv+Bao6Hfva/Bkg1YCXbpWsqrOxIhqSFI8X103
         VNxQ/MOz9vvhQ2UMadM4hpIpzTtJ9uuUT6iTzddikUzkv4xYudS/JPzjiFUMQY0ZnE+r
         D45qTbCQAuRXQ6624j78M2Jc8dseAxHiPY01+NVnHSKszpJOf7oggdZeymfAVXw8pv1m
         V7nN0omZr4JP803LHZvAGq3Yojcb+9M2pj2ZP6gjqlZAGAFHhCG+jkDd5n5grDzuYym1
         pTDA==
X-Gm-Message-State: APjAAAW6fO2c5rm4iMRDCUY2FiPQYo1mgChmIo1gYwA5shx1xso5GXmO
        1+RPRVqMwBbUDVdk0Ln4EKtMz25bWqd8V4Fca+mtniPU1gk2
X-Google-Smtp-Source: APXvYqwaoXSCXsvV1QYH0vRAsKbXKMU3okraTaYo4SkwkMm0SrYG4erFBFg8bbcy+0lpOO4en1vA0texEuQay7Fz+tlfQjlA6QXh
MIME-Version: 1.0
X-Received: by 2002:a24:d845:: with SMTP id b66mr16266145itg.94.1558663080569;
 Thu, 23 May 2019 18:58:00 -0700 (PDT)
Date:   Thu, 23 May 2019 18:58:00 -0700
In-Reply-To: <000000000000af6c020589247060@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003df61e05899887d3@google.com>
Subject: Re: BUG: spinlock bad magic in rhashtable_walk_enter
From:   syzbot <syzbot+01dd5c4b3c34a5cf9308@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hujunwei4@huawei.com, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, wangxiaogang3@huawei.com,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7e27e8d6130c5e88fac9ddec4249f7f2337fe7f8
Author: Junwei Hu <hujunwei4@huawei.com>
Date:   Thu May 16 02:51:15 2019 +0000

     tipc: switch order of device registration to fix a crash

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c22c72a00000
start commit:   510e2ced ipv6: fix src addr routing with the exception table
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14222c72a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10222c72a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=01dd5c4b3c34a5cf9308
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b6373ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1251e73ca00000

Reported-by: syzbot+01dd5c4b3c34a5cf9308@syzkaller.appspotmail.com
Fixes: 7e27e8d6130c ("tipc: switch order of device registration to fix a  
crash")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
