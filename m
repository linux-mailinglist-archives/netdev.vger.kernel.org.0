Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF564163E38
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 08:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBSHyE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Feb 2020 02:54:04 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:54295 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgBSHyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 02:54:04 -0500
Received: by mail-il1-f200.google.com with SMTP id t4so19233296ili.21
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=bhiLhZ0hGFmHCjOA0xxswOfkox27Yu7xmMOMfRdjKnY=;
        b=jhzpV6uDrRm+P0uCY8KEYrwKOKe1f5TYCvMkFUdtjxJNrlW5beBUm0SLe0KNd45IWD
         s7OX8pnohxCDdeldgTJRaRci04V9RIIzhGX4ECfvGSJ5mPvyQ4Z5vE6N+xIAQKh/cnaF
         Fde2VeKBMdUYxZDL0PK1ZFv8BpKDIt8mtV3iuY/Svp9dmYEHWbtUwg3FmaBGo35WwbLV
         eL8QT+0tW5T6RjnyMve6cINDETu47z5UvTxwa+bqMDTZFn5kdIlY33jklNUXOcfgnC6G
         myjmxWjFXOJRUsWdPKQmPAPQYfQg7vw1AdTfEuhVyjQzGB573h8MvbeMRK4svbzrj/1i
         /O7w==
X-Gm-Message-State: APjAAAWDy+wX8fYDc/2gYwKfy7enUQYXbOOSXXT7hxp+pWtmoS7NVANt
        NgT4iigD60Uwy2dvM6/IqFZtBdJjhFx+k0/yIlmDxHjGrErn
X-Google-Smtp-Source: APXvYqxGYY13aZOMM0BSOmDQMzSYZrf2qmPLxLF8eTHCcZFD8r1N2DfCNIuzDx8cL8jZ8cKMDsJUm0ShbBazBm0Pcb2Lzvn6MzqR
MIME-Version: 1.0
X-Received: by 2002:a02:2101:: with SMTP id e1mr19970446jaa.29.1582098843467;
 Tue, 18 Feb 2020 23:54:03 -0800 (PST)
Date:   Tue, 18 Feb 2020 23:54:03 -0800
In-Reply-To: <0000000000006d7b1e059c7db653@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000908c50059ee9173a@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ip_ext_cleanup
From:   syzbot <syzbot+b554d01b6c7870b17da2@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, florent.fourcot@wifirst.fr, fw@strlen.de,
        jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 32c72165dbd0e246e69d16a3ad348a4851afd415
Author: Kadlecsik József <kadlec@blackhole.kfki.hu>
Date:   Sun Jan 19 21:06:49 2020 +0000

    netfilter: ipset: use bitmap infrastructure completely

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17079245e00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=b554d01b6c7870b17da2
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145948d6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16202cc9e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
