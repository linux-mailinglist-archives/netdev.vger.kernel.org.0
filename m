Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A7B3EF5B0
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHQWVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:21:44 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34594 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbhHQWVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 18:21:43 -0400
Received: by mail-io1-f71.google.com with SMTP id o8-20020a0566021248b029058d0f91164eso54092iou.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=umDmu+4hB/JDNHdbTJk5sLucv5/bOLVHY7bndijJFTA=;
        b=W7goGzCiCKZQpHjuX0RP0KvTTrdqV/Eh3kl2VYrPnjmczYFrpy2Fpy5rathgdCfmww
         NrOReKxQydTUGmes9HZZb2bbBPWlGjK311e94X1Rq+uMUtxHJkYWUKiqZkabnuG3ur3n
         QxcVc4S6GKOBwx+nacFCnfcDw4luqYLWmd7Cr6yzDybg/Z2wP2SX+MXOXXBLceyCYqLr
         a97KWns5IefiDhUU394AxbqPR7Tu2fY8BFrwo0gtdprI9FzUm1Nz5WoGBGjSOh0UcuUw
         4UaEX4XcQQ5epFTOGrae7uSWSjINEfRtqNrfUnSdfYAwXafyspk7xfaLTvIHBMRWDB8L
         ulhA==
X-Gm-Message-State: AOAM533N01hB4/fpbYUA7ZClEYzyJY/P4IzNZ2M24eiyM7m5s0X0/dY7
        Kz+yc3u2g9Yg3sdD5Btt+t7vYQHUKgZbo08MItq7c5RW/GjH
X-Google-Smtp-Source: ABdhPJzaDcwt4eaiB4ndqrwZbsMFOJdKO3Yu0KMKfK1Kr5midZbCbjKzgjJY5yO6zqRjKZKrk/3nxoTRvoMMG4XwWaB7JHSI/tXL
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:547:: with SMTP id i7mr3835170ils.102.1629238869490;
 Tue, 17 Aug 2021 15:21:09 -0700 (PDT)
Date:   Tue, 17 Aug 2021 15:21:09 -0700
In-Reply-To: <00000000000080486305c9a8f818@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012030e05c9c8bc85@google.com>
Subject: Re: [syzbot] KFENCE: use-after-free in kvm_fastop_exception
From:   syzbot <syzbot+7b938780d5deeaaf938f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit c4512c63b1193c73b3f09c598a6d0a7f88da1dd8
Author: Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri Jun 25 21:25:22 2021 +0000

    mptcp: fix 'masking a bool' warning

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122b0655300000
start commit:   b9011c7e671d Add linux-next specific files for 20210816
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=112b0655300000
console output: https://syzkaller.appspot.com/x/log.txt?x=162b0655300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
dashboard link: https://syzkaller.appspot.com/bug?extid=7b938780d5deeaaf938f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157a41ee300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f78ff9300000

Reported-by: syzbot+7b938780d5deeaaf938f@syzkaller.appspotmail.com
Fixes: c4512c63b119 ("mptcp: fix 'masking a bool' warning")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
