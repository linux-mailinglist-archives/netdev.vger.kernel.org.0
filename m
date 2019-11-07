Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94720F3024
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbfKGNmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:42:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:32821 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389119AbfKGNmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:42:09 -0500
Received: by mail-il1-f198.google.com with SMTP id z14so2675420ill.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:42:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hy0IUqmtd0A4X3fC1vp+srexXjp8oWtVGisb6LFHlS8=;
        b=uEXKXmyRr2XBbBvQGJxMmkQMNvH4dyrhpsOY1IR0No1SiN5ggloNyAT0EW1fXIQMHk
         LO0VP2HAGp8+v9c9D5AHRISmQy40UirvfYfkuWDIaHLrT5dplH1NkK5kWM7BmgdVTaPH
         B2q9W6VF7AhCnuT7wTdBhV7f5lC7uRYn8NGh1g4klAHtKZ9Qkq0mPDcr+sG1Xza1fpoS
         wSrhMGQrH3A0bW+v3G8H7Fb43P8dERmb35KSi1k67yIUoudIQqmWbgP6wFyRCvqPAvgP
         9SNJGNptrXVAld5VZlD7MuEF3rMzNp4/m71lsxI/xXxvnPsKrzt6tdRqq/UrwOPuq/S7
         xyWw==
X-Gm-Message-State: APjAAAWh55KS3wsNBlBBatvUQSVSfsfYbDR9LMKMKiQAlCKeTeswGolA
        RKR+3l0fdP2WmIDKd9Ifligb0ckvi3gsJA6UwWEa7TY6Y6Fb
X-Google-Smtp-Source: APXvYqy7IAQ7q+QKT0ObAmdHFO7txUCkOkWC8WZUDTvlKk/xr4Bj4B0+GFhbIElFmcxx4JMqWJqo/97ciSxzF5cqyNtl+EMM/48U
MIME-Version: 1.0
X-Received: by 2002:a02:6306:: with SMTP id j6mr4111377jac.62.1573134127936;
 Thu, 07 Nov 2019 05:42:07 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:07 -0800
In-Reply-To: <0000000000007829c8057b0b58ed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e139ab0596c1d4c0@google.com>
Subject: Re: KASAN: use-after-free Read in tick_sched_handle (3)
From:   syzbot <syzbot+999bca54de2ee169c021@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, frederic@kernel.org,
        fweisbec@gmail.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, sbrivio@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit bc6e019b6ee65ff4ebf3ca272f774cf6c67db669
Author: Stefano Brivio <sbrivio@redhat.com>
Date:   Thu Jan 3 20:43:34 2019 +0000

     fou: Prevent unbounded recursion in GUE error handler also with UDP-Lite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119c0bc2600000
start commit:   1c7fc5cb Linux 5.0-rc2
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=817708c0a0300f84
dashboard link: https://syzkaller.appspot.com/bug?extid=999bca54de2ee169c021
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c95a30c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11df0107400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: fou: Prevent unbounded recursion in GUE error handler also with  
UDP-Lite

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
