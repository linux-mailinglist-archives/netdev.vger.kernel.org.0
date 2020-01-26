Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60FC149B60
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgAZPZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:25:03 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:35822 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgAZPZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:25:02 -0500
Received: by mail-il1-f199.google.com with SMTP id h18so5770141ilc.2
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 07:25:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RjRY8jb+5UI6pjP3QDbg06fxukj7aEOy3CbF/dNamkc=;
        b=HSYJADeh7WFCyNOmo43q9EuCNiU90UtwEabH3UsWdVJbeJeKXtvWkrU58o25toPfca
         iAqVWL4+VFMKEFT61Em8PtxAjh5vAZ/SXLzPlFGdC5NWyXiBIs7KLdeiXo67GMEboJcC
         5V3Tk5xpVl9pKwW92V+1zKFSmmjKV9UD1ASpHYBCWGJVy9y0kcXqKe2CMNhdLWaOl6Ha
         dikgpFKXtTGE1piTld8Gqlpp57MYtpcPjrt64imqLkuTatRaV8z62l4C5/GcRR7IwhIA
         KzFeGwckWaJX55kbK/s9O9doqzQY2PJTqfVRmnLv5vFkpX4G+0hm60LjUSkHGmDwTbFO
         dVJA==
X-Gm-Message-State: APjAAAXVc88tCgw/eAoJOjYGiVYtwP3beqB1jyqs8htTPJxgssxtwADR
        bhogZkC6Y7CeXgoMao5SyRRQal+DkSWpqcb5Jn+oLuaJvYfH
X-Google-Smtp-Source: APXvYqxx8mMeFFgL/ZBVyqZz9kOD/SiLe3QSxztT5lA5/Xu2sGr9dWlclDW5GVH4eU2r0rYEIZFk2fSbaf1Mo91+scqt7ZMxnXOr
MIME-Version: 1.0
X-Received: by 2002:a6b:600f:: with SMTP id r15mr9168784iog.54.1580052302010;
 Sun, 26 Jan 2020 07:25:02 -0800 (PST)
Date:   Sun, 26 Jan 2020 07:25:02 -0800
In-Reply-To: <0000000000003cf909059a69fe9a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003021ea059d0c98b4@google.com>
Subject: Re: INFO: rcu detected stall in addrconf_rs_timer (3)
From:   syzbot <syzbot+c22c6b9dce8e773ddcb6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit d9e15a2733067c9328fb56d98fe8e574fa19ec31
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon Jan 6 14:10:39 2020 +0000

    pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1625d479e00000
start commit:   a1ec57c0 net: stmmac: tc: Fix TAPRIO division operation
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=7159d94cd4de714e
dashboard link: https://syzkaller.appspot.com/bug?extid=c22c6b9dce8e773ddcb6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168e33b6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178c160ae00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
