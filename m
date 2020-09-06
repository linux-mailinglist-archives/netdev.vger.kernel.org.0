Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911E025EBE5
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 03:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgIFBHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 21:07:07 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:35066 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgIFBHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 21:07:06 -0400
Received: by mail-il1-f205.google.com with SMTP id p16so7581074ilp.2
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 18:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=uErToetCtxM2LxDa/nunGNpiTq3iUJM6c1gSOFYhqVE=;
        b=nKin7cfnjHiP8OYxA9KOHOy6TNVAY6nx6QG7PQydY8htCHlXya/9QudhO/EM5XCzlj
         Jcyo93G/kVP3q88ujSl3VrhBJ3kdxRzISmtYtm/QB0A2z9nXNsq37q7HS6rj7D/H5KuU
         XEKeqwYrlDEIjA1U7U80RTffBwVSClIe0blk0SDynUlQ100pNxUaZOzoYpyMDewq7aAr
         yz5B4fSQTt8BEiXyI/NTV4EQufkKoD2iPFcsSdchGbEmssfIyWDCbrNXfnvOx18Z/ZZy
         2deBn3cijLY05qpDZJIM6Eue1Q7HMvdKN1xRV5Kos4aDpxy8BOnit+UcH8gfMQXGoErR
         ZMGw==
X-Gm-Message-State: AOAM530LGA0xz+emj0JrZ6poVHVGoIhZfykqIpi7vfN9TIEQrfS8xCA7
        4c8u4PVBMPtXaFZh6QQOfXhgZu53U1g2BLQjRqtQH8La7N68
X-Google-Smtp-Source: ABdhPJym3N6qwjYEE5uH53mipM2L77NAqTDZN1skGYxJ5p38lVrxFf0yXeNgvWFwORCMUNrX5wE8e7Ubtqufgb0mrh/6nKA86/PQ
MIME-Version: 1.0
X-Received: by 2002:a5d:8042:: with SMTP id b2mr13018336ior.60.1599354425033;
 Sat, 05 Sep 2020 18:07:05 -0700 (PDT)
Date:   Sat, 05 Sep 2020 18:07:05 -0700
In-Reply-To: <0000000000000cce30059f4e27e9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fc62d05ae9ab8c2@google.com>
Subject: Re: WARNING: refcount bug in l2cap_chan_put
From:   syzbot <syzbot+198362c76088d1515529@syzkaller.appspotmail.com>
To:     abhishekpandit@chromium.org, alainm@chromium.org,
        bliniob53@gmail.com, davem@davemloft.net, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, mcchou@chromium.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b83764f9220a4a14525657466f299850bbc98de9
Author: Miao-chen Chou <mcchou@chromium.org>
Date:   Tue Jun 30 03:15:00 2020 +0000

    Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11aaff5d900000
start commit:   fffe3ae0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=18bb86f2e4ebfda2
dashboard link: https://syzkaller.appspot.com/bug?extid=198362c76088d1515529
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152a482c900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109b781a900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
