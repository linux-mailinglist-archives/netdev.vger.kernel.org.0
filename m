Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248C8225305
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 19:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgGSRQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 13:16:10 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38675 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSRQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 13:16:08 -0400
Received: by mail-io1-f72.google.com with SMTP id l13so9766871ioj.5
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 10:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=uWsaInl6El+/D5enNDY+jTmOBPyNvNc8dNA1QiA0S0c=;
        b=PuMYN+xYZM5KUEbT7lac+I6VzBnw4UMnD3JBpvdD89SYRV5gmBP/zjzvj3X4xuVan/
         DS/8tgrbqjEIGIOAmh4LZCoU2BfGtI4mUSd1+xQ0eTiuzFqy5RmcV5rk3KB8q8PVrY0r
         z3Ah8U2O5FKePwmj+NUPLCsBs5dJkon2jKJSSd3KsW6eq/plwHgM1thtd67OF+tRnAgc
         VlIA1MwSNiygOqqJDaWx7tW2j753fRk6dRjjvEaLgMM3TBjbPxBRkS46B1YAgjjhGnqH
         V830KpJbF21QSm9qEL2hcLGBwhDMbiVYaz+W5wjulypGJEjmhGm1hlENeKxfmaUXby7N
         IUvg==
X-Gm-Message-State: AOAM530G9dAztnT5+vHzDYvR4EJ/oNNHPf2rm5fD2xQAfit9xTAcLDP7
        ZUwcmgcFMxY4cvsWQerPh2dsIG4kV1A1yvvZkz4nf8s3gO77
X-Google-Smtp-Source: ABdhPJyqtWSRK+J0kwgjyR9dCgOB/4uCy+2pVK5gDCT/d7MyHs2xxFLVTglqQ0deuai/N8yljwZPA1Qoe/b/OkExASNGKUx+4h19
MIME-Version: 1.0
X-Received: by 2002:a92:58d6:: with SMTP id z83mr19077343ilf.186.1595178967166;
 Sun, 19 Jul 2020 10:16:07 -0700 (PDT)
Date:   Sun, 19 Jul 2020 10:16:07 -0700
In-Reply-To: <000000000000418fc105aa4243aa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b0fb8b05aace8b8e@google.com>
Subject: Re: INFO: rcu detected stall in sys_clock_settime
From:   syzbot <syzbot+f3bd350a4124f10acdae@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org, mingo@elte.hu,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=167142f0900000
start commit:   e9919e11 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=157142f0900000
console output: https://syzkaller.appspot.com/x/log.txt?x=117142f0900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a160d1053fc89af5
dashboard link: https://syzkaller.appspot.com/bug?extid=f3bd350a4124f10acdae
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1353c420900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130f8ef7100000

Reported-by: syzbot+f3bd350a4124f10acdae@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
