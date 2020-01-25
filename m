Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216A914925F
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbgAYApC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:45:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:57160 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387596AbgAYApB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 19:45:01 -0500
Received: by mail-io1-f71.google.com with SMTP id d13so2412100ioo.23
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 16:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7t8461NsKJ7dggiUJMEiWFWH6uHHmMrVa8LOc9k9NXU=;
        b=nhTy7JG0scgVEoA9jfWDSCmlabTgJo1z4OV32xHLFBVlTPbRZyPI0hy0T8wSlFs9Th
         x8B+6YAtV/GIz2lDNeRetS8V7hzbJU64D7J4Br5ByWb1b78lwlXInx+CHDUZn1IEqCTF
         coGXP7MBsIUTgw1PDC+hWownJuaMcW2IDngrwVG9VTxwRPHIP8YHK2yjxc0GkVZRoJOA
         en77sNW+qlcE45sjpDkgI+0xwtE504tEaIyDVP3Ive8LSrnaLu4Gf+Z9nE2MYPVbgZyd
         x7ZWuOj/Xl3TwMi1ncGMOQuerfw9mmI7FL7jXzWn0ahaEzgW/NnXDOaE2wkdPDc7Kf0J
         5HJw==
X-Gm-Message-State: APjAAAVymT08TLoWH61RraLmep8tWOCTnpVawIIh5//fFvQx2DaVGq66
        IZQ82bRssaZzRO4RaZnPfJby3DBWbWZEH70yE+4Pzd0R7H/a
X-Google-Smtp-Source: APXvYqwJo/vSmPmq9gsIz8uynVDogIStRUI8hB7HAkeHhbeN4sRbsogeWVwDSqjIRI+0a2J/NhCBO2MPxF0CPwKx3SXQudBlBCiz
MIME-Version: 1.0
X-Received: by 2002:a6b:915:: with SMTP id t21mr4112476ioi.34.1579913101128;
 Fri, 24 Jan 2020 16:45:01 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:45:01 -0800
In-Reply-To: <000000000000cdbe79059ce82948@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b3861059cec2f82@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_destroy
From:   syzbot <syzbot+a85062dec5d65617cc1c@syzkaller.appspotmail.com>
To:     a@unstable.cc, arvid.brodin@alten.se,
        b.a.t.m.a.n@lists.open-mesh.org, coreteam@netfilter.org,
        davem@davemloft.net, florent.fourcot@wifirst.fr, fw@strlen.de,
        jeremy@azazel.net, johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

    hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123fce01e00000
start commit:   4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=113fce01e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=163fce01e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=a85062dec5d65617cc1c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1301ed85e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b7b79ee00000

Reported-by: syzbot+a85062dec5d65617cc1c@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
