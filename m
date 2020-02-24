Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BFE16A56C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgBXLqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:46:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:56595 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgBXLqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 06:46:02 -0500
Received: by mail-il1-f200.google.com with SMTP id p67so17794149ili.23
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 03:46:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TPDa8vA3dA5ocPrn3u12l+xTYIvr8/gY5caMU69qWlU=;
        b=VfTcKnYPCnlbVnDbP4Bwelx8QQOJTTdloLDp2FeVWYWeFb++A8MXJ+v7kDA1425D4u
         aJBdWHRhP6qm89VKGZDlkqtaLgBaOTz9e8FdRnsQdNURW1r6k32XL5egua4z8P4jQwJq
         G1M5bsH7FwrLqSI4hBIXaSBJNw3OPdRLIX4i6xvVt3DSx1thKWa8oeFbzN+gnw3MKKaG
         FmjH0RsN41AENpwoPY2zg2dFujL9Qzi+p625LHH0WqKi86OO9V6W00XiWTrQ2pQYqCSY
         5d3FxcyvXWEwC9FIzcGC8JLNzQQU9U8fIDzoiQLR7/BSolji5r/NaWXtU37DtrS14p6v
         2wCg==
X-Gm-Message-State: APjAAAUtgdb0MVeViHJreTjo/gTYqOb6LUUQ5rSwmC2pQ4QZcxdmT5lf
        CAvwpDAyH2thpSZYWAfRQzE+tBg7cnvWjfJxu7Nf7oDtsJQg
X-Google-Smtp-Source: APXvYqw8hJLLKQWy7t1wn0gt4p/CBTAWcz0u7a08HT32PVYseKb6Zst8oSvvhVBG6HkcXdOrZxccOixjo3lFs6l0GucGK/G5V7q9
MIME-Version: 1.0
X-Received: by 2002:a6b:730c:: with SMTP id e12mr48673976ioh.4.1582544761598;
 Mon, 24 Feb 2020 03:46:01 -0800 (PST)
Date:   Mon, 24 Feb 2020 03:46:01 -0800
In-Reply-To: <00000000000005efef059f4e27e1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b46ba059f50ea17@google.com>
Subject: Re: KASAN: use-after-free Read in ethnl_update_bitset32
From:   syzbot <syzbot+709b7a64d57978247e44@syzkaller.appspotmail.com>
To:     davem@davemloft.net, f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit bfbcfe2032e70bd8598d680d39ac177d507e39ac
Author: Michal Kubecek <mkubecek@suse.cz>
Date:   Fri Dec 27 14:56:13 2019 +0000

    ethtool: set link modes related data with LINKMODES_SET request

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16d59109e00000
start commit:   0c0ddd6a Merge tag 'linux-watchdog-5.6-rc3' of git://www.l..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15d59109e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11d59109e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=709b7a64d57978247e44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13885de9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1518127ee00000

Reported-by: syzbot+709b7a64d57978247e44@syzkaller.appspotmail.com
Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
