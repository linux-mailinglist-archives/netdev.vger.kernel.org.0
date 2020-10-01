Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3680D280725
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgJASqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:46:06 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:42312 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbgJASqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 14:46:06 -0400
Received: by mail-il1-f208.google.com with SMTP id 18so5306484ilt.9
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 11:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QPaq3GozfGEmcVEfcZ9p2WifWSbg3p4JEASOWyQUygM=;
        b=lnVH84mPpSo8hAq4me6EFEIZ+OZt7c9UqPkRZAmIQbSYoDJfHcJJ6HGPCLI74mZjDc
         eHU1lC2cJ4Nh6JjkIjdwNlbpVJn1i35I0u0FrOofZnX9+F6PnmT80TPbquTd0T6SjpO+
         k4PN9e17f+wpbY4o5ogigZNLefqYXtF7BQU5bouOMWPPtdd9eVY0QMAfU53HtTIluEzW
         qPRleBdzDAppEm7POc9+RguN3aOwXZERD/NdpvtAVf9WNQmoSqIoVnzmfc/ZIRBfBuH6
         2igYv2poufIrJsvlX62170MLHRbIAfx/dkRW0xgypnZbK+Ymnp5kwW5/X4evRFBZ4JU/
         52mw==
X-Gm-Message-State: AOAM532LnTVyGjiGdhBiNzQGQ4NE/EkN6nEjZhMVTBb3B4Jr0qoHXIrw
        GTUxI+bUJxVNS9LRScD+1ZVqXMC9I/k84i/F+vuvTyDiBOMz
X-Google-Smtp-Source: ABdhPJxZy8JSQ93jW1Afj+8O1MF5YFh8NRykTOGDo1ivTsoY0Wr90IQy946nezTTOaKxADBqzM6N18M0Cfj/CgmkiynfD3dUBzzM
MIME-Version: 1.0
X-Received: by 2002:a6b:7005:: with SMTP id l5mr6586653ioc.10.1601577964783;
 Thu, 01 Oct 2020 11:46:04 -0700 (PDT)
Date:   Thu, 01 Oct 2020 11:46:04 -0700
In-Reply-To: <0000000000008fddd805adc8c56f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000abcd5505b0a06d96@google.com>
Subject: Re: general protection fault in rt6_fill_node
From:   syzbot <syzbot+81af6e9b3c4b8bc874f8@syzkaller.appspotmail.com>
To:     John.Linn@xilinx.com, a@unstable.cc, anant.thazhemadam@gmail.com,
        andriin@fb.com, anirudh@xilinx.com, ast@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        hancock@sedsystems.ca, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, michal.simek@xilinx.com,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        songliubraving@fb.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit eeaac3634ee0e3f35548be35275efeca888e9b23
Author: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date:   Sat Aug 22 12:06:36 2020 +0000

    net: nexthop: don't allow empty NHA_GROUP

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12beed5b900000
start commit:   c3d8f220 Merge tag 'kbuild-fixes-v5.9' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=81af6e9b3c4b8bc874f8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ff8539900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143f3a96900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: nexthop: don't allow empty NHA_GROUP

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
