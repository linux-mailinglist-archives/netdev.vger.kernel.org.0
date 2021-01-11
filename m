Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06A12F0C32
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbhAKFQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:16:48 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:45679 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbhAKFQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:16:47 -0500
Received: by mail-io1-f72.google.com with SMTP id x7so11714291ion.12
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 21:16:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TwLtYgNM/VxZnJX9RYzFOAmbDbu3TS829VUYdlrQ6tU=;
        b=gCfeghTDpWZjKDfW+9bTbe7SUXFjxj1sY/vZHjudgY4dIRDLmTlYlgD0aLz+xfo+Vj
         oW0f09c5PhWJCZVsfOWPHQKLE3JiSorby0lNbqVUUbYgWbkmdoF0VzRQMvXZvVHcCiEH
         hOehub8T/FQVycysq7lNQ+tp9E/wdMw/A3z+UHBzOEEDuEzFxDK1U1zZ5941WD+IPAQE
         /ddpRtizJtCZSODJVWNyoRzatuBUvMVdwKEqfQEva/ybfyKJEt8TEW4JLovkmjiss9Vt
         ewzYLahZWnX9ehs6ndP1u/Tv8IF7ULO/bSCmjNfn05KgfzJsdGxHF2WRhvjHYMQKFZCD
         5b3w==
X-Gm-Message-State: AOAM530W9f0QcFZ6ePTpLvbLNHKG+4MEG8AoMP4FnAIjbpBJB6pFtJD5
        vJB6BouFFWqCRI5OMSZ4w0Vy05LaoahbM9PWCgLsishrbnpA
X-Google-Smtp-Source: ABdhPJw34d6R73XmCxuksM9133DcvPyLfBOZgm6heuu0BEb6aKdNf+Jt1XOKWGljxWX0oVlLoshF5G4fzBYFc5U+6aYPAdyyumLW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f86:: with SMTP id v6mr14014231ilo.56.1610342166413;
 Sun, 10 Jan 2021 21:16:06 -0800 (PST)
Date:   Sun, 10 Jan 2021 21:16:06 -0800
In-Reply-To: <000000000000f5964705b7d47d8c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cbca0705b89900b3@google.com>
Subject: Re: INFO: trying to register non-static key in l2cap_sock_teardown_cb
From:   syzbot <syzbot+a41dfef1d2e04910eb2e@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, hdanton@sina.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org,
        mareklindner@neomailbox.ch, miklos@szeredi.hu, mszeredi@redhat.com,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 4680a7ee5db27772af40d83393fa0fb955b745b7
Author: Miklos Szeredi <mszeredi@redhat.com>
Date:   Sat Oct 1 05:32:33 2016 +0000

    fuse: remove duplicate cs->offset assignment

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fc80e7500000
start commit:   73b7a604 net: dsa: bcm_sf2: support BCM4908's integrated s..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13fc80e7500000
console output: https://syzkaller.appspot.com/x/log.txt?x=15fc80e7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ce34124da4c882b
dashboard link: https://syzkaller.appspot.com/bug?extid=a41dfef1d2e04910eb2e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166ee4cf500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1337172f500000

Reported-by: syzbot+a41dfef1d2e04910eb2e@syzkaller.appspotmail.com
Fixes: 4680a7ee5db2 ("fuse: remove duplicate cs->offset assignment")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
