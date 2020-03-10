Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9CB180BD8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCJWsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:48:03 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:54341 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJWsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:48:02 -0400
Received: by mail-il1-f198.google.com with SMTP id l10so18805ilo.21
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=q5ZfIbP9gSY9pdPHS/kIAKtPmXSbcAcSEV6rs0Snm+0=;
        b=E4gtdzcih5kN2ZBmb24WynQQt2ARmGsuOu4qXue6pEEMmajdrm9okZrLTT2iMf8Hz0
         bEboQhhUAVf7iLN2rfahvd0I6FUU662xfmap9Z2gU+F87cwfMfVZrMAvdNt2Mw0kiRgN
         WKAgd2CiPcKhPMmuHaLcMpGdhmelQ3YgDhl7Lx4c9Ce0Yi7fwmSYOiWjaE2b9KNchpho
         neDatko7IapJwv6/jCBlTd9dl2+srCCwNNWBP0X+HCTefIeGLRAha4/uk9KQucbHQ6a3
         R1OxFY8n+9fkw8+fZjlfXOmyMDscj/clVv/2T1HgS25BZaB1KpnL1u35caZxPjObPda3
         Rogg==
X-Gm-Message-State: ANhLgQ35uAN2OtLN5gm8O7DrBjyka5SylSXxZaxv6IoKB2vj3j1fuceH
        fhs9Md0gXW3N93mUrQl+5o3syv4Wv4+jgBBIYQeWqm8BBuMu
X-Google-Smtp-Source: ADFU+vsUpjaOtAr4hhw0rq5N3kQz/0hNMAgmfm1xXX732YmORbP3PrSO7VAQ4OKpFhJHkvH5+C6ASJ2eFbWOuCz4cHIHD8swbAza
MIME-Version: 1.0
X-Received: by 2002:a6b:7c04:: with SMTP id m4mr298568iok.208.1583880482351;
 Tue, 10 Mar 2020 15:48:02 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:48:02 -0700
In-Reply-To: <0000000000006601b005a08774fd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000846f6905a087e9b8@google.com>
Subject: Re: general protection fault in tcf_action_destroy (2)
From:   syzbot <syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170df5c3e00000
start commit:   30bb5572 Merge tag 'ktest-v5.6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=148df5c3e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=108df5c3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=92a80fff3b3af6c4464e
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13faf439e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16956ddde00000

Reported-by: syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
