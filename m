Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8694182331
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387410AbgCKURE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:17:04 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:36446 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731057AbgCKURE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 16:17:04 -0400
Received: by mail-il1-f198.google.com with SMTP id v14so2265587ilq.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 13:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Hk8leBLQn5EO2E5GYez0a5lDH0bgTVJ9Yjc9wD197GA=;
        b=WlBKOwDBrDWj0rSsk/2OINjIB5t7m+2tvlbl/40Whs/zGjqKKYXEkjNZvTQy9KAu7W
         FWCHbW3Wum/m2FOluipOEvID5JtqFkLVSEe09bg8Cy/J3kghx18Jm0qoKKkiyoxgELVC
         9gv/y+BPOJYlDMnm7hT+osHtK1kclgrdifthRPcpYnEe7TC1aSjmdDr13ef1UT6X3uSw
         +9bqHpiBeSPFOLvKaOIJIEKAe1uTwyByywKFLWYjO9kxuFrfjGV81MOkySqdT4banKHh
         5KZcnVmfRcuHM5nVvrt5044X8swlssAtmmj/zmHN5AMOElNRHmg0VPdxUoiPrfikGzkq
         i42g==
X-Gm-Message-State: ANhLgQ10Tva5hZfyZcBGBpmtAZ1buI1MRwJa4hal7RO/yjSwTNeV+6th
        e28FLVFq+qTrFVuvX43NAdFyUPa81BzOPdu5eTSmLWFy7f4f
X-Google-Smtp-Source: ADFU+vuCk0oLjsQRK1OQUGd8tOfOULwTEpr37d1F6UYTw6+1J+u2VViJHjd/h7gGWV9DvDuMYhL3fUTIAi3lVakXW/slGPEJZJ+Y
MIME-Version: 1.0
X-Received: by 2002:a02:962e:: with SMTP id c43mr4679555jai.26.1583957823254;
 Wed, 11 Mar 2020 13:17:03 -0700 (PDT)
Date:   Wed, 11 Mar 2020 13:17:03 -0700
In-Reply-To: <00000000000030395e059f6aaa09@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064f9a805a099eb8a@google.com>
Subject: Re: general protection fault in j1939_netdev_start
From:   syzbot <syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, jiri@mellanox.com, jiri@resnulli.us,
        kernel@pengutronix.de, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        mareklindner@neomailbox.ch, mkl@pengutronix.de,
        netdev@vger.kernel.org, robin@protonic.nl, socketcan@hartkopp.net,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 8330f73fe9742f201f467639f8356cf58756fb9f
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Wed Sep 4 07:40:47 2019 +0000

    rocker: add missing init_net check in FIB notifier

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=165cdcb1e00000
start commit:   63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=155cdcb1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=115cdcb1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=f03d384f3455d28833eb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162b8331e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f10a2de00000

Reported-by: syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com
Fixes: 8330f73fe974 ("rocker: add missing init_net check in FIB notifier")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
