Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A103508BC
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhCaVD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:03:26 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:41357 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhCaVDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 17:03:09 -0400
Received: by mail-il1-f198.google.com with SMTP id g11so2456475ilc.8
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 14:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kP/y11epKcSUPOyR3ggVPINM0BmYMwSnVyCElSIqNFk=;
        b=iNKm+geaKqO3fLlw2y5ZcunPVykWt77dXemLxvPe4R6oNVrQWMFYWjrBqgFMHT9mMZ
         HOGJvEExeC5E5HapDIHkE53dl2XynPguT2f2PcgpHOsdzlUk8Pb8Nb/ZPcpd4Kj4fKQk
         f3Uya+Raaese5mTdlI/KH3YoiH0prOh+t6pTDiVZt9dXtFqrIu97C6DW+LcDQ6QdN1rW
         HY/mBUAA3beC6TrQHPrmOmBbPu5fyPi3XOfTZOPCm5kBHzZfbA7LsrOnFo9QnQMGVGOO
         OK2X/77EFDQ2QBudLFDWO2lQ4bxACSxOpUOURNUtRXOm0YjF8ZAbnySrk1JLPnYVM4RE
         LP+w==
X-Gm-Message-State: AOAM5336eFRnLGLkhBViNLh9oje8QReB1Z6boI4KC1HHt9YX96cHnWK3
        jpxS+YwSjUwScOachZIY8bGcNK7sAotaycwDzonHWDyqHf8+
X-Google-Smtp-Source: ABdhPJwLRBNjRlYsZOUMcyuiCfXjpK8qdqf9jZ3VAQDOJm+DbI0iO8VxG0rEbQUcU2oSqtwg/wuXvw4w01xF8OT1kTor7aN6bJkU
MIME-Version: 1.0
X-Received: by 2002:a05:6638:388e:: with SMTP id b14mr4857937jav.62.1617224588612;
 Wed, 31 Mar 2021 14:03:08 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:03:08 -0700
In-Reply-To: <00000000000073afff05bbe9a54d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020564605bedb716e@google.com>
Subject: Re: [syzbot] WARNING in ieee802154_del_seclevel
From:   syzbot <syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com>
To:     a@unstable.cc, alex.aring@gmail.com,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        info@sophiescuban.com, jkosina@suse.cz, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        stefan@datenfreihafen.org, stern@rowland.harvard.edu,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 416dacb819f59180e4d86a5550052033ebb6d72c
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Wed Aug 21 17:27:12 2019 +0000

    HID: hidraw: Fix invalid read in hidraw_ioctl

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127430fcd00000
start commit:   6e5a03bc ethernet/netronome/nfp: Fix a use after free in n..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=117430fcd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=167430fcd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=fbf4fc11a819824e027b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bfe45ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1188e31ad00000

Reported-by: syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com
Fixes: 416dacb819f5 ("HID: hidraw: Fix invalid read in hidraw_ioctl")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
