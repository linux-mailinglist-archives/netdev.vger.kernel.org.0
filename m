Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD40B116070
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 06:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfLHFDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 00:03:01 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49242 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfLHFDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 00:03:01 -0500
Received: by mail-il1-f199.google.com with SMTP id t13so8852219ilk.16
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 21:03:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qxR8n/MO9nUojwz4mikH1ALZdXQUJxV8vd4w04E6/Ac=;
        b=K9jWDrM2iw9afeM9fd34EKAFMTueJK6Dr+3EMp6LwXt39H2uU7pSp2Jxy4EnIy+JZw
         z6PJ15qCE1wMxcYkIhwqdTgnGJZjwXKfgmm+jo+QmAYmMlJjUj0kQ7YSUql1ZQkrmJOs
         xhQ94qkGGyMS1dSqDy/TJgrhLmkVtyUwv8dDRto3rcDA7A+t4diBWR5wC2YD8MwC0bOx
         Pv5DkT+L+S/WhQUyoGoMVSD02tIrlAT+7rj5UyBlLiTBlcafQ9uSUhwXFfx4AtM0BWgB
         WikoeqzqrbirFVS7RHKf8ZEHfy66EncnkVHeKK+MFPjq8A9wO1vCH5SQGkepC9Vn6yPI
         pngA==
X-Gm-Message-State: APjAAAUt+vNRfN9KKgCHYbSaw1NZOtETjO2yse3g2mqU512mr0wLUFU5
        5NYGYMcnaOeZGgVO8NLQ9Pr17vwxwL7UVUITrxdBOs75Z9Mp
X-Google-Smtp-Source: APXvYqwhYun6FRgcqHHP72qU2fze8Qfccpac/MDOfTBslHGmFtbVnfIYVfHJILMkuRSGVKPU9YNFZlZopc4zcKxXx7fBNK5x0SmW
MIME-Version: 1.0
X-Received: by 2002:a5d:9c52:: with SMTP id 18mr15554232iof.180.1575781380427;
 Sat, 07 Dec 2019 21:03:00 -0800 (PST)
Date:   Sat, 07 Dec 2019 21:03:00 -0800
In-Reply-To: <000000000000734545058bb27ebb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006c96bd05992a318e@google.com>
Subject: Re: WARNING in perf_reg_value
From:   syzbot <syzbot+10189b9b0f8c4664badd@syzkaller.appspotmail.com>
To:     acme@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, arvid.brodin@alten.se,
        bp@alien8.de, davem@davemloft.net, eranian@google.com,
        hpa@zytor.com, jolsa@kernel.org, jolsa@redhat.com,
        kan.liang@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        vincent.weaver@maine.edu, x86@kernel.org, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 311633b604063a8a5d3fbc74d0565b42df721f68
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Jul 10 06:24:54 2019 +0000

     hsr: switch ->dellink() to ->ndo_uninit()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13e241dae00000
start commit:   e01e060f Merge tag 'platform-drivers-x86-v5.2-3' of git://..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9f7e1b6a8bb586
dashboard link: https://syzkaller.appspot.com/bug?extid=10189b9b0f8c4664badd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16615caea00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a222aea00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: hsr: switch ->dellink() to ->ndo_uninit()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
