Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF08311557C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 17:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfLFQeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 11:34:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36613 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfLFQeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 11:34:01 -0500
Received: by mail-il1-f198.google.com with SMTP id v15so5668751iln.3
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 08:34:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=eN4yK+b1Bwvylv7Nm0VpeOFgnJkXHsh0eveEUiwrQH8=;
        b=dO4/zw3n92mSgyT8v54273vTkxJZYY4iTFbufrRj58EBvf/BgE4aUdLV2ozGfbaPN6
         nVBrcxWFBji83z93PGrZKPb3NkIecOM8e0nff6fHJcG1WA8hIHIqdKqAjpXYHBwvYC2k
         ZCrhS9alkg8XGseIYYsT5rDqytXrwVa6nb/GPW33v7gwk3ynSUSwt/0VK6cRVwVr7eSJ
         qTtZ9oPzw24JlyLhNIJAiNg+XmwDkXxXsf7aF4sPfVBmOHgnbbgQkTHenhdHLNqRZsCQ
         43ImdYrr4TFfA/OVvdn3ffpOb3KDsALj7C4GIIDO0iIaiDztz1AEVSCIndDIHLx5//xD
         xWNQ==
X-Gm-Message-State: APjAAAXmq7x/Nx/vWa1fbZdTpREuqEuCZnoPkzlzRiFLZnIWrW33TsDH
        r6VmjpLizyITpa2iIiVTd92UkVLtARyHFyuDz1FC1LRi1GOj
X-Google-Smtp-Source: APXvYqzZYpNyvisihbt8EN3KnLhQ+QrZm3JeQEpbdA8h9nBmjE1AdDXOmVmenOawWmDOfOfWECCiqsoRsetDdfRKflEyZvm4mUC+
MIME-Version: 1.0
X-Received: by 2002:a92:4891:: with SMTP id j17mr14417440ilg.33.1575650041118;
 Fri, 06 Dec 2019 08:34:01 -0800 (PST)
Date:   Fri, 06 Dec 2019 08:34:01 -0800
In-Reply-To: <000000000000e1d639059908223b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fdd04105990b9c93@google.com>
Subject: Re: KASAN: use-after-free Read in soft_cursor
From:   syzbot <syzbot+cf43fb300aa142fb024b@syzkaller.appspotmail.com>
To:     b.zolnierkie@samsung.com, coreteam@netfilter.org,
        davem@davemloft.net, dri-devel@lists.freedesktop.org,
        gwshan@linux.vnet.ibm.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, ruscur@russell.cc, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
Author: Russell Currey <ruscur@russell.cc>
Date:   Mon Feb 8 04:08:20 2016 +0000

     powerpc/powernv: Remove support for p5ioc2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1512d1bce00000
start commit:   b0d4beaa Merge branch 'next.autofs' of git://git.kernel.or..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1712d1bce00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1312d1bce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f07a23020fd7d21a
dashboard link: https://syzkaller.appspot.com/bug?extid=cf43fb300aa142fb024b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1745a90ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1361042ae00000

Reported-by: syzbot+cf43fb300aa142fb024b@syzkaller.appspotmail.com
Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
