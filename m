Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E6C140319
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgAQEpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:45:02 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:33721 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbgAQEpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:45:02 -0500
Received: by mail-io1-f72.google.com with SMTP id i8so14314965ioi.0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1cUAzzk2sNct6oR4gK6sFNSkqIAeXDAPVDj7dr4pJaI=;
        b=t0CsvXR5JglTPKda11VyE8t8pTdWr/g1TAlACv2fPURGVqdIbLAMzbRr3NquGWVo//
         mHG4QX+ZHKBm8pBZCk+FsxpLJvUQbuG2SyLzVWS/YKPcGZuo4ApFq8F6kJKFElJ7BQZD
         iN9mIp02ykG3HqvrXWfl2YXeEwL3XZiHvh/YLppXHveJfpCkPD4PUG/drD8Aw7SaO5VB
         xMnfMDOOHyPzGgeG9pu6qXfuK24LYHpb3wLbLjjVRV4eMAdubhex9k9lMaBEmCm0EhTb
         ft/SEdOFV68sEJfuCH9MmDFdd6JRzgKYSgcyGoFL3W2dLClf5i5ZR60YV8bGEc8OH9rw
         qCLQ==
X-Gm-Message-State: APjAAAUtCBboEryVdJRNcTTflG6JB4D4vePdszgRUFSfbBEe7FLEYZB1
        41AU9bmekTKAMGqjR8W7+k47GMRCLDrbwV1b7w0BhrnmOaJ3
X-Google-Smtp-Source: APXvYqyjD+Biivg/aa5/AT9J3HOCrQyY1dnQuDliyrdfNZIwqOAQb+x2KCj1JtDJEr9CqmN0upuDE/qMamViB/tBFaUwrT2rQYUY
MIME-Version: 1.0
X-Received: by 2002:a5d:9694:: with SMTP id m20mr30787857ion.48.1579236301410;
 Thu, 16 Jan 2020 20:45:01 -0800 (PST)
Date:   Thu, 16 Jan 2020 20:45:01 -0800
In-Reply-To: <000000000000b3599c059c36db0d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c31c6d059c4e9a6c@google.com>
Subject: Re: BUG: corrupted list in nf_tables_commit
From:   syzbot <syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7c23b629a8085b11daccd68c62b5116ff498f84a
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sun Jan 7 00:04:22 2018 +0000

     netfilter: flow table support for the mixed IPv4/IPv6 family

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=146472d1e00000
start commit:   51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=166472d1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=126472d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=37a6804945a3a13b1572
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17241c76e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13118315e00000

Reported-by: syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com
Fixes: 7c23b629a808 ("netfilter: flow table support for the mixed IPv4/IPv6  
family")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
