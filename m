Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF8810C211
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 03:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfK1CAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 21:00:04 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:48145 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfK1CAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 21:00:03 -0500
Received: by mail-io1-f69.google.com with SMTP id e15so14350771ioh.15
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 18:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DYCoVBntiKkpTeX6a8KJneZkYAcva9u1pdG4zXgpO64=;
        b=t5efrV0OmtQ7XbB/PKR3TqEzKT0h/YWTlrd4NcHmnMkwi1VvguPqFoBj6j+wjSrD1j
         vxCeTs2lGXh1mHhUV+o+QA8scTjQdbLh3xCa2L8MWUpD11uNTZ+4n9b8/6Soj3MWzjFg
         AH5jyde70Q6cL9pV95Fu8VEwrsgE6KRHrUjuk+TF/nWnk2+X3xGEJrJU4483mTL7GFQQ
         KR6wDZLrZ04qDB2nblgz4ehe0TTwN0DHB/bPMiUu6zGC4L/8nEByUqlye8MMFy0ueq/G
         YgZznUVkgLlqn9lciPIADdoOJ3EAE+hY2blbGrXP+/7MH/cfeHQS5Pl9jmjYf2j7rPmg
         l/8Q==
X-Gm-Message-State: APjAAAW6WS+Qu5WGHvDhuseZ7e4d01eyyiddxyA46BhzJYaHmR23aOtW
        8cZExiY44Yu4mSAJjoeKX+JACjIe2Pqgw4YTT1j0+K9iF7aZ
X-Google-Smtp-Source: APXvYqxa6cVqXVISZzxW/NS5ndS0aUKG+LFds1IRmdw/COM4lIqUf7ADeUv9oT1zbWREBSImJJDTBYinlwECS+K++PZEc9N9rGqG
MIME-Version: 1.0
X-Received: by 2002:a92:461d:: with SMTP id t29mr49468857ila.100.1574906401298;
 Wed, 27 Nov 2019 18:00:01 -0800 (PST)
Date:   Wed, 27 Nov 2019 18:00:01 -0800
In-Reply-To: <00000000000038b5c205983c2df4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009aa32205985e78b6@google.com>
Subject: Re: WARNING in mark_lock (3)
From:   syzbot <syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, jiri@resnulli.us, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, vinicius.gomes@intel.com,
        wang.yi59@zte.com.cn, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit d665c1281bc89ac85b8b0c058c22a3f94640a1d6
Author: Yi Wang <wang.yi59@zte.com.cn>
Date:   Mon Oct 21 23:57:42 2019 +0000

     net: sched: taprio: fix -Wmissing-prototypes warnings

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=132ee536e00000
start commit:   89d57ddd Merge tag 'media/v5.5-1' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10aee536e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=172ee536e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=595c15c951695d1b
dashboard link: https://syzkaller.appspot.com/bug?extid=a229d8d995b74f8c4b6c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1511af5ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e0f17ae00000

Reported-by: syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com
Fixes: d665c1281bc8 ("net: sched: taprio: fix -Wmissing-prototypes  
warnings")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
