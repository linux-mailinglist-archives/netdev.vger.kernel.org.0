Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6860011F544
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 02:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLOB1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 20:27:01 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:46668 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLOB1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 20:27:01 -0500
Received: by mail-il1-f200.google.com with SMTP id s85so3200603ild.13
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 17:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=c+s69FUrevmh/qMLgOyZw9GWvtN3ytNCAie8XX1Wio0=;
        b=kDMrOQBzcN9zaWwi5v+tBVyZ4I6CdvagWMkAQvHt6LaxUtF3tcbhFz/rNVzLRsZtea
         a8CqH/5qMjKqQB45hpPDNLO2fXIFYO8Ztk8oa6z+TzOnpxe+9K7B09Ut3UcPyqr1VWoq
         xdtSwdkj5wkipR1AOR53LSz4w3TC3If+KATbSuEBDdJptMGHK6PwvsBonnKTqjUdnh0W
         JGtPb+OLDrpT95SgkBCjy3mQKOfjYJ1nKaocxGS0p/8Za8FPyO8UVQOMXYUhpWZ1SWjY
         djjsNEJpYkUnAR8OS05HaW+9r1t2DGgaWaz5ba1GnLU3Av6WeZuRpwf2wM0CKsrOVVCe
         WMWw==
X-Gm-Message-State: APjAAAXi+5RE5XRVf8oSC3859jTJAE7fRUsqjpbxZwjXZ1wiB/qk3+Wt
        Xp1gKXs2U8MMQOhdQqwCqO81NKkMYFj4qf0hZw+FaBbMFvdu
X-Google-Smtp-Source: APXvYqy7O21f8gr/KcYVDGHHA00H9AO2+CAAcrvPyJbJkQR9bGCOqaPnuFyWq42GKUJVdxRtIb/Aqis0HVOF9COqLeCaOOMD3jTv
MIME-Version: 1.0
X-Received: by 2002:a92:5a56:: with SMTP id o83mr2853063ilb.97.1576373220852;
 Sat, 14 Dec 2019 17:27:00 -0800 (PST)
Date:   Sat, 14 Dec 2019 17:27:00 -0800
In-Reply-To: <000000000000c71dcf0579b0553f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dcc9b10599b3fd5e@google.com>
Subject: Re: KASAN: use-after-free Read in ext4_xattr_set_entry (2)
From:   syzbot <syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com>
To:     a@unstable.cc, adilger.kernel@dilger.ca, afd@ti.com,
        b.a.t.m.a.n@lists.open-mesh.org, chris@lapa.com.au,
        davem@davemloft.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pali.rohar@gmail.com, sre@kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 8835cae5f2abd7f7a3143afe357f416aff5517a4
Author: Chris Lapa <chris@lapa.com.au>
Date:   Wed Jan 11 01:44:47 2017 +0000

     power: supply: bq27xxx: adds specific support for bq27520-g4 revision.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16661f41e00000
start commit:   ae4b064e Merge tag 'afs-fixes-20191211' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15661f41e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11661f41e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=4a39a025912b265cacef
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ec1332e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163455dee00000

Reported-by: syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
Fixes: 8835cae5f2ab ("power: supply: bq27xxx: adds specific support for  
bq27520-g4 revision.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
