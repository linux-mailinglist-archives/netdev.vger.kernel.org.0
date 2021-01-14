Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DA92F5601
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbhANBA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:00:28 -0500
Received: from mail-pl1-f200.google.com ([209.85.214.200]:54492 "EHLO
        mail-pl1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbhANA5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:57:04 -0500
Received: by mail-pl1-f200.google.com with SMTP id x12so2237397plr.21
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jlFSyFsy03pYVrVR3CcVIDgLJx11fHk/YYGYXYtjZt0=;
        b=Kuoa6kauvdJAmI3aW0M5iOr9kHT4tnOi4G+jSSXab+zkODgM3XjwKDnSL5ZI3vSyjU
         gD7t/PrAUGs74e3wOk2UNs7ws2J3NykKpzHHvdI20OJRr0xjC1ORN6C5o+y4Kw3qeuKr
         kxO+IXCYqSXDSp+OoW+xCZrj73BFxpLiAhTK2YYP+NxNUK087n63S85RBBsZ1hQHOPZX
         zqVNLEeA1K8v59JIIU09tLY2wbk5aAQO+V+HVxRNOu5s52Lavky0ermpkYGQfJc3cMn4
         9Pxt1W/cwXG99UrfPC+WkibN8+f4JGCm2RW3nREW0tyDOpyERknAepjEZ+0S5qgYm7bn
         U+5A==
X-Gm-Message-State: AOAM533e8R4GPAddrRPGvFlhOkVJHoJroLotU2sCEDatzoPK0L6C9yKQ
        odzMZSP/bS5sQFGeRyWrRi+2tLPW+JU87r5wKouRSdZF5EP7
X-Google-Smtp-Source: ABdhPJy1vepLrK0QdOGj3+JxVkfzwde1SE5dgoHnfXS4WCuUzSYJSlWakQM+9vHXU3TywlsRkPAATkcWJ2PnQeeUhpeBjEvjEIeS
MIME-Version: 1.0
X-Received: by 2002:a6b:784d:: with SMTP id h13mr3621423iop.26.1610585226627;
 Wed, 13 Jan 2021 16:47:06 -0800 (PST)
Date:   Wed, 13 Jan 2021 16:47:06 -0800
In-Reply-To: <20210113114136.4b23f753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000504e4005b8d198c1@google.com>
Subject: Re: kernel BUG at net/core/dev.c:NUM!
From:   syzbot <syzbot+2393580080a2da190f04@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+2393580080a2da190f04@syzkaller.appspotmail.com

Tested on:

commit:         3a30363e net: sit: unregister_netdevice on newlink's error..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git sit-fix
kernel config:  https://syzkaller.appspot.com/x/.config?x=bacfc914704718d3
dashboard link: https://syzkaller.appspot.com/bug?extid=2393580080a2da190f04
compiler:       gcc (GCC) 10.1.0-syz 20200507

Note: testing is done by a robot and is best-effort only.
