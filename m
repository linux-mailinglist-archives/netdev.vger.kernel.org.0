Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC7D22549A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 01:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgGSXCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 19:02:05 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:57276 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgGSXCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 19:02:05 -0400
Received: by mail-io1-f72.google.com with SMTP id a10so10019862ioc.23
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 16:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yAyoquWQur/JE0vcMjr85UEh8dUhSL28OuUIPGAj7Z4=;
        b=CCEH2vxZpnBrP+zclfNpsg3Q/3tDh0upgD0WBPlmfWwjcQnq0pwOx5E0zK7Lqh3R22
         +hp/M1b4S4X3HU5DbcgDNxb75GJAMhQoXO/qxBzTL0hrMqwHfu9J7/8yhC1f85mCV1Ry
         /F+8pI1A46/JbHIfGIgQMBWaj3J/a9UeNLHbbPOp6NTSJmYj9Dg1G70nN5O/zTBu+LI9
         zqTM3mWvKxhvtrFK7MLeLzD2l154BJvDo639K7enzCZ3DdUfzEfYzZJ2M2Cbrd2Chs91
         DvCGyI5iOEyb5lkCbJaIgCAIV1DV8I73Hk/6tt5lEfj+pMEIk0dWxnXXMFo9zUJFl4DB
         R+dw==
X-Gm-Message-State: AOAM531CoPSM9z1D8u+wqUiHYwsr2+K3T3mJJHSiCF7lO4klj5ko9DGP
        MaLaY/fj27xXtfRvWwtGvRzpJYC3VXuxr7njJF4xD9xieSQB
X-Google-Smtp-Source: ABdhPJwWt4B8WbtLMsmBYQmM2VfWyfOntvoTC+LmzCsi1coiOMj3P2eZTNHm+1EGBF8VkbJpY83MG5RtAxjdYt/IIRKpIihJWwHt
MIME-Version: 1.0
X-Received: by 2002:a92:d181:: with SMTP id z1mr20509309ilz.41.1595199724489;
 Sun, 19 Jul 2020 16:02:04 -0700 (PDT)
Date:   Sun, 19 Jul 2020 16:02:04 -0700
In-Reply-To: <0000000000001e16e605a9d01ab3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ec958305aad360e3@google.com>
Subject: Re: BUG: soft lockup in __do_sys_clock_adjtime
From:   syzbot <syzbot+b63f85efcdedbba8b3be@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, luto@kernel.org, mingo@elte.hu,
        mingo@redhat.com, netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vinicius.gomes@intel.com, x86@kernel.org, xiyou.wangcong@gmail.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13cb847f100000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=102b847f100000
console output: https://syzkaller.appspot.com/x/log.txt?x=17cb847f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=b63f85efcdedbba8b3be
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f6948f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138eb7a7100000

Reported-by: syzbot+b63f85efcdedbba8b3be@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
