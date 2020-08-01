Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8D235490
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 00:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgHAW4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 18:56:11 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:45210 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgHAW4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 18:56:10 -0400
Received: by mail-il1-f200.google.com with SMTP id 65so3240965ilb.12
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 15:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dOzePy5yJodn3MAztJ8MjMszFxBpzjO8+9+k54Plw7U=;
        b=Yu38vr7R+xYtQEgMFuLnOEUoFCiRThc70NEcFQVJQ7QUwxmRUS/4k9qJ5VAOi3wB5V
         006xjwMVoMmxJmgwWBs+2I8DLmZlCSvKyA3E1VEGL3KDcT8lyuesA5WEgu5l0NiDDHps
         i7hriLsPNL4nlRYpaDQTh4t+zbWZFwbU5jNWdOGegzwK7/ibPa7UtasEFDg831/tdNrg
         PRmVgk8x6drMRcIrfZVHODqgln4bZID2aVNi3eLef+L5318wDHMBCWXvj90VkFOxu+ll
         t4ula8JjAjb2h2hM91D/mYuwiDx6gp0Yu51fIflxS9tJjj4/eEsvklkviV71pod16HH9
         RvYg==
X-Gm-Message-State: AOAM533Rxx+fVKHN5LA2X3whF2HJJqaypedu6sFtt6pGt/gRslLXyLbG
        hPKLtTPqjIIwxwCyl2jTKyMUElr8hhkmX6YzF8lW9rWlW6pD
X-Google-Smtp-Source: ABdhPJzoFyfIZQhNRPiFzD4/WN4vVmjC3jcEN/n2QVLjineSWA8YL2dCDfS0uwVot1kHmJxuiejHJRIs+6Vlg9DaPmCCBtbeQtI1
MIME-Version: 1.0
X-Received: by 2002:a92:79c4:: with SMTP id u187mr10446904ilc.194.1596322569603;
 Sat, 01 Aug 2020 15:56:09 -0700 (PDT)
Date:   Sat, 01 Aug 2020 15:56:09 -0700
In-Reply-To: <0000000000007450a405abd572a8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b54f9f05abd8cfbb@google.com>
Subject: Re: WARNING in hci_conn_timeout
From:   syzbot <syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        rvarsha016@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 3d30311c0e4d834c94e6a27d6242a942d6a76b85
Author: Varsha Rao <rvarsha016@gmail.com>
Date:   Sun Oct 9 11:13:56 2016 +0000

    staging: vt6655: Removes unnecessary blank lines.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17023a14900000
start commit:   7dc6fd0f Merge branch 'i2c/for-current' of git://git.kerne..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14823a14900000
console output: https://syzkaller.appspot.com/x/log.txt?x=10823a14900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=2446dd3cb07277388db6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f781d4900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116a0c14900000

Reported-by: syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com
Fixes: 3d30311c0e4d ("staging: vt6655: Removes unnecessary blank lines.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
