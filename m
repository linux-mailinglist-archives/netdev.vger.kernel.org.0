Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9ED29D6B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391473AbfEXRpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:45:01 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54873 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731977AbfEXRpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:45:01 -0400
Received: by mail-io1-f71.google.com with SMTP id t7so8006466iof.21
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=c2mQ7jAjg1TkTNQW+Q7cBX89VBXvYUUqtTETBXNcAmo=;
        b=pVJsPtbMd43pN6D1mpyUjK1mDXRVvchtTPD2qq7aaaiKG03kUyn3aJa9do/k8jq7An
         X+OCp51XjfevFZsC23Rgvh3cDgR6xarFgZ6mFRZ+xfvujXNqWP47L3Lafn5CiEzI3/X7
         YFoPDuDd+IEiQB8eyq5/LSbGlkbcb5MuhFL4qENK6ZdCzSlCiwA9v5q/G1BoeTe4e2yz
         qjssD3+gV8ZML093itt6HfCpQMZuImunt5i39uF8YTSqPAdJTFTMQKW+iN7Mu8UjR2Lp
         B9os9jHCj/T8KkMuxdDiRy0qolkQnwl/6LUZ38KG3eMMpNmDdgrNJWhVE2wY7q5W1+gG
         yZXQ==
X-Gm-Message-State: APjAAAVab+nqLgOUYX6CF+L6uhrewQgvB5NyRp1ZFac2w+DjqBGtAZDf
        9sb8GE19yyCdEEyt8kDbi0syjUcXXzArabksWL1ZvrXAj9GF
X-Google-Smtp-Source: APXvYqwTesnYfoO4m7EBs45C7CQ2/IhrVDP8iqnoEDeVN0X6LAEhL6WyQvLKWv+zmXmPZg7B2WTv4c2OMokRUbMI/0k8Ou03o2Fm
MIME-Version: 1.0
X-Received: by 2002:a5e:c241:: with SMTP id w1mr4606151iop.237.1558719900226;
 Fri, 24 May 2019 10:45:00 -0700 (PDT)
Date:   Fri, 24 May 2019 10:45:00 -0700
In-Reply-To: <000000000000a99a470589247007@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f520bb0589a5c19b@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in rhashtable_walk_enter
From:   syzbot <syzbot+21ad49ad4c11cbfba8d7@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dbe682a00000
start commit:   510e2ced ipv6: fix src addr routing with the exception table
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12dbe682a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14dbe682a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=21ad49ad4c11cbfba8d7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1648fdb2a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16437cf8a00000

Reported-by: syzbot+21ad49ad4c11cbfba8d7@syzkaller.appspotmail.com
Fixes: 7e27e8d6130c ("tipc: switch order of device registration to fix a  
crash")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
