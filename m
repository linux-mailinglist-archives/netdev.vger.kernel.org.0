Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232521459C0
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgAVQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:24:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41450 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgAVQYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:24:02 -0500
Received: by mail-il1-f199.google.com with SMTP id k9so110042ili.8
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 08:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zJCuXAAGGfmdn3xKT3mw1EQTFOCTjnZ0M4GP0MOAhHQ=;
        b=cHGY/VGQ+yNi+l91n/uSCxO6qHxfxrng2ItWZncbtjQY1PvpJFkcNrR1WuHpX9+xnE
         DYAlTYTUkZCH5XPq8JXlaWZ9P0KPtpnFScbRcLQDWAj2M/kTk3oxJNluDb359+etvPiE
         rR6it1vQqWBZ+TXGkDY76zBwu97Lh+a5m46z1Sltp6ddWgedeqPgCgrDRJ2RAFpV+8Zb
         h3OL/MQbobxKuAZ1Rtd71bK5mrbID8E8eWcvRQYCLzFcjTZY5fBEb5UnbTmAHetelsNv
         +WaZQY0weJxRPsnSBd0gq3LnfHeIa/W/aJkMWjTPYPRk9rgyUOIG/cTa3eFiieFjigI7
         8T9A==
X-Gm-Message-State: APjAAAU0ANex+7vt/ooSvmqV6U8U32rnUQhu3qtRlSNbQuB/zd931B/3
        qSxnxYRGEtbwRUgd1bP9Tkez226vtJxfqtqipi7Snd+wJ6+7
X-Google-Smtp-Source: APXvYqyJNUTQllpzChKWI3nNnvCCMcKFDK8FOmsX5mlgK8LQmSBOogF54plRyAyGRd+Lr8Pp2HjGvCwNo5+7ENt5YVZMH92fGi8/
MIME-Version: 1.0
X-Received: by 2002:a6b:8e47:: with SMTP id q68mr7385399iod.274.1579710241804;
 Wed, 22 Jan 2020 08:24:01 -0800 (PST)
Date:   Wed, 22 Jan 2020 08:24:01 -0800
In-Reply-To: <000000000000b6da7b059c8110c4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf992f059cbcf362@google.com>
Subject: Re: general protection fault in nf_flow_table_offload_setup
From:   syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit a7965d58ddab0253ddfae58bd5c7d2de46ef0f76
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 13 18:02:22 2020 +0000

    netfilter: flowtable: add nf_flow_table_offload_cmd()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17ea59c9e00000
start commit:   4f2c17e0 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=141a59c9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=101a59c9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f93900a7904130d
dashboard link: https://syzkaller.appspot.com/bug?extid=e93c1d9ae19a0236289c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166fea6ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=108d6185e00000

Reported-by: syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com
Fixes: a7965d58ddab ("netfilter: flowtable: add nf_flow_table_offload_cmd()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
