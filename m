Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC61A10916C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfKYP7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:59:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:48596 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbfKYP7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:59:02 -0500
Received: by mail-io1-f71.google.com with SMTP id e15so8358275ioh.15
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 07:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yUeyiVmdRHn8X3vVnYT/vxc1eNRVQp5M/ypw1pAPYls=;
        b=den0qnYD1gKjPPy3yI/wNW7y3ieVm9g+cURjZasahk6vLUFzj4c54v6Vja7a35GYTe
         IuABVpvkwQ7DuoXVGuThmXhGLHhbiIiGquLaQ/wEnzDoCmvTQSGLPOqQe7Yv0nEsPtb1
         jGNJRBv0NTsNjn2ukmU97VrAADGWrItl2fNx0daZeuF+hhqQQ2BIh90DRCy7/j5nkbwR
         1HTQTrs+4GU2NQU7T6qKA6fa53G0s/hC2kL1r247bxvNEMUBtcRRyzriqDKAoN43Wjf4
         /8vu8xElFDbnNF2ptYl4C9KJMttHcbXSP1rOomvfCTR3YuFMBh2K1GiIKLN8QXl4xobB
         bVgg==
X-Gm-Message-State: APjAAAXRDMaJxyRrBrydRfZmsjII7dIS+GYprE1sHjhE9bt9qegTieRf
        WT/AvZ3gBjapdwyOpfISlYxy5ULWK32pfveL196Nic3Afx04
X-Google-Smtp-Source: APXvYqynVxr815BoQYCNcPSokDuYaA68dhLy+qgKHBbYcNAk9X2Ea0HhaZtIBiKAZNrG636O8LHiBoEC1+w40u56oce5fDI8pN/j
MIME-Version: 1.0
X-Received: by 2002:a92:831d:: with SMTP id f29mr34892240ild.263.1574697541284;
 Mon, 25 Nov 2019 07:59:01 -0800 (PST)
Date:   Mon, 25 Nov 2019 07:59:01 -0800
In-Reply-To: <000000000000013b0d056e997fec@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093bc3b05982dd771@google.com>
Subject: Re: WARNING in sk_stream_kill_queues (3)
From:   syzbot <syzbot+13e1ee9caeab5a9abc62@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, davejwatson@fb.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        ilyal@mellanox.com, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pombredanne@nexb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 3c4d7559159bfe1e3b94df3a657b2cda3a34e218
Author: Dave Watson <davejwatson@fb.com>
Date:   Wed Jun 14 18:37:39 2017 +0000

     tls: kernel TLS support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127a8f22e00000
start commit:   be779f03 Merge tag 'kbuild-v4.18-2' of git://git.kernel.or..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=117a8f22e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=167a8f22e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=855fb54e1e019da2
dashboard link: https://syzkaller.appspot.com/bug?extid=13e1ee9caeab5a9abc62
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165a0c1f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114591af800000

Reported-by: syzbot+13e1ee9caeab5a9abc62@syzkaller.appspotmail.com
Fixes: 3c4d7559159b ("tls: kernel TLS support")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
