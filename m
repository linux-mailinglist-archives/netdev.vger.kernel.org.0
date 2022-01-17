Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBACA490C3A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 17:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240891AbiAQQMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 11:12:14 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:33439 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbiAQQMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 11:12:12 -0500
Received: by mail-il1-f198.google.com with SMTP id q12-20020a056e0220ec00b002b4dfeb7b27so12033572ilv.0
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 08:12:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xuzTZ41K566REjxDbPumQ9eQ7qYKtqQReAxXQBUHG4E=;
        b=v1C+oNVRxtoLbjcVHeCu3uu9hQ7UxM4XVoTDricjs2aTsmZloTkoEGqLsBgQtpBwd4
         zGzcI0/EOBeWBcTW1XXObKhlB7DggsXNYvLZb8olPDOF1gjsZ3oXcWW6lIml6NygRz8d
         iU99EaE+dVa5CAw0r4AcmoHchA/bKr5jyOhO6DCoX2+v9r1y4qvdhaUUfxsNVlumCWhu
         RcjdZ+VMZH+H/Q626+wBrjUbCJFxNggzQ3bLVd27WR64IDO6W3AT5jGgGQ/A9rCLzNuN
         rqOUW9WNUQEtDSG4I9QLvL13ie32eaTIUDydrs2W9BMeAj78hMRbJasJRcrFudD14cUp
         DwFA==
X-Gm-Message-State: AOAM530zwLf4IIJ1IhYJcv1VgZy9UizXccuIzgHTgkqjUzpVY2iG8p+k
        Av8ExbIxjnip+mZArZSbJAJjbv9q5XjsDKCnEyvPyP4ELkYH
X-Google-Smtp-Source: ABdhPJz1jyyIXxHrExZi60mnLbKlhQ4qpcFnzsZJTX4wBUQTPJaJ+7xBoy1CZ1oYysLObagTp2nEyg6NE4o1+kQgvoMIAINQnGVz
MIME-Version: 1.0
X-Received: by 2002:a02:94a3:: with SMTP id x32mr10046790jah.185.1642435931560;
 Mon, 17 Jan 2022 08:12:11 -0800 (PST)
Date:   Mon, 17 Jan 2022 08:12:11 -0800
In-Reply-To: <000000000000c0069f05d38f279d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044c19b05d5c96a09@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_hook_entries_grow
From:   syzbot <syzbot+e918523f77e62790d6d9@syzkaller.appspotmail.com>
To:     antony.antony@secunet.com, coreteam@netfilter.org,
        davem@davemloft.net, eyal.birger@gmail.com, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 8dce43919566f06e865f7e8949f5c10d8c2493f5
Author: Antony Antony <antony.antony@secunet.com>
Date:   Sun Dec 12 10:34:30 2021 +0000

    xfrm: interface with if_id 0 should return error

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10eb9bb0700000
start commit:   9eaa88c7036e Merge tag 'libata-5.16-rc6' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=10f3f669b8093e95
dashboard link: https://syzkaller.appspot.com/bug?extid=e918523f77e62790d6d9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1781a643b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15130199b00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfrm: interface with if_id 0 should return error

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
