Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CDE27CDB2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgI2MqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:46:15 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:52391 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387570AbgI2MqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:46:09 -0400
Received: by mail-io1-f77.google.com with SMTP id m4so2744298iov.19
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aIH5+9o/WQ3U3fksD3TLsum6UmaiEhIKEW/H6MhmdWk=;
        b=b0mq8nOqvkqeS86UNcVE8+9jmAlD1XYYh+U2+5hjEEbSTbklWO3lL9QGp4V0Wtz5lY
         dqD+FYzdhmNXpmjfBXMZj1tyga4UPpBc1vkiD8/IOpeB7U+6gfmXkyrnItXCJoeJTWZ1
         Bd5DfoR+78POuoBj2vyMZUexnuUq29hQR62ClBxQuWaYMiLVVTUBLpW0sw9zovE+b/y4
         VaYY7ci1r/JgnoJNjJZNThIvqtZgVG51guQuhHsQJYGahGeo1qsZwsMagTcbZH/u+GFc
         KjbyYyUCp9FvXq2dAFoTAJbmM/4hp/lTD0n2NRwQKEwi8CUFN04j9QAETxXbWwnMNCUQ
         3yMA==
X-Gm-Message-State: AOAM530FXG1rLl/Fh7k0IZcl7LyhunAufbf5vrF7sNssAsKE2HuQVs3l
        8Xh+fX1uVWrK51zYNATXiar2ybDwBraSLXj5m4J6D6dFyN9+
X-Google-Smtp-Source: ABdhPJwXmI8uoWFeVU57vW1YfSovrR/LKjfjYU2pu0Qiw8c9CBL2Er2mOJAkOIOmHv3XCnBwKzhAH9Zj40sRAD6sOGgoDx76gFvA
MIME-Version: 1.0
X-Received: by 2002:a92:360d:: with SMTP id d13mr2524504ila.99.1601383568081;
 Tue, 29 Sep 2020 05:46:08 -0700 (PDT)
Date:   Tue, 29 Sep 2020 05:46:08 -0700
In-Reply-To: <000000000000680f2905afd0649c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b98b5505b0732a29@google.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_trace_run2
From:   syzbot <syzbot+cc36fd07553c0512f5f7@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        corbet@lwn.net, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@gmail.com, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, kuba@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rostedt@goodmis.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 58956317c8de52009d1a38a721474c24aef74fe7
Author: David Ahern <dsahern@gmail.com>
Date:   Fri Dec 7 20:24:57 2018 +0000

    neighbor: Improve garbage collection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d31675900000
start commit:   12450081 libbpf: Fix native endian assumption when parsing..
git tree:       bpf
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11d31675900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d31675900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac0d21536db480b
dashboard link: https://syzkaller.appspot.com/bug?extid=cc36fd07553c0512f5f7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1365d2c3900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d5f08d900000

Reported-by: syzbot+cc36fd07553c0512f5f7@syzkaller.appspotmail.com
Fixes: 58956317c8de ("neighbor: Improve garbage collection")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
