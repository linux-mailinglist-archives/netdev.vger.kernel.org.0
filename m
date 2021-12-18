Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF1479C7A
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 21:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhLRT7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 14:59:20 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:36637 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhLRT7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 14:59:18 -0500
Received: by mail-io1-f71.google.com with SMTP id w16-20020a5d8a10000000b005e241c13c7bso4042105iod.3
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 11:59:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BYwp39HfkoKA0spS5iKDdSyw2i3LvTwEYaoIQ1fJH/I=;
        b=HbKoQtznr/v/ySiAl4kT+OSTMJoAqsK/beXYrHVIr2+Tp0gGs+pR5oLI0bCFjMe7nR
         qp4XUub2fPh59h0kFQg+oBFUEDouoz3M3QNbt9NlZTcNTxgz6+G5ZioEINmH4eFIj6I3
         iI1cowgscIgYQOwTp2POpUCXav7eJ8ckup0+KjzS0q3wgqTXdFVRIpgEz3bMZbL6yyQy
         tqE4ZGeJe+QMXwsS5Oj93LQxQDEEs/sf3kcJq4CbC6k7dJWEC/imzOQS44z2YbTAyl/Q
         N6Jm37m2nbPaWqt2EcBhbZbYPlZfF9Jqk9ftjQvxzsxP6qwghC2vkemmo7E2nOF91pRy
         4qng==
X-Gm-Message-State: AOAM530w9WX+XfOGxwWgzaHaaaMBZh34GSHwL21gMxlVIkgaH5cFu9oI
        ebgwcpykRMfMaWRrIYaYrJA5lSumddfbEvxXuGZi/aUi69YI
X-Google-Smtp-Source: ABdhPJwtphcEpn94Y+GKY1ddbM7fL8AeKAWU5U3uy2A6xfXQnyUUGDnIRf4rsD452Bl9zZ3dM0mMHaUf7yhLWL7TBRJjz46LGT0b
MIME-Version: 1.0
X-Received: by 2002:a05:6638:140d:: with SMTP id k13mr5342747jad.37.1639857558522;
 Sat, 18 Dec 2021 11:59:18 -0800 (PST)
Date:   Sat, 18 Dec 2021 11:59:18 -0800
In-Reply-To: <00000000000021bb9b05d14bf0c7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000420dda05d37117f9@google.com>
Subject: Re: [syzbot] WARNING in page_counter_cancel (3)
From:   syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
Author: Leon Romanovsky <leonro@nvidia.com>
Date:   Thu Oct 21 14:16:14 2021 +0000

    devlink: Remove not-executed trap policer notifications

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16464095b00000
start commit:   158b515f703e tun: avoid double free in tun_free_netdev
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15464095b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11464095b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa556098924b78f0
dashboard link: https://syzkaller.appspot.com/bug?extid=bc9e2d2dbcb347dd215a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ff127eb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bedb6db00000

Reported-by: syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com
Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
