Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF593E370F
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 22:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhHGUu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 16:50:27 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41623 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhHGUu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 16:50:26 -0400
Received: by mail-io1-f72.google.com with SMTP id c18-20020a0566023352b0290523c137a6a4so9329687ioz.8
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 13:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kB3Z+oJmbPVyqEenpzuOJ3r/Iu75zORAOLzcjtFRKcU=;
        b=b8NOegpTCA92uD67dAO/oud+dC3TtmLciTXr7/iwLQ+SaQeU9Y4CnUhqvcEu9kv3SZ
         7FZ7qdHRpR1e1Y2Bui9c9m6rSAL2wJ4MEcEVDBTTgFMGODuu1IxSfpeb3FOQcA45sEA7
         zjGg6AwxMUxaZaTUqEBD9KsN8XNxvgnNd3t6Y6YGUBehsV1ovbP4CNU069WzwamWGcst
         xLpp8q7I0lWyKCzeRQj2HVGIgkZU+RS4PxCJT4F8SjVPH5QAAQ/7J2KWZn9gTJms9OhE
         uDasoIehwWGZxRlCRobvzM3r7HxIURAivoGWn4tUny1V43QuW3iccNCvLbgvdVrQiubJ
         j71w==
X-Gm-Message-State: AOAM53014DDhp7WtKtwl/vIiSmqKsuEnLXKVNfdZaxkp3RtAjAKD71tj
        WpUh91d0svk3sWMKg6OBnrz0JrZByt5LLx0loYHA1R6YRHJb
X-Google-Smtp-Source: ABdhPJwjExny7u/hKTYAZ8j2/3MBwJ7OmePQ9gJZ+yu6LVU/yD0FZToysK+YsZWX2eREUDBAfRwOH4NNmSdjgH2lP5/tagQ/uNEH
MIME-Version: 1.0
X-Received: by 2002:a92:c52e:: with SMTP id m14mr19009ili.257.1628369408835;
 Sat, 07 Aug 2021 13:50:08 -0700 (PDT)
Date:   Sat, 07 Aug 2021 13:50:08 -0700
In-Reply-To: <000000000000b720b705c8f8599f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d477205c8fe4ccd@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
From:   syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 65038428b2c6c5be79d3f78a6b79c0cdc3a58a41
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Mar 17 13:13:46 2020 +0000

    netfilter: nf_tables: allow to specify stateful expression in set definition

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1145a881300000
start commit:   894d6f401b21 Merge tag 'spi-fix-v5.14-rc4' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1345a881300000
console output: https://syzkaller.appspot.com/x/log.txt?x=1545a881300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=649e339fa6658ee623d3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110319aa300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1142fac9d00000

Reported-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
