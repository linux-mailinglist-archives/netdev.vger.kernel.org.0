Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03C722A250
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgGVWYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:24:08 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35570 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVWYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:24:08 -0400
Received: by mail-il1-f198.google.com with SMTP id v12so2140435ilg.2
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wyels00yuO2hXMVYbZQVnCTESUbWVpmiNO+l3fFwAEg=;
        b=Q5SW0qCtHn9kDU94lNa8StSSxuLR+tNcq6myD2NAmDaIvwO1m5wkW/BxbK+ta404Jw
         17VB95Mj186MSDOeARFU1BUNh4oQ3a4M9aokARqEL/1G0Yamb1ZE6VTMGFDPmPjvOeEl
         bGeDQuSTwy0tTXLNkK6MkUgy1NJ8LyOhlQhhkFQv48RmRtPCFKe/YGe9Fa6kLlvHzadv
         MAazlU7JTo2fw3CvyOaSMv9ZIdUQb8eB8Ufsn6Qc+r7BCawNr6sn9Xune9zTbanrjT0U
         cv6RrF2ynnTwayfWMSH5g04/XJKRWvYOo7i11064jVnbPoPNhLUOkbdPoxH7CF3yTYJ4
         Q5GA==
X-Gm-Message-State: AOAM531Q3Hpj/tZalN8xepdCjxCLr+TPBzuWrr1YGFP5mh/ggoT00OAV
        up6qL4b5vZNdSqIi2EqeyGYrJTWsejsJLL2l0hsvmOCWmSls
X-Google-Smtp-Source: ABdhPJxjCcHozifK7eLXi30QKZ6a69Z/FmqquTzaVoaFK0E57gWv+ZSUlpHJnnPfhdRwhMZOJa28BI3Nn7D0lDWwXXKE1mAUB+OI
MIME-Version: 1.0
X-Received: by 2002:a05:6638:13ce:: with SMTP id i14mr1515751jaj.62.1595456647624;
 Wed, 22 Jul 2020 15:24:07 -0700 (PDT)
Date:   Wed, 22 Jul 2020 15:24:07 -0700
In-Reply-To: <CAM_iQpXKJ2SA=pRFEjwAwLkR_bw-y7ZqnSoe3zPqJc-CKv09Xw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc7a5905ab0f32b9@google.com>
Subject: Re: KASAN: use-after-free Write in __linkwatch_run_queue
From:   syzbot <syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com

Tested on:

commit:         0c473089 bonding: fix register_netdevice() in bond_newlink()
git tree:       https://github.com/congwang/linux.git net
kernel config:  https://syzkaller.appspot.com/x/.config?x=dddbcb5a9f4192db
dashboard link: https://syzkaller.appspot.com/bug?extid=bbc3a11c4da63c1b74d6
compiler:       gcc (GCC) 10.1.0-syz 20200507

Note: testing is done by a robot and is best-effort only.
