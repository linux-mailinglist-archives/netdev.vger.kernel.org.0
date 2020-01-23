Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F80F1473B8
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 23:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAWWWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 17:22:03 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:49973 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAWWWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 17:22:03 -0500
Received: by mail-io1-f70.google.com with SMTP id v11so40380iop.16
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 14:22:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=U2ciZII89LyEb1jgPxE5/IJrQKEwwRWzV2RXknpTZh0=;
        b=UlvilAIOb+rWvfht2OXk9nLNXPdzrsM9Ib1QPJB8bn8YCp8ZIRC48s3rnrnKzBDV9n
         mVkSVYskOKcguZZBSGE3h5URNTEJXESEVmyCWxyKlNGympxLgdaW51j6yB34J1pdaB6F
         HJipJFbfOCGv0uhzHxWle5T78Qmh92xAbwLAsyauYCE0DRalFsOmiyBrEjl3ErI8j2j+
         7d8bjtmcu4vG+HaWik0lC50Rva4uW+hyWxVlOp1cgKxr2oFByAdZzhuArgTob5OUSe+S
         wRYur7XeQ0YG/fBPj0OxdFu1tZ5RcNYbIeVTyZKgxxHFwfxDNWUL1EfZ7IANkSf9+Qc5
         L4eA==
X-Gm-Message-State: APjAAAXVPT8zJjrNyLdmJqyMASqCWn4wlhCCFbssc3QD4lVkKToQv++a
        jJiS4Y2fKS1YQcr7fDZcKNTi97wdbF7QhOy8G2kKU6JRZ04g
X-Google-Smtp-Source: APXvYqzaQsx9AEgaVI+glQ1AcIBsAAutP1ZctuK9ZTtYuJ4mdcopjSrfR25SqY6ZJWnqbTQIJlRs2yTGajrbtyPIUwun6yUoBqiI
MIME-Version: 1.0
X-Received: by 2002:a02:8587:: with SMTP id d7mr59180jai.39.1579818122597;
 Thu, 23 Jan 2020 14:22:02 -0800 (PST)
Date:   Thu, 23 Jan 2020 14:22:02 -0800
In-Reply-To: <000000000000da7a79059caf2656@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001df94059cd612b2@google.com>
Subject: Re: WARNING in __proc_create (2)
From:   syzbot <syzbot+b904ba7c947a37b4b291@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        dan.carpenter@oracle.com, davem@davemloft.net, dhowells@redhat.com,
        info@drgreenstore.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit f4b3526d83c40dd8bf5948b9d7a1b2c340f0dcc8
Author: David Howells <dhowells@redhat.com>
Date:   Thu Nov 2 15:27:48 2017 +0000

    afs: Connect up the CB.ProbeUuid

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1627a721e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1527a721e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1127a721e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=b904ba7c947a37b4b291
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c96185e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f859c9e00000

Reported-by: syzbot+b904ba7c947a37b4b291@syzkaller.appspotmail.com
Fixes: f4b3526d83c4 ("afs: Connect up the CB.ProbeUuid")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
