Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DFE351B50
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhDASHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:07:30 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:39218 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhDASBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:01:08 -0400
Received: by mail-il1-f198.google.com with SMTP id n2so444099ilt.6
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 11:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=t1PSBwAKPIxSsjyHhjvOvydGcJv2nwxNeNnnB0pN5z4=;
        b=FSC50wsNw8uxT+AtfmYPTqp8Hn4EWC13iFplDbYKDZ/ZEH34PX2mpj/ipuCBbHsg8x
         GQOHfIkutiS5nPGnFIKo63bwS7P0X4ohjv2V5lPbLHDQqUN+S/A4lIoidTM57XCp96Tc
         OCc41X8vmo+2uM9OVd49jAgjESTi23u0gdUrgeWBQ3KlVGaXALMuUGlX2LyymOKZEANi
         PARhhy7+v8KmDwEO1Thrn0TCSjN4fV1c2iJQ+EcfS+mkMSnl1K2O4gqcUWQMLQxs5Pug
         /nF6jS9vINvjvuVSwQyouXwdtibMnfX/Qc+71ebYJuoGfF/qmE8JA8GocfC5UiDbqGgN
         f88Q==
X-Gm-Message-State: AOAM5327rMVjjMXn7AyThl3M/kCkj6IAoKrLXds889RNtjlFxJ7ikEN6
        atk7zxZx1K9vvJjDtRZFNlReMTRpzgC0S8PBai7ulq/NdHMw
X-Google-Smtp-Source: ABdhPJyvO0s22tKhZ9WnikY25h0lMQFGQxk3fm8YQuGAfS4QejjBrmdhMtUZGFynSyNRa1nHaVnvvFGyw+hSTQlenTkj1ltd289T
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170c:: with SMTP id u12mr7856308ill.100.1617300067465;
 Thu, 01 Apr 2021 11:01:07 -0700 (PDT)
Date:   Thu, 01 Apr 2021 11:01:07 -0700
In-Reply-To: <000000000000680f2905afd0649c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000043f2c05beed04d8@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in bpf_trace_run2
From:   syzbot <syzbot+cc36fd07553c0512f5f7@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, corbet@lwn.net, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kpsingh@kernel.org, kuba@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, mingo@redhat.com, mmullins@mmlx.us,
        netdev@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit befe6d946551d65cddbd32b9cb0170b0249fd5ed
Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
Date:   Wed Nov 18 14:34:05 2020 +0000

    tracepoint: Do not fail unregistering a probe due to memory failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f0260ed00000
start commit:   12450081 libbpf: Fix native endian assumption when parsing..
git tree:       bpf
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac0d21536db480b
dashboard link: https://syzkaller.appspot.com/bug?extid=cc36fd07553c0512f5f7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1365d2c3900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d5f08d900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: tracepoint: Do not fail unregistering a probe due to memory failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
