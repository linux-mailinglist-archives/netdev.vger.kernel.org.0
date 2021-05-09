Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A455437772E
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEIPRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:17:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36407 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhEIPRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:17:10 -0400
Received: by mail-io1-f69.google.com with SMTP id q3-20020a5d9f030000b029043969850b7eso943706iot.3
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 08:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ptj/dJVyElDcDR4dlhXEYGbK7nkar7mLZG2Y7a4j/mk=;
        b=Dy8I4AP+UyOi0aw/wZAg2MHa3tY/C8uNbEO1Ix4ZhQ1JcgjwxgrNDloey5gj45koXL
         P+6/2iD5saIf916e2GHZODqoRLr2h0Jo/WP/TzdYsCfqjWzqtWPX+r4XltbrXafyWMKz
         sAIk4inVgkSSfKs4+7s9vRag3ufJeGulopRJ8JBlKGIozU8HgJYCRGEsSdRsgB1+NJnY
         vdJwVfIUAb5qbVfFHyu2xEeWNMlx/mZ1tUwxC3t3NTxPnMKoIH4ZpH6mDuHxn5cD21Xd
         IUXaeEtxHrp3qoZ2Dfbgoi6IyGQwQjJ29C1YHSDL+r9M93hUP0wo4t2h4bnVgcbeyneG
         PUFQ==
X-Gm-Message-State: AOAM530kN+4AjYX8sX+k7m9kgdsAwcj8Xq9aEShHG51vxEnqpfNQgr8N
        xIUK7nv/D1pruSLwl2xmdOOYNAIpl911pnNKC1sU5dDvqOO/
X-Google-Smtp-Source: ABdhPJyJwGwIL1loYhchZjvnNXd4eyMCeUirhmBOuDgssB8pUDt9169y2A7L98/9mTHVSC/CagAOsT8bOf+hALkYwWJBC7G5uvBO
MIME-Version: 1.0
X-Received: by 2002:a6b:dc16:: with SMTP id s22mr14878581ioc.170.1620573367415;
 Sun, 09 May 2021 08:16:07 -0700 (PDT)
Date:   Sun, 09 May 2021 08:16:07 -0700
In-Reply-To: <0000000000009f94c1057e772431@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5b92105c1e723d5@google.com>
Subject: Re: [syzbot] WARNING in hsr_forward_skb
From:   syzbot <syzbot+fdce8f2a8903f3ba0e6b@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, axboe@fb.com, axboe@kernel.dk,
        davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        hch@lst.de, kuba@kernel.org, kurt@linutronix.de,
        linux-block@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        ming.lei@redhat.com, mkl@pengutronix.de, netdev@vger.kernel.org,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 9d6803921a16f4d768dc41a75375629828f4d91e
Author: Kurt Kanzenbach <kurt@linutronix.de>
Date:   Tue Apr 6 07:35:09 2021 +0000

    net: hsr: Reset MAC header for Tx path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119c7fedd00000
start commit:   3af409ca net: enetc: fix destroyed phylink dereference dur..
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=fdce8f2a8903f3ba0e6b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1525467ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114c0b12d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: hsr: Reset MAC header for Tx path

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
