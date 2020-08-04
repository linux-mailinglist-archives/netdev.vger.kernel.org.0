Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB723BAD8
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgHDNBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:01:32 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49592 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgHDNBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 09:01:07 -0400
Received: by mail-io1-f71.google.com with SMTP id 189so4885772iov.16
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 06:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=06+82rKMp3PGXLDD6Ap7gC365MaLMsLGY5Rl6STa3zE=;
        b=n71SEQpM0z5w4k2lw8zOdAo888jtiy/0pnKp50j5KAPARyoswjWhVF+S3wdzOyaR6B
         49eXR9nJE/F4zUTqwFcrTFHUQ9qSBOSyxo8RkyAFB5FaIs8/lniVVojNzCFL5cDpqW2p
         E51jrk3P90cFvPabtmmfKah4ZNLfZRzp0xmKkOoFuyKEcsgIGzE8vx7G1TGTj8811nwJ
         w4ZxyOotSHPfft9LDTLv5Qpu0L+021c9VTClytDP9IQ7YgaNF2Qn3WuRpITe6fR1AwTl
         SOYl9ZHglQ2fC/8Gt5wj5Vf/tDxaKVIUcBVnb+RIIuBKa5jWhOxdlkLpal42SKLdl3nL
         DoPw==
X-Gm-Message-State: AOAM531+cuI9/5uJCvjNbO/2I4dIjCj+unuvkRKmGa0kSW9OPvdAnjmM
        T6x7KUSJ/Wwy7AH/E1stPLnykFNi6r+XTZAxFN+C5vCjR9xd
X-Google-Smtp-Source: ABdhPJysIn/3rq8mJzFBZcPdgkiq5Vci73yhB6VXvAfDq6syCOUZWs4ErkDjGmgAWbCV304S/arGJe8W97c4vCtTU2PHRCJr/z6K
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d51:: with SMTP id h17mr4320234ilj.155.1596546066783;
 Tue, 04 Aug 2020 06:01:06 -0700 (PDT)
Date:   Tue, 04 Aug 2020 06:01:06 -0700
In-Reply-To: <000000000000a7eb5e05abeb197d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002da68705ac0cd9ab@google.com>
Subject: Re: general protection fault in hci_event_packet
From:   syzbot <syzbot+0bef568258653cff272f@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, geert@linux-m68k.org, javier@osg.samsung.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, marcel@holtmann.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 941992d2944789641470626e9336d663236b1d28
Author: Javier Martinez Canillas <javier@osg.samsung.com>
Date:   Mon Sep 12 14:03:34 2016 +0000

    ethernet: amd: use IS_ENABLED() instead of checking for built-in or module

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155180c2900000
start commit:   bcf87687 Linux 5.8
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=175180c2900000
console output: https://syzkaller.appspot.com/x/log.txt?x=135180c2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b489d75d0c8859d
dashboard link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1043af04900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ca1dea900000

Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Fixes: 941992d29447 ("ethernet: amd: use IS_ENABLED() instead of checking for built-in or module")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
