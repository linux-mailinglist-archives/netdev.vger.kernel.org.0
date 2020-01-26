Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B619149981
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 08:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAZH0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 02:26:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:34897 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgAZH0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 02:26:02 -0500
Received: by mail-il1-f198.google.com with SMTP id h18so5172863ilc.2
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 23:26:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=d0EAYYoFJs/j+ol20aGJxzlCRa5xPQMsZhQpp42dXF8=;
        b=SHZxGk54z0Jmgb7HhnS1DJJttExcablCIKXub6aSuTGNcQSaAie+ksAn2JWVhkjGxE
         KvibyMkXZUiRQvzA4EZUXwBtlekgfkWsOkegxzS/MDU0Hi0P5FWAS9KpquiUC/aD65ol
         6HqJJqFFf6lWKbR6TxjIlD7404lrk6SNyhlGAwq2iRZTc0VF3bNeUezXVRkvFB1/oQxE
         4lPZRe2GQwO2OkslYNN4B69iN/q2PK6tQrNzJX+dN6N6XdJT8R42mjbjGWvrq9cT0rjV
         AdjrxDr785G6bg1rKc5X8i5WyvYuqBpbYih1Oos42jDpfT5MIgAH+3u+y5fd1zjtarbc
         oVeg==
X-Gm-Message-State: APjAAAVh0FO7dZtZGRLbw6PcTWOKqHo41SaZRQHHTzp/FaxIlUFs4qIf
        9ZIxgAhWtKy7BmFGvtE8HIgazu2DtyRJGOtK0eXWDgAL58M+
X-Google-Smtp-Source: APXvYqzP4/VEkdgFaSon67FgAjDduMDSjqndowqxJ0Wgxs/rNFlUGTPeaIFZks4U9WerRYsiCmp64bVGDtHXk327djrJdL8dA5Tn
MIME-Version: 1.0
X-Received: by 2002:a92:85d2:: with SMTP id f201mr9111770ilh.45.1580023561398;
 Sat, 25 Jan 2020 23:26:01 -0800 (PST)
Date:   Sat, 25 Jan 2020 23:26:01 -0800
In-Reply-To: <000000000000466b64059bcb3843@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d2faa059d05e738@google.com>
Subject: Re: INFO: task hung in hashlimit_mt_check_common
From:   syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7ddd8faf4399ab4f4edad5604eab35f8a87caf02
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Fri Oct 13 22:57:54 2017 +0000

    userfaultfd: selftest: exercise -EEXIST only in background transfer

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175625c9e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14d625c9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10d625c9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=adf6c6c2be1c3a718121
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ea2559e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ffc8bee00000

Reported-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Fixes: 7ddd8faf4399 ("userfaultfd: selftest: exercise -EEXIST only in background transfer")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
