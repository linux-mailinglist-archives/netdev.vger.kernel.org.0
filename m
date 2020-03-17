Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A66188FEB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCQVAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:00:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56400 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQVAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:00:05 -0400
Received: by mail-io1-f69.google.com with SMTP id d13so15053208ioo.23
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 14:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jOHQtkE+j+BwIkremLXMAym3S1dSOKIG4OvqLs6ZU6s=;
        b=ne/hyUjssdB/RdUk7O2GbvQzYT4szaJD04Tjn/J7Mhlgw4DFKEVwi2ywqxrNOJtnwb
         XP58ulmeb6VSVwMLiIcGedyphx3LrsCTDNrJ2K8YRg59RZmG3KuRKtbX/nJBmEHjPco2
         urPsOl8uNnzu2SeeqU6dp2Jya6PrjPOSa+FDhr4/COyTP3HWnnfBWYmqpdJmxvtr59PI
         vcR5P3FD5w/tFncuw1jzUXrW01jD1l8wIgbqN0emqTtmomlPNDUA34u0ZFisF5nz1iOp
         /hcbnR4B/abbWDJ28Muj/XWllYlu/ZqIYhWd2tMD37aUgXzjJwXhWky/tYNyK69wOr8s
         zgdw==
X-Gm-Message-State: ANhLgQ2gL2RtTv3QRkwkV0BIMJcEB+ZaVqLD0Ki1VMsa6X/NutDbGu0A
        PeCD+CxX0pdr8dewzThcCHPbIeEvpvFnWnkVd+Ns9gkY368Q
X-Google-Smtp-Source: ADFU+vvjZYbx7yw6D42qU49X2AdYKRb+wwE/boG6wr6tdhE57By27JNVOyvqOTfhPYLqsPqBjiMMmM8UOmZHaQdMVGzs1UGN1xRV
MIME-Version: 1.0
X-Received: by 2002:a05:6638:a99:: with SMTP id 25mr1264995jas.37.1584478803965;
 Tue, 17 Mar 2020 14:00:03 -0700 (PDT)
Date:   Tue, 17 Mar 2020 14:00:03 -0700
In-Reply-To: <000000000000f3b11305a0879723@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000043c5e505a11338e0@google.com>
Subject: Re: WARNING in kfree (2)
From:   syzbot <syzbot+50ef5e5e5ea5f812f0c2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13257803e00000
start commit:   2c523b34 Linux 5.6-rc5
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10a57803e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17257803e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=50ef5e5e5ea5f812f0c2
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d8ae91e00000

Reported-by: syzbot+50ef5e5e5ea5f812f0c2@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
