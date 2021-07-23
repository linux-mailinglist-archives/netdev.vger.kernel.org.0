Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32343D434C
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhGWW3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 18:29:40 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54102 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhGWW3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 18:29:37 -0400
Received: by mail-io1-f72.google.com with SMTP id w3-20020a0566020343b02905393057ad92so2581382iou.20
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6RQsGzkA52unvEXhAGOuDMaDb8vBCAzRbnUzWuORtwY=;
        b=V7UmHMDa74uzltYB9LhSWX2MvWZ/XdWK6imatokmoFSkKjxyy1yJvT8mwJQ6wLK5ek
         a9anO5ZQVbcmK68tOJ3WasiD2chDECz5iQ9KrzufxJsSvzYfzqdmxmGg5sKbzOT5eByw
         u9h+4kcZz/LBgTkw5KySzX0AaF1wFOO8ZKw0n37BAMYijbUt1anm6cOZptJpzWyQPldO
         0gGSQxwAaz3lhZJoM3UdFPCNT2is6Ra9RSZ1ShV2OcH08Xf4vsOHhagcMP+JPPR0EPgW
         2gty7bzOZDSRD4EJHemiMJYz7ljNVxzgY9kxQ3ocKzgkFd4JR8+hU/P6w142Ft79GIO1
         RXNg==
X-Gm-Message-State: AOAM530XUZW+kpxlM106AzTMILBYDzK4aCHP2NP0e/jje8qSIWwRHBL4
        XMYWMPHThkg3OepeIbT9xAc72kFZcuxVfLNtZ4C1XZOrwNZT
X-Google-Smtp-Source: ABdhPJwBnb2izvcnLq+78+oC7ssLD4z4TZTwLRynmblYk+oOhI0ea8aORnvXRNoO10TBdt2CBU09OzlhW8R6f6V1sxyHgENr0RUQ
MIME-Version: 1.0
X-Received: by 2002:a5d:8747:: with SMTP id k7mr5777211iol.83.1627081809209;
 Fri, 23 Jul 2021 16:10:09 -0700 (PDT)
Date:   Fri, 23 Jul 2021 16:10:09 -0700
In-Reply-To: <20210723194932.6c3b77a8@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042305105c7d281d0@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
From:   syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, devicetree@vger.kernel.org,
        frowand.list@gmail.com, gregkh@linuxfoundation.org,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com, rafael@kernel.org,
        robh@kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com

Tested on:

commit:         90d856e7 Add linux-next specific files for 20210723
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=644211b3d3da598c
dashboard link: https://syzkaller.appspot.com/bug?extid=e6741b97d5552f97c24d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=118f857c300000

Note: testing is done by a robot and is best-effort only.
