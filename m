Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE99241AC8
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 14:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgHKMHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 08:07:51 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35822 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgHKMHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 08:07:06 -0400
Received: by mail-il1-f198.google.com with SMTP id g6so10368219iln.2
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 05:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HzQLLDC1IVxhcp7/2UGjOxAx/is2c+2Svqmxvr49UPw=;
        b=JyNSpQfliiJec2RpWl5oR3+l7Xb8nA6BkOmk56XU7otsKSBhlexR38/KjDlsZ2Kl/+
         dfIeAtrfNR6v+wgBxOWYC+i9p+bS36dkOPxqPR4zogHKyq/Lt2G0AdSj6F2maXpz+gcU
         SJtV+GvJfENxnnIfm/yvy9t7j5WNx2Lolf3YTWnJDEM4qSRkwn0JlGwVjCKqaPcBcHSA
         iaThlDBjxuEVkE634NBmT/LiLFAge77/v1lAwdCgk1XpuD99ef3A4VekJ5e+ESLsU8O8
         goBooNlePkQL7sRo234xItB47UnbMTqMN8tjzTECEkGYPHf4znEI/MbI8dPXVIWYTBfH
         XyKg==
X-Gm-Message-State: AOAM530DuRV6b9GMT+d5cSklEdkr6kDaxuCy6/nUvjCzuFuYDLE6JUVK
        4Go8cYAM7aCB3Tslr2tKUnDXbChX0gPFvTYbE9tQU1yxMEsN
X-Google-Smtp-Source: ABdhPJxzQS39hv4MK29/Jx/x0y/5Yh1oJ5MVyHs9Ac+UcQli1on3FM41GDUlr03BCZqL5G33nbAGhCmN34y5wng1V3Lzp7VBKGAJ
MIME-Version: 1.0
X-Received: by 2002:a92:b6cb:: with SMTP id m72mr14759930ill.276.1597147624930;
 Tue, 11 Aug 2020 05:07:04 -0700 (PDT)
Date:   Tue, 11 Aug 2020 05:07:04 -0700
In-Reply-To: <000000000000cf1be105a8ffc44c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d683c505ac98e87e@google.com>
Subject: Re: possible deadlock in dev_mc_unsync
From:   syzbot <syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit be74294ffa24f5fbc0d6643842e3e095447e17a2
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri Jun 26 18:24:22 2020 +0000

    net: get rid of lockdep_set_class_and_subclass()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=110b0fc2900000
start commit:   4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=08e3d39f3eb8643216be
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d2b1c5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17aed775100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: get rid of lockdep_set_class_and_subclass()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
