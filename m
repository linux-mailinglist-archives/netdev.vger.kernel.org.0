Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4505AFAA
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 12:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF3KkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 06:40:01 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49656 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfF3KkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 06:40:01 -0400
Received: by mail-io1-f71.google.com with SMTP id x24so12013603ioh.16
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 03:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=eziCMEFtU+C3qoNYfJHsPKHY2FKR9JngSHlmZZHqzFo=;
        b=qEr5XatCz1mIR1fAivvRRe0bCz+R5Hg2wqPz3YOXZYtfj2ipfaHw5y8BDvck6Gqed9
         H1SieilhelsyzZ6YC6Lo2Yre+VghBx0TB6JPW3R9FAirR5hKWiIoPc/Yc7YaL6jhg2rh
         ImWA4ljKnJMYGOoRr6CzHLb1cfF24eMo+MBRxsNWIPjelrmHFGRrAKD9hrzSnFKPDuxU
         ywKkzx6maksZ/kZPUECZgzmM2YKyImbDGBWpmrIIHLESCeMgV5/hZ9wXPsm1F6da1S0G
         m2Um1Ct8VQw+Og7zV5ZfsTJlS5tWb14V+y9HVarUt6f/NsvaFbGIhJZyKJSlBOCBxrSv
         Auaw==
X-Gm-Message-State: APjAAAWp2tb7a7nUTh6f+kPHGoDIQSd0lf51c9UVNd6FKuA85mF6TcFz
        eg/vsM7qrONIOIVeoYQStzKSeS7SuC/5WvH+zt+Z+38vtfPD
X-Google-Smtp-Source: APXvYqwc7jNxeDwuXuaVmtRV4iFyubee59JJU/yaTue7FDuw9a59U5XBHdkSI5CIzX3MUpYnDTjMD5X25A8OGVnPI50yMEKLHG28
MIME-Version: 1.0
X-Received: by 2002:a02:c6a9:: with SMTP id o9mr10128962jan.90.1561891200769;
 Sun, 30 Jun 2019 03:40:00 -0700 (PDT)
Date:   Sun, 30 Jun 2019 03:40:00 -0700
In-Reply-To: <0000000000003ec128058c7624ec@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003326c1058c8822c7@google.com>
Subject: Re: WARNING in kernfs_create_dir_ns
From:   syzbot <syzbot+38f5d5cf7ae88c46b11a@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        hongjiefang@asrmicro.com, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tj@kernel.org,
        ulf.hansson@linaro.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 7f38abf220e2c800a2c451372e9f07ed5fd0ea49
Author: Hongjie Fang <hongjiefang@asrmicro.com>
Date:   Tue Jul 31 02:55:09 2018 +0000

     mmc: core: improve reasonableness of bus width setting for HS400es

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129d6755a00000
start commit:   72825454 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=119d6755a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=169d6755a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
dashboard link: https://syzkaller.appspot.com/bug?extid=38f5d5cf7ae88c46b11a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a6c439a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1353c323a00000

Reported-by: syzbot+38f5d5cf7ae88c46b11a@syzkaller.appspotmail.com
Fixes: 7f38abf220e2 ("mmc: core: improve reasonableness of bus width  
setting for HS400es")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
