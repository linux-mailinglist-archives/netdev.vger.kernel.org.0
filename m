Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69247220470
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 07:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgGOFnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 01:43:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49340 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgGOFnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 01:43:05 -0400
Received: by mail-io1-f70.google.com with SMTP id l7so718916ioq.16
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 22:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/z2x/BsnXueVROTB2+EfJc+boAw0TokYStszpq182V8=;
        b=eIUSj3ptyowg8BCYbIqiHrNoM5JkhnhNRrmxjTvXzO0ELr6n1CwcvSpyxbnqIpz7MD
         PuRCbJxxT7KBmNr3j53RGZ1pJs3qB3Lrl+EMK2qCGQ4K2YIKF4BLGLFLddD1CLiLJk6d
         SQ1p9JFIBU54JeJVQLZpBhjHmWEZZoPpHQZN424NkB1tjtuRSgBsA/0bQXiRyheqSGRT
         b8bwpZpdKlnxUCP4kmAEejHw7WkXGoG7Dj2SMfI//5JEbPKrhHXhta8RNXVRr4lHt1HX
         8eMZ4QAXURm0rSPRhQdk+j5y0lcUZ6j4KYDLgbsQ1r1QO313tIWZZkkHBj3f/fZPmdCP
         Rkpw==
X-Gm-Message-State: AOAM530BZVXsBLxY0ujfVAibRCQpUf1f11/V0ABkZg296F2CE+qnGppB
        uJDWC80c/Kmd1pgJn6CmCw4Q5cxaRYq+2NbfEMDJMobsPnha
X-Google-Smtp-Source: ABdhPJwjK+YsDz9DCMtkcUKewccMP7gwa0bvnKpr7nngnJQGwjL5uJUGDmQoZeU6zE2L47JMOzdR8e3Cmdi/wnee0F6CBDeoyLKa
MIME-Version: 1.0
X-Received: by 2002:a6b:691d:: with SMTP id e29mr8454664ioc.159.1594791784843;
 Tue, 14 Jul 2020 22:43:04 -0700 (PDT)
Date:   Tue, 14 Jul 2020 22:43:04 -0700
In-Reply-To: <000000000000080a5f05aa4691a8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d38e6805aa746577@google.com>
Subject: Re: BUG: soft lockup in smp_call_function
From:   syzbot <syzbot+cce3691658bef1b12ac9@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, dvyukov@google.com,
        hpa@zytor.com, jhs@mojatatu.com, jiri@resnulli.us,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, luto@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vinicius.gomes@intel.com, wad@chromium.org,
        x86@kernel.org, xiyou.wangcong@gmail.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1196d06f100000
start commit:   4437dd6e Merge tag 'io_uring-5.8-2020-07-12' of git://git...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1396d06f100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1596d06f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=cce3691658bef1b12ac9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a160bf100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d2bd77100000

Reported-by: syzbot+cce3691658bef1b12ac9@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
