Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5916490D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgBSPqD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Feb 2020 10:46:03 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45184 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSPqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:46:03 -0500
Received: by mail-il1-f199.google.com with SMTP id w6so514967ill.12
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 07:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=meEL6Fy6aleZ9jtvpgGrvnGSbq9MuEYemHMybXseYg4=;
        b=Z9H5mq1hNiOGKr+p0KQBCIRPn10gYnJp2ZcTpmKw/8vUxsCklaX9Bt1jdlPB1N4HVt
         FvITopElC2OFUaSt94IfmduRfWT5Q1rVKC8hLj2XIaz+I0nlCKH9TzSsBBhYFQ1JikYp
         tZD9IqGCxNlyWLIqyN27UyxgV6gYTRO2c0y0S8+S+Q2yUA0DoYiwGM6loUE07hWlHKow
         nIzssaj3uhVYt07kpRJ6hd4WRvRk5trD19dQOXw1I9VmkzJe2c5RYv7YBGPVoo0/tyHO
         bx07K8WwpMsTrDuubmFhY0c2ymcQWwOWFXv+obKgJ1XPHaOzliiErHxZwkyuhGIRGpI3
         LXag==
X-Gm-Message-State: APjAAAVQwk+aNee5lERvICkr7bGC3sms6/D66QNzj4d0TrL/u5RL//iT
        FHNj4cwkfWS3Uk/vcWrRYpQg0RiyfKr2eKJFiG/PNmeUbfyd
X-Google-Smtp-Source: APXvYqwJfaY34Duul7QI4nsW4eP5gWo56eh9X0PBjI8pEz/ZDnQ4R7/IwdlEugDK5rSMkM2M9L+WROKda4/pXhpDOVDjiChOjTov
MIME-Version: 1.0
X-Received: by 2002:a92:91d8:: with SMTP id e85mr25001159ill.146.1582127163011;
 Wed, 19 Feb 2020 07:46:03 -0800 (PST)
Date:   Wed, 19 Feb 2020 07:46:02 -0800
In-Reply-To: <000000000000c7999e059c86eebe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a7b14059eefafff@google.com>
Subject: Re: KASAN: use-after-free Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+33fc3ad6fa11675e1a7e@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        po-hsu.lin@canonical.com, skhan@linuxfoundation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13435a7ee00000
start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=33fc3ad6fa11675e1a7e
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15982cc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11be38d6e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: netfilter: ipset: use bitmap infrastructure completely

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
