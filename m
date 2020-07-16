Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39842222D21
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGPUlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:41:05 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36910 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgGPUlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:41:05 -0400
Received: by mail-io1-f72.google.com with SMTP id 63so4354540ioy.4
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MJOPP91fI02T11IImb5jr+gjqr0RxeB4C7mwZ09S0ac=;
        b=VMuxuDBmbGN0TdnmJ6m2ULXRRc+8dw/k8ZpWsVZIx5YP1Qg3i9JCP95AGTHTo+wN2L
         TY3k8Lt+a0/h6bu5MVry8WrmPzra9lmkZkHQPhFaS4YVHz4Nm1sZvz5Jc55an5DLHj6D
         MPsy7qdUyZNW2clwwH9z49igWppXSIy9TXBBY6EPFZVkQ+J57Lw3CYnPUAzcVIDuUxDO
         DhS5+t7p6minMA8LxA4qGi7gCkFJ2CH60WDzEgP8BMeQ4pjDfiai5DOZzCokoq0deh6R
         zjcJcBPQd89fX1GR52UrEuHRBEPzEMuAjtZEVPL+Gu/EvSdTiGZ8Srd5O90yWnGfqa3f
         k58A==
X-Gm-Message-State: AOAM533WVOR2E9gBbpWt2IrkWF13+YqvsKFZCi/gxBDzJR1lhVE2NlCX
        NLZgy4GM26PQRuOo22oEzTktyCyGEGjzw+mnxYhnM0t9AwV9
X-Google-Smtp-Source: ABdhPJzv2CNM+Kml3MecWCgob+RHzrgpODX2HxZNVirGkjOmGSYqaiVYO323EJ7wT8l+qtjglQjZCXtHQGB8uokL4mPFWgQs++oy
MIME-Version: 1.0
X-Received: by 2002:a02:cf12:: with SMTP id q18mr7002957jar.3.1594932064186;
 Thu, 16 Jul 2020 13:41:04 -0700 (PDT)
Date:   Thu, 16 Jul 2020 13:41:04 -0700
In-Reply-To: <000000000000983e0405a9c7b870@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002077ca05aa950f9f@google.com>
Subject: Re: INFO: rcu detected stall in __sys_sendmsg
From:   syzbot <syzbot+f517075b510306f61903@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=109a63cf100000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149a63cf100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=f517075b510306f61903
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f01c1f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c40ba7100000

Reported-by: syzbot+f517075b510306f61903@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
