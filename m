Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A691C315E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 05:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgEDDCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 23:02:06 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:38751 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgEDDCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 23:02:05 -0400
Received: by mail-il1-f200.google.com with SMTP id u11so12430135ilg.5
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 20:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=VsgFqYSkkd5RuUdbSLmpmT3wYB5MsDwArGNEdSX9o6A=;
        b=iXoqTVscXClowFYY67BfQl+cuXLwxsnvquEQrT7SRn+ff5ILiwOcX7B4af9Zv/yW4S
         jghFI8NH0zjdhcgFZ75jJpWyWbd5icQNrlLEA0gOGb47UBpcJp09i1h9px5UjqxC5hbH
         PfS7NsimhhOAZyUHv41qJWh2bFPOOfNrRn37feyerLcrLwYXd75svNETgsSznHfwccWB
         LuLdP2QkU3DkwN/ArCBFV2PLp/rzqFnUWgAUJsntPYHAX0hATvJwiI4US1uaM2wolWuh
         tFE/UuxN+SioIOY2/EhF+UwizgukoPzDleYxIqm8gC0eRHQC8oGhf391cdGQd5lBcZeI
         j6fQ==
X-Gm-Message-State: AGi0PuaWblZaVFh2fxLou4/hfqxgjr4Y8UdiGfae9Iy8F6QaFEHoekpa
        dgzoWlMRxXcLsgPyDV1Y3LNLKdv3bgHU2zqo81h1oFrzBX2l
X-Google-Smtp-Source: APiQypKVjvGUSvnQLOwHaUNc3oSLx1OL9IDYU+TwsaaCuFKXkqDorCljUIAIiJwrVKP9h2yMm1lLreb2XNEBCIfKdpGQt0q5p9WS
MIME-Version: 1.0
X-Received: by 2002:a6b:4113:: with SMTP id n19mr13759133ioa.187.1588561324819;
 Sun, 03 May 2020 20:02:04 -0700 (PDT)
Date:   Sun, 03 May 2020 20:02:04 -0700
In-Reply-To: <0000000000001b1a1d057e776c92@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007851da05a4c9c169@google.com>
Subject: Re: WARNING in hsr_addr_subst_dest
From:   syzbot <syzbot+b92e4f1472a54e1c7dec@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, arvid.brodin@alten.se, axboe@fb.com,
        axboe@kernel.dk, davem@davemloft.net, dvyukov@google.com,
        hch@lst.de, kuba@kernel.org, linux-block@vger.kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, mkl@pengutronix.de, netdev@vger.kernel.org,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 4b793acdca0050739b99ace6a8b9e7f717f57c6b
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Fri Feb 28 18:01:46 2020 +0000

    hsr: use netdev_err() instead of WARN_ONCE()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130746ffe00000
start commit:   ea200dec Merge tag 'armsoc-fixes' of git://git.kernel.org/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcf10bf83926432a
dashboard link: https://syzkaller.appspot.com/bug?extid=b92e4f1472a54e1c7dec
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b5cafee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12574271e00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: hsr: use netdev_err() instead of WARN_ONCE()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
